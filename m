From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 6/9] nilfs2: use modification cache to improve
 performance
Date: Sat, 14 Mar 2015 10:04:54 +0900 (JST)
Message-ID: <20150314.100454.282929983211771709.konishi.ryusuke@lab.ntt.co.jp>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
	<1424804504-10914-7-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=Gh97+gxSdZIP19MvJzAV0naAA2qAvhW3SUpEA+nR+6k=;
        b=BUoMM8+g+qrEJ6Xoj2U3awXy6/TwkOSzqxeU0q+M5r0VQ7X9xs7fELnAlMgX98egs+
         FadU2HE43yiilFqaMkELty+BCxAtH1F88WZc2wG6JsC8qo8qZ0YG40Lfu8KW2Tsg5fBF
         gL01bsA70ZOE8y3G3T+uchc/9eRBArFJ4yQkWRwGfdCTK1rowt05jc757LHSbn0Rp6Me
         5tY7i4BmTHN8UsgPjRhYCysZLLp4oEK8QHEo0+3grMQ8x8sQ2eRABcK/t/VOj7ND1nBo
         7sCBH6NwTTfszPJmxDqFRU/InPk8TA4GC0vkPrbEJM+KO/PJ3bmlk7bg/rVo2Cq8PybL
         wKMg==
In-Reply-To: <1424804504-10914-7-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: andreas.rohner-hi6Y0CQ0nG0@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 24 Feb 2015 20:01:41 +0100, Andreas Rohner wrote:
> This patch adds a small cache to accumulate the small decrements of
> the number of live blocks in a segment usage entry. If for example a
> large file is deleted, the segment usage entry has to be updated for
> every single block. But for every decrement, a MDT write lock has to
> be aquired, which blocks the entire SUFILE and effectively turns
> this lock into a global lock for the whole file system.
> 
> The cache tries to ameliorate this situation by adding up the
> decrements and increments for a given number of segments and
> applying the changes all at once. Because the changes are
> accumulated in memory and not immediately written to the SUFILE, the
> afore mentioned lock only needs to be aquired, if the cache is full
> or at the end of the respective operation.
> 
> To effectively get the pointer to the modification cache from the
> high level operations down to the update of the individual blocks in
> nilfs_dat_commit_end(), a new pointer b_private was added to struct
> nilfs_bmap.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/bmap.c    | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/bmap.h    | 11 +++++++-
>  fs/nilfs2/btree.c   |  2 +-
>  fs/nilfs2/direct.c  |  2 +-
>  fs/nilfs2/inode.c   | 22 +++++++++++++---
>  fs/nilfs2/segment.c | 26 +++++++++++++++---
>  fs/nilfs2/segment.h |  3 +++
>  7 files changed, 132 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
> index ecd62ba..927acb7 100644
> --- a/fs/nilfs2/bmap.c
> +++ b/fs/nilfs2/bmap.c
> @@ -288,6 +288,43 @@ int nilfs_bmap_truncate(struct nilfs_bmap *bmap, unsigned long key)
>  }
>  
>  /**
> + * nilfs_bmap_truncate_with_mc - truncate a bmap to a specified key
> + * @bmap: bmap
> + * @mc: modification cache
> + * @key: key
> + *
> + * Description: nilfs_bmap_truncate_with_mc() removes key-record pairs whose
> + * keys are greater than or equal to @key from @bmap. It has the same
> + * functionality as nilfs_bmap_truncate(), but allows the passing
> + * of a modification cache to update segment usage information.
> + *
> + * Return Value: On success, 0 is returned. On error, one of the following
> + * negative error codes is returned.
> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + */
> +int nilfs_bmap_truncate_with_mc(struct nilfs_bmap *bmap,
> +				struct nilfs_sufile_mod_cache *mc,
> +				unsigned long key)
> +{
> +	int ret;
> +
> +	down_write(&bmap->b_sem);
> +
> +	bmap->b_private = mc;
> +
> +	ret = nilfs_bmap_do_truncate(bmap, key);
> +
> +	bmap->b_private = NULL;
> +
> +	up_write(&bmap->b_sem);
> +
> +	return nilfs_bmap_convert_error(bmap, __func__, ret);
> +}
> +
> +/**
>   * nilfs_bmap_clear - free resources a bmap holds
>   * @bmap: bmap
>   *
> @@ -328,6 +365,43 @@ int nilfs_bmap_propagate(struct nilfs_bmap *bmap, struct buffer_head *bh)
>  }
>  
>  /**
> + * nilfs_bmap_propagate_with_mc - propagate dirty state
> + * @bmap: bmap
> + * @mc: modification cache
> + * @bh: buffer head
> + *
> + * Description: nilfs_bmap_propagate_with_mc() marks the buffers that directly
> + * or indirectly refer to the block specified by @bh dirty. It has
> + * the same functionality as nilfs_bmap_propagate(), but allows the passing
> + * of a modification cache to update segment usage information.
> + *
> + * Return Value: On success, 0 is returned. On error, one of the following
> + * negative error codes is returned.
> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + */
> +int nilfs_bmap_propagate_with_mc(struct nilfs_bmap *bmap,
> +				 struct nilfs_sufile_mod_cache *mc,
> +				 struct buffer_head *bh)
> +{
> +	int ret;
> +
> +	down_write(&bmap->b_sem);
> +
> +	bmap->b_private = mc;
> +
> +	ret = bmap->b_ops->bop_propagate(bmap, bh);
> +
> +	bmap->b_private = NULL;
> +
> +	up_write(&bmap->b_sem);
> +
> +	return nilfs_bmap_convert_error(bmap, __func__, ret);
> +}

