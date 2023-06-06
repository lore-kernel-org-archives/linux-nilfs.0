From: Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>
Subject: Re: [PATCH 06/31] cdrom: remove the unused mode argument to
 cdrom_release
Date: Wed, 7 Jun 2023 00:00:57 +0100
Message-ID: <ZH+6qd1W75G49P7p@equinox>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-7-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20221208.gappssmtp.com; s=20221208; t=1686092460; x=1688684460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4AyxSeVCWLu668XQQXcZmNRbTvqm+XfWnbYRI3bfM+o=;
        b=ap+1NYchKGrYc446kRWRnQbhMV1pl6YsP5OToBbRr7yqxWuwivol/KLqvKwbFREzDt
         leVawKb5LA6xL6S30/x70zQDywvhkHn7+JCGlKA0lozFIJqWnjRJTp5YJHpex7lWnnUv
         dJkg9spKjZLznLO62AffDpdqoqWcUVXi8VRvJ792SrSPG5RfZag3TIQLuMV3b7gUNrfh
         oTcGuFKfS4159jodmD3xpY5/Ko+Rh5RiDBfrQUvcEy89mqnn+LVVNO5Iw2N5Qiu+JIlB
         FJKkwHEgGck4KgrxHNc30tLse+VJntfkb30BZScrTrWOpflbR4XFpuj885jYKqOuXNkW
         SBWg==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-7-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvm

On Tue, Jun 06, 2023 at 09:39:25AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/cdrom/cdrom.c | 2 +-
>  drivers/cdrom/gdrom.c | 2 +-
>  drivers/scsi/sr.c     | 2 +-
>  include/linux/cdrom.h | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index adebac1bd210d9..998b03fe976e22 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -1250,7 +1250,7 @@ static int check_for_audio_disc(struct cdrom_device_info *cdi,
>  	return 0;
>  }
>  
> -void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
> +void cdrom_release(struct cdrom_device_info *cdi)
>  {
>  	const struct cdrom_device_ops *cdo = cdi->ops;
>  
> diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
> index 14922403983e9e..a401dc4218a998 100644
> --- a/drivers/cdrom/gdrom.c
> +++ b/drivers/cdrom/gdrom.c
> @@ -481,7 +481,7 @@ static int gdrom_bdops_open(struct block_device *bdev, fmode_t mode)
>  	bdev_check_media_change(bdev);
>  
>  	mutex_lock(&gdrom_mutex);
> -	ret = cdrom_open(gd.cd_info, mode);
> +	ret = cdrom_open(gd.cd_info);
>  	mutex_unlock(&gdrom_mutex);
>  	return ret;
>  }
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 444c7efc14cba7..6d33120ee5ba85 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -512,7 +512,7 @@ static void sr_block_release(struct gendisk *disk, fmode_t mode)
>  	struct scsi_cd *cd = scsi_cd(disk);
>  
>  	mutex_lock(&cd->lock);
> -	cdrom_release(&cd->cdi, mode);
> +	cdrom_release(&cd->cdi);
>  	mutex_unlock(&cd->lock);
>  
>  	scsi_device_put(cd->device);
> diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
> index 385e94732b2cf1..3f23d5239de254 100644
> --- a/include/linux/cdrom.h
> +++ b/include/linux/cdrom.h
> @@ -102,7 +102,7 @@ int cdrom_read_tocentry(struct cdrom_device_info *cdi,
>  
>  /* the general block_device operations structure: */
>  int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode);
> -extern void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode);
> +void cdrom_release(struct cdrom_device_info *cdi);
>  int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
>  		unsigned int cmd, unsigned long arg);
>  extern unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
> -- 
> 2.39.2
> 

Looks good, thanks.

Signed-off-by: Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>

Regards,
Phil
