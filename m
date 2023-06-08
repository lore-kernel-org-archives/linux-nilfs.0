From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/30] cdrom: remove the unused cdrom_close_write release code
Date: Thu,  8 Jun 2023 13:02:32 +0200
Message-ID: <20230608110258.189493-5-hch@lst.de>
References: <20230608110258.189493-1-hch@lst.de>
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
	List-Owner; bh=ac+a18GQwY5NrY5C53CS7EnFHnxKNuxfsoHfKC/unyY=; b=ehwEi/mANGKWXb
	Y5Yc7PkwOVQoy1Lqb94iVLAuQ8QQKPHhAMHq70MYoY767hiktnylg0K2jgoeSsUG0yzlaxR/1tPjI
	ZQYgTQYfFsyHvfjyEJbeHI6RD8pUeWrwFReDm4vbOGisDYD7Py2fs3L91di6wr4RzBIws1kwhnSN+
	64V/eNF+T/+YZ5Qm0xlFjrOUWxmiQ0xgnrtfGXxv8wqVQrzmU6hmgnlyW24/QV08rwh44NLLjjFT8
	15RNWG8jWXMGYwwUPMsuNedSbt1BlU/pRNNyn8L5yPs3VeRvPWIUiJQM3vt6cdtQWBQ/Gk66IosHt
	ojkxp1ghmT0pmDTN7COQ==;
In-Reply-To: <20230608110258.189493-1-hch@lst.de>
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

cdrom_close_write is empty, and the for_data flag it is keyed off is
never set.  Remove all this clutter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Phillip Potter <phil@philpotter.co.uk>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Christian Brauner <brauner@kernel.org>
---
 drivers/cdrom/cdrom.c | 15 ---------------
 include/linux/cdrom.h |  1 -
 2 files changed, 16 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 245e5bbb05d41c..08abf1ffede002 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -978,15 +978,6 @@ static void cdrom_dvd_rw_close_write(struct cdrom_device_info *cdi)
 	cdi->media_written = 0;
 }
 
-static int cdrom_close_write(struct cdrom_device_info *cdi)
-{
-#if 0
-	return cdrom_flush_cache(cdi);
-#else
-	return 0;
-#endif
-}
-
 /* badly broken, I know. Is due for a fixup anytime. */
 static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype *tracks)
 {
@@ -1282,12 +1273,6 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
 	opened_for_data = !(cdi->options & CDO_USE_FFLAGS) ||
 		!(mode & FMODE_NDELAY);
 
-	/*
-	 * flush cache on last write release
-	 */
-	if (CDROM_CAN(CDC_RAM) && !cdi->use_count && cdi->for_data)
-		cdrom_close_write(cdi);
-
 	cdo->release(cdi);
 	if (cdi->use_count == 0) {      /* last process that closes dev*/
 		if (opened_for_data &&
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 4aea8c82d16971..0a5db0b0c958a1 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -61,7 +61,6 @@ struct cdrom_device_info {
 	__u8 last_sense;
 	__u8 media_written;		/* dirty flag, DVD+RW bookkeeping */
 	unsigned short mmc3_profile;	/* current MMC3 profile */
-	int for_data;
 	int (*exit)(struct cdrom_device_info *);
 	int mrw_mode_page;
 	__s64 last_media_change_ms;
-- 
2.39.2
