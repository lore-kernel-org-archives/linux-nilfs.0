From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 3/9] nilfs2: extend SUFILE on-disk format to enable
 counting of live blocks
Date: Sat, 14 Mar 2015 13:05:10 +0900 (JST)
Message-ID: <20150314.130510.1787020452086116319.konishi.ryusuke@lab.ntt.co.jp>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
	<1424804504-10914-4-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=UOIePb1S777ewT1FZW/Wc/5clA9ztIg6diS2DaWdteA=;
        b=fuvsYALCYxg4KjrddrXMZwSIkUjbcQcB0RHhM6QfDkI6sUipALBfA/08UlGzCkVU9e
         7LIOmCOfM8wgDTHBOJEOQ6FXO8LUMucn42glB3D8PFGhMEzA9kRNitiwOor6Ix0vs4MQ
         AzHLDGk2Q7a4DDBH+ODCC7J/wavQnYGWMNmVqghqKr1bG3jQjyuoy1qmSlwfaQFl9ity
         HLM67Am6Ag3blgQody5wyAW7RmboirPFzMj76uc0BnIfPJb4WjfpxNEUQNBeaxq7gaOj
         09FL5bN0CNplYH47DSCD7hoHtBOV+X/xlYvK0XgspLymDKoSHLumQjvPuilC5t4TX9rp
         a+pQ==
In-Reply-To: <1424804504-10914-4-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 24 Feb 2015 20:01:38 +0100, Andreas Rohner wrote:
> *buf,
>  	int cleansi, cleansu, dirtysi, dirtysu;
>  	long ncleaned = 0, ndirtied = 0;
>  	int ret = 0;
> +	bool sup_ext = (supsz >= NILFS_EXT_SUINFO_UPDATE_SIZE);
> +	bool su_ext = nilfs_sufile_ext_supported(sufile);
>  
>  	if (unlikely(nsup == 0))
>  		return ret;
> @@ -926,6 +949,9 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
>  				(~0UL << __NR_NILFS_SUINFO_UPDATE_FIELDS))
>  			|| (nilfs_suinfo_update_nblocks(sup) &&
>  				sup->sup_sui.sui_nblocks >
> +				nilfs->ns_blocks_per_segment)
> +			|| (nilfs_suinfo_update_nlive_blks(sup) && sup_ext &&
> +				sup->sup_sui.sui_nlive_blks >
>  				nilfs->ns_blocks_per_segment))
>  			return -EINVAL;
>  	}
> @@ -953,6 +979,14 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
>  		if (nilfs_suinfo_update_nblocks(sup))
>  			su->su_nblocks = cpu_to_le32(sup->sup_sui.sui_nblocks);
>  
> +		if (nilfs_suinfo_update_nlive_blks(sup) && sup_ext && su_ext)
> +			su->su_nlive_blks =
> +				cpu_to_le32(sup->sup_sui.sui_nlive_blks);
> +
> +		if (nilfs_suinfo_update_nlive_lastmod(sup) && sup_ext && su_ext)
> +			su->su_nlive_lastmod =
> +				cpu_to_le64(sup->sup_sui.sui_nlive_lastmod);
> +
>  		if (nilfs_suinfo_update_flags(sup)) {
>  			/*
>  			 * Active flag is a virtual flag projected by running
> diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
> index c446325..d56498b 100644
> --- a/fs/nilfs2/sufile.h
> +++ b/fs/nilfs2/sufile.h
> @@ -28,6 +28,11 @@
>  #include <linux/nilfs2_fs.h>
>  #include "mdt.h"
>  
> +static inline int
> +nilfs_sufile_ext_supported(const struct inode *sufile)
> +{
> +	return NILFS_MDT(sufile)->mi_entry_size >= NILFS_EXT_SEGMENT_USAGE_SIZE;
> +}
>  
>  static inline unsigned long nilfs_sufile_get_nsegments(struct inode *sufile)
>  {
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index ff3fea3..5d83c55 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -220,9 +220,11 @@ struct nilfs_super_block {
>   * If there is a bit set in the incompatible feature set that the kernel
>   * doesn't know about, it should refuse to mount the filesystem.
>   */
> -#define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT	0x00000001ULL
> +#define NILFS_FEATURE_COMPAT_SUFILE_EXTENSION		(1ULL << 0)

This feature name is not good.  sufile can be extended more in a future.
You should name it based on the meaning of the extension of this time.

As I mentioned in another patch, I think this could be unified to the
TRACK_LIVE_BLKS feature that a later patch adds since the live block
counting of this patchset is inherently depending on the extention of
sufile.

>  
> -#define NILFS_FEATURE_COMPAT_SUPP	0ULL
> +#define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT		(1ULL << 0)
> +

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
