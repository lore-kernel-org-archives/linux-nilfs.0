From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/30] drbd: use bdev_nr_sectors instead of open coding it
Date: Fri, 15 Oct 2021 15:26:17 +0200
Message-ID: <20211015132643.1621913-5-hch@lst.de>
References: <20211015132643.1621913-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=sRz3ktGyKoN3l7m+veOu47xjytoh4FxLpztSQgTc2E4=; b=2Hl1p/KJtE+43LsxTKrPI56Tp8
        Z1u+/nKEpjLeDRsVPz1SlqoWGEAiGFveyGkqNqrDzwiS8vMbIEnifQ9GKxFW4loCtgmo6f/H29/3P
        AK5NgH4FJfKgTpOGnPNqvOG5Jo7ina885H6Jio3wLA9OoS7K7N2U8G6RoDNn1rlPvWuSwFnf3fXYP
        9bl6S1SU1fq17NHsCqHIPkC9ocMvzizEmjdReZFGk67McOTn5rGLXmFDzdoWna6qkYjsI/v973sMK
        HVTm4g6kp1gKcvshrk1c7E/XrmY6kmJcG9L9srP+/nGz0DPmAWB2s2dUQVPShEk277OD1aJw9QVen
        6LK82y4w==;
In-Reply-To: <20211015132643.1621913-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
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

