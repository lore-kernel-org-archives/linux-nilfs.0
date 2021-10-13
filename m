From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/29] drbd: use bdev_nr_sectors instead of open coding it
Date: Wed, 13 Oct 2021 07:10:15 +0200
Message-ID: <20211013051042.1065752-3-hch@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=g8zwkRt9/f1ewG9ciisUGRCziOVySw93pi5vyPemNAI=; b=nWIotL3QSRoDmvAA3o9BLxIx6i
        t4tgYxkL2iWa6feU3mcKjViBgV628kEI3j5cp2HTfHI5qbb5tmwpSC/812qJ+tIpOC0+6ZXF0Yhk1
        5/9uLY7Z9un8Zx+wYevMd9WgJEXEPd+jf99pZpD/NqPCzIY0yzkTDeFs/A7NObgO/TsPUlUm00azm
        jzgcK41A7UnRgzQeKy8vk7Tjr/8htqPY0cCKS9erTgbsPAmZcQk05o5++x3yiFcAox9+NsbnoYLD2
        XgiNG4Ra1ckwDmXmBiQEy6lDOHyfYSyUX1y5l6wMULdMarhxHkj1ybNbPpIss3/EZnwhnweR8ESQO
        YWkbaoTA==;
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_int.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 5d9181382ce19..75fda53eed8cf 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1826,8 +1826,7 @@ static inline sector_t drbd_md_last_sector(struct drbd_backing_dev *bdev)
 /* Returns the number of 512 byte sectors of the device */
 static inline sector_t drbd_get_capacity(struct block_device *bdev)
 {
-	/* return bdev ? get_capacity(bdev->bd_disk) : 0; */
-	return bdev ? i_size_read(bdev->bd_inode) >> 9 : 0;
+	return bdev ? bdev_nr_sectors(bdev) : 0;
 }
 
 /**
-- 
2.30.2

