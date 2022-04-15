From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/27] block: use bdev_alignment_offset in
 disk_alignment_offset_show
Date: Fri, 15 Apr 2022 06:52:48 +0200
Message-ID: <20220415045258.199825-18-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=q2ranmlO4Nl6vweHnkN5W/lhAXFqjXPKY6W4cI6bGNw=; b=Imm4Yfj4lK8os56GTjHtESv8Ln
 /f/n//I9UVgO0gz0loVNZo7Kx8U2lN8GWuypT8815hL/Cbxkr3GIfFYT2oap2P7u27ZNlfV4ESUm3
 nUKYekUTiCtdte0HtVU0mfHtnc1JSUCyagOIpbgNEzqbzUQNiwlEp8m5sb47dsYKebQL4R3A3Igsy
 dTbWNMbYDJIYjtYyj8uxb8rBDcOQ+bzOZSC1SBOJPEIu1iXFYJPGOni5DOCC7FW8wOycr+QifG/Wg
 MwWy7d+vMvWLfxa4iMbFhmkTIzHqao0ZRSaYQGzHa37lKAGUhFr/qfO/PDwSf9PSBl8O2KxhcHtX4
 P2d5tlXw==;
In-Reply-To: <20220415045258.199825-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Errors-To: virtualization-bounces@lists.linux-foundation.org
Sender: "Virtualization" <virtualization-bounces@lists.linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org

This does the same as the open coded variant except for an extra branch,
and allows to remove queue_alignment_offset entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/genhd.c          | 2 +-
 include/linux/blkdev.h | 8 --------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b8b6759d670f0..712031ce19070 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1010,7 +1010,7 @@ static ssize_t disk_alignment_offset_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", queue_alignment_offset(disk->queue));
+	return sprintf(buf, "%d\n", bdev_alignment_offset(disk->part0));
 }
 
 static ssize_t disk_discard_alignment_show(struct device *dev,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f8c50b77543eb..d5346e72e3645 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1251,14 +1251,6 @@ bdev_zone_write_granularity(struct block_device *bdev)
 	return queue_zone_write_granularity(bdev_get_queue(bdev));
 }
 
-static inline int queue_alignment_offset(const struct request_queue *q)
-{
-	if (q->limits.misaligned)
-		return -1;
-
-	return q->limits.alignment_offset;
-}
-
 static inline int queue_limit_alignment_offset(struct queue_limits *lim, sector_t sector)
 {
 	unsigned int granularity = max(lim->physical_block_size, lim->io_min);
-- 
2.30.2
