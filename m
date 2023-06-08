From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/30] swsusp: don't pass a stack address to
 blkdev_get_by_path
Date: Thu,  8 Jun 2023 13:02:39 +0200
Message-ID: <20230608110258.189493-12-hch@lst.de>
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
 bh=BWc5z9HT4dUA9mjQNGkIg08JFiqviKFgFc2kwBdnmvA=; b=LvJv/A6yU6ExdrZ6m1FDlDxTFB
 TG0QpAdJ7TO8Pq+KZvQ4eDD7ebZQj2tXXqET/1gNJbfuS4z7WeJcweuvmpowoD2D2sFmN5XK1on5L
 ncQ4lD+3V9Pkfj+yqpiH4xbxlr/Nsocw6BPMkHq2vutGS5m4HeBRj5xrDKYxYh+rIHAM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=BWc5z9HT4dUA9mjQNGkIg08JFiqviKFgFc2kwBdnmvA=; b=GwsI8zzZRjUNyQ33Uva7xAddNy
 rbYMYSmfRDxbPB2nNdPMNzGuOXI9NISJExjBDIyDYuvRzq/Smd901IcmK61sMpxDGY64vexQ4mLZr
 J4Pg7QBdA7ukbcryvb68BvDT0441GMto306r97mv4HuUuphI+arAp4TxiKmWcvdkRvdU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=BWc5z9HT4dUA9mjQNGkIg08JFiqviKFgFc2kwBdnmvA=; b=DSaSxe/TisXuiNZhOR1TgSi7tx
 33lAtkUXPMOr9WQm9Z+HhNKEJGoeKJSluj7uhXRCmimH7VoHS0E0fvUNcZ7UiWxsb/tBtz6fXhZlr
 GE9jtxC+Q8FoQSEQz+4vk9nOOH8BTAjfrUuFLcHba2SvPuPGZNkEv8QjVxkATSDkihbdNi6umKqVB
 7p2NEvk5EAeqwWcAKAwVWRbUBkG4tyEy/NutpgRnWrvU0mWTHAqNh1aG3veS9lJl/Zm3XwnRRN4uy
 kPNwBnK5dcXc2ETiMnCmg0liMCPKVYmWiFEJ6OPE/jhf6OnfgqyBEoO+PrWwml+/G7QKTlQlKNK+/
 sLCUxnmg==;
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

holder is just an on-stack pointer that can easily be reused by other calls,
replace it with a static variable that doesn't change.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 kernel/power/swap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 81aec3b2c60510..b03ff1a33c7f68 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -1510,6 +1510,8 @@ int swsusp_read(unsigned int *flags_p)
 	return error;
 }
 
+static void *swsusp_holder;
+
 /**
  *      swsusp_check - Check for swsusp signature in the resume device
  */
@@ -1517,14 +1519,13 @@ int swsusp_read(unsigned int *flags_p)
 int swsusp_check(bool snapshot_test)
 {
 	int error;
-	void *holder;
 	fmode_t mode = FMODE_READ;
 
 	if (snapshot_test)
 		mode |= FMODE_EXCL;
 
 	hib_resume_bdev = blkdev_get_by_dev(swsusp_resume_device,
-					    mode, &holder, NULL);
+					    mode, &swsusp_holder, NULL);
 	if (!IS_ERR(hib_resume_bdev)) {
 		set_blocksize(hib_resume_bdev, PAGE_SIZE);
 		clear_page(swsusp_header);
-- 
2.39.2
