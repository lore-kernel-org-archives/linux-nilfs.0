From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/6] nilfs2: relocate io status variables to
	segment buffer
Date: Mon, 30 Nov 2009 22:30:42 +0900
Message-ID: <1259587845-3436-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This moves io status variables in nilfs_write_info struct to
nilfs_segment_buffer struct.

This is a preparation to hide nilfs_write_info in segment buffer code.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c  |   59 +++++++++++++++++++++++++--------------------------
 fs/nilfs2/segbuf.h  |   16 ++++++-------
 fs/nilfs2/segment.c |   19 +++++++---------
 3 files changed, 44 insertions(+), 50 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index c71b689..d86056c 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -63,6 +63,11 @@ struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *sb)
 	INIT_LIST_HEAD(&segbuf->sb_list);
 	INIT_LIST_HEAD(&segbuf->sb_segsum_buffers);
 	INIT_LIST_HEAD(&segbuf->sb_payload_buffers);
+
+	init_completion(&segbuf->sb_bio_event);
+	atomic_set(&segbuf->sb_err, 0);
+	segbuf->sb_nbio = 0;
+
 	return segbuf;
 }
 
@@ -132,8 +137,6 @@ int nilfs_segbuf_reset(struct nilfs_segment_buffer *segbuf, unsigned flags,
 	segbuf->sb_sum.sumbytes = sizeof(struct nilfs_segment_summary);
 	segbuf->sb_sum.nfinfo = segbuf->sb_sum.nfileblk = 0;
 	segbuf->sb_sum.ctime = ctime;
-
-	segbuf->sb_io_error = 0;
 	return 0;
 }
 
@@ -247,7 +250,7 @@ void nilfs_release_buffers(struct list_head *list)
 static void nilfs_end_bio_write(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct nilfs_write_info *wi = bio->bi_private;
+	struct nilfs_segment_buffer *segbuf = bio->bi_private;
 
 	if (err == -EOPNOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
@@ -256,21 +259,22 @@ static void nilfs_end_bio_write(struct bio *bio, int err)
 	}
 
 	if (!uptodate)
-		atomic_inc(&wi->err);
+		atomic_inc(&segbuf->sb_err);
 
 	bio_put(bio);
-	complete(&wi->bio_event);
+	complete(&segbuf->sb_bio_event);
 }
 
-static int nilfs_submit_seg_bio(struct nilfs_write_info *wi, int mode)
+static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
+				   struct nilfs_write_info *wi, int mode)
 {
 	struct bio *bio = wi->bio;
 	int err;
 
-	if (wi->nbio > 0 && bdi_write_congested(wi->bdi)) {
-		wait_for_completion(&wi->bio_event);
-		wi->nbio--;
-		if (unlikely(atomic_read(&wi->err))) {
+	if (segbuf->sb_nbio > 0 && bdi_write_congested(wi->bdi)) {
+		wait_for_completion(&segbuf->sb_bio_event);
+		segbuf->sb_nbio--;
+		if (unlikely(atomic_read(&segbuf->sb_err))) {
 			bio_put(bio);
 			err = -EIO;
 			goto failed;
@@ -278,7 +282,7 @@ static int nilfs_submit_seg_bio(struct nilfs_write_info *wi, int mode)
 	}
 
 	bio->bi_end_io = nilfs_end_bio_write;
-	bio->bi_private = wi;
+	bio->bi_private = segbuf;
 	bio_get(bio);
 	submit_bio(mode, bio);
 	if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
@@ -286,7 +290,7 @@ static int nilfs_submit_seg_bio(struct nilfs_write_info *wi, int mode)
 		err = -EOPNOTSUPP;
 		goto failed;
 	}
-	wi->nbio++;
+	segbuf->sb_nbio++;
 	bio_put(bio);
 
 	wi->bio = NULL;
@@ -336,15 +340,12 @@ void nilfs_segbuf_prepare_write(struct nilfs_segment_buffer *segbuf,
 	wi->max_pages = bio_get_nr_vecs(wi->sb->s_bdev);
 	wi->nr_vecs = min(wi->max_pages, wi->rest_blocks);
 	wi->start = wi->end = 0;
-	wi->nbio = 0;
 	wi->blocknr = segbuf->sb_pseg_start;
-
-	atomic_set(&wi->err, 0);
-	init_completion(&wi->bio_event);
 }
 
-static int nilfs_submit_bh(struct nilfs_write_info *wi, struct buffer_head *bh,
-			   int mode)
+static int nilfs_segbuf_submit_bh(struct nilfs_segment_buffer *segbuf,
+				  struct nilfs_write_info *wi,
+				  struct buffer_head *bh, int mode)
 {
 	int len, err;
 
@@ -363,7 +364,7 @@ static int nilfs_submit_bh(struct nilfs_write_info *wi, struct buffer_head *bh,
 		return 0;
 	}
 	/* bio is FULL */
-	err = nilfs_submit_seg_bio(wi, mode);
+	err = nilfs_segbuf_submit_bio(segbuf, wi, mode);
 	/* never submit current bh */
 	if (likely(!err))
 		goto repeat;
@@ -377,13 +378,13 @@ int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 	int res = 0, rw = WRITE;
 
 	list_for_each_entry(bh, &segbuf->sb_segsum_buffers, b_assoc_buffers) {
-		res = nilfs_submit_bh(wi, bh, rw);
+		res = nilfs_segbuf_submit_bh(segbuf, wi, bh, rw);
 		if (unlikely(res))
 			goto failed_bio;
 	}
 
 	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
-		res = nilfs_submit_bh(wi, bh, rw);
+		res = nilfs_segbuf_submit_bh(segbuf, wi, bh, rw);
 		if (unlikely(res))
 			goto failed_bio;
 	}
@@ -394,7 +395,7 @@ int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 		 * submission.
 		 */
 		rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
-		res = nilfs_submit_seg_bio(wi, rw);
+		res = nilfs_segbuf_submit_bio(segbuf, wi, rw);
 	}
 
  failed_bio:
@@ -403,29 +404,27 @@ int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 
 /**
  * nilfs_segbuf_wait - wait for completion of requested BIOs
- * @wi: nilfs_write_info
+ * @segbuf: segment buffer
  *
  * Return Value: On Success, 0 is returned. On Error, one of the following
  * negative error code is returned.
  *
  * %-EIO - I/O error
  */
-int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf,
-		      struct nilfs_write_info *wi)
+int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf)
 {
 	int err = 0;
 
-	if (!wi->nbio)
+	if (!segbuf->sb_nbio)
 		return 0;
 
 	do {
-		wait_for_completion(&wi->bio_event);
-	} while (--wi->nbio > 0);
+		wait_for_completion(&segbuf->sb_bio_event);
+	} while (--segbuf->sb_nbio > 0);
 
