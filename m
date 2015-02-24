From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 9/9] nilfs2: prevent starvation of segments protected by snapshots
Date: Tue, 24 Feb 2015 20:01:44 +0100
Message-ID: <1424804504-10914-10-git-send-email-andreas.rohner@gmx.net>
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

It doesn't really matter if the number of reclaimable blocks for a
segment is inaccurate, as long as the overall performance is better than
the simple timestamp algorithm and starvation is prevented.

The following steps will lead to starvation of a segment:

1. The segment is written
2. A snapshot is created
3. The files in the segment are deleted and the number of live
   blocks for the segment is decremented to a very low value
4. The GC tries to free the segment, but there are no reclaimable
   blocks, because they are all protected by the snapshot. To prevent an
   infinite loop the GC has to adjust the number of live blocks to the
   correct value.
5. The snapshot is converted to a checkpoint and the blocks in the
   segment are now reclaimable.
6. The GC will never attemt to clean the segment again, because of it
   incorrectly shows up as having a high number of live blocks.

To prevent this, the already existing padding field of the SUFILE entry
is used to track the number of snapshot blocks in the segment. This
number is only set by the GC, since it collects the necessary
information anyway. So there is no need, to track which block belongs to
which segment. In step 4 of the list above the GC will set the new field
su_nsnapshot_blks. In step 5 all entries in the SUFILE are checked and
entries with a big su_nsnapshot_blks field get their su_nlive_blks field
reduced.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/cpfile.c        |   5 ++
 fs/nilfs2/segbuf.c        |   1 +
 fs/nilfs2/segbuf.h        |   1 +
 fs/nilfs2/segment.c       |   7 ++-
 fs/nilfs2/sufile.c        | 114 ++++++++++++++++++++++++++++++++++++++++++----
 fs/nilfs2/sufile.h        |   4 +-
 fs/nilfs2/the_nilfs.h     |   7 +++
 include/linux/nilfs2_fs.h |  12 +++--
 8 files changed, 136 insertions(+), 15 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 0d58075..6b61fd7 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -28,6 +28,7 @@
 #include <linux/nilfs2_fs.h>
 #include "mdt.h"
 #include "cpfile.h"
+#include "sufile.h"
 
 
 static inline unsigned long
@@ -703,6 +704,7 @@ static int nilfs_cpfile_clear_snapshot(struct inode *cpfile, __u64 cno)
 	struct nilfs_cpfile_header *header;
 	struct nilfs_checkpoint *cp;
 	struct nilfs_snapshot_list *list;
+	struct the_nilfs *nilfs = cpfile->i_sb->s_fs_info;
 	__u64 next, prev;
 	void *kaddr;
 	int ret;
@@ -784,6 +786,9 @@ static int nilfs_cpfile_clear_snapshot(struct inode *cpfile, __u64 cno)
 	mark_buffer_dirty(header_bh);
 	nilfs_mdt_mark_dirty(cpfile);
 
+	if (nilfs_feature_track_snapshots(nilfs))
+		nilfs_sufile_fix_starving_segs(nilfs->ns_sufile);
+
 	brelse(prev_bh);
 
  out_next:
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index bbd807b..a98c576 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -59,6 +59,7 @@ struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *sb)
 	segbuf->sb_super_root = NULL;
 	segbuf->sb_nlive_blks_added = 0;
 	segbuf->sb_nlive_blks_diff = 0;
+	segbuf->sb_nsnapshot_blks = 0;
 
 	init_completion(&segbuf->sb_bio_event);
 	atomic_set(&segbuf->sb_err, 0);
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index 4e994f7..7a462c4 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -85,6 +85,7 @@ struct nilfs_segment_buffer {
 	unsigned		sb_rest_blocks;
 	__u32			sb_nlive_blks_added;
 	__s64			sb_nlive_blks_diff;
+	__u32			sb_nsnapshot_blks;
 
 	/* Buffers */
 	struct list_head	sb_segsum_buffers;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 16c7c36..b976198 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1381,6 +1381,7 @@ static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
 			(segbuf->sb_pseg_start - segbuf->sb_fseg_start);
 		ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
 						     live_blocks,
+						     segbuf->sb_nsnapshot_blks,
 						     sci->sc_seg_ctime);
 		WARN_ON(ret); /* always succeed because the segusage is dirty */
 
