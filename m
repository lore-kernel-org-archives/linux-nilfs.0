From: Phillip Potter <phil@philpotter.co.uk>
Subject: Re: [PATCH 05/31] cdrom: track if a cdrom_device_info was opened for
 data
Date: Tue, 6 Jun 2023 23:59:27 +0100
Message-ID: <ZH+6T/ibWkjSrWdt@equinox>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:In-Reply-To:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=1U5fgALsVtOfkeMReRyqJ4JdoKWMeowW5osGAPX+50w=; b=fkQ6ZIdH9sqyn5
	/iK+hoy3bnpfqAJCCSGkeiKNcY429nQtZxo9GqQ1uUmwe3ZycyHBXvTdtFT+Uos+EDOoj3bhCkxCE
	Joyp/hL7LLyeVPuvikR2TJDh389YEnFnkmIGrQIMK10ydunWswVoROH7MA6cW8K+WPea3cA9vzGw5
	eMS68pIXln1VeSoqjWtNK5z4dmp+1MaY8pqJoOMSXiik6I0IPUoVsYwAJx51eZ0+HGVYxh2nxshU2
	PLIefyFMg4NZ166aU6k3JOJgCaG4rYUgc81PW+9V/6jFZMbfZBh8Pvyei+t0AnMf4e7KckffDZolX
	rM4tH2VoNrW+q9X0PqLA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20221208.gappssmtp.com; s=20221208; t=1686092369; x=1688684369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xzrxvHE7NOsDG+KS0tlYsM4OII1tBEP7fRMkD9ta1LM=;
        b=dPBbqXFS82u/OyXTZWp6fXeJmGza5q6dVa5qz3VIcZuY3ttrTYxwiWgluNlWkTlMHS
         nr1NagSevnp3gcPfL+kiCiB3WIarpN0pgeCvHxSkBKjcjt+hu5N1Ft+/6M9I8wrHDoyn
         9ycgq/Rw7NnFSNhYqDYV0c86KZdoApl9s6kWkF+s0hGgLYcofhqvB8kmW/BZ+LKMR//A
         gwuJ0w+LXlMxibiExmvI39ydW+5R96o5Dj5hVb4IzQeS/zsCQmqqjO7QkeXRJL2RSe4t
         6PrHCQqgVj8mU9U37sOH8TIm5TIb7ksdihwA/BJR/rIS7FZXiO40utLCY94h1/n/iUKk
         stqw==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-6-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-um/>
List-Post: <mailto:linux-um@lists.infradead.org>
List-Help: <mailto:linux-um-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=subscribe>
Sender: "linux-um" <linux-um-bounces@lists.infradead.org>
Errors-To: linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.ke

On Tue, Jun 06, 2023 at 09:39:24AM +0200, Christoph Hellwig wrote:
> Set a flag when a cdrom_device_info is opened for writing, instead of
> trying to figure out this at release time.  This will allow to eventually
> remove the mode argument to the ->release block_device_operation as
> nothing but the CDROM drivers uses that argument.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/cdrom/cdrom.c | 12 +++++-------
>  include/linux/cdrom.h |  1 +
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 08abf1ffede002..adebac1bd210d9 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -1172,6 +1172,7 @@ int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode)
>  			ret = 0;
>  			cdi->media_written = 0;
>  		}
> +		cdi->opened_for_data = true;
>  	}
>  
>  	if (ret)
> @@ -1252,7 +1253,6 @@ static int check_for_audio_disc(struct cdrom_device_info *cdi,
>  void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
>  {
>  	const struct cdrom_device_ops *cdo = cdi->ops;
> -	int opened_for_data;
>  
>  	cd_dbg(CD_CLOSE, "entering cdrom_release\n");
>  
> @@ -1270,14 +1270,12 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
>  		}
>  	}
>  
> -	opened_for_data = !(cdi->options & CDO_USE_FFLAGS) ||
> -		!(mode & FMODE_NDELAY);
> -
>  	cdo->release(cdi);
> -	if (cdi->use_count == 0) {      /* last process that closes dev*/
> -		if (opened_for_data &&
> -		    cdi->options & CDO_AUTO_EJECT && CDROM_CAN(CDC_OPEN_TRAY))
> +
> +	if (cdi->use_count == 0 && cdi->opened_for_data) {
> +		if (cdi->options & CDO_AUTO_EJECT && CDROM_CAN(CDC_OPEN_TRAY))
>  			cdo->tray_move(cdi, 1);
> +		cdi->opened_for_data = false;
>  	}
>  }
>  EXPORT_SYMBOL(cdrom_release);
> diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
> index 0a5db0b0c958a1..385e94732b2cf1 100644
> --- a/include/linux/cdrom.h
> +++ b/include/linux/cdrom.h
> @@ -64,6 +64,7 @@ struct cdrom_device_info {
>  	int (*exit)(struct cdrom_device_info *);
>  	int mrw_mode_page;
>  	__s64 last_media_change_ms;
> +	bool opened_for_data;
>  };
>  
>  struct cdrom_device_ops {
> -- 
> 2.39.2
> 

Looks good, thanks.

Signed-off-by: Phillip Potter <phil@philpotter.co.uk>

Regards,
Phil
