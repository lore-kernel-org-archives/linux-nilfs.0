From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 3/6] nilfs-utils: add support for tracking live blocks
Date: Sat, 14 Mar 2015 14:52:50 +0900 (JST)
Message-ID: <20150314.145250.2068629190053128024.konishi.ryusuke@lab.ntt.co.jp>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
	<1424804659-10986-1-git-send-email-andreas.rohner@gmx.net>
	<1424804659-10986-3-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=Wfl4YwO3rYa6g8XTYSV9rKDBETbOGZ/9tAJ++QiQz3Q=;
        b=dcVZDomakKg0LID3s7miumzFRHWvwdbhbMxYWVfaiVbTvwYUv/vfPeiVRL7EKrkvTJ
         LQ5oFef3yqt65BETz0RhSZKz5sbisS/ZgTWbbpLDIfsMdgdO8KKKCj4uydqKQA4Kdtdc
         vIJa26wpIDeRA5WU/gbZ0FuPSLE9n1x40DAJzpSBjbw3UkynJOEXjEk619Htp2bWBHJj
         /B8NWkdiCZcGvd8PiMID1K8dmejU5HfO90ICu5wtgg8NmPg+9X+7gOf9t0Yb5s1R9pGp
         7A98epe3hxqCyZsq79ObcS46D5bIkrZXu3w8e88olTzPSWT2w7rJeN+EQBpsNYDhZusN
         GxVg==
