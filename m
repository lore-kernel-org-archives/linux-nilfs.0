From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/12] fs: use the super_block as holder when
 mounting file systems
Date: Wed,  2 Aug 2023 17:41:25 +0200
Message-ID: <20230802154131.2221419-7-hch@lst.de>
References: <20230802154131.2221419-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:References:
 In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=M1CYJB5aZHpSvwyG1hOGEAK3efdcwABvgd5jbMJTCG8=; b=DfpK+3eqqsb+GDiap23vZV3+aV
 46J3LhWB7rVnpsnV+Hf1H1CCfIanjQQfVRdYj9AcM9qhTsPfO/6tU/8Lcq8uoUcEkxfgzQx0XVPny
 I3jHgQvOVjQZHP8w5NmzZNbWREsHllOqkvbn93npsuxBDVSSn3CBrVogFxReg1SWhVb0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=M1CYJB5aZHpSvwyG1hOGEAK3efdcwABvgd5jbMJTCG8=; b=MnWt63AlV68rWWuvh4X84Bj1HS
 2RI1o2XW8INsJFoc6toBpz/n7qLBGA1Eryc7JZNQXZuVcJD93FtT88ZByqlfn5A3IZsTmC5Jqlg4X
 iydgHj5jFXL21bolpprTghy6RFHCDvj6DlQiW6eYjVPFY7E2LcOGpQTnBo2TbT+mBZJ8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=M1CYJB5aZHpSvwyG1hOGEAK3efdcwABvgd5jbMJTCG8=; b=4M2U9E2zBIKq45Q55cHcXCmYTg
 gAnYWD0UBubVeGE8flbFzHcT2SAbc9FEd/qFH3xmSbWluAsI7ww7kYoPqlU3QRz8RzFRKLHIzCgsf
 cr+3pEEMdDlLG1z5QCdKhFRnxuZje6F/ETjowj21lvzt7iG5qDNkgAKTduXm8RM6mxtnghjEmUiaS
 7mgukROVBAbdXXqRfUtEp/TlgAYZIPJaVLwJpzJz5iuX46JRBvvwzLD9hgz9rnWt+GHxif423Xbbh
 VxSnMzgn7bE0RP3Snb8vXJU9C2OAa1FWQ+NPZeXwjgltT9BQvqIRMcNdE46+kaNcA/LQM6OmRuIiT
 4Jzx0irw==;
In-Reply-To: <20230802154131.2221419-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-btrfs@vger.kernel.org

The file system type is not a very useful holder as it doesn't allow us
to go back to the actual file system instance.  Pass the super_block instead
which is useful when passed back to the file system driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/super.c | 7 ++-----
 fs/f2fs/super.c  | 7 +++----
 fs/super.c       | 8 ++++----
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5980b5dcc6b163..8a47c7f2690880 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -69,8 +69,6 @@ static const struct super_operations btrfs_super_ops;
  * requested by subvol=/path. That way the callchain is straightforward and we
  * don't have to play tricks with the mount options and recursive calls to
  * btrfs_mount.
- *
- * The new btrfs_root_fs_type also servers as a tag for the bdev_holder.
  */
 static struct file_system_type btrfs_fs_type;
 static struct file_system_type btrfs_root_fs_type;
@@ -1498,8 +1496,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	} else {
 		struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 
-		error = btrfs_open_devices(fs_devices, sb_open_mode(flags),
-					   fs_type);
+		error = btrfs_open_devices(fs_devices, sb_open_mode(flags), s);
 		if (error)
 			goto out_deactivate;
 
@@ -1513,7 +1510,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 			 fs_devices->latest_dev->bdev);
 		shrinker_debugfs_rename(&s->s_shrink, "sb-%s:%s", fs_type->name,
 					s->s_id);
-		btrfs_sb(s)->bdev_holder = fs_type;
+		fs_info->bdev_holder = s;
 		error = btrfs_fill_super(s, fs_devices, data);
 	}
 	if (!error)
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ca31163da00a55..05c90fdb7a6cca 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1561,7 +1561,7 @@ static void destroy_device_list(struct f2fs_sb_info *sbi)
 	int i;
 
 	for (i = 0; i < sbi->s_ndevs; i++) {
-		blkdev_put(FDEV(i).bdev, sbi->sb->s_type);
+		blkdev_put(FDEV(i).bdev, sbi->sb);
 #ifdef CONFIG_BLK_DEV_ZONED
 		kvfree(FDEV(i).blkz_seq);
 #endif
@@ -4198,7 +4198,7 @@ static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
 			/* Single zoned block device mount */
 			FDEV(0).bdev =
 				blkdev_get_by_dev(sbi->sb->s_bdev->bd_dev, mode,
-						  sbi->sb->s_type, NULL);
+						  sbi->sb, NULL);
 		} else {
 			/* Multi-device mount */
 			memcpy(FDEV(i).path, RDEV(i).path, MAX_PATH_LEN);
@@ -4217,8 +4217,7 @@ static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
 					sbi->log_blocks_per_seg) - 1;
 			}
 			FDEV(i).bdev = blkdev_get_by_path(FDEV(i).path, mode,
-							  sbi->sb->s_type,
-							  NULL);
+							  sbi->sb, NULL);
 		}
 		if (IS_ERR(FDEV(i).bdev))
 			return PTR_ERR(FDEV(i).bdev);
diff --git a/fs/super.c b/fs/super.c
index 6aaa275fa8630d..09b65ee1a8b737 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1249,7 +1249,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
 	blk_mode_t mode = sb_open_mode(sb_flags);
 	struct block_device *bdev;
 
-	bdev = blkdev_get_by_dev(sb->s_dev, mode, sb->s_type, &fs_holder_ops);
+	bdev = blkdev_get_by_dev(sb->s_dev, mode, sb, &fs_holder_ops);
 	if (IS_ERR(bdev)) {
 		if (fc)
 			errorf(fc, "%s: Can't open blockdev", fc->source);
@@ -1262,7 +1262,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
 	 * writable from userspace even for a read-only block device.
 	 */
 	if ((mode & BLK_OPEN_WRITE) && bdev_read_only(bdev)) {
-		blkdev_put(bdev, sb->s_type);
+		blkdev_put(bdev, sb);
 		return -EACCES;
 	}
 
@@ -1278,7 +1278,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
 		if (fc)
 			warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
-		blkdev_put(bdev, sb->s_type);
+		blkdev_put(bdev, sb);
 		return -EBUSY;
 	}
 	spin_lock(&sb_lock);
@@ -1418,7 +1418,7 @@ void kill_block_super(struct super_block *sb)
 	if (bdev) {
 		bdev->bd_super = NULL;
 		sync_blockdev(bdev);
-		blkdev_put(bdev, sb->s_type);
+		blkdev_put(bdev, sb);
 	}
 }
 
-- 
2.39.2
