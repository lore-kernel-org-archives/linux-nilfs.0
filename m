From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 1/1] nilfs2: add mount option that reduces super
 block writes
Date: Tue, 11 Feb 2014 21:31:38 +0900 (JST)
Message-ID: <20140211.213138.107755196.konishi.ryusuke@lab.ntt.co.jp>
References: <cover.1391359219.git.andreas.rohner@gmx.net>
	<cover.1391359219.git.andreas.rohner@gmx.net>
	<dd489a00bca481cea1cb69e755ed5db5b186a5e5.1391359219.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dd489a00bca481cea1cb69e755ed5db5b186a5e5.1391359219.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,
On Sun,  2 Feb 2014 17:50:09 +0100, Andreas Rohner wrote:
> This patch introduces a mount option bad_ftl that disables the
> periodic overwrites of the super block to make the file system better
> suitable for bad flash memory with a bad FTL. The super block is only
> written at umount time. So if there is a unclean shutdown the file
> system needs to be recovered by a linear scan of all segment summary
> blocks.
> 
> The linear scan is only necessary if the file system wasn't umounted
> properly. So the normal mount time is not affected.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>


Do we really need to add the third crc in segument summary headers ?
After all, we need to do a full check for a log with a super root
block to validate it.

This patch also seems to be using the nature that headers which have a
NILFS_SS_SR flag sometimes appear at the head of segments.  But this
is not guranteed.  Is this condition eliminable?

The measurement results are very interesting (thanks for the effort),
but they look to rely on a few these ellipsis techniques for reducing
recovery time.

Regards,
Ryusuke Konishi


