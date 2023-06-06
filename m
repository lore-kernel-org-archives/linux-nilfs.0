From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/31] block: rename blkdev_close to
 blkdev_release
Date: Tue,  6 Jun 2023 09:39:30 +0200
Message-ID: <20230606073950.225178-12-hch@lst.de>
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
 bh=FfW9DuqWcqftCK2V6shZmYbcTRlwjUtw9gvZaCo9uwY=; b=ZUGhuFsjuLC7UP030EFpYfTsN7
 rjsGiTwffmTcNHTdmlmtCse/kJyJ7yZyZsZ3AkCyG9zghQk7Jk7wRhzS7Dj3gMUVvf4QVUIMWo38U
 9XTYfvAlHMQ58o6zzJrAPOW58rU1tzLvQQy9IKU8+0B+vEPomYU+1W4P30SdL5d2ujJc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=FfW9DuqWcqftCK2V6shZmYbcTRlwjUtw9gvZaCo9uwY=; b=LbwiwRm52JcdcFtqv7d4yN0SPR
 95vDy88DCA3j3TTYB8dBOkuZ2ctthe819zfYzkz0bGAx48TWBcEzPQJsIyi53EpqlMeL0VqSqQWxj
 rNIUpujtr/ltAp+LAndaTIbqXhQEeGgzX7oLjEMSAfqP7z5LgrDyvFlkuMaH4GhAl0SI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=FfW9DuqWcqftCK2V6shZmYbcTRlwjUtw9gvZaCo9uwY=; b=4IsKSEVIFLiRaOu49nM5+2+Atx
 sWynEbtjaTBj4wCpEyskc+AVpK9xBK2MyKKGe4FYbxvhjaC5LimsABd4cvkv1jv+VhxiAcI8wHrul
 BQ2EKZrYRElZjwKKlbsbcfmSdhaNX3g7h/PXGWfGeexe2oLRsJNFeu/fB50MxFxZbLVXR6FJPlChH
 THp/dF/6FsqG8FhQ5IEhDUSDTpOKU/RFO7wrS/JncAebuXfCX6h84SO3T0Bcu0BqepXfa25O/ttFX
 SKqzGH4GKjuqqkUpWzm3dwGyXzwy+CxxbeOKtT2njKDlzxoOMJNzaZg2vjCZzLeLKN98TI5RxOZKb
 Rt27q2sw==;
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

Make the function name match the method name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 6a3087b750a6cd..26af2b39c758e1 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -500,7 +500,7 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int blkdev_close(struct inode *inode, struct file *filp)
+static int blkdev_release(struct inode *inode, struct file *filp)
 {
 	struct block_device *bdev = filp->private_data;
 
@@ -677,7 +677,7 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
-	.release	= blkdev_close,
+	.release	= blkdev_release,
 	.llseek		= blkdev_llseek,
 	.read_iter	= blkdev_read_iter,
 	.write_iter	= blkdev_write_iter,
-- 
2.39.2
