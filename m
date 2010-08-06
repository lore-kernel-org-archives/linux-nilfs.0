From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2-utils: fix volume label size in mkfs
Date: Fri, 06 Aug 2010 19:50:13 +0900 (JST)
Message-ID: <20100806.195013.257051635.ryusuke@osrg.net>
References: <87y6ckb0f2.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87y6ckb0f2.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Fri, 06 Aug 2010 17:38:57 +0900, Jiro SEKIBA wrote:
> 
> mkfs has own option struct, in which volume label is defined.
> This patch enlarges volume label of mkfs to 80 from 16.
> 
> volume label has been extend to 80 from 16 by commit
> 337eeb61e5edbb77dee10650c8aac9d88249716a in linux-2.6.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Ahh, I got it.  Will apply later.

Thank you.

Ryusuke Konishi

> ---
>  sbin/mkfs/mkfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
> index e135059..2d04c59 100644
> --- a/sbin/mkfs/mkfs.c
> +++ b/sbin/mkfs/mkfs.c
> @@ -112,7 +112,7 @@ struct mkfs_options {
>  	long r_segments_percentage;
>  	int quiet, cflag, nflag;
>  	time_t ctime;
> -	char volume_label[16];
> +	char volume_label[80];
>  };
>  
>  extern char *optarg;
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
