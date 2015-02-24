From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 5/9] nilfs2: add simple tracking of block deletions and updates
Date: Tue, 24 Feb 2015 20:01:40 +0100
Message-ID: <1424804504-10914-6-git-send-email-andreas.rohner@gmx.net>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424804504-10914-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch adds simple tracking of block deletions and updates for
all files except the DAT- and the SUFILE-Metadatafiles. It uses the
fact, that for every block, NILFS2 keeps an entry in the DAT-File
and stores the checkpoint where it was created and deleted or
overwritten. So whenever a block is deleted or overwritten
nilfs_dat_commit_end() is called to update the DAT-Entry. At this
point this patch simply decrements the su_nlive_blks field of the
corresponding segment. The value of su_nlive_blks is set at segment
creation time.

The blocks of the DAT-File cannot be counted this way, because it
does not contain any entries about itself, so the function
nilfs_dat_commit_end() is not called when its blocks are deleted or
overwritten.

The SUFILE cannot be counted this way, because it would lead to a
deadlock. When nilfs_dat_commit_end() is called, the bmap->b_sem is
held by code way up the call chain. To decrement the SUFILE entry
the same semaphore has to be aquired. So if the DAT-Entry belongs to
the SUFILE both semaphores are the same and a deadlock will occur.
But it works for any other file. So by excluding the SUFILE from
being counted by the extra parameter count_blocks a deadlock can be
avoided.

With the above changes the code does not pass the lock dependency
checks of the kernel, because all the locks have the same class and
the order in which the locks are taken is different. Usually it is:

1. down_write(&NILFS_MDT(sufile)->mi_sem);
2. down_write(&bmap->b_sem);

Now it can also be reversed, which leads to failed checks:

1. down_write(&bmap->b_sem); /* lock of a file other than SUFILE */
2. down_write(&NILFS_MDT(sufile)->mi_sem);

But this is safe as long as the first lock down_write(&bmap->b_sem)
doesn't belong to the SUFILE.

It is also possible, that two bmap->b_sem locks have to be taken at
the same time:

1. down_write(&bmap->b_sem); /* lock of a file other than SUFILE */
2. down_write(&bmap->b_sem); /* lock of SUFILE */

Since bmap->b_sem of normal files and the bmap->b_sem of the
SUFILE have the same lock class, the above behavior would also lead
to a warning.

Because of this, it is necessary to introduce two new lock classes
for the SUFILE. So the bmap->b_sem of the SUFILE gets its own lock
class and the NILFS_MDT(sufile)->mi_sem as well.

A new feature compatibility flag
NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS was added, so that the new
features introduced by this patch can be enabled or disabled at any
time.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/bmap.c          |  8 +++++++-
 fs/nilfs2/bmap.h          |  5 +++--
 fs/nilfs2/btree.c         |  4 +++-
 fs/nilfs2/dat.c           | 25 ++++++++++++++++++++-----
 fs/nilfs2/dat.h           |  7 +++++--
 fs/nilfs2/direct.c        |  4 +++-
 fs/nilfs2/mdt.c           |  5 ++++-
 fs/nilfs2/segbuf.c        |  1 +
 fs/nilfs2/segbuf.h        |  1 +
 fs/nilfs2/segment.c       | 25 +++++++++++++++++++++----
 fs/nilfs2/the_nilfs.c     |  4 ++++
 fs/nilfs2/the_nilfs.h     | 16 ++++++++++++++++
 include/linux/nilfs2_fs.h |  4 +++-
 13 files changed, 91 insertions(+), 18 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index aadbd0b..ecd62ba 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -467,6 +467,7 @@ __u64 nilfs_bmap_find_target_in_group(const struct nilfs_bmap *bmap)
 
 static struct lock_class_key nilfs_bmap_dat_lock_key;
 static struct lock_class_key nilfs_bmap_mdt_lock_key;
