From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/6] nilfs2: divide load_segment_summary function
Date: Tue, 25 May 2010 01:39:07 +0900
Message-ID: <1274719149-24371-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1274719149-24371-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1274719149-24371-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

load_segment_summary function has two distinct roles: getting summary
header of a log, and verifying consistencies of the log.

This divide it into two corresponding functions, nilfs_read_log_header
and nilfs_validate_log to clarify the meaning.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/recovery.c |  114 +++++++++++++++++++++++++++++++-------------------
 1 files changed, 71 insertions(+), 43 deletions(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index fd7fb41..cee9fa3 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -202,58 +202,63 @@ int nilfs_read_super_root_block(struct the_nilfs *nilfs, sector_t sr_block,
 }
 
 /**
- * load_segment_summary - read segment summary of the specified partial segment
+ * nilfs_read_log_header - read summary header of the specified log
  * @nilfs: nilfs object
- * @pseg_start: start disk block number of partial segment
- * @seg_seq: sequence number requested
- * @ssi: pointer to nilfs_segsum_info struct to store information
+ * @start_blocknr: start block number of the log
+ * @sum: pointer to return segment summary structure
  */
-static int
-load_segment_summary(struct the_nilfs *nilfs, sector_t pseg_start,
-		     u64 seg_seq, struct nilfs_segsum_info *ssi)
+static struct buffer_head *
+nilfs_read_log_header(struct the_nilfs *nilfs, sector_t start_blocknr,
+		      struct nilfs_segment_summary **sum)
 {
 	struct buffer_head *bh_sum;
-	struct nilfs_segment_summary *sum;
-	unsigned long nblock;
-	u32 crc;
-	int ret = NILFS_SEG_FAIL_IO;
 
-	bh_sum = __bread(nilfs->ns_bdev, pseg_start, nilfs->ns_blocksize);
-	if (!bh_sum)
-		goto out;
+	bh_sum = __bread(nilfs->ns_bdev, start_blocknr, nilfs->ns_blocksize);
+	if (bh_sum)
+		*sum = (struct nilfs_segment_summary *)bh_sum->b_data;
+	return bh_sum;
+}
 
-	sum = (struct nilfs_segment_summary *)bh_sum->b_data;
+/**
+ * nilfs_validate_log - verify consistency of log
+ * @nilfs: nilfs object
+ * @seg_seq: sequence number of segment
+ * @bh_sum: buffer head of summary block
+ * @sum: segment summary struct
+ */
+static int nilfs_validate_log(struct the_nilfs *nilfs, u64 seg_seq,
+			      struct buffer_head *bh_sum,
+			      struct nilfs_segment_summary *sum)
+{
+ 	unsigned long nblock;
+ 	u32 crc;
+	int ret;
 
-	/* Check consistency of segment summary */
-	if (le32_to_cpu(sum->ss_magic) != NILFS_SEGSUM_MAGIC) {
-		ret = NILFS_SEG_FAIL_MAGIC;
-		goto failed;
-	}
-	store_segsum_info(ssi, sum, nilfs->ns_blocksize);
-	if (seg_seq != ssi->seg_seq) {
-		ret = NILFS_SEG_FAIL_SEQ;
-		goto failed;
-	}
+	ret = NILFS_SEG_FAIL_MAGIC;
+	if (le32_to_cpu(sum->ss_magic) != NILFS_SEGSUM_MAGIC)
+ 		goto out;
 
-	nblock = ssi->nblocks;
-	if (unlikely(nblock == 0 || nblock > nilfs->ns_blocks_per_segment)) {
+	ret = NILFS_SEG_FAIL_SEQ;
+	if (le64_to_cpu(sum->ss_seq) != seg_seq)
+		goto out;
+ 
+	nblock = le32_to_cpu(sum->ss_nblocks);
+	ret = NILFS_SEG_FAIL_CONSISTENCY;
+	if (unlikely(nblock == 0 || nblock > nilfs->ns_blocks_per_segment))
 		/* This limits the number of blocks read in the CRC check */
-		ret = NILFS_SEG_FAIL_CONSISTENCY;
-		goto failed;
-	}
+		goto out;
+
+	ret = NILFS_SEG_FAIL_IO;
 	if (nilfs_compute_checksum(nilfs, bh_sum, &crc, sizeof(sum->ss_datasum),
 				   ((u64)nblock << nilfs->ns_blocksize_bits),
-				   pseg_start, nblock)) {
-		ret = NILFS_SEG_FAIL_IO;
-		goto failed;
-	}
-	if (crc == le32_to_cpu(sum->ss_datasum))
-		ret = 0;
-	else
-		ret = NILFS_SEG_FAIL_CHECKSUM_FULL;
- failed:
-	brelse(bh_sum);
- out:
+				   bh_sum->b_blocknr, nblock))
+		goto out;
+
+	ret = NILFS_SEG_FAIL_CHECKSUM_FULL;
+	if (crc != le32_to_cpu(sum->ss_datasum))
+		goto out;
+	ret = 0;
+out:
 	return ret;
 }
 
