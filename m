From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCHv3] nilfs2: issue discard request after cleaning segments
Date: Sat, 30 Jan 2010 19:10:25 +0900 (JST)
Message-ID: <20100130.191025.172547942.ryusuke@osrg.net>
References: <87fx5onrln.wl%jir@sekiba.com>
	<20100130.161157.55833148.ryusuke@osrg.net>
	<877hr07yhw.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <877hr07yhw.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 30 Jan 2010 18:06:35 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi, 
> 
> Konishi-san, thank you for the comment.
> 
> I revised the patch so as to remove the nilfs->ns_current reference.
> 
> I introduce new variable "ret" instead of reuseing "err" in nilfs_clean_segments
> so that error of discard request won't stop GC process.
> 
> 
> This adds a function to send discard requests for given array of
> segment numbers, and calls the function when garbage collection
> succeeded.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Applied, thank you.

Ryusuke Konishi

> ---
>  Documentation/filesystems/nilfs2.txt |    3 ++
>  fs/nilfs2/segment.c                  |   10 +++++++++
>  fs/nilfs2/super.c                    |    8 ++++++-
>  fs/nilfs2/the_nilfs.c                |   38 ++++++++++++++++++++++++++++++++++
>  fs/nilfs2/the_nilfs.h                |    1 +
>  include/linux/nilfs2_fs.h            |    1 +
>  6 files changed, 60 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
> index 839efd8..cf6d0d8 100644
> --- a/Documentation/filesystems/nilfs2.txt
> +++ b/Documentation/filesystems/nilfs2.txt
> @@ -74,6 +74,9 @@ norecovery		Disable recovery of the filesystem on mount.
>  			This disables every write access on the device for
>  			read-only mounts or snapshots.  This option will fail
>  			for r/w mounts on an unclean volume.
> +discard			Issue discard/TRIM commands to the underlying block
> +			device when blocks are freed.  This is useful for SSD
> +			devices and sparse/thinly-provisioned LUNs.
>  
>  NILFS2 usage
>  ============
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 17584c5..9eae057 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2560,6 +2560,16 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
>  		set_current_state(TASK_INTERRUPTIBLE);
>  		schedule_timeout(sci->sc_interval);
>  	}
> +	if (nilfs_test_opt(sbi, DISCARD)) {
> +		int ret = nilfs_discard_segments(nilfs, sci->sc_freesegs,
> +						 sci->sc_nfreesegs);
> +		if (ret) {
> +			printk(KERN_WARNING
> +			       "NILFS warning: error %d on discard request, "
> +			       "turning discards off for the device\n", ret);
> +			nilfs_clear_opt(sbi, DISCARD);
> +		}
> +	}
>  
>   out_unlock:
>  	sci->sc_freesegs = NULL;
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 8173fae..3f88401 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -481,6 +481,8 @@ static int nilfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  		seq_printf(seq, ",order=strict");
>  	if (nilfs_test_opt(sbi, NORECOVERY))
>  		seq_printf(seq, ",norecovery");
> +	if (nilfs_test_opt(sbi, DISCARD))
> +		seq_printf(seq, ",discard");
>  
>  	return 0;
>  }
> @@ -550,7 +552,7 @@ static const struct export_operations nilfs_export_ops = {
>  enum {
>  	Opt_err_cont, Opt_err_panic, Opt_err_ro,
>  	Opt_nobarrier, Opt_snapshot, Opt_order, Opt_norecovery,
> -	Opt_err,
> +	Opt_discard, Opt_err,
>  };
>  
>  static match_table_t tokens = {
> @@ -561,6 +563,7 @@ static match_table_t tokens = {
>  	{Opt_snapshot, "cp=%u"},
>  	{Opt_order, "order=%s"},
>  	{Opt_norecovery, "norecovery"},
> +	{Opt_discard, "discard"},
>  	{Opt_err, NULL}
>  };
>  
> @@ -614,6 +617,9 @@ static int parse_options(char *options, struct super_block *sb)
>  		case Opt_norecovery:
>  			nilfs_set_opt(sbi, NORECOVERY);
>  			break;
> +		case Opt_discard:
> +			nilfs_set_opt(sbi, DISCARD);
> +			break;
>  		default:
>  			printk(KERN_ERR
>  			       "NILFS: Unrecognized mount option \"%s\"\n", p);
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 6241e17..92733d5 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -646,6 +646,44 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
>  	goto out;
>  }
>  
> +int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
> +			    size_t nsegs)
> +{
> +	sector_t seg_start, seg_end;
> +	sector_t start = 0, nblocks = 0;
> +	unsigned int sects_per_block;
> +	__u64 *sn;
> +	int ret = 0;
> +
> +	sects_per_block = (1 << nilfs->ns_blocksize_bits) /
> +		bdev_logical_block_size(nilfs->ns_bdev);
> +	for (sn = segnump; sn < segnump + nsegs; sn++) {
> +		nilfs_get_segment_range(nilfs, *sn, &seg_start, &seg_end);
> +
> +		if (!nblocks) {
> +			start = seg_start;
> +			nblocks = seg_end - seg_start + 1;
> +		} else if (start + nblocks == seg_start) {
> +			nblocks += seg_end - seg_start + 1;
> +		} else {
> +			ret = blkdev_issue_discard(nilfs->ns_bdev,
> +						   start * sects_per_block,
> +						   nblocks * sects_per_block,
> +						   GFP_NOFS,
> +						   DISCARD_FL_BARRIER);
> +			if (ret < 0)
> +				return ret;
> +			nblocks = 0;
> +		}
> +	}
> +	if (nblocks)
> +		ret = blkdev_issue_discard(nilfs->ns_bdev,
> +					   start * sects_per_block,
> +					   nblocks * sects_per_block,
> +					   GFP_NOFS, DISCARD_FL_BARRIER);
> +	return ret;
> +}
> +
>  int nilfs_count_free_blocks(struct the_nilfs *nilfs, sector_t *nblocks)
>  {
>  	struct inode *dat = nilfs_dat_inode(nilfs);
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index 589786e..fd057f8 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -221,6 +221,7 @@ struct the_nilfs *find_or_create_nilfs(struct block_device *);
>  void put_nilfs(struct the_nilfs *);
>  int init_nilfs(struct the_nilfs *, struct nilfs_sb_info *, char *);
>  int load_nilfs(struct the_nilfs *, struct nilfs_sb_info *);
> +int nilfs_discard_segments(struct the_nilfs *, __u64 *, size_t);
>  int nilfs_count_free_blocks(struct the_nilfs *, sector_t *);
>  struct nilfs_sb_info *nilfs_find_sbinfo(struct the_nilfs *, int, __u64);
>  int nilfs_checkpoint_is_mounted(struct the_nilfs *, __u64, int);
> diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
> index 3fe02cf..640702e 100644
> --- a/include/linux/nilfs2_fs.h
> +++ b/include/linux/nilfs2_fs.h
> @@ -153,6 +153,7 @@ struct nilfs_super_root {
>  						   semantics also for data */
>  #define NILFS_MOUNT_NORECOVERY		0x4000  /* Disable write access during
>  						   mount-time recovery */
> +#define NILFS_MOUNT_DISCARD		0x8000  /* Issue DISCARD requests */
>  
>  
>  /**
> -- 
> 1.5.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
