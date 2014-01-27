From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v3 1/3] nilfs2: add struct nilfs_suinfo_update and flags
Date: Tue, 28 Jan 2014 00:29:45 +0900 (JST)
Message-ID: <20140128.002945.60055619.konishi.ryusuke@lab.ntt.co.jp>
References: <cover.1390813175.git.andreas.rohner@gmx.net>
	<bb721a6255f199eb4a3fdfe2b34e0bdaa5f870a7.1390816620.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bb721a6255f199eb4a3fdfe2b34e0bdaa5f870a7.1390816620.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 27 Jan 2014 10:59:26 +0100, Andreas Rohner wrote:
> This patch adds the nilfs_suinfo_update structure, which contains the
> information needed to update one segment usage entry. The flags
> specify, which fields need to be updated.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  include/linux/nilfs2_fs.h | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 9875576..7b94449 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -709,6 +709,47 @@ static inline int nilfs_suinfo_clean(const struct nilfs_suinfo *si)
>  	return !si->sui_flags;
>  }
>  
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
>  /* ioctl */
>  enum {
>  	NILFS_CHECKPOINT,
> -- 
> 1.8.5.3

This patch looks good to me.


Strictly speaking, these declarations should be inserted in the ioctl
section of nilfs2_fs.h which starts from the comment line /* ioctl */
instead of the disk format section.  But, the current constuction of
nilfs2_fs.h is already broken :(

The insert position you selected seems appropriate for now.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
