From: NeilBrown <neilb@suse.de>
Subject: [PATCH 03/11] MM: improve cleanup when ->readpages doesn't process
 all pages.
Date: Tue, 22 Feb 2022 14:17:17 +1100
Message-ID: <164549983736.9187.16755913785880819183.stgit@noble.brown>
References: <164549971112.9187.16871723439770288255.stgit@noble.brown>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645499913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dxMNB30lzl6BwAspjhyrqZOLtIFrR9DXCk9OQJHPtUY=;
        b=W7ebGdMAlezFqBmfhUhJtFLKOkWJeos9pQHX2grBMDLkQg4vopHgKFVTPQqtciX/3uFXle
        LS7sGhVKANsry9bX1t+C90K8NvDOgUWBOJdfcsjev7nJWmTO6WYZvG1tAfszx73V8g317v
        IPQ6JQNv6q0a7ebKuPJwoY3rm6bp6Jg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645499913;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dxMNB30lzl6BwAspjhyrqZOLtIFrR9DXCk9OQJHPtUY=;
        b=G7n/l/aOQFd/9dtTrzc2aloiCvbC6lUJXd2tD1UOdI3tXRXAymBbJgRLyF1oHS6++KH8Ts
        e4yVYzL7OFocyEBw==
In-Reply-To: <164549971112.9187.16871723439770288255.stgit@noble.brown>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org

If ->readpages doesn't process all the pages, then it is best to act as
though they weren't requested so that a subsequent readahead can try
again.
So:
  - remove any 'ahead' pages from the page cache so they can be loaded
    with ->readahead() rather then multiple ->read()s
  - update the file_ra_state to reflect the reads that were actually
    submitted.

This allows ->readpages() to abort early due e.g.  to congestion, which
will then allow us to remove the inode_read_congested() test from
page_Cache_async_ra().

Signed-off-by: NeilBrown <neilb@suse.de>
---
 mm/readahead.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 73b2bc5302e0..8a97bd408cf6 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -104,7 +104,13 @@
  * for necessary resources (e.g.  memory or indexing information) to
  * become available.  Pages in the final ``async_size`` may be
  * considered less urgent and failure to read them is more acceptable.
- * They will eventually be read individually using ->readpage().
+ * In this case it is best to use delete_from_page_cache() to remove the
+ * pages from the page cache as is automatically done for pages that
+ * were not fetched with readahead_page().  This will allow a
+ * subsequent synchronous read ahead request to try them again.  If they
+ * are left in the page cache, then they will be read individually using
+ * ->readpage().
+ *
  */
 
 #include <linux/kernel.h>
@@ -226,8 +232,17 @@ static void read_pages(struct readahead_control *rac, struct list_head *pages,
 
 	if (aops->readahead) {
 		aops->readahead(rac);
-		/* Clean up the remaining pages */
+		/*
+		 * Clean up the remaining pages.  The sizes in ->ra
+		 * maybe be used to size next read-ahead, so make sure
+		 * they accurately reflect what happened.
+		 */
 		while ((page = readahead_page(rac))) {
+			rac->ra->size -= 1;
+			if (rac->ra->async_size > 0) {
+				rac->ra->async_size -= 1;
+				delete_from_page_cache(page);
+			}
 			unlock_page(page);
 			put_page(page);
 		}


