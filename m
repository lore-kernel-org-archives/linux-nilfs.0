From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/31] cdrom: remove the unused mode argument to cdrom_release
Date: Tue,  6 Jun 2023 09:39:25 +0200
Message-ID: <20230606073950.225178-7-hch@lst.de>
References: <20230606073950.225178-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=zjXFCCJeAKvhtGSQYjWDO4ba3TNcD55zWX9SsvvL+8U=; b=NhIO6PufhBEk0u
	Gom4j129AM57mGdSRfXUnH1HrtfLtviTBGb2mcrAvgqpUu+iaMUVdoIIKG/eqF9fvyQUv9CX61acA
	5pNDTK9/gf+DcrfJCBgIiw5OPb436nxhf1Xhr7rNcEtq8uPgQr44Jez0k0DU7MgYD/z/vpOX7hENQ
	mSHptWqVNNY7fU+J/pcTELhXIwHg38tcgZVuuiN1SVVkqXRDdaZzF+gWLgVh64i5lG4Xm1wgWrccZ
	TZWd3ZquExyYVdgUIypx4Hq4cmA1V/149XKbNp6CueYYpY/oRKoac8RAemO1zqp2JLiZFlUegpqQI
	X/xrJvNVbKo5VkobcQRw==;
In-Reply-To: <20230606073950.225178-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-um/>
List-Post: <mailto:linux-um@lists.infradead.org>
List-Help: <mailto:linux-um-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=subscribe>
Sender: "linux-um" <linux-um-bounces@lists.infradead.org>
Errors-To: linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdeve

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/cdrom/cdrom.c | 2 +-
 drivers/cdrom/gdrom.c | 2 +-
 drivers/scsi/sr.c     | 2 +-
 include/linux/cdrom.h | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index adebac1bd210d9..998b03fe976e22 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1250,7 +1250,7 @@ static int check_for_audio_disc(struct cdrom_device_info *cdi,
 	return 0;
 }
 
-void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
+void cdrom_release(struct cdrom_device_info *cdi)
 {
 	const struct cdrom_device_ops *cdo = cdi->ops;
 
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 14922403983e9e..a401dc4218a998 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -481,7 +481,7 @@ static int gdrom_bdops_open(struct block_device *bdev, fmode_t mode)
 	bdev_check_media_change(bdev);
 
 	mutex_lock(&gdrom_mutex);
-	ret = cdrom_open(gd.cd_info, mode);
+	ret = cdrom_open(gd.cd_info);
 	mutex_unlock(&gdrom_mutex);
 	return ret;
 }
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 444c7efc14cba7..6d33120ee5ba85 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -512,7 +512,7 @@ static void sr_block_release(struct gendisk *disk, fmode_t mode)
 	struct scsi_cd *cd = scsi_cd(disk);
 
 	mutex_lock(&cd->lock);
-	cdrom_release(&cd->cdi, mode);
+	cdrom_release(&cd->cdi);
 	mutex_unlock(&cd->lock);
 
 	scsi_device_put(cd->device);
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 385e94732b2cf1..3f23d5239de254 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -102,7 +102,7 @@ int cdrom_read_tocentry(struct cdrom_device_info *cdi,
 
 /* the general block_device operations structure: */
 int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode);
-extern void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode);
+void cdrom_release(struct cdrom_device_info *cdi);
 int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 		unsigned int cmd, unsigned long arg);
 extern unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
-- 
2.39.2
