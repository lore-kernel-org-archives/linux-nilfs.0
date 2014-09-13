From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v6 1/1] nilfs2: add missing blkdev_issue_flush() to
 nilfs_sync_fs()
Date: Sun, 14 Sep 2014 02:06:09 +0900 (JST)
Message-ID: <20140914.020609.1854857348878379764.konishi.ryusuke@lab.ntt.co.jp>
References: <1410619073-26360-1-git-send-email-andreas.rohner@gmx.net>
	<1410619073-26360-2-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=D4Y0Ys339BWpj2KPRoI5pFQaDY5MfVcekbJQM/8pLOU=;
        b=NJb8Z97KgLAPYfP96tsUJD6sS85lWVfG78qPajTIl7WeAHPvl72nE71v48jKOp5EWo
         M/rJb4s9zQ6MWOBswFHEySth4vFywZxkGzqy0WbysV8hNG4V+aNaXc3SEmy2rddk54tB
         9RagjQqqivT3mjLxewEiBbZTP9m1iOJtLxwVG7WupMwmueAZs0FBee0HTzE0v6wTtXsA
         3maTt9cQfJj5nNXXst0Y+OsGclnIUu2cm/DtP/3UFP+B0bBeP4fKS5B2ChCJs1TvDRSZ
         RUNXH/3ToEUXDLxCgFEU0egWk3RBGZ8y0NJhV788ig0ruwzr7fAFeesZqY8xJSsRa7SS
         U5Rg==
In-Reply-To: <1410619073-26360-2-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 13 Sep 2014 16:37:53 +0200, Andreas Rohner wrote:
> Under normal circumstances nilfs_sync_fs() writes out the super block,
> which causes a flush of the underlying block device. But this depends on
> the THE_NILFS_SB_DIRTY flag, which is only set if the pointer to the
> last segment crosses a segment boundary. So if only a small amount of
> data is written before the call to nilfs_sync_fs(), no flush of the
> block device occurs.
> 
> In the above case an additional call to blkdev_issue_flush() is needed.
> To prevent unnecessary overhead, the new flag nilfs->ns_flushed_device
> is introduced, which is cleared whenever new logs are written and set
> whenever the block device is flushed. For convenience the function
> nilfs_flush_device() is added, which contains the above logic.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Applied, thank you!

Ryusuke Konishi

> ---
>  fs/nilfs2/file.c      |  8 +++-----
>  fs/nilfs2/ioctl.c     |  8 +++-----
>  fs/nilfs2/segment.c   |  3 +++
>  fs/nilfs2/super.c     |  6 ++++++
>  fs/nilfs2/the_nilfs.h | 22 ++++++++++++++++++++++
>  5 files changed, 37 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index 2497815..e9e3325 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -56,11 +56,9 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	mutex_unlock(&inode->i_mutex);
>  
>  	nilfs = inode->i_sb->s_fs_info;
> -	if (!err && nilfs_test_opt(nilfs, BARRIER)) {
> -		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
> -		if (err != -EIO)
> -			err = 0;
> -	}
> +	if (!err)
> +		err = nilfs_flush_device(nilfs);
> +
>  	return err;
>  }
>  
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 422fb54..9a20e51 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -1022,11 +1022,9 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
>  		return ret;
>  
>  	nilfs = inode->i_sb->s_fs_info;
> -	if (nilfs_test_opt(nilfs, BARRIER)) {
> -		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
> -		if (ret == -EIO)
> -			return ret;
> -	}
> +	ret = nilfs_flush_device(nilfs);
> +	if (ret < 0)
> +		return ret;
>  
>  	if (argp != NULL) {
>  		down_read(&nilfs->ns_segctor_sem);
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index a1a1916..0b7d2ca 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -1833,6 +1833,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
>  	nilfs_set_next_segment(nilfs, segbuf);
>  
>  	if (update_sr) {
> +		nilfs->ns_flushed_device = 0;
>  		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
>  				       segbuf->sb_sum.seg_seq, nilfs->ns_cno++);
>  
> @@ -2216,6 +2217,8 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
>  	sci->sc_dsync_end = end;
>  
>  	err = nilfs_segctor_do_construct(sci, SC_LSEG_DSYNC);
> +	if (!err)
> +		nilfs->ns_flushed_device = 0;
>  
>  	nilfs_transaction_unlock(sb);
>  	return err;
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 228f5bd..2e5b3ec 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -310,6 +310,9 @@ int nilfs_commit_super(struct super_block *sb, int flag)
>  					    nilfs->ns_sbsize));
>  	}
>  	clear_nilfs_sb_dirty(nilfs);
> +	nilfs->ns_flushed_device = 1;
> +	/* make sure store to ns_flushed_device cannot be reordered */
> +	smp_wmb();
>  	return nilfs_sync_super(sb, flag);
>  }
>  
> @@ -514,6 +517,9 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
>  	}
>  	up_write(&nilfs->ns_sem);
>  
> +	if (!err)
> +		err = nilfs_flush_device(nilfs);
> +
>  	return err;
>  }
>  
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index d01ead1..23778d3 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -46,6 +46,7 @@ enum {
>  /**
>   * struct the_nilfs - struct to supervise multiple nilfs mount points
>   * @ns_flags: flags
> + * @ns_flushed_device: flag indicating if all volatile data was flushed
>   * @ns_bdev: block device
>   * @ns_sem: semaphore for shared states
>   * @ns_snapshot_mount_mutex: mutex to protect snapshot mounts
> @@ -103,6 +104,7 @@ enum {
>   */
>  struct the_nilfs {
>  	unsigned long		ns_flags;
> +	int			ns_flushed_device;
>  
>  	struct block_device    *ns_bdev;
>  	struct rw_semaphore	ns_sem;
> @@ -371,4 +373,24 @@ static inline int nilfs_segment_is_active(struct the_nilfs *nilfs, __u64 n)
>  	return n == nilfs->ns_segnum || n == nilfs->ns_nextnum;
>  }
>  
> +static inline int nilfs_flush_device(struct the_nilfs *nilfs)
> +{
> +	int err;
> +
> +	if (!nilfs_test_opt(nilfs, BARRIER) || nilfs->ns_flushed_device)
> +		return 0;
> +
> +	nilfs->ns_flushed_device = 1;
> +	/*
> +	 * the store to ns_flushed_device must not be reordered after
> +	 * blkdev_issue_flush().
> +	 */
> +	smp_wmb();
> +
> +	err = blkdev_issue_flush(nilfs->ns_bdev, GFP_KERNEL, NULL);
> +	if (err != -EIO)
> +		err = 0;
> +	return err;
> +}
> +
>  #endif /* _THE_NILFS_H */
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
