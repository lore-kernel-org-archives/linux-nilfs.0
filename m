From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/19] xen-blkback: bio_alloc can't fail if it is allow to sleep
Date: Mon, 24 Jan 2022 10:11:00 +0100
Message-ID: <20220124091107.642561-13-hch@lst.de>
References: <20220124091107.642561-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Hmdul2b824Aw+W7hsxfLRPm+W2xGls7ShW1BUgArE2A=; b=pWc0N5kYb4bArsjIbr1mc2MULT
        3C8ao+NuMPVQ2pEhWYD0pS4OEiDwzWJcF3OQWJ/7qPuRxogxWFPuvaH/AdXs6d9RZUXZ3YF8Gb0Z3
        adpO4UBuk/hqPQGUGdkP7euk2NRZzk0iS7A1P8UCLCAKB11FO7xYa9uy+6z1r53Ll03uwC/sZF7Bz
        2AYkMWod1x441+zLUUKusAzBIuZ96nUG4RvGk5j2uXutO+aMMny3ji5ZOHON/lia9Bdro8LDESVGt
        +7vVuZZXadeZX2arJ2UfxF0DCT0MLTUT8dyRYXfgOb5VGvKJj2KC8zrta0vgK9UgXnaGvmHM5Jw+1
        YxPUbcZQ==;
In-Reply-To: <20220124091107.642561-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Andrew Morton <akpm@linux-foundation.org>, "Md . Haris Iqbal " <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.co>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, xen-devel@lists.xenproject.org, drbd-dev@lists.linbit.com

Remove handling of NULL returns from sleeping bio_alloc calls given that
those can't fail.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

