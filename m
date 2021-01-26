From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/17] nfs/blocklayout: remove cruft in
	bl_alloc_init_bio
Date: Tue, 26 Jan 2021 15:52:45 +0100
Message-ID: <20210126145247.1964410-16-hch@lst.de>
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

bio_alloc never returns NULL when it can sleep.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfs/blocklayout/blocklayout.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 3be6836074ae92..1a96ce28efb026 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -123,11 +123,6 @@ bl_alloc_init_bio(int npg, struct block_device *bdev, sector_t disk_sector,
 
 	npg = min(npg, BIO_MAX_PAGES);
 	bio = bio_alloc(GFP_NOIO, npg);
-	if (!bio && (current->flags & PF_MEMALLOC)) {
-		while (!bio && (npg /= 2))
-			bio = bio_alloc(GFP_NOIO, npg);
-	}
-
 	if (bio) {
 		bio->bi_iter.bi_sector = disk_sector;
 		bio_set_dev(bio, bdev);
-- 
2.29.2
