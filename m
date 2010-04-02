From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: move pointer to super root block into logs
Date: Sat,  3 Apr 2010 00:48:24 +0900
Message-ID: <1270223305-30416-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ryusuke-sG5X7nlA6pw@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This moves a pointer to buffer storing super root block to each log
buffer from nilfs_sc_info struct for simplicity.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c  |    2 ++
 fs/nilfs2/segbuf.h  |    2 ++
 fs/nilfs2/segment.c |   45 +++++++++++++++++++++------------------------
 fs/nilfs2/segment.h |    2 --
 4 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 6129a43..cb6459d 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -80,6 +80,7 @@ struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *sb)
 	INIT_LIST_HEAD(&segbuf->sb_list);
 	INIT_LIST_HEAD(&segbuf->sb_segsum_buffers);
 	INIT_LIST_HEAD(&segbuf->sb_payload_buffers);
+	segbuf->sb_super_root = NULL;
 
 	init_completion(&segbuf->sb_bio_event);
 	atomic_set(&segbuf->sb_err, 0);
@@ -281,6 +282,7 @@ static void nilfs_segbuf_clear(struct nilfs_segment_buffer *segbuf)
 {
 	nilfs_release_buffers(&segbuf->sb_segsum_buffers);
 	nilfs_release_buffers(&segbuf->sb_payload_buffers);
+	segbuf->sb_super_root = NULL;
 }
 
 /*
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index 94dfd35..a1a0af6 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -76,6 +76,7 @@ struct nilfs_segsum_info {
  * @sb_rest_blocks: Number of residual blocks in the current segment
  * @sb_segsum_buffers: List of buffers for segment summaries
  * @sb_payload_buffers: List of buffers for segment payload
+ * @sb_super_root: Pointer to buffer storing a super root block (if exists)
  * @sb_nbio: Number of flying bio requests
  * @sb_err: I/O error status
  * @sb_bio_event: Completion event of log writing
@@ -95,6 +96,7 @@ struct nilfs_segment_buffer {
 	/* Buffers */
 	struct list_head	sb_segsum_buffers;
 	struct list_head	sb_payload_buffers; /* including super root */
+	struct buffer_head     *sb_super_root;
 
 	/* io status */
 	int			sb_nbio;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index c161d89..39c94b7 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -434,7 +434,7 @@ static int nilfs_segctor_add_super_root(struct nilfs_sc_info *sci)
 			return err;
 		segbuf = sci->sc_curseg;
 	}
-	err = nilfs_segbuf_extend_payload(segbuf, &sci->sc_super_root);
+	err = nilfs_segbuf_extend_payload(segbuf, &segbuf->sb_super_root);
 	if (likely(!err))
 		segbuf->sb_sum.flags |= NILFS_SS_SR;
 	return err;
