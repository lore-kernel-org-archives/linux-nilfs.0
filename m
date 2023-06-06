From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 27/31] block: remove unused fmode_t arguments
 from ioctl handlers
Date: Tue,  6 Jun 2023 09:39:46 +0200
Message-ID: <20230606073950.225178-28-hch@lst.de>
References: <20230606073950.225178-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686037313;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5tkvICbf42kkoCM66Xg1JapKl0agkcnkBuuXfiIIy7o=;
	b=GG+CG9wBQPC7C/P8zXSFWedYLK91P31V/uTYFAP2GB/wQgbOSUXuqxSGWeuLFOW4V+JI48
	d3lpq7BUDL26p6pJKjCfhEz2r8+B0/Odyrb5G7rsCSB2/2M/+YjOW+Lxy79UsXRVgajzVl
	l8deGGt74txUscPlf0D1EiKUT2ZyZiU=
In-Reply-To: <20230606073950.225178-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.

A few ioctl handlers have fmode_t arguments that are entirely unused,
remove them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-zoned.c |  4 ++--
 block/blk.h       |  6 +++---
 block/ioctl.c     | 14 +++++++-------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 096b6b47561f83..02cc2c629ac9be 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -323,8 +323,8 @@ static int blkdev_copy_zone_to_user(struct blk_zone *zone, unsigned int idx,
  * BLKREPORTZONE ioctl processing.
  * Called from blkdev_ioctl.
  */
-int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
-			      unsigned int cmd, unsigned long arg)
+int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
+		unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	struct zone_report_args args;
diff --git a/block/blk.h b/block/blk.h
index 6910220aa030f1..e28d5d67d31a28 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -394,15 +394,15 @@ static inline struct bio *blk_queue_bounce(struct bio *bio,
 #ifdef CONFIG_BLK_DEV_ZONED
 void disk_free_zone_bitmaps(struct gendisk *disk);
 void disk_clear_zone_settings(struct gendisk *disk);
-int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
-		unsigned int cmd, unsigned long arg);
+int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
+		unsigned long arg);
 int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 		unsigned int cmd, unsigned long arg);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline void disk_free_zone_bitmaps(struct gendisk *disk) {}
 static inline void disk_clear_zone_settings(struct gendisk *disk) {}
 static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
-		fmode_t mode, unsigned int cmd, unsigned long arg)
+		unsigned int cmd, unsigned long arg)
 {
 	return -ENOTTY;
 }
diff --git a/block/ioctl.c b/block/ioctl.c
index b39bd5b41ee492..3a10c34b8ef6d3 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -344,8 +344,8 @@ static int blkdev_pr_clear(struct block_device *bdev,
 	return ops->pr_clear(bdev, c.key);
 }
 
-static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
-		unsigned cmd, unsigned long arg)
+static int blkdev_flushbuf(struct block_device *bdev, unsigned cmd,
+		unsigned long arg)
 {
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -354,8 +354,8 @@ static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
 	return 0;
 }
 
-static int blkdev_roset(struct block_device *bdev, fmode_t mode,
-		unsigned cmd, unsigned long arg)
+static int blkdev_roset(struct block_device *bdev, unsigned cmd,
+		unsigned long arg)
 {
 	int ret, n;
 
@@ -475,9 +475,9 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 
 	switch (cmd) {
 	case BLKFLSBUF:
-		return blkdev_flushbuf(bdev, mode, cmd, arg);
+		return blkdev_flushbuf(bdev, cmd, arg);
 	case BLKROSET:
-		return blkdev_roset(bdev, mode, cmd, arg);
+		return blkdev_roset(bdev, cmd, arg);
 	case BLKDISCARD:
 		return blk_ioctl_discard(bdev, mode, arg);
 	case BLKSECDISCARD:
@@ -487,7 +487,7 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 	case BLKGETDISKSEQ:
 		return put_u64(argp, bdev->bd_disk->diskseq);
 	case BLKREPORTZONE:
-		return blkdev_report_zones_ioctl(bdev, mode, cmd, arg);
+		return blkdev_report_zones_ioctl(bdev, cmd, arg);
 	case BLKRESETZONE:
 	case BLKOPENZONE:
 	case BLKCLOSEZONE:
-- 
2.39.2
