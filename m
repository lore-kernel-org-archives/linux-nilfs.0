From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: delete unnecessary condition in
 nilfs_dat_translate
Date: Sat, 06 Feb 2010 14:20:04 +0900 (JST)
Message-ID: <20100206.142004.27783676.ryusuke@osrg.net>
References: <87pr4jsr9d.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87pr4jsr9d.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 05 Feb 2010 23:15:26 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> This is a trivial patch to delete unnecessary condition in nilfs_dat_translate.
> 
> nilfs_dat_translate() will asign translated address to *blocknrp if blocknrp
> is not NULL.  However the condition is unneeded, because all callers of
> nilfs_dat_translate() pass blocknrp properly.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Applied.

Ryusuke Konishi

> ---
>  fs/nilfs2/dat.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
> index 187dd07..9d1e5de 100644
> --- a/fs/nilfs2/dat.c
> +++ b/fs/nilfs2/dat.c
> @@ -388,8 +388,7 @@ int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
>  		ret = -ENOENT;
>  		goto out;
>  	}
> -	if (blocknrp != NULL)
> -		*blocknrp = blocknr;
> +	*blocknrp = blocknr;
>  
>   out:
>  	kunmap_atomic(kaddr, KM_USER0);
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
