From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: unbreak compat ioctl
Date: Mon, 14 Nov 2011 18:30:47 +0900 (JST)
Message-ID: <20111114.183047.139564117.ryusuke@osrg.net>
References: <1320697117.1396.4.camel@localhost.localdomain>
	<20111110.124918.255392182.ryusuke@osrg.net>
	<1321180334.1624.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321180334.1624.23.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: thomas-VsYtu1Qij5c@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 13 Nov 2011 11:32:14 +0100, Thomas Meyer wrote:
> Am Donnerstag, den 10.11.2011, 12:49 +0900 schrieb Ryusuke Konishi:
> > But, this patch looks to prevent compat_sys_ioctl() from handling
> > other compatible ioctls that compat_ioctl_check_table function
> > detects.  For instance, fiemap (FS_IOC_FIEMAP) is handled via the
> > function.
> > 
> > I think we should only redirect own ioctl commands
> > (i.e. NILFS_IOCTL_xxxx) to the nilfs_ioctl() call.
> 
> Hello Ryusuke,
> 
> something like this?

Thanks, it looks fine to me.

I'll send it upstream after testing it against a 64-bit kernel
environment with a 32-bit userspace.

Regards,
Ryusuke Konishi


> kind regards
> thomas
> 
> From 241cc9e8c7d6b8218d307117b0d4a0dabbe1d94e Mon Sep 17 00:00:00 2001
> From: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
> Date: Mon, 7 Nov 2011 20:59:02 +0100
> Subject: [PATCH] nilfs2: unbreak compat ioctl
> 
> I guess commit 828b1c50ae11e6dda68f8dfefe43b74c7182b157 incidentally broke
> all other NILFS compat ioctls. make them work again.
> 
> Signed-off-by: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 41d6743..3e65427 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -842,6 +842,19 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	case FS_IOC32_GETVERSION:
>  		cmd = FS_IOC_GETVERSION;
>  		break;
> +	case NILFS_IOCTL_CHANGE_CPMODE:
> +	case NILFS_IOCTL_DELETE_CHECKPOINT:
> +	case NILFS_IOCTL_GET_CPINFO:
> +	case NILFS_IOCTL_GET_CPSTAT:
> +	case NILFS_IOCTL_GET_SUINFO:
> +	case NILFS_IOCTL_GET_SUSTAT:
> +	case NILFS_IOCTL_GET_VINFO:
> +	case NILFS_IOCTL_GET_BDESCS:
> +	case NILFS_IOCTL_CLEAN_SEGMENTS:
> +	case NILFS_IOCTL_SYNC:
> +	case NILFS_IOCTL_RESIZE:
> +	case NILFS_IOCTL_SET_ALLOC_RANGE:
> +		break;
>  	default:
>  		return -ENOIOCTLCMD;
>  	}
> -- 
> 1.7.7.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
