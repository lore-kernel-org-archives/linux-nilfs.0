From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 4/9] nilfs2: add function to modify su_nlive_blks
Date: Sat, 14 Mar 2015 13:57:04 +0900 (JST)
Message-ID: <20150314.135704.2029475436182884660.konishi.ryusuke@lab.ntt.co.jp>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
	<1424804504-10914-5-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=oHdPeR9NENL9A4LqzpE9JLMLy7ndZ5aGxBDl0r7XRF4=;
        b=jOrcvCcbcdfndryFSLBPr7KJ6MVSVCMUqueka39CWMjvbh+bqDK/0ErORWnl3IE8cY
         GPB+UCVEfajDeAxt1Cwsaej81skMs79AcssTWsP0XGKF0qhnpydGlC5DfhTquwDYUkI8
         K9hlPxOASha3F9XebeUgZOXFTUEFygLPqEYraSro6T9GFB9Rlu7CKMkE5A16z3I6QvU4
         kMp5N/GQvMsrC9uqnGUr16Qvwc4no01UEUhTp8942Eh8/FmONlmDvV1NEkXuuApo7E2f
         tYtwxQZjshyL3tMYoIX33ocjuysMG2aU0Kawn/L6YfTm/DQoouO2QCIje5CgMf5LQQaC
         RgoA==
