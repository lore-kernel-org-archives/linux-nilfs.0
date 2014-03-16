From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 6/6] nilfs2: add counting of live blocks for deleted files
Date: Sun, 16 Mar 2014 11:47:39 +0100
Message-ID: <403de4d405baf2c1ec40c16474ac457a78a0b2bd.1394966730.git.andreas.rohner@gmx.net>
References: <cover.1394966728.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1394966728.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1394966728.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1394966728.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

If a file is deleted, then the entries of its blocks in the DAT-File
need to be updated. So everytime a file is deleted
nilfs_dat_commit_end() is called for every block to set de_end to the
current checkpoint number. So it is the perfect hook to insert logic
that counts live blocks. If the file is deleted, then the blocks are
reclaimable and the number of live blocks for the corresponding
segments must be decremented. This patch adds code to
nilfs_dat_commit_end() that decrements the number of live blocks under
certain conditions.

One condition is, that the block must not belong to the SUFILE, because
that would lead to a deadlock. When nilfs_dat_commit_end() is called the
bmaps b_sem is already held, but nilfs_sufile_add_segment_usage() has to
lock that same lock for the SUFILE, to decrement the number of live
blocks. Secondly the blocks must only be counted if
nilfs_dat_commit_end() is called from a file deletion operation,
because overwritten blocks are already counted somewhere else.

With the above changes the code does not pass the lock dependency
checks, because all the locks have the same class and the order in which
the locks are taken is different. Usually it is:

1. down_write(&NILFS_MDT(sufile)->mi_sem);
2. down_write(&bmap->b_sem);

Now it can also be reversed, which leads to failed checks:

1. down_write(&bmap->b_sem); /* lock of a file other than SUFILE */
2. down_write(&NILFS_MDT(sufile)->mi_sem);

But this is safe as long as the first lock down_write(&bmap->b_sem)
doesn't belong to the SUFILE. So the warnings can be resolved, by adding
an extra lock class for the SUFILE and the code is safe, because the
SUFILE is excluded from being counted.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/bmap.c   |  8 +++++++-
 fs/nilfs2/bmap.h   |  2 +-
 fs/nilfs2/btree.c  |  3 ++-
 fs/nilfs2/dat.c    | 18 ++++++++++++++----
 fs/nilfs2/dat.h    |  4 ++--
 fs/nilfs2/direct.c |  3 ++-
 fs/nilfs2/mdt.c    |  5 ++++-
 7 files changed, 32 insertions(+), 11 deletions(-)

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
index b89e680..f09009c 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -223,7 +223,7 @@ static inline void nilfs_bmap_commit_end_ptr(struct nilfs_bmap *bmap,
 {
 	if (dat)
 		nilfs_dat_commit_end(dat, &req->bpr_req,
-				     bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
+				     bmap->b_ptr_type == NILFS_BMAP_PTR_VS, 1);
 }
 
 static inline void nilfs_bmap_abort_end_ptr(struct nilfs_bmap *bmap,
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index b2e3ff3..7365cb4 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1851,7 +1851,8 @@ static void nilfs_btree_commit_update_v(struct nilfs_bmap *btree,
 
 	nilfs_dat_commit_update(dat, &path[level].bp_oldreq.bpr_req,
 				&path[level].bp_newreq.bpr_req,
-				btree->b_ptr_type == NILFS_BMAP_PTR_VS);
+				btree->b_ptr_type == NILFS_BMAP_PTR_VS,
+				buffer_nilfs_node(path[level].bp_bh));
 
 	if (buffer_nilfs_node(path[level].bp_bh)) {
 		nilfs_btnode_commit_change_key(
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index e7b19c40..f465cbf 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -188,12 +188,13 @@ int nilfs_dat_prepare_end(struct inode *dat, struct nilfs_palloc_req *req)
 }
 
 void nilfs_dat_commit_end(struct inode *dat, struct nilfs_palloc_req *req,
-			  int dead)
+			  int dead, int count_blocks)
 {
 	struct nilfs_dat_entry *entry;
 	__u64 start, end;
 	sector_t blocknr;
 	void *kaddr;
+	struct the_nilfs *nilfs;
 
 	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
@@ -210,8 +211,16 @@ void nilfs_dat_commit_end(struct inode *dat, struct nilfs_palloc_req *req,
 
 	if (blocknr == 0)
 		nilfs_dat_commit_free(dat, req);
-	else
+	else {
 		nilfs_dat_commit_entry(dat, req);
+
+		if (!dead && count_blocks) {
+			nilfs =  dat->i_sb->s_fs_info;
+			nilfs_sufile_add_segment_usage(nilfs->ns_sufile,
+				nilfs_get_segnum_of_block(nilfs, blocknr), -1,
+				nilfs->ns_ctime);
+		}
+	}
 }
 
 void nilfs_dat_abort_end(struct inode *dat, struct nilfs_palloc_req *req)
@@ -250,9 +259,10 @@ int nilfs_dat_prepare_update(struct inode *dat,
 
 void nilfs_dat_commit_update(struct inode *dat,
 			     struct nilfs_palloc_req *oldreq,
-			     struct nilfs_palloc_req *newreq, int dead)
+			     struct nilfs_palloc_req *newreq,
+			     int dead, int count_blocks)
 {
-	nilfs_dat_commit_end(dat, oldreq, dead);
+	nilfs_dat_commit_end(dat, oldreq, dead, count_blocks);
 	nilfs_dat_commit_alloc(dat, newreq);
 }
 
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index 51d44c0..3dc8de8 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -40,12 +40,12 @@ int nilfs_dat_prepare_start(struct inode *, struct nilfs_palloc_req *);
 void nilfs_dat_commit_start(struct inode *, struct nilfs_palloc_req *,
 			    sector_t);
 int nilfs_dat_prepare_end(struct inode *, struct nilfs_palloc_req *);
-void nilfs_dat_commit_end(struct inode *, struct nilfs_palloc_req *, int);
+void nilfs_dat_commit_end(struct inode *, struct nilfs_palloc_req *, int, int);
 void nilfs_dat_abort_end(struct inode *, struct nilfs_palloc_req *);
 int nilfs_dat_prepare_update(struct inode *, struct nilfs_palloc_req *,
 			     struct nilfs_palloc_req *);
 void nilfs_dat_commit_update(struct inode *, struct nilfs_palloc_req *,
-			     struct nilfs_palloc_req *, int);
+			     struct nilfs_palloc_req *, int, int);
 void nilfs_dat_abort_update(struct inode *, struct nilfs_palloc_req *,
 			    struct nilfs_palloc_req *);
 
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 82f4865..c432484 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -272,7 +272,8 @@ static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 		if (ret < 0)
 			return ret;
 		nilfs_dat_commit_update(dat, &oldreq, &newreq,
-					bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
+					bmap->b_ptr_type == NILFS_BMAP_PTR_VS,
+					0);
 		set_buffer_nilfs_volatile(bh);
 		nilfs_direct_set_ptr(bmap, key, newreq.pr_entry_nr);
 	} else
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index c4dcd1d..1aa3cc5 100644
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
 	inode->i_mapping->backing_dev_info = inode->i_sb->s_bdi;
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
