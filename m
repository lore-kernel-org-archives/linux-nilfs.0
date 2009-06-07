From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 3/6] nilfs2: get rid of sget use for checking if current mount is present
Date: Mon,  8 Jun 2009 01:39:30 +0900
Message-ID: <1244392773-14230-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1244392773-14230-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1244392773-14230-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, users@nilfs.org

This stops using sget() for checking if an r/w-mount or an r/o-mount
exists on the device.  This elimination uses a back pointer to the
current mount added to nilfs object.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/nilfs2/super.c     |   92 +++++++++++++++++--------------------------------
 fs/nilfs2/the_nilfs.h |    3 ++
 2 files changed, 35 insertions(+), 60 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index bdb479a..0a62901 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -66,8 +66,6 @@ MODULE_DESCRIPTION("A New Implementation of the Log-structured Filesystem "
 MODULE_LICENSE("GPL");
 
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
-static int test_exclusive_mount(struct file_system_type *fs_type,
-				struct block_device *bdev, int flags);
 
 /**
  * nilfs_error() - report failure condition on a filesystem
@@ -323,6 +321,10 @@ static void nilfs_put_super(struct super_block *sb)
 		nilfs_commit_super(sbi, 1);
 		up_write(&nilfs->ns_sem);
 	}
+	down_write(&nilfs->ns_sem);
+	if (nilfs->ns_current == sbi)
+		nilfs->ns_current = NULL;
+	up_write(&nilfs->ns_sem);
 
 	nilfs_detach_checkpoint(sbi);
 	put_nilfs(sbi->s_nilfs);
@@ -870,6 +872,11 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 		goto failed_root;
 	}
 
+	down_write(&nilfs->ns_sem);
+	if (!nilfs_test_opt(sbi, SNAPSHOT))
+		nilfs->ns_current = sbi;
+	up_write(&nilfs->ns_sem);
+
 	return 0;
 
  failed_root:
@@ -946,14 +953,16 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		 * by fsck since we originally mounted the partition.)
 		 */
 		down(&sb->s_bdev->bd_mount_sem);
-		/* Check existing RW-mount */
-		if (test_exclusive_mount(sb->s_type, sb->s_bdev, 0)) {
+		down_read(&nilfs->ns_sem);
+		if (nilfs->ns_current && nilfs->ns_current != sbi) {
 			printk(KERN_WARNING "NILFS (device %s): couldn't "
-			       "remount because a RW-mount exists.\n",
+			       "remount because an RW-mount exists.\n",
 			       sb->s_id);
+			up_read(&nilfs->ns_sem);
 			err = -EBUSY;
 			goto rw_remount_failed;
 		}
+		up_read(&nilfs->ns_sem);
 		if (sbi->s_snapshot_cno != nilfs_last_cno(nilfs)) {
 			printk(KERN_WARNING "NILFS (device %s): couldn't "
 			       "remount because the current RO-mount is not "
@@ -972,6 +981,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 
 		down_write(&nilfs->ns_sem);
 		nilfs_setup_super(sbi);
+		nilfs->ns_current = sbi;
 		up_write(&nilfs->ns_sem);
 
 		up(&sb->s_bdev->bd_mount_sem);
@@ -1104,10 +1114,23 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	}
 
 	down(&sd.bdev->bd_mount_sem);
-	if (!sd.cno &&
-	    (err = test_exclusive_mount(fs_type, sd.bdev, flags ^ MS_RDONLY))) {
-		err = (err < 0) ? : -EBUSY;
-		goto failed_unlock;
+
+	if (!sd.cno) {
+		/*
+		 * Check if an exclusive mount exists or not.
+		 * Snapshot mounts coexist with a current mount
+		 * (i.e. rw-mount or ro-mount), whereas rw-mount and
+		 * ro-mount are mutually exclusive.
+		 */
+		down_read(&nilfs->ns_sem);
+		if (nilfs->ns_current &&
+		    ((nilfs->ns_current->s_super->s_flags ^ flags)
+		     & MS_RDONLY)) {
+			up_read(&nilfs->ns_sem);
+			err = -EBUSY;
+			goto failed_unlock;
+		}
+		up_read(&nilfs->ns_sem);
 	}
 
 	/*
@@ -1168,57 +1191,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	return err;
 }
 
-static int nilfs_test_bdev_super3(struct super_block *s, void *data)
-{
-	struct nilfs_super_data *sd = data;
-	int ret;
-
-	if (s->s_bdev != sd->bdev)
-		return 0;
-	if (down_read_trylock(&s->s_umount)) {
-		ret = (s->s_flags & MS_RDONLY) && s->s_root &&
-			nilfs_test_opt(NILFS_SB(s), SNAPSHOT);
-		up_read(&s->s_umount);
-		if (ret)
-			return 0; /* ignore snapshot mounts */
-	}
-	return !((sd->flags ^ s->s_flags) & MS_RDONLY);
-}
-
-static int __false_bdev_super(struct super_block *s, void *data)
-{
-#if 0 /* XXX: workaround for lock debug. This is not good idea */
-	up_write(&s->s_umount);
-#endif
-	return -EFAULT;
-}
-
-/**
- * test_exclusive_mount - check whether an exclusive RW/RO mount exists or not.
- * fs_type: filesystem type
- * bdev: block device
- * flag: 0 (check rw-mount) or MS_RDONLY (check ro-mount)
- * res: pointer to an integer to store result
- *
- * This function must be called within a section protected by bd_mount_mutex.
- */
-static int test_exclusive_mount(struct file_system_type *fs_type,
-				struct block_device *bdev, int flags)
-{
-	struct super_block *s;
-	struct nilfs_super_data sd = { .flags = flags, .bdev = bdev };
-
-	s = sget(fs_type, nilfs_test_bdev_super3, __false_bdev_super, &sd);
-	if (IS_ERR(s)) {
-		if (PTR_ERR(s) != -EFAULT)
-			return PTR_ERR(s);
-		return 0;  /* Not found */
-	}
-	up_write(&s->s_umount);
-	deactivate_super(s);
-	return 1;  /* Found */
-}
-
 struct file_system_type nilfs_fs_type = {
 	.owner    = THIS_MODULE,
 	.name     = "nilfs2",
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 116caf9..99f7e29 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -50,6 +50,7 @@ enum {
  * @ns_sem: semaphore for shared states
  * @ns_writer_mutex: mutex protecting ns_writer attach/detach
  * @ns_writer_refcount: number of referrers on ns_writer
+ * @ns_current: back pointer to current mount
  * @ns_sbh: buffer heads of on-disk super blocks
  * @ns_sbp: pointers to super block data
  * @ns_sbwtime: previous write time of super blocks
@@ -98,6 +99,8 @@ struct the_nilfs {
 	struct mutex		ns_writer_mutex;
 	atomic_t		ns_writer_refcount;
 
+	struct nilfs_sb_info   *ns_current;
+
 	/*
 	 * used for
 	 * - loading the latest checkpoint exclusively.
-- 
1.6.2

