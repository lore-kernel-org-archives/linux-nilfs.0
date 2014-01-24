From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 1/3] nilfs2: add new nilfs_suinfo_update struct
Date: Fri, 24 Jan 2014 13:56:35 +0900 (JST)
Message-ID: <20140124.135635.27780504.konishi.ryusuke@lab.ntt.co.jp>
References: <cover.1390310509.git.andreas.rohner@gmx.net>
	<cec6a449ddf5ae9da2928cdddfb96ebcb2789eee.1390312777.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cec6a449ddf5ae9da2928cdddfb96ebcb2789eee.1390312777.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 21 Jan 2014 15:00:28 +0100, Andreas Rohner wrote:
> This adds struct nilfs_suinfo_update and some flags. It contains the
> information needed to update one entry of segment usage information in
> the SUFILE. The flags specify, which fields need to be updated.
> 
> This can be used to update segment usage information from userspace with an
> ioctl.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  include/linux/nilfs2_fs.h | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 9875576..2ee1594 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -709,6 +709,45 @@ static inline int nilfs_suinfo_clean(const struct nilfs_suinfo *si)
>  	return !si->sui_flags;
>  }
>  
> +/**
> + * nilfs_suinfo_update - segment usage information update
> + * @sup_segnum: segment number
> + * @sup_flags: flags for which fields are active in sup_sui
> + * @sup_sui: segment usage information
> + */
> +struct nilfs_suinfo_update {
> +	__u64 sup_segnum;
> +	__u32 sup_flags;
> +	struct nilfs_suinfo sup_sui;
> +};

This structure is not aligned on 8 byte boundary.  You need a 4 byte
pad to make the alignment architecture independent since the structure
already has some 64-bit variables.

If you do not so, the ioctl will lose compatibility, for instance,
between 32 bit userland programs and 64 bit kernel.

struct nilfs_suinfo_update {
	__u64 sup_segnum;
	__u32 sup_flags;
	__u32 sup_reserved;
	struct nilfs_suinfo sup_sui;
};

Do you really need different suinfo update flags per segment ?

If it's not so, we don't have to add nilfs_suinfo_update structure.
v_flags of nilfs_argv structure looks to be available for that
purpose.  It's just a confirmation.  Basically, I think this extension
is acceptable.


Regards,
Ryusuke Konishi

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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
