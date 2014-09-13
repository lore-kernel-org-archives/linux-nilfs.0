From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v4 1/1] nilfs2: add missing blkdev_issue_flush() to
 nilfs_sync_fs()
Date: Sat, 13 Sep 2014 20:35:45 +0900 (JST)
Message-ID: <20140913.203545.1841445753777865743.konishi.ryusuke@lab.ntt.co.jp>
References: <1410297429-18260-1-git-send-email-andreas.rohner@gmx.net>
	<1410297429-18260-2-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=T4MbLXxFCr2VjodCqeEFd8OpVXOztqVPXjjjuzd+RIk=;
        b=ufrbqN4n5uyYcSie++1aqwaFq+qelRihxsZzsVax7/JTnpceG8LExmHfgPS5bzAiQO
         fSyf7Fm6A3m6EFvQCTWiiiIYbXukjtpuutvfyPMgOrIgx5fms+Rih4gygSJegdsEq1z+
         3FsNkB7hGqMY7hDyxWj5aWvlFixgYJRoxHwXDNMeUUbVpDpmSogr/diWswiUtuq6YIY9
         mQSLMhZMO9MSDduugHOM0CA+GaYUcj7PaJusPn+bCQnv/SRnF0jPfweYEhawuWdYHQYt
         TyZJi8DRk9GQ4QBJHWw5DbljbL7HT1E02ljIB5EUOEfosA12P+eObs6ZiOJE67pDC4QD
         y0yw==
In-Reply-To: <1410297429-18260-2-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue,  9 Sep 2014 23:17:09 +0200, Andreas Rohner wrote:
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
> whenever the block device is flushed.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  fs/nilfs2/file.c      | 10 +++++++++-
>  fs/nilfs2/ioctl.c     | 10 +++++++++-
>  fs/nilfs2/segment.c   |  4 ++++
>  fs/nilfs2/super.c     | 17 +++++++++++++++++
>  fs/nilfs2/the_nilfs.h |  2 ++
>  5 files changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index 2497815..16375c2 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -56,7 +56,15 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	mutex_unlock(&inode->i_mutex);
>  
>  	nilfs = inode->i_sb->s_fs_info;
> -	if (!err && nilfs_test_opt(nilfs, BARRIER)) {
> +	if (!err && nilfs_test_opt(nilfs, BARRIER) &&
> +	    !nilfs->ns_flushed_device) {
> +		nilfs->ns_flushed_device = 1;
> +		/*
> +		 * the store to ns_flushed_device must not be reordered after
> +		 * blkdev_issue_flush
> +		 */
> +		smp_wmb();
> +
>  		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
>  		if (err != -EIO)
>  			err = 0;

Looks good.  But, these code lines and the comment appear repeatedly.
To simplify these, I propose to add the following inline function to
the_nilfs.h.

@@ -371,4 +373,24 @@ static inline int nilfs_segment_is_active(struct the_nilfs *nilfs, __u64 n)
 	return n == nilfs->ns_segnum || n == nilfs->ns_nextnum;
 }
 
+static inline int nilfs_flush_device(struct the_nilfs *nilfs)
+{
+	int err;
+
+	if (!nilfs_test_opt(nilfs, BARRIER) || nilfs->ns_flushed_device)
+		return 0;
+
+	nilfs->ns_flushed_device = 1;
+	/*
+	 * the store to ns_flushed_device must not be reordered after
+	 * blkdev_issue_flush().
+	 */
+	smp_wmb();
+
+	err = blkdev_issue_flush(nilfs->ns_bdev, GFP_KERNEL, NULL);
+	if (err != -EIO)
+		err = 0;
+	return err;
+}
+
 #endif /* _THE_NILFS_H */

> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 422fb54..9444d5d 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -1022,7 +1022,15 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
>  		return ret;
>  
>  	nilfs = inode->i_sb->s_fs_info;
> -	if (nilfs_test_opt(nilfs, BARRIER)) {
> +	if (nilfs_test_opt(nilfs, BARRIER) &&
> +	    !nilfs->ns_flushed_device) {
> +		nilfs->ns_flushed_device = 1;
> +		/*
> +		 * the store to ns_flushed_device must not be reordered after
> +		 * blkdev_issue_flush
> +		 */
> +		smp_wmb();
> +
>  		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
>  		if (ret == -EIO)
>  			return ret;
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index a1a1916..379da1b 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -1997,6 +1997,10 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
>  			err = nilfs_segctor_wait(sci);
>  			if (err)
>  				goto failed_to_write;
> +
> +			if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) ||
> +			    mode == SC_LSEG_DSYNC)
> +				nilfs->ns_flushed_device = 0;
>  		}
>  	} while (sci->sc_stage.scnt != NILFS_ST_DONE);

We can simplify this by inserting "nilfs->ns_flushed_device = 0" in
nilfs_segctor_complete_write() and nilfs_construct_dsync_segment()
separately as follows.  Explicit memory barriers are not required in
the following changes because both nilfs_set_last_segment() and
nilfs_transaction_unlock() imply a memory barrier.

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1833,6 +1833,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	nilfs_set_next_segment(nilfs, segbuf);
 
 	if (update_sr) {
+		nilfs->ns_flushed_device = 0;
 		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
 				       segbuf->sb_sum.seg_seq, nilfs->ns_cno++);
 
@@ -2216,6 +2217,8 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	sci->sc_dsync_end = end;
 
 	err = nilfs_segctor_do_construct(sci, SC_LSEG_DSYNC);
+	if (!err)
+		nilfs->ns_flushed_device = 0;
 
 	nilfs_transaction_unlock(sb);
 	return err;


> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 228f5bd..33aafbd 100644
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
> @@ -514,6 +517,20 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
>  	}
>  	up_write(&nilfs->ns_sem);
>  
> +	if (wait && !err && nilfs_test_opt(nilfs, BARRIER) &&
> +	    !nilfs->ns_flushed_device) {
> +		nilfs->ns_flushed_device = 1;
> +		/*
> +		 * the store to ns_flushed_device must not be reordered after
> +		 * blkdev_issue_flush
> +		 */
> +		smp_wmb();
> +
> +		err = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
> +		if (err != -EIO)
> +			err = 0;
> +	}
> +
>  	return err;
>  }
>  
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index d01ead1..dabb02c 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -45,6 +45,7 @@ enum {
>  
>  /**
>   * struct the_nilfs - struct to supervise multiple nilfs mount points

> + * @ns_flushed_device: flag indicating if all volatile data was flushed
>   * @ns_flags: flags

ns_flushed_device is inserted after ns_flags, so these two comment lines
should be swapped.

>   * @ns_bdev: block device
>   * @ns_sem: semaphore for shared states
> @@ -103,6 +104,7 @@ enum {
>   */
>  struct the_nilfs {
>  	unsigned long		ns_flags;
> +	int			ns_flushed_device;
>  
>  	struct block_device    *ns_bdev;
>  	struct rw_semaphore	ns_sem;
> -- 
> 2.1.0


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
