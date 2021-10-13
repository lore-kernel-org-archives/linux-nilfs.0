From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/29] fs: use bdev_nr_sectors instead of open coding it in blkdev_max_block
Date: Wed, 13 Oct 2021 07:10:21 +0200
Message-ID: <20211013051042.1065752-9-hch@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=TaHNzTEbIlyf8VXszJ+3gUpeBMoLxyPeY6M0WbLeJoE=; b=E+78EEJ2GHUy8Hk4P4DcOEjmwX
        HIQ2kNmA3WYxpDbTzgmiYyRL2xWCpSEifFW8boMSUF/sGaztAh3FbTDSkpa8miOFEZFNArrh9A/Ki
        peiQ6gNWuohYoOYEJ2aeJhiJkXX+ruL0fTrfijH7xWchqQ4kexPkIoSShXoyh6yHu37hoO2fDKYzY
        +yS55l1rIobhbkKzjv6H80Q2JgO7oc8Y8RPhkmll4qN72NgoDdwUDfEOxrfgtQZOXfF2S8EnoANXq
        9aLLxZ52YRtDKUJr7TbTHvQ6wCqBdpgppsBYsyqry+UY++1dQpz1Bq7l0+coY3Sl5L/KV8yTCbJYt
        jIiTKAGQ==;
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c615387aedcae..3fb9c5b457ab6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -878,7 +878,7 @@ link_dev_buffers(struct page *page, struct buffer_head *head)
 static sector_t blkdev_max_block(struct block_device *bdev, unsigned int size)
 {
 	sector_t retval = ~((sector_t)0);
-	loff_t sz = i_size_read(bdev->bd_inode);
+	loff_t sz = bdev_nr_sectors(bdev) << SECTOR_SHIFT;
 
 	if (sz) {
 		unsigned int sizebits = blksize_bits(size);
-- 
2.30.2

