From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/27] block: use bdev_alignment_offset in
 part_alignment_offset_show
Date: Wed,  6 Apr 2022 08:05:04 +0200
Message-ID: <20220406060516.409838-16-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=Z466ZFUUKBaH6hbYD0HK+8FHR1O7bsGB8sNIWBFJhOk=; b=nZyFe69pq6eqf1/kF5nMPTOAne
 TDtMwcoIcF1YVH8vK4pZn8SWXmvAy4dj0YLO+u7/f/B2HIjYkBtn4UJ8NiskaBRp3fwS47roOcVRe
 vLIrpgEvmwBi0TgLuCY4ho1EAziykjm9zmNebUkK6neSzMI32Ao85X2VP0v0J3+9ko5w3milUn2Og
 nHnr9afoa38HHNP14nGQNi1dlupB12CTU0omTrFBjKA0bBmskFyATPVPaofHC89rc0iWDgo4hGjmw
 mUDsTYktHm80+vK4Z5OqBaEmEbibKoSEKtnP9u44j73GVKdSFe+O7hLNHxfOqHQlf6RzKBjJvj/fx
 be/fnxdQ==;
In-Reply-To: <20220406060516.409838-1-hch@lst.de>
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
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org

Replace the open coded offset calculation with the proper helper.
This is an ABI change in that the -1 for a misaligned partition is
properly propagated, which can be considered a bug fix and maches
what is done on the whole device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/partitions/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 2ef8dfa1e5c85..240b3fff521e4 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -200,11 +200,7 @@ static ssize_t part_ro_show(struct device *dev,
 static ssize_t part_alignment_offset_show(struct device *dev,
 					  struct device_attribute *attr, char *buf)
 {
-	struct block_device *bdev = dev_to_bdev(dev);
-
-	return sprintf(buf, "%u\n",
-		queue_limit_alignment_offset(&bdev_get_queue(bdev)->limits,
-				bdev->bd_start_sect));
+	return sprintf(buf, "%u\n", bdev_alignment_offset(dev_to_bdev(dev)));
 }
 
 static ssize_t part_discard_alignment_show(struct device *dev,
-- 
2.30.2
