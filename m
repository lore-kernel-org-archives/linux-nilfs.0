From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v5 3/3] nilfs2: implementation of
 NILFS_IOCTL_SET_SUINFO ioctl
Date: Fri, 31 Jan 2014 20:10:30 +0900 (JST)
Message-ID: <20140131.201030.402961421.konishi.ryusuke@lab.ntt.co.jp>
References: <ca8880c95dab78576ad1dddd26068397766e1cca.1391165125.git.andreas.rohner@gmx.net>
	<ca8880c95dab78576ad1dddd26068397766e1cca.1391165125.git.andreas.rohner@gmx.net>
	<f5e65b4ff6e1f73c90bd1f3f6cc7129d7c707050.1391165125.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f5e65b4ff6e1f73c90bd1f3f6cc7129d7c707050.1391165125.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 31 Jan 2014 11:46:07 +0100, Andreas Rohner wrote:
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

Applied.

Thanks a lot for your effort.

Ryusuke Konishi

> ---
>  fs/nilfs2/ioctl.c         | 92 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/nilfs2_fs.h |  2 ++
>  2 files changed, 94 insertions(+)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 2b34021..c19a231 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -1163,6 +1163,95 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_set_suinfo - set segment usage info
> + * @inode: inode object
> + * @filp: file object
> + * @cmd: ioctl's request code
> + * @argp: pointer on argument from userspace
> + *
> + * Description: Expects an array of nilfs_suinfo_update structures
> + * encapsulated in nilfs_argv and updates the segment usage info
> + * according to the flags in nilfs_suinfo_update.
> + *
> + * Return Value: On success, 0 is returned. On error, one of the
> + * following negative error codes is returned.
> + *
> + * %-EPERM - Not enough permissions
> + *
> + * %-EFAULT - Error copying input data
> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-EINVAL - Invalid values in input (segment number, flags or nblocks)
> + */
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
> +	if (argv.v_nmembs >= UINT_MAX / argv.v_size)
> +		goto out;
> +
> +	len = argv.v_size * argv.v_nmembs;
> +	if (!len) {
> +		ret = 0;
> +		goto out;
> +	}
> +
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
>  long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	struct inode *inode = file_inode(filp);
> @@ -1189,6 +1278,8 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		return nilfs_ioctl_get_info(inode, filp, cmd, argp,
>  					    sizeof(struct nilfs_suinfo),
>  					    nilfs_ioctl_do_get_suinfo);
> +	case NILFS_IOCTL_SET_SUINFO:
> +		return nilfs_ioctl_set_suinfo(inode, filp, cmd, argp);
>  	case NILFS_IOCTL_GET_SUSTAT:
>  		return nilfs_ioctl_get_sustat(inode, filp, cmd, argp);
>  	case NILFS_IOCTL_GET_VINFO:
> @@ -1228,6 +1319,7 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	case NILFS_IOCTL_GET_CPINFO:
>  	case NILFS_IOCTL_GET_CPSTAT:
>  	case NILFS_IOCTL_GET_SUINFO:
> +	case NILFS_IOCTL_SET_SUINFO:
>  	case NILFS_IOCTL_GET_SUSTAT:
>  	case NILFS_IOCTL_GET_VINFO:
>  	case NILFS_IOCTL_GET_BDESCS:
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 2526578..1fb465f 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -905,5 +905,7 @@ struct nilfs_bdesc {
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
