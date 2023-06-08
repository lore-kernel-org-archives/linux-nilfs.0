From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/30] ubd: remove commented out code in ubd_open
Date: Thu,  8 Jun 2023 13:02:52 +0200
Message-ID: <20230608110258.189493-25-hch@lst.de>
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
 bh=POouKGvveG/KhITgHpTZ7KYqo/RAGhaN1xR2Wciupo0=; b=FZzebwhfVz0Bl9W4OpfmqA1xBx
 vaxgk0S/KoMdPWSalTI00PCMbspBVnEnbP3rA+G+Ad7r+z+WWSnZwEZyoskJ9zJK0C9zeq62AOGnh
 EQlqtv7YJlOq84wm/6LS5fINMHzsj7Feb2duXG0b++IWLJkVcRhZ38za83AaBJYTgmew=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=POouKGvveG/KhITgHpTZ7KYqo/RAGhaN1xR2Wciupo0=; b=D7lCSlMgzi1xmeW4Dmvn9l80Ft
 mAB/gJN4f6CrN6K/HJhjObYjI6TxDpxQR2UAjJOVlNDG4Bz0JAOwlQfKbPbRqH7YHAOrTRLHtv/pG
 8IMlDQDNy7R982cJU1Y5FaT33rZytaGfdU+deHb9azrpJ7OXYiy4PIs+fl46qBjCta+Q=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=POouKGvveG/KhITgHpTZ7KYqo/RAGhaN1xR2Wciupo0=; b=EcIzCKB9dEH30RjdEI/DabgwV/
 6ZE+m+wtvZk6OlgaAm4++oJn5FTLnCIoCYvUSixjcb5vsY48DtbyAF4PDNJ/rUJORL1vNC823Al4U
 VogmIfb6HzJmAK7DP+LO5jRK6FEnbun1AtQpt1pPcF50L3s5FmpYxmyflfpxPuE7q7N0wzfVyrSB8
 mNHn32tzxgxj01b+nT/bN6+F8F6UZG8I0kTELL4n7KxuHYSBQ/GlztYhMGyhnBDpN7FKP/M06AY4h
 ARLvSfsMwWJCnbdIol8AZA7AQ8Dfm329oHy3IynpXfnam/tcuzu3MT53AqEu8DXAUCaDdLeh7/WED
 B7h06UbQ==;
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

This code has been dead forever, make sure it doesn't show up in code
searches.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Acked-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/ubd_kern.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 8b79554968addb..20c1a16199c503 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1170,13 +1170,6 @@ static int ubd_open(struct gendisk *disk, fmode_t mode)
 	}
 	ubd_dev->count++;
 	set_disk_ro(disk, !ubd_dev->openflags.w);
-
-	/* This should no more be needed. And it didn't work anyway to exclude
-	 * read-write remounting of filesystems.*/
-	/*if((mode & FMODE_WRITE) && !ubd_dev->openflags.w){
-	        if(--ubd_dev->count == 0) ubd_close_dev(ubd_dev);
-	        err = -EROFS;
-	}*/
 out:
 	mutex_unlock(&ubd_mutex);
 	return err;
-- 
2.39.2