@@ -1405,7 +1406,7 @@ static void nilfs_cancel_segusage(struct list_head *logs,
 	segbuf = NILFS_FIRST_SEGBUF(logs);
 	ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
 					     segbuf->sb_pseg_start -
-					     segbuf->sb_fseg_start, 0);
+					     segbuf->sb_fseg_start, 0, 0);
 	WARN_ON(ret); /* always succeed because the segusage is dirty */
 
 	if (nilfs_feature_track_live_blks(nilfs))
@@ -1416,7 +1417,7 @@ static void nilfs_cancel_segusage(struct list_head *logs,
 
 	list_for_each_entry_continue(segbuf, logs, sb_list) {
 		ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
-						     0, 0);
+						     0, 0, 0);
 		WARN_ON(ret); /* always succeed */
 	}
 }
@@ -1521,6 +1522,8 @@ static void nilfs_segctor_dec_nlive_blks_gc(struct inode *dat,
 
 	if (!buffer_nilfs_snapshot(bh) && isreclaimable)
 		segbuf->sb_nlive_blks_diff--;
+	if (buffer_nilfs_snapshot(bh))
+		segbuf->sb_nsnapshot_blks++;
 }
 
 /**
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 574a77e..a6dc7bf 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -468,7 +468,7 @@ void nilfs_sufile_do_scrap(struct inode *sufile, __u64 *data,
 	su->su_flags = cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY);
 	if (nilfs_sufile_ext_supported(sufile)) {
 		su->su_nlive_blks = cpu_to_le32(0);
-		su->su_pad = cpu_to_le32(0);
+		su->su_nsnapshot_blks = cpu_to_le32(0);
 		su->su_nlive_lastmod = cpu_to_le64(0);
 	}
 	kunmap_atomic(kaddr);
@@ -538,7 +538,8 @@ int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
  * @modtime: modification time (option)
  */
 int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
-				   unsigned long nblocks, time_t modtime)
+				   unsigned long nblocks, __u32 nsnapshot_blks,
+				   time_t modtime)
 {
 	struct buffer_head *bh;
 	struct nilfs_segment_usage *su;
@@ -556,9 +557,18 @@ int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
 	if (modtime)
 		su->su_lastmod = cpu_to_le64(modtime);
 	su->su_nblocks = cpu_to_le32(nblocks);
-	if (nilfs_sufile_ext_supported(sufile) &&
-	    nblocks < le32_to_cpu(su->su_nlive_blks))
-		su->su_nlive_blks = su->su_nblocks;
+	if (nilfs_sufile_ext_supported(sufile)) {
+		if (nblocks < le32_to_cpu(su->su_nlive_blks))
+			su->su_nlive_blks = su->su_nblocks;
+
+		nsnapshot_blks += le32_to_cpu(su->su_nsnapshot_blks);
+
+		if (nblocks < nsnapshot_blks)
+			nsnapshot_blks = nblocks;
+
+		su->su_nsnapshot_blks = cpu_to_le32(nsnapshot_blks);
+	}
+
 	kunmap_atomic(kaddr);
 
 	mark_buffer_dirty(bh);
@@ -891,7 +901,7 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 
 			if (sisz >= NILFS_EXT_SUINFO_SIZE) {
 				si->sui_nlive_blks = nlb;
-				si->sui_pad = 0;
+				si->sui_nsnapshot_blks = 0;
 				si->sui_nlive_lastmod = lm;
 			}
 		}
@@ -939,6 +949,7 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 	int ret = 0;
 	bool sup_ext = (supsz >= NILFS_EXT_SUINFO_UPDATE_SIZE);
 	bool su_ext = nilfs_sufile_ext_supported(sufile);
+	bool supsu_ext = sup_ext && su_ext;
 
 	if (unlikely(nsup == 0))
 		return ret;
@@ -952,6 +963,10 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 				nilfs->ns_blocks_per_segment)
 			|| (nilfs_suinfo_update_nlive_blks(sup) && sup_ext &&
 				sup->sup_sui.sui_nlive_blks >
+				nilfs->ns_blocks_per_segment)
+			|| (nilfs_suinfo_update_nsnapshot_blks(sup) &&
+				sup_ext &&
+				sup->sup_sui.sui_nsnapshot_blks >
 				nilfs->ns_blocks_per_segment))
 			return -EINVAL;
 	}