-	if (unlikely(atomic_read(&wi->err) > 0)) {
+	if (unlikely(atomic_read(&segbuf->sb_err) > 0)) {
 		printk(KERN_ERR "NILFS: IO error writing segment\n");
 		err = -EIO;
-		segbuf->sb_io_error = 1;
 	}
 	return err;
 }
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index 0c3076f..bd076cc 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -77,7 +77,9 @@ struct nilfs_segsum_info {
  * @sb_rest_blocks: Number of residual blocks in the current segment
  * @sb_segsum_buffers: List of buffers for segment summaries
  * @sb_payload_buffers: List of buffers for segment payload
- * @sb_io_error: I/O error status
+ * @sb_nbio: Number of flying bio requests
+ * @sb_err: I/O error status
+ * @sb_bio_event: Completion event of log writing
  */
 struct nilfs_segment_buffer {
 	struct super_block     *sb_super;
@@ -96,7 +98,9 @@ struct nilfs_segment_buffer {
 	struct list_head	sb_payload_buffers; /* including super root */
 
 	/* io status */
-	int			sb_io_error;
+	int			sb_nbio;
+	atomic_t		sb_err;
+	struct completion	sb_bio_event;
 };
 
 #define NILFS_LIST_SEGBUF(head)  \
@@ -177,11 +181,6 @@ struct nilfs_write_info {
 	int			nr_vecs;
 	sector_t		blocknr;
 
-	int			nbio;
-	atomic_t		err;
-	struct completion	bio_event;
-				/* completion event of segment write */
-
 	/*
 	 * The following fields must be set explicitly
 	 */
@@ -195,7 +194,6 @@ void nilfs_segbuf_prepare_write(struct nilfs_segment_buffer *,
 				struct nilfs_write_info *);
 int nilfs_segbuf_write(struct nilfs_segment_buffer *,
 		       struct nilfs_write_info *);
-int nilfs_segbuf_wait(struct nilfs_segment_buffer *,
-		      struct nilfs_write_info *);
+int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf);
 
 #endif /* _NILFS_SEGBUF_H */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 79acf4d..cb004eb 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1382,14 +1382,14 @@ static void nilfs_segctor_free_incomplete_segments(struct nilfs_sc_info *sci,
 						   struct the_nilfs *nilfs)
 {
 	struct nilfs_segment_buffer *segbuf;
-	int ret, done = 0;
+	int ret;
 
 	segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
 	if (nilfs->ns_nextnum != segbuf->sb_nextnum) {
 		ret = nilfs_sufile_free(nilfs->ns_sufile, segbuf->sb_nextnum);
 		WARN_ON(ret); /* never fails */
 	}
-	if (segbuf->sb_io_error) {
+	if (atomic_read(&segbuf->sb_err)) {
 		/* Case 1: The first segment failed */
 		if (segbuf->sb_pseg_start != segbuf->sb_fseg_start)
 			/* Case 1a:  Partial segment appended into an existing
@@ -1398,19 +1398,16 @@ static void nilfs_segctor_free_incomplete_segments(struct nilfs_sc_info *sci,
 						segbuf->sb_fseg_end);
 		else /* Case 1b:  New full segment */
 			set_nilfs_discontinued(nilfs);
-		done++;
 	}
 
 	list_for_each_entry_continue(segbuf, &sci->sc_segbufs, sb_list) {
 		ret = nilfs_sufile_free(nilfs->ns_sufile, segbuf->sb_nextnum);
 		WARN_ON(ret); /* never fails */
-		if (!done && segbuf->sb_io_error) {
-			if (segbuf->sb_segnum != nilfs->ns_nextnum)
-				/* Case 2: extended segment (!= next) failed */
-				nilfs_sufile_set_error(nilfs->ns_sufile,
-						       segbuf->sb_segnum);
-			done++;
-		}
+		if (atomic_read(&segbuf->sb_err) &&
+		    segbuf->sb_segnum != nilfs->ns_nextnum)
+			/* Case 2: extended segment (!= next) failed */
+			nilfs_sufile_set_error(nilfs->ns_sufile,
+					       segbuf->sb_segnum);
 	}
 }
 
@@ -1801,7 +1798,7 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
 		nilfs_segbuf_prepare_write(segbuf, &wi);
 		err = nilfs_segbuf_write(segbuf, &wi);
 
-		res = nilfs_segbuf_wait(segbuf, &wi);
+		res = nilfs_segbuf_wait(segbuf);
 		err = err ? : res;
 		if (err)
 			return err;
-- 
1.6.3.4
