From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/17] md: remove md_bio_alloc_sync
Date: Tue, 26 Jan 2021 15:52:43 +0100
Message-ID: <20210126145247.1964410-14-hch@lst.de>
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

md_bio_alloc_sync is never called with a NULL mddev, and ->sync_set is
initialized in md_run, so it always must be initialized as well.  Just
open code the remaining call to bio_alloc_bioset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6a27f52007c871..399c81bddc1ae1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -340,14 +340,6 @@ static int start_readonly;
  */
 static bool create_on_open = true;
 
-static struct bio *md_bio_alloc_sync(struct mddev *mddev)
-{
-	if (!mddev || !bioset_initialized(&mddev->sync_set))
-		return bio_alloc(GFP_NOIO, 1);
-
-	return bio_alloc_bioset(GFP_NOIO, 1, &mddev->sync_set);
-}
-
 /*
  * We have a system wide 'event count' that is incremented
  * on any 'interesting' event, and readers of /proc/mdstat
@@ -989,7 +981,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	if (test_bit(Faulty, &rdev->flags))
 		return;
 
-	bio = md_bio_alloc_sync(mddev);
+	bio = bio_alloc_bioset(GFP_NOIO, 1, &mddev->sync_set);
 
 	atomic_inc(&rdev->nr_pending);
 
-- 
2.29.2
