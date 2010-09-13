From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 11/23] nilfs2: simplify life cycle management of nilfs object
Date: Tue, 14 Sep 2010 00:37:12 +0900
Message-ID: <1284392244-27100-12-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This stops pre-allocating nilfs object in nilfs_get_sb routine, and
stops managing its life cycle by reference counting.

nilfs_find_or_create_nilfs() function, nilfs->ns_mount_mutex,
nilfs_objects list, and the reference counter will be removed through
the simplification.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c     |    4 +-
 fs/nilfs2/super.c     |   67 ++++++++++++++-----------------------------
 fs/nilfs2/the_nilfs.c |   75 +++---------------------------------------------
 fs/nilfs2/the_nilfs.h |   16 +---------
 4 files changed, 31 insertions(+), 131 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index f0a99bd..85274f0 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -118,7 +118,7 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 	if (copy_from_user(&cpmode, argp, sizeof(cpmode)))
 		goto out;
 
-	mutex_lock(&nilfs->ns_mount_mutex);
+	down_read(&inode->i_sb->s_umount);
 
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	ret = nilfs_cpfile_change_cpmode(
@@ -128,7 +128,7 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 	else
 		nilfs_transaction_commit(inode->i_sb); /* never fails */
 
-	mutex_unlock(&nilfs->ns_mount_mutex);
+	up_read(&inode->i_sb->s_umount);
 out:
 	mnt_drop_write(filp->f_path.mnt);
 	return ret;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index bd2eb42..411ee2e 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -359,7 +359,7 @@ static void nilfs_put_super(struct super_block *sb)
 		up_write(&nilfs->ns_sem);
 	}
 
-	put_nilfs(sbi->s_nilfs);
+	destroy_nilfs(nilfs);
 	sbi->s_super = NULL;
 	sb->s_fs_info = NULL;
 	kfree(sbi);
@@ -841,15 +841,14 @@ static int nilfs_try_to_shrink_tree(struct dentry *root_dentry)
  * @sb: super_block
  * @data: mount options
  * @silent: silent mode flag
- * @nilfs: the_nilfs struct
  *
  * This function is called exclusively by nilfs->ns_mount_mutex.
  * So, the recovery process is protected from other simultaneous mounts.
  */
 static int
-nilfs_fill_super(struct super_block *sb, void *data, int silent,
-		 struct the_nilfs *nilfs)
+nilfs_fill_super(struct super_block *sb, void *data, int silent)
 {
+	struct the_nilfs *nilfs;
 	struct nilfs_sb_info *sbi;
 	struct nilfs_root *fsroot;
 	__u64 cno;
@@ -860,14 +859,18 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 		return -ENOMEM;
 
 	sb->s_fs_info = sbi;
+	sbi->s_super = sb;
 
-	get_nilfs(nilfs);
+	nilfs = alloc_nilfs(sb->s_bdev);
+	if (!nilfs) {
+		err = -ENOMEM;
+		goto failed_sbi;
+	}
 	sbi->s_nilfs = nilfs;
-	sbi->s_super = sb;
 
 	err = init_nilfs(nilfs, sbi, (char *)data);
 	if (err)
-		goto failed_sbi;
+		goto failed_nilfs;
 
 	spin_lock_init(&sbi->s_inode_lock);
 	INIT_LIST_HEAD(&sbi->s_dirty_files);
@@ -890,14 +893,14 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 
 	err = load_nilfs(nilfs, sbi);
 	if (err)
-		goto failed_sbi;
+		goto failed_nilfs;
 
 	cno = nilfs_last_cno(nilfs);
 	err = nilfs_attach_checkpoint(sbi, cno, true, &fsroot);
 	if (err) {
 		printk(KERN_ERR "NILFS: error loading last checkpoint "
 		       "(checkpoint number=%llu).\n", (unsigned long long)cno);
-		goto failed_sbi;
+		goto failed_nilfs;
 	}
 
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -926,8 +929,10 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
  failed_checkpoint:
 	nilfs_put_root(fsroot);
 
+ failed_nilfs:
+	destroy_nilfs(nilfs);
+
  failed_sbi:
-	put_nilfs(nilfs);
 	sb->s_fs_info = NULL;
 	kfree(sbi);
 	return err;
@@ -1086,7 +1091,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	struct nilfs_super_data sd;
 	struct super_block *s;
 	fmode_t mode = FMODE_READ;
-	struct the_nilfs *nilfs;
 	struct dentry *root_dentry;
 	int err, s_new = false;
 
@@ -1104,18 +1108,10 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 		goto failed;
 	}
 
