From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 3/9] nilfs2: introduce new feature flag for tracking
 live blocks
Date: Sat, 09 May 2015 11:28:14 +0900 (JST)
Message-ID: <20150509.112814.2026089040966346261.konishi.ryusuke@lab.ntt.co.jp>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>
	<1430647522-14304-4-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=JlL5R0iI1OL/07XijdRISKYzGhU7DOdlcweBcKFvylo=;
        b=eDyPfhOjlsN0A5s7vn0snz8VsOyVKBjv8ZUDl6Yd7re0kKzALUznwCeglt0NYot59E
         3zCpiwOxWaKhoaaL6QWVjCt9nsDeo0LbJenj2h54xiCnVoGo6BbOCadPHxeTS+u2JkHe
         KlkhpRwoUw45nVB583qkWddCSoYkT63R9x/G7C8s+yGNUfzXaxnR3rTUjsRNDYiuhmBO
         /dn7ehh2Ne5nPCe4cr10ml0nWurrYEUMbRjzZTyIJH72uw2TfBzDrE4d2w1jFghqrjnN
         DeWbf95sUPtQo1eeGaLGWUHYHdz6nZH3hJvnEZe04dzXhryRMa8GqfEbghj57oa1gnx1
         3ZIQ==
In-Reply-To: <1430647522-14304-4-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun,  3 May 2015 12:05:16 +0200, Andreas Rohner wrote:
> This patch introduces a new file system feature flag
> NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS. If it is enabled, the file system
> will keep track of the number of live blocks per segment. This
> information can be used by the GC to select segments for cleaning more
> efficiently.

Please describe the reason why you separated
NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS and
NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT that you mentioned before
in the commit log.

> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/the_nilfs.h     | 8 ++++++++
>  include/linux/nilfs2_fs.h | 4 +++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index 12cd91d..d755b6b 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -401,4 +401,12 @@ static inline int nilfs_flush_device(struct the_nilfs *nilfs)
>  	return err;
>  }
>  
> +static inline int nilfs_feature_track_live_blks(struct the_nilfs *nilfs)
> +{
> +	const __u64 required_bits = NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS |
> +				    NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT;
> +
> +	return ((nilfs->ns_feature_compat & required_bits) == required_bits);
> +}
> +
>  #endif /* _THE_NILFS_H */
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 4800daa..5f05bbf 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -221,11 +221,13 @@ struct nilfs_super_block {
>   * doesn't know about, it should refuse to mount the filesystem.
>   */
>  #define NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT	BIT(0)
> +#define NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS		BIT(1)

Ditto.  Avoid using BIT macro in nilfs2_fs.h for now.

Regards,
Ryusuke Konishi

>  #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT		BIT(0)
>  
>  #define NILFS_FEATURE_COMPAT_SUPP					\
> -			(NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT)
> +			(NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT |	\
> +			 NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS)
>  #define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
>  #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
>  
> -- 
> 2.3.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
