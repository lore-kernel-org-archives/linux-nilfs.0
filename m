From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH 06/31] cdrom: remove the unused mode argument to
 cdrom_release
Date: Mon, 26 Jun 2023 22:41:07 -0700
Message-ID: <fb21bb8b-958a-4238-aab8-c2720ac519ad@roeck-us.net>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-7-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687844470; x=1690436470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eUHv1b8aqLsb4R7LditAal7kNTag6lxKqXAOQ2qujCU=;
        b=fG/WGax37UoauKBSyv6kej64LdcGJrv6k66h8NGOsMv9uaUsNclSu7DiDyHvg7N0+H
         TpLbLvnFmTkLJuRzyFn0V5R9/xG3MBNfmS6gpoZxFQmbIvFJa8XU1iIC6Fyl95ACCFHi
         Ys+3TEnr35uP041kETcaQnaFL3Zzmuv0Ara4RUBuuI4A1DlyY37o026XtSt1PCG00d7o
         R82xvUrMlfJH4JujFDKNZYqLCuYZs3onB7GlXFtQZdgcqNFnR06TCpWzVOviTJnvGG64
         v3WIIO+Pf3siD1OxDgXeCgfd8ad+rtq0TuDOYOoPNLLpd/YOKy903+fL59/xrY4ynCa9
         WP/g==
Sender: Guenter Roeck <groeck7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

$ git grep cdrom_release
Documentation/cdrom/cdrom-standard.rst:         cdrom_release,          /* release */
Documentation/cdrom/cdrom-standard.rst:the door, should be left over to the general routine *cdrom_release()*.
Documentation/cdrom/cdrom-standard.rst: void cdrom_release(struct inode *ip, struct file *fp)
                                                                           ^^^^^^^^^^^^^^^^^
drivers/cdrom/cdrom.c:void cdrom_release(struct cdrom_device_info *cdi)
drivers/cdrom/cdrom.c:  cd_dbg(CD_CLOSE, "entering cdrom_release\n");
drivers/cdrom/cdrom.c:EXPORT_SYMBOL(cdrom_release);
drivers/cdrom/gdrom.c:  cdrom_release(gd.cd_info, mode);
                                                ^^^^^^
drivers/scsi/sr.c:      cdrom_release(&cd->cdi);
include/linux/cdrom.h:void cdrom_release(struct cdrom_device_info *cdi);

$ git grep cdrom_open
Documentation/cdrom/cdrom-standard.rst:         cdrom_open,             /* open */
Documentation/cdrom/cdrom-standard.rst: int cdrom_open(struct inode * ip, struct file * fp)
Documentation/cdrom/cdrom-standard.rst:This function implements the reverse-logic of *cdrom_open()*, and then
drivers/cdrom/cdrom.c:static int cdrom_open_write(struct cdrom_device_info *cdi)
drivers/cdrom/cdrom.c:int cdrom_open(struct cdrom_device_info *cdi, blk_mode_t mode)
drivers/cdrom/cdrom.c:  cd_dbg(CD_OPEN, "entering cdrom_open\n");
drivers/cdrom/cdrom.c:                  if (cdrom_open_write(cdi))
drivers/cdrom/cdrom.c:EXPORT_SYMBOL(cdrom_open);
drivers/cdrom/gdrom.c:  ret = cdrom_open(gd.cd_info);
                                         ^^^^^^^^^^
drivers/scsi/sr.c:      ret = cdrom_open(&cd->cdi, mode);
include/linux/cdrom.h:int cdrom_open(struct cdrom_device_info *cdi, blk_mode_t mode);

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
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