+static struct lock_class_key nilfs_bmap_sufile_lock_key;
 
 /**
  * nilfs_bmap_read - read a bmap from an inode
@@ -498,12 +499,17 @@ int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 		lockdep_set_class(&bmap->b_sem, &nilfs_bmap_dat_lock_key);
 		break;
 	case NILFS_CPFILE_INO:
-	case NILFS_SUFILE_INO:
 		bmap->b_ptr_type = NILFS_BMAP_PTR_VS;
 		bmap->b_last_allocated_key = 0;
 		bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
 		lockdep_set_class(&bmap->b_sem, &nilfs_bmap_mdt_lock_key);
 		break;
+	case NILFS_SUFILE_INO:
+		bmap->b_ptr_type = NILFS_BMAP_PTR_VS;
+		bmap->b_last_allocated_key = 0;
+		bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
+		lockdep_set_class(&bmap->b_sem, &nilfs_bmap_sufile_lock_key);
+		break;
 	case NILFS_IFILE_INO:
 		lockdep_set_class(&bmap->b_sem, &nilfs_bmap_mdt_lock_key);
 		/* Fall through */
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index b89e680..718c814 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -222,8 +222,9 @@ static inline void nilfs_bmap_commit_end_ptr(struct nilfs_bmap *bmap,
 					     struct inode *dat)
 {
 	if (dat)
-		nilfs_dat_commit_end(dat, &req->bpr_req,
-				     bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
+		nilfs_dat_commit_end(dat, &req->bpr_req, NULL,
+				     bmap->b_ptr_type == NILFS_BMAP_PTR_VS,
+				     bmap->b_inode->i_ino != NILFS_SUFILE_INO);
 }
 
 static inline void nilfs_bmap_abort_end_ptr(struct nilfs_bmap *bmap,
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index b2e3ff3..2af0519 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1851,7 +1851,9 @@ static void nilfs_btree_commit_update_v(struct nilfs_bmap *btree,
 
 	nilfs_dat_commit_update(dat, &path[level].bp_oldreq.bpr_req,
 				&path[level].bp_newreq.bpr_req,
-				btree->b_ptr_type == NILFS_BMAP_PTR_VS);
+				NULL,
+				btree->b_ptr_type == NILFS_BMAP_PTR_VS,
+				btree->b_inode->i_ino != NILFS_SUFILE_INO);
 
 	if (buffer_nilfs_node(path[level].bp_bh)) {
 		nilfs_btnode_commit_change_key(
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 0d5fada..d2c8f7e 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -28,6 +28,7 @@
 #include "mdt.h"
 #include "alloc.h"
 #include "dat.h"
+#include "sufile.h"
 
 
 #define NILFS_CNO_MIN	((__u64)1)
@@ -185,12 +186,14 @@ int nilfs_dat_prepare_end(struct inode *dat, struct nilfs_palloc_req *req)
 }
 
 void nilfs_dat_commit_end(struct inode *dat, struct nilfs_palloc_req *req,
-			  int dead)
+			  struct nilfs_sufile_mod_cache *mc,
+			  int dead, int count_blocks)
 {
 	struct nilfs_dat_entry *entry;
-	__u64 start, end;
+	__u64 start, end, segnum;
 	sector_t blocknr;
 	void *kaddr;
+	struct the_nilfs *nilfs;
 
 	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
@@ -206,8 +209,18 @@ void nilfs_dat_commit_end(struct inode *dat, struct nilfs_palloc_req *req,
 
 	if (blocknr == 0)
 		nilfs_dat_commit_free(dat, req);
-	else
+	else {
 		nilfs_dat_commit_entry(dat, req);
+
+		nilfs = dat->i_sb->s_fs_info;
+
+		if (count_blocks && nilfs_feature_track_live_blks(nilfs)) {
+			segnum = nilfs_get_segnum_of_block(nilfs, blocknr);
+
+			nilfs_sufile_mod_nlive_blks(nilfs->ns_sufile, mc,
+						    segnum, -1);
+		}
+	}
 }
 
 void nilfs_dat_abort_end(struct inode *dat, struct nilfs_palloc_req *req)
@@ -246,9 +259,11 @@ int nilfs_dat_prepare_update(struct inode *dat,
 
 void nilfs_dat_commit_update(struct inode *dat,
 			     struct nilfs_palloc_req *oldreq,
-			     struct nilfs_palloc_req *newreq, int dead)
+			     struct nilfs_palloc_req *newreq,
+			     struct nilfs_sufile_mod_cache *mc,
+			     int dead, int count_blocks)
 {
-	nilfs_dat_commit_end(dat, oldreq, dead);
+	nilfs_dat_commit_end(dat, oldreq, mc, dead, count_blocks);
 	nilfs_dat_commit_alloc(dat, newreq);
 }
 
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index cbd8e97..d196f09 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -29,6 +29,7 @@
 
 
 struct nilfs_palloc_req;
+struct nilfs_sufile_mod_cache;
 
 int nilfs_dat_translate(struct inode *, __u64, sector_t *);
 
@@ -39,12 +40,14 @@ int nilfs_dat_prepare_start(struct inode *, struct nilfs_palloc_req *);
 void nilfs_dat_commit_start(struct inode *, struct nilfs_palloc_req *,
 			    sector_t);
 int nilfs_dat_prepare_end(struct inode *, struct nilfs_palloc_req *);
-void nilfs_dat_commit_end(struct inode *, struct nilfs_palloc_req *, int);
+void nilfs_dat_commit_end(struct inode *, struct nilfs_palloc_req *,
+			  struct nilfs_sufile_mod_cache *, int, int);
 void nilfs_dat_abort_end(struct inode *, struct nilfs_palloc_req *);
 int nilfs_dat_prepare_update(struct inode *, struct nilfs_palloc_req *,
 			     struct nilfs_palloc_req *);
 void nilfs_dat_commit_update(struct inode *, struct nilfs_palloc_req *,
-			     struct nilfs_palloc_req *, int);
+			     struct nilfs_palloc_req *,
+			     struct nilfs_sufile_mod_cache *, int, int);
 void nilfs_dat_abort_update(struct inode *, struct nilfs_palloc_req *,
 			    struct nilfs_palloc_req *);
 
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 82f4865..e022cfb 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -272,7 +272,9 @@ static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 		if (ret < 0)
 			return ret;
 		nilfs_dat_commit_update(dat, &oldreq, &newreq,
-					bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
+				NULL,
+				bmap->b_ptr_type == NILFS_BMAP_PTR_VS,
+				bmap->b_inode->i_ino != NILFS_SUFILE_INO);
 		set_buffer_nilfs_volatile(bh);
 		nilfs_direct_set_ptr(bmap, key, newreq.pr_entry_nr);
 	} else
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 892cf5f..2a81f82 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -414,7 +414,7 @@ static const struct address_space_operations def_mdt_aops = {
 
 static const struct inode_operations def_mdt_iops;
 static const struct file_operations def_mdt_fops;
-
+static struct lock_class_key nilfs_mdt_mi_sufile_lock_key;
 
 int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz)
 {
@@ -427,6 +427,9 @@ int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz)
 	init_rwsem(&mi->mi_sem);
 	inode->i_private = mi;
 
+	if (inode->i_ino == NILFS_SUFILE_INO)
+		lockdep_set_class(&mi->mi_sem, &nilfs_mdt_mi_sufile_lock_key);
+
 	inode->i_mode = S_IFREG;
 	mapping_set_gfp_mask(inode->i_mapping, gfp_mask);
 
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index dc3a9efd..7a6e9cd 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -57,6 +57,7 @@ struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *sb)
 	INIT_LIST_HEAD(&segbuf->sb_segsum_buffers);
 	INIT_LIST_HEAD(&segbuf->sb_payload_buffers);
 	segbuf->sb_super_root = NULL;