@@ -589,6 +594,8 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 				 struct nilfs_recovery_info *ri)
 {
 	struct nilfs_segsum_info ssi;
+	struct buffer_head *bh_sum = NULL;
+	struct nilfs_segment_summary *sum;
 	sector_t pseg_start;
 	sector_t seg_start, seg_end;  /* Starting/ending DBN of full segment */
 	unsigned long nsalvaged_blocks = 0;
@@ -610,8 +617,14 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 	nilfs_get_segment_range(nilfs, segnum, &seg_start, &seg_end);
 
 	while (segnum != ri->ri_segnum || pseg_start <= ri->ri_pseg_start) {
+		brelse(bh_sum);
+		bh_sum = nilfs_read_log_header(nilfs, pseg_start, &sum);
+		if (!bh_sum) {
+			err = -EIO;
+			goto failed;
+		}
 
-		ret = load_segment_summary(nilfs, pseg_start, seg_seq, &ssi);
+		ret = nilfs_validate_log(nilfs, seg_seq, bh_sum, sum);
 		if (ret) {
 			if (ret == NILFS_SEG_FAIL_IO) {
 				err = -EIO;
@@ -619,6 +632,8 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 			}
 			goto strayed;
 		}
+
+		store_segsum_info(&ssi, sum, nilfs->ns_blocksize);
 		if (unlikely(NILFS_SEG_HAS_SR(&ssi)))
 			goto confused;
 
@@ -682,6 +697,7 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 		ri->ri_need_recovery = NILFS_RECOVERY_ROLLFORWARD_DONE;
 	}
  out:
+	brelse(bh_sum);
 	dispose_recovery_list(&dsync_blocks);
 	nilfs_detach_writer(nilfs, sbi);
 	return err;
@@ -807,6 +823,8 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 			    struct nilfs_recovery_info *ri)
 {
 	struct nilfs_segsum_info ssi;
+	struct buffer_head *bh_sum = NULL;
+	struct nilfs_segment_summary *sum;
 	sector_t pseg_start, pseg_end, sr_pseg_start = 0;
 	sector_t seg_start, seg_end; /* range of full segment (block number) */
 	sector_t b, end;
@@ -831,12 +849,20 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 		__breadahead(nilfs->ns_bdev, b++, nilfs->ns_blocksize);
 
 	for (;;) {
-		ret = load_segment_summary(nilfs, pseg_start, seg_seq, &ssi);
+		brelse(bh_sum);
+		ret = NILFS_SEG_FAIL_IO;
+		bh_sum = nilfs_read_log_header(nilfs, pseg_start, &sum);
+		if (!bh_sum)
+			goto failed;
+
+		ret = nilfs_validate_log(nilfs, seg_seq, bh_sum, sum);
 		if (ret) {
 			if (ret == NILFS_SEG_FAIL_IO)
 				goto failed;
 			goto strayed;
 		}
+
+		store_segsum_info(&ssi, sum, nilfs->ns_blocksize);
 		pseg_end = pseg_start + ssi.nblocks - 1;
 		if (unlikely(pseg_end > seg_end)) {
 			ret = NILFS_SEG_FAIL_CONSISTENCY;
@@ -936,6 +962,7 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 
  super_root_found:
 	/* Updating pointers relating to the latest checkpoint */
+	brelse(bh_sum);
 	list_splice_tail(&segments, &ri->ri_used_segments);
 	nilfs->ns_last_pseg = sr_pseg_start;
 	nilfs->ns_last_seq = nilfs->ns_seg_seq;
@@ -943,6 +970,7 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 	return 0;
 
  failed:
+	brelse(bh_sum);
 	nilfs_dispose_segment_list(&segments);
 	return (ret < 0) ? ret : nilfs_warn_segment_error(ret);
 }
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
