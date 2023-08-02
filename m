From: "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/12] xfs: drop s_umount over opening the log and RT
 devices
Date: Wed, 2 Aug 2023 09:32:19 -0700
Message-ID: <20230802163219.GW11352@frogsfrogsfrogs>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-12-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690993939;
        bh=GcVu5AKxQx3Xueu/J47RQ71hv6d/lK6wYIHHmRfGqaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wtd/B0tT5WFKMlZ4FcUuBOY403mH8jUVkWi+G6Rc6yRr8xqjh9e6QJP4M5cVaQZjl
         RdSRk087/R+zJKvlBUY6iflSrQVduZHiM7vhrntHc8ykJ5MZ3CsTWNydd8G60nAjjB
         xsTI+0r8XJWzqubQJge2bfArwRHdY+O0Fl3cJpBpiRZiCeObWknsnSeiOIYUNNlQ5n
         gF1Wsh0ENOOBgf0aIBZa5zNVBIhSdH4vc5MXOCvbYSInOKhXU+6gtVD2ABSpP8k6sE
         GxKNKflCh1H01pQA/zivBFr3jCjg3b+DK9HkonEjcCq0iyGozH4qOncit0g9T89zgx
         DasFxOweGYc3Q==
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-12-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 02, 2023 at 05:41:30PM +0200, Christoph Hellwig wrote:
> Just like get_tree_bdev needs to drop s_umount when opening the main
> device, we need to do the same for the xfs log and RT devices to avoid a
> potential lock order reversal with s_unmount for the mark_dead path.
> 
> It might be preferable to just drop s_umount over ->fill_super entirely,
> but that will require a fairly massive audit first, so we'll do the easy
> version here first.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  fs/xfs/xfs_super.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 8185102431301d..d5042419ed9997 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -448,17 +448,21 @@ STATIC int
>  xfs_open_devices(
>  	struct xfs_mount	*mp)
>  {
> -	struct block_device	*ddev = mp->m_super->s_bdev;
> +	struct super_block	*sb = mp->m_super;
> +	struct block_device	*ddev = sb->s_bdev;
>  	struct block_device	*logdev = NULL, *rtdev = NULL;
>  	int			error;
>  
> +	/* see get_tree_bdev why this is needed and safe */

Which part of get_tree_bdev?  Is it this?

		/*
		 * s_umount nests inside open_mutex during
		 * __invalidate_device().  blkdev_put() acquires
		 * open_mutex and can't be called under s_umount.  Drop
		 * s_umount temporarily.  This is safe as we're
		 * holding an active reference.
		 */
		up_write(&s->s_umount);
		blkdev_put(bdev, fc->fs_type);
		down_write(&s->s_umount);

<confused>

> +	up_write(&sb->s_umount);
> +
>  	/*
>  	 * Open real time and log devices - order is important.
>  	 */
>  	if (mp->m_logname) {
>  		error = xfs_blkdev_get(mp, mp->m_logname, &logdev);
>  		if (error)
> -			return error;
> +			goto out_unlock;
>  	}
>  
>  	if (mp->m_rtname) {
> @@ -496,7 +500,10 @@ xfs_open_devices(
>  		mp->m_logdev_targp = mp->m_ddev_targp;
>  	}
>  
> -	return 0;
> +	error = 0;
> +out_unlock:
> +	down_write(&sb->s_umount);

Isn't down_write taking s_umount?  I think the label should be
out_relock or something less misleading.

--D

> +	return error;
>  
>   out_free_rtdev_targ:
>  	if (mp->m_rtdev_targp)
> @@ -508,7 +515,7 @@ xfs_open_devices(
>   out_close_logdev:
>  	if (logdev && logdev != ddev)
>  		xfs_blkdev_put(mp, logdev);
> -	return error;
> +	goto out_unlock;
>  }
>  
>  /*
> -- 
> 2.39.2
> 
