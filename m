From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 30/31] block: store the holder in file->private_data
Date: Wed, 7 Jun 2023 15:14:35 +0200
Message-ID: <04517ec2-bf6c-0783-9494-fb12a89d07a0@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-31-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686143675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3qm10BFMOoxWlTfzY02rDFkH1MgJHM90hSPqL0EKSU=;
        b=h0v2DqBB9ySJiLnmn6KXn42VRK0Z/nPXxfHyl6P9vx/g51yoRFC9AAW5wAXqURmVlJIrCN
        2D+/sGF0Dbl/023m3VKR+jyJmZpI81N2dxOsOVo1Iyv6eQHVy55am5AqqgqG5JbeU+LsvI
        y9I3aAtB7v6O/td5ghW63FzKVmGA63w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686143675;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3qm10BFMOoxWlTfzY02rDFkH1MgJHM90hSPqL0EKSU=;
        b=nE+HbFK6uzo+zBGVf8a/fbVecve2gD4PPeEmbpshgySHxZDiiPHczbZcJawWlwnNHAICqS
        Q/nUJxr0GbT6aJBg==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-31-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

On 6/6/23 09:39, Christoph Hellwig wrote:
> Store the file struct used as the holder in file->private_data as an
> indicator that this file descriptor was opened exclusively to  remove
> the last use of FMODE_EXCL.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>   block/fops.c | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index c40b9f978e3bc7..915e0ef7560993 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -478,7 +478,7 @@ blk_mode_t file_to_blk_mode(struct file *file)
>   		mode |= BLK_OPEN_READ;
>   	if (file->f_mode & FMODE_WRITE)
>   		mode |= BLK_OPEN_WRITE;
> -	if (file->f_mode & FMODE_EXCL)
> +	if (file->private_data)
>   		mode |= BLK_OPEN_EXCL;
>   	if ((file->f_flags & O_ACCMODE) == 3)
>   		mode |= BLK_OPEN_WRITE_IOCTL;
> @@ -501,12 +501,15 @@ static int blkdev_open(struct inode *inode, struct file *filp)
>   	filp->f_flags |= O_LARGEFILE;
>   	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
>   
> +	/*
> +	 * Use the file private data to store the holder, file_to_blk_mode
> +	 * relies on this.
> +	 */

Can you update the comment to reflect that we're only use the
->private_data field for exclusive open?
I know it's indicated by the condition, but we really should
be clarify this usage.

>   	if (filp->f_flags & O_EXCL)
> -		filp->f_mode |= FMODE_EXCL;
> +		filp->private_data = filp;
>   
>   	bdev = blkdev_get_by_dev(inode->i_rdev, file_to_blk_mode(filp),
> -				 (filp->f_mode & FMODE_EXCL) ? filp : NULL,
> -				 NULL);
> +				 filp->private_data, NULL);
>   	if (IS_ERR(bdev))
>   		return PTR_ERR(bdev);
>   
> @@ -517,8 +520,7 @@ static int blkdev_open(struct inode *inode, struct file *filp)
>   
>   static int blkdev_release(struct inode *inode, struct file *filp)
>   {
> -	blkdev_put(I_BDEV(filp->f_mapping->host),
> -		   (filp->f_mode & FMODE_EXCL) ? filp : NULL);
> +	blkdev_put(I_BDEV(filp->f_mapping->host), filp->private_data);
>   	return 0;
>   }
>   
Other than that:

Reviewed-by: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>

Cheers,

Hannes

