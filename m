From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: unbreak compat ioctl
Date: Thu, 10 Nov 2011 12:49:18 +0900 (JST)
Message-ID: <20111110.124918.255392182.ryusuke@osrg.net>
References: <1320697117.1396.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320697117.1396.4.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: thomas-VsYtu1Qij5c@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 07 Nov 2011 21:18:37 +0100, Thomas Meyer wrote:
> I guess commit 828b1c50ae11e6dda68f8dfefe43b74c7182b157 incidentally broke
> all other compat ioctls. make them work again.
> 
> Signed-off-by: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 41d6743..1773a98 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -842,8 +842,6 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	case FS_IOC32_GETVERSION:
>  		cmd = FS_IOC_GETVERSION;
>  		break;
> -	default:
> -		return -ENOIOCTLCMD;
>  	}
>  	return nilfs_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
>  }
> -- 
> 1.7.7

Hi, thank you for pointing this out.

But, this patch looks to prevent compat_sys_ioctl() from handling
other compatible ioctls that compat_ioctl_check_table function
detects.  For instance, fiemap (FS_IOC_FIEMAP) is handled via the
function.

I think we should only redirect own ioctl commands
(i.e. NILFS_IOCTL_xxxx) to the nilfs_ioctl() call.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
