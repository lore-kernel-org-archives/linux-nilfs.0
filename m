From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/29] bcache: remove bdev_sectors
Date: Wed, 13 Oct 2021 07:10:14 +0200
Message-ID: <20211013051042.1065752-2-hch@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=xbvviTnaXJGkyPAE7V0Wv817NIzgoLv0IeosRbA7bOI=; b=cCXjRJKxdcjkqqFc0tvMZY/a5g
        SugwD7sJZMLowObwvX/yGpnc6TGfdOSMJ5YbuJw+tYvDLJ2O2kg49Ha8EBDK43gqeY/S2IWXAhIQZ
        EJEuY4oclhtqkJ1k1mcnqXvqJUf/30M1VIxxGz+DYdVdvKizD53B8MMSsq/X00xjkl5kbeeg+gOCt
        s6EuKKNghPbrbcDFeIyNHmF8cwZ2pU47c0rHQOXRK/vgmdSUjlVwfMsyWGjLqertf2mnymuxbF2yw
        0qLbM7EpWiOLjPkaqVtW2u2CBStg5Li95sdEYkOHdAmrluetXirxJCpq8XlKOeH+eSkLmEAi+q5+m
        HjLmUUQQ==;
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.or

Use the equivalent block layer helper instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c     | 2 +-
 drivers/md/bcache/util.h      | 4 ----
 drivers/md/bcache/writeback.c | 2 +-
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f2874c77ff797..4f89985abe4b7 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1002,7 +1002,7 @@ static void calc_cached_dev_sectors(struct cache_set *c)
 	struct cached_dev *dc;
 
 	list_for_each_entry(dc, &c->cached_devs, list)
-		sectors += bdev_sectors(dc->bdev);
+		sectors += bdev_nr_sectors(dc->bdev);
 
 	c->cached_dev_sectors = sectors;
 }
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index b64460a762677..a7da7930a7fda 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -584,8 +584,4 @@ static inline unsigned int fract_exp_two(unsigned int x,
 void bch_bio_map(struct bio *bio, void *base);
 int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp_mask);
 
-static inline sector_t bdev_sectors(struct block_device *bdev)
-{
-	return bdev->bd_inode->i_size >> 9;
-}
 #endif /* _BCACHE_UTIL_H */
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 8120da278161e..c7560f66dca88 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -45,7 +45,7 @@ static uint64_t __calc_target_rate(struct cached_dev *dc)
 	 * backing volume uses about 2% of the cache for dirty data.
 	 */
 	uint32_t bdev_share =
-		div64_u64(bdev_sectors(dc->bdev) << WRITEBACK_SHARE_SHIFT,
+		div64_u64(bdev_nr_sectors(dc->bdev) << WRITEBACK_SHARE_SHIFT,
 				c->cached_dev_sectors);
 
 	uint64_t cache_dirty_target =
-- 
2.30.2

