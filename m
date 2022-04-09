From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/27] mm: use bdev_is_zoned in claim_swapfile
Date: Sat,  9 Apr 2022 06:50:26 +0200
Message-ID: <20220409045043.23593-11-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=OGJvHxXgCvw9/l2/0Y6T0ivupEa5/VICLVgDi4pj6zk=; b=bvdxNtIBSK2e/CHWOJvjhJQ/pD
 ziWAaN1+H5rv0PFjwCtxUb32HQisXqhv0CfdNRRakGSvxS2SlGM7sa31KM+kznDnIR/AZLVb6CdU4
 vS8DuWDB+gUHx5md6g+mCQSqz3crMjKTJ6PsdykxY9osHuidQtFbDkq6qQ9nvfWGIgIk4Rkp02Mzl
 WCYI+BDG1gl4hW/mPoncA+V1yctBgiee9+ltyBfbzQvs00T9mPYBlaJ4i/TRsB0Z4Fkgt4oIU5qzV
 IXkEEPpdqsWu7ooiuyvMhxa14Ribw7Jyx9BT4vHhU8n59256QhhUPR6N/0aIFpZCRpJfpeccBNtOP
 uiV7Ifjw==;
In-Reply-To: <20220409045043.23593-1-hch@lst.de>
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

Use the bdev based helper instead of poking into the queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 63c61f8b26118..4c7537162af5e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2761,7 +2761,7 @@ static int claim_swapfile(struct swap_info_struct *p, struct inode *inode)
 		 * write only restriction.  Hence zoned block devices are not
 		 * suitable for swapping.  Disallow them here.
 		 */
-		if (blk_queue_is_zoned(p->bdev->bd_disk->queue))
+		if (bdev_is_zoned(p->bdev))
 			return -EINVAL;
 		p->flags |= SWP_BLKDEV;
 	} else if (S_ISREG(inode->i_mode)) {
-- 
2.30.2
