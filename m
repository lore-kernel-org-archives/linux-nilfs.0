From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/3] nilfs2: get rid of nilfs_segctor_req struct
Date: Wed, 10 Feb 2010 00:46:21 +0900
Message-ID: <1265730383-31290-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1265730383-31290-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1265730383-31290-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This will clean up nilfs_segctor_req struct and the obscure request
argument passed among private methods of segment constructor.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c |   79 ++++++++++++++++++++++++--------------------------
 fs/nilfs2/segment.h |    2 +
 2 files changed, 40 insertions(+), 41 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index ab439a7..fa4abfc 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2425,43 +2425,43 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	return err;
 }
 
-struct nilfs_segctor_req {
-	int mode;
-	__u32 seq_accepted;
-	int sc_err;  /* construction failure */
-	int sb_err;  /* super block writeback failure */
-};
-
 #define FLUSH_FILE_BIT	(0x1) /* data file only */
 #define FLUSH_DAT_BIT	(1 << NILFS_DAT_INO) /* DAT only */
 
-static void nilfs_segctor_accept(struct nilfs_sc_info *sci,
-				 struct nilfs_segctor_req *req)
+/**
+ * nilfs_segctor_accept - record accepted sequence count of log-write requests
+ * @sci: segment constructor object
+ */
+static void nilfs_segctor_accept(struct nilfs_sc_info *sci)
 {
-	req->sc_err = req->sb_err = 0;
 	spin_lock(&sci->sc_state_lock);
-	req->seq_accepted = sci->sc_seq_request;
+	sci->sc_seq_accepted = sci->sc_seq_request;
 	spin_unlock(&sci->sc_state_lock);
 
 	if (sci->sc_timer)
 		del_timer_sync(sci->sc_timer);
 }
 
