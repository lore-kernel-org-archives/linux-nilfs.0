From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 02/12] nilfs2: use setup_bdev_super to de-duplicate the
 mount code
Date: Thu, 3 Aug 2023 13:46:51 +0200
Message-ID: <20230803114651.ihtqqgthbdjjgxev@quack3>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-3-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1691063212; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZRATTl9ze2dbUUVR6EVaJqJOlEgsHbOiGIMflJWuqI0=;
        b=h+EOnXJZ1jQZw9KNznDfrtEVfnT0I2iXG3/4HvbXo1yozv3rIJ+Wdq9MEXs36iEvzouiwa
        Qa8ClVd3Mwj47ujqwbT/HakaB10E6VKYHQZyrhi2fOcf6kBVnzu7m3kX6pRQr2zwBP0jIi
        nGT1wBjrem2o26HsmwfVoHsRyMvqQbg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1691063212;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZRATTl9ze2dbUUVR6EVaJqJOlEgsHbOiGIMflJWuqI0=;
        b=qfBkEeurvDJwpRK/HkPdKdpHXcX207g6s3ATzE+1nJ8sM1f44b6FY6WolKFsTJ/M5qyHi4
        gkmsb6FWy8DyysCQ==
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-3-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 02-08-23 17:41:21, Christoph Hellwig wrote:
> Use the generic setup_bdev_super helper to open the main block device
> and do various bits of superblock setup instead of duplicating the
> logic.  This includes moving to the new scheme implemented in common
> code that only opens the block device after the superblock has allocated.
> 
> It does not yet convert nilfs2 to the new mount API, but doing so will
> become a bit simpler after this first step.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

AFAICS nilfs2 could *almost* use mount_bdev() directly and then just do its
snapshot thing after mount_bdev() returns. But it has this weird logic
that: "if the superblock is already mounted but we can shrink the whole
dcache, then do remount instead of ignoring mount options". Firstly, this
looks racy - what prevents someone from say opening a file on the sb just
after nilfs_tree_is_busy() shrinks dcache? Secondly, it is inconsistent
with any other filesystem so it's going to surprise sysadmins not
intimately knowing nilfs2. Thirdly, from userspace you cannot tell what
your mount call is going to do. Last but not least, what is it really good
for? Ryusuke, can you explain please?

								Honza

> ---
>  fs/nilfs2/super.c | 81 ++++++++++++++++++-----------------------------
>  1 file changed, 30 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 0ef8c71bde8e5f..a5d1fa4e7552f6 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -35,6 +35,7 @@
>  #include <linux/writeback.h>
>  #include <linux/seq_file.h>
>  #include <linux/mount.h>
> +#include <linux/fs_context.h>
>  #include "nilfs.h"
>  #include "export.h"
>  #include "mdt.h"
> @@ -1216,7 +1217,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
>  }
>  
>  struct nilfs_super_data {
> -	struct block_device *bdev;
>  	__u64 cno;
>  	int flags;
>  };
> @@ -1283,64 +1283,49 @@ static int nilfs_identify(char *data, struct nilfs_super_data *sd)
>  
>  static int nilfs_set_bdev_super(struct super_block *s, void *data)
>  {
> -	s->s_bdev = data;
> -	s->s_dev = s->s_bdev->bd_dev;
> +	s->s_dev = *(dev_t *)data;
>  	return 0;
>  }
>  
>  static int nilfs_test_bdev_super(struct super_block *s, void *data)
>  {
> -	return (void *)s->s_bdev == data;
> +	return !(s->s_iflags & SB_I_RETIRED) && s->s_dev == *(dev_t *)data;
>  }
>  
>  static struct dentry *
>  nilfs_mount(struct file_system_type *fs_type, int flags,
>  	     const char *dev_name, void *data)
>  {
> -	struct nilfs_super_data sd;
> +	struct nilfs_super_data sd = { .flags = flags };
>  	struct super_block *s;
> -	struct dentry *root_dentry;
> -	int err, s_new = false;
> +	dev_t dev;
> +	int err;
>  
> -	sd.bdev = blkdev_get_by_path(dev_name, sb_open_mode(flags), fs_type,
> -				     NULL);
> -	if (IS_ERR(sd.bdev))
> -		return ERR_CAST(sd.bdev);
> +	if (nilfs_identify(data, &sd))
> +		return ERR_PTR(-EINVAL);
>  
> -	sd.cno = 0;
> -	sd.flags = flags;
> -	if (nilfs_identify((char *)data, &sd)) {
> -		err = -EINVAL;
> -		goto failed;
> -	}
> +	err = lookup_bdev(dev_name, &dev);
> +	if (err)
> +		return ERR_PTR(err);
>  
> -	/*
> -	 * once the super is inserted into the list by sget, s_umount
> -	 * will protect the lockfs code from trying to start a snapshot
> -	 * while we are mounting
> -	 */
> -	mutex_lock(&sd.bdev->bd_fsfreeze_mutex);
> -	if (sd.bdev->bd_fsfreeze_count > 0) {
> -		mutex_unlock(&sd.bdev->bd_fsfreeze_mutex);
> -		err = -EBUSY;
> -		goto failed;
> -	}
>  	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, flags,
> -		 sd.bdev);
> -	mutex_unlock(&sd.bdev->bd_fsfreeze_mutex);
> -	if (IS_ERR(s)) {
> -		err = PTR_ERR(s);
> -		goto failed;
> -	}
> +		 &dev);
> +	if (IS_ERR(s))
> +		return ERR_CAST(s);
>  
>  	if (!s->s_root) {
> -		s_new = true;
> -
> -		/* New superblock instance created */
> -		snprintf(s->s_id, sizeof(s->s_id), "%pg", sd.bdev);
> -		sb_set_blocksize(s, block_size(sd.bdev));
> -
> -		err = nilfs_fill_super(s, data, flags & SB_SILENT ? 1 : 0);
> +		/*
> +		 * We drop s_umount here because we need to open the bdev and
> +		 * bdev->open_mutex ranks above s_umount (blkdev_put() ->
> +		 * __invalidate_device()). It is safe because we have active sb
> +		 * reference and SB_BORN is not set yet.
> +		 */
> +		up_write(&s->s_umount);
> +		err = setup_bdev_super(s, flags, NULL);
> +		down_write(&s->s_umount);
> +		if (!err)
> +			err = nilfs_fill_super(s, data,
> +					       flags & SB_SILENT ? 1 : 0);
>  		if (err)
>  			goto failed_super;
>  
> @@ -1366,24 +1351,18 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
>  	}
>  
>  	if (sd.cno) {
> +		struct dentry *root_dentry;
> +
>  		err = nilfs_attach_snapshot(s, sd.cno, &root_dentry);
>  		if (err)
>  			goto failed_super;
> -	} else {
> -		root_dentry = dget(s->s_root);
> +		return root_dentry;
>  	}
>  
> -	if (!s_new)
> -		blkdev_put(sd.bdev, fs_type);
> -
> -	return root_dentry;
> +	return dget(s->s_root);
>  
>   failed_super:
>  	deactivate_locked_super(s);
> -
> - failed:
> -	if (!s_new)
> -		blkdev_put(sd.bdev, fs_type);
>  	return ERR_PTR(err);
>  }
>  
> -- 
> 2.39.2
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
