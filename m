From: David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 24/27] block: remove QUEUE_FLAG_DISCARD
Date: Mon, 11 Apr 2022 19:24:21 +0200
Message-ID: <20220411172421.GU15609@twin.jikos.cz>
References: <20220409045043.23593-1-hch@lst.de>
	<20220409045043.23593-25-hch@lst.de>
Reply-To: dsterba-AlSwsSmVLrQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1649698106;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	cc:cc:mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=0RiNf7uoJjg1rRFObzVZQSCMAd1nof/h0vLpUgMcwvY=;
	b=tfXHkMaj5kpUcLtvBYnwRGxDxcXmodIyKTVNxARm8whPlAkOVHL3pBXy48YlCR99uput93
	ek64inXcfBYSt9NuV9MWohA/Liu5eXfW+58ujnwevThluScwhFajBAp+/PR+hCYJW8ogrY
	iu/7/TOOXGQ1NMcWDFWaoeOCSwaX7H0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1649698106;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	cc:cc:mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=0RiNf7uoJjg1rRFObzVZQSCMAd1nof/h0vLpUgMcwvY=;
	b=y/QeT70zXSjm5PP3weiVBlhCkwkEL69tQO+HTTi+7j+oI3RtiZJDs5egZuujl2LcaWZ24F
	apjvnh1HQMyDZeAA==
Content-Disposition: inline
In-Reply-To: <20220409045043.23593-25-hch-jcswGhMUV9g@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, nbd-2H2hN8V1XRtuHlm7Suoebg@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-btrfs@vger.

On Sat, Apr 09, 2022 at 06:50:40AM +0200, Christoph Hellwig wrote:
> Just use a non-zero max_discard_sectors as an indicator for discard
> support, similar to what is done for write zeroes.
> =

> The only places where needs special attention is the RAID5 driver,
> which must clear discard support for security reasons by default,
> even if the default stacking rules would allow for it.
> =

> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Acked-by: Christoph B=F6hmwalder <christoph.boehmwalder-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org> [btrf=
s]
> Acked-by: Coly Li <colyli-l3A5Bk7waGM@public.gmane.org> [bcache]
> ---
>  arch/um/drivers/ubd_kern.c          |  2 --
>  block/blk-core.c                    |  2 +-
>  block/blk-lib.c                     |  2 +-
>  block/blk-mq-debugfs.c              |  1 -
>  block/ioctl.c                       |  3 +--
>  drivers/block/drbd/drbd_main.c      |  2 +-
>  drivers/block/drbd/drbd_nl.c        | 19 ++-----------------
>  drivers/block/drbd/drbd_receiver.c  |  3 +--
>  drivers/block/loop.c                | 11 +++--------
>  drivers/block/nbd.c                 |  5 +----
>  drivers/block/null_blk/main.c       |  1 -
>  drivers/block/rbd.c                 |  1 -
>  drivers/block/rnbd/rnbd-clt.c       |  2 --
>  drivers/block/rnbd/rnbd-srv-dev.h   |  3 ---
>  drivers/block/virtio_blk.c          |  2 --
>  drivers/block/xen-blkback/xenbus.c  |  2 +-
>  drivers/block/xen-blkfront.c        |  2 --
>  drivers/block/zram/zram_drv.c       |  1 -
>  drivers/md/bcache/request.c         |  4 ++--
>  drivers/md/bcache/super.c           |  3 +--
>  drivers/md/bcache/sysfs.c           |  2 +-
>  drivers/md/dm-cache-target.c        |  9 +--------
>  drivers/md/dm-clone-target.c        |  9 +--------
>  drivers/md/dm-log-writes.c          |  3 +--
>  drivers/md/dm-raid.c                |  9 ++-------
>  drivers/md/dm-table.c               |  9 ++-------
>  drivers/md/dm-thin.c                | 11 +----------
>  drivers/md/dm.c                     |  3 +--
>  drivers/md/md-linear.c              | 11 +----------
>  drivers/md/raid0.c                  |  7 -------
>  drivers/md/raid1.c                  | 16 +---------------
>  drivers/md/raid10.c                 | 18 ++----------------
>  drivers/md/raid5-cache.c            |  2 +-
>  drivers/md/raid5.c                  | 12 ++++--------
>  drivers/mmc/core/queue.c            |  1 -
>  drivers/mtd/mtd_blkdevs.c           |  1 -
>  drivers/nvme/host/core.c            |  6 ++----
>  drivers/s390/block/dasd_fba.c       |  1 -
>  drivers/scsi/sd.c                   |  2 --
>  drivers/target/target_core_device.c |  2 +-

For

>  fs/btrfs/extent-tree.c              |  4 ++--
>  fs/btrfs/ioctl.c                    |  2 +-

Acked-by: David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>
