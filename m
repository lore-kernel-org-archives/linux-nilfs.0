From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: add bdev freeze/thaw support
Date: Tue, 21 Sep 2010 01:21:08 +0900
Message-ID: <1284999668-21814-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Nilfs hasn't supported the freeze/thaw feature because it didn't work
due to the peculiar design that multiple super block instances could
be allocated for a device.  This limitation was removed by the patch
"nilfs2: do not allocate multiple super block instances for a device".

So now this adds the freeze/thaw support to nilfs.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c   |    2 +
 fs/nilfs2/segment.c |    2 +
 fs/nilfs2/super.c   |   58 +++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 85274f0..db2b3e7 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -581,6 +581,8 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 		goto out_free;
 	}
 
+	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+
 	ret = nilfs_ioctl_move_blocks(inode->i_sb, &argv[0], kbufs[0]);
 	if (ret < 0)
 		printk(KERN_ERR "NILFS: GC failed during preparation: "
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 56350bf..172ad42 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -191,6 +191,8 @@ int nilfs_transaction_begin(struct super_block *sb,
 	if (ret > 0)
 		return 0;
 
+	vfs_check_frozen(sb, SB_FREEZE_WRITE);
+
 	sbi = NILFS_SB(sb);
 	nilfs = sbi->s_nilfs;
 	down_read(&nilfs->ns_segctor_sem);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8418bd0..027c7e8 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -74,6 +74,7 @@ struct kmem_cache *nilfs_transaction_cachep;
 struct kmem_cache *nilfs_segbuf_cachep;
 struct kmem_cache *nilfs_btree_path_cache;
 
+static int nilfs_setup_super(struct nilfs_sb_info *sbi, int is_mount);
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 
 static void nilfs_set_error(struct nilfs_sb_info *sbi)
@@ -444,6 +445,36 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
 	return err;
 }
 
+static int nilfs_freeze(struct super_block *sb)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	int err;
+
+	if (sb->s_flags & MS_RDONLY)
+		return 0;
+
+	/* Mark super block clean */
+	down_write(&nilfs->ns_sem);
+	err = nilfs_cleanup_super(sbi);
+	up_write(&nilfs->ns_sem);
+	return err;
+}
+
+static int nilfs_unfreeze(struct super_block *sb)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+
+	if (sb->s_flags & MS_RDONLY)
+		return 0;
+
+	down_write(&nilfs->ns_sem);
+	nilfs_setup_super(sbi, false);
+	up_write(&nilfs->ns_sem);
+	return 0;
+}
+
 static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
@@ -528,6 +559,8 @@ static const struct super_operations nilfs_sops = {
 	.put_super      = nilfs_put_super,
 	/* .write_super    = nilfs_write_super, */
 	.sync_fs        = nilfs_sync_fs,
+	.freeze_fs	= nilfs_freeze,
+	.unfreeze_fs	= nilfs_unfreeze,
 	/* .write_super_lockfs */
 	/* .unlockfs */
 	.statfs         = nilfs_statfs,
@@ -631,7 +664,7 @@ nilfs_set_default_options(struct nilfs_sb_info *sbi,
 		NILFS_MOUNT_ERRORS_RO | NILFS_MOUNT_BARRIER;
 }
 
-static int nilfs_setup_super(struct nilfs_sb_info *sbi)
+static int nilfs_setup_super(struct nilfs_sb_info *sbi, int is_mount)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct nilfs_super_block **sbp;
@@ -643,6 +676,9 @@ static int nilfs_setup_super(struct nilfs_sb_info *sbi)
 	if (!sbp)
 		return -EIO;
 
+	if (!is_mount)
+		goto skip_mount_setup;
+
 	max_mnt_count = le16_to_cpu(sbp[0]->s_max_mnt_count);
 	mnt_count = le16_to_cpu(sbp[0]->s_mnt_count);
 
@@ -659,9 +695,11 @@ static int nilfs_setup_super(struct nilfs_sb_info *sbi)
 		sbp[0]->s_max_mnt_count = cpu_to_le16(NILFS_DFL_MAX_MNT_COUNT);
 
 	sbp[0]->s_mnt_count = cpu_to_le16(mnt_count + 1);
+	sbp[0]->s_mtime = cpu_to_le64(get_seconds());
+
+skip_mount_setup:
 	sbp[0]->s_state =
 		cpu_to_le16(le16_to_cpu(sbp[0]->s_state) & ~NILFS_VALID_FS);
-	sbp[0]->s_mtime = cpu_to_le64(get_seconds());
 	/* synchronize sbp[1] with sbp[0] */
 	memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
 	return nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
@@ -943,7 +981,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_write(&nilfs->ns_sem);
-		nilfs_setup_super(sbi);
+		nilfs_setup_super(sbi, true);
 		up_write(&nilfs->ns_sem);
 	}
 
@@ -1041,7 +1079,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 			goto restore_opts;
 
 		down_write(&nilfs->ns_sem);
-		nilfs_setup_super(sbi);
+		nilfs_setup_super(sbi, true);
 		up_write(&nilfs->ns_sem);
 	}
  out:
@@ -1141,7 +1179,19 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 		goto failed;
 	}
 
+	/*
+	 * once the super is inserted into the list by sget, s_umount
+	 * will protect the lockfs code from trying to start a snapshot
+	 * while we are mounting
+	 */
+	mutex_lock(&sd.bdev->bd_fsfreeze_mutex);
+	if (sd.bdev->bd_fsfreeze_count > 0) {
+		mutex_unlock(&sd.bdev->bd_fsfreeze_mutex);
+		err = -EBUSY;
+		goto failed;
+	}
 	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, sd.bdev);
+	mutex_unlock(&sd.bdev->bd_fsfreeze_mutex);
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
 		goto failed;
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
