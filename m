From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/27] target: fix discard alignment on partitions
Date: Sat,  9 Apr 2022 06:50:19 +0200
Message-ID: <20220409045043.23593-4-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=OTIsP1OizukmDhxFkiULvJk6rKtH8rZ66Toc2zFZ06c=; b=UPj32NEZSs0CZXU66K8zWiAfa1
        xZi9mNnXgP+xDQL0eZfIz641yrgwphIK2vKHJq+DoAtDvElmNRgDbJUWiJ8LyL9xqUM2UWFY7Qyui
        tvbHWEmImnVRF7P5yMfrv6iT3Cq0iPs429cZILRmpjqQ1A5wLRB6v5agc1vr3+sykUaLRIBEx/Esx
        +L2whSVV5Udt9aHJm3N6VtcagVQ4jfmDqHnMwZyb9ChnAcwzA/ZypVRwhIc2odkVgg/54WmJlHYVp
        s6rib0l0pjoJtsNxoS/ADbx9+kWTDEWWDVpseZqy/qnwy7fqLCYKD3ouvwlL9wYpZg4OadMvweV7k
        BfVKIhsg==;
In-Reply-To: <20220409045043.23593-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, nbd@other.debian.org, ceph-devel@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org

Use the proper bdev_discard_alignment helper that accounts for partition
offsets.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/target/target_core_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 3a1ec705cd80b..16e775bcf4a7c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -849,8 +849,8 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
 	 */
 	attrib->max_unmap_block_desc_count = 1;
 	attrib->unmap_granularity = q->limits.discard_granularity / block_size;
-	attrib->unmap_granularity_alignment = q->limits.discard_alignment /
-								block_size;
+	attrib->unmap_granularity_alignment =
+		bdev_discard_alignment(bdev) / block_size;
 	return true;
 }
 EXPORT_SYMBOL(target_configure_unmap_from_queue);
-- 
2.30.2

