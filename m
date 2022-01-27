From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 9/9] Remove congestion tracking framework.
Date: Thu, 27 Jan 2022 13:46:29 +1100
Message-ID: <164325158960.29787.17588717894058708630.stgit@noble.brown>
References: <164325106958.29787.4865219843242892726.stgit@noble.brown>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643251787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OVO5L5oh76QqfW3n1oDvBos2Yawv0E43OsrqMmz97u8=;
        b=JOFvU7iAGyn/v6BD3Bp+bh089vjSIxSCwY01PObM+BmenfkUZ1j2GJfL9RHxbWRZM/l98u
        qo/UEFC5lfk1D4MRdyMUcjwh6hIji/NTYfIRlm9cB6k65ocg8RHieVXuXzdIix2W/WWAJB
        +fCFtWOMn+6HtfPTgy8eWKnyVdE1o0E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643251787;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OVO5L5oh76QqfW3n1oDvBos2Yawv0E43OsrqMmz97u8=;
        b=IBhAkB2hVQaF92fXW6Y2P175TbQ6CFUUnjY/M7g7xzSXg9kQBD90kXkX3iZRhhBhPwaHez
        ofEg50iSvDeTM4BA==
In-Reply-To: <164325106958.29787.4865219843242892726.stgit-KMjKAoDPBoBHWa5fdsenEw@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This framework is no longer used - so discard it.

Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
---
 include/linux/backing-dev-defs.h |    8 -----
 include/linux/backing-dev.h      |    2 -
 include/trace/events/writeback.h |   28 -------------------
 mm/backing-dev.c                 |   57 --------------------------------------
 4 files changed, 95 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 993c5628a726..e863c88df95f 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -207,14 +207,6 @@ struct backing_dev_info {
 #endif
 };
 
-enum {
-	BLK_RW_ASYNC	= 0,
-	BLK_RW_SYNC	= 1,
-};
-
-void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
-void set_bdi_congested(struct backing_dev_info *bdi, int sync);
-
 struct wb_lock_cookie {
 	bool locked;
 	unsigned long flags;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 2d764566280c..87ce24d238f3 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -135,8 +135,6 @@ static inline bool writeback_in_progress(struct bdi_writeback *wb)
 
 struct backing_dev_info *inode_to_bdi(struct inode *inode);
 
-long congestion_wait(int sync, long timeout);
-
 static inline bool mapping_can_writeback(struct address_space *mapping)
 {
 	return inode_to_bdi(mapping->host)->capabilities & BDI_CAP_WRITEBACK;
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index a345b1e12daf..86b2a82da546 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -735,34 +735,6 @@ TRACE_EVENT(writeback_sb_inodes_requeue,
 	)
 );
 
-DECLARE_EVENT_CLASS(writeback_congest_waited_template,
-
-	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
-
-	TP_ARGS(usec_timeout, usec_delayed),
-
-	TP_STRUCT__entry(
-		__field(	unsigned int,	usec_timeout	)
-		__field(	unsigned int,	usec_delayed	)
-	),
-
-	TP_fast_assign(
-		__entry->usec_timeout	= usec_timeout;
-		__entry->usec_delayed	= usec_delayed;
-	),
-
-	TP_printk("usec_timeout=%u usec_delayed=%u",
-			__entry->usec_timeout,
-			__entry->usec_delayed)
-);
-
-DEFINE_EVENT(writeback_congest_waited_template, writeback_congestion_wait,
-
-	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
-
-	TP_ARGS(usec_timeout, usec_delayed)
-);
-
 DECLARE_EVENT_CLASS(writeback_single_inode_template,
 
 	TP_PROTO(struct inode *inode,
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index eae96dfe0261..7176af65b103 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1005,60 +1005,3 @@ const char *bdi_dev_name(struct backing_dev_info *bdi)
 	return bdi->dev_name;
 }
 EXPORT_SYMBOL_GPL(bdi_dev_name);
-
-static wait_queue_head_t congestion_wqh[2] = {
-		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[0]),
-		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[1])
-	};
-static atomic_t nr_wb_congested[2];
-
-void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
-{
-	wait_queue_head_t *wqh = &congestion_wqh[sync];
-	enum wb_congested_state bit;
-
-	bit = sync ? WB_sync_congested : WB_async_congested;
-	if (test_and_clear_bit(bit, &bdi->wb.congested))
-		atomic_dec(&nr_wb_congested[sync]);
-	smp_mb__after_atomic();
-	if (waitqueue_active(wqh))
-		wake_up(wqh);
-}
-EXPORT_SYMBOL(clear_bdi_congested);
-
-void set_bdi_congested(struct backing_dev_info *bdi, int sync)
-{
-	enum wb_congested_state bit;
-
-	bit = sync ? WB_sync_congested : WB_async_congested;
-	if (!test_and_set_bit(bit, &bdi->wb.congested))
-		atomic_inc(&nr_wb_congested[sync]);
-}
-EXPORT_SYMBOL(set_bdi_congested);
-
-/**
- * congestion_wait - wait for a backing_dev to become uncongested
- * @sync: SYNC or ASYNC IO
- * @timeout: timeout in jiffies
- *
- * Waits for up to @timeout jiffies for a backing_dev (any backing_dev) to exit
- * write congestion.  If no backing_devs are congested then just wait for the
- * next write to be completed.
- */
-long congestion_wait(int sync, long timeout)
-{
-	long ret;
-	unsigned long start = jiffies;
-	DEFINE_WAIT(wait);
-	wait_queue_head_t *wqh = &congestion_wqh[sync];
-
-	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
-	ret = io_schedule_timeout(timeout);
-	finish_wait(wqh, &wait);
-
-	trace_writeback_congestion_wait(jiffies_to_usecs(timeout),
-					jiffies_to_usecs(jiffies - start));
-
-	return ret;
-}
-EXPORT_SYMBOL(congestion_wait);


