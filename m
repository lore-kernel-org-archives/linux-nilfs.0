From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2-utils: fix bug when opening non-nilfs2 device
Date: Sat, 11 Sep 2010 14:57:06 +0900 (JST)
Message-ID: <20100911.145706.55860795.ryusuke@osrg.net>
References: <87vd6ec596.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87vd6ec596.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Fri, 10 Sep 2010 18:33:25 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> This patch fixes a wrong return value of nilfs_sb_read when opening
> non-nilfs2 device.  nilfs_sb_read should return NULL in case it was
> not a nilfs2 device instead of "-1" to indicate error.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Applied, thank you.

Ryusuke Konishi

> ---
>  lib/sb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/sb.c b/lib/sb.c
> index 201b9ad..b60575d 100644
> --- a/lib/sb.c
> +++ b/lib/sb.c
> @@ -161,7 +161,7 @@ struct nilfs_super_block *nilfs_sb_read(int devfd)
>  	struct nilfs_super_block *sbp[2];
>  
>  	if (__nilfs_sb_read(devfd, sbp, NULL))
> -		return -1;
> +		return NULL;
>  
>  	if (!sbp[0]) {
>  		sbp[0] = sbp[1];
> -- 
> 1.7.0.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
