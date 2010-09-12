From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2-utils: change the error message of nilfs-tune
 properly
Date: Sun, 12 Sep 2010 23:51:37 +0900 (JST)
Message-ID: <20100912.235137.179954044.ryusuke@osrg.net>
References: <8762ybkq7j.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8762ybkq7j.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,
On Sun, 12 Sep 2010 23:10:24 +0900, Jiro SEKIBA wrote:
> hi, 
> 
> This patch modifies the error message of nilfs-tune when user doesn't have
> a permission to access the device to show the cause of error clearly.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> ---
>  sbin/nilfs-tune/nilfs-tune.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.c
> index 18513f2..f6cdd36 100644
> --- a/sbin/nilfs-tune/nilfs-tune.c
> +++ b/sbin/nilfs-tune/nilfs-tune.c
> @@ -394,10 +394,12 @@ int modify_nilfs(char *device, struct nilfs_tune_options *opts)
>  	struct nilfs_super_block *sbp;
>  	__u64 features;
>  
> +	errno = 0;
>  	devfd = open(device, opts->flags);
>  
>  	if (devfd == -1) {
> -		fprintf(stderr, "%s: cannot open NILFS\n", device);
> +		fprintf(stderr, "%s: cannot open device %s\n",
> +			strerror(errno), device);

How about putting the error string behind the primary message?

		fprintf(stderr, "cannot open device %s: %s\n", device,
			strerror(errno));

Thanks,
Ryusuke Konishi

>  		ret = EXIT_FAILURE;
>  		goto out;
>  	}
> -- 
> 1.7.0.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
