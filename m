From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 2/2] nilfs2: add FITRIM ioctl support for nilfs2
Date: Mon, 17 Feb 2014 12:01:41 +0900 (JST)
Message-ID: <20140217.120141.102660712.konishi.ryusuke@lab.ntt.co.jp>
References: <cover.1392470644.git.andreas.rohner@gmx.net>
	<cover.1392470644.git.andreas.rohner@gmx.net>
	<c1b713f94e9ebdb093c539a4c79a0426c45639a9.1392470644.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c1b713f94e9ebdb093c539a4c79a0426c45639a9.1392470644.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 15 Feb 2014 14:34:26 +0100, Andreas Rohner wrote:
> This patch adds support for the FITRIM ioctl, which enables user space
> tools to issue TRIM/DISCARD requests to the underlying device. Every
> clean segment within the specified range will be discarded.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 2b34021..cb1bea4 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -1072,6 +1072,49 @@ out:
>  }
>  
>  /**
> + * nilfs_ioctl_trim_fs() - trim ioctl handle function
> + * @inode: inode object
> + * @argp: pointer on argument from userspace
> + *
> + * Decription: nilfs_ioctl_trim_fs is the FITRIM ioctl handle function. It
> + * checks the arguments from userspace and calls nilfs_sufile_trim_fs, which
> + * performs the actual trim operation.
> + *
> + * Return Value: On success, 0 is returned or negative error code, otherwise.
> + */
> +static int nilfs_ioctl_trim_fs(struct inode *inode, void __user *argp)
> +{
> +	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
> +	struct request_queue *q = bdev_get_queue(nilfs->ns_bdev);
> +	struct fstrim_range range;
> +	int ret = 0;

This initialization is unnecessary.

Other looks OK to me.

Regards,
Ryusuke Konishi

> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (!blk_queue_discard(q))
> +		return -EOPNOTSUPP;
> +
> +	if (copy_from_user(&range, argp, sizeof(range)))
> +		return -EFAULT;
> +
> +	range.minlen = max_t(unsigned int, (unsigned int)range.minlen,
> +			q->limits.discard_granularity);
> +
> +	down_read(&nilfs->ns_segctor_sem);
> +	ret = nilfs_sufile_trim_fs(nilfs->ns_sufile, &range);
> +	up_read(&nilfs->ns_segctor_sem);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (copy_to_user(argp, &range, sizeof(range)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +/**
>   * nilfs_ioctl_set_alloc_range - limit range of segments to be allocated
>   * @inode: inode object
>   * @argp: pointer on argument from userspace
> @@ -1205,6 +1248,8 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		return nilfs_ioctl_resize(inode, filp, argp);
>  	case NILFS_IOCTL_SET_ALLOC_RANGE:
>  		return nilfs_ioctl_set_alloc_range(inode, argp);
> +	case FITRIM:
> +		return nilfs_ioctl_trim_fs(inode, argp);
>  	default:
>  		return -ENOTTY;
>  	}
> @@ -1235,6 +1280,7 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	case NILFS_IOCTL_SYNC:
>  	case NILFS_IOCTL_RESIZE:
>  	case NILFS_IOCTL_SET_ALLOC_RANGE:
> +	case FITRIM:
>  		break;
>  	default:
>  		return -ENOIOCTLCMD;
> -- 
> 1.8.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
