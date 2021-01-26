From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/17] drbd: remove bio_alloc_drbd
Date: Tue, 26 Jan 2021 15:52:39 +0100
Message-ID: <20210126145247.1964410-10-hch@lst.de>
References: <20210126145247.1964410-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20210126145247.1964410-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, David Sterba <dsterba@suse.com>, dm-devel@redhat.com, Naohiro Aota <naohiro.aota@wdc.com>, linux-nilfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, Chao Yu <chao@kernel.org>, linux-nfs@vger.kernel.org, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, drbd-dev@tron.linbit.com, Jaegeuk Kim <jaegeuk@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Philipp Reisner <philipp.reisner@linbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-btrfs@vger.kernel.org

Given that drbd_md_io_bio_set is initialized during module initialization
and the module fails to load if the initialization fails there is no need
to fall back to plain bio_alloc.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_actlog.c |  2 +-
 drivers/block/drbd/drbd_bitmap.c |  2 +-
 drivers/block/drbd/drbd_int.h    |  2 --
 drivers/block/drbd/drbd_main.c   | 13 -------------
 4 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 7227fc7ab8ed1e..72cf7603d51fc7 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -138,7 +138,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 		op_flags |= REQ_FUA | REQ_PREFLUSH;
 	op_flags |= REQ_SYNC;
 
-	bio = bio_alloc_drbd(GFP_NOIO);
+	bio = bio_alloc_bioset(GFP_NOIO, 1, &drbd_md_io_bio_set);
 	bio_set_dev(bio, bdev->md_bdev);
 	bio->bi_iter.bi_sector = sector;
 	err = -EIO;
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index df53dca5d02c7e..c1f816f896a89a 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -976,7 +976,7 @@ static void drbd_bm_endio(struct bio *bio)
 
 static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_hold(local)
 {
-	struct bio *bio = bio_alloc_drbd(GFP_NOIO);
+	struct bio *bio = bio_alloc_bioset(GFP_NOIO, 1, &drbd_md_io_bio_set);
 	struct drbd_device *device = ctx->device;
 	struct drbd_bitmap *b = device->bitmap;
 	struct page *page;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index b2c93a29c251fd..02db50d7e4c668 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1422,8 +1422,6 @@ extern mempool_t drbd_md_io_page_pool;
 /* We also need to make sure we get a bio
  * when we need it for housekeeping purposes */
 extern struct bio_set drbd_md_io_bio_set;
-/* to allocate from that set */
-extern struct bio *bio_alloc_drbd(gfp_t gfp_mask);
 
 /* And a bio_set for cloning */
 extern struct bio_set drbd_io_bio_set;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1c8c18b2a25f33..788dd97e6026b8 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -138,19 +138,6 @@ static const struct block_device_operations drbd_ops = {
 	.release	= drbd_release,
 };
 
-struct bio *bio_alloc_drbd(gfp_t gfp_mask)
-{
-	struct bio *bio;
-
-	if (!bioset_initialized(&drbd_md_io_bio_set))
-		return bio_alloc(gfp_mask, 1);
-
-	bio = bio_alloc_bioset(gfp_mask, 1, &drbd_md_io_bio_set);
-	if (!bio)
-		return NULL;
-	return bio;
-}
-
 #ifdef __CHECKER__
 /* When checking with sparse, and this is an inline function, sparse will
    give tons of false positives. When this is a real functions sparse works.
-- 
2.29.2
