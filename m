From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/12] btrfs: always open the device read-only in
 btrfs_scan_one_device
Date: Wed,  2 Aug 2023 17:41:22 +0200
Message-ID: <20230802154131.2221419-4-hch@lst.de>
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
 bh=r6gDfPhaoM7J2iRzTUUAmIosaWN5Ed601e9pLnuJfEs=; b=VsaI6siV+3gBfWRIy58fPqmCnU
 +BRPF5bWuCYfn1kws9d1fWkI+XjK3Xj1R5yoplldbpyI6kSTRG55dyUEHViGSkT3ivYMnVQECaGJA
 NsHPKzrtKmWej5Stc5qNZa6uJ25lU8zJaR3MbHvmggzJNhPLgoT6CX2kN1LUOID8zUGM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=r6gDfPhaoM7J2iRzTUUAmIosaWN5Ed601e9pLnuJfEs=; b=epaeiRGckCcirN3YiQP9l8/rO+
 hVQD7ooQwXzP58eLKyflvdDyG6hoBs+3GpuwHE22z1lLShLuC8a+7FMXBVC276nJ/SshSzlLURGCj
 5MU+a0Huhoq9vmlrojnJaqBj3PkX4FnGo+mwy1M5VtQrXI+/xzk2qas/3fkIMKJbsXaw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=r6gDfPhaoM7J2iRzTUUAmIosaWN5Ed601e9pLnuJfEs=; b=c/d4bWxOI508Va9wIGXRyHKdMA
 IlxE8CEKVR0mcLbU3734JNpP0RMsj7Qu2YdutSwnxlB50zjF92HsUKdY0bgEvUK4yP9MNpSqJZ8na
 GoQBql1OU4+D49Do/OsTLEuL3PUc8/gdGa7t4r0dYzY6jPDsDOwBeT8ZR7YNcbf688sHQ7vpgT6fw
 LVPeh/Ns9PqLrZtZ9T8O0RTAhKsFlOrpBjIsYwNcRcO2d0y14NWF6CmZ6t3suWbSPcwnPC6XuRkit
 8FOLfmqVbY3oNlQfdxdqx3DIV+pQVghfqtD6vATCpB+iS6JDlkjRqxAyu8Af+23wKnqAQFUBTNV/K
 SU+E7PIQ==;
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

btrfs_scan_one_device opens the block device only to read the super
block.  Instead of passing a blk_mode_t argument to sometimes open
it for writing, just hard code BLK_OPEN_READ as it will never write
to the device or hand the block_device out to someone else.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/super.c   | 15 +++++++--------
 fs/btrfs/volumes.c |  4 ++--
 fs/btrfs/volumes.h |  2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f1dd172d8d5bd7..b318bddefd5236 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -849,7 +849,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
  * All other options will be parsed on much later in the mount process and
  * only when we need to allocate a new super block.
  */
-static int btrfs_parse_device_options(const char *options, blk_mode_t flags)
+static int btrfs_parse_device_options(const char *options)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *device_name, *opts, *orig, *p;
@@ -883,7 +883,7 @@ static int btrfs_parse_device_options(const char *options, blk_mode_t flags)
 				error = -ENOMEM;
 				goto out;
 			}
-			device = btrfs_scan_one_device(device_name, flags);
+			device = btrfs_scan_one_device(device_name);
 			kfree(device_name);
 			if (IS_ERR(device)) {
 				error = PTR_ERR(device);
@@ -1440,7 +1440,6 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	struct btrfs_fs_devices *fs_devices = NULL;
 	struct btrfs_fs_info *fs_info = NULL;
 	void *new_sec_opts = NULL;
-	blk_mode_t mode = sb_open_mode(flags);
 	int error = 0;
 
 	if (data) {
@@ -1472,13 +1471,13 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	}
 
 	mutex_lock(&uuid_mutex);
-	error = btrfs_parse_device_options(data, mode);
+	error = btrfs_parse_device_options(data);
 	if (error) {
 		mutex_unlock(&uuid_mutex);
 		goto error_fs_info;
 	}
 
-	device = btrfs_scan_one_device(device_name, mode);
+	device = btrfs_scan_one_device(device_name);
 	if (IS_ERR(device)) {
 		mutex_unlock(&uuid_mutex);
 		error = PTR_ERR(device);
@@ -1488,7 +1487,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	fs_devices = device->fs_devices;
 	fs_info->fs_devices = fs_devices;
 
-	error = btrfs_open_devices(fs_devices, mode, fs_type);
+	error = btrfs_open_devices(fs_devices, sb_open_mode(flags), fs_type);
 	mutex_unlock(&uuid_mutex);
 	if (error)
 		goto error_fs_info;
@@ -2190,7 +2189,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
 		mutex_lock(&uuid_mutex);
-		device = btrfs_scan_one_device(vol->name, BLK_OPEN_READ);
+		device = btrfs_scan_one_device(vol->name);
 		ret = PTR_ERR_OR_ZERO(device);
 		mutex_unlock(&uuid_mutex);
 		break;
@@ -2204,7 +2203,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		break;
 	case BTRFS_IOC_DEVICES_READY:
 		mutex_lock(&uuid_mutex);
-		device = btrfs_scan_one_device(vol->name, BLK_OPEN_READ);
+		device = btrfs_scan_one_device(vol->name);
 		if (IS_ERR(device)) {
 			mutex_unlock(&uuid_mutex);
 			ret = PTR_ERR(device);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 73f9ea7672dbda..8246578c70f55b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1356,7 +1356,7 @@ int btrfs_forget_devices(dev_t devt)
  * and we are not allowed to call set_blocksize during the scan. The superblock
  * is read via pagecache
  */
-struct btrfs_device *btrfs_scan_one_device(const char *path, blk_mode_t flags)
+struct btrfs_device *btrfs_scan_one_device(const char *path)
 {
 	struct btrfs_super_block *disk_super;
 	bool new_device_added = false;
@@ -1384,7 +1384,7 @@ struct btrfs_device *btrfs_scan_one_device(const char *path, blk_mode_t flags)
 	 * values temporarily, as the device paths of the fsid are the only
 	 * required information for assembling the volume.
 	 */
-	bdev = blkdev_get_by_path(path, flags, NULL, NULL);
+	bdev = blkdev_get_by_path(path, BLK_OPEN_READ, NULL, NULL);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b8c51f16ba867f..824161c6dd063e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -611,7 +611,7 @@ struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
 void btrfs_mapping_tree_free(struct extent_map_tree *tree);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       blk_mode_t flags, void *holder);
-struct btrfs_device *btrfs_scan_one_device(const char *path, blk_mode_t flags);
+struct btrfs_device *btrfs_scan_one_device(const char *path);
 int btrfs_forget_devices(dev_t devt);
 void btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices);
-- 
2.39.2
