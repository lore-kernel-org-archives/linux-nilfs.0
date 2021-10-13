From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/29] block: use bdev_nr_sectors instead of open coding it in blkdev_fallocate
Date: Wed, 13 Oct 2021 07:10:36 +0200
Message-ID: <20211013051042.1065752-24-hch@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Jn3vPWURqTLCTgey+1ZKUDn76o/D4LziuPXo21jTcNA=; b=hRwOIaUT4TV+iuM/Zg8w7n25xq
        4JP07oWgVj96DxAIyE5GugNAoImIQjt6YOnfusnDpQHqpMzsfUUyomS23Xdp6GlGxW3N9d9yv8zRS
        Hpba9F54jbcMwbBNW8QibfhbiimOvdOmbo+bN2OBMyd97mLTimJW2mXzi7iAyeKKMK46Qo3qyEEEa
        rak7t0pG0xoWK9og1uwIKQIsTozlfX1z449iRcMhaqjTRmWD/ItgnJgiWeePTgAAgRxi2mKfmIrf0
        aPWD/qlzTxrcJbhN3jtl/ZC96e/wuQfBrUM++RgMnBjSBr/PpZLjvhZ0imDh0CcCecmWUWPsOtrDH
        PvSE0SHg==;
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 7bb9581a146cf..6e27dd2748504 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -548,7 +548,7 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 		return -EOPNOTSUPP;
 
 	/* Don't go off the end of the device. */
-	isize = i_size_read(bdev->bd_inode);
+	isize = bdev_nr_sectors(bdev) << SECTOR_SHIFT;
 	if (start >= isize)
 		return -EINVAL;
 	if (end >= isize) {
-- 
2.30.2

