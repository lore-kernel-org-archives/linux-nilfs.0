From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 6/6] nilfs2: separate wait function from
	nilfs_segctor_write
Date: Mon, 30 Nov 2009 22:30:45 +0900
Message-ID: <1259587845-3436-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1259587845-3436-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1259587845-3436-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This separates wait function for submitted logs from the write
function nilfs_segctor_write().  A new list of segment buffers
"sc_write_logs" is added to hold logs under writing, and double
buffering is partially applied to hide io latency.

At this point, the double buffering is disabled for blocksize <
pagesize because page dirty flag is turned off during write and dirty
buffers are not properly collected for pages crossing over segments.

To receive full benefit of the double buffering, further refinement is
needed to move the io wait outside the lock section of log writer.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c  |   16 ++++
 fs/nilfs2/segbuf.h  |    2 +
 fs/nilfs2/segment.c |  240 +++++++++++++++++++++++++++++++--------------------
 fs/nilfs2/segment.h |    2 +
 4 files changed, 165 insertions(+), 95 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index d856d62..645c786 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -100,6 +100,22 @@ void nilfs_segbuf_map(struct nilfs_segment_buffer *segbuf, __u64 segnum,
 		segbuf->sb_fseg_end - segbuf->sb_pseg_start + 1;
 }
 
+/**
+ * nilfs_segbuf_map_cont - map a new log behind a given log
+ * @segbuf: new segment buffer
+ * @prev: segment buffer containing a log to be continued
+ */
+void nilfs_segbuf_map_cont(struct nilfs_segment_buffer *segbuf,
+			   struct nilfs_segment_buffer *prev)
+{
+	segbuf->sb_segnum = prev->sb_segnum;
+	segbuf->sb_fseg_start = prev->sb_fseg_start;
+	segbuf->sb_fseg_end = prev->sb_fseg_end;
+	segbuf->sb_pseg_start = prev->sb_pseg_start + prev->sb_sum.nblocks;
+	segbuf->sb_rest_blocks =
+		segbuf->sb_fseg_end - segbuf->sb_pseg_start + 1;
+}
+
 void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *segbuf,
 				  __u64 nextnum, struct the_nilfs *nilfs)
 {
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index 7fbaf5e..6af1630 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -128,6 +128,8 @@ struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *);
 void nilfs_segbuf_free(struct nilfs_segment_buffer *);
 void nilfs_segbuf_map(struct nilfs_segment_buffer *, __u64, unsigned long,
 		      struct the_nilfs *);
+void nilfs_segbuf_map_cont(struct nilfs_segment_buffer *segbuf,
+			   struct nilfs_segment_buffer *prev);
 void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *, __u64,
 				  struct the_nilfs *);
 int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned, time_t);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 689deb9..17584c5 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1273,48 +1273,69 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 	return err;
 }
 
