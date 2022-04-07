From: Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 26/27] block: uncouple REQ_OP_SECURE_ERASE
 from REQ_OP_DISCARD
Date: Thu, 7 Apr 2022 14:09:30 +0800
Message-ID: <ac88801d-c1f9-e8a4-e0cf-e5f7cbdfbfc3@suse.de>
References: <20220406060516.409838-1-hch@lst.de>
	<20220406060516.409838-27-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1649311777;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=JT4UvlPRTF1rf1PNVYTQl5oxY75vXHbMm6cxI+vJlzM=;
	b=wOiyRM1WKAijaiXA/6UPpDOabfmgWyFiXfUydWL/10ZCv7yghtyaXvUcoBtsxJ2dnhBhf4
	MXxBRV2J27Fs0oBPGyW3Bcz1OeFP7yQybfPi0d2TDSS1Rp6Pn1IPyM3ErNotkeHAJf1Ysz
	2ylrrplM7mJGkpksfcE/0PXv/RJ0b84=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1649311777;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=JT4UvlPRTF1rf1PNVYTQl5oxY75vXHbMm6cxI+vJlzM=;
	b=qH6/6KvekVW7yUEoPIXC0j8Nl8eBqt7dLT/vdiczEh3nQdRmXIIFkTLVPwnvPg8wyiCLJm
	FUCApLKkaSIR8qDQ==
Content-Language: en-US
In-Reply-To: <20220406060516.409838-27-hch-jcswGhMUV9g@public.gmane.org>
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
> Secure erase is a very different operation from discard in that it is
> a data integrity operation vs hint.  Fully split the limits and helper
> infrastructure to make the separation more clear.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

For the bcache part,

Acked-by: Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>


Thanks.

Coly Li


> ---
>   block/blk-core.c                    |  2 +-
>   block/blk-lib.c                     | 64 ++++++++++++++++++++---------
>   block/blk-mq-debugfs.c              |  1 -
>   block/blk-settings.c                | 16 +++++++-
>   block/fops.c                        |  2 +-
>   block/ioctl.c                       | 43 +++++++++++++++----
>   drivers/block/drbd/drbd_receiver.c  |  5 ++-
>   drivers/block/rnbd/rnbd-clt.c       |  4 +-
>   drivers/block/rnbd/rnbd-srv-dev.h   |  2 +-
>   drivers/block/xen-blkback/blkback.c | 15 +++----
>   drivers/block/xen-blkback/xenbus.c  |  5 +--
>   drivers/block/xen-blkfront.c        |  5 ++-
>   drivers/md/bcache/alloc.c           |  2 +-
>   drivers/md/dm-table.c               |  8 ++--
>   drivers/md/dm-thin.c                |  4 +-
>   drivers/md/md.c                     |  2 +-
>   drivers/md/raid5-cache.c            |  6 +--
>   drivers/mmc/core/queue.c            |  2 +-
>   drivers/nvme/target/io-cmd-bdev.c   |  2 +-
>   drivers/target/target_core_file.c   |  2 +-
>   drivers/target/target_core_iblock.c |  2 +-
>   fs/btrfs/extent-tree.c              |  4 +-
>   fs/ext4/mballoc.c                   |  2 +-
>   fs/f2fs/file.c                      | 16 ++++----
>   fs/f2fs/segment.c                   |  2 +-
>   fs/jbd2/journal.c                   |  2 +-
>   fs/nilfs2/sufile.c                  |  4 +-
>   fs/nilfs2/the_nilfs.c               |  4 +-
>   fs/ntfs3/super.c                    |  2 +-
>   fs/xfs/xfs_discard.c                |  2 +-
>   fs/xfs/xfs_log_cil.c                |  2 +-
>   include/linux/blkdev.h              | 27 +++++++-----
>   mm/swapfile.c                       |  6 +--
>   33 files changed, 168 insertions(+), 99 deletions(-)
[snipped]
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 097577ae3c471..ce13c272c3872 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -336,7 +336,7 @@ static int bch_allocator_thread(void *arg)
>   				mutex_unlock(&ca->set->bucket_lock);
>   				blkdev_issue_discard(ca->bdev,
>   					bucket_to_sector(ca->set, bucket),
> -					ca->sb.bucket_size, GFP_KERNEL, 0);
> +					ca->sb.bucket_size, GFP_KERNEL);
>   				mutex_lock(&ca->set->bucket_lock);
>   			}
>   


[snipped]
