From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 3/3] nilfs2: implementation of
 NILFS_IOCTL_SET_SUINFO ioctl
Date: Fri, 24 Jan 2014 22:20:16 +0900 (JST)
Message-ID: <20140124.222016.110509397.konishi.ryusuke@lab.ntt.co.jp>
References: <cec6a449ddf5ae9da2928cdddfb96ebcb2789eee.1390312777.git.andreas.rohner@gmx.net>
	<cec6a449ddf5ae9da2928cdddfb96ebcb2789eee.1390312777.git.andreas.rohner@gmx.net>
	<6fb5a6d45afca9ae2599c471c0e42805ed1b6c55.1390312777.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6fb5a6d45afca9ae2599c471c0e42805ed1b6c55.1390312777.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 21 Jan 2014 15:00:30 +0100, Andreas Rohner wrote:
> With this ioctl the segment usage information in the SUFILE can be
> updated from userspace.
> 
> This is useful, because it allows the userspace GC to modify and update
> segment usage entries for specific segments, which enables it to avoid
> unnecessary write operations.
> 
> If a segment needs to be cleaned, but there is no or very little free
> space to be gained, the cleaning operation basically degrades to
> needless expensive copying of data. In the end the only thing that
> changes is the location of the data and a timestamp in the segment usage
> info. With this ioctl the GC can skip the copying and update the segment
> usage entries directly instead.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c         | 50 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/nilfs2_fs.h |  2 ++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index b44bdb2..c6a3faf 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -273,6 +273,13 @@ nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
>  	return ret;
>  }
>  
> +static ssize_t
> +nilfs_ioctl_do_set_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
> +			  void *buf, size_t size, size_t nmembs)
> +{
> +	return nilfs_sufile_set_suinfo(nilfs->ns_sufile, buf, size, nmembs);
> +}
> +
>  static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
>  				  unsigned int cmd, void __user *argp)
>  {
> @@ -767,6 +774,44 @@ out:
>  	return ret;
>  }
>  
> +static int nilfs_ioctl_set_info(struct inode *inode, struct file *filp,
> +				unsigned int cmd, void __user *argp,
> +				size_t membsz,
> +				ssize_t (*dofunc)(struct the_nilfs *,
> +						  __u64 *, int,
> +						  void *, size_t, size_t))
> +{
> +	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
> +	struct nilfs_transaction_info ti;
> +	struct nilfs_argv argv;
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
> +	if (argv.v_size < membsz)
> +		return -EINVAL;
> +
> +	nilfs_transaction_begin(inode->i_sb, &ti, 0);
> +	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd), dofunc);

Hmm, we have a problem here.

nilfs_ioctl_wrap_copy() cannot be used between
nilfs_transcation_begin() and nilfs_transaction_end() since
nilfs_ioctl_wrap_copy() calls copy_from_user() and/or copy_to_user().
Unfortunately there is a lock order restriction for these functions.

Let's use vmalloc() like nilfs_ioctl_clean_segments().  The following
is a sample code for this:

	size_t len;
	void __user *base;
	void *kbuf;
	int ret;

	...
	ret = -EINVAL;
	if (argv.v_size < sizeof(struct nilfs_suinfo_update))
		goto out;

	< range check of argv.v_nmembs >

	len = argv.v_size * argv.v_nmembs;
	base = (void __user *)(unsigned long)argv.v_base;
	kbuf = vmalloc(len);
	if (!kbuf) {
		ret = -ENOMEM;
		goto out;
	}

	if (copy_from_user(kbuf, base, len)) {
		ret = -EFAULT;
		goto out_free;
	}

	nilfs_transaction_begin(inode->i_sb, &ti, 0);
	ret = < call nilfs_sufile_set_suinfo > ;
	if (unlikely(ret < 0))
		nilfs_transcation_abort(inode->i_sb);
	else
		nilfs_transcation_commit(inode->i_sb);

out_free:
	vfree(kbuf);
out:
	mnt_drop_write_file(filp);
	...



Thanks,
Ryusuke Konishi

> +	if (unlikely(ret < 0))
> +		nilfs_transaction_abort(inode->i_sb);
> +	else
> +		nilfs_transaction_commit(inode->i_sb); /* never fails */
> +
> +out:
> +	mnt_drop_write_file(filp);
> +	return ret;
> +}
> +
>  static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
>  				unsigned int cmd, void __user *argp,
>  				size_t membsz,
> @@ -820,6 +865,10 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		return nilfs_ioctl_get_info(inode, filp, cmd, argp,
>  					    sizeof(struct nilfs_suinfo),
>  					    nilfs_ioctl_do_get_suinfo);
> +	case NILFS_IOCTL_SET_SUINFO:
> +		return nilfs_ioctl_set_info(inode, filp, cmd, argp,
> +					    sizeof(struct nilfs_suinfo_update),
> +					    nilfs_ioctl_do_set_suinfo);
>  	case NILFS_IOCTL_GET_SUSTAT:
>  		return nilfs_ioctl_get_sustat(inode, filp, cmd, argp);
>  	case NILFS_IOCTL_GET_VINFO:
> @@ -859,6 +908,7 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	case NILFS_IOCTL_GET_CPINFO:
>  	case NILFS_IOCTL_GET_CPSTAT:
>  	case NILFS_IOCTL_GET_SUINFO:
> +	case NILFS_IOCTL_SET_SUINFO:
>  	case NILFS_IOCTL_GET_SUSTAT:
>  	case NILFS_IOCTL_GET_VINFO:
>  	case NILFS_IOCTL_GET_BDESCS:
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 2ee1594..528e2c5 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -902,5 +902,7 @@ struct nilfs_bdesc {
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
