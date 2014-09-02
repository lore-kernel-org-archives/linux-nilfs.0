From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] libmount: don't base GC startup on no-mtab context
Date: Wed, 03 Sep 2014 02:16:47 +0900 (JST)
Message-ID: <20140903.021647.725436840180006450.konishi.ryusuke@lab.ntt.co.jp>
References: <1409600714-25174-1-git-send-email-dan@archlinux.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=Wmc1+wMl6Kx0D3eZYH7Qbs53jgIURdhwTzuaVHA0CQw=;
        b=bLjctU5hfhC7PQ3KHOfWbg9LNQU/SSF28L8h0ftsRzwrthAEUdzhEFMXDfXYK0+b+i
         Z+rdyuRJ8G/nq1A6ZPKEjmO16BIIbpxdtx1IlPdkgHS4xgM29oX835Ic9GBqkOdy6zvv
         pQhh719/IC/9LHo26MOmWdLl52vSNXDViMF9c7uC/8vucsg7W9vSJovQqSvC628uyVvT
         +kWjCD6DL7em7uN25B95xr7EXi59NuWniCKO3W9B8U3bEvoV39Ppul2eM6A6GzdEJZ8w
         Jq8cI8eegOZQ87ilJgzifQvnbwMD9k9DhpuDm41ILUEPOO+N8duhOXdT0l1/jA3MvZOo
         +iiQ==
In-Reply-To: <1409600714-25174-1-git-send-email-dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon,  1 Sep 2014 14:45:14 -0500, Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org> wrote:
> When mtab is a symlink to /proc/mounts, libmount uses /run/mount/utab to
> store filesystem-specific mount attributes, making this check
> unnecessary. Worse, it now breaks nilfs_cleanerd under systemd 216+
> since it always passes `-n` to the mount command.
> 
> Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>

Applied, thank you!

Ryusuke Konishi

> ---
>  sbin/mount/mount_libmount.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/sbin/mount/mount_libmount.c b/sbin/mount/mount_libmount.c
> index c518475..b901654 100644
> --- a/sbin/mount/mount_libmount.c
> +++ b/sbin/mount/mount_libmount.c
> @@ -404,12 +404,6 @@ static int nilfs_update_mount_state(struct nilfs_mount_info *mi)
>  	rungc = gc_ok && !mi->new_attrs.nogc;
>  	old_attrs = (mi->mflags & MS_REMOUNT) ? &mi->old_attrs : NULL;
>  
> -	if (mnt_context_is_nomtab(cxt)) {
> -		if (rungc)
> -			printf(_("%s not started\n"), NILFS_CLEANERD_NAME);
> -		return 0;
> -	}
> -
>  	if (rungc) {
>  		if (mi->new_attrs.pp == ULONG_MAX)
>  			mi->new_attrs.pp = mi->old_attrs.pp;
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
