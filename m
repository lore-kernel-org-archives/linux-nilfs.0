From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v3 3/3] nilfs2: implementation of
 NILFS_IOCTL_SET_SUINFO ioctl
Date: Tue, 28 Jan 2014 01:26:50 +0900 (JST)
Message-ID: <20140128.012650.303740375.konishi.ryusuke@lab.ntt.co.jp>
References: <bb721a6255f199eb4a3fdfe2b34e0bdaa5f870a7.1390816620.git.andreas.rohner@gmx.net>
	<bb721a6255f199eb4a3fdfe2b34e0bdaa5f870a7.1390816620.git.andreas.rohner@gmx.net>
	<ce24b310783bf1a501408eeb0dfa268155c07444.1390816620.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ce24b310783bf1a501408eeb0dfa268155c07444.1390816620.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 27 Jan 2014 10:59:28 +0100, Andreas Rohner wrote:
> With this ioctl the segment usage entries in the SUFILE can be
> updated from userspace.
> 
> This is useful, because it allows the userspace GC to modify and update
> segment usage entries for specific segments, which enables it to avoid
> unnecessary write operations.
> 
> If a segment needs to be cleaned, but there is no or very little
> reclaimable space in it, the cleaning operation basically degrades to
> a useless moving operation. In the end the only thing that changes is
> the location of the data and a timestamp in the segment usage
> information. With this ioctl the GC can skip the cleaning and update
> the segment usage entries directly instead.
> 
> This is basically a shortcut to cleaning the segment. It is still
> necessary to read the segment summary information, but the writing of
> the live blocks can be skipped if it's not worth it.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c         | 61 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/nilfs2_fs.h |  2 ++
>  2 files changed, 63 insertions(+)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index b44bdb2..e97df9c 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -767,6 +767,64 @@ out:
>  	return ret;
>  }
>  
> +static int nilfs_ioctl_set_suinfo(struct inode *inode, struct file *filp,
> +				unsigned int cmd, void __user *argp)
> +{
> +	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
> +	struct nilfs_transaction_info ti;
> +	struct nilfs_argv argv;
> +	size_t len;
> +	void __user *base;
> +	void *kbuf;
> +	int ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	ret = mnt_want_write_file(filp);
> +	if (ret)
> +		return ret;
> +
> +	ret = -EFAULT;
> +	if (copy_from_user(&argv, argp, sizeof(argv)))
> +		goto out;
> +
> +	ret = -EINVAL;
> +	if (argv.v_size < sizeof(struct nilfs_suinfo_update))
> +		goto out;
> +
> +	if (argv.v_nmembs > nilfs->ns_nsegments)
> +		goto out;
> +
> +	len = argv.v_size * argv.v_nmembs;

The following check should be inserted to avoid overflow of variable
"len".

	if (argv.v_nmembs >= UINT_MAX / argv.v_size)
		goto out;

The size argument of vmalloc() is unsigned long, but sizeof(unsinged
long) differs depending on architecture, thus undesirable.

The following check also should be inserted because vmalloc(0) arises
a warning returning NULL.

	if (!len) {
		ret = 0;
		goto out;
	}


Regards,
Ryusuke Konishi

> +	base = (void __user *)(unsigned long)argv.v_base;

> +	kbuf = vmalloc(len);
> +	if (!kbuf) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	if (copy_from_user(kbuf, base, len)) {
> +		ret = -EFAULT;
> +		goto out_free;
> +	}
> +
> +	nilfs_transaction_begin(inode->i_sb, &ti, 0);
> +	ret = nilfs_sufile_set_suinfo(nilfs->ns_sufile, kbuf, argv.v_size,
> +			argv.v_nmembs);
> +	if (unlikely(ret < 0))
> +		nilfs_transaction_abort(inode->i_sb);
> +	else
> +		nilfs_transaction_commit(inode->i_sb); /* never fails */
> +
> +out_free:
> +	vfree(kbuf);
> +out:
> +	mnt_drop_write_file(filp);
> +	return ret;
> +}
> +
> +
>  static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
>  				unsigned int cmd, void __user *argp,
>  				size_t membsz,
> @@ -820,6 +878,8 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		return nilfs_ioctl_get_info(inode, filp, cmd, argp,
>  					    sizeof(struct nilfs_suinfo),
>  					    nilfs_ioctl_do_get_suinfo);
> +	case NILFS_IOCTL_SET_SUINFO:
> +		return nilfs_ioctl_set_suinfo(inode, filp, cmd, argp);
>  	case NILFS_IOCTL_GET_SUSTAT:
>  		return nilfs_ioctl_get_sustat(inode, filp, cmd, argp);
>  	case NILFS_IOCTL_GET_VINFO:
> @@ -859,6 +919,7 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	case NILFS_IOCTL_GET_CPINFO:
>  	case NILFS_IOCTL_GET_CPSTAT:
>  	case NILFS_IOCTL_GET_SUINFO:
> +	case NILFS_IOCTL_SET_SUINFO:
>  	case NILFS_IOCTL_GET_SUSTAT:
>  	case NILFS_IOCTL_GET_VINFO:
>  	case NILFS_IOCTL_GET_BDESCS:
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 7b94449..4140f7f 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -904,5 +904,7 @@ struct nilfs_bdesc {
>  	_IOW(NILFS_IOCTL_IDENT, 0x8B, __u64)
>  #define NILFS_IOCTL_SET_ALLOC_RANGE  \
>  	_IOW(NILFS_IOCTL_IDENT, 0x8C, __u64[2])
> +#define NILFS_IOCTL_SET_SUINFO  \
> +	_IOW(NILFS_IOCTL_IDENT, 0x8D, struct nilfs_argv)
>  
>  #endif	/* _LINUX_NILFS_FS_H */
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
