From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/17] dm-clone: use blkdev_issue_flush in
 commit_metadata
Date: Tue, 26 Jan 2021 15:52:36 +0100
Message-ID: <20210126145247.1964410-7-hch@lst.de>
References: <20210126145247.1964410-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:References:
 In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=KOVL9a1MkJeVtbO5wAEfyylWZoWniZN5JlBdpQ6RLVM=; b=jgfvkaYkKAMpVa1xPausRIkhgI
 J05wK5UY1q/uQpoez6gDv0Og04gI2pxLFTBRouscbtbi9Xs1DLP68AI4OGxjEAzJ6CeKc8yboBreV
 jznqw4Sk5HUgeq3Uwb1e4hjZMVG4DBVivtl1+GxtL5kLt9Vh08we0xZuIm11DXQHXWkA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=KOVL9a1MkJeVtbO5wAEfyylWZoWniZN5JlBdpQ6RLVM=; b=Iqk1FQR0xGnTT/J8drP+e7P9WW
 iPO/EvmqGkUVwGQfYB9PeEZOx09nQjJ3sfN2T776He29+LLxltTgA8D+FnJNniCASWO+zXe3XNuGQ
 Z7IlwC8ZrZ34xNwT8vsISzIySRroGY2GXpOLfZJbeJt71XXLnLHpZ/9tvtUCJmUiYgAo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=KOVL9a1MkJeVtbO5wAEfyylWZoWniZN5JlBdpQ6RLVM=; b=UXprdS/M6ExT6y8z2YkV6ntwGP
 omDC0ofe3OnxV6Yi9f2pOA923E0+NvR1wQq66SRHdZNqeVD0AQ/Acio/9Gjfz/d10FJCj/4OtjPPq
 5vLqgkQ6Gw3w0jW1aGI3RDIv1430L0ay0COX8MLA1pUbgCL2jA3OvOmmWJjwcwk2myTY7jXxTdmLj
 Mi4ZHZsF7s1B2FS9/PgBbHuju0uOmuX3pLQJDcXwpWqzfDAQIQJbd7/DZ2lCXEyuoiqh6J3yWSM10
 2Im25S5t/YszSEhuYaz0/qYB7rknN6NIVA+IhRXWoJioq0M/9ZpeFlFCgmoUfgLlfbp5pszdUTI5J
 oiwn5nvQ==;
In-Reply-To: <20210126145247.1964410-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, Naohiro Aota <naohiro.aota@wdc.com>, linux-nilfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, linux-nfs@vger.kernel.org, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Andrew Morton <akpm@linux-foundation.org>, Philipp Reisner <philipp.reisner@linbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-btrfs@vger.kernel.org

Use blkdev_issue_flush instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-clone-target.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index bdb255edc20043..a90bdf9b2ca6bd 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -85,12 +85,6 @@ struct clone {
 
 	struct dm_clone_metadata *cmd;
 
-	/*
-	 * bio used to flush the destination device, before committing the
-	 * metadata.
-	 */
-	struct bio flush_bio;
-
 	/* Region hydration hash table */
 	struct hash_table_bucket *ht;
 
@@ -1155,11 +1149,7 @@ static int commit_metadata(struct clone *clone, bool *dest_dev_flushed)
 		goto out;
 	}
 
-	bio_reset(&clone->flush_bio);
-	bio_set_dev(&clone->flush_bio, clone->dest_dev->bdev);
-	clone->flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
-
-	r = submit_bio_wait(&clone->flush_bio);
+	r = blkdev_issue_flush(clone->dest_dev->bdev);
 	if (unlikely(r)) {
 		__metadata_operation_failed(clone, "flush destination device", r);
 		goto out;
@@ -1886,7 +1876,6 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	bio_list_init(&clone->deferred_flush_completions);
 	clone->hydration_offset = 0;
 	atomic_set(&clone->hydrations_in_flight, 0);
-	bio_init(&clone->flush_bio, NULL, 0);
 
 	clone->wq = alloc_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM, 0);
 	if (!clone->wq) {
@@ -1958,7 +1947,6 @@ static void clone_dtr(struct dm_target *ti)
 	struct clone *clone = ti->private;
 
 	mutex_destroy(&clone->commit_lock);
-	bio_uninit(&clone->flush_bio);
 
 	for (i = 0; i < clone->nr_ctr_args; i++)
 		kfree(clone->ctr_args[i]);
-- 
2.29.2