-static void nilfs_segctor_notify(struct nilfs_sc_info *sci,
-				 struct nilfs_segctor_req *req)
+/**
+ * nilfs_segctor_notify - notify the result of request to caller threads
+ * @sci: segment constructor object
+ * @mode: mode of log forming
+ * @err: error code to be notified
+ */
+static void nilfs_segctor_notify(struct nilfs_sc_info *sci, int mode, int err)
 {
 	/* Clear requests (even when the construction failed) */
 	spin_lock(&sci->sc_state_lock);
 
-	if (req->mode == SC_LSEG_SR) {
+	if (mode == SC_LSEG_SR) {
 		sci->sc_state &= ~NILFS_SEGCTOR_COMMIT;
-		sci->sc_seq_done = req->seq_accepted;
-		nilfs_segctor_wakeup(sci, req->sc_err ? : req->sb_err);
+		sci->sc_seq_done = sci->sc_seq_accepted;
+		nilfs_segctor_wakeup(sci, err);
 		sci->sc_flush_request = 0;
 	} else {
-		if (req->mode == SC_FLUSH_FILE)
+		if (mode == SC_FLUSH_FILE)
 			sci->sc_flush_request &= ~FLUSH_FILE_BIT;
-		else if (req->mode == SC_FLUSH_DAT)
+		else if (mode == SC_FLUSH_DAT)
 			sci->sc_flush_request &= ~FLUSH_DAT_BIT;
 
 		/* re-enable timer if checkpoint creation was not done */
@@ -2472,30 +2472,37 @@ static void nilfs_segctor_notify(struct nilfs_sc_info *sci,
 	spin_unlock(&sci->sc_state_lock);
 }
 
-static int nilfs_segctor_construct(struct nilfs_sc_info *sci,
-				   struct nilfs_segctor_req *req)
+/**
+ * nilfs_segctor_construct - form logs and write them to disk
+ * @sci: segment constructor object
+ * @mode: mode of log forming
+ */
+static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 {
 	struct nilfs_sb_info *sbi = sci->sc_sbi;
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	int err = 0;
 
+	nilfs_segctor_accept(sci);
+
 	if (nilfs_discontinued(nilfs))
-		req->mode = SC_LSEG_SR;
-	if (!nilfs_segctor_confirm(sci)) {
-		err = nilfs_segctor_do_construct(sci, req->mode);
-		req->sc_err = err;
-	}
+		mode = SC_LSEG_SR;
+	if (!nilfs_segctor_confirm(sci))
+		err = nilfs_segctor_do_construct(sci, mode);
+
 	if (likely(!err)) {
-		if (req->mode != SC_FLUSH_DAT)
+		if (mode != SC_FLUSH_DAT)
 			atomic_set(&nilfs->ns_ndirtyblks, 0);
 		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
 		    nilfs_discontinued(nilfs)) {
 			down_write(&nilfs->ns_sem);
-			req->sb_err = nilfs_commit_super(sbi,
-					nilfs_altsb_need_update(nilfs));
+			err = nilfs_commit_super(
+				sbi, nilfs_altsb_need_update(nilfs));
 			up_write(&nilfs->ns_sem);
 		}
 	}
+
+	nilfs_segctor_notify(sci, mode, err);
 	return err;
 }
 
@@ -2526,7 +2533,6 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 	struct nilfs_sc_info *sci = NILFS_SC(sbi);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct nilfs_transaction_info ti;
-	struct nilfs_segctor_req req = { .mode = SC_LSEG_SR };
 	int err;
 
 	if (unlikely(!sci))
@@ -2547,10 +2553,8 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 	list_splice_tail_init(&nilfs->ns_gc_inodes, &sci->sc_gc_inodes);
 
 	for (;;) {
-		nilfs_segctor_accept(sci, &req);
-		err = nilfs_segctor_construct(sci, &req);
+		err = nilfs_segctor_construct(sci, SC_LSEG_SR);
 		nilfs_remove_written_gcinodes(nilfs, &sci->sc_gc_inodes);
-		nilfs_segctor_notify(sci, &req);
 
 		if (likely(!err))
 			break;
@@ -2583,13 +2587,9 @@ static void nilfs_segctor_thread_construct(struct nilfs_sc_info *sci, int mode)
 {
 	struct nilfs_sb_info *sbi = sci->sc_sbi;
 	struct nilfs_transaction_info ti;
-	struct nilfs_segctor_req req = { .mode = mode };
 
 	nilfs_transaction_lock(sbi, &ti, 0);
-
-	nilfs_segctor_accept(sci, &req);
-	nilfs_segctor_construct(sci, &req);
-	nilfs_segctor_notify(sci, &req);
+	nilfs_segctor_construct(sci, mode);
 
 	/*
 	 * Unclosed segment should be retried.  We do this using sc_timer.
@@ -2807,12 +2807,9 @@ static void nilfs_segctor_write_out(struct nilfs_sc_info *sci)
 	do {
 		struct nilfs_sb_info *sbi = sci->sc_sbi;
 		struct nilfs_transaction_info ti;
-		struct nilfs_segctor_req req = { .mode = SC_LSEG_SR };
 
 		nilfs_transaction_lock(sbi, &ti, 0);
-		nilfs_segctor_accept(sci, &req);
-		ret = nilfs_segctor_construct(sci, &req);
-		nilfs_segctor_notify(sci, &req);
+		ret = nilfs_segctor_construct(sci, SC_LSEG_SR);
 		nilfs_transaction_unlock(sbi);
 
 	} while (ret && retrycount-- > 0);
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 3d3ab2f..3155e0c 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -116,6 +116,7 @@ struct nilfs_segsum_pointer {
  * @sc_wait_daemon: Daemon wait queue
  * @sc_wait_task: Start/end wait queue to control segctord task
  * @sc_seq_request: Request counter
+ * @sc_seq_accept: Accepted request count
  * @sc_seq_done: Completion counter
  * @sc_sync: Request of explicit sync operation
  * @sc_interval: Timeout value of background construction
@@ -169,6 +170,7 @@ struct nilfs_sc_info {
 	wait_queue_head_t	sc_wait_task;
 
 	__u32			sc_seq_request;
+	__u32			sc_seq_accepted;
 	__u32			sc_seq_done;
 
 	int			sc_sync;
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