-	nilfs = find_or_create_nilfs(sd.bdev);
-	if (!nilfs) {
-		err = -ENOMEM;
-		goto failed;
-	}
-
-	mutex_lock(&nilfs->ns_mount_mutex);
-
 	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, sd.bdev);
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
-		goto failed_unlock;
+		goto failed;
 	}
 
 	if (!s->s_root) {
@@ -1129,10 +1125,9 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 		strlcpy(s->s_id, bdevname(sd.bdev, b), sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(sd.bdev));
 
-		err = nilfs_fill_super(s, data, flags & MS_SILENT ? 1 : 0,
-				       nilfs);
+		err = nilfs_fill_super(s, data, flags & MS_SILENT ? 1 : 0);
 		if (err)
-			goto cancel_new;
+			goto failed_super;
 
 		s->s_flags |= MS_ACTIVE;
 	} else if (!sd.cno) {
@@ -1162,17 +1157,12 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 
 	if (sd.cno) {
 		err = nilfs_attach_snapshot(s, sd.cno, &root_dentry);
-		if (err) {
-			if (s_new)
-				goto cancel_new;
+		if (err)
 			goto failed_super;
-		}
 	} else {
 		root_dentry = dget(s->s_root);
 	}
 
-	mutex_unlock(&nilfs->ns_mount_mutex);
-	put_nilfs(nilfs);
 	if (!s_new)
 		close_bdev_exclusive(sd.bdev, mode);
 
@@ -1182,24 +1172,11 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 
  failed_super:
 	deactivate_locked_super(s);
- failed_unlock:
-	mutex_unlock(&nilfs->ns_mount_mutex);
-	put_nilfs(nilfs);
- failed:
-	close_bdev_exclusive(sd.bdev, mode);
 
-	return err;
+ failed:
+	if (!s_new)
+		close_bdev_exclusive(sd.bdev, mode);
 
- cancel_new:
-	/* Abandoning the newly allocated superblock */
-	mutex_unlock(&nilfs->ns_mount_mutex);
-	put_nilfs(nilfs);
-	deactivate_locked_super(s);
-	/*
-	 * This deactivate_locked_super() invokes close_bdev_exclusive().
-	 * We must finish all post-cleaning before this call;
-	 * put_nilfs() needs the block device.
-	 */
 	return err;
 }
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index e8d950d..bc9a3e2 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -35,9 +35,6 @@
 #include "segbuf.h"
 
 
