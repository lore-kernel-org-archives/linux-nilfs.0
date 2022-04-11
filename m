From: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 24/27] block: remove QUEUE_FLAG_DISCARD
Date: Mon, 11 Apr 2022 08:01:41 -0600
Message-ID: <YlQ0xbtIcf8gti43@kbusch-mbp.dhcp.thefacebook.com>
References: <20220409045043.23593-1-hch@lst.de>
 <20220409045043.23593-25-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649685706;
        bh=aoF5JI4oA+WPgt/y0IgsxtsbxAXaCuGafPntNOloKP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z3DJooO+lpgxb0V7M65iVrqmxI0PEssCJPh+vJ1dEw1YBTDUO4k0Ftowa06gEpR83
         S1WtT+TAlqYOA3SV5oPOUKBv5r5Czq1jXlmgnBC2vlAsKUSP12Z7m3WPk2IIXa7ddE
         7+rat37phwTAQkXhdDcOfyIkaP50hX9uWu9MCv3Yv354dhMqhNyhEKK5VIXvkcNSo/
         Yw75O5ZXcRgYxwAIHqrZej/c3adf+HQOwXoAdC34I68eRF5zbda1Ysdnlbmc/q5KXa
         +yAvml8INLRMKi4FRTZn17313igwH9BKq1x7zfZpQGp7kDf9WzbZnpQOZP3oofxBEN
         wCj97MUpv05qA==
Content-Disposition: inline
In-Reply-To: <20220409045043.23593-25-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, nbd@other.debian.org, ceph-devel@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, ocfs2-devel@oss.o

On Sat, Apr 09, 2022 at 06:50:40AM +0200, Christoph Hellwig wrote:
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index efb85c6d8e2d5..7e07dd69262a7 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -1607,10 +1607,8 @@ static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)
>  	struct request_queue *queue = disk->queue;
>  	u32 size = queue_logical_block_size(queue);
>  
> -	if (ctrl->max_discard_sectors == 0) {
> -		blk_queue_flag_clear(QUEUE_FLAG_DISCARD, queue);
> +	if (ctrl->max_discard_sectors == 0)
>  		return;
> -	}

I think we need to update the queue limit in this condition. While unlikley,
the flag was cleared here in case the device changed support for discard from
the previous reset. 
