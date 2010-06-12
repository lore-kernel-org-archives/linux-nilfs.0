From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 2/2] nilfs2: sync super blocks in turns
Date: Sun, 13 Jun 2010 04:06:10 +0900 (JST)
Message-ID: <20100613.040610.143057289.ryusuke@osrg.net>
References: <1276266639-15913-1-git-send-email-jir@unicus.jp>
	<1276266639-15913-3-git-send-email-jir@unicus.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1276266639-15913-3-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Fri, 11 Jun 2010 23:30:39 +0900, Jiro SEKIBA wrote:
> This will sync super blocks in turns instead of syncing duplicate
> super blocks at the time.  This will help searching valid super root when
> super block is written into disk before log is written, which is happen when
> barrier-less block devices are unmounted uncleanly.
> In the stiation, old super block likely points valid log.
> 
> This patch introduces nilfs_write_log_cursor to advance log cursor
> one of super blocks.  To update super block information other than
> log cursor, caller of nilfs_commit_super must set the information on both
> super blocks.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> ---
>  fs/nilfs2/nilfs.h     |    5 ++
>  fs/nilfs2/segment.c   |   11 +----
>  fs/nilfs2/super.c     |  104 +++++++++++++++++++++++++++++++-----------------
>  fs/nilfs2/the_nilfs.c |    4 +-
>  fs/nilfs2/the_nilfs.h |   24 +++++++----
>  5 files changed, 92 insertions(+), 56 deletions(-)
> 
> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index 9805d35..9867320 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -259,6 +259,10 @@ extern void nilfs_dirty_inode(struct inode *);
>  extern struct dentry *nilfs_get_parent(struct dentry *);
>  
>  /* super.c */
> +enum {
> +	NILFS_SB_COMMIT = 0,
> +	NILFS_SB_COMMIT_ALL
> +};

This definition should be explained with some comments.

At least you should describe the target and meaning of each value
like:

  /*
   * Write mode of super blocks
   */
  enum {
  	NILFS_SB_COMMIT = 0,	/* Commit a super block alternately */
  	NILFS_SB_COMMIT_ALL	/* Commit both super blocks */
  };

And, this definition should be put earlier.

