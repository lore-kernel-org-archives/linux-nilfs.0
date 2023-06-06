From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/31] block: also call ->open for incremental partition opens
Date: Tue,  6 Jun 2023 09:39:20 +0200
Message-ID: <20230606073950.225178-2-hch@lst.de>
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
	List-Owner; bh=CdXL1/YNkkoHmA3YQ+kRFGG9QXUm8zHR9guWlp61MRg=; b=KdAuuZAtlBcuNC
	aiPHZYnF23hHYAmu4UF7KW7qY8DdsKnEUpG2qnWTfo3FiNKClYjvafN9LmSWDJXCTrrtL9Py2IG1V
	GumOGycRakOxeRQUeiIFE+nnZ7x9tbEsJoWd6se4gN0LbEAI7PQPJgvZC1woJH0dQFEn3nNy+n99N
	XoXwSwJaM/JBvnwEPshGDm1xSf+elBago8qpq2R7NJljIK/03z4HBq9+eOCPN+MPQJx3VhPDuT2hY
	EF9E59DXQgsxgEL/00kIvRGSAypcLrOQ6Kr8qnRBDibEO9IgdpHYMK+cb6j1sVinPP6gOgU1CZ05K
	wBQkjM5X0hEUozrXaZiw==;
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

For whole devices ->open is called for each open, but for partitions it
is only called on the first open of a partition.  This is problematic
as various block drivers look at open flags and might not do all setup
for ioctl only or NDELAY opens.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bdev.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 5c46ff10770638..981f6135795138 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -683,9 +683,6 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 	struct gendisk *disk = part->bd_disk;
 	int ret;
 
-	if (atomic_read(&part->bd_openers))
-		goto done;
-
 	ret = blkdev_get_whole(bdev_whole(part), mode);
 	if (ret)
 		return ret;
@@ -694,9 +691,10 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 	if (!bdev_nr_sectors(part))
 		goto out_blkdev_put;
 
-	disk->open_partitions++;
-	set_init_blocksize(part);
-done:
+	if (!atomic_read(&part->bd_openers)) {
+		disk->open_partitions++;
+		set_init_blocksize(part);
+	}
 	atomic_inc(&part->bd_openers);
 	return 0;
 
@@ -709,10 +707,10 @@ static void blkdev_put_part(struct block_device *part, fmode_t mode)
 {
 	struct block_device *whole = bdev_whole(part);
 
-	if (!atomic_dec_and_test(&part->bd_openers))
-		return;
-	blkdev_flush_mapping(part);
-	whole->bd_disk->open_partitions--;
+	if (atomic_dec_and_test(&part->bd_openers)) {
+		blkdev_flush_mapping(part);
+		whole->bd_disk->open_partitions--;
+	}
 	blkdev_put_whole(whole, mode);
 }
 
-- 
2.39.2