+	segbuf->sb_nlive_blks_added = 0;
 
 	init_completion(&segbuf->sb_bio_event);
 	atomic_set(&segbuf->sb_err, 0);
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index b04f08c..d04da26 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -83,6 +83,7 @@ struct nilfs_segment_buffer {
 	sector_t		sb_fseg_start, sb_fseg_end;
 	sector_t		sb_pseg_start;
 	unsigned		sb_rest_blocks;
+	__u32			sb_nlive_blks_added;
 
 	/* Buffers */
 	struct list_head	sb_segsum_buffers;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 469086b..6059f53 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1367,9 +1367,10 @@ static void nilfs_free_incomplete_logs(struct list_head *logs,
 }
 
 static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
-					  struct inode *sufile)
+					  struct the_nilfs *nilfs)
 {
 	struct nilfs_segment_buffer *segbuf;
+	struct inode *sufile = nilfs->ns_sufile;
 	unsigned long live_blocks;
 	int ret;
 
@@ -1380,12 +1381,22 @@ static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
 						     live_blocks,
 						     sci->sc_seg_ctime);
 		WARN_ON(ret); /* always succeed because the segusage is dirty */
+
+		/* should always be positive */
+		segbuf->sb_nlive_blks_added = segbuf->sb_sum.nfileblk;
+
+		if (nilfs_feature_track_live_blks(nilfs))
+			nilfs_sufile_mod_nlive_blks(sufile, NULL,
+						segbuf->sb_segnum,
+						segbuf->sb_nlive_blks_added);
 	}
 }
 
