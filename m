From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/31] cdrom: remove the unused mode argument to cdrom_ioctl
Date: Tue,  6 Jun 2023 09:39:22 +0200
Message-ID: <20230606073950.225178-4-hch@lst.de>
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
	List-Owner; bh=rtZhzh9n+4Sk7XL1QrK0X+ix6muQXyOj40v5pFvyiO8=; b=RRK0j63X+BCyxg
	951TKQgEWlaZP4do1jXkppNJdoVD2qcYuZUB9ghYwoqnMpOig+ZyXoZx67Fe2MBU2K2VDTNAbFvsk
	a0gREfoMlShydZWdQH/RZlgbZGVgabr7yaJ2NgiCfgPe1+OcPTU26W/Pfg5I4jk6FhEdfgPGNELVq
	nQIgq7l9IV3hqN90eGkBuqAFSffG1VIEXiPiXXTfTiEv3YD3PlY2hWR/4B8R5mE1FaDP0CeVDgUb4
	E7flVQuaTcJ3fqFB2alDzB/JOttL9DeIsthwWG6hL+FLMZkB7bBWTsgZZU1yI/09Jb2EbvpBsIjbE
	07K1DZ/K+JYCX6O/Bq/A==;
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
 include/linux/cdrom.h | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index e3eab319cb0474..245e5bbb05d41c 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3336,7 +3336,7 @@ static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
  * ATAPI / SCSI specific code now mainly resides in mmc_ioctl().
  */
 int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
-		fmode_t mode, unsigned int cmd, unsigned long arg)
+		unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int ret;
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index eaa2d5a90bc82f..14922403983e9e 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -505,7 +505,7 @@ static int gdrom_bdops_ioctl(struct block_device *bdev, fmode_t mode,
 	int ret;
 
 	mutex_lock(&gdrom_mutex);
-	ret = cdrom_ioctl(gd.cd_info, bdev, mode, cmd, arg);
+	ret = cdrom_ioctl(gd.cd_info, bdev, cmd, arg);
 	mutex_unlock(&gdrom_mutex);
 
 	return ret;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 61b83880e395a4..444c7efc14cba7 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -539,7 +539,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	scsi_autopm_get_device(sdev);
 
 	if (cmd != CDROMCLOSETRAY && cmd != CDROMEJECT) {
-		ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
+		ret = cdrom_ioctl(&cd->cdi, bdev, cmd, arg);
 		if (ret != -ENOSYS)
 			goto put;
 	}
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index cc5717cb0fa8a8..4aea8c82d16971 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -103,8 +103,8 @@ int cdrom_read_tocentry(struct cdrom_device_info *cdi,
 /* the general block_device operations structure: */
 int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode);
 extern void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode);
-extern int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
-		       fmode_t mode, unsigned int cmd, unsigned long arg);
+int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
+		unsigned int cmd, unsigned long arg);
 extern unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
 				       unsigned int clearing);
 
-- 
2.39.2
