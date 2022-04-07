From: Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 25/27] block: remove QUEUE_FLAG_DISCARD
Date: Thu, 7 Apr 2022 13:18:49 +0800
Message-ID: <f326944f-46b1-e888-18f6-97dcf69d945d@suse.de>
References: <20220406060516.409838-1-hch@lst.de>
	<20220406060516.409838-26-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1649308737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=A+yNUODWma7WknR/jI5cBa/CbnRiNAE8PcMaVQDIzR4=;
	b=mnCB1gF89XJ5ZS0vn/sLXjbjQHE0OVf5/BCbnACnemfg918qFrAMS1uu96deBrWbKaTk0y
	986H3NVh/IurAPnL2y9HkNS4LPMQclLG/RGT1PVgOxZNeKUsvsv1qbmzIT0Ddpaw+xC6qE
	NWA7dPYsE9i1SiYQLl3VkO1mNMjLBac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1649308737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=A+yNUODWma7WknR/jI5cBa/CbnRiNAE8PcMaVQDIzR4=;
	b=kD2ssGZ1opFQemhwtjj59lbGNVo/3qb1+9BNGH243uIB4Twx+Dpu/NW4coV8ja6JRSUAIx
	INPQyHL1JAX+fNCg==
Content-Language: en-US
In-Reply-To: <20220406060516.409838-26-hch-jcswGhMUV9g@public.gmane.org>
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, nbd-2H2hN8V1XRtuHlm7Suoebg@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 4/6/22 2:05 PM, Christoph Hellwig wrote:
> Just use a non-zero max_discard_sectors as an indicator for discard
> support, similar to what is done for write zeroes.
>
> The only places where needs special attention is the RAID5 driver,
> which must clear discard support for security reasons by default,
> even if the default stacking rules would allow for it.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

For the bcache part,

Acked-by: Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>


Thanks.

Coly Li


> ---
>   arch/um/drivers/ubd_kern.c    |  2 --
>   block/blk-mq-debugfs.c        |  1 -
>   drivers/block/drbd/drbd_nl.c  | 15 ---------------
>   drivers/block/loop.c          |  2 --
>   drivers/block/nbd.c           |  3 ---
>   drivers/block/null_blk/main.c |  1 -
>   drivers/block/rbd.c           |  1 -
>   drivers/block/rnbd/rnbd-clt.c |  2 --
>   drivers/block/virtio_blk.c    |  2 --
>   drivers/block/xen-blkfront.c  |  2 --
>   drivers/block/zram/zram_drv.c |  1 -
>   drivers/md/bcache/super.c     |  1 -
>   drivers/md/dm-table.c         |  5 +----
>   drivers/md/dm-thin.c          |  2 --
>   drivers/md/dm.c               |  1 -
>   drivers/md/md-linear.c        |  9 ---------
>   drivers/md/raid0.c            |  7 -------
>   drivers/md/raid1.c            | 14 --------------
>   drivers/md/raid10.c           | 14 --------------
>   drivers/md/raid5.c            | 12 ++++--------
>   drivers/mmc/core/queue.c      |  1 -
>   drivers/mtd/mtd_blkdevs.c     |  1 -
>   drivers/nvme/host/core.c      |  6 ++----
>   drivers/s390/block/dasd_fba.c |  1 -
>   drivers/scsi/sd.c             |  2 --
>   include/linux/blkdev.h        |  2 --
>   26 files changed, 7 insertions(+), 103 deletions(-)
[snipped]
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 296f200b2e208..2f49e31142f62 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -973,7 +973,6 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>   
>   	blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
>   	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);
> -	blk_queue_flag_set(QUEUE_FLAG_DISCARD, d->disk->queue);
>   
>   	blk_queue_write_cache(q, true, true);
>   


[snipped]
