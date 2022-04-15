From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/27] drbd: use bdev based limit helpers in drbd_send_sizes
Date: Fri, 15 Apr 2022 06:52:36 +0200
Message-ID: <20220415045258.199825-6-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-ID:Content-Description;
        bh=XZGhvwW8WnEXnqFpyMAZS4hEeSHoeSYBiqC69zbelFo=; b=Gxz7Y5uJ+XKe3DFB5F+glNf4Qd
        +ilmHliKeg1fmYV7/5LLANJc72+LNxw8j97CHk5ziFCgc1uz7kS3J7fxsGIO6cnBRc/aEIND8YKio
        0SkKbU86rwF6U+vXBBwyr3GFqwWasgE9TCw8n+hO0zPxSPP5I4ZPpiX7PrV0Nkluz9OYVJwj4Hmwy
        oKidnHT0/AqxHbe4vf+J+1VyQBy8myzVvzFwGzWB5MOWnMsTyORGtxjAzgY+jPvDzJzijUERBo3GF
        IuBPqJCO6mtg8vZGmw86bOvzf7HW3Tdf+1Wt8evubUZivpuvFh33FBjqoHj3OCwfnGHVCD1k5Crl7
        crl4uuXw==;
In-Reply-To: <20220415045258.199825-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, nbd@other.debian.org, ceph-devel@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org

Use the bdev based limits helpers where they exist.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christoph B=C3=B6hmwalder <christoph.boehmwalder@linbit.com>
---
 drivers/block/drbd/drbd_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 367715205c860..c39b04bda261f 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -924,7 +924,9 @@ int drbd_send_sizes(struct drbd_peer_device *peer_devic=
e, int trigger_reply, enu
=20
 	memset(p, 0, packet_size);
 	if (get_ldev_if_state(device, D_NEGOTIATING)) {
-		struct request_queue *q =3D bdev_get_queue(device->ldev->backing_bdev);
+		struct block_device *bdev =3D device->ldev->backing_bdev;
+		struct request_queue *q =3D bdev_get_queue(bdev);
+
 		d_size =3D drbd_get_max_capacity(device->ldev);
 		rcu_read_lock();
 		u_size =3D rcu_dereference(device->ldev->disk_conf)->disk_size;
@@ -933,13 +935,13 @@ int drbd_send_sizes(struct drbd_peer_device *peer_dev=
ice, int trigger_reply, enu
 		max_bio_size =3D queue_max_hw_sectors(q) << 9;
 		max_bio_size =3D min(max_bio_size, DRBD_MAX_BIO_SIZE);
 		p->qlim->physical_block_size =3D
-			cpu_to_be32(queue_physical_block_size(q));
+			cpu_to_be32(bdev_physical_block_size(bdev));
 		p->qlim->logical_block_size =3D
-			cpu_to_be32(queue_logical_block_size(q));
+			cpu_to_be32(bdev_logical_block_size(bdev));
 		p->qlim->alignment_offset =3D
 			cpu_to_be32(queue_alignment_offset(q));
-		p->qlim->io_min =3D cpu_to_be32(queue_io_min(q));
-		p->qlim->io_opt =3D cpu_to_be32(queue_io_opt(q));
+		p->qlim->io_min =3D cpu_to_be32(bdev_io_min(bdev));
+		p->qlim->io_opt =3D cpu_to_be32(bdev_io_opt(bdev));
 		p->qlim->discard_enabled =3D blk_queue_discard(q);
 		put_ldev(device);
 	} else {
--=20
2.30.2