+/**
+ * nilfs_segctor_begin_construction - setup segment buffer to make a new log
+ * @sci: nilfs_sc_info
+ * @nilfs: nilfs object
+ */
 static int nilfs_segctor_begin_construction(struct nilfs_sc_info *sci,
 					    struct the_nilfs *nilfs)
 {
-	struct nilfs_segment_buffer *segbuf;
+	struct nilfs_segment_buffer *segbuf, *prev;
 	__u64 nextnum;
-	int err;
+	int err, alloc = 0;
 
-	if (list_empty(&sci->sc_segbufs)) {
-		segbuf = nilfs_segbuf_new(sci->sc_super);
-		if (unlikely(!segbuf))
-			return -ENOMEM;
-		list_add(&segbuf->sb_list, &sci->sc_segbufs);
-	} else
-		segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
+	segbuf = nilfs_segbuf_new(sci->sc_super);
+	if (unlikely(!segbuf))
+		return -ENOMEM;
 
-	nilfs_segbuf_map(segbuf, nilfs->ns_segnum, nilfs->ns_pseg_offset,
-			 nilfs);
+	if (list_empty(&sci->sc_write_logs)) {
+		nilfs_segbuf_map(segbuf, nilfs->ns_segnum,
+				 nilfs->ns_pseg_offset, nilfs);
+		if (segbuf->sb_rest_blocks < NILFS_PSEG_MIN_BLOCKS) {
+			nilfs_shift_to_next_segment(nilfs);
+			nilfs_segbuf_map(segbuf, nilfs->ns_segnum, 0, nilfs);
+		}
 
-	if (segbuf->sb_rest_blocks < NILFS_PSEG_MIN_BLOCKS) {
-		nilfs_shift_to_next_segment(nilfs);
-		nilfs_segbuf_map(segbuf, nilfs->ns_segnum, 0, nilfs);
+		segbuf->sb_sum.seg_seq = nilfs->ns_seg_seq;
+		nextnum = nilfs->ns_nextnum;
+
+		if (nilfs->ns_segnum == nilfs->ns_nextnum)
+			/* Start from the head of a new full segment */
+			alloc++;
+	} else {
+		/* Continue logs */
+		prev = NILFS_LAST_SEGBUF(&sci->sc_write_logs);
+		nilfs_segbuf_map_cont(segbuf, prev);
+		segbuf->sb_sum.seg_seq = prev->sb_sum.seg_seq;
+		nextnum = prev->sb_nextnum;
+
+		if (segbuf->sb_rest_blocks < NILFS_PSEG_MIN_BLOCKS) {
+			nilfs_segbuf_map(segbuf, prev->sb_nextnum, 0, nilfs);
+			segbuf->sb_sum.seg_seq++;
+			alloc++;
+		}
 	}
-	sci->sc_segbuf_nblocks = segbuf->sb_rest_blocks;
 
 	err = nilfs_sufile_mark_dirty(nilfs->ns_sufile, segbuf->sb_segnum);
-	if (unlikely(err))
-		return err;
+	if (err)
+		goto failed;
 
-	if (nilfs->ns_segnum == nilfs->ns_nextnum) {
-		/* Start from the head of a new full segment */
+	if (alloc) {
 		err = nilfs_sufile_alloc(nilfs->ns_sufile, &nextnum);
-		if (unlikely(err))
-			return err;
-	} else
-		nextnum = nilfs->ns_nextnum;
-
-	segbuf->sb_sum.seg_seq = nilfs->ns_seg_seq;
+		if (err)
+			goto failed;
+	}
 	nilfs_segbuf_set_next_segnum(segbuf, nextnum, nilfs);
 
-	/* truncating segment buffers */
-	nilfs_truncate_logs(&sci->sc_segbufs, segbuf);
+	BUG_ON(!list_empty(&sci->sc_segbufs));
+	list_add_tail(&segbuf->sb_list, &sci->sc_segbufs);
+	sci->sc_segbuf_nblocks = segbuf->sb_rest_blocks;
 	return 0;
+
+ failed:
+	nilfs_segbuf_free(segbuf);
+	return err;
 }
 
 static int nilfs_segctor_extend_segments(struct nilfs_sc_info *sci,
@@ -1373,15 +1394,16 @@ static int nilfs_segctor_extend_segments(struct nilfs_sc_info *sci,
 	return err;
 }
 
-static void nilfs_segctor_free_incomplete_segments(struct nilfs_sc_info *sci,
-						   struct the_nilfs *nilfs)
+static void nilfs_free_incomplete_logs(struct list_head *logs,
+				       struct the_nilfs *nilfs)
 {
-	struct nilfs_segment_buffer *segbuf;
+	struct nilfs_segment_buffer *segbuf, *prev;
+	struct inode *sufile = nilfs->ns_sufile;
 	int ret;
 
-	segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
+	segbuf = NILFS_FIRST_SEGBUF(logs);
 	if (nilfs->ns_nextnum != segbuf->sb_nextnum) {
-		ret = nilfs_sufile_free(nilfs->ns_sufile, segbuf->sb_nextnum);
+		ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
 		WARN_ON(ret); /* never fails */
 	}
 	if (atomic_read(&segbuf->sb_err)) {
@@ -1395,34 +1417,18 @@ static void nilfs_segctor_free_incomplete_segments(struct nilfs_sc_info *sci,
 			set_nilfs_discontinued(nilfs);
 	}
 
-	list_for_each_entry_continue(segbuf, &sci->sc_segbufs, sb_list) {
-		ret = nilfs_sufile_free(nilfs->ns_sufile, segbuf->sb_nextnum);
-		WARN_ON(ret); /* never fails */
+	prev = segbuf;
+	list_for_each_entry_continue(segbuf, logs, sb_list) {
+		if (prev->sb_nextnum != segbuf->sb_nextnum) {
+			ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
+			WARN_ON(ret); /* never fails */
+		}
 		if (atomic_read(&segbuf->sb_err) &&
 		    segbuf->sb_segnum != nilfs->ns_nextnum)
 			/* Case 2: extended segment (!= next) failed */
-			nilfs_sufile_set_error(nilfs->ns_sufile,
-					       segbuf->sb_segnum);
-	}
-}
-
-static void nilfs_segctor_end_construction(struct nilfs_sc_info *sci,
-					   struct the_nilfs *nilfs, int err)
-{
-	if (unlikely(err)) {
-		nilfs_segctor_free_incomplete_segments(sci, nilfs);
-		if (sci->sc_stage.flags & NILFS_CF_SUFREED) {
-			int ret;
-
-			ret = nilfs_sufile_cancel_freev(nilfs->ns_sufile,
-							sci->sc_freesegs,
-							sci->sc_nfreesegs,
-							NULL);
-			WARN_ON(ret); /* do not happen */
-		}
+			nilfs_sufile_set_error(sufile, segbuf->sb_segnum);
+		prev = segbuf;
 	}
-	nilfs_clear_logs(&sci->sc_segbufs);
-	sci->sc_super_root = NULL;
 }
 
 static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
@@ -1442,19 +1448,18 @@ static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
 	}
 }
 
-static void nilfs_segctor_cancel_segusage(struct nilfs_sc_info *sci,
-					  struct inode *sufile)
+static void nilfs_cancel_segusage(struct list_head *logs, struct inode *sufile)
 {
 	struct nilfs_segment_buffer *segbuf;
 	int ret;
 
-	segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
+	segbuf = NILFS_FIRST_SEGBUF(logs);
 	ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
 					     segbuf->sb_pseg_start -
 					     segbuf->sb_fseg_start, 0);
 	WARN_ON(ret); /* always succeed because the segusage is dirty */
 
-	list_for_each_entry_continue(segbuf, &sci->sc_segbufs, sb_list) {
+	list_for_each_entry_continue(segbuf, logs, sb_list) {
 		ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
 						     0, 0);
 		WARN_ON(ret); /* always succeed */
@@ -1760,17 +1765,15 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
 			       struct the_nilfs *nilfs)
 {
 	struct nilfs_segment_buffer *segbuf;
-	int err, res;
+	int ret = 0;
 
 	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
-		err = nilfs_segbuf_write(segbuf, nilfs);
-
-		res = nilfs_segbuf_wait(segbuf);
-		err = err ? : res;
-		if (err)
-			return err;
+		ret = nilfs_segbuf_write(segbuf, nilfs);
+		if (ret)
+			break;
 	}
-	return 0;
+	list_splice_tail_init(&sci->sc_segbufs, &sci->sc_write_logs);
+	return ret;
 }
 
 static void __nilfs_end_page_io(struct page *page, int err)
@@ -1848,15 +1851,17 @@ static void nilfs_clear_copied_buffers(struct list_head *list, int err)
 	}
 }
 