@@ -951,10 +951,10 @@ static void nilfs_segctor_fill_in_checksums(struct nilfs_sc_info *sci,
 {
 	struct nilfs_segment_buffer *segbuf;
 
-	if (sci->sc_super_root)
-		nilfs_fill_in_super_root_crc(sci->sc_super_root, seed);
-
 	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
+		if (segbuf->sb_super_root)
+			nilfs_fill_in_super_root_crc(segbuf->sb_super_root,
+						     seed);
 		nilfs_segbuf_fill_in_segsum_crc(segbuf, seed);
 		nilfs_segbuf_fill_in_data_crc(segbuf, seed);
 	}
@@ -963,11 +963,13 @@ static void nilfs_segctor_fill_in_checksums(struct nilfs_sc_info *sci,
 static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
 					     struct the_nilfs *nilfs)
 {
-	struct buffer_head *bh_sr = sci->sc_super_root;
-	struct nilfs_super_root *raw_sr =
-		(struct nilfs_super_root *)bh_sr->b_data;
+	struct buffer_head *bh_sr;
+	struct nilfs_super_root *raw_sr;
 	unsigned isz = nilfs->ns_inode_size;
 
+	bh_sr = NILFS_LAST_SEGBUF(&sci->sc_segbufs)->sb_super_root;
+	raw_sr = (struct nilfs_super_root *)bh_sr->b_data;
+
 	raw_sr->sr_bytes = cpu_to_le16(NILFS_SR_BYTES);
 	raw_sr->sr_nongc_ctime
 		= cpu_to_le64(nilfs_doing_gc() ?
@@ -1490,7 +1492,6 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 
 	/* Collection retry loop */
 	for (;;) {
-		sci->sc_super_root = NULL;
 		sci->sc_nblk_this_inc = 0;
 		sci->sc_curseg = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
 
@@ -1567,7 +1568,7 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 	ssp.offset = sizeof(struct nilfs_segment_summary);
 
 	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
-		if (bh == sci->sc_super_root)
+		if (bh == segbuf->sb_super_root)
 			break;
 		if (!finfo) {
 			finfo =	nilfs_segctor_map_segsum_entry(
@@ -1728,7 +1729,7 @@ static int nilfs_segctor_prepare_write(struct nilfs_sc_info *sci,
 
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			if (bh == sci->sc_super_root) {
+			if (bh == segbuf->sb_super_root) {
 				if (bh->b_page != bd_page) {
 					lock_page(bd_page);
 					clear_page_dirty_for_io(bd_page);
@@ -1847,7 +1848,7 @@ static void nilfs_clear_copied_buffers(struct list_head *list, int err)
 }
 
 static void nilfs_abort_logs(struct list_head *logs, struct page *failed_page,
-			     struct buffer_head *bh_sr, int err)
+			     int err)
 {
 	struct nilfs_segment_buffer *segbuf;
 	struct page *bd_page = NULL, *fs_page = NULL;
@@ -1868,7 +1869,7 @@ static void nilfs_abort_logs(struct list_head *logs, struct page *failed_page,
 
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			if (bh == bh_sr) {
+			if (bh == segbuf->sb_super_root) {
 				if (bh->b_page != bd_page) {
 					end_page_writeback(bd_page);
 					bd_page = bh->b_page;
@@ -1897,7 +1898,7 @@ static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
 
 	list_splice_tail_init(&sci->sc_write_logs, &logs);
 	ret = nilfs_wait_on_logs(&logs);
-	nilfs_abort_logs(&logs, NULL, sci->sc_super_root, ret ? : err);
+	nilfs_abort_logs(&logs, NULL, ret ? : err);
 
 	list_splice_tail_init(&sci->sc_segbufs, &logs);
 	nilfs_cancel_segusage(&logs, nilfs->ns_sufile);
@@ -1913,7 +1914,6 @@ static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
 	}
 
 	nilfs_destroy_logs(&logs);
-	sci->sc_super_root = NULL;
 }
 
 static void nilfs_set_next_segment(struct the_nilfs *nilfs,
@@ -1932,7 +1932,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	struct nilfs_segment_buffer *segbuf;
 	struct page *bd_page = NULL, *fs_page = NULL;
 	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
-	int update_sr = (sci->sc_super_root != NULL);
+	int update_sr = false;
 
 	list_for_each_entry(segbuf, &sci->sc_write_logs, sb_list) {
 		struct buffer_head *bh;
@@ -1963,11 +1963,12 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 			set_buffer_uptodate(bh);
 			clear_buffer_dirty(bh);
 			clear_buffer_nilfs_volatile(bh);
-			if (bh == sci->sc_super_root) {
+			if (bh == segbuf->sb_super_root) {
 				if (bh->b_page != bd_page) {
 					end_page_writeback(bd_page);
 					bd_page = bh->b_page;
 				}
+				update_sr = true;
 				break;
 			}
 			if (bh->b_page != fs_page) {
@@ -2114,7 +2115,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 	struct nilfs_sb_info *sbi = sci->sc_sbi;
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct page *failed_page;
-	int err, has_sr = 0;
+	int err;
 
 	sci->sc_stage.scnt = NILFS_ST_INIT;
 
@@ -2142,8 +2143,6 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 		if (unlikely(err))
 			goto failed;
 
-		has_sr = (sci->sc_super_root != NULL);
-
 		/* Avoid empty segment */
 		if (sci->sc_stage.scnt == NILFS_ST_DONE &&
 		    NILFS_SEG_EMPTY(&sci->sc_curseg->sb_sum)) {
@@ -2158,7 +2157,8 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 		if (sci->sc_stage.flags & NILFS_CF_IFILE_STARTED)
 			nilfs_segctor_fill_in_file_bmap(sci, sbi->s_ifile);
 
-		if (has_sr) {
+		if (mode == SC_LSEG_SR &&
+		    sci->sc_stage.scnt >= NILFS_ST_CPFILE) {
 			err = nilfs_segctor_fill_in_checkpoint(sci);
 			if (unlikely(err))
 				goto failed_to_write;
@@ -2170,8 +2170,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 		/* Write partial segments */
 		err = nilfs_segctor_prepare_write(sci, &failed_page);
 		if (err) {
-			nilfs_abort_logs(&sci->sc_segbufs, failed_page,
-					 sci->sc_super_root, err);
+			nilfs_abort_logs(&sci->sc_segbufs, failed_page, err);
 			goto failed_to_write;
 		}
 		nilfs_segctor_fill_in_checksums(sci, nilfs->ns_crc_seed);
@@ -2195,8 +2194,6 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 		}
 	} while (sci->sc_stage.scnt != NILFS_ST_DONE);
 
-	sci->sc_super_root = NULL;
-
  out:
 	nilfs_segctor_check_out_files(sci, sbi);
 	return err;
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 82dfd6a..e61fc79 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -100,7 +100,6 @@ struct nilfs_segsum_pointer {
  * @sc_write_logs: List of segment buffers to hold logs under writing
  * @sc_segbuf_nblocks: Number of available blocks in segment buffers.
  * @sc_curseg: Current segment buffer
- * @sc_super_root: Pointer to the super root buffer
  * @sc_stage: Collection stage
  * @sc_finfo_ptr: pointer to the current finfo struct in the segment summary
  * @sc_binfo_ptr: pointer to the current binfo struct in the segment summary
@@ -148,7 +147,6 @@ struct nilfs_sc_info {
 	struct list_head	sc_write_logs;
 	unsigned long		sc_segbuf_nblocks;
 	struct nilfs_segment_buffer *sc_curseg;
-	struct buffer_head     *sc_super_root;
 
 	struct nilfs_cstage	sc_stage;
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
