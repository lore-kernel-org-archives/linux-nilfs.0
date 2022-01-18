From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 12/19] xen-blkback: bio_alloc can't fail if it is allow to sleep
Date: Tue, 18 Jan 2022 08:19:45 +0100
Message-ID: <20220118071952.1243143-13-hch@lst.de>
References: <20220118071952.1243143-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Hmdul2b824Aw+W7hsxfLRPm+W2xGls7ShW1BUgArE2A=; b=FlSg7Ip4B3XJbqRLUazSGBl6sY
        aCwhXTmbowZx9b2j7qi2Hd8DnfbGH4eiPxuAaA2nRPne046/wmkaYlrnWHmDzVrmLfbwtcNrB2Y5G
        L2k1rbD83lcM9y55YgCjdm3x34WIVHPPGGKbMAMBTkOlHX1/RYAWfOSXMvKfFfvu+z6XGHMVcEUOc
        GTFWU4kS/QuprLIJtVIfCwCheJZFCG7BPLBRkxMUGQVd05jFWnJg0a/6rUFRuwjohPcbkpzQsrxtv
        nMW27Vau8u3rAodC7STr3O6ThI27hF4j362D5p61hPICn2G3bNrEpQc2H7FsOMM9QEe/wLR7EuIoO
        m2N3R2JA==;
In-Reply-To: <20220118071952.1243143-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Md . Haris Iqbal " <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau-Sxgqhf6Nn4Bhl2p70BpVqQ@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org

Remove handling of NULL returns from sleeping bio_alloc calls given that
those can't fail.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/block/xen-blkback/blkback.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 14e452896d04c..6bb2ad7692065 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -1327,9 +1327,6 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 				     seg[i].nsec << 9,
 				     seg[i].offset) == 0)) {
 			bio = bio_alloc(GFP_KERNEL, bio_max_segs(nseg - i));
-			if (unlikely(bio == NULL))
-				goto fail_put_bio;
-
 			biolist[nbio++] = bio;
 			bio_set_dev(bio, preq.bdev);
 			bio->bi_private = pending_req;
@@ -1346,9 +1343,6 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 		BUG_ON(operation_flags != REQ_PREFLUSH);
 
 		bio = bio_alloc(GFP_KERNEL, 0);
-		if (unlikely(bio == NULL))
-			goto fail_put_bio;
-
 		biolist[nbio++] = bio;
 		bio_set_dev(bio, preq.bdev);
 		bio->bi_private = pending_req;
@@ -1381,14 +1375,6 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 	free_req(ring, pending_req);
 	msleep(1); /* back off a bit */
 	return -EIO;
-
- fail_put_bio:
-	for (i = 0; i < nbio; i++)
-		bio_put(biolist[i]);
-	atomic_set(&pending_req->pendcnt, 1);
-	__end_block_io_op(pending_req, BLK_STS_RESOURCE);
-	msleep(1); /* back off a bit */
-	return -EIO;
 }
 
 
-- 
2.30.2

