From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 2/9] nilfs2: add simple cache for modifications to
 SUFILE
Date: Sat, 14 Mar 2015 09:45:08 +0900 (JST)
Message-ID: <20150314.094508.136245760217644902.konishi.ryusuke@lab.ntt.co.jp>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
	<1424804504-10914-3-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=tttSaIRny49Ua8kYLv3/+zPErsMj6gTbj2m/qaWRKME=;
        b=FRkbREzdapcbtjGpBpWszTxQ4oYEjIOfuOHx0FN6QzvUVdYC9ajQMG0YZYOj4nMt7l
         11brqbDJiD2MCVnVEBs+l9F+nCVR+hT+6UBMrXAUdb4QwL6SwhUZkKDPGf/8ohuj5af5
         C82AyDq7vjDJgTYWpEgbO5PvA95AkOSkMxIT86g8I1jj2mOf0KK9x4FtqQIBOJLKhntT
         uK131dd3rj0mCavoBMkj8aU4gxTZ+h8N5qt/4G0fOZim4P6Ch98wh2iUuFHNNczoG2sm
         5JD/dBXmAqIv1W3c7VRaRIpATOhFpWMQNcQpNLzuvJqlm+sSVphRStSP/WTMmkDsZJzc
         zICA==
In-Reply-To: <1424804504-10914-3-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: andreas.rohner-hi6Y0CQ0nG0@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 24 Feb 2015 20:01:37 +0100, Andreas Rohner wrote:
> This patch adds a simple, small cache that can be used to accumulate
> modifications to SUFILE entries. This is for example useful for
> keeping track of reclaimable blocks, because most of the
> modifications consist of small increments or decrements. By adding
> these up and temporarily storing them in a small cache, the
> performance can be improved. Additionally lock contention is
> reduced.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/sufile.c | 178 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/sufile.h |  44 +++++++++++++
>  2 files changed, 222 insertions(+)
> 
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 1e8cac6..a369c30 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -1168,6 +1168,184 @@ out_sem:
>  }
>  
>  /**
> + * nilfs_sufile_mc_init - inits segusg modification cache
> + * @mc: modification cache
> + * @capacity: maximum capacity of the mod cache
> + *
> + * Description: Allocates memory for an array of nilfs_sufile_mod structures
> + * according to @capacity. This memory must be freed with
> + * nilfs_sufile_mc_destroy().
> + *
> + * Return Value: On success, 0 is returned. On error, one of the following
> + * negative error codes is returned.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-EINVAL - Invalid capacity.
> + */
> +int nilfs_sufile_mc_init(struct nilfs_sufile_mod_cache *mc, size_t capacity)
> +{
> +	mc->mc_capacity = capacity;
> +	if (!capacity)
> +		return -EINVAL;
> +
> +	mc->mc_mods = kmalloc(capacity * sizeof(struct nilfs_sufile_mod),
> +			      GFP_KERNEL);

GFP_NOFS must be used instead of GFP_KERNEL to avoid initiating other
filesystem operations.

The abbreviation "mc" is not good, which is already used as the
abbreviation of "minimum clean" in userland.

> +	if (!mc->mc_mods)
> +		return -ENOMEM;
> +
> +	mc->mc_size = 0;
> +
> +	return 0;
> +}
> +
> +/**
> + * nilfs_sufile_mc_add - add signed value to segusg modification cache
> + * @mc: modification cache
> + * @segnum: segment number
> + * @value: signed value (can be positive and negative)
> + *
> + * Description: nilfs_sufile_mc_add() tries to add a pair of @segnum and
> + * @value to the modification cache. If the cache already contains a
> + * segment number equal to @segnum, then @value is simply added to the
> + * existing value. This way thousands of small modifications can be
> + * accumulated into one value. If @segnum cannot be found and the
> + * capacity allows it, a new element is added to the cache. If the
> + * capacity is reached an error value is returned.
> + *
> + * Return Value: On success, 0 is returned. On error, one of the following
> + * negative error codes is returned.
> + *
> + * %-ENOSPC - The mod cache has reached its capacity and must be flushed.
> + */
> +static inline int nilfs_sufile_mc_add(struct nilfs_sufile_mod_cache *mc,
> +				      __u64 segnum, __s64 value)
> +{
> +	struct nilfs_sufile_mod *mods = mc->mc_mods;
> +	int i;
> +
> +	for (i = 0; i < mc->mc_size; ++i, ++mods) {
> +		if (mods->m_segnum == segnum) {
> +			mods->m_value += value;
> +			return 0;
> +		}
> +	}
> +
> +	if (mc->mc_size < mc->mc_capacity) {
> +		mods->m_segnum = segnum;
> +		mods->m_value = value;
> +		mc->mc_size++;
> +		return 0;
> +	}
> +
> +	return -ENOSPC;
> +}
> +
> +/**
> + * nilfs_sufile_mc_clear - set mc_size to 0
> + * @mc: modification cache
> + *
> + * Description: nilfs_sufile_mc_clear() sets mc_size to 0, which enables
> + * nilfs_sufile_mc_add() to overwrite the elements in @mc.
> + */
> +static inline void nilfs_sufile_mc_clear(struct nilfs_sufile_mod_cache *mc)
> +{
> +	mc->mc_size = 0;
> +}
> +
> +/**
> + * nilfs_sufile_mc_reset - clear cache and add one element
> + * @mc: modification cache
> + * @segnum: segment number
> + * @value: signed value (can be positive and negative)
> + *
> + * Description: Clears the modification cache in @mc and adds a new pair of
> + * @segnum and @value to it at the same time.
> + */
> +static inline void nilfs_sufile_mc_reset(struct nilfs_sufile_mod_cache *mc,
> +					 __u64 segnum, __s64 value)
> +{
> +	struct nilfs_sufile_mod *mods = mc->mc_mods;
> +
> +	mods->m_segnum = segnum;
> +	mods->m_value = value;
> +	mc->mc_size = 1;
> +}

