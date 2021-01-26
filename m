From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/17] drbd: remove drbd_req_make_private_bio
Date: Tue, 26 Jan 2021 15:52:40 +0100
Message-ID: <20210126145247.1964410-11-hch@lst.de>
References: <20210126145247.1964410-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=jUX/nPv36iBJWdAHLrELJid7jXvEdNR6cRFF7NPxZ3A=; b=IpTioxravckm1qWlFlhuTXqcRU
        NUrQRXmnYaUUkiw+vad9k9lpdmMyYrpgXEgukSClL8PPJYRMAlC6PbXKGyHzkg4QgCq5ytPbIctU0
        Wu+AAg1vTUjodle4xRBeGFJxUuV90SjBomvdcXWoLsGxNckVxTg/NO0lV2QQg3NnOBl2C8ucoaGEh
        e1e0LT8AvFm3CKPyjDORVskFTIoraKd9UA3fA3R7jCx0mHdzlJoYhJv4fTxkNjiCdEnjZjfhVcdEP
        wpDTJ0dmomAG1DDIPybWzoJF6Nb0MGrzyoAKs8QVsymaQzhznpqBFzqeBp8JY+LKtIDBeAIgk0+OS
        j0VgL1sQ==;
In-Reply-To: <20210126145247.1964410-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Damien Le Moal <damien.lemoal@wdc.com>, Naohiro Aota <naohiro.aota@wdc.com>, Andrew Morton <akpm@linux-foundation.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-nilfs@vger.kernel.org, dm-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org

Open code drbd_req_make_private_bio in the two callers to prepare
for further changes.  Also don't bother to initialize bi_next as the
bio code already does that that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_req.c    |  5 ++++-
 drivers/block/drbd/drbd_req.h    | 12 ------------
 drivers/block/drbd/drbd_worker.c |  5 ++++-
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index ea0f31ab334361..9dbb660a7d7c8e 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -30,7 +30,10 @@ static struct drbd_request *drbd_req_new(struct drbd_device *device, struct bio
 		return NULL;
 	memset(req, 0, sizeof(*req));
 
-	drbd_req_make_private_bio(req, bio_src);
+	req->private_bio = bio_clone_fast(bio_src, GFP_NOIO, &drbd_io_bio_set);
+	req->private_bio->bi_private = req;
+	req->private_bio->bi_end_io = drbd_request_endio;
+
 	req->rq_state = (bio_data_dir(bio_src) == WRITE ? RQ_WRITE : 0)
 		      | (bio_op(bio_src) == REQ_OP_WRITE_SAME ? RQ_WSAME : 0)
 		      | (bio_op(bio_src) == REQ_OP_WRITE_ZEROES ? RQ_ZEROES : 0)
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 55bb0f8721faa3..511f39a08de453 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -256,18 +256,6 @@ enum drbd_req_state_bits {
 #define MR_WRITE       1
 #define MR_READ        2
 
-static inline void drbd_req_make_private_bio(struct drbd_request *req, struct bio *bio_src)
-{
-	struct bio *bio;
-	bio = bio_clone_fast(bio_src, GFP_NOIO, &drbd_io_bio_set);
-
-	req->private_bio = bio;
-
-	bio->bi_private  = req;
-	bio->bi_end_io   = drbd_request_endio;
-	bio->bi_next     = NULL;
-}
-
 /* Short lived temporary struct on the stack.
  * We could squirrel the error to be returned into
  * bio->bi_iter.bi_size, or similar. But that would be too ugly. */
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 02044ab7f767d5..64563bfdf0da02 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1523,8 +1523,11 @@ int w_restart_disk_io(struct drbd_work *w, int cancel)
 	if (bio_data_dir(req->master_bio) == WRITE && req->rq_state & RQ_IN_ACT_LOG)
 		drbd_al_begin_io(device, &req->i);
 
-	drbd_req_make_private_bio(req, req->master_bio);
+	req->private_bio = bio_clone_fast(req->master_bio, GFP_NOIO,
+					  &drbd_io_bio_set);
 	bio_set_dev(req->private_bio, device->ldev->backing_bdev);
+	req->private_bio->bi_private = req;
+	req->private_bio->bi_end_io = drbd_request_endio;
 	submit_bio_noacct(req->private_bio);
 
 	return 0;
-- 
2.29.2