> ---
>  fs/nilfs2/recovery.c      | 248 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/segbuf.c        |  16 ++-
>  fs/nilfs2/segment.c       |   3 +-
>  fs/nilfs2/segment.h       |   1 +
>  fs/nilfs2/super.c         |  10 +-
>  fs/nilfs2/the_nilfs.c     |   3 +
>  include/linux/nilfs2_fs.h |   6 +-
>  7 files changed, 281 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
> index ff00a0b..7f9dd39 100644
> --- a/fs/nilfs2/recovery.c
> +++ b/fs/nilfs2/recovery.c
> @@ -55,6 +55,13 @@ struct nilfs_recovery_block {
>  	struct list_head list;
>  };
>  
> +/* work structure log cursor search */
> +struct nilfs_seg_history {
> +	u64 seq;
> +	sector_t seg_start;
> +};
> +
> +#define NILFS_SEG_HISTORY_DEPTH		3
>  
>  static int nilfs_warn_segment_error(int err)
>  {
> @@ -792,6 +799,247 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
>  	return err;
>  }
>  
> +static inline int nilfs_validate_segment_summary_fast(struct the_nilfs *nilfs,
> +		struct nilfs_segment_summary *sum)
> +{
> +	u32 crc;
> +	int crc_size = sizeof(struct nilfs_segment_summary) -
> +			(sizeof(sum->ss_datasum) +
> +			sizeof(sum->ss_sumsum) +
> +			sizeof(sum->ss_sumsum_fast) +
> +			sizeof(sum->ss_cno));
> +
> +	if (le32_to_cpu(sum->ss_magic) != NILFS_SEGSUM_MAGIC
> +		|| le32_to_cpu(sum->ss_nblocks) == 0
> +		|| le32_to_cpu(sum->ss_nblocks) >
> +			nilfs->ns_blocks_per_segment)
> +		return -1;
> +
> +	crc = crc32_le(nilfs->ns_crc_seed,
> +		       (unsigned char *)sum + sizeof(sum->ss_datasum) +
> +		       sizeof(sum->ss_sumsum), crc_size);
> +
> +	if (le32_to_cpu(sum->ss_sumsum_fast) != crc)
> +		return -1;
> +
> +	return 0;
> +}
> 
> +static inline void nilfs_add_segment_history(struct nilfs_seg_history *history,
> +		int hist_len, u64 seq, sector_t seg_start)
> +{
> +	int i, j;
> +
> +	for (i = 0; i < hist_len; ++i) {
> +		if (seq > history[i].seq) {
> +			for (j = hist_len - 1; j > i; --j)
> +				history[j] = history[j - 1];
> +
> +			history[i].seq = seq;
> +			history[i].seg_start = seg_start;
> +			break;
> +		}
> +	}
> +}
> +
> +static inline void nilfs_init_segment_history(struct nilfs_seg_history *history,
> +		int hist_len, u64 seq, sector_t seg_start)
> +{
> +	int i;
> +
> +	for (i = 0; i < hist_len; ++i) {
> +		history[i].seq = seq;
> +		history[i].seg_start = seg_start;
> +	}
> +}
> +
> +static int nilfs_search_partial_log_cursor(struct the_nilfs *nilfs,
> +		u64 seq, sector_t pseg_start, sector_t *dest)
> +{
> +	struct buffer_head *bh_sum = NULL;
> +	struct nilfs_segment_summary *sum;
> +	sector_t seg_start, seg_end;
> +	int ret = -1;
> +
> +	nilfs_get_segment_range(nilfs,
> +			nilfs_get_segnum_of_block(nilfs, pseg_start),
> +			&seg_start, &seg_end);
> +
> +	while (pseg_start < seg_end && pseg_start >= seg_start) {
> +		brelse(bh_sum);
> +
> +		bh_sum = nilfs_read_log_header(nilfs, pseg_start, &sum);
> +		if (!bh_sum)
> +			return -EIO;
> +
> +		if (nilfs_validate_segment_summary_fast(nilfs, sum))
> +			goto out;
> +
> +		if (le64_to_cpu(sum->ss_seq) != seq)
> +			goto out;
> +
> +		if (le16_to_cpu(sum->ss_flags) & NILFS_SS_SR) {
> +			*dest = pseg_start;
> +			ret = 0;
> +			goto out;
> +		}
> +
> +		pseg_start += le32_to_cpu(sum->ss_nblocks);
> +	}
> +
> +out:
> +	brelse(bh_sum);
> +	return ret;
> +}
> +
> +static int nilfs_search_validate_log_cursor(struct the_nilfs *nilfs,
> +		sector_t seg_start, u64 seq)
> +{
> +	struct buffer_head *bh_sum;
> +	struct nilfs_segment_summary *sum;
> +	sector_t b;
> +	int ret;
> +
> +	bh_sum = nilfs_read_log_header(nilfs, seg_start, &sum);
> +	if (!bh_sum) {
> +		printk(KERN_ERR "NILFS error searching for cursor.\n");
> +		return -EIO;
> +	}
> +
> +	b = seg_start;
> +	while (b < seg_start + le32_to_cpu(sum->ss_nblocks))
> +		__breadahead(nilfs->ns_bdev, b++, nilfs->ns_blocksize);
> +
> +	ret = nilfs_validate_log(nilfs, seq, bh_sum, sum);
> +	if (ret) {
> +		ret = -1;
> +	} else {
> +		/* update nilfs log cursor */
> +		nilfs->ns_last_pseg = seg_start;
> +		nilfs->ns_last_cno = le64_to_cpu(sum->ss_cno);
> +		nilfs->ns_last_seq = seq;
> +
> +		nilfs->ns_prev_seq = nilfs->ns_last_seq;
> +		nilfs->ns_seg_seq = nilfs->ns_last_seq;
> +		nilfs->ns_segnum =
> +			nilfs_get_segnum_of_block(nilfs, nilfs->ns_last_pseg);
> +		nilfs->ns_cno = nilfs->ns_last_cno + 1;
> +	}
> +
> +	brelse(bh_sum);
> +	return ret;
> +}
> +
> +/**
> + * nilfs_search_log_cursor - search the latest log cursor
> + * @nilfs: the_nilfs
> + *
> + * Description: nilfs_search_log_cursor() performs a linear scan of all full
> + * segment summary blocks and updates the cursor of the nilfs object if a more
> + * recent segment is found. The cursor is only updated if the segment is valid
> + * and there is a super root present. The goal is to quickly find the latest
> + * segment and leave the rest of the heavy lifting to the normal recovery
> + * process.
> + *
> + * Return Value: On success, 0 is returned.  On error, one of the following
> + * negative error code is returned.
> + *
> + * %-EIO - I/O error
> + */
> +int nilfs_search_log_cursor(struct the_nilfs *nilfs)
> +{
> +	u64 seq, segnum, segahead, nsegments = nilfs->ns_nsegments;
> +	struct buffer_head *bh_sum = NULL;
> +	struct nilfs_segment_summary *sum;
> +	struct nilfs_seg_history history[NILFS_SEG_HISTORY_DEPTH];
> +	struct nilfs_seg_history history_sr[NILFS_SEG_HISTORY_DEPTH];
> +	sector_t seg_start = 0, seg_end;
> +	int i;
> +
> +	printk(KERN_WARNING "NILFS warning: searching for latest log\n");
> +
> +	for (segahead = 0; segahead < 64 && segahead < nsegments; ++segahead) {
> +		nilfs_get_segment_range(nilfs, segahead, &seg_start, &seg_end);
> +		__breadahead(nilfs->ns_bdev, seg_start, nilfs->ns_blocksize);
> +	}
> +
> +	nilfs_init_segment_history(history, NILFS_SEG_HISTORY_DEPTH,
> +			nilfs->ns_last_seq, 0);
> +	nilfs_init_segment_history(history_sr, NILFS_SEG_HISTORY_DEPTH,
> +			nilfs->ns_last_seq, 0);
> +
> +	for (segnum = 0; segnum < nsegments; ++segnum, ++segahead) {
> +		brelse(bh_sum);
> +
> +		if (segahead < nsegments) {
> +			nilfs_get_segment_range(nilfs, segahead,
> +					&seg_start, &seg_end);
> +			__breadahead(nilfs->ns_bdev, seg_start,
> +					nilfs->ns_blocksize);
> +		}
> +
> +		nilfs_get_segment_range(nilfs, segnum, &seg_start, &seg_end);
> +
> +		bh_sum = nilfs_read_log_header(nilfs, seg_start, &sum);
> +		if (!bh_sum) {
> +			printk(KERN_ERR "NILFS error searching for cursor.\n");
> +			return -EIO;
> +		}
> +
> +		if (nilfs_validate_segment_summary_fast(nilfs, sum))
> +			continue;
> +
> +		seq = le64_to_cpu(sum->ss_seq);
> +
> +		nilfs_add_segment_history(history, NILFS_SEG_HISTORY_DEPTH,
> +				seq, seg_start);
> +
> +		if (!(le16_to_cpu(sum->ss_flags) & NILFS_SS_SR))
> +			continue;
> +
> +		nilfs_add_segment_history(history_sr, NILFS_SEG_HISTORY_DEPTH,
> +				seq, seg_start);
> +	}
> +	brelse(bh_sum);
> +
> +	/*
> +	 * if last super root is too far off try to find
> +	 * next super root in partial segment
> +	 */
> +	if (history_sr[0].seq + NILFS_SEG_HISTORY_DEPTH < history[0].seq) {
> +		for (i = 0; i < NILFS_SEG_HISTORY_DEPTH; ++i) {
> +			if (history[i].seg_start == 0 ||
> +				history[i].seq <= nilfs->ns_last_seq)
> +				break;
> +
> +			if (nilfs_search_partial_log_cursor(nilfs,
> +					history[i].seq, history[i].seg_start,
> +					&seg_start) == 0) {
> +				nilfs_add_segment_history(history_sr,
> +						NILFS_SEG_HISTORY_DEPTH,
> +						history[i].seq, seg_start);
> +				break;
> +			}
> +		}
> +	}
> +
> +	/*
> +	 * try to validate one of the super root segments previously
> +	 * collected
> +	 */
> +	for (i = 0; i < NILFS_SEG_HISTORY_DEPTH; ++i) {
> +		if (history_sr[i].seg_start == 0 ||
> +			history_sr[i].seq <= nilfs->ns_last_seq)
> +			break;
> +
> +		if (nilfs_search_validate_log_cursor(nilfs,
> +			history_sr[i].seg_start, history_sr[i].seq) == 0)
> +			return 0;
> +	}
> +
> +	return -1;
> +}
> +
>  /**
>   * nilfs_search_super_root - search the latest valid super root
>   * @nilfs: the_nilfs
> diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> index dc3a9efd..692bf26 100644
> --- a/fs/nilfs2/segbuf.c
> +++ b/fs/nilfs2/segbuf.c
> @@ -158,6 +158,9 @@ void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *segbuf)
>  {
>  	struct nilfs_segment_summary *raw_sum;
>  	struct buffer_head *bh_sum;
> +	struct the_nilfs *nilfs = segbuf->sb_super->s_fs_info;
> +	u32 crc;
> +	int size;
>  
>  	bh_sum = list_entry(segbuf->sb_segsum_buffers.next,
>  			    struct buffer_head, b_assoc_buffers);
> @@ -172,8 +175,19 @@ void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *segbuf)
>  	raw_sum->ss_nblocks  = cpu_to_le32(segbuf->sb_sum.nblocks);
>  	raw_sum->ss_nfinfo   = cpu_to_le32(segbuf->sb_sum.nfinfo);
>  	raw_sum->ss_sumbytes = cpu_to_le32(segbuf->sb_sum.sumbytes);
> -	raw_sum->ss_pad      = 0;
>  	raw_sum->ss_cno      = cpu_to_le64(segbuf->sb_sum.cno);
> +
> +	size = sizeof(struct nilfs_segment_summary) -
> +		(sizeof(raw_sum->ss_datasum) +
> +		sizeof(raw_sum->ss_sumsum) +
> +		sizeof(raw_sum->ss_sumsum_fast) +
> +		sizeof(raw_sum->ss_cno));
> +
> +	crc = crc32_le(nilfs->ns_crc_seed,
> +		       (unsigned char *)raw_sum + sizeof(raw_sum->ss_datasum) +
> +		       sizeof(raw_sum->ss_sumsum), size);
> +
> +	raw_sum->ss_sumsum_fast = cpu_to_le32(crc);
>  }
>  
>  /*
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index a1a1916..e8e38a9 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2288,7 +2288,8 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
>  		if (mode != SC_FLUSH_DAT)
>  			atomic_set(&nilfs->ns_ndirtyblks, 0);
>  		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
> -		    nilfs_discontinued(nilfs)) {
> +		    nilfs_discontinued(nilfs) &&
> +		    !nilfs_test_opt(nilfs, BAD_FTL)) {
>  			down_write(&nilfs->ns_sem);
>  			err = -EIO;
>  			sbp = nilfs_prepare_super(sci->sc_super,
> diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
> index 38a1d00..ceb0ea4 100644
> --- a/fs/nilfs2/segment.h
> +++ b/fs/nilfs2/segment.h
> @@ -237,6 +237,7 @@ void nilfs_detach_log_writer(struct super_block *sb);
>  /* recovery.c */
>  extern int nilfs_read_super_root_block(struct the_nilfs *, sector_t,
>  				       struct buffer_head **, int);
> +extern int nilfs_search_log_cursor(struct the_nilfs *nilfs);
>  extern int nilfs_search_super_root(struct the_nilfs *,
>  				   struct nilfs_recovery_info *);
>  int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs, struct super_block *sb,
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 7ac2a12..c3374ed 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -505,7 +505,7 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
>  		err = nilfs_construct_segment(sb);
>  
>  	down_write(&nilfs->ns_sem);
> -	if (nilfs_sb_dirty(nilfs)) {
> +	if (nilfs_sb_dirty(nilfs) && !nilfs_test_opt(nilfs, BAD_FTL)) {
>  		sbp = nilfs_prepare_super(sb, nilfs_sb_will_flip(nilfs));
>  		if (likely(sbp)) {
>  			nilfs_set_log_cursor(sbp[0], nilfs);
> @@ -691,6 +691,8 @@ static int nilfs_show_options(struct seq_file *seq, struct dentry *dentry)
>  		seq_puts(seq, ",norecovery");
>  	if (nilfs_test_opt(nilfs, DISCARD))
>  		seq_puts(seq, ",discard");
> +	if (nilfs_test_opt(nilfs, BAD_FTL))
> +		seq_puts(seq, ",bad_ftl");
>  
>  	return 0;
>  }
> @@ -712,7 +714,7 @@ static const struct super_operations nilfs_sops = {
>  enum {
>  	Opt_err_cont, Opt_err_panic, Opt_err_ro,
>  	Opt_barrier, Opt_nobarrier, Opt_snapshot, Opt_order, Opt_norecovery,
> -	Opt_discard, Opt_nodiscard, Opt_err,
> +	Opt_discard, Opt_nodiscard, Opt_err, Opt_bad_ftl,
>  };
>  
>  static match_table_t tokens = {
> @@ -726,6 +728,7 @@ static match_table_t tokens = {
>  	{Opt_norecovery, "norecovery"},
>  	{Opt_discard, "discard"},
>  	{Opt_nodiscard, "nodiscard"},
> +	{Opt_bad_ftl, "bad_ftl"},
>  	{Opt_err, NULL}
>  };
>  
> @@ -787,6 +790,9 @@ static int parse_options(char *options, struct super_block *sb, int is_remount)
>  		case Opt_nodiscard:
>  			nilfs_clear_opt(nilfs, DISCARD);
>  			break;
> +		case Opt_bad_ftl:
> +			nilfs_set_opt(nilfs, BAD_FTL);
> +			break;
>  		default:
>  			printk(KERN_ERR
>  			       "NILFS: Unrecognized mount option \"%s\"\n", p);
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 94c451c..a44bf40 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -217,6 +217,9 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
>  	int err;
>  
>  	if (!valid_fs) {
> +		if (nilfs_test_opt(nilfs, BAD_FTL))
> +			nilfs_search_log_cursor(nilfs);
> +
>  		printk(KERN_WARNING "NILFS warning: mounting unchecked fs\n");
>  		if (s_flags & MS_RDONLY) {
>  			printk(KERN_INFO "NILFS: INFO: recovery "
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 9875576..03424d4 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -135,6 +135,8 @@ struct nilfs_super_root {
>  #define NILFS_MOUNT_NORECOVERY		0x4000  /* Disable write access during
>  						   mount-time recovery */
>  #define NILFS_MOUNT_DISCARD		0x8000  /* Issue DISCARD requests */
> +#define NILFS_MOUNT_BAD_FTL		0x10000 /* Only write super block
> +						   at umount time */
>  
>  
>  /**
> @@ -407,7 +409,7 @@ union nilfs_binfo {
>   * @ss_nblocks: number of blocks
>   * @ss_nfinfo: number of finfo structures
>   * @ss_sumbytes: total size of segment summary in bytes
> - * @ss_pad: padding
> + * @ss_sumsum_fast: small sum of only the nilfs_segment_summary
>   * @ss_cno: checkpoint number
>   */
>  struct nilfs_segment_summary {
> @@ -422,7 +424,7 @@ struct nilfs_segment_summary {
>  	__le32 ss_nblocks;
>  	__le32 ss_nfinfo;
>  	__le32 ss_sumbytes;
> -	__le32 ss_pad;
> +	__le32 ss_sumsum_fast;
>  	__le64 ss_cno;
>  	/* array of finfo structures */
>  };
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
