From: Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>
Subject: Re: [PATCH 03/31] cdrom: remove the unused mode argument to
 cdrom_ioctl
Date: Tue, 6 Jun 2023 23:54:11 +0100
Message-ID: <ZH+5E5OUUBcE1URG@equinox>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-4-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20221208.gappssmtp.com; s=20221208; t=1686092054; x=1688684054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WXBt7JZzXPFqym4cCnJPiy0FfIw5Z8TRQSIrowmnJ2I=;
        b=y/DPog6+x5wGemOO9REl8wWYWJzD4iMG9s0P4L75NF501qmTUKPPbjSmSWL8hk0aIH
         AReatV0VgQpuPEy6beyF6HQkDPhvz8Py1F5RgMVT0C0THCFzB5taD4RxBSZDph6MVAXv
         zq8qdbifmeoev+y+EMmyAhIWBhOh2u6DiEV1dl9i3upSb4XjHzWkpz+fQyiyAoqhOt72
         zBtDkRdlyEuvWSdP4/fWJTHUJreUQHAAXh+CUY+GkEkt/DXnJH0oIMni7ZM5hQbCL6t/
         vr1JxaS/c8scaopC4pHtcsjEmJADUTWY/pzY58wjFip8DTTkk41ATmdEOAV6RcEEIrIx
         yFqw==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-4-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvm

On Tue, Jun 06, 2023 at 09:39:22AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/cdrom/cdrom.c | 2 +-
>  drivers/cdrom/gdrom.c | 2 +-
>  drivers/scsi/sr.c     | 2 +-
>  include/linux/cdrom.h | 4 ++--
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index e3eab319cb0474..245e5bbb05d41c 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -3336,7 +3336,7 @@ static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
>   * ATAPI / SCSI specific code now mainly resides in mmc_ioctl().
>   */
>  int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
> -		fmode_t mode, unsigned int cmd, unsigned long arg)
> +		unsigned int cmd, unsigned long arg)
>  {
>  	void __user *argp = (void __user *)arg;
>  	int ret;
> diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
> index eaa2d5a90bc82f..14922403983e9e 100644
> --- a/drivers/cdrom/gdrom.c
> +++ b/drivers/cdrom/gdrom.c
> @@ -505,7 +505,7 @@ static int gdrom_bdops_ioctl(struct block_device *bdev, fmode_t mode,
>  	int ret;
>  
>  	mutex_lock(&gdrom_mutex);
> -	ret = cdrom_ioctl(gd.cd_info, bdev, mode, cmd, arg);
> +	ret = cdrom_ioctl(gd.cd_info, bdev, cmd, arg);
>  	mutex_unlock(&gdrom_mutex);
>  
>  	return ret;
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 61b83880e395a4..444c7efc14cba7 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -539,7 +539,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>  	scsi_autopm_get_device(sdev);
>  
>  	if (cmd != CDROMCLOSETRAY && cmd != CDROMEJECT) {
> -		ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
> +		ret = cdrom_ioctl(&cd->cdi, bdev, cmd, arg);
>  		if (ret != -ENOSYS)
>  			goto put;
>  	}
> diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
> index cc5717cb0fa8a8..4aea8c82d16971 100644
> --- a/include/linux/cdrom.h
> +++ b/include/linux/cdrom.h
> @@ -103,8 +103,8 @@ int cdrom_read_tocentry(struct cdrom_device_info *cdi,
>  /* the general block_device operations structure: */
>  int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode);
>  extern void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode);
> -extern int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
> -		       fmode_t mode, unsigned int cmd, unsigned long arg);
> +int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
> +		unsigned int cmd, unsigned long arg);
>  extern unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
>  				       unsigned int clearing);
>  
> -- 
> 2.39.2
> 

Thanks, looks good.

Signed-off-by: Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>

Regards,
Phil
