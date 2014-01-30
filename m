From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 1/1] nilfs2: add mount option that reduces super block writes
Date: Thu, 30 Jan 2014 03:47:00 +0100
Message-ID: <75ceb45c464097ab556baacf2d15d6ae4b792bb2.1391048231.git.andreas.rohner@gmx.net>
References: <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com>
 <cover.1391048231.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1391048231.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1391048231.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1391048231.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch introduces a mount option bad_ftl that disables the
periodic overwrites of the super block to make the file system better
suitable for bad flash memory with a bad FTL. The super block is only
written at umount time. So if there is a power outage the file system
needs to be recovered by a linear scan of all segment summary blocks.

The linear scan is only necessary if the file system wasn't umounted
properly. So the normal mount time is not affected.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/segbuf.c        |  3 ++-
 fs/nilfs2/segment.c       |  3 ++-
 fs/nilfs2/super.c         | 10 +++++++--
 fs/nilfs2/the_nilfs.c     | 54 ++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/nilfs2_fs.h |  4 +++-
 5 files changed, 66 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 2d8be51..4ea9dd6 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -158,6 +158,7 @@ void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *segbuf)
 {
 	struct nilfs_segment_summary *raw_sum;
 	struct buffer_head *bh_sum;
+	struct the_nilfs *nilfs = segbuf->sb_super->s_fs_info;
 
 	bh_sum = list_entry(segbuf->sb_segsum_buffers.next,
 			    struct buffer_head, b_assoc_buffers);
@@ -172,7 +173,7 @@ void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *segbuf)
 	raw_sum->ss_nblocks  = cpu_to_le32(segbuf->sb_sum.nblocks);
 	raw_sum->ss_nfinfo   = cpu_to_le32(segbuf->sb_sum.nfinfo);
 	raw_sum->ss_sumbytes = cpu_to_le32(segbuf->sb_sum.sumbytes);
-	raw_sum->ss_pad      = 0;
+	raw_sum->ss_crc_seed      = cpu_to_le32(nilfs->ns_crc_seed);
 	raw_sum->ss_cno      = cpu_to_le64(segbuf->sb_sum.cno);
 }
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index a1a1916..e8e38a9 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2288,7 +2288,8 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 		if (mode != SC_FLUSH_DAT)
 			atomic_set(&nilfs->ns_ndirtyblks, 0);
 		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
