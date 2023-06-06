From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 31/31] fs: remove the now unused FMODE_* flags
Date: Tue,  6 Jun 2023 09:39:50 +0200
Message-ID: <20230606073950.225178-32-hch@lst.de>
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
 bh=rEj4t4RByNCnEGoVckpjuOqOSqkYA0bI6jBzshMrCBQ=; b=M5fdN5vwtGOCvQ7JAJ+H+61/mA
 ZYR7aU+JJ7T516sFXfIUQivBFrrlEl31k3/KaGYqMa0qyyISi92qqgzo9DYxKRAC16dN91YvLgJFk
 kZSlDKqlx7C/9G5Mtz41m6J31T3TLOSZHkzjnFhwenYlgZZjoHizl1ZQUpW1IAmFn7s8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=rEj4t4RByNCnEGoVckpjuOqOSqkYA0bI6jBzshMrCBQ=; b=BPZIy0cBsf4mcOOShn4ErsK3gC
 u69jsIuoNbd9TpynqEorcFMZijpu727ukW3DfCUKMVUO7bVwdnmRux+wxmOrr+/HlT53w2jeXGnLk
 y/ZRyfpQ+CCE1X5Tq4PAl6PaVMzLiC1geiRr/GsuNMz6dRPfuSoZjkgd/64nr+BjsByM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=rEj4t4RByNCnEGoVckpjuOqOSqkYA0bI6jBzshMrCBQ=; b=reUq0A7aIRxNvxcQU4tLunP86X
 H5T3lbnnI0syQYXk4WpwsHbWarRNnbB1Ejinyj0U5j9N6Xc8lDSnGhfVpE0VAyaaNlpshg0cq2AWk
 H/AiZzOK3MfQZxXIcVz/mFljOI2rr+/oczCVgaSLG8cxdxFFF31FwXIaNfWsS8GjGPwhOhpfR45mL
 aH1JaNHGBZCbLBZUKvsgUSymRmvl7oDjrh2VVV4WuzeiifXsrTbcjvhBKpBd1lII26GclF49T17yH
 ETLpJbaNQjbQM5JdMQyVIK0noqFAz2nPbGyIvVaQrFCioTYq14mNIzHq+cGYs24y5oVWcQYhcIXrt
 trSDszIg==;
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

FMODE_NDELAY, FMODE_EXCL and FMODE_WRITE_IOCTL were only used for
block internal purposed and are now entirely unused, so remove them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fs.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index ad1d2c9afb3fa4..8045c7ef4000c2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -119,13 +119,6 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define FMODE_PWRITE		((__force fmode_t)0x10)
 /* File is opened for execution with sys_execve / sys_uselib */
 #define FMODE_EXEC		((__force fmode_t)0x20)
-/* File is opened with O_NDELAY (only set for block devices) */
-#define FMODE_NDELAY		((__force fmode_t)0x40)
-/* File is opened with O_EXCL (only set for block devices) */
-#define FMODE_EXCL		((__force fmode_t)0x80)
-/* File is opened using open(.., 3, ..) and is writeable only for ioctls
-   (specialy hack for floppy.c) */
-#define FMODE_WRITE_IOCTL	((__force fmode_t)0x100)
 /* 32bit hashes as llseek() offset (for directories) */
 #define FMODE_32BITHASH         ((__force fmode_t)0x200)
 /* 64bit hashes as llseek() offset (for directories) */
-- 
2.39.2