-static LIST_HEAD(nilfs_objects);
-static DEFINE_SPINLOCK(nilfs_lock);
-
 static int nilfs_valid_sb(struct nilfs_super_block *sbp);
 
 void nilfs_set_last_segment(struct the_nilfs *nilfs,
@@ -61,16 +58,13 @@ void nilfs_set_last_segment(struct the_nilfs *nilfs,
 }
 
 /**
- * alloc_nilfs - allocate the_nilfs structure
+ * alloc_nilfs - allocate a nilfs object
  * @bdev: block device to which the_nilfs is related
  *
- * alloc_nilfs() allocates memory for the_nilfs and
- * initializes its reference count and locks.
- *
  * Return Value: On success, pointer to the_nilfs is returned.
  * On error, NULL is returned.
  */
-static struct the_nilfs *alloc_nilfs(struct block_device *bdev)
+struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 {
 	struct the_nilfs *nilfs;
 
@@ -79,12 +73,9 @@ static struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 		return NULL;
 
 	nilfs->ns_bdev = bdev;
-	atomic_set(&nilfs->ns_count, 1);
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
-	mutex_init(&nilfs->ns_mount_mutex);
 	init_rwsem(&nilfs->ns_writer_sem);
-	INIT_LIST_HEAD(&nilfs->ns_list);
 	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_cptree = RB_ROOT;
@@ -95,67 +86,11 @@ static struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 }
 
 /**
- * find_or_create_nilfs - find or create nilfs object
- * @bdev: block device to which the_nilfs is related
- *
- * find_nilfs() looks up an existent nilfs object created on the
- * device and gets the reference count of the object.  If no nilfs object
- * is found on the device, a new nilfs object is allocated.
- *
- * Return Value: On success, pointer to the nilfs object is returned.
- * On error, NULL is returned.
- */
-struct the_nilfs *find_or_create_nilfs(struct block_device *bdev)
-{
-	struct the_nilfs *nilfs, *new = NULL;
-
- retry:
-	spin_lock(&nilfs_lock);
-	list_for_each_entry(nilfs, &nilfs_objects, ns_list) {
-		if (nilfs->ns_bdev == bdev) {
-			get_nilfs(nilfs);
-			spin_unlock(&nilfs_lock);
-			if (new)
-				put_nilfs(new);
-			return nilfs; /* existing object */
-		}
-	}
-	if (new) {
-		list_add_tail(&new->ns_list, &nilfs_objects);
-		spin_unlock(&nilfs_lock);
-		return new; /* new object */
-	}
-	spin_unlock(&nilfs_lock);
-
-	new = alloc_nilfs(bdev);
-	if (new)
-		goto retry;
-	return NULL; /* insufficient memory */
-}
-
-/**
- * put_nilfs - release a reference to the_nilfs
- * @nilfs: the_nilfs structure to be released
- *
- * put_nilfs() decrements a reference counter of the_nilfs.
- * If the reference count reaches zero, the_nilfs is freed.
+ * destroy_nilfs - destroy nilfs object
+ * @nilfs: nilfs object to be released
  */
-void put_nilfs(struct the_nilfs *nilfs)
+void destroy_nilfs(struct the_nilfs *nilfs)
 {
-	spin_lock(&nilfs_lock);
-	if (!atomic_dec_and_test(&nilfs->ns_count)) {
-		spin_unlock(&nilfs_lock);
-		return;
-	}
-	list_del_init(&nilfs->ns_list);
-	spin_unlock(&nilfs_lock);
-
-	/*
-	 * Increment of ns_count never occurs below because the caller
-	 * of get_nilfs() holds at least one reference to the_nilfs.
-	 * Thus its exclusion control is not required here.
-	 */
-
 	might_sleep();
 	if (nilfs_loaded(nilfs)) {
 		nilfs_mdt_destroy(nilfs->ns_sufile);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 7b43693..1908dc7 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -46,13 +46,10 @@ enum {
 /**
  * struct the_nilfs - struct to supervise multiple nilfs mount points
  * @ns_flags: flags
- * @ns_count: reference count
- * @ns_list: list head for nilfs_list
  * @ns_bdev: block device
  * @ns_bdi: backing dev info
  * @ns_writer: back pointer to writable nilfs_sb_info
  * @ns_sem: semaphore for shared states
- * @ns_mount_mutex: mutex protecting mount process of nilfs
  * @ns_writer_sem: semaphore protecting ns_writer attach/detach
  * @ns_sbh: buffer heads of on-disk super blocks
  * @ns_sbp: pointers to super block data
@@ -94,14 +91,11 @@ enum {
  */
 struct the_nilfs {
 	unsigned long		ns_flags;
-	atomic_t		ns_count;
-	struct list_head	ns_list;
 
 	struct block_device    *ns_bdev;
 	struct backing_dev_info *ns_bdi;
 	struct nilfs_sb_info   *ns_writer;
 	struct rw_semaphore	ns_sem;
-	struct mutex		ns_mount_mutex;
 	struct rw_semaphore	ns_writer_sem;
 
 	/*
@@ -239,8 +233,8 @@ static inline int nilfs_sb_will_flip(struct the_nilfs *nilfs)
 }
 
 void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
-struct the_nilfs *find_or_create_nilfs(struct block_device *);
-void put_nilfs(struct the_nilfs *);
+struct the_nilfs *alloc_nilfs(struct block_device *bdev);
+void destroy_nilfs(struct the_nilfs *nilfs);
 int init_nilfs(struct the_nilfs *, struct nilfs_sb_info *, char *);
 int load_nilfs(struct the_nilfs *, struct nilfs_sb_info *);
 int nilfs_discard_segments(struct the_nilfs *, __u64 *, size_t);
@@ -256,12 +250,6 @@ void nilfs_fall_back_super_block(struct the_nilfs *);
 void nilfs_swap_super_block(struct the_nilfs *);
 
 
-static inline void get_nilfs(struct the_nilfs *nilfs)
-{
-	/* Caller must have at least one reference of the_nilfs. */
-	atomic_inc(&nilfs->ns_count);
-}
-
 static inline void nilfs_get_root(struct nilfs_root *root)
 {
 	atomic_inc(&root->count);
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