>  extern struct inode *nilfs_alloc_inode_common(struct the_nilfs *);
>  extern struct inode *nilfs_alloc_inode(struct super_block *);
>  extern void nilfs_destroy_inode(struct inode *);
> @@ -270,6 +274,7 @@ extern struct nilfs_super_block *
>  nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
>  extern int nilfs_store_magic_and_option(struct super_block *,
>  					struct nilfs_super_block *, char *);
> +extern int nilfs_write_log_cursor(struct nilfs_sb_info *);
>  extern struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *);
>  extern int nilfs_commit_super(struct nilfs_sb_info *, int);
>  extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index f67ffbb..e5a53fe 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2421,15 +2421,8 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
>  		if (mode != SC_FLUSH_DAT)
>  			atomic_set(&nilfs->ns_ndirtyblks, 0);
>  		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
> -		    nilfs_discontinued(nilfs)) {
> -			down_write(&nilfs->ns_sem);
> -			if (likely(nilfs_prepare_super(sbi)))
> -				err = nilfs_commit_super(
> -					sbi, nilfs_altsb_need_update(nilfs));
> -			else
> -				err = -EIO;
> -			up_write(&nilfs->ns_sem);
> -		}
> +		    nilfs_discontinued(nilfs))
> +			err = nilfs_write_log_cursor(sbi);
>  	}
>  
>  	nilfs_segctor_notify(sci, mode, err);
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index b978d6c..8872112 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -107,8 +107,9 @@ void nilfs_error(struct super_block *sb, const char *function,
>  			nilfs->ns_mount_state |= NILFS_ERROR_FS;
>  			sbp = nilfs_prepare_super(sbi);
>  			if (likely(sbp)) {
> -				sbp[0]->s_state |= cpu_to_le16(NILFS_ERROR_FS);
> -				nilfs_commit_super(sbi, 1);
> +				nilfs_sb_set_state(sbp,
> +				sbp[0]->s_state | cpu_to_le16(NILFS_ERROR_FS));
> +				nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
>  			}
>  		}
>  		up_write(&nilfs->ns_sem);
> @@ -179,7 +180,7 @@ static void nilfs_clear_inode(struct inode *inode)
>  	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
>  }
>  
> -static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
> +static int nilfs_sync_super(struct nilfs_sb_info *sbi, int flag)
>  {
>  	struct the_nilfs *nilfs = sbi->s_nilfs;
>  	int err;
> @@ -205,6 +206,8 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
>  		printk(KERN_ERR
>  		       "NILFS: unable to write superblock (err=%d)\n", err);
>  		if (err == -EIO && nilfs->ns_sbh[1]) {
> +			memcpy(nilfs->ns_sbp[1], nilfs->ns_sbp[0],
> +			       nilfs->ns_sbsize);
>  			nilfs_fall_back_super_block(nilfs);
>  			goto retry;
>  		}
> @@ -220,10 +223,17 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
>  		/* update GC protection for recent segments */
>  		if (nilfs->ns_sbh[1]) {
>  			sbp = NULL;
> -			if (dupsb) {
> +			if (flag == NILFS_SB_COMMIT_ALL) {
>  				set_buffer_dirty(nilfs->ns_sbh[1]);
>  				if (!sync_dirty_buffer(nilfs->ns_sbh[1]))
>  					sbp = nilfs->ns_sbp[1];
> +			} else {
> +				int flip_bits = (nilfs->ns_cno & 0x0FL);
> +				/* flip super block 9 to 7 ratio */
> +				if (flip_bits == 0x08 || flip_bits == 0x0F) {
> +					nilfs_swap_super_block(nilfs);
> +					sbp = nilfs->ns_sbp[1];
> +				}
>  			}
>  		}
>  		if (sbp) {
> @@ -254,19 +264,49 @@ struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *sbi)
>  	return sbp;
>  }
>  
> -int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
> +int nilfs_commit_super(struct nilfs_sb_info *sbi, int flag)
>  {
>  	struct the_nilfs *nilfs = sbi->s_nilfs;
>  	struct nilfs_super_block **sbp = nilfs->ns_sbp;
> -	sector_t nfreeblocks;
>  	time_t t;
> +
> +	t = get_seconds();
> +	nilfs->ns_sbwtime[0] = t;
> +	sbp[0]->s_wtime = cpu_to_le64(t);
> +	sbp[0]->s_sum = 0;
> +	sbp[0]->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
> +					     (unsigned char *)sbp[0],
> +					     nilfs->ns_sbsize));
> +	if (flag == NILFS_SB_COMMIT_ALL && sbp[1]) {
> +		nilfs->ns_sbwtime[1] = t;
> +		sbp[1]->s_wtime = sbp[0]->s_wtime;
> +		sbp[1]->s_sum = 0;
> +		sbp[1]->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
> +					     (unsigned char *)sbp[1],
> +					     nilfs->ns_sbsize));
> +	}
> +	clear_nilfs_sb_dirty(nilfs);
> +	return nilfs_sync_super(sbi, flag);
> +}
> +
> +int nilfs_write_log_cursor(struct nilfs_sb_info *sbi)
> +{
> +	struct the_nilfs *nilfs = sbi->s_nilfs;
> +	struct nilfs_super_block **sbp;
> +	sector_t nfreeblocks;
>  	int err;
>  
> -	/* nilfs->ns_sem must be locked by the caller. */
> +	down_write(&nilfs->ns_sem);
> +	sbp = nilfs_prepare_super(sbi);
> +	if (unlikely(!sbp))  {
> +		err = -EIO;
> +		goto out;
> +	}
> +
>  	err = nilfs_count_free_blocks(nilfs, &nfreeblocks);
>  	if (unlikely(err)) {
>  		printk(KERN_ERR "NILFS: failed to count free blocks\n");
> -		return err;
> +		goto out;
>  	}
>  	spin_lock(&nilfs->ns_last_segment_lock);
>  	sbp[0]->s_last_seq = cpu_to_le64(nilfs->ns_last_seq);
> @@ -274,20 +314,12 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
>  	sbp[0]->s_last_cno = cpu_to_le64(nilfs->ns_last_cno);
>  	spin_unlock(&nilfs->ns_last_segment_lock);
>  
> -	t = get_seconds();
> -	nilfs->ns_sbwtime[0] = t;
>  	sbp[0]->s_free_blocks_count = cpu_to_le64(nfreeblocks);
> -	sbp[0]->s_wtime = cpu_to_le64(t);
> -	sbp[0]->s_sum = 0;
> -	sbp[0]->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
> -					     (unsigned char *)sbp[0],
> -					     nilfs->ns_sbsize));
> -	if (dupsb && sbp[1]) {
> -		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
> -		nilfs->ns_sbwtime[1] = t;
> -	}
> -	clear_nilfs_sb_dirty(nilfs);
> -	return nilfs_sync_super(sbi, dupsb);
> +
> +	err = nilfs_commit_super(sbi, NILFS_SB_COMMIT);
> +out:
> +	up_write(&nilfs->ns_sem);
> +	return err;
>  }
>  
>  static void nilfs_put_super(struct super_block *sb)
> @@ -304,8 +336,9 @@ static void nilfs_put_super(struct super_block *sb)
>  		down_write(&nilfs->ns_sem);
>  		sbp = nilfs_prepare_super(sbi);
>  		if (likely(sbp)) {
> -			sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
> -			nilfs_commit_super(sbi, 1);
> +			nilfs_sb_set_state(sbp,
> +				cpu_to_le16(nilfs->ns_mount_state));
> +			nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
>  		}
>  		up_write(&nilfs->ns_sem);
>  	}

This looks to have a problem.  Note that this will restore VALID_FS
flag for both super blocks.

If the master super block which indicates a newer log is destroyed,
nilfs skips roll-forward from an old log because the secondary super
block also has the VALID_FS flag. (See nilfs_search_super_root)


