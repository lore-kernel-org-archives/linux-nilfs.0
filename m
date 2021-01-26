From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/17] md: simplify sync_page_io
Date: Tue, 26 Jan 2021 15:52:42 +0100
Message-ID: <20210126145247.1964410-13-hch@lst.de>
References: <20210126145247.1964410-1-hch@lst.de>
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
 bh=W8aYaHALoHXbZuaFOXKQTvVh+y8Fd7IAvJYrZZoNhdA=; b=QU6dIHrUKvdiqYuFRmbfS51ffv
 eNINiO6PhfgxsaCBU9yS8uGJqCyPmfmyinw1JpPBUPlI1dbTBScszz47a88yvE4cxRDNbmXw2OvJX
 0PlmqKiQzae55FG8K9aRp07ca6z1/P9xUUGpVqDlDkdrLcy2J/fvfMcLqrp2evvg+wHA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=W8aYaHALoHXbZuaFOXKQTvVh+y8Fd7IAvJYrZZoNhdA=; b=CqSbGHhrhb6q9IoTGnwQlmK24W
 KURO97d1Axgyeb4oNYvJzDGTmou9hrTT5sVgUuoeqN5ELKvsNPOoGQARPnJteG4Y4scDqdU+PTO4b
 HPQfjmuQQvgdUOUPSS9C7+y+z89wGbRfYeR/0PmsdVUV9+/vjZMah4ipe2QkctuHCIZo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=W8aYaHALoHXbZuaFOXKQTvVh+y8Fd7IAvJYrZZoNhdA=; b=JGt1JH63w8eiaQAEI4n5kVSxVw
 Yb98hQCjj4BuRaFELXNV4V1YWR5whaTFBuvsbS38JX90ZmqkewzosVaccIltP0wA2PaXodrpLDpB2
 dSjrXAgSsWvpd2IUnGUtb9AYtQSvL35vq7Nk0hrDytjnDJgyME8PkByHiOhSAl9mtgqEmnzC6m+1a
 27nBnbSxYEnE4x0UzJcki15gkshb+GwSUKKI0Oto59KylHdpnaNOwDbNnn+gdjEjJTFJ/NFEbW1sE
 0TONqXtHBo84FuLa/h+/kr81vIkdUY2Vm7qMY41RhMKFBZje5JtOQrBJAVRfoZsXINuN6WnyqR5mx
 9qSFgATA==;
In-Reply-To: <20210126145247.1964410-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, Naohiro Aota <naohiro.aota@wdc.com>, linux-nilfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, linux-nfs@vger.kernel.org, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Andrew Morton <akpm@linux-foundation.org>, Philipp Reisner <philipp.reisner@linbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-btrfs@vger.kernel.org

Use an on-stack bio and biovec for the single page synchronous I/O.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e2b9dbb6e888f6..6a27f52007c871 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1021,29 +1021,29 @@ int md_super_wait(struct mddev *mddev)
 int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		 struct page *page, int op, int op_flags, bool metadata_op)
 {
-	struct bio *bio = md_bio_alloc_sync(rdev->mddev);
-	int ret;
+	struct bio bio;
+	struct bio_vec bvec;
+
+	bio_init(&bio, &bvec, 1);
 
 	if (metadata_op && rdev->meta_bdev)
-		bio_set_dev(bio, rdev->meta_bdev);
+		bio_set_dev(&bio, rdev->meta_bdev);
 	else
-		bio_set_dev(bio, rdev->bdev);
-	bio_set_op_attrs(bio, op, op_flags);
+		bio_set_dev(&bio, rdev->bdev);
+	bio.bi_opf = op | op_flags;
 	if (metadata_op)
-		bio->bi_iter.bi_sector = sector + rdev->sb_start;
+		bio.bi_iter.bi_sector = sector + rdev->sb_start;
 	else if (rdev->mddev->reshape_position != MaxSector &&
 		 (rdev->mddev->reshape_backwards ==
 		  (sector >= rdev->mddev->reshape_position)))
-		bio->bi_iter.bi_sector = sector + rdev->new_data_offset;
+		bio.bi_iter.bi_sector = sector + rdev->new_data_offset;
 	else
-		bio->bi_iter.bi_sector = sector + rdev->data_offset;
-	bio_add_page(bio, page, size, 0);
+		bio.bi_iter.bi_sector = sector + rdev->data_offset;
+	bio_add_page(&bio, page, size, 0);
 
-	submit_bio_wait(bio);
+	submit_bio_wait(&bio);
 
-	ret = !bio->bi_status;
-	bio_put(bio);
-	return ret;
+	return !bio.bi_status;
 }
 EXPORT_SYMBOL_GPL(sync_page_io);
 
-- 
2.29.2
