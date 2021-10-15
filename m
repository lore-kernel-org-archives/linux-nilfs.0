From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 04/30] drbd: use bdev_nr_sectors instead of open coding it
Date: Fri, 15 Oct 2021 11:00:57 -0700
Message-ID: <211d2871-6232-8111-987f-077a95d92a1a@suse.com>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-5-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634320871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m4dfeoXG+Sb747r1kiHnXbAbgB6Mk9qwJHpOSq1ikW0=;
        b=O5tgNB9eq/FqK3OfR1pXKvMGODzwLmyj96mzgZGotlyHaNIXyz3Y9lkcjEOxoxRf/fRVCv
        xoTQeLDJmsfu6d3ilXinL0Mg+JVaEahhKqsEIGVu/Lnna+HVOx6Bj/sQAOig9p2PZuKbHE
        pTCj4hQjcW9NC2ydnuMpSy+b+3VHbzc=
In-Reply-To: <20211015132643.1621913-5-hch@lst.de>
Content-Language: en-US
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 10/15/21 6:26 AM, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>  drivers/block/drbd/drbd_int.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
> index 5d9181382ce19..75fda53eed8cf 100644
> --- a/drivers/block/drbd/drbd_int.h
> +++ b/drivers/block/drbd/drbd_int.h
> @@ -1826,8 +1826,7 @@ static inline sector_t drbd_md_last_sector(struct drbd_backing_dev *bdev)
>  /* Returns the number of 512 byte sectors of the device */
>  static inline sector_t drbd_get_capacity(struct block_device *bdev)
>  {
> -	/* return bdev ? get_capacity(bdev->bd_disk) : 0; */
> -	return bdev ? i_size_read(bdev->bd_inode) >> 9 : 0;
> +	return bdev ? bdev_nr_sectors(bdev) : 0;
>  }
>  
>  /**
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

