From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v4 4/6] nilfs-utils: add suport for
 NILFS_IOCTL_SET_SUINFO ioctl
Date: Thu, 06 Feb 2014 04:25:18 +0900 (JST)
Message-ID: <20140206.042518.139122814.konishi.ryusuke@lab.ntt.co.jp>
References: <cover.1391566347.git.andreas.rohner@gmx.net>
	<cover.1391566347.git.andreas.rohner@gmx.net>
	<6b62cd72448c48055cfab9017753349cb2cd7da9.1391566347.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6b62cd72448c48055cfab9017753349cb2cd7da9.1391566347.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed,  5 Feb 2014 03:16:37 +0100, Andreas Rohner wrote:
> This patch adds library support for the NILFS_IOCTL_SET_SUINFO
> ioctl. A new function nilfs_set_suinfo and the structure
> nilfs_suinfo_update, which contains the update information, are
> added.
> 
> With this function the segment usage information can be updated
> from userspace, which can be used as a shortcut for certain GC
> operations.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  include/nilfs.h     |  2 ++
>  include/nilfs2_fs.h | 43 +++++++++++++++++++++++++++++++++++++++++++
>  lib/nilfs.c         | 35 +++++++++++++++++++++++++++++++++++
>  3 files changed, 80 insertions(+)
> 
> diff --git a/include/nilfs.h b/include/nilfs.h
> index b5f85d3..da18e24 100644
> --- a/include/nilfs.h
> +++ b/include/nilfs.h
> @@ -304,6 +304,8 @@ int nilfs_delete_checkpoint(struct nilfs *, nilfs_cno_t);
>  int nilfs_get_cpstat(const struct nilfs *, struct nilfs_cpstat *);
>  ssize_t nilfs_get_suinfo(const struct nilfs *, __u64, struct nilfs_suinfo *,
>  			 size_t);
> +ssize_t nilfs_set_suinfo(struct nilfs *, struct nilfs_suinfo_update *,
> +			 size_t);
>  int nilfs_get_sustat(const struct nilfs *, struct nilfs_sustat *);
>  ssize_t nilfs_get_vinfo(const struct nilfs *, struct nilfs_vinfo *, size_t);
>  ssize_t nilfs_get_bdescs(const struct nilfs *, struct nilfs_bdesc *, size_t);
> diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
> index e674f44..cf8f633 100644
> --- a/include/nilfs2_fs.h
> +++ b/include/nilfs2_fs.h
> @@ -714,6 +714,47 @@ static inline int nilfs_suinfo_clean(const struct nilfs_suinfo *si)
>  }
>  
>  /* ioctl */
> +/**
> + * nilfs_suinfo_update - segment usage information update
> + * @sup_segnum: segment number
> + * @sup_flags: flags for which fields are active in sup_sui
> + * @sup_reserved: reserved necessary for alignment
> + * @sup_sui: segment usage information
> + */
> +struct nilfs_suinfo_update {
> +	__u64 sup_segnum;
> +	__u32 sup_flags;
> +	__u32 sup_reserved;
> +	struct nilfs_suinfo sup_sui;
> +};
> +
> +enum {
> +	NILFS_SUINFO_UPDATE_LASTMOD,
> +	NILFS_SUINFO_UPDATE_NBLOCKS,
> +	NILFS_SUINFO_UPDATE_FLAGS,
> +};
> +
> +#define NILFS_SUINFO_UPDATE_FNS(flag, name)				\
> +static inline void							\
> +nilfs_suinfo_update_set_##name(struct nilfs_suinfo_update *sup)		\
> +{									\
> +	sup->sup_flags |= 1UL << NILFS_SUINFO_UPDATE_##flag;		\
> +}									\
> +static inline void							\
> +nilfs_suinfo_update_clear_##name(struct nilfs_suinfo_update *sup)	\
> +{									\
> +	sup->sup_flags &= ~(1UL << NILFS_SUINFO_UPDATE_##flag);		\
> +}									\
> +static inline int							\
> +nilfs_suinfo_update_##name(const struct nilfs_suinfo_update *sup)	\
> +{									\
> +	return !!(sup->sup_flags & (1UL << NILFS_SUINFO_UPDATE_##flag));\
> +}
> +
> +NILFS_SUINFO_UPDATE_FNS(LASTMOD, lastmod)
> +NILFS_SUINFO_UPDATE_FNS(NBLOCKS, nblocks)
> +NILFS_SUINFO_UPDATE_FNS(FLAGS, flags)
> +
>  enum {
>  	NILFS_CHECKPOINT,
>  	NILFS_SNAPSHOT,
> @@ -867,5 +908,7 @@ struct nilfs_bdesc {
>  	_IOW(NILFS_IOCTL_IDENT, 0x8B, __u64)
>  #define NILFS_IOCTL_SET_ALLOC_RANGE  \
>  	_IOW(NILFS_IOCTL_IDENT, 0x8C, __u64[2])
> +#define NILFS_IOCTL_SET_SUINFO  \
> +	_IOW(NILFS_IOCTL_IDENT, 0x8D, struct nilfs_argv)
>  
>  #endif	/* _LINUX_NILFS_FS_H */
> diff --git a/lib/nilfs.c b/lib/nilfs.c
> index 93822de..e6f7c1e 100644
> --- a/lib/nilfs.c
> +++ b/lib/nilfs.c
> @@ -596,6 +596,41 @@ ssize_t nilfs_get_suinfo(const struct nilfs *nilfs, __u64 segnum,
>  }
>  
>  /**
> + * nilfs_set_suinfo - sets segment usage info
> + * @nilfs: nilfs object
> + * @sup: an array of nilfs_suinfo_update structs
> + * @nsup: number of elements in sup
> + *
> + * Description: Takes an array of nilfs_suinfo_update structs and updates
> + * segment usage info accordingly. Only the fields indicated by sup_flags
> + * are updated.
> + *
> + * Return Value: On success, 0 is returned. On error, -1 is returned.
> + */
> +ssize_t nilfs_set_suinfo(struct nilfs *nilfs,
> +			 struct nilfs_suinfo_update *sup, size_t nsup)

The type of return value of this function should be "int" because it
doesn't return the count of obtained suinfo items.

> +{
> +	struct nilfs_argv argv;
> +
> +	if (nilfs->n_iocfd < 0) {
> +		errno = EBADF;
> +		return -1;
> +	}
> +
> +	argv.v_base = (unsigned long)sup;
> +	argv.v_nmembs = nsup;
> +	argv.v_size = sizeof(struct nilfs_suinfo_update);
> +	argv.v_index = 0;
> +	argv.v_flags = 0;
> +	if (ioctl(nilfs->n_iocfd, NILFS_IOCTL_SET_SUINFO, &argv) < 0) {
> +		if (errno == ENOTTY)
> +			nilfs_opt_clear_set_suinfo(nilfs);

This invalidation should be done in utils or upper library.
Simply return here as follows:

     return ioctl(nilfs->n_iocfd, NILFS_IOCTL_SET_SUINFO, &argv);
}


Regards,
Ryusuke Konishi


> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +/**
>   * nilfs_get_sustat - get segment usage statistics
>   * @nilfs: nilfs object
>   * @sustat: buffer of a nilfs_sustat struct to store statistics in
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
