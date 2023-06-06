From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 30/31] block: store the holder in
 file->private_data
Date: Tue,  6 Jun 2023 09:39:49 +0200
Message-ID: <20230606073950.225178-31-hch@lst.de>
References: <20230606073950.225178-1-hch@lst.de>
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
 bh=RkaoGw7hxnY7p2Aj4jgl8vVIBxmKSkWEmvUol6CzrBM=; b=nLoxbapOBSG/Y75uik8nxV1LUD
 /pcgp9OS87lX4XMvVLlYogbEYVU/DY4Hx9K7Tq0CfQxH1dbGjRRBIufgjVsBvs1plQUe1YoSMn2re
 52S4G0oANhWZwKdyYlJWzNCisTq2Gmnz/2BKi9vuIDnmx5dOq1qBR2sOfhQ7tMgvwVuU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=RkaoGw7hxnY7p2Aj4jgl8vVIBxmKSkWEmvUol6CzrBM=; b=eQWhGwHFz1oTdKjOihcc5AmtPN
 Cypmavc06U0cAVDtz6Ny4An01+hSow2/wmUu7Ig3BEFjJh2DyDbiwpkA3j2YrL0yqTs3edgKhnlYj
 FClU9VDuSt43JvymR2enMSgePpS+O+nayo1KCJNIh0Zm016pLHrULFQGWb5nktCrc8X4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=RkaoGw7hxnY7p2Aj4jgl8vVIBxmKSkWEmvUol6CzrBM=; b=NLn6+h1KQ1XPhC8jPNSjuxiI/H
 d3m1qq+F+uiL75Nt82jjj6hyuacgFBd3QNUYV0sHDor2YZKT1Nxmg04qDVQhMYoevX0tImBwex4VG
 G+9KvCdLT6m6XXN86IZINhovZ63m0Zc8rws01Ky24GKB/HiugyBnBWZH+oaHS8Q0Idl5inxJoIfSU
 qi4TPJkaEIQeX6IPAScaGNPHjAr8/VFwUTGdvbJhjlV0CVdqGYYW6JpYO4BQJhreDe+7iuna18m0o
 /zWoaJMNLycrCXvHvH4YL57SJwMV3vBqiYawbb8oLQ1PPYa/zpRelkQw/bx0xJpawaod/0ZWKLQo4
 IzSMFktA==;
In-Reply-To: <20230606073950.225178-1-hch@lst.de>
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
index c40b9f978e3bc7..915e0ef7560993 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -478,7 +478,7 @@ blk_mode_t file_to_blk_mode(struct file *file)
 		mode |= BLK_OPEN_READ;
 	if (file->f_mode & FMODE_WRITE)
 		mode |= BLK_OPEN_WRITE;
-	if (file->f_mode & FMODE_EXCL)
+	if (file->private_data)
 		mode |= BLK_OPEN_EXCL;
 	if ((file->f_flags & O_ACCMODE) == 3)
 		mode |= BLK_OPEN_WRITE_IOCTL;
@@ -501,12 +501,15 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	filp->f_flags |= O_LARGEFILE;
 	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
 
+	/*
+	 * Use the file private data to store the holder, file_to_blk_mode
+	 * relies on this.
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
 
@@ -517,8 +520,7 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 
 static int blkdev_release(struct inode *inode, struct file *filp)
 {
-	blkdev_put(I_BDEV(filp->f_mapping->host),
-		   (filp->f_mode & FMODE_EXCL) ? filp : NULL);
+	blkdev_put(I_BDEV(filp->f_mapping->host), filp->private_data);
 	return 0;
 }
 
-- 
2.39.2
