From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 2/2] nilfs2: sync super blocks in turns
Date: Mon, 07 Jun 2010 15:15:32 +0900 (JST)
Message-ID: <20100607.151532.64702336.ryusuke@osrg.net>
References: <1275776349-22820-1-git-send-email-jir@unicus.jp>
	<1275776349-22820-3-git-send-email-jir@unicus.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1275776349-22820-3-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Sun,  6 Jun 2010 07:19:09 +0900, Jiro SEKIBA wrote:
> This will sync super blocks in turns instead of syncing duplicate
> super blocks at the time.  This will help searching valid super root when
> super block is written into disk before log is written, which is happen when
> barrier-less block devices are unmounted uncleanly.
> In the stiation, old super block likely points valid log.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Here is my comment on the second patch.

> ---
>  fs/nilfs2/nilfs.h   |    1 +
>  fs/nilfs2/segment.c |    8 +++++---
>  fs/nilfs2/super.c   |   44 +++++++++++++++++++++++++++++++++++++++-----
>  3 files changed, 45 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index c8edffd..b8fd4d1 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -271,6 +271,7 @@ nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
>  extern int nilfs_store_magic_and_option(struct super_block *,
>  					struct nilfs_super_block *, char *);
>  extern int nilfs_prepare_super(struct nilfs_sb_info *);
> +extern int nilfs_update_super(struct nilfs_sb_info *);
>  extern int nilfs_commit_super(struct nilfs_sb_info *, int);
>  extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
>  extern void nilfs_detach_checkpoint(struct nilfs_sb_info *);
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 72f779f..4801331 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2491,9 +2491,11 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
>  		    nilfs_discontinued(nilfs)) {
>  			down_write(&nilfs->ns_sem);
>  			err = nilfs_prepare_super(sbi);
> -			if (likely(!err))
> -				err = nilfs_commit_super(
> -					sbi, nilfs_altsb_need_update(nilfs));
> +			if (likely(!err)) {
> +				err = nilfs_update_super(sbi);
> +				if (likely(!err))
> +					err = nilfs_commit_super(sbi, 0);
> +			}
>  			up_write(&nilfs->ns_sem);
>  		}
>  	}

Please integrate these three functions into one.

You can write a superior function which calls nilfs_prepare_super(),
updates one of two cursors that point to the latest log, and then
calls nilfs_commit_super().

By doing so, this part can be simplifed as follows:

		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
		    nilfs_discontinued(nilfs))
			err = nilfs_write_log_cursor(nilfs);

> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 312b34a..9d0edfb 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -227,6 +227,8 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
>  		printk(KERN_ERR
>  		       "NILFS: unable to write superblock (err=%d)\n", err);
>  		if (err == -EIO && nilfs->ns_sbh[1]) {
> +			memcpy(nilfs->ns_sbp[1], nilfs->ns_sbp[0],
> +			       nilfs->ns_sbsize);
>  			nilfs_fall_back_super_block(nilfs);
>  			goto retry;
>  		}
> @@ -246,6 +248,13 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
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
> @@ -275,7 +284,7 @@ int nilfs_prepare_super(struct nilfs_sb_info *sbi)
>  	return 0;
>  }
>  
> -int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
> +int nilfs_update_super(struct nilfs_sb_info *sbi)
>  {
>  	struct the_nilfs *nilfs = sbi->s_nilfs;
>  	struct nilfs_super_block **sbp = nilfs->ns_sbp;
> @@ -303,9 +312,31 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
>  	sbp[0]->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
>  					     (unsigned char *)sbp[0],
>  					     nilfs->ns_sbsize));

The second half of nilfs_update_super() (the following part started
with '+' marks) should be moved to the head of nilfs_commit_super
since these lines are closing the changes for super block.

+       t = get_seconds();
+       nilfs->ns_sbwtime[0] = t;
-       sbp[0]->s_free_blocks_count = cpu_to_le64(nfreeblocks);
+       sbp[0]->s_wtime = cpu_to_le64(t);
+       sbp[0]->s_sum = 0;
+       sbp[0]->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
+                                            (unsigned char *)sbp[0],
+                                             nilfs->ns_sbsize));

> +	return 0;
> +}
> +
> +int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
> +{
> +	struct the_nilfs *nilfs = sbi->s_nilfs;
> +	struct nilfs_super_block **sbp = nilfs->ns_sbp;
> +
> +	/* nilfs->sem must be locked by the caller. */
>  	if (dupsb && sbp[1]) {
> -		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
> -		nilfs->ns_sbwtime[1] = t;
> +		nilfs->ns_sbwtime[1] = nilfs->ns_sbwtime[0];
> +		/* copy super block except s_last_cno, s_last_pseg,
> +		   s_last_seq, s_free_blocks_count.
> +		  Those are asymmetric members */
> +		const int ctimeoff =
> +			offsetof(struct nilfs_super_block, s_ctime);
> +		memcpy(sbp[1], sbp[0],
> +		       offsetof(struct nilfs_super_block, s_last_cno));
> +		memcpy((unsigned char *)sbp[1] + ctimeoff,
> +		       (unsigned char *)sbp[0] + ctimeoff,
> +		       nilfs->ns_sbsize - ctimeoff);

Umm, this looks bad.

So, we shouldn't hide update operations on the spare superblock...
I'll pull back my previous comment on nilfs_prepare_super.

We would be better off copying the updated field into its counterpart
within the callers of nilfs_commit_super().

	sbp[0]->s_state |= ...;
	if (sbp[1])
		sbp[1]->s_state = sbp[0]->s_state;

We can make a macro to do this in generic manner, but it seems to be
overkill for now.

> +		sbp[1]->s_sum = 0;
> +		sbp[1]->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
> +					    (unsigned char *)sbp[1],
> +					    nilfs->ns_sbsize));
>  	}
>  	clear_nilfs_sb_dirty(nilfs);
>  	return nilfs_sync_super(sbi, dupsb);
> @@ -352,8 +383,11 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
>  		err = nilfs_construct_segment(sb);
>  
>  	down_write(&nilfs->ns_sem);
> -	if (nilfs_sb_dirty(nilfs) && likely(!nilfs_prepare_super(sbi)))
> -		nilfs_commit_super(sbi, 1);
> +	if (nilfs_sb_dirty(nilfs) && likely(!nilfs_prepare_super(sbi))) {
> +		err = nilfs_update_super(sbi);
> +		if (likely(!err))
> +			nilfs_commit_super(sbi, 0);
> +	}
>  	up_write(&nilfs->ns_sem);
>  
>  	return err;
> -- 
> 1.5.6.5

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