These bmap functions are really bad.  The mod cache argument has no
meaning with regard to block mapping operation.  I really hope we
don't have to add these variants by hiding the cache in sufile.

> +
> +/**
>   * nilfs_bmap_lookup_dirty_buffers -
>   * @bmap: bmap
>   * @listp: pointer to buffer head list
> @@ -490,6 +564,7 @@ int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
>  
>  	init_rwsem(&bmap->b_sem);
>  	bmap->b_state = 0;
> +	bmap->b_private = NULL;
>  	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
>  	switch (bmap->b_inode->i_ino) {
>  	case NILFS_DAT_INO:
> @@ -551,6 +626,7 @@ void nilfs_bmap_init_gc(struct nilfs_bmap *bmap)
>  	bmap->b_last_allocated_key = 0;
>  	bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
>  	bmap->b_state = 0;
> +	bmap->b_private = NULL;
>  	nilfs_btree_init_gc(bmap);
>  }
>  
> diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
> index 718c814..a8b935a 100644
> --- a/fs/nilfs2/bmap.h
> +++ b/fs/nilfs2/bmap.h
> @@ -36,6 +36,7 @@
>  
>  
>  struct nilfs_bmap;
> +struct nilfs_sufile_mod_cache;
>  
>  /**
>   * union nilfs_bmap_ptr_req - request for bmap ptr
> @@ -106,6 +107,7 @@ static inline int nilfs_bmap_is_new_ptr(unsigned long ptr)
>   * @b_ptr_type: pointer type
>   * @b_state: state
>   * @b_nchildren_per_block: maximum number of child nodes for non-root nodes
> + * @b_private: pointer for extra data
>   */
>  struct nilfs_bmap {
>  	union {
> @@ -120,6 +122,7 @@ struct nilfs_bmap {
>  	int b_ptr_type;
>  	int b_state;
>  	__u16 b_nchildren_per_block;
> +	void *b_private;
>  };
>  
>  /* pointer type */
> @@ -157,8 +160,14 @@ int nilfs_bmap_insert(struct nilfs_bmap *, unsigned long, unsigned long);
>  int nilfs_bmap_delete(struct nilfs_bmap *, unsigned long);
>  int nilfs_bmap_last_key(struct nilfs_bmap *, unsigned long *);
>  int nilfs_bmap_truncate(struct nilfs_bmap *, unsigned long);
> +int nilfs_bmap_truncate_with_mc(struct nilfs_bmap *,
> +				struct nilfs_sufile_mod_cache *,
> +				unsigned long);
>  void nilfs_bmap_clear(struct nilfs_bmap *);
>  int nilfs_bmap_propagate(struct nilfs_bmap *, struct buffer_head *);
> +int nilfs_bmap_propagate_with_mc(struct nilfs_bmap *,
> +				 struct nilfs_sufile_mod_cache *,
> +				 struct buffer_head *);
>  void nilfs_bmap_lookup_dirty_buffers(struct nilfs_bmap *, struct list_head *);
>  int nilfs_bmap_assign(struct nilfs_bmap *, struct buffer_head **,
>  		      unsigned long, union nilfs_binfo *);
> @@ -222,7 +231,7 @@ static inline void nilfs_bmap_commit_end_ptr(struct nilfs_bmap *bmap,
>  					     struct inode *dat)
>  {
>  	if (dat)
> -		nilfs_dat_commit_end(dat, &req->bpr_req, NULL,
> +		nilfs_dat_commit_end(dat, &req->bpr_req, bmap->b_private,
>  				     bmap->b_ptr_type == NILFS_BMAP_PTR_VS,
>  				     bmap->b_inode->i_ino != NILFS_SUFILE_INO);
>  }
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index 2af0519..c3c883e 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -1851,7 +1851,7 @@ static void nilfs_btree_commit_update_v(struct nilfs_bmap *btree,
>  
>  	nilfs_dat_commit_update(dat, &path[level].bp_oldreq.bpr_req,
>  				&path[level].bp_newreq.bpr_req,
> -				NULL,
> +				btree->b_private,
>  				btree->b_ptr_type == NILFS_BMAP_PTR_VS,
>  				btree->b_inode->i_ino != NILFS_SUFILE_INO);
>  
> diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
> index e022cfb..a716bba 100644
> --- a/fs/nilfs2/direct.c
> +++ b/fs/nilfs2/direct.c
> @@ -272,7 +272,7 @@ static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
>  		if (ret < 0)
>  			return ret;
>  		nilfs_dat_commit_update(dat, &oldreq, &newreq,
> -				NULL,
> +				bmap->b_private,
>  				bmap->b_ptr_type == NILFS_BMAP_PTR_VS,
>  				bmap->b_inode->i_ino != NILFS_SUFILE_INO);
>  		set_buffer_nilfs_volatile(bh);
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 8b59695..7f6d056 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -34,6 +34,7 @@
>  #include "mdt.h"
>  #include "cpfile.h"
>  #include "ifile.h"
> +#include "sufile.h"
>  
>  /**
>   * struct nilfs_iget_args - arguments used during comparison between inodes
> @@ -714,29 +715,42 @@ void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh, int flags)
>  static void nilfs_truncate_bmap(struct nilfs_inode_info *ii,
>  				unsigned long from)
>  {
> +	struct the_nilfs *nilfs = ii->vfs_inode.i_sb->s_fs_info;
> +	struct nilfs_sufile_mod_cache mc, *mcp = NULL;
>  	unsigned long b;
>  	int ret;
>  
>  	if (!test_bit(NILFS_I_BMAP, &ii->i_state))
>  		return;
> +
> +	if (nilfs_feature_track_live_blks(nilfs) &&
> +	    !nilfs_sufile_mc_init(&mc, NILFS_SUFILE_MC_SIZE_DEFAULT))
> +		mcp = &mc;
> +
>  repeat:
>  	ret = nilfs_bmap_last_key(ii->i_bmap, &b);
>  	if (ret == -ENOENT)
> -		return;
> +		goto out_free;
>  	else if (ret < 0)
>  		goto failed;
>  
>  	if (b < from)
> -		return;
> +		goto out_free;
>  
>  	b -= min_t(unsigned long, NILFS_MAX_TRUNCATE_BLOCKS, b - from);
> -	ret = nilfs_bmap_truncate(ii->i_bmap, b);
> +	ret = nilfs_bmap_truncate_with_mc(ii->i_bmap, mcp, b);
>  	nilfs_relax_pressure_in_lock(ii->vfs_inode.i_sb);
>  	if (!ret || (ret == -ENOMEM &&
> -		     nilfs_bmap_truncate(ii->i_bmap, b) == 0))
> +		     nilfs_bmap_truncate_with_mc(ii->i_bmap, mcp, b) == 0))
>  		goto repeat;
>  
> +out_free:
> +	nilfs_sufile_flush_nlive_blks(nilfs->ns_sufile, mcp);
> +	nilfs_sufile_mc_destroy(mcp);
> +	return;
>  failed:
> +	nilfs_sufile_flush_nlive_blks(nilfs->ns_sufile, mcp);
> +	nilfs_sufile_mc_destroy(mcp);
>  	nilfs_warning(ii->vfs_inode.i_sb, __func__,
>  		      "failed to truncate bmap (ino=%lu, err=%d)",
>  		      ii->vfs_inode.i_ino, ret);
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 6059f53..dc0070c 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -511,7 +511,8 @@ static int nilfs_collect_file_data(struct nilfs_sc_info *sci,
>  {
>  	int err;
>  
> -	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
> +	err = nilfs_bmap_propagate_with_mc(NILFS_I(inode)->i_bmap,
> +					   sci->sc_mc, bh);
>  	if (err < 0)
>  		return err;
>  
> @@ -526,7 +527,8 @@ static int nilfs_collect_file_node(struct nilfs_sc_info *sci,
>  				   struct buffer_head *bh,
>  				   struct inode *inode)
>  {
> -	return nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
> +	return nilfs_bmap_propagate_with_mc(NILFS_I(inode)->i_bmap,
> +					    sci->sc_mc, bh);
>  }
>  
>  static int nilfs_collect_file_bmap(struct nilfs_sc_info *sci,
> @@ -1386,7 +1388,7 @@ static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
>  		segbuf->sb_nlive_blks_added = segbuf->sb_sum.nfileblk;
>  
>  		if (nilfs_feature_track_live_blks(nilfs))
> -			nilfs_sufile_mod_nlive_blks(sufile, NULL,
> +			nilfs_sufile_mod_nlive_blks(sufile, sci->sc_mc,
>  						segbuf->sb_segnum,
>  						segbuf->sb_nlive_blks_added);
>  	}
> @@ -2014,6 +2016,9 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
>  		}
>  		nilfs_segctor_update_segusage(sci, nilfs);
>  
> +		nilfs_sufile_flush_nlive_blks(nilfs->ns_sufile,
> +					      sci->sc_mc);
> +
>  		/* Write partial segments */
>  		nilfs_segctor_prepare_write(sci);
>  
> @@ -2603,6 +2608,7 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct super_block *sb,
>  {
>  	struct the_nilfs *nilfs = sb->s_fs_info;
>  	struct nilfs_sc_info *sci;
> +	int ret;
>  
>  	sci = kzalloc(sizeof(*sci), GFP_KERNEL);
>  	if (!sci)
> @@ -2633,6 +2639,18 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct super_block *sb,
>  		sci->sc_interval = HZ * nilfs->ns_interval;
>  	if (nilfs->ns_watermark)
>  		sci->sc_watermark = nilfs->ns_watermark;
> +
> +	if (nilfs_feature_track_live_blks(nilfs)) {
> +		sci->sc_mc = kmalloc(sizeof(*(sci->sc_mc)), GFP_KERNEL);
> +		if (sci->sc_mc) {
> +			ret = nilfs_sufile_mc_init(sci->sc_mc,
> +						   NILFS_SUFILE_MC_SIZE_EXT);
> +			if (ret) {
> +				kfree(sci->sc_mc);
> +				sci->sc_mc = NULL;
> +			}
> +		}
> +	}
>  	return sci;
>  }
>  
> @@ -2701,6 +2719,8 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
>  	down_write(&nilfs->ns_segctor_sem);
>  
>  	del_timer_sync(&sci->sc_timer);
> +	nilfs_sufile_mc_destroy(sci->sc_mc);
> +	kfree(sci->sc_mc);
>  	kfree(sci);
>  }
>  
> diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
> index a48d6de..a857527 100644
> --- a/fs/nilfs2/segment.h
> +++ b/fs/nilfs2/segment.h
> @@ -80,6 +80,7 @@ struct nilfs_cstage {
>  };
>  
>  struct nilfs_segment_buffer;
> +struct nilfs_sufile_mod_cache;
>  
>  struct nilfs_segsum_pointer {
>  	struct buffer_head     *bh;
> @@ -129,6 +130,7 @@ struct nilfs_segsum_pointer {
>   * @sc_watermark: Watermark for the number of dirty buffers
>   * @sc_timer: Timer for segctord
>   * @sc_task: current thread of segctord
> + * @sc_mc: mod cache to add up updates for SUFILE during seg construction
>   */
>  struct nilfs_sc_info {
>  	struct super_block     *sc_super;
> @@ -185,6 +187,7 @@ struct nilfs_sc_info {
>  
>  	struct timer_list	sc_timer;
>  	struct task_struct     *sc_task;
> +	struct nilfs_sufile_mod_cache *sc_mc;
>  };
>  
>  /* sc_flags */

Again, I really hope you eliminate this changes by hiding the cache in
sufile.

Regards,
Ryusuke Konishi

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