-static void nilfs_cancel_segusage(struct list_head *logs, struct inode *sufile)
+static void nilfs_cancel_segusage(struct list_head *logs,
+				  struct the_nilfs *nilfs)
 {
 	struct nilfs_segment_buffer *segbuf;
+	struct inode *sufile = nilfs->ns_sufile;
 	int ret;
 
 	segbuf = NILFS_FIRST_SEGBUF(logs);
@@ -1394,6 +1405,12 @@ static void nilfs_cancel_segusage(struct list_head *logs, struct inode *sufile)
 					     segbuf->sb_fseg_start, 0);
 	WARN_ON(ret); /* always succeed because the segusage is dirty */
 
+	if (nilfs_feature_track_live_blks(nilfs))
+		nilfs_sufile_mod_nlive_blks(sufile, NULL, segbuf->sb_segnum,
+					-((__s64)segbuf->sb_nlive_blks_added));
+
+	segbuf->sb_nlive_blks_added = 0;
+
 	list_for_each_entry_continue(segbuf, logs, sb_list) {
 		ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
 						     0, 0);
@@ -1729,7 +1746,7 @@ static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
 	nilfs_abort_logs(&logs, ret ? : err);
 
 	list_splice_tail_init(&sci->sc_segbufs, &logs);
-	nilfs_cancel_segusage(&logs, nilfs->ns_sufile);
+	nilfs_cancel_segusage(&logs, nilfs);
 	nilfs_free_incomplete_logs(&logs, nilfs);
 
 	if (sci->sc_stage.flags & NILFS_CF_SUFREED) {
@@ -1995,7 +2012,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 
 			nilfs_segctor_fill_in_super_root(sci, nilfs);
 		}
-		nilfs_segctor_update_segusage(sci, nilfs->ns_sufile);
+		nilfs_segctor_update_segusage(sci, nilfs);
 
 		/* Write partial segments */
 		nilfs_segctor_prepare_write(sci);
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 69bd801..606fdfc 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -630,6 +630,10 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	get_random_bytes(&nilfs->ns_next_generation,
 			 sizeof(nilfs->ns_next_generation));
 
+	nilfs->ns_feature_compat = le64_to_cpu(sbp->s_feature_compat);
+	nilfs->ns_feature_compat_ro = le64_to_cpu(sbp->s_feature_compat_ro);
+	nilfs->ns_feature_incompat = le64_to_cpu(sbp->s_feature_incompat);
+
 	err = nilfs_store_disk_layout(nilfs, sbp);
 	if (err)
 		goto failed_sbh;
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 23778d3..87cab10 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -101,6 +101,9 @@ enum {
  * @ns_dev_kobj: /sys/fs/<nilfs>/<device>
  * @ns_dev_kobj_unregister: completion state
  * @ns_dev_subgroups: <device> subgroups pointer
+ * @ns_feature_compat: Compatible feature set
+ * @ns_feature_compat_ro: Read-only compatible feature set
+ * @ns_feature_incompat: Incompatible feature set
  */
 struct the_nilfs {
 	unsigned long		ns_flags;
@@ -201,6 +204,11 @@ struct the_nilfs {
 	struct kobject ns_dev_kobj;
 	struct completion ns_dev_kobj_unregister;
 	struct nilfs_sysfs_dev_subgroups *ns_dev_subgroups;
+
+	/* Features */
+	__u64			ns_feature_compat;
+	__u64			ns_feature_compat_ro;
+	__u64			ns_feature_incompat;
 };
 
 #define THE_NILFS_FNS(bit, name)					\
@@ -393,4 +401,12 @@ static inline int nilfs_flush_device(struct the_nilfs *nilfs)
 	return err;
 }
 
+static inline int nilfs_feature_track_live_blks(struct the_nilfs *nilfs)
+{
+	return (nilfs->ns_feature_compat &
+		NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS) &&
+		(nilfs->ns_feature_compat &
+		NILFS_FEATURE_COMPAT_SUFILE_EXTENSION);
+}
+
 #endif /* _THE_NILFS_H */
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 5d83c55..6ccb2ad 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -221,10 +221,12 @@ struct nilfs_super_block {
  * doesn't know about, it should refuse to mount the filesystem.
  */
 #define NILFS_FEATURE_COMPAT_SUFILE_EXTENSION		(1ULL << 0)
+#define NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS		(1ULL << 1)
 
 #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT		(1ULL << 0)
 
-#define NILFS_FEATURE_COMPAT_SUPP	NILFS_FEATURE_COMPAT_SUFILE_EXTENSION
+#define NILFS_FEATURE_COMPAT_SUPP	(NILFS_FEATURE_COMPAT_SUFILE_EXTENSION \
+				| NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS)
 #define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
 #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
 
-- 
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
