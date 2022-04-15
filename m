From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/27] drbd: use bdev_alignment_offset instead of queue_alignment_offset
Date: Fri, 15 Apr 2022 06:52:37 +0200
Message-ID: <20220415045258.199825-7-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-ID:Content-Description;
        bh=pjOlLI0zIPscdljJBqydWvc1kCbsO4mNomowvsnW144=; b=qvkOjPFjyqYMQWW/2QWIK68ENP
        k2NNTMvf9yJkIIsMinaHWq3ShtV9GAA9eD1j84n/4A1YSynSJPbH7xunvM4gFW2tBAaf34uDjFYTF
        Cf27zURP5kxthNnuilxHYkuF0+dYk/s+KgITZDeRBuWDyLf29iyj7NC5GSjUBL7HTLudqqDHJV7jI
        umQOzmF/ghCqietP9jcYeXWa5VJNEKLQMKEWsHvHjmzPuAlTBx/BxH8sjV6Sj89/sE85wKvCAMm7z
        4onw1pEIPzrLUGePDGOaGXDfMTfY5lSCh3pdlvTomsyZDMHzABEpf6210R46hSLONPkgfa2cukRRf
        iN4Lrpmg==;
In-Reply-To: <20220415045258.199825-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, nbd@other.debian.org, ceph-devel@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org

The bdev version does the right thing for partitions, so use that.

Fixes: 9104d31a759f ("drbd: introduce WRITE_SAME support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christoph B=C3=B6hmwalder <christoph.boehmwalder@linbit.com>
---
 drivers/block/drbd/drbd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c39b04bda261f..7b501c8d59928 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -939,7 +939,7 @@ int drbd_send_sizes(struct drbd_peer_device *peer_devic=
e, int trigger_reply, enu
 		p->qlim->logical_block_size =3D
 			cpu_to_be32(bdev_logical_block_size(bdev));
 		p->qlim->alignment_offset =3D
-			cpu_to_be32(queue_alignment_offset(q));
+			cpu_to_be32(bdev_alignment_offset(bdev));
 		p->qlim->io_min =3D cpu_to_be32(bdev_io_min(bdev));
 		p->qlim->io_opt =3D cpu_to_be32(bdev_io_opt(bdev));
 		p->qlim->discard_enabled =3D blk_queue_discard(q);
--=20
2.30.2

