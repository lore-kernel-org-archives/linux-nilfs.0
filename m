From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCHv2] nilfs2-utils: change the error message of nilfs-tune
 properlyx
Date: Wed, 15 Sep 2010 19:39:10 +0900 (JST)
Message-ID: <20100915.193910.220041690.ryusuke@osrg.net>
References: <8739tbfq2b.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8739tbfq2b.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Wed, 15 Sep 2010 16:01:32 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> Change the error message of nilfs-tune when user doesn't have
> a permission to access the device to show the cause of error clearly.
> 
> differences from v1
> - moved the error string behind the primary message.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Applied.

Thanks,
Ryusuke Konishi

> ---
>  sbin/nilfs-tune/nilfs-tune.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.c
> index d99ce46..e80caa4 100644
> --- a/sbin/nilfs-tune/nilfs-tune.c
> +++ b/sbin/nilfs-tune/nilfs-tune.c
> @@ -399,10 +399,12 @@ int modify_nilfs(char *device, struct nilfs_tune_options *opts)
>  	struct nilfs_super_block *sbp;
>  	__u64 features;
>  
> +	errno = 0;
>  	devfd = open(device, opts->flags);
>  
>  	if (devfd == -1) {
> -		fprintf(stderr, "%s: cannot open NILFS\n", device);
> +		fprintf(stderr, "cannot open device %s: %s\n",
> +			device, strerror(errno));
>  		ret = EXIT_FAILURE;
>  		goto out;
>  	}
> -- 
> 1.5.6.5
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
