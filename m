From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/31] block: share code between disk_check_media_change and disk_force_media_change
Date: Tue,  6 Jun 2023 09:39:27 +0200
Message-ID: <20230606073950.225178-9-hch@lst.de>
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
	List-Owner; bh=80EyAAaAjaGfreHVVNV4HjolLuYiprTROi7PrrWnadk=; b=cBGc/YWgurK6F7
	ZbzvT80Gy1719tH2401bwTuo87nlabdCBWwEIyqhY2kS2voRRWQJewGg1UXDcJWZTr4fyU9gHeqTm
	Yjt9vOAybd2ml3ZMD7+hMPBmW1XMpkbbC9s3WCNqoe3h3IDY9CWh/sGZskvyGE7D5Q4sFa3BmUN3C
	OJyC0pzZ33Wuk+6gOPNslZsj4WpGmUG0cN8K/xdLC/UhVeG48hBEgSF7JCwWDwroyipqu8dDkGOgn
	BuBB5qnIBqCBjAbG+f+OVmdUygXFoPjELjS1Rv6AjcTzIaEibE4hsY15fRCgvCjrajBLRfL7sJJMf
	aeD6k5jzlQQeOo6/Zp8w==;
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

Factor the common logic between disk_check_media_change and
disk_force_media_change into a helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/disk-events.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/block/disk-events.c b/block/disk-events.c
index 8b1b63225738f8..06f325662b3494 100644
--- a/block/disk-events.c
+++ b/block/disk-events.c
@@ -262,6 +262,18 @@ static unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 	return pending;
 }
 
+static bool __disk_check_media_change(struct gendisk *disk, unsigned int events)
+{
+	if (!(events & DISK_EVENT_MEDIA_CHANGE))
+		return false;
+
+	if (__invalidate_device(disk->part0, true))
+		pr_warn("VFS: busy inodes on changed media %s\n",
+			disk->disk_name);
+	set_bit(GD_NEED_PART_SCAN, &disk->state);
+	return true;
+}
+
 /**
  * disk_check_media_change - check if a removable media has been changed
  * @disk: gendisk to check
@@ -274,18 +286,9 @@ static unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
  */
 bool disk_check_media_change(struct gendisk *disk)
 {
-	unsigned int events;
-
-	events = disk_clear_events(disk, DISK_EVENT_MEDIA_CHANGE |
-				   DISK_EVENT_EJECT_REQUEST);
-	if (!(events & DISK_EVENT_MEDIA_CHANGE))
-		return false;
-
-	if (__invalidate_device(disk->part0, true))
-		pr_warn("VFS: busy inodes on changed media %s\n",
-			disk->disk_name);
-	set_bit(GD_NEED_PART_SCAN, &disk->state);
-	return true;
+	return __disk_check_media_change(disk,
+			disk_clear_events(disk, DISK_EVENT_MEDIA_CHANGE |
+						DISK_EVENT_EJECT_REQUEST));
 }
 EXPORT_SYMBOL(disk_check_media_change);
 
@@ -303,15 +306,7 @@ EXPORT_SYMBOL(disk_check_media_change);
 bool disk_force_media_change(struct gendisk *disk, unsigned int events)
 {
 	disk_event_uevent(disk, events);
-
-	if (!(events & DISK_EVENT_MEDIA_CHANGE))
-		return false;
-
-	if (__invalidate_device(disk->part0, true))
-		pr_warn("VFS: busy inodes on changed media %s\n",
-			disk->disk_name);
-	set_bit(GD_NEED_PART_SCAN, &disk->state);
-	return true;
+	return __disk_check_media_change(disk, events);
 }
 EXPORT_SYMBOL_GPL(disk_force_media_change);
 
-- 
2.39.2