In-Reply-To: <1424804504-10914-5-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 24 Feb 2015 20:01:39 +0100, Andreas Rohner wrote:
> This patch adds a function to modify the su_nlive_blks field of the
> nilfs_segment_usage structure in the SUFILE. By using positive or
> negative integers, it is possible to add and substract any value from
> the su_nlive_blks field.
> 
> The use of a modification cache is optional and by passing a NULL
> pointer the value will be added or subtracted directly. Otherwise it is
> necessary to call nilfs_sufile_flush_nlive_blks() at some point to make
> the modifications persistent.
> 
> The modification cache is useful, because it allows for small values,
> like simple increments and decrements, to be added up before writing
> them to the SUFILE.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/sufile.c | 138 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/sufile.h |   5 ++
>  2 files changed, 143 insertions(+)
> 
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index ae08050..574a77e 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -1380,6 +1380,144 @@ static inline int nilfs_sufile_mc_update(struct inode *sufile,
>  }
>  
>  /**
> + * nilfs_sufile_do_flush_nlive_blks - apply modification to su_nlive_blks
> + * @sufile: inode of segment usage file
> + * @mod: modification structure
> + * @header_bh: sufile header block
> + * @su_bh: block containing segment usage of m_segnum in @mod
> + *
> + * Description: nilfs_sufile_do_flush_nlive_blks() is a callback function
> + * used with nilfs_sufile_updatev(), that adds m_value in @mod to
> + * the su_nlive_blks field of the segment usage entry belonging to m_segnum.
> + */
> +static void nilfs_sufile_do_flush_nlive_blks(struct inode *sufile,
> +					     struct nilfs_sufile_mod *mod,
> +					     struct buffer_head *header_bh,
> +					     struct buffer_head *su_bh)
> +{
> +	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
> +	struct nilfs_segment_usage *su;
> +	void *kaddr;
> +	__u32 nblocks, nlive_blocks;
> +	__u64 segnum = mod->m_segnum;
> +	__s64 value = mod->m_value;
> +
> +	if (!value)
> +		return;
> +
> +	kaddr = kmap_atomic(su_bh->b_page);
> +
> +	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
> +	WARN_ON(nilfs_segment_usage_error(su));
> +
> +	nblocks = le32_to_cpu(su->su_nblocks);
> +	nlive_blocks = le32_to_cpu(su->su_nlive_blks);
> +
> +	value += nlive_blocks;
> +	if (value < 0)
> +		value = 0;
> +	else if (value > nblocks)
> +		value = nblocks;
> +
> +	/* do nothing if the value didn't change */
> +	if (value != nlive_blocks) {
> +		su->su_nlive_blks = cpu_to_le32(value);
> +		su->su_nlive_lastmod = cpu_to_le64(nilfs->ns_ctime);

ns_ctime should not be used because it is updated after writing
segment.  get_seconds() should be used.

> +	}
> +
> +	kunmap_atomic(kaddr);
> +
> +	if (value != nlive_blocks) {
> +		mark_buffer_dirty(su_bh);
> +		nilfs_mdt_mark_dirty(sufile);
> +	}
> +}
> +
> +/**
> + * nilfs_sufile_flush_nlive_blks - flush mod cache to su_nlive_blks
> + * @sufile: inode of segment usage file
> + * @mc: modification cache
> + *
> + * Description: nilfs_sufile_flush_nlive_blks() flushes the cached
> + * modifications in @mc, by applying them to the su_nlive_blks field of
> + * the corresponding segment usage entries. @mc can be NULL or empty. If
> + * the sufile extension needed to support su_nlive_blks is not supported the
> + * function will abort without error.
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
> +int nilfs_sufile_flush_nlive_blks(struct inode *sufile,
> +				  struct nilfs_sufile_mod_cache *mc)
> +{
> +	int ret;
> +
> +	if (!mc || !mc->mc_size || !nilfs_sufile_ext_supported(sufile))
> +		return 0;
> +
> +	ret = nilfs_sufile_mc_flush(sufile, mc,
> +				    nilfs_sufile_do_flush_nlive_blks);
> +
> +	nilfs_sufile_mc_clear(mc);
> +
> +	return ret;
> +}
> +
> +/**
> + * nilfs_sufile_mod_nlive_blks - modifiy su_nlive_blks using mod cache
> + * @sufile: inode of segment usage file
> + * @mc: modification cache
> + * @segnum: segment number
> + * @value: signed value (can be positive and negative)
> + *
> + * Description: nilfs_sufile_mod_nlive_blks() adds @value to the su_nlive_blks
> + * field of the segment usage entry for @segnum. If @mc is not NULL it first
> + * accumulates all modifications in the cache and flushes it if it is full.
> + * Otherwise the change is applied directly.
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
> +int nilfs_sufile_mod_nlive_blks(struct inode *sufile,
> +				struct nilfs_sufile_mod_cache *mc,
> +				__u64 segnum, __s64 value)
> +{
> +	int ret;
> +
> +	if (!value || !nilfs_sufile_ext_supported(sufile))
> +		return 0;
> +
> +	if (!mc)
> +		return nilfs_sufile_mc_update(sufile, segnum, value,
> +				nilfs_sufile_do_flush_nlive_blks);
> +
> +	if (!nilfs_sufile_mc_add(mc, segnum, value))
> +		return 0;
> +
> +	ret = nilfs_sufile_flush_nlive_blks(sufile, mc);
> +
> +	nilfs_sufile_mc_reset(mc, segnum, value);
> +
> +	return ret;
> +}
> +
> +/**
>   * nilfs_sufile_read - read or get sufile inode
>   * @sb: super block instance
>   * @susize: size of a segment usage entry
> diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
> index d56498b..ae3c52a 100644
> --- a/fs/nilfs2/sufile.h
> +++ b/fs/nilfs2/sufile.h
> @@ -195,4 +195,9 @@ static inline void nilfs_sufile_mc_destroy(struct nilfs_sufile_mod_cache *mc)
>  	}
>  }
>  
> +int nilfs_sufile_flush_nlive_blks(struct inode *,
> +				  struct nilfs_sufile_mod_cache *);
> +int nilfs_sufile_mod_nlive_blks(struct inode *, struct nilfs_sufile_mod_cache *,
> +				__u64, __s64);
> +

Please add variable names to arguments of new declarations.
(You don't have to add variable names to unrelated declarations)

Regards,
Ryusuke Konishi

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
