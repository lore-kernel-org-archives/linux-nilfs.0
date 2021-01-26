From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/17] md: remove bio_alloc_mddev
Date: Tue, 26 Jan 2021 15:52:41 +0100
Message-ID: <20210126145247.1964410-12-hch@lst.de>
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

bio_alloc_mddev is never called with a NULL mddev, and ->bio_set is
initialized in md_run, so it always must be initialized as well.  Just
open code the remaining call to bio_alloc_bioset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c     | 12 +-----------
 drivers/md/md.h     |  2 --
 drivers/md/raid1.c  |  2 +-
 drivers/md/raid10.c |  2 +-
 4 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7d1bb24add3107..e2b9dbb6e888f6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -340,16 +340,6 @@ static int start_readonly;
  */
 static bool create_on_open = true;
 
-struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
-			    struct mddev *mddev)
-{
-	if (!mddev || !bioset_initialized(&mddev->bio_set))
-		return bio_alloc(gfp_mask, nr_iovecs);
-
-	return bio_alloc_bioset(gfp_mask, nr_iovecs, &mddev->bio_set);
-}
-EXPORT_SYMBOL_GPL(bio_alloc_mddev);
-
 static struct bio *md_bio_alloc_sync(struct mddev *mddev)
 {
 	if (!mddev || !bioset_initialized(&mddev->sync_set))
@@ -613,7 +603,7 @@ static void submit_flushes(struct work_struct *ws)
 			atomic_inc(&rdev->nr_pending);
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
-			bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
+			bi = bio_alloc_bioset(GFP_NOIO, 0, &mddev->bio_set);
 			bi->bi_end_io = md_end_flush;
 			bi->bi_private = rdev;
 			bio_set_dev(bi, rdev->bdev);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f13290ccc1c248..bcbba1b5ec4a71 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -742,8 +742,6 @@ extern void md_rdev_clear(struct md_rdev *rdev);
 extern void md_handle_request(struct mddev *mddev, struct bio *bio);
 extern void mddev_suspend(struct mddev *mddev);
 extern void mddev_resume(struct mddev *mddev);
-extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
-				   struct mddev *mddev);
 
 extern void md_reload_sb(struct mddev *mddev, int raid_disk);
 extern void md_update_sb(struct mddev *mddev, int force);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3b19141cdb4bc2..d2378765dc154f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1104,7 +1104,7 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 	int i = 0;
 	struct bio *behind_bio = NULL;
 
-	behind_bio = bio_alloc_mddev(GFP_NOIO, vcnt, r1_bio->mddev);
+	behind_bio = bio_alloc_bioset(GFP_NOIO, vcnt, &r1_bio->mddev->bio_set);
 	if (!behind_bio)
 		return;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index be8f14afb6d143..e1eefbec15d444 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4531,7 +4531,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		return sectors_done;
 	}
 
-	read_bio = bio_alloc_mddev(GFP_KERNEL, RESYNC_PAGES, mddev);
+	read_bio = bio_alloc_bioset(GFP_KERNEL, RESYNC_PAGES, &mddev->bio_set);
 
 	bio_set_dev(read_bio, rdev->bdev);
 	read_bio->bi_iter.bi_sector = (r10_bio->devs[r10_bio->read_slot].addr
-- 
2.29.2