The name of this function is confusing.  Actual meaning of this
function is "reset" and "add", and that can be replaced with mc_clear
and mc_add.  Remove this function to simplify interface.

Regards,
Ryusuke Konishi

> +/**
> + * nilfs_sufile_mc_flush - flush modification cache
> + * @sufile: inode of segment usage file
> + * @mc: modification cache
> + * @dofunc: primitive operation for the update
> + *
> + * Description: nilfs_sufile_mc_flush() flushes the cached modifications
> + * and applies them to the segment usages on disk. It persists the cached
> + * changes, by calling @dofunc for every element in the cache. @dofunc also
> + * determines the interpretation of the cached values and how they should
> + * be applied to the corresponding segment usage entries.
> + *
> + * Return Value: On success, zero is returned.  On error, one of the
> + * following negative error codes is returned.
> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-ENOENT - Given segment usage is in hole block
> + *
> + * %-EINVAL - Invalid segment usage number
> + */
> +static inline int nilfs_sufile_mc_flush(struct inode *sufile,
> +					struct nilfs_sufile_mod_cache *mc,
> +					void (*dofunc)(struct inode *,
> +						struct nilfs_sufile_mod *,
> +						struct buffer_head *,
> +						struct buffer_head *))
> +{
> +	return nilfs_sufile_updatev(sufile, mc->mc_mods,
> +				    sizeof(struct nilfs_sufile_mod),
> +				    offsetof(struct nilfs_sufile_mod, m_segnum),
> +				    mc->mc_size, 0, NULL, (void *)dofunc);
> +}
> +
> +/**
> + * nilfs_sufile_mc_update - immediately applies modification
> + * @sufile: inode of segment usage file
> + * @segnum: segment number
> + * @value: signed value (can be positive and negative)
> + * @dofunc: primitive operation for the update
> + *
> + * Description: nilfs_sufile_mc_update() is a helper function, that
> + * creates a temporary nilfs_sufile_mod structure out of @segnum and @value
> + * and immediately flushes it using @dofunc, without the use of a
> + * modification cache.
> + *
> + * Return Value: On success, zero is returned.  On error, one of the
> + * following negative error codes is returned.
> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-ENOENT - Given segment usage is in hole block
> + *
> + * %-EINVAL - Invalid segment usage number
> + */
> +static inline int nilfs_sufile_mc_update(struct inode *sufile,
> +					 __u64 segnum, __s64 value,
> +					 void (*dofunc)(struct inode *,
> +						struct nilfs_sufile_mod *,
> +						struct buffer_head *,
> +						struct buffer_head *))
> +{
> +	struct nilfs_sufile_mod m = {.m_segnum = segnum, .m_value = value};
> +
> +	return nilfs_sufile_update(sufile, &m,
> +				   offsetof(struct nilfs_sufile_mod, m_segnum),
> +				   0, (void *)dofunc);
> +}
> +
> +/**
>   * nilfs_sufile_read - read or get sufile inode
>   * @sb: super block instance
>   * @susize: size of a segment usage entry
> diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
> index 2df6c71..c446325 100644
> --- a/fs/nilfs2/sufile.h
> +++ b/fs/nilfs2/sufile.h
> @@ -146,4 +146,48 @@ static inline int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
>  				   (void *)nilfs_sufile_do_set_error);
>  }
>  
> +#define NILFS_SUFILE_MC_SIZE_DEFAULT	5
> +#define NILFS_SUFILE_MC_SIZE_EXT	10
> +
> +/**
> + * struct nilfs_sufile_mod - segment usage modification
> + * @m_segnum: segment number
> + * @m_value: signed value that gets added to respective segusg field
> + */
> +struct nilfs_sufile_mod {
> +	__u64 m_segnum;
> +	__s64 m_value;
> +};
> +
> +/**
> + * struct nilfs_sufile_mod_cache - segment usage modification cache
> + * @mc_mods: array of modifications to segments
> + * @mc_capacity: maximum number of elements that fit in @mc_mods
> + * @mc_size: number of elements currently filled with valid data
> + */
> +struct nilfs_sufile_mod_cache {
> +	struct nilfs_sufile_mod *mc_mods;
> +	size_t mc_capacity;
> +	size_t mc_size;
> +};
> +
> +int nilfs_sufile_mc_init(struct nilfs_sufile_mod_cache *, size_t);
> +
> +/**
> + * nilfs_sufile_mc_destroy - destroy segusg modification cache
> + * @mc: modification cache
> + *
> + * Description: Releases the memory allocated by nilfs_sufile_mc_init and
> + * sets the size and capacity to 0. @mc should not be used after a call to
> + * this function.
> + */
> +static inline void nilfs_sufile_mc_destroy(struct nilfs_sufile_mod_cache *mc)
> +{
> +	if (mc) {
> +		kfree(mc->mc_mods);
> +		mc->mc_capacity = 0;
> +		mc->mc_size = 0;
> +	}
> +}
> +
>  #endif	/* _NILFS_SUFILE_H */
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