> @@ -333,11 +366,8 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
>  	if (wait)
>  		err = nilfs_construct_segment(sb);
>  
> -	down_write(&nilfs->ns_sem);
> -	if (nilfs_sb_dirty(nilfs) && likely(nilfs_prepare_super(sbi)))
> -		nilfs_commit_super(sbi, 1);
> -	up_write(&nilfs->ns_sem);
> -
> +	if (nilfs_sb_dirty(nilfs))
> +		nilfs_write_log_cursor(sbi);
>  	return err;
>  }
>  
> @@ -652,14 +682,14 @@ static int nilfs_setup_super(struct nilfs_sb_info *sbi)
>  #endif
>  	}
>  	if (!max_mnt_count)
> -		sbp[0]->s_max_mnt_count = cpu_to_le16(NILFS_DFL_MAX_MNT_COUNT);
> -
> -	sbp[0]->s_mnt_count = cpu_to_le16(mnt_count + 1);
> -	sbp[0]->s_state =
> -		cpu_to_le16(le16_to_cpu(sbp[0]->s_state) & ~NILFS_VALID_FS);
> -
> -	sbp[0]->s_mtime = cpu_to_le64(get_seconds());
> -	return nilfs_commit_super(sbi, 1);
> +		nilfs_sb_set_max_mnt_count(sbp,
> +				cpu_to_le16(NILFS_DFL_MAX_MNT_COUNT));
> +
> +	nilfs_sb_set_mnt_count(sbp, cpu_to_le16(mnt_count + 1));
> +	nilfs_sb_set_state(sbp,
> +		cpu_to_le16(le16_to_cpu(sbp[0]->s_state) & ~NILFS_VALID_FS));
> +	nilfs_sb_set_mtime(sbp, cpu_to_le64(get_seconds()));
> +	return nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
>  }
>  
>  struct nilfs_super_block *nilfs_read_super_block(struct super_block *sb,
> @@ -913,7 +943,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
>  				sbp[0]->s_state =
>  				    cpu_to_le16(nilfs->ns_mount_state);
>  			sbp[0]->s_mtime = cpu_to_le64(get_seconds());
> -			nilfs_commit_super(sbi, 1);
> +			nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
>  		}
>  		up_write(&nilfs->ns_sem);
>  	} else {
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index e8f2f1f..95533d9 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -329,8 +329,8 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
>  	sbp = nilfs_prepare_super(sbi);
>  	if (likely(sbp)) {
>  		nilfs->ns_mount_state |= NILFS_VALID_FS;
> -		sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
> -		err = nilfs_commit_super(sbi, 1);
> +		nilfs_sb_set_state(sbp, cpu_to_le16(nilfs->ns_mount_state));
> +		err = nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
>  	} else
>  		err = -EIO;
>  	up_write(&nilfs->ns_sem);
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index 1ab9745..38ecb2d 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -201,9 +201,24 @@ THE_NILFS_FNS(DISCONTINUED, discontinued)
>  THE_NILFS_FNS(GC_RUNNING, gc_running)
>  THE_NILFS_FNS(SB_DIRTY, sb_dirty)
>  
> +#define NILFS_SB_SET_FN(name, type)				\
> +static inline void nilfs_sb_set_##name(			\
> +			struct nilfs_super_block **sbp,		\
> +			type val)				\
> +{								\
> +	sbp[0]->s_##name = val;					\
> +	if (sbp[1] &&						\
> +	    sbp[1]->s_magic == cpu_to_le16(NILFS_SUPER_MAGIC))	\
> +		sbp[1]->s_##name = val;				\
> +}

This check looks overkill.

I think nilfs_prepare_super() should handle abnormal cases and try
recovery if one of two super blocks is invalid.

Without the change, this patch seems to break automatic repair feature
of super blocks.  Please think how a broken super block is repaired
with another one.

> +NILFS_SB_SET_FN(state, __le16)
> +NILFS_SB_SET_FN(mnt_count, __le16)
> +NILFS_SB_SET_FN(max_mnt_count, __le16)
> +NILFS_SB_SET_FN(mtime, __le64)
> +
>  /* Minimum interval of periodical update of superblocks (in seconds) */
>  #define NILFS_SB_FREQ		10
> -#define NILFS_ALTSB_FREQ	60  /* spare superblock */
>  
>  static inline int nilfs_sb_need_update(struct the_nilfs *nilfs)
>  {
> @@ -212,13 +227,6 @@ static inline int nilfs_sb_need_update(struct the_nilfs *nilfs)
>  		 t > nilfs->ns_sbwtime[0] + NILFS_SB_FREQ;
>  }
>  
> -static inline int nilfs_altsb_need_update(struct the_nilfs *nilfs)
> -{
> -	u64 t = get_seconds();
> -	struct nilfs_super_block **sbp = nilfs->ns_sbp;
> -	return sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
> -}
> -
>  void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
>  struct the_nilfs *find_or_create_nilfs(struct block_device *);
>  void put_nilfs(struct the_nilfs *);
> -- 
> 1.5.6.5

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
