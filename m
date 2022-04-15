From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/27] drbd: cleanup decide_on_discard_support
Date: Fri, 15 Apr 2022 06:52:38 +0200
Message-ID: <20220415045258.199825-8-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-ID:Content-Description;
        bh=9tUaZULhEmteAuYmNe/S5K85i8mY+zpV/R7NWj8li0M=; b=AjCBuPx/UHSGTakXv8HXmgNw4N
        Iyofq9wNNzfgjbG93scprq/gUs5OOhFUGL0tKjcj2IWWkpHNBkXqusk5CV5Uj/P/70TymjB6Unzdu
        VnxSzUtQb3ldimIkXALq/IfCXSo1TL1NzeISVmz+Ea7q6xFf02zHvxp+FndxH2zbBXHBFRTOnXe4c
        nAXrXpjx27cFTMs0mjOzvEq3gOjLOY6hKIcglkznMntAYg+vXORRN23xzGalvjS8R6ccxTXJWj8QW
        sdXJMYerLCI2QfFcDPA/f8tI4pucu7JSpv7rjXlKJh5WSo2NBa1UXNlyVf9emnFeALezPoiPRp2d8
        jaVM4Jaw==;
In-Reply-To: <20220415045258.199825-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, nbd@other.debian.org, ceph-devel@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org

Sanitize the calling conventions and use a goto label to cleanup the
code flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christoph B=C3=B6hmwalder <christoph.boehmwalder@linbit.com>
---
 drivers/block/drbd/drbd_nl.c | 68 +++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index b7216c186ba4d..4d00986d6f588 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1204,38 +1204,42 @@ static unsigned int drbd_max_discard_sectors(struct=
 drbd_connection *connection)
 }
=20
 static void decide_on_discard_support(struct drbd_device *device,
-			struct request_queue *q,
-			struct request_queue *b,
-			bool discard_zeroes_if_aligned)
+		struct drbd_backing_dev *bdev)
 {
-	/* q =3D drbd device queue (device->rq_queue)
-	 * b =3D backing device queue (device->ldev->backing_bdev->bd_disk->queue=
),
-	 *     or NULL if diskless
-	 */
-	struct drbd_connection *connection =3D first_peer_device(device)->connect=
ion;
-	bool can_do =3D b ? blk_queue_discard(b) : true;
-
-	if (can_do && connection->cstate >=3D C_CONNECTED && !(connection->agreed=
_features & DRBD_FF_TRIM)) {
-		can_do =3D false;
-		drbd_info(connection, "peer DRBD too old, does not support TRIM: disabli=
ng discards\n");
-	}
-	if (can_do) {
-		/* We don't care for the granularity, really.
-		 * Stacking limits below should fix it for the local
-		 * device.  Whether or not it is a suitable granularity
-		 * on the remote device is not our problem, really. If
-		 * you care, you need to use devices with similar
-		 * topology on all peers. */
-		blk_queue_discard_granularity(q, 512);
-		q->limits.max_discard_sectors =3D drbd_max_discard_sectors(connection);
-		blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
-		q->limits.max_write_zeroes_sectors =3D drbd_max_discard_sectors(connecti=
on);
-	} else {
-		blk_queue_flag_clear(QUEUE_FLAG_DISCARD, q);
-		blk_queue_discard_granularity(q, 0);
-		q->limits.max_discard_sectors =3D 0;
-		q->limits.max_write_zeroes_sectors =3D 0;
+	struct drbd_connection *connection =3D
+		first_peer_device(device)->connection;
+	struct request_queue *q =3D device->rq_queue;
+
+	if (bdev && !blk_queue_discard(bdev->backing_bdev->bd_disk->queue))
+		goto not_supported;
+
+	if (connection->cstate >=3D C_CONNECTED &&
+	    !(connection->agreed_features & DRBD_FF_TRIM)) {
+		drbd_info(connection,
+			"peer DRBD too old, does not support TRIM: disabling discards\n");
+		goto not_supported;
 	}
+
+	/*
+	 * We don't care for the granularity, really.
+	 *
+	 * Stacking limits below should fix it for the local device.  Whether or
+	 * not it is a suitable granularity on the remote device is not our
+	 * problem, really. If you care, you need to use devices with similar
+	 * topology on all peers.
+	 */
+	blk_queue_discard_granularity(q, 512);
+	q->limits.max_discard_sectors =3D drbd_max_discard_sectors(connection);
+	blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
+	q->limits.max_write_zeroes_sectors =3D
+		drbd_max_discard_sectors(connection);
+	return;
+
+not_supported:
+	blk_queue_flag_clear(QUEUE_FLAG_DISCARD, q);
+	blk_queue_discard_granularity(q, 0);
+	q->limits.max_discard_sectors =3D 0;
+	q->limits.max_write_zeroes_sectors =3D 0;
 }
=20
 static void fixup_discard_if_not_supported(struct request_queue *q)
@@ -1273,7 +1277,6 @@ static void drbd_setup_queue_param(struct drbd_device=
 *device, struct drbd_backi
 	unsigned int max_segments =3D 0;
 	struct request_queue *b =3D NULL;
 	struct disk_conf *dc;
-	bool discard_zeroes_if_aligned =3D true;
=20
 	if (bdev) {
 		b =3D bdev->backing_bdev->bd_disk->queue;
@@ -1282,7 +1285,6 @@ static void drbd_setup_queue_param(struct drbd_device=
 *device, struct drbd_backi
 		rcu_read_lock();
 		dc =3D rcu_dereference(device->ldev->disk_conf);
 		max_segments =3D dc->max_bio_bvecs;
-		discard_zeroes_if_aligned =3D dc->discard_zeroes_if_aligned;
 		rcu_read_unlock();
=20
 		blk_set_stacking_limits(&q->limits);
@@ -1292,7 +1294,7 @@ static void drbd_setup_queue_param(struct drbd_device=
 *device, struct drbd_backi
 	/* This is the workaround for "bio would need to, but cannot, be split" */
 	blk_queue_max_segments(q, max_segments ? max_segments : BLK_MAX_SEGMENTS);
 	blk_queue_segment_boundary(q, PAGE_SIZE-1);
-	decide_on_discard_support(device, q, b, discard_zeroes_if_aligned);
+	decide_on_discard_support(device, bdev);
=20
 	if (b) {
 		blk_stack_limits(&q->limits, &b->limits, 0);
--=20
2.30.2