-		    nilfs_discontinued(nilfs)) {
+		    nilfs_discontinued(nilfs) &&
+		    !nilfs_test_opt(nilfs, BAD_FTL)) {
 			down_write(&nilfs->ns_sem);
 			err = -EIO;
 			sbp = nilfs_prepare_super(sci->sc_super,
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7ac2a12..c3374ed 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -505,7 +505,7 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 		err = nilfs_construct_segment(sb);
 
 	down_write(&nilfs->ns_sem);
-	if (nilfs_sb_dirty(nilfs)) {
+	if (nilfs_sb_dirty(nilfs) && !nilfs_test_opt(nilfs, BAD_FTL)) {
 		sbp = nilfs_prepare_super(sb, nilfs_sb_will_flip(nilfs));
 		if (likely(sbp)) {
 			nilfs_set_log_cursor(sbp[0], nilfs);
@@ -691,6 +691,8 @@ static int nilfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",norecovery");
 	if (nilfs_test_opt(nilfs, DISCARD))
 		seq_puts(seq, ",discard");
+	if (nilfs_test_opt(nilfs, BAD_FTL))
+		seq_puts(seq, ",bad_ftl");
 
 	return 0;
 }
@@ -712,7 +714,7 @@ static const struct super_operations nilfs_sops = {
 enum {
 	Opt_err_cont, Opt_err_panic, Opt_err_ro,
 	Opt_barrier, Opt_nobarrier, Opt_snapshot, Opt_order, Opt_norecovery,
-	Opt_discard, Opt_nodiscard, Opt_err,
+	Opt_discard, Opt_nodiscard, Opt_err, Opt_bad_ftl,
 };
 
 static match_table_t tokens = {
@@ -726,6 +728,7 @@ static match_table_t tokens = {
 	{Opt_norecovery, "norecovery"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
+	{Opt_bad_ftl, "bad_ftl"},
 	{Opt_err, NULL}
 };
 
@@ -787,6 +790,9 @@ static int parse_options(char *options, struct super_block *sb, int is_remount)
 		case Opt_nodiscard:
 			nilfs_clear_opt(nilfs, DISCARD);
 			break;
+		case Opt_bad_ftl:
+			nilfs_set_opt(nilfs, BAD_FTL);
+			break;
 		default:
 			printk(KERN_ERR
 			       "NILFS: Unrecognized mount option \"%s\"\n", p);
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 94c451c..d29b2f0 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -168,6 +168,50 @@ static void nilfs_clear_recovery_info(struct nilfs_recovery_info *ri)
 	nilfs_dispose_segment_list(&ri->ri_used_segments);
 }
 
+static int nilfs_search_log_cursor(struct the_nilfs *nilfs)
+{
+	u64 segnum;
+	struct buffer_head *bh_sum = NULL;
+	struct nilfs_segment_summary *sum;
+	sector_t seg_start, seg_end; /* range of full segment (block number) */
+
+	for (segnum = 0; segnum < nilfs->ns_nsegments; ++segnum) {
+		brelse(bh_sum);
+
+		/* Calculate range of segment */
+		nilfs_get_segment_range(nilfs, segnum, &seg_start, &seg_end);
+
+		bh_sum = __bread(nilfs->ns_bdev, seg_start,
+					nilfs->ns_blocksize);
+		if (!bh_sum) {
+			printk(KERN_ERR "NILFS error searching for cursor.\n");
+			return -EINVAL;
+		}
+
+		sum = (struct nilfs_segment_summary *)bh_sum->b_data;
+
+		/*
+		 * use ss_crc_seed to distinguish the segments from previous
+		 * nilfs2 file systems on the same volume
+		 */
+		if (le32_to_cpu(sum->ss_magic) != NILFS_SEGSUM_MAGIC
+			|| le32_to_cpu(sum->ss_nblocks) == 0
+			|| le32_to_cpu(sum->ss_nblocks) >
+				nilfs->ns_blocks_per_segment
+			|| le32_to_cpu(sum->ss_crc_seed) != nilfs->ns_crc_seed)
+			continue;
+
+		if (le64_to_cpu(sum->ss_seq) > nilfs->ns_last_seq) {
+			nilfs->ns_last_pseg = seg_start;
+			nilfs->ns_last_cno = le64_to_cpu(sum->ss_cno);
+			nilfs->ns_last_seq = le64_to_cpu(sum->ss_seq);
+		}
+	}
+	brelse(bh_sum);
+
+	return 0;
+}
+
 /**
  * nilfs_store_log_cursor - load log cursor from a super block
  * @nilfs: nilfs object
@@ -179,7 +223,7 @@ static void nilfs_clear_recovery_info(struct nilfs_recovery_info *ri)
  * scanning and recovery.
  */
 static int nilfs_store_log_cursor(struct the_nilfs *nilfs,
-				  struct nilfs_super_block *sbp)
+				  struct nilfs_super_block *sbp, int valid_fs)
 {
 	int ret = 0;
 
@@ -187,6 +231,9 @@ static int nilfs_store_log_cursor(struct the_nilfs *nilfs,
 	nilfs->ns_last_cno = le64_to_cpu(sbp->s_last_cno);
 	nilfs->ns_last_seq = le64_to_cpu(sbp->s_last_seq);
 
+	if (!valid_fs && nilfs_test_opt(nilfs, BAD_FTL))
+		ret = nilfs_search_log_cursor(nilfs);
+
 	nilfs->ns_prev_seq = nilfs->ns_last_seq;
 	nilfs->ns_seg_seq = nilfs->ns_last_seq;
 	nilfs->ns_segnum =
@@ -263,7 +310,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 			goto scan_error;
 		}
 
-		err = nilfs_store_log_cursor(nilfs, sbp[0]);
+		err = nilfs_store_log_cursor(nilfs, sbp[0], 1);
 		if (err)
 			goto scan_error;
 
@@ -626,7 +673,8 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 
 	nilfs->ns_mount_state = le16_to_cpu(sbp->s_state);
 
-	err = nilfs_store_log_cursor(nilfs, sbp);
+	err = nilfs_store_log_cursor(nilfs, sbp,
+			nilfs->ns_mount_state & NILFS_VALID_FS);
 	if (err)
 		goto failed_sbh;
 
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 4140f7f..6a8f5f8 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -135,6 +135,8 @@ struct nilfs_super_root {
 #define NILFS_MOUNT_NORECOVERY		0x4000  /* Disable write access during
 						   mount-time recovery */
 #define NILFS_MOUNT_DISCARD		0x8000  /* Issue DISCARD requests */
+#define NILFS_MOUNT_BAD_FTL		0x10000 /* Only write super block
+						   at umount time */
 
 
 /**
@@ -422,7 +424,7 @@ struct nilfs_segment_summary {
 	__le32 ss_nblocks;
 	__le32 ss_nfinfo;
 	__le32 ss_sumbytes;
-	__le32 ss_pad;
+	__le32 ss_crc_seed;
 	__le64 ss_cno;
 	/* array of finfo structures */
 };
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