-static void nilfs_segctor_abort_write(struct nilfs_sc_info *sci,
-				      struct page *failed_page, int err)
+static void nilfs_abort_logs(struct list_head *logs, struct page *failed_page,
+			     struct buffer_head *bh_sr, int err)
 {
 	struct nilfs_segment_buffer *segbuf;
 	struct page *bd_page = NULL, *fs_page = NULL;
+	struct buffer_head *bh;
 
-	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
-		struct buffer_head *bh;
+	if (list_empty(logs))
+		return;
 
+	list_for_each_entry(segbuf, logs, sb_list) {
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
 			if (bh->b_page != bd_page) {
@@ -1868,7 +1873,7 @@ static void nilfs_segctor_abort_write(struct nilfs_sc_info *sci,
 
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			if (bh == sci->sc_super_root) {
+			if (bh == bh_sr) {
 				if (bh->b_page != bd_page) {
 					end_page_writeback(bd_page);
 					bd_page = bh->b_page;
@@ -1878,7 +1883,7 @@ static void nilfs_segctor_abort_write(struct nilfs_sc_info *sci,
 			if (bh->b_page != fs_page) {
 				nilfs_end_page_io(fs_page, err);
 				if (fs_page && fs_page == failed_page)
-					goto done;
+					return;
 				fs_page = bh->b_page;
 			}
 		}
@@ -1887,8 +1892,34 @@ static void nilfs_segctor_abort_write(struct nilfs_sc_info *sci,
 		end_page_writeback(bd_page);
 
 	nilfs_end_page_io(fs_page, err);
- done:
+}
+
+static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
+					     struct the_nilfs *nilfs, int err)
+{
+	LIST_HEAD(logs);
+	int ret;
+
+	list_splice_tail_init(&sci->sc_write_logs, &logs);
+	ret = nilfs_wait_on_logs(&logs);
+	if (ret)
+		nilfs_abort_logs(&logs, NULL, sci->sc_super_root, ret);
+
+	list_splice_tail_init(&sci->sc_segbufs, &logs);
+	nilfs_cancel_segusage(&logs, nilfs->ns_sufile);
+	nilfs_free_incomplete_logs(&logs, nilfs);
 	nilfs_clear_copied_buffers(&sci->sc_copied_buffers, err);
+
+	if (sci->sc_stage.flags & NILFS_CF_SUFREED) {
+		ret = nilfs_sufile_cancel_freev(nilfs->ns_sufile,
+						sci->sc_freesegs,
+						sci->sc_nfreesegs,
+						NULL);
+		WARN_ON(ret); /* do not happen */
+	}
+
+	nilfs_destroy_logs(&logs);
+	sci->sc_super_root = NULL;
 }
 
 static void nilfs_set_next_segment(struct the_nilfs *nilfs,
@@ -1910,7 +1941,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	int update_sr = (sci->sc_super_root != NULL);
 
-	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
+	list_for_each_entry(segbuf, &sci->sc_write_logs, sb_list) {
 		struct buffer_head *bh;
 
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
@@ -1983,7 +2014,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 
 	sci->sc_nblk_inc += sci->sc_nblk_this_inc;
 
-	segbuf = NILFS_LAST_SEGBUF(&sci->sc_segbufs);
+	segbuf = NILFS_LAST_SEGBUF(&sci->sc_write_logs);
 	nilfs_set_next_segment(nilfs, segbuf);
 
 	if (update_sr) {
@@ -1994,10 +2025,23 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 		clear_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 		clear_bit(NILFS_SC_DIRTY, &sci->sc_flags);
 		set_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags);
+		nilfs_segctor_clear_metadata_dirty(sci);
 	} else
 		clear_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags);
 }
 
+static int nilfs_segctor_wait(struct nilfs_sc_info *sci)
+{
+	int ret;
+
+	ret = nilfs_wait_on_logs(&sci->sc_write_logs);
+	if (!ret) {
+		nilfs_segctor_complete_write(sci);
+		nilfs_destroy_logs(&sci->sc_write_logs);
+	}
+	return ret;
+}
+
 static int nilfs_segctor_check_in_files(struct nilfs_sc_info *sci,
 					struct nilfs_sb_info *sbi)
 {
@@ -2110,7 +2154,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 		/* Avoid empty segment */
 		if (sci->sc_stage.scnt == NILFS_ST_DONE &&
 		    NILFS_SEG_EMPTY(&sci->sc_curseg->sb_sum)) {
-			nilfs_segctor_end_construction(sci, nilfs, 1);
+			nilfs_segctor_abort_construction(sci, nilfs, 1);
 			goto out;
 		}
 
@@ -2124,7 +2168,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 		if (has_sr) {
 			err = nilfs_segctor_fill_in_checkpoint(sci);
 			if (unlikely(err))
-				goto failed_to_make_up;
+				goto failed_to_write;
 
 			nilfs_segctor_fill_in_super_root(sci, nilfs);
 		}
@@ -2132,42 +2176,46 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 
 		/* Write partial segments */
 		err = nilfs_segctor_prepare_write(sci, &failed_page);
-		if (unlikely(err))
+		if (err) {
+			nilfs_abort_logs(&sci->sc_segbufs, failed_page,
+					 sci->sc_super_root, err);
 			goto failed_to_write;
-
+		}
 		nilfs_segctor_fill_in_checksums(sci, nilfs->ns_crc_seed);
 
 		err = nilfs_segctor_write(sci, nilfs);
 		if (unlikely(err))
 			goto failed_to_write;
 
-		nilfs_segctor_complete_write(sci);
-
-		/* Commit segments */
-		if (has_sr)
-			nilfs_segctor_clear_metadata_dirty(sci);
-
-		nilfs_segctor_end_construction(sci, nilfs, 0);
-
+		if (sci->sc_stage.scnt == NILFS_ST_DONE ||
+		    nilfs->ns_blocksize_bits != PAGE_CACHE_SHIFT) {
+			/*
+			 * At this point, we avoid double buffering
+			 * for blocksize < pagesize because page dirty
+			 * flag is turned off during write and dirty
+			 * buffers are not properly collected for
+			 * pages crossing over segments.
+			 */
+			err = nilfs_segctor_wait(sci);
+			if (err)
+				goto failed_to_write;
+		}
 	} while (sci->sc_stage.scnt != NILFS_ST_DONE);
 
+	sci->sc_super_root = NULL;
+
  out:
-	nilfs_destroy_logs(&sci->sc_segbufs);
 	nilfs_segctor_check_out_files(sci, sbi);
 	return err;
 
  failed_to_write:
-	nilfs_segctor_abort_write(sci, failed_page, err);
-	nilfs_segctor_cancel_segusage(sci, nilfs->ns_sufile);
-
- failed_to_make_up:
 	if (sci->sc_stage.flags & NILFS_CF_IFILE_STARTED)
 		nilfs_redirty_inodes(&sci->sc_dirty_files);
 
  failed:
 	if (nilfs_doing_gc())
 		nilfs_redirty_inodes(&sci->sc_gc_inodes);
-	nilfs_segctor_end_construction(sci, nilfs, err);
+	nilfs_segctor_abort_construction(sci, nilfs, err);
 	goto out;
 }
 
@@ -2725,6 +2773,7 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct nilfs_sb_info *sbi)
 	spin_lock_init(&sci->sc_state_lock);
 	INIT_LIST_HEAD(&sci->sc_dirty_files);
 	INIT_LIST_HEAD(&sci->sc_segbufs);
+	INIT_LIST_HEAD(&sci->sc_write_logs);
 	INIT_LIST_HEAD(&sci->sc_gc_inodes);
 	INIT_LIST_HEAD(&sci->sc_copied_buffers);
 
@@ -2792,6 +2841,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 	}
 
 	WARN_ON(!list_empty(&sci->sc_segbufs));
+	WARN_ON(!list_empty(&sci->sc_write_logs));
 
 	down_write(&sbi->s_nilfs->ns_segctor_sem);
 
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 0d2a475..3d3ab2f 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -97,6 +97,7 @@ struct nilfs_segsum_pointer {
  * @sc_dsync_start: start byte offset of data pages
  * @sc_dsync_end: end byte offset of data pages (inclusive)
  * @sc_segbufs: List of segment buffers
+ * @sc_write_logs: List of segment buffers to hold logs under writing
  * @sc_segbuf_nblocks: Number of available blocks in segment buffers.
  * @sc_curseg: Current segment buffer
  * @sc_super_root: Pointer to the super root buffer
@@ -143,6 +144,7 @@ struct nilfs_sc_info {
 
 	/* Segment buffers */
 	struct list_head	sc_segbufs;
+	struct list_head	sc_write_logs;
 	unsigned long		sc_segbuf_nblocks;
 	struct nilfs_segment_buffer *sc_curseg;
 	struct buffer_head     *sc_super_root;
-- 
1.6.3.4
