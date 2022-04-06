From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 23/27] block: add a bdev_max_discard_sectors
	helper
Date: Thu, 7 Apr 2022 02:28:15 +0900
Message-ID: <CAKFNMokGOma3pvHdEsnsjuKgW+jpYX9zx8fWwJWyeKuCpKz-YQ@mail.gmail.com>
References: <20220406060516.409838-1-hch@lst.de>
	<20220406060516.409838-24-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=WJLYFFwKJzu0AzBejzceyC93Fh4AhvIk3A/MNZXzKIU=;
	b=nHoFYmIVcbUdYBuRBczLdRhO5AcYZ6GHHFtKpS9G1n5vNIpBGLipmKmQ40hQnwfBEK
	9YcCx5HGe8T4NG1UPywpqZKblDsiU8Uam6EvTYaei53mUEV7gX/X6QEIMPDVNdTe1RsC
	lSqUADllCjDlRJ3aqfDHj4gGsZ5WvTndElsOvm3ukXbURNWbOjm9tS3FKy9TW5JIte+s
	iqchodtdlLO+0839AsHapTHL+am4rmkQFqKuweIuQiuTq0iA/dxkHoEkiJl793SmXbAL
	d6FIVbXVTWtg6j4nPkHK8I7vb1+rBuBMN5T4ZVmgoa+qulAgS9/S0AV92hnwAdWJS/in
	gNUw==
In-Reply-To: <20220406060516.409838-24-hch-jcswGhMUV9g@public.gmane.org>
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
Cc: jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, nbd-2H2hN8V1XRtuHlm7Suoebg@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org

On Wed, Apr 6, 2022 at 11:05 PM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> Add a helper to query the number of sectors support per each discard bio
> based on the block device and use this helper to stop various places from
> poking into the request_queue to see if discard is supported and if so how
> much.  This mirrors what is done e.g. for write zeroes as well.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
...
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 16e775bcf4a7c..7d510e4231713 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -829,9 +829,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>  }
>
>  /*
> - * Check if the underlying struct block_device request_queue supports
> - * the QUEUE_FLAG_DISCARD bit for UNMAP/WRITE_SAME in SCSI + TRIM
> - * in ATA and we need to set TPE=1

> + * Check if the underlying struct block_device request_queue supports disard.
>   */

Here was a typo:

 s/disard/discard/

On Thu, Apr 7, 2022 at 12:19 AM Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> If I'm misreading things, could you please document that
> bdev_max_discard_sectors() != 0 implies that discard is supported?

I got the same impression.   Checking the discard support with
bdev_max_discard_sectors() != 0 seems a bit unclear than before.

Thanks,
Ryusuke Konishi
