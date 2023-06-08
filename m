From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 30/30] fs: remove the now unused FMODE_* flags
Date: Thu,  8 Jun 2023 13:02:58 +0200
Message-ID: <20230608110258.189493-31-hch@lst.de>
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
 bh=d1qoGjkPozWQoERQWNO6oRm0vDiGAX9ruSKuYqYCTmk=; b=TxlRQAn3VgLapM4IP9HOX3tQJ0
 m9zRqkS6eLYsS26bkc8XbCDNQzJ1B1kNU3I7vL87SxftT/g0VOgs4Ko/zUYP4eRacoEbHyELGoidT
 eonJTI0iDGw822E+N7pLOhUB54m09AwrX6J3ElQxO9sNahgc3RZbVDcg+Nu4caZIUArc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=d1qoGjkPozWQoERQWNO6oRm0vDiGAX9ruSKuYqYCTmk=; b=SpiEVNNLBvxq6+5OpZHsZDKAj3
 Y2BqqoPwlzLfCBprWXzToea0fUx/XaJAz2b9+thicnkY6l6XSYCokihR/h1uWMadNZb2/XpDqr+6c
 pdaU5RSVIPq+s74AeSR6Rv+tlO/ao0vDQL7J+AgkMjQl/LjodCTLJsmxQHQbCxWbyfAU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=d1qoGjkPozWQoERQWNO6oRm0vDiGAX9ruSKuYqYCTmk=; b=UBhwv6q5nwz6kIVHHUvGdge5x1
 LN4p34WeIV4Xtu0tQLYdNoagvbxLEVlibfWS6Z8JoEXQJFYWnQDx9vi4dLFZYXlo2iSndo43uia8K
 41YZnXLq4w0t9F1He0XGIdH8JIU2qaKY+Q12n2eTboggepOqy1af7u3SZ1Nz2UCa5x1ao9TjYwhHL
 U4Nylniu61uWgkxg/RcG6hJOkIQCiW/0tRzPTkYt58gH65GKRL+gtI+Nmqtx8eWH9TBKrU7A6WA/Y
 kF5WLY+PnO3X6CIjCM/m9E6lHA4vBST9YnPdPDqomL2/noHfHhw30VMExNOY6Tj20ZzVa4BVsJqUS
 L5T6ftGQ==;
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

FMODE_NDELAY, FMODE_EXCL and FMODE_WRITE_IOCTL were only used for
block internal purposed and are now entirely unused, so remove them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christian Brauner <brauner@kernel.org>
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
