From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] mount.nilfs2: add "uhelper=" option
Date: Fri, 23 Jul 2010 23:33:10 +0900 (JST)
Message-ID: <20100723.233310.85394061.ryusuke@osrg.net>
References: <87d3ueej51.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87d3ueej51.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Fri, 23 Jul 2010 16:45:30 +0900, Jiro SEKIBA wrote:
> 
> Standard mount command takes uhelper=<helper_name> option to tell the mount
> is under <helper_name> control.  When this option is specified,
> umount.<helper_name> is called on unmount time.
> 
> This option is used when mount is triggered by udisks. udisks is a dbus
> service daemon.  The service is used by Palimpsest.  To controll nilfs2
> partition from palimpsest, interpret the option is required.
>
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> ---

Very interesting.  If nilfs becomes available on Palimsest, it will
make levels of entry lower.

I took this one and applied to nilfs-utils.git.
If you need any additional help for this, please let me know.

BTW, I didn't know the role of the struct string_opt_map until now.
It looks helpful also for other virtual options.

Thanks,
Ryusuke Konishi

>  sbin/mount/mount_opts.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/sbin/mount/mount_opts.c b/sbin/mount/mount_opts.c
> index 9db599f..396b41f 100644
> --- a/sbin/mount/mount_opts.c
> +++ b/sbin/mount/mount_opts.c
> @@ -98,7 +98,7 @@ static const struct opt_map opt_map[] = {
>  };
>  
>  static const char *opt_loopdev, *opt_vfstype, *opt_offset, *opt_encryption,
> -	*opt_speed, *opt_comment;
> +	*opt_speed, *opt_comment, *opt_uhelper;
>  
>  static struct string_opt_map {
>  	char *tag;
> @@ -111,6 +111,7 @@ static struct string_opt_map {
>  	{ "encryption=", 0, &opt_encryption },
>  	{ "speed=", 0, &opt_speed },
>  	{ "comment=", 1, &opt_comment },
> +	{ "uhelper=", 0, &opt_uhelper },
>  	{ NULL, 0, NULL }
>  };
>  
> -- 
> 1.5.6.5
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
