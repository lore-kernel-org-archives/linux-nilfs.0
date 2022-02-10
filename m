From: NeilBrown <neilb@suse.de>
Subject: [PATCH 04/11] fuse: remove reliance on bdi congestion
Date: Thu, 10 Feb 2022 16:37:52 +1100
Message-ID: <164447147258.23354.13665933242616399479.stgit@noble.brown>
References: <164447124918.23354.17858831070003318849.stgit@noble.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version
 :References:In-Reply-To:Message-ID:Date:Cc:To:From:Subject:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=j2iKmKfQAV47ltxyUTpJL5kF151jPpkpJZBMxZj0hPA=; b=F4Q3AuEQiBarXHhzGL9WUz1PKm
 MGl3XtCTYa6fRBGzJcEKMQ+P/7LLXN/QGizGswWWjDt75ZzrIrMBn2DyAmLcyDIiVjF4on08oR3d5
 7g/LZOuExwvQBK86GHXJ0YxxiX0muVe4I3MUr9RHdbQ1a4ejgHRWa1jiBk6Egjv8sjtY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
 In-Reply-To:Message-ID:Date:Cc:To:From:Subject:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=j2iKmKfQAV47ltxyUTpJL5kF151jPpkpJZBMxZj0hPA=; b=NqYViWD1/kiFuUTqQLPoQY/Shl
 WxeIPAVgyywh2fNtZDfsSbY5OiET9vqmlnW8SQoIStJuZ2kyJZBtdrP28D08RcJT2yVXaYBec4S8o
 7sU7lBhJWUcH/HaDuB7SUY73EXj5Egkmy9iS+PYs3It1JSMAHmLJlua/ymvHk7W5uTPE=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1644471559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=j2iKmKfQAV47ltxyUTpJL5kF151jPpkpJZBMxZj0hPA=;
 b=uKgETFLiX7EG3eRXPuLaRXJzGwKmI41Y099K5XW1KSBpIkvAtu7aaGjeLAQGXG8TUQFaYO
 OMbK9eXz4PZqR02yAAtlGS6TlPoP/iTMR8GqWOZjaexFnysfcGLyRc7rr/3yf9JBO9+gKt
 oZC/hm6/xktjcHUh7EOUlnr9KfhiLHA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1644471559;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=j2iKmKfQAV47ltxyUTpJL5kF151jPpkpJZBMxZj0hPA=;
 b=tFH7OafqVWs9TyFo1hmlUCp9XAM4aJZnlfF1apQOnbWq4IG7Y1nuHRPilxWK+gi9ecSy8b
 ySE9dRcAQmytzwCw==
In-Reply-To: <164447124918.23354.17858831070003318849.stgit@noble.brown>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, drbd-dev@lists.linbit.com

The bdi congestion tracking in not widely used and will be removed.

Fuse is one of a small number of filesystems that uses it, setting both
the sync (read) and async (write) congestion flags at what it determines
are appropriate times.

The only remaining effect of the sync flag is to cause read-ahead to be
skipped.
The only remaining effect of the async flag is to cause (some)
WB_SYNC_NONE writes to be skipped.

So instead of setting the flags, change:
 - .readahead to stop when it has submitted all non-async pages
    for read.
 - .writepages to do nothing if WB_SYNC_NONE and the flag would be set
 - .writepage to return AOP_WRITEPAGE_ACTIVATE if WB_SYNC_NONE
    and the flag would be set.

The writepages change causes a behavioural change in that pageout() can
now return PAGE_ACTIVATE instead of PAGE_KEEP, so SetPageActive() will
be called on the page which (I think) will further delay the next attempt
at writeout.  This might be a good thing.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/fuse/control.c |   17 -----------------
 fs/fuse/dev.c     |    8 --------
 fs/fuse/file.c    |   17 +++++++++++++++++
 3 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 000d2e5627e9..7cede9a3bc96 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -164,7 +164,6 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
 {
 	unsigned val;
 	struct fuse_conn *fc;
-	struct fuse_mount *fm;
 	ssize_t ret;
 
 	ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
@@ -178,22 +177,6 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
 	down_read(&fc->killsb);
 	spin_lock(&fc->bg_lock);
 	fc->congestion_threshold = val;
-
-	/*
-	 * Get any fuse_mount belonging to this fuse_conn; s_bdi is
-	 * shared between all of them
-	 */
-
-	if (!list_empty(&fc->mounts)) {
-		fm = list_first_entry(&fc->mounts, struct fuse_mount, fc_entry);
-		if (fc->num_background < fc->congestion_threshold) {
-			clear_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
-			clear_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
-		} else {
-			set_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
-			set_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
-		}
-	}
 	spin_unlock(&fc->bg_lock);
 	up_read(&fc->killsb);
 	fuse_conn_put(fc);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index cd54a529460d..e1b4a846c90d 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -315,10 +315,6 @@ void fuse_request_end(struct fuse_req *req)
 				wake_up(&fc->blocked_waitq);
 		}
 
-		if (fc->num_background == fc->congestion_threshold && fm->sb) {
-			clear_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
-			clear_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
-		}
 		fc->num_background--;
 		fc->active_background--;
 		flush_bg_queue(fc);
@@ -540,10 +536,6 @@ static bool fuse_request_queue_background(struct fuse_req *req)
 		fc->num_background++;
 		if (fc->num_background == fc->max_background)
 			fc->blocked = 1;
-		if (fc->num_background == fc->congestion_threshold && fm->sb) {
-			set_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
-			set_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
-		}
 		list_add_tail(&req->list, &fc->bg_queue);
 		flush_bg_queue(fc);
 		queued = true;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 829094451774..94747bac3489 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -966,6 +966,14 @@ static void fuse_readahead(struct readahead_control *rac)
 		struct fuse_io_args *ia;
 		struct fuse_args_pages *ap;
 
+		if (fc->num_background >= fc->congestion_threshold &&
+		    rac->ra->async_size >= readahead_count(rac))
+			/*
+			 * Congested and only async pages left, so skip the
+			 * rest.
+			 */
+			break;
+
 		nr_pages = readahead_count(rac) - nr_pages;
 		if (nr_pages > max_pages)
 			nr_pages = max_pages;
@@ -1958,6 +1966,7 @@ static int fuse_writepage_locked(struct page *page)
 
 static int fuse_writepage(struct page *page, struct writeback_control *wbc)
 {
+	struct fuse_conn *fc = get_fuse_conn(page->mapping->host);
 	int err;
 
 	if (fuse_page_is_writeback(page->mapping->host, page->index)) {
@@ -1973,6 +1982,10 @@ static int fuse_writepage(struct page *page, struct writeback_control *wbc)
 		return 0;
 	}
 
+	if (wbc->sync_mode == WB_SYNC_NONE &&
+	    fc->num_background >= fc->congestion_threshold)
+		return AOP_WRITEPAGE_ACTIVATE;
+
 	err = fuse_writepage_locked(page);
 	unlock_page(page);
 
@@ -2226,6 +2239,10 @@ static int fuse_writepages(struct address_space *mapping,
 	if (fuse_is_bad(inode))
 		goto out;
 
+	if (wbc->sync_mode == WB_SYNC_NONE &&
+	    fc->num_background >= fc->congestion_threshold)
+		return 0;
+
 	data.inode = inode;
 	data.wpa = NULL;
 	data.ff = NULL;
