From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 25/30] block: move a few internal definitions out
 of blkdev.h
Date: Thu,  8 Jun 2023 13:02:53 +0200
Message-ID: <20230608110258.189493-26-hch@lst.de>
References: <20230608110258.189493-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686222295;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=61mJYGOUc+nNCuJz3Tlkt2zBDCV6mPOFnRZBHjcFbFQ=;
	b=aRyKD34AsEVnwvhy2QSKL3rEelHydOHXb+EhLYW8aUqce4Vj2jgja4aXcykZPbnyA1WLsd
	UgskeulDvLT7wk+LazayHZd/CcJ54c+krYBm7qgnbMdTLeeh+AFtVLA4u/OoLFJ1rKf+gl
	b8AbNK7zvqHTud5rhc19qoOS8fpfNfs=
In-Reply-To: <20230608110258.189493-1-hch@lst.de>
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

All these helpers are only used in core block code, so move them out of
the public header.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Christian Brauner <brauner@kernel.org>
---
 block/blk.h            | 23 +++++++++++++++++++++--
 include/linux/blkdev.h | 27 ---------------------------
 2 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 9582fcd0df4123..6910220aa030f1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -394,10 +394,27 @@ static inline struct bio *blk_queue_bounce(struct bio *bio,
 #ifdef CONFIG_BLK_DEV_ZONED
 void disk_free_zone_bitmaps(struct gendisk *disk);
 void disk_clear_zone_settings(struct gendisk *disk);
-#else
+int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
+		unsigned int cmd, unsigned long arg);
+int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
+		unsigned int cmd, unsigned long arg);
+#else /* CONFIG_BLK_DEV_ZONED */
 static inline void disk_free_zone_bitmaps(struct gendisk *disk) {}
 static inline void disk_clear_zone_settings(struct gendisk *disk) {}
-#endif
+static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
+		fmode_t mode, unsigned int cmd, unsigned long arg)
+{
+	return -ENOTTY;
+}
+static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
+		fmode_t mode, unsigned int cmd, unsigned long arg)
+{
+	return -ENOTTY;
+}
+#endif /* CONFIG_BLK_DEV_ZONED */
+
+struct block_device *bdev_alloc(struct gendisk *disk, u8 partno);
+void bdev_add(struct block_device *bdev, dev_t dev);
 
 int blk_alloc_ext_minor(void);
 void blk_free_ext_minor(unsigned int minor);
@@ -449,6 +466,8 @@ extern struct device_attribute dev_attr_events_poll_msecs;
 
 extern struct attribute_group blk_trace_attr_group;
 
+int truncate_bdev_range(struct block_device *bdev, fmode_t mode, loff_t lstart,
+		loff_t lend);
 long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 97803603902076..6b65623e447c02 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -318,7 +318,6 @@ typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
 void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
 
 #ifdef CONFIG_BLK_DEV_ZONED
-
 #define BLK_ALL_ZONES  ((unsigned int)-1)
 int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data);
@@ -328,33 +327,11 @@ extern int blkdev_zone_mgmt(struct block_device *bdev, enum req_op op,
 			    gfp_t gfp_mask);
 int blk_revalidate_disk_zones(struct gendisk *disk,
 			      void (*update_driver_data)(struct gendisk *disk));
-
-extern int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
-				     unsigned int cmd, unsigned long arg);
-extern int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
-				  unsigned int cmd, unsigned long arg);
-
 #else /* CONFIG_BLK_DEV_ZONED */
-
 static inline unsigned int bdev_nr_zones(struct block_device *bdev)
 {
 	return 0;
 }
-
-static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
-					    fmode_t mode, unsigned int cmd,
-					    unsigned long arg)
-{
-	return -ENOTTY;
-}
-
-static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
-					 fmode_t mode, unsigned int cmd,
-					 unsigned long arg)
-{
-	return -ENOTTY;
-}
-
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 /*
@@ -1493,11 +1470,7 @@ void blkdev_put(struct block_device *bdev, void *holder);
 struct block_device *blkdev_get_no_open(dev_t dev);
 void blkdev_put_no_open(struct block_device *bdev);
 
-struct block_device *bdev_alloc(struct gendisk *disk, u8 partno);
-void bdev_add(struct block_device *bdev, dev_t dev);
 struct block_device *I_BDEV(struct inode *inode);
-int truncate_bdev_range(struct block_device *bdev, fmode_t mode, loff_t lstart,
-		loff_t lend);
 
 #ifdef CONFIG_BLOCK
 void invalidate_bdev(struct block_device *bdev);
-- 
2.39.2