@@ -979,11 +994,15 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 		if (nilfs_suinfo_update_nblocks(sup))
 			su->su_nblocks = cpu_to_le32(sup->sup_sui.sui_nblocks);
 
-		if (nilfs_suinfo_update_nlive_blks(sup) && sup_ext && su_ext)
+		if (nilfs_suinfo_update_nlive_blks(sup) && supsu_ext)
 			su->su_nlive_blks =
 				cpu_to_le32(sup->sup_sui.sui_nlive_blks);
 
-		if (nilfs_suinfo_update_nlive_lastmod(sup) && sup_ext && su_ext)
+		if (nilfs_suinfo_update_nsnapshot_blks(sup) && supsu_ext)
+			su->su_nsnapshot_blks =
+				cpu_to_le32(sup->sup_sui.sui_nsnapshot_blks);
+
+		if (nilfs_suinfo_update_nlive_lastmod(sup) && supsu_ext)
 			su->su_nlive_lastmod =
 				cpu_to_le64(sup->sup_sui.sui_nlive_lastmod);
 
@@ -1050,6 +1069,85 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 }
 
 /**
+ * nilfs_sufile_fix_starving_segs - fix potentially starving segments
+ * @sufile: inode of segment usage file
+ *
+ * Description: Scans for segments, which are potentially starving and
+ * reduces the number of live blocks to less than half of the maximum
+ * number of blocks in a segment. This way the segment is more likely to be
+ * chosen by the GC. A segment is marked as potentially starving, if more
+ * than half of the blocks it contains are protected by snapshots.
+ *
+ * Return Value: On success, 0 is returned and on error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_sufile_fix_starving_segs(struct inode *sufile)
+{
+	struct buffer_head *su_bh;
+	struct nilfs_segment_usage *su;
+	size_t n, i, susz = NILFS_MDT(sufile)->mi_entry_size;
+	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
+	void *kaddr;
+	unsigned long nsegs, segusages_per_block;
+	__u32 max_segblks = nilfs->ns_blocks_per_segment / 2;
+	__u64 segnum = 0;
+	int ret = 0, blkdirty, dirty = 0;
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+
+	segusages_per_block = nilfs_sufile_segment_usages_per_block(sufile);
+	nsegs = nilfs_sufile_get_nsegments(sufile);
+
+	while (segnum < nsegs) {
+		n = nilfs_sufile_segment_usages_in_block(sufile, segnum,
+							 nsegs - 1);
+
+		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum,
+							   0, &su_bh);
+		if (ret < 0) {
+			if (ret != -ENOENT)
+				goto out;
+			/* hole */
+			segnum += n;
+			continue;
+		}
+
+		kaddr = kmap_atomic(su_bh->b_page);
+		su = nilfs_sufile_block_get_segment_usage(sufile, segnum,
+							  su_bh, kaddr);
+		blkdirty = 0;
+		for (i = 0; i < n; ++i, ++segnum, su = (void *)su + susz) {
+			if (le32_to_cpu(su->su_nsnapshot_blks) <= max_segblks)
+				continue;
+
+			if (su->su_nlive_blks <= max_segblks)
+				continue;
+
+			su->su_nlive_blks = max_segblks;
+			blkdirty = 1;
+		}
+
+		kunmap_atomic(kaddr);
+		if (blkdirty) {
+			mark_buffer_dirty(su_bh);
+			dirty = 1;
+		}
+		put_bh(su_bh);
+	}
+
+out:
+	if (dirty)
+		nilfs_mdt_mark_dirty(sufile);
+
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
+/**
  * nilfs_sufile_trim_fs() - trim ioctl handle function
  * @sufile: inode of segment usage file
  * @range: fstrim_range structure
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index ae3c52a..e831622 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -45,7 +45,8 @@ int nilfs_sufile_set_alloc_range(struct inode *sufile, __u64 start, __u64 end);
 int nilfs_sufile_alloc(struct inode *, __u64 *);
 int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum);
 int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
-				   unsigned long nblocks, time_t modtime);
+				   unsigned long nblocks, __u32 nsnapshot_blks,
+				   time_t modtime);
 int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
 ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
 				size_t);
@@ -72,6 +73,7 @@ int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs);
 int nilfs_sufile_read(struct super_block *sb, size_t susize,
 		      struct nilfs_inode *raw_inode, struct inode **inodep);
 int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range);
+int nilfs_sufile_fix_starving_segs(struct inode *);
 
 /**
  * nilfs_sufile_scrap - make a segment garbage
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 87cab10..3d495f1 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -409,4 +409,11 @@ static inline int nilfs_feature_track_live_blks(struct the_nilfs *nilfs)
 		NILFS_FEATURE_COMPAT_SUFILE_EXTENSION);
 }
 
+static inline int nilfs_feature_track_snapshots(struct the_nilfs *nilfs)
+{
+	return (nilfs->ns_feature_compat &
+		NILFS_FEATURE_COMPAT_TRACK_SNAPSHOTS) &&
+		nilfs_feature_track_live_blks(nilfs);
+}
+
 #endif /* _THE_NILFS_H */
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 6ffdc09..a3c7593 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -222,11 +222,13 @@ struct nilfs_super_block {
  */
 #define NILFS_FEATURE_COMPAT_SUFILE_EXTENSION		(1ULL << 0)
 #define NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS		(1ULL << 1)
+#define NILFS_FEATURE_COMPAT_TRACK_SNAPSHOTS		(1ULL << 2)
 
 #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT		(1ULL << 0)
 
 #define NILFS_FEATURE_COMPAT_SUPP	(NILFS_FEATURE_COMPAT_SUFILE_EXTENSION \
-				| NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS)
+				| NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS \
+				| NILFS_FEATURE_COMPAT_TRACK_SNAPSHOTS)
 #define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
 #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
 
