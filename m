From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 04/27] drbd: remove assign_p_sizes_qlim
Date: Fri, 15 Apr 2022 06:52:35 +0200
Message-ID: <20220415045258.199825-5-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-ID:Content-Description;
        bh=be5XRqr6FpD/xPCRROQj1WW79ZNoTG4VrTyORPZGjVE=; b=zfdoWKjLNg8/93VMXMR/8dmem+
        WdvS+5iIu6uir1zneoGsW/PVn5k5msDFRP3cNUjzgk48HwXHEWdbPPQegdyt6x56ivnd6KhVFEdRn
        raW2CONj2YH3bKud1GU1IPcR9v/j6pw0pUmG9drywqIdz4cTw9frqxiK8uJ0qudjT7ff4EmR2zNpd
        iXKlU7IflKK7BZ1vMlEvBpbCIpEVLMDJnliSIXYAubrng3TWL7OH99pGfDALzISzxUUJefgBXG3V5
        WlBB+jh7r7m3TcfVeysrxVV3wHeAvYOUUoaQFeOXr6OBj0iU6tL7PMj+sYlQjUaSSJXCl4UqBVXnS
        NdWcSxoQ==;
In-Reply-To: <20220415045258.199825-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, nbd-2H2hN8V1XRtuHlm7Suoebg@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Fold each branch into its only caller.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Christoph B=C3=B6hmwalder <christoph.boehmwalder-63ez5xqkn6DQT0dZ=
R+AlfA@public.gmane.org>
---
 drivers/block/drbd/drbd_main.c | 47 +++++++++++++++-------------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 4b0b25cc916ee..367715205c860 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -903,31 +903,6 @@ void drbd_gen_and_send_sync_uuid(struct drbd_peer_devi=
ce *peer_device)
 	}
 }
=20
-/* communicated if (agreed_features & DRBD_FF_WSAME) */
-static void
-assign_p_sizes_qlim(struct drbd_device *device, struct p_sizes *p,
-					struct request_queue *q)
-{
-	if (q) {
-		p->qlim->physical_block_size =3D cpu_to_be32(queue_physical_block_size(q=
));
-		p->qlim->logical_block_size =3D cpu_to_be32(queue_logical_block_size(q));
-		p->qlim->alignment_offset =3D cpu_to_be32(queue_alignment_offset(q));
-		p->qlim->io_min =3D cpu_to_be32(queue_io_min(q));
-		p->qlim->io_opt =3D cpu_to_be32(queue_io_opt(q));
-		p->qlim->discard_enabled =3D blk_queue_discard(q);
-		p->qlim->write_same_capable =3D 0;
-	} else {
-		q =3D device->rq_queue;
-		p->qlim->physical_block_size =3D cpu_to_be32(queue_physical_block_size(q=
));
-		p->qlim->logical_block_size =3D cpu_to_be32(queue_logical_block_size(q));
-		p->qlim->alignment_offset =3D 0;
-		p->qlim->io_min =3D cpu_to_be32(queue_io_min(q));
-		p->qlim->io_opt =3D cpu_to_be32(queue_io_opt(q));
-		p->qlim->discard_enabled =3D 0;
-		p->qlim->write_same_capable =3D 0;
-	}
-}
-
 int drbd_send_sizes(struct drbd_peer_device *peer_device, int trigger_repl=
y, enum dds_flags flags)
 {
 	struct drbd_device *device =3D peer_device->device;
@@ -957,14 +932,32 @@ int drbd_send_sizes(struct drbd_peer_device *peer_dev=
ice, int trigger_reply, enu
 		q_order_type =3D drbd_queue_order_type(device);
 		max_bio_size =3D queue_max_hw_sectors(q) << 9;
 		max_bio_size =3D min(max_bio_size, DRBD_MAX_BIO_SIZE);
-		assign_p_sizes_qlim(device, p, q);
+		p->qlim->physical_block_size =3D
+			cpu_to_be32(queue_physical_block_size(q));
+		p->qlim->logical_block_size =3D
+			cpu_to_be32(queue_logical_block_size(q));
+		p->qlim->alignment_offset =3D
+			cpu_to_be32(queue_alignment_offset(q));
+		p->qlim->io_min =3D cpu_to_be32(queue_io_min(q));
+		p->qlim->io_opt =3D cpu_to_be32(queue_io_opt(q));
+		p->qlim->discard_enabled =3D blk_queue_discard(q);
 		put_ldev(device);
 	} else {
+		struct request_queue *q =3D device->rq_queue;
+
+		p->qlim->physical_block_size =3D
+			cpu_to_be32(queue_physical_block_size(q));
+		p->qlim->logical_block_size =3D
+			cpu_to_be32(queue_logical_block_size(q));
+		p->qlim->alignment_offset =3D 0;
+		p->qlim->io_min =3D cpu_to_be32(queue_io_min(q));
+		p->qlim->io_opt =3D cpu_to_be32(queue_io_opt(q));
+		p->qlim->discard_enabled =3D 0;
+
 		d_size =3D 0;
 		u_size =3D 0;
 		q_order_type =3D QUEUE_ORDERED_NONE;
 		max_bio_size =3D DRBD_MAX_BIO_SIZE; /* ... multiple BIOs per peer_reques=
t */
-		assign_p_sizes_qlim(device, p, NULL);
 	}
=20
 	if (peer_device->connection->agreed_pro_version <=3D 94)
--=20
2.30.2

