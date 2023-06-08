From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 29/30] block: store the holder in
 file->private_data
Date: Thu,  8 Jun 2023 13:02:57 +0200
Message-ID: <20230608110258.189493-30-hch@lst.de>
References: <20230608110258.189493-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:References:
 In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=cT8NDVtiIsZNzV7dqaCyqaAv6UgEz/7VfiIdR+IkQQM=; b=cv9/3L4cT2beHZXlxN477UVPcg
 SKB5bOmnuqOuS8fAaUluJC2yIgrQL0MGchyhdG6kN0LVZVTGyImXHBz0RHZFT9VRP97HcS9Je8Ym9
 1MltHN7flNJ5QIUh6T2ByFToUap0QaaOHULG+T/Ir3uHQRxc5sCJtY8HEgktKwjiz+IQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=cT8NDVtiIsZNzV7dqaCyqaAv6UgEz/7VfiIdR+IkQQM=; b=j7XFJ9kbGD1B7ZT0pQy46PtTsk
 DHLALHj+RQbL1WXU2yT530y2nAQRXUkEa8cxdpocCikBZD6v+pbFZ8T8FHlH4kdRy9Yhw3n7GHMP4
 5U1j0xhfYUAB1aHeGpdzhszCkPMvqM/TFVJzUf7awQiZ9yGqVRU1g+Ynbn3FqrJN5HRg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=cT8NDVtiIsZNzV7dqaCyqaAv6UgEz/7VfiIdR+IkQQM=; b=kiJFIQ1nAL+TXJv9FL1MxdQxRn
 MjE37b6TUrn3o2T+X8RTjzxc9dFoJwc13B1cxCTfAgHHieEEThz+nOulB+CXAbbC1Y0y85FoWFx1G
 VraKXIbJAMCy3hW0e3Z3ki4QwJEvq9BK9L16/RF4/o2PenRIOj00eETs5fBt1PFSS9iM3+erOXzTk
 Zaq0wNsryRPVn+c0ll3/+zPoyHsu/DIq1VB+b/aXjSerkeOYW0iTLL8nU8Au3EkY8EtDDZIBLMWmS
 WhjQhMLxjLCE3gWrcxXeubo/4FAPO6sinlscv6PM4NW47r2uUyAy4fyteW4jDGY1V2cNPUKALpg8d
 C5CDVyMw==;
In-Reply-To: <20230608110258.189493-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Jens Axboe <axboe@kernel.dk>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.

Store the file struct used as the holder in file->private_data as an
indicator that this file descriptor was opened exclusively to  remove
the last use of FMODE_EXCL.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 0d714d050a462c..9871bd6052b416 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -478,7 +478,7 @@ blk_mode_t file_to_blk_mode(struct file *file)
 		mode |= BLK_OPEN_READ;
 	if (file->f_mode & FMODE_WRITE)
 		mode |= BLK_OPEN_WRITE;
-	if (file->f_mode & FMODE_EXCL)
+	if (file->private_data)
 		mode |= BLK_OPEN_EXCL;
 	if (file->f_flags & O_NDELAY)
 		mode |= BLK_OPEN_NDELAY;
@@ -507,12 +507,15 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	filp->f_flags |= O_LARGEFILE;
 	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
 
+	/*
+	 * Use the file private data to store the holder for exclusive openes.
+	 * file_to_blk_mode relies on it being present to set BLK_OPEN_EXCL.
+	 */
 	if (filp->f_flags & O_EXCL)
-		filp->f_mode |= FMODE_EXCL;
+		filp->private_data = filp;
 
 	bdev = blkdev_get_by_dev(inode->i_rdev, file_to_blk_mode(filp),
-				 (filp->f_mode & FMODE_EXCL) ? filp : NULL,
-				 NULL);
+				 filp->private_data, NULL);
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
@@ -523,8 +526,7 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 
 static int blkdev_release(struct inode *inode, struct file *filp)
 {
-	blkdev_put(I_BDEV(filp->f_mapping->host),
-		   (filp->f_mode & FMODE_EXCL) ? filp : NULL);
+	blkdev_put(I_BDEV(filp->f_mapping->host), filp->private_data);
 	return 0;
 }
 
-- 
2.39.2
