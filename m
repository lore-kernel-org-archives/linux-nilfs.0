From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 05/31] cdrom: track if a cdrom_device_info was opened for
 data
Date: Wed, 7 Jun 2023 14:13:33 +0200
Message-ID: <a7524776-f4c3-147a-cfa5-da92d2f877bb@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-6-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686140013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=StU8bsjNjflHj0YFd3pOgj01pYtuKwFRrsba2nNmHxc=;
        b=dMMg+c9NJGeIwDBEGbx2Qu0RmdyzjEbDquVhtxZPyu0hsWDj62tdshi8Pk+C/wPadb/RFE
        FnFkUmm9S3NcyQ4hIfWvWWKM5Qe4kSe5QdN4EGvw7IISWJ49A0dyy9AvJh3Hu0hoLwhkxh
        nEwP4x5dY8zjOJEiuhgizoLxmTJK3bM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686140013;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=StU8bsjNjflHj0YFd3pOgj01pYtuKwFRrsba2nNmHxc=;
        b=UHMYFZOyP/acMA8ezhNsMXSgaL/blHnAMYHL7lhda0+2cRiUsjJd9ypcsD0e8JWz2sThGU
        CZGpXJmSh+0RoTCA==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-6-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

On 6/6/23 09:39, Christoph Hellwig wrote:
> Set a flag when a cdrom_device_info is opened for writing, instead of
> trying to figure out this at release time.  This will allow to eventually
> remove the mode argument to the ->release block_device_operation as
> nothing but the CDROM drivers uses that argument.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>   drivers/cdrom/cdrom.c | 12 +++++-------
>   include/linux/cdrom.h |  1 +
>   2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 08abf1ffede002..adebac1bd210d9 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -1172,6 +1172,7 @@ int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode)
>   			ret = 0;
>   			cdi->media_written = 0;
>   		}
> +		cdi->opened_for_data = true;
>   	}
>   
>   	if (ret)
> @@ -1252,7 +1253,6 @@ static int check_for_audio_disc(struct cdrom_device_info *cdi,
>   void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
>   {
>   	const struct cdrom_device_ops *cdo = cdi->ops;
> -	int opened_for_data;
>   
>   	cd_dbg(CD_CLOSE, "entering cdrom_release\n");
>   
> @@ -1270,14 +1270,12 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
>   		}
>   	}
>   
> -	opened_for_data = !(cdi->options & CDO_USE_FFLAGS) ||
> -		!(mode & FMODE_NDELAY);
> -
>   	cdo->release(cdi);
> -	if (cdi->use_count == 0) {      /* last process that closes dev*/
> -		if (opened_for_data &&
> -		    cdi->options & CDO_AUTO_EJECT && CDROM_CAN(CDC_OPEN_TRAY))
> +
> +	if (cdi->use_count == 0 && cdi->opened_for_data) {
> +		if (cdi->options & CDO_AUTO_EJECT && CDROM_CAN(CDC_OPEN_TRAY))
>   			cdo->tray_move(cdi, 1);
> +		cdi->opened_for_data = false;
>   	}
>   }
>   EXPORT_SYMBOL(cdrom_release);
> diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
> index 0a5db0b0c958a1..385e94732b2cf1 100644
> --- a/include/linux/cdrom.h
> +++ b/include/linux/cdrom.h
> @@ -64,6 +64,7 @@ struct cdrom_device_info {
>   	int (*exit)(struct cdrom_device_info *);
>   	int mrw_mode_page;
>   	__s64 last_media_change_ms;
> +	bool opened_for_data;
>   };
>   
>   struct cdrom_device_ops {

Do we care about alignment here?
integer followed by a 64 bit value followed by a bool seems
like an automatic padding to me ...

Cheers,

Hannes

