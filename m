From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/6] nilfs2: do not use nilfs_segsum_info structure in recovery code
Date: Tue, 25 May 2010 01:39:08 +0900
Message-ID: <1274719149-24371-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This will get rid of nilfs_segsum_info use from recovery functions for
simplicity.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/recovery.c |   91 ++++++++++++++++++++-----------------------------
 1 files changed, 37 insertions(+), 54 deletions(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index cee9fa3..14d7251 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -91,24 +91,6 @@ static int nilfs_warn_segment_error(int err)
 	return -EINVAL;
 }
 
-static void store_segsum_info(struct nilfs_segsum_info *ssi,
-			      struct nilfs_segment_summary *sum,
-			      unsigned int blocksize)
-{
-	ssi->flags = le16_to_cpu(sum->ss_flags);
-	ssi->seg_seq = le64_to_cpu(sum->ss_seq);
-	ssi->ctime = le64_to_cpu(sum->ss_create);
-	ssi->next = le64_to_cpu(sum->ss_next);
-	ssi->nblocks = le32_to_cpu(sum->ss_nblocks);
-	ssi->nfinfo = le32_to_cpu(sum->ss_nfinfo);
-	ssi->sumbytes = le32_to_cpu(sum->ss_sumbytes);
-
-	ssi->nsumblk = DIV_ROUND_UP(ssi->sumbytes, blocksize);
-	ssi->nfileblk = ssi->nblocks - ssi->nsumblk - !!NILFS_SEG_HAS_SR(ssi);
-
-	/* need to verify ->ss_bytes field if read ->ss_cno */
-}
-
 /**
  * nilfs_compute_checksum - compute checksum of blocks continuously
  * @nilfs: nilfs object
@@ -328,29 +310,31 @@ static void nilfs_skip_summary_info(struct the_nilfs *nilfs,
  * nilfs_scan_dsync_log - get block information of a log written for data sync
  * @nilfs: nilfs object
  * @start_blocknr: start block number of the log
- * @ssi: log summary information
+ * @sum: log summary information
  * @head: list head to add nilfs_recovery_block struct
  */
 static int nilfs_scan_dsync_log(struct the_nilfs *nilfs, sector_t start_blocknr,
-				struct nilfs_segsum_info *ssi,
+				struct nilfs_segment_summary *sum,
 				struct list_head *head)
 {
 	struct buffer_head *bh;
 	unsigned int offset;
-	unsigned long nfinfo = ssi->nfinfo;
-	sector_t blocknr = start_blocknr + ssi->nsumblk;
+	u32 nfinfo, sumbytes;
+	sector_t blocknr;
 	ino_t ino;
 	int err = -EIO;
 
+	nfinfo = le32_to_cpu(sum->ss_nfinfo);
 	if (!nfinfo)
 		return 0;
 
+	sumbytes = le32_to_cpu(sum->ss_sumbytes);
+	blocknr = start_blocknr + DIV_ROUND_UP(sumbytes, nilfs->ns_blocksize);
 	bh = __bread(nilfs->ns_bdev, start_blocknr, nilfs->ns_blocksize);
 	if (unlikely(!bh))
 		goto out;
 
-	offset = le16_to_cpu(
-		((struct nilfs_segment_summary *)bh->b_data)->ss_bytes);
+	offset = le16_to_cpu(sum->ss_bytes);
 	for (;;) {
 		unsigned long nblocks, ndatablk, nnodeblk;
 		struct nilfs_finfo *finfo;
@@ -593,12 +577,12 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 				 struct nilfs_sb_info *sbi,
 				 struct nilfs_recovery_info *ri)
 {
-	struct nilfs_segsum_info ssi;
 	struct buffer_head *bh_sum = NULL;
 	struct nilfs_segment_summary *sum;
 	sector_t pseg_start;
 	sector_t seg_start, seg_end;  /* Starting/ending DBN of full segment */
 	unsigned long nsalvaged_blocks = 0;
+	unsigned int flags;
 	u64 seg_seq;
 	__u64 segnum, nextnum = 0;
 	int empty_seg = 0;
@@ -633,32 +617,34 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 			goto strayed;
 		}
 
-		store_segsum_info(&ssi, sum, nilfs->ns_blocksize);
-		if (unlikely(NILFS_SEG_HAS_SR(&ssi)))
+		flags = le16_to_cpu(sum->ss_flags);
+		if (flags & NILFS_SS_SR)
 			goto confused;
 
 		/* Found a valid partial segment; do recovery actions */
-		nextnum = nilfs_get_segnum_of_block(nilfs, ssi.next);
+		nextnum = nilfs_get_segnum_of_block(nilfs,
+						    le64_to_cpu(sum->ss_next));
 		empty_seg = 0;
-		nilfs->ns_ctime = ssi.ctime;
-		if (!(ssi.flags & NILFS_SS_GC))
-			nilfs->ns_nongc_ctime = ssi.ctime;
+		nilfs->ns_ctime = le64_to_cpu(sum->ss_create);
+		if (!(flags & NILFS_SS_GC))
+			nilfs->ns_nongc_ctime = nilfs->ns_ctime;
 
 		switch (state) {
 		case RF_INIT_ST:
-			if (!NILFS_SEG_LOGBGN(&ssi) || !NILFS_SEG_DSYNC(&ssi))
+			if (!(flags & NILFS_SS_LOGBGN) ||
+			    !(flags & NILFS_SS_SYNDT))
 				goto try_next_pseg;
 			state = RF_DSYNC_ST;
 			/* Fall through */
 		case RF_DSYNC_ST:
-			if (!NILFS_SEG_DSYNC(&ssi))
+			if (!(flags & NILFS_SS_SYNDT))
 				goto confused;
 
-			err = nilfs_scan_dsync_log(nilfs, pseg_start, &ssi,
+			err = nilfs_scan_dsync_log(nilfs, pseg_start, sum,
 						   &dsync_blocks);
 			if (unlikely(err))
 				goto failed;
-			if (NILFS_SEG_LOGEND(&ssi)) {
+			if (flags & NILFS_SS_LOGEND) {
 				err = nilfs_recover_dsync_blocks(
 					nilfs, sbi, &dsync_blocks,
 					&nsalvaged_blocks);
@@ -672,7 +658,7 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
  try_next_pseg:
 		if (pseg_start == ri->ri_lsegs_end)
 			break;
-		pseg_start += ssi.nblocks;
+		pseg_start += le32_to_cpu(sum->ss_nblocks);
 		if (pseg_start < seg_end)
 			continue;
 		goto feed_segment;
@@ -822,12 +808,13 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 int nilfs_search_super_root(struct the_nilfs *nilfs,
 			    struct nilfs_recovery_info *ri)
 {
-	struct nilfs_segsum_info ssi;
 	struct buffer_head *bh_sum = NULL;
 	struct nilfs_segment_summary *sum;
 	sector_t pseg_start, pseg_end, sr_pseg_start = 0;
 	sector_t seg_start, seg_end; /* range of full segment (block number) */
 	sector_t b, end;
+	unsigned long nblocks;
+	unsigned int flags;
 	u64 seg_seq;
 	__u64 segnum, nextnum = 0;
 	__u64 cno;
@@ -862,8 +849,8 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 			goto strayed;
 		}
 
-		store_segsum_info(&ssi, sum, nilfs->ns_blocksize);
-		pseg_end = pseg_start + ssi.nblocks - 1;
+		nblocks = le32_to_cpu(sum->ss_nblocks);
+		pseg_end = pseg_start + nblocks - 1;
 		if (unlikely(pseg_end > seg_end)) {
 			ret = NILFS_SEG_FAIL_CONSISTENCY;
 			goto strayed;
@@ -873,11 +860,13 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 		ri->ri_pseg_start = pseg_start;
 		ri->ri_seq = seg_seq;
 		ri->ri_segnum = segnum;
-		nextnum = nilfs_get_segnum_of_block(nilfs, ssi.next);
+		nextnum = nilfs_get_segnum_of_block(nilfs,
+						    le64_to_cpu(sum->ss_next));
 		ri->ri_nextnum = nextnum;
 		empty_seg = 0;
 
-		if (!NILFS_SEG_HAS_SR(&ssi) && !scan_newer) {
+		flags = le16_to_cpu(sum->ss_flags);
+		if (!(flags & NILFS_SS_SR) && !scan_newer) {
 			/* This will never happen because a superblock
 			   (last_segment) always points to a pseg
 			   having a super root. */
@@ -891,12 +880,12 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 				__breadahead(nilfs->ns_bdev, b++,
 					     nilfs->ns_blocksize);
 		}
-		if (!NILFS_SEG_HAS_SR(&ssi)) {
-			if (!ri->ri_lsegs_start && NILFS_SEG_LOGBGN(&ssi)) {
+		if (!(flags & NILFS_SS_SR)) {
+			if (!ri->ri_lsegs_start && (flags & NILFS_SS_LOGBGN)) {
 				ri->ri_lsegs_start = pseg_start;
 				ri->ri_lsegs_start_seq = seg_seq;
 			}
-			if (NILFS_SEG_LOGEND(&ssi))
+			if (flags & NILFS_SS_LOGEND)
 				ri->ri_lsegs_end = pseg_start;
 			goto try_next_pseg;
 		}
@@ -907,12 +896,12 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 		ri->ri_lsegs_start = ri->ri_lsegs_end = 0;
 
 		nilfs_dispose_segment_list(&segments);
-		nilfs->ns_pseg_offset = (sr_pseg_start = pseg_start)
-			+ ssi.nblocks - seg_start;
+		sr_pseg_start = pseg_start;
+		nilfs->ns_pseg_offset = pseg_start + nblocks - seg_start;
 		nilfs->ns_seg_seq = seg_seq;
 		nilfs->ns_segnum = segnum;
 		nilfs->ns_cno = cno;  /* nilfs->ns_cno = ri->ri_cno + 1 */
-		nilfs->ns_ctime = ssi.ctime;
+		nilfs->ns_ctime = le64_to_cpu(sum->ss_create);
 		nilfs->ns_nextnum = nextnum;
 
 		if (scan_newer)
@@ -923,15 +912,9 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 			scan_newer = 1;
 		}
 
-		/* reset region for roll-forward */
-		pseg_start += ssi.nblocks;
-		if (pseg_start < seg_end)
-			continue;
-		goto feed_segment;
-
  try_next_pseg:
 		/* Standing on a course, or met an inconsistent state */
-		pseg_start += ssi.nblocks;
+		pseg_start += nblocks;
 		if (pseg_start < seg_end)
 			continue;
 		goto feed_segment;
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
