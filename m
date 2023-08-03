From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 06/12] fs: use the super_block as holder when mounting
 file systems
Date: Thu, 3 Aug 2023 13:51:31 +0200
Message-ID: <20230803115131.w6hbhjvvkqnv4qbq@quack3>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-7-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1691063491; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FSDsUsIEQz9MqYljBqqvkw70hXtdohgf+Xi67OczPRo=;
        b=odMACKCIVrFSIXlcffue7bXE6GbaXBcd5uZGciE4H0AoT/+WWV/L2NVjCjh25U1T4hX/cs
        TTJY8v5U9PLqp7sFGPj9P5jvU6MF0P30lZW3EvpPJELuObqYiD8Wgn+1RmiEU/gZzwcyaA
        EvOmiWaVUuvxkKP2YG9McS4lETi+k9Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1691063491;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FSDsUsIEQz9MqYljBqqvkw70hXtdohgf+Xi67OczPRo=;
        b=jIB7cdSAyRslx1phzXdb8IVuWU82Qcmj3mJGynL7hiUUJ8Mnn3Rj/hJ8z5LEMxGiSqZEO3
        zfwQeDRaEtkTLMBw==
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-7-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 02-08-23 17:41:25, Christoph Hellwig wrote:
> The file system type is not a very useful holder as it doesn't allow us
> to go back to the actual file system instance.  Pass the super_block instead
> which is useful when passed back to the file system driver.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Nice, this is what I also wanted to eventually do :). Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  fs/btrfs/super.c | 7 ++-----
>  fs/f2fs/super.c  | 7 +++----
>  fs/super.c       | 8 ++++----
>  3 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 5980b5dcc6b163..8a47c7f2690880 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -69,8 +69,6 @@ static const struct super_operations btrfs_super_ops;
>   * requested by subvol=/path. That way the callchain is straightforward and we
>   * don't have to play tricks with the mount options and recursive calls to
>   * btrfs_mount.
> - *
> - * The new btrfs_root_fs_type also servers as a tag for the bdev_holder.
>   */
>  static struct file_system_type btrfs_fs_type;
>  static struct file_system_type btrfs_root_fs_type;
> @@ -1498,8 +1496,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>  	} else {
>  		struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>  
> -		error = btrfs_open_devices(fs_devices, sb_open_mode(flags),
> -					   fs_type);
> +		error = btrfs_open_devices(fs_devices, sb_open_mode(flags), s);
>  		if (error)
>  			goto out_deactivate;
>  
> @@ -1513,7 +1510,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>  			 fs_devices->latest_dev->bdev);
>  		shrinker_debugfs_rename(&s->s_shrink, "sb-%s:%s", fs_type->name,
>  					s->s_id);
> -		btrfs_sb(s)->bdev_holder = fs_type;
> +		fs_info->bdev_holder = s;
>  		error = btrfs_fill_super(s, fs_devices, data);
>  	}
>  	if (!error)
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index ca31163da00a55..05c90fdb7a6cca 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -1561,7 +1561,7 @@ static void destroy_device_list(struct f2fs_sb_info *sbi)
>  	int i;
>  
>  	for (i = 0; i < sbi->s_ndevs; i++) {
> -		blkdev_put(FDEV(i).bdev, sbi->sb->s_type);
> +		blkdev_put(FDEV(i).bdev, sbi->sb);
>  #ifdef CONFIG_BLK_DEV_ZONED
>  		kvfree(FDEV(i).blkz_seq);
>  #endif
> @@ -4198,7 +4198,7 @@ static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
>  			/* Single zoned block device mount */
>  			FDEV(0).bdev =
>  				blkdev_get_by_dev(sbi->sb->s_bdev->bd_dev, mode,
> -						  sbi->sb->s_type, NULL);
> +						  sbi->sb, NULL);
>  		} else {
>  			/* Multi-device mount */
>  			memcpy(FDEV(i).path, RDEV(i).path, MAX_PATH_LEN);
> @@ -4217,8 +4217,7 @@ static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
>  					sbi->log_blocks_per_seg) - 1;
>  			}
>  			FDEV(i).bdev = blkdev_get_by_path(FDEV(i).path, mode,
> -							  sbi->sb->s_type,
> -							  NULL);
> +							  sbi->sb, NULL);
>  		}
>  		if (IS_ERR(FDEV(i).bdev))
>  			return PTR_ERR(FDEV(i).bdev);
> diff --git a/fs/super.c b/fs/super.c
> index 6aaa275fa8630d..09b65ee1a8b737 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1249,7 +1249,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
>  	blk_mode_t mode = sb_open_mode(sb_flags);
>  	struct block_device *bdev;
>  
> -	bdev = blkdev_get_by_dev(sb->s_dev, mode, sb->s_type, &fs_holder_ops);
> +	bdev = blkdev_get_by_dev(sb->s_dev, mode, sb, &fs_holder_ops);
>  	if (IS_ERR(bdev)) {
>  		if (fc)
>  			errorf(fc, "%s: Can't open blockdev", fc->source);
> @@ -1262,7 +1262,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
>  	 * writable from userspace even for a read-only block device.
>  	 */
>  	if ((mode & BLK_OPEN_WRITE) && bdev_read_only(bdev)) {
> -		blkdev_put(bdev, sb->s_type);
> +		blkdev_put(bdev, sb);
>  		return -EACCES;
>  	}
>  
> @@ -1278,7 +1278,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
>  		mutex_unlock(&bdev->bd_fsfreeze_mutex);
>  		if (fc)
>  			warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
> -		blkdev_put(bdev, sb->s_type);
> +		blkdev_put(bdev, sb);
>  		return -EBUSY;
>  	}
>  	spin_lock(&sb_lock);
> @@ -1418,7 +1418,7 @@ void kill_block_super(struct super_block *sb)
>  	if (bdev) {
>  		bdev->bd_super = NULL;
>  		sync_blockdev(bdev);
> -		blkdev_put(bdev, sb->s_type);
> +		blkdev_put(bdev, sb);
>  	}
>  }
>  
> -- 
> 2.39.2
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
