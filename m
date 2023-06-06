From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 29/31] block: always use I_BDEV on
 file->f_mapping->host to find the bdev
Date: Tue,  6 Jun 2023 09:39:48 +0200
Message-ID: <20230606073950.225178-30-hch@lst.de>
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
 bh=olyTmt1++EhkqUXPlwyxeL1H8bKZf9/0mYmTRE1O09c=; b=UJ2VxBXH06Ka59PY0pcka1umFX
 l4SW+DohzZUIaaLCoCPNWcOw0H2xbq4cso8Ril7FYfYj8ZUmnVOgO/56z/gjCtAU+MkjphpjCkQqk
 TP7ImX8d+MiF5u8v77HklKvClgf375nwLj+DMx4vkABcfVUAC37YBNzSX5LRTQgDS1cY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=olyTmt1++EhkqUXPlwyxeL1H8bKZf9/0mYmTRE1O09c=; b=HTmvKuwL0ul4oQ+IOCGG9449Hj
 AYb/k7CfhybR146KDrSNiPFO05FS0FjJt2KtmZcyNF3QiLEUq0KqCbAXEVsCExrovYp+Y7EGhDbsc
 MOshzkgNPeVYnAV14W1rwSvaSqEyzZqyRfe9urF7/txOa49ZSyD59ozAJUeVNzOTkSYw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=olyTmt1++EhkqUXPlwyxeL1H8bKZf9/0mYmTRE1O09c=; b=D6bRDmf0aQjaYta0onoCN8UsmK
 knmcUGvKcM3a6U66+UYI4vcEDdhjzByWGAsLWm8WnHhs7PfTUdRIDNLUY4f//YhB8Tbcr7g2t7g8f
 RfUKIcFnTgIS2K3V2GEqx0XpuEpowQqfWeOrl+P+1eZOo5tf34z6yyykp/Plo8tRMW76HKVK2x07A
 2hqh615hFyvQ7WGPE5ycOAp1Pp7NIYTQU53YgHsmUxVlqYh60SD64VeoAgNZn4Rrx3/S2XXEFq4gQ
 y9wx+ZxNm+ul7qbPalhtlurHieYREgSrSF79KEqXydWMs7jKeXS+lUzm8MNtRkwN/UtdJDZEwNQxD
 4QMlBw+Q==;
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

Always use I_BDEV(file->f_mapping->host) to find the bdev for a file to
free up file->private_data for other uses.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 928c37a214f785..c40b9f978e3bc7 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -54,7 +54,7 @@ static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
 static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 		struct iov_iter *iter, unsigned int nr_pages)
 {
-	struct block_device *bdev = iocb->ki_filp->private_data;
+	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 	struct bio_vec inline_vecs[DIO_INLINE_BIO_VECS], *vecs;
 	loff_t pos = iocb->ki_pos;
 	bool should_dirty = false;
@@ -170,7 +170,7 @@ static void blkdev_bio_end_io(struct bio *bio)
 static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		unsigned int nr_pages)
 {
-	struct block_device *bdev = iocb->ki_filp->private_data;
+	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 	struct blk_plug plug;
 	struct blkdev_dio *dio;
 	struct bio *bio;
@@ -310,7 +310,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 					struct iov_iter *iter,
 					unsigned int nr_pages)
 {
-	struct block_device *bdev = iocb->ki_filp->private_data;
+	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 	bool is_read = iov_iter_rw(iter) == READ;
 	blk_opf_t opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb);
 	struct blkdev_dio *dio;
@@ -451,7 +451,7 @@ static loff_t blkdev_llseek(struct file *file, loff_t offset, int whence)
 static int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
 		int datasync)
 {
-	struct block_device *bdev = filp->private_data;
+	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
 	int error;
 
 	error = file_write_and_wait_range(filp, start, end);
@@ -510,7 +510,6 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
-	filp->private_data = bdev;
 	filp->f_mapping = bdev->bd_inode->i_mapping;
 	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
 	return 0;
@@ -518,9 +517,8 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 
 static int blkdev_release(struct inode *inode, struct file *filp)
 {
-	struct block_device *bdev = filp->private_data;
-
-	blkdev_put(bdev, (filp->f_mode & FMODE_EXCL) ? filp : NULL);
+	blkdev_put(I_BDEV(filp->f_mapping->host),
+		   (filp->f_mode & FMODE_EXCL) ? filp : NULL);
 	return 0;
 }
 
@@ -533,7 +531,7 @@ static int blkdev_release(struct inode *inode, struct file *filp)
  */
 static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
-	struct block_device *bdev = iocb->ki_filp->private_data;
+	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 	struct inode *bd_inode = bdev->bd_inode;
 	loff_t size = bdev_nr_bytes(bdev);
 	size_t shorted = 0;
@@ -569,7 +567,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
-	struct block_device *bdev = iocb->ki_filp->private_data;
+	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 	loff_t size = bdev_nr_bytes(bdev);
 	loff_t pos = iocb->ki_pos;
 	size_t shorted = 0;
-- 
2.39.2