@@ -630,7 +632,7 @@ struct nilfs_segment_usage {
 	__le32 su_nblocks;
 	__le32 su_flags;
 	__le32 su_nlive_blks;
-	__le32 su_pad;
+	__le32 su_nsnapshot_blks;
 	__le64 su_nlive_lastmod;
 };
 
@@ -682,7 +684,7 @@ nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su, size_t susz)
 	su->su_flags = cpu_to_le32(0);
 	if (susz >= NILFS_EXT_SEGMENT_USAGE_SIZE) {
 		su->su_nlive_blks = cpu_to_le32(0);
-		su->su_pad = cpu_to_le32(0);
+		su->su_nsnapshot_blks = cpu_to_le32(0);
 		su->su_nlive_lastmod = cpu_to_le64(0);
 	}
 }
@@ -723,7 +725,7 @@ struct nilfs_suinfo {
 	__u32 sui_nblocks;
 	__u32 sui_flags;
 	__u32 sui_nlive_blks;
-	__u32 sui_pad;
+	__u32 sui_nsnapshot_blks;
 	__u64 sui_nlive_lastmod;
 };
 
@@ -770,6 +772,7 @@ enum {
 	NILFS_SUINFO_UPDATE_FLAGS,
 	NILFS_SUINFO_UPDATE_NLIVE_BLKS,
 	NILFS_SUINFO_UPDATE_NLIVE_LASTMOD,
+	NILFS_SUINFO_UPDATE_NSNAPSHOT_BLKS,
 	__NR_NILFS_SUINFO_UPDATE_FIELDS,
 };
 
@@ -794,6 +797,7 @@ NILFS_SUINFO_UPDATE_FNS(LASTMOD, lastmod)
 NILFS_SUINFO_UPDATE_FNS(NBLOCKS, nblocks)
 NILFS_SUINFO_UPDATE_FNS(FLAGS, flags)
 NILFS_SUINFO_UPDATE_FNS(NLIVE_BLKS, nlive_blks)
+NILFS_SUINFO_UPDATE_FNS(NSNAPSHOT_BLKS, nsnapshot_blks)
 NILFS_SUINFO_UPDATE_FNS(NLIVE_LASTMOD, nlive_lastmod)
 
 #define NILFS_MIN_SUINFO_UPDATE_SIZE	\
-- 
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
