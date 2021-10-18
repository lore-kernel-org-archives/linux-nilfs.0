From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/30] drbd: use bdev_nr_sectors instead of open
	coding it
Date: Mon, 18 Oct 2021 12:11:04 +0200
Message-ID: <20211018101130.1838532-5-hch@lst.de>
References: <20211018101130.1838532-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20211018101130.1838532-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org, reiserfs-devel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-ext4@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>, Kees Cook <keescook@chromium.org>, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, linux-block@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-de

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
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
