From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 1/1] nilfs2: add missing blkdev_issue_flush() to
 nilfs_sync_fs()
Date: Tue, 02 Sep 2014 02:59:39 +0900 (JST)
Message-ID: <20140902.025939.1812841141168890644.konishi.ryusuke@lab.ntt.co.jp>
References: <1409500033-30791-1-git-send-email-andreas.rohner@gmx.net>
	<1409500033-30791-2-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=u6gSI9fFfWJSjexfehDcMAYsxy2uoQgg/qgEYy9OLVo=;
        b=OWrCAOcvhCxHrw0He+L4rHlJjOs5W74ot2ie7Zs8GyUlJovTqozfFCvL6ZVsDMVaaR
         6dDp5A6YPhMHPaUvwIn6VzE0EVCovmw6a9NuFi+pPyJjN7P7lBfHYvGqveXrP6W16OPi
         0armYcirVl3pyOQzMuBWCztLDUyUxifuasN3XfBNMVeNCQPRLtyFLUk3HxrUDaYR+asq
         oz4qMxtren3PbLy0GwjzHdoTjnS+FeP6VNHsE/fQwkt+bXEPuorVdd1bks6MGMOzmKno
         PEnSu9NsZA2a7+ROlrYhjx3C94NET9W6KknFFmw1V7opgA9+LaoRiG9S1zEqQwH58Kp2
         V9SQ==
In-Reply-To: <1409500033-30791-2-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,
On Sun, 31 Aug 2014 17:47:13 +0200, Andreas Rohner wrote:
> Under normal circumstances nilfs_sync_fs() writes out the super block,
> which causes a flush of the underlying block device. But this depends on
> the THE_NILFS_SB_DIRTY flag, which is only set if the pointer to the
> last segment crosses a segment boundary. So if only a small amount of
> data is written before the call to nilfs_sync_fs(), no flush of the
> block device occurs.
> 
> In the above case an additional call to blkdev_issue_flush() is needed.
> To prevent unnecessary overhead, the new flag THE_NILFS_FLUSHED is
> introduced, which is cleared whenever new logs are written and set
> whenever the block device is flushed.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

The patch looks good to me except that I feel the use of atomic
test-and-set bitwise operations something unfavorable (though it's
logically correct).  I will try to send this to upstream as is unless
a comment comes to mind.

Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/file.c      | 3 ++-
>  fs/nilfs2/ioctl.c     | 3 ++-
>  fs/nilfs2/segment.c   | 2 ++
>  fs/nilfs2/super.c     | 8 ++++++++
>  fs/nilfs2/the_nilfs.h | 6 ++++++
>  5 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index 2497815..7857460 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -56,7 +56,8 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	mutex_unlock(&inode->i_mutex);
>  
>  	nilfs = inode->i_sb->s_fs_info;
> -	if (!err && nilfs_test_opt(nilfs, BARRIER)) {
> +	if (!err && nilfs_test_opt(nilfs, BARRIER) &&
> +	    !test_and_set_nilfs_flushed(nilfs)) {
>  		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
>  		if (err != -EIO)
>  			err = 0;
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 422fb54..dc5d101 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -1022,7 +1022,8 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
>  		return ret;
>  
>  	nilfs = inode->i_sb->s_fs_info;
> -	if (nilfs_test_opt(nilfs, BARRIER)) {
> +	if (nilfs_test_opt(nilfs, BARRIER) &&
> +	    !test_and_set_nilfs_flushed(nilfs)) {
>  		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
>  		if (ret == -EIO)
>  			return ret;
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index a1a1916..54a6be1 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -1842,6 +1842,8 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
>  		nilfs_segctor_clear_metadata_dirty(sci);
>  	} else
>  		clear_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags);
> +
> +	clear_nilfs_flushed(nilfs);
>  }
>  
>  static int nilfs_segctor_wait(struct nilfs_sc_info *sci)
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 228f5bd..332fdf0 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -310,6 +310,7 @@ int nilfs_commit_super(struct super_block *sb, int flag)
>  					    nilfs->ns_sbsize));
>  	}
>  	clear_nilfs_sb_dirty(nilfs);
> +	set_nilfs_flushed(nilfs);
>  	return nilfs_sync_super(sb, flag);
>  }
>  
> @@ -514,6 +515,13 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
>  	}
>  	up_write(&nilfs->ns_sem);
>  
> +	if (wait && !err && nilfs_test_opt(nilfs, BARRIER) &&
> +	    !test_and_set_nilfs_flushed(nilfs)) {
> +		err = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
> +		if (err != -EIO)
> +			err = 0;
> +	}
> +
>  	return err;
>  }
>  
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index d01ead1..d12a8ce 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -41,6 +41,7 @@ enum {
>  	THE_NILFS_DISCONTINUED,	/* 'next' pointer chain has broken */
>  	THE_NILFS_GC_RUNNING,	/* gc process is running */
>  	THE_NILFS_SB_DIRTY,	/* super block is dirty */
> +	THE_NILFS_FLUSHED,	/* volatile data was flushed to disk */
>  };
>  
>  /**
> @@ -202,6 +203,10 @@ struct the_nilfs {
>  };
>  
>  #define THE_NILFS_FNS(bit, name)					\
> +static inline int test_and_set_nilfs_##name(struct the_nilfs *nilfs)	\
> +{									\
> +	return test_and_set_bit(THE_NILFS_##bit, &(nilfs)->ns_flags);	\
> +}									\
>  static inline void set_nilfs_##name(struct the_nilfs *nilfs)		\
>  {									\
>  	set_bit(THE_NILFS_##bit, &(nilfs)->ns_flags);			\
> @@ -219,6 +224,7 @@ THE_NILFS_FNS(INIT, init)
>  THE_NILFS_FNS(DISCONTINUED, discontinued)
>  THE_NILFS_FNS(GC_RUNNING, gc_running)
>  THE_NILFS_FNS(SB_DIRTY, sb_dirty)
> +THE_NILFS_FNS(FLUSHED, flushed)
>  
>  /*
>   * Mount option operations
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
