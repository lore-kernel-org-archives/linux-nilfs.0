From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/30] block: add a bdev_nr_bytes helper
Date: Mon, 18 Oct 2021 12:11:02 +0200
Message-ID: <20211018101130.1838532-3-hch@lst.de>
References: <20211018101130.1838532-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xjTWeSayf3PGdeuuH3Uv1mvdxKcTliIdGd38f16e0vY=; b=KMWyFjUUP4rTm1jU72NoSazyjw
        NukgJKTB3XLeVN5/NaHZeMw1abHoo6KJQXk2WQvU/LsTslU9QVmfYML22zcD3OIFxgbvqOWiXdnaR
        OpY1s7tltedd/mn56643zLiVtvcycJPwOmHKOR3RPDXVr8PVpqxRhuugiqdEMDLPy7Gw62jdy8gjA
        FCOsAmyXMJVwe63VVc61EYBxID5DtFF4IstC57V/rHMPXBAphyH570DHr1Ob6pxFi144uTQUosdjx
        mAcl43jh0ueJZ2x4rqHyyAr2lalnUkUd9hsorIFLNvRC3ubFHhIW5VBzOdWy2PLwjmzFlpw5QEA+l
        4CL6wc2A==;
In-Reply-To: <20211018101130.1838532-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.or

Add a helper to query the size of a block device in bytes.  This
will be used to remove open coded access to ->bd_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 include/linux/genhd.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 082a3e5fd8fa1..b560aee1d69f0 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -235,9 +235,14 @@ static inline sector_t get_start_sect(struct block_device *bdev)
 	return bdev->bd_start_sect;
 }
 
+static inline loff_t bdev_nr_bytes(struct block_device *bdev)
+{
+	return i_size_read(bdev->bd_inode);
+}
+
 static inline sector_t bdev_nr_sectors(struct block_device *bdev)
 {
-	return i_size_read(bdev->bd_inode) >> 9;
+	return bdev_nr_bytes(bdev) >> SECTOR_SHIFT;
 }
 
 static inline sector_t get_capacity(struct gendisk *disk)
-- 
2.30.2