In-Reply-To: <1424804659-10986-3-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 24 Feb 2015 20:04:16 +0100, Andreas Rohner wrote:
> This patch adds a new feature flag NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS,
> which allows the user to enable and disable the tracking of live
> blocks. The flag can be set at file system creation time with mkfs or
> at any later time with nilfs-tune.
> 
> Additionally a new option NILFS_OPT_TRACK_LIVE_BLKS is added to be
> used by the GC. It is set to the same value as
> NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS at startup. It is mainly used to
> easily and efficiently check for the feature at runtime and to disable
> it if the kernel doesn't support it.
> 
> It is fully backwards compatible, because
> NILFS_FEATURE_COMPAT_SUFILE_EXTENSION also is backwards compatible and
> it basically only tells the kernel to update a counter for every
> segment in the SUFILE. If the kernel doesn't support it, the counter
> won't be updated and the GC policies depending on that information
> will work less efficient, but they would still work.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  include/nilfs.h              | 30 +++++++++++++++++++++++++++---
>  include/nilfs2_fs.h          |  4 +++-
>  lib/feature.c                |  2 ++
>  lib/nilfs.c                  | 32 ++++----------------------------
>  man/mkfs.nilfs2.8            |  6 ++++++
>  sbin/mkfs/mkfs.c             |  3 ++-
>  sbin/nilfs-tune/nilfs-tune.c |  4 ++--
>  7 files changed, 46 insertions(+), 35 deletions(-)
> 
> diff --git a/include/nilfs.h b/include/nilfs.h
> index f695f48..22a9190 100644
> --- a/include/nilfs.h
> +++ b/include/nilfs.h
> @@ -130,6 +130,7 @@ struct nilfs {
>  
>  #define NILFS_OPT_MMAP		0x01
>  #define NILFS_OPT_SET_SUINFO	0x02
> +#define NILFS_OPT_TRACK_LIVE_BLKS	0x04
>  
>  
>  struct nilfs *nilfs_open(const char *, const char *, int);
> @@ -141,9 +142,25 @@ void nilfs_opt_clear_mmap(struct nilfs *);
>  int nilfs_opt_set_mmap(struct nilfs *);
>  int nilfs_opt_test_mmap(struct nilfs *);
>  
> -void nilfs_opt_clear_set_suinfo(struct nilfs *);
> -int nilfs_opt_set_set_suinfo(struct nilfs *);
> -int nilfs_opt_test_set_suinfo(struct nilfs *);
> +#define NILFS_OPT_FLAG(flag, name)					\
> +static inline void							\
> +nilfs_opt_set_##name(struct nilfs *nilfs)			\
> +{									\
> +	nilfs->n_opts |= NILFS_OPT_##flag;		\
> +}									\
> +static inline void							\
> +nilfs_opt_clear_##name(struct nilfs *nilfs)			\
> +{									\
> +	nilfs->n_opts &= ~NILFS_OPT_##flag;		\
> +}									\
> +static inline int							\
> +nilfs_opt_test_##name(const struct nilfs *nilfs)			\
> +{									\
> +	return !!(nilfs->n_opts & NILFS_OPT_##flag);	\
> +}

Don't break library compatibility by inlining.  Al least this should
be done in a separate patch.

I think we should do the opposite thing.  I mean that the
implementation of nilfs structure should be hidden in nilfs library
sometime when we will bump up the library version because it will
break the library compatibility.

> +
> +NILFS_OPT_FLAG(SET_SUINFO, set_suinfo);
> +NILFS_OPT_FLAG(TRACK_LIVE_BLKS, track_live_blks);
>  
>  nilfs_cno_t nilfs_get_oldest_cno(struct nilfs *);
>  
> @@ -326,4 +343,11 @@ static inline __u32 nilfs_get_blocks_per_segment(const struct nilfs *nilfs)
>  	return le32_to_cpu(nilfs->n_sb->s_blocks_per_segment);
>  }
>  
> +static inline int nilfs_feature_track_live_blks(const struct nilfs *nilfs)
> +{
> +	__u64 fc = le64_to_cpu(nilfs->n_sb->s_feature_compat);
> +	return (fc & NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS) &&
> +		(fc & NILFS_FEATURE_COMPAT_SUFILE_EXTENSION);
> +}
> +
>  #endif	/* NILFS_H */
> diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
> index d01a924..427ca53 100644
> --- a/include/nilfs2_fs.h
> +++ b/include/nilfs2_fs.h
> @@ -220,10 +220,12 @@ struct nilfs_super_block {
>   * doesn't know about, it should refuse to mount the filesystem.
>   */
>  #define NILFS_FEATURE_COMPAT_SUFILE_EXTENSION		(1ULL << 0)
> +#define NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS		(1ULL << 1)
>  
>  #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT		(1ULL << 0)
>  
> -#define NILFS_FEATURE_COMPAT_SUPP	NILFS_FEATURE_COMPAT_SUFILE_EXTENSION
> +#define NILFS_FEATURE_COMPAT_SUPP	(NILFS_FEATURE_COMPAT_SUFILE_EXTENSION \
> +				| NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS)
>  #define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
>  #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
>  
> diff --git a/lib/feature.c b/lib/feature.c
> index d954cda..ebe8c3f 100644
> --- a/lib/feature.c
> +++ b/lib/feature.c
> @@ -57,6 +57,8 @@ static const struct nilfs_feature features[] = {
>  	/* Compat features */
>  	{ NILFS_FEATURE_TYPE_COMPAT,
>  	  NILFS_FEATURE_COMPAT_SUFILE_EXTENSION, "sufile_ext" },
> +	{ NILFS_FEATURE_TYPE_COMPAT,
> +	  NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS, "track_live_blks" },
>  	/* Read-only compat features */
>  	{ NILFS_FEATURE_TYPE_COMPAT_RO,
>  	  NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT, "block_count" },
> diff --git a/lib/nilfs.c b/lib/nilfs.c
> index 30db654..2067fc0 100644
> --- a/lib/nilfs.c
> +++ b/lib/nilfs.c
> @@ -290,34 +290,6 @@ int nilfs_opt_test_mmap(struct nilfs *nilfs)
>  	return !!(nilfs->n_opts & NILFS_OPT_MMAP);
>  }
>  
> -/**
> - * nilfs_opt_set_set_suinfo - set set_suinfo option
> - * @nilfs: nilfs object
> - */
> -int nilfs_opt_set_set_suinfo(struct nilfs *nilfs)
> -{
> -	nilfs->n_opts |= NILFS_OPT_SET_SUINFO;
> -	return 0;
> -}
> -
> -/**
> - * nilfs_opt_clear_set_suinfo - clear set_suinfo option
> - * @nilfs: nilfs object
> - */
> -void nilfs_opt_clear_set_suinfo(struct nilfs *nilfs)
> -{
> -	nilfs->n_opts &= ~NILFS_OPT_SET_SUINFO;
> -}
> -
> -/**
> - * nilfs_opt_test_set_suinfo - test whether set_suinfo option is set or not
> - * @nilfs: nilfs object
> - */
> -int nilfs_opt_test_set_suinfo(struct nilfs *nilfs)
> -{
> -	return !!(nilfs->n_opts & NILFS_OPT_SET_SUINFO);
> -}
> -
>  static int nilfs_open_sem(struct nilfs *nilfs)
>  {
>  	char semnambuf[NAME_MAX - 4];
> @@ -382,6 +354,7 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
>  	nilfs->n_dev = NULL;
>  	nilfs->n_ioc = NULL;
>  	nilfs->n_mincno = NILFS_CNO_MIN;
> +	nilfs->n_opts = 0;

Please fix this as a separate patch.  This is a leak bug even though
it doesn't really matters.

Regards,
Ryusuke Konishi

>  	memset(nilfs->n_sems, 0, sizeof(nilfs->n_sems));
>  
>  	if (flags & NILFS_OPEN_RAW) {
> @@ -405,6 +378,9 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
>  			errno = ENOTSUP;
>  			goto out_fd;
>  		}
> +
> +		if (nilfs_feature_track_live_blks(nilfs))
> +			nilfs_opt_set_track_live_blks(nilfs);
>  	}
>  
>  	if (flags &
> diff --git a/man/mkfs.nilfs2.8 b/man/mkfs.nilfs2.8
> index 6c9a644..2431ac9 100644
> --- a/man/mkfs.nilfs2.8
> +++ b/man/mkfs.nilfs2.8
> @@ -176,6 +176,12 @@ cannot be disabled, because it changes the ondisk format. Nevertheless it
>  is fully compatible with older versions of the file system. This feature
>  is on by default, because it is fully backwards compatible and can only
>  be set at file system creation time.
> +.TP
> +.B track_live_blks
> +Enables the tracking of live blocks, which might improve the effectiveness of
> +garbage collection, but entails a small runtime overhead. It is important to
> +note, that this feature depends on sufile_ext, which can only be set
> +at file system creation time.
>  .RE
>  .TP
>  .B \-q
> diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
> index 3985262..680311c 100644
> --- a/sbin/mkfs/mkfs.c
> +++ b/sbin/mkfs/mkfs.c
> @@ -1082,7 +1082,8 @@ static inline void check_ctime(time_t ctime)
>  
>  static const __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
>  	/* Compat */
> -	NILFS_FEATURE_COMPAT_SUFILE_EXTENSION,
> +	NILFS_FEATURE_COMPAT_SUFILE_EXTENSION |
> +	NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS,
>  	/* Read-only compat */
>  	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
>  	/* Incompat */
> diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.c
> index 60f1d39..7889310 100644
> --- a/sbin/nilfs-tune/nilfs-tune.c
> +++ b/sbin/nilfs-tune/nilfs-tune.c
> @@ -84,7 +84,7 @@ static void nilfs_tune_usage(void)
>  
>  static const __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
>  	/* Compat */
> -	0,
> +	NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS,
>  	/* Read-only compat */
>  	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
>  	/* Incompat */
> @@ -93,7 +93,7 @@ static const __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
>  
>  static const __u64 clear_ok_features[NILFS_MAX_FEATURE_TYPES] = {
>  	/* Compat */
> -	0,
> +	NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS,
>  	/* Read-only compat */
>  	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
>  	/* Incompat */
> -- 
> 2.3.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
