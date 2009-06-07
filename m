From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 2/6] nilfs2: get rid of sget use for acquiring nilfs object
Date: Mon,  8 Jun 2009 01:39:29 +0900
Message-ID: <1244392773-14230-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This will change the way to obtain nilfs object in nilfs_get_sb()
function.

Previously, a preliminary sget() call was performed, and the nilfs
object was acquired from a super block instance found by the sget()
call.

This patch, instead, instroduces a new dedicated function
find_or_create_nilfs(); as the name implies, the function finds an
existent nilfs object from a global list or creates a new one if no
object is found on the device.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/nilfs2/super.c     |   80 +++++++++++-------------------------------------
 fs/nilfs2/the_nilfs.c |   57 +++++++++++++++++++++++++++++++++--
 fs/nilfs2/the_nilfs.h |    4 ++-
 3 files changed, 76 insertions(+), 65 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8131615..bdb479a 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1047,13 +1047,6 @@ static int nilfs_set_bdev_super(struct super_block *s, void *data)
 static int nilfs_test_bdev_super(struct super_block *s, void *data)
 {
 	struct nilfs_super_data *sd = data;
-
-	return s->s_bdev == sd->bdev;
-}
-
-static int nilfs_test_bdev_super2(struct super_block *s, void *data)
-{
-	struct nilfs_super_data *sd = data;
 	int ret;
 
 	if (s->s_bdev != sd->bdev)
@@ -1082,8 +1075,8 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	     const char *dev_name, void *data, struct vfsmount *mnt)
 {
 	struct nilfs_super_data sd;
-	struct super_block *s, *s2;
-	struct the_nilfs *nilfs = NULL;
+	struct super_block *s;
+	struct the_nilfs *nilfs;
 	int err, need_to_close = 1;
 
 	sd.bdev = open_bdev_exclusive(dev_name, flags, fs_type);
@@ -1104,11 +1097,12 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 		goto failed;
 	}
 
-	/*
-	 * once the super is inserted into the list by sget, s_umount
-	 * will protect the lockfs code from trying to start a snapshot
-	 * while we are mounting
-	 */
+	nilfs = find_or_create_nilfs(sd.bdev);
+	if (!nilfs) {
+		err = -ENOMEM;
+		goto failed;
+	}
+
 	down(&sd.bdev->bd_mount_sem);
 	if (!sd.cno &&
 	    (err = test_exclusive_mount(fs_type, sd.bdev, flags ^ MS_RDONLY))) {
@@ -1117,51 +1111,22 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	}
 
 	/*
-	 * Phase-1: search any existent instance and get the_nilfs
+	 * Search specified snapshot or R/W mode super_block
 	 */
-	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, &sd);
-	if (IS_ERR(s))
-		goto error_s;
-
-	if (!s->s_root) {
-		err = -ENOMEM;
-		nilfs = alloc_nilfs(sd.bdev);
-		if (!nilfs)
-			goto cancel_new;
-	} else {
-		struct nilfs_sb_info *sbi = NILFS_SB(s);
+	if (!sd.cno)
+		/* trying to get the latest checkpoint.  */
+		sd.cno = nilfs_last_cno(nilfs);
 
-		/*
-		 * s_umount protects super_block from unmount process;
-		 * It covers pointers of nilfs_sb_info and the_nilfs.
-		 */
-		nilfs = sbi->s_nilfs;
-		get_nilfs(nilfs);
-		up_write(&s->s_umount);
-
-		/*
-		 * Phase-2: search specified snapshot or R/W mode super_block
-		 */
-		if (!sd.cno)
-			/* trying to get the latest checkpoint.  */
-			sd.cno = nilfs_last_cno(nilfs);
-
-		s2 = sget(fs_type, nilfs_test_bdev_super2,
-			  nilfs_set_bdev_super, &sd);
-		deactivate_super(s);
-		/*
-		 * Although deactivate_super() invokes close_bdev_exclusive() at
-		 * kill_block_super().  Here, s is an existent mount; we need
-		 * one more close_bdev_exclusive() call.
-		 */
-		s = s2;
-		if (IS_ERR(s))
-			goto error_s;
+	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, &sd);
+	if (IS_ERR(s)) {
+		err = PTR_ERR(s);
+		goto failed_unlock;
 	}
 
 	if (!s->s_root) {
 		char b[BDEVNAME_SIZE];
 
+		/* New superblock instance created */
 		s->s_flags = flags;
 		strlcpy(s->s_id, bdevname(sd.bdev, b), sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(sd.bdev));
@@ -1181,15 +1146,9 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	simple_set_mnt(mnt, s);
 	return 0;
 
- error_s:
-	up(&sd.bdev->bd_mount_sem);
-	if (nilfs)
-		put_nilfs(nilfs);
-	close_bdev_exclusive(sd.bdev, flags);
-	return PTR_ERR(s);
-
  failed_unlock:
 	up(&sd.bdev->bd_mount_sem);
+	put_nilfs(nilfs);
  failed:
 	close_bdev_exclusive(sd.bdev, flags);
 
@@ -1198,8 +1157,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
  cancel_new:
 	/* Abandoning the newly allocated superblock */
 	up(&sd.bdev->bd_mount_sem);
-	if (nilfs)
-		put_nilfs(nilfs);
+	put_nilfs(nilfs);
 	up_write(&s->s_umount);
 	deactivate_super(s);
 	/*
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 7f65b3b..92ff3b1 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -35,6 +35,10 @@
 #include "seglist.h"
 #include "segbuf.h"
 
+
+static LIST_HEAD(nilfs_objects);
+static DEFINE_SPINLOCK(nilfs_lock);
+
 void nilfs_set_last_segment(struct the_nilfs *nilfs,
 			    sector_t start_blocknr, u64 seq, __u64 cno)
 {
@@ -55,7 +59,7 @@ void nilfs_set_last_segment(struct the_nilfs *nilfs,
  * Return Value: On success, pointer to the_nilfs is returned.
  * On error, NULL is returned.
  */
-struct the_nilfs *alloc_nilfs(struct block_device *bdev)
+static struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 {
 	struct the_nilfs *nilfs;
 
@@ -69,6 +73,7 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
 	mutex_init(&nilfs->ns_writer_mutex);
+	INIT_LIST_HEAD(&nilfs->ns_list);
 	INIT_LIST_HEAD(&nilfs->ns_supers);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_gc_inodes_h = NULL;
@@ -78,6 +83,45 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 }
 
 /**
+ * find_or_create_nilfs - find or create nilfs object
+ * @bdev: block device to which the_nilfs is related
+ *
+ * find_nilfs() looks up an existent nilfs object created on the
+ * device and gets the reference count of the object.  If no nilfs object
+ * is found on the device, a new nilfs object is allocated.
+ *
+ * Return Value: On success, pointer to the nilfs object is returned.
+ * On error, NULL is returned.
+ */
+struct the_nilfs *find_or_create_nilfs(struct block_device *bdev)
+{
+	struct the_nilfs *nilfs, *new = NULL;
+
+ retry:
+	spin_lock(&nilfs_lock);
+	list_for_each_entry(nilfs, &nilfs_objects, ns_list) {
+		if (nilfs->ns_bdev == bdev) {
+			get_nilfs(nilfs);
+			spin_unlock(&nilfs_lock);
+			if (new)
+				put_nilfs(new);
+			return nilfs; /* existing object */
+		}
+	}
+	if (new) {
+		list_add_tail(&new->ns_list, &nilfs_objects);
+		spin_unlock(&nilfs_lock);
+		return new; /* new object */
+	}
+	spin_unlock(&nilfs_lock);
+
+	new = alloc_nilfs(bdev);
+	if (new)
+		goto retry;
+	return NULL; /* insufficient memory */
+}
+
+/**
  * put_nilfs - release a reference to the_nilfs
  * @nilfs: the_nilfs structure to be released
  *
@@ -86,13 +130,20 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
  */
 void put_nilfs(struct the_nilfs *nilfs)
 {
-	if (!atomic_dec_and_test(&nilfs->ns_count))
+	spin_lock(&nilfs_lock);
+	if (!atomic_dec_and_test(&nilfs->ns_count)) {
+		spin_unlock(&nilfs_lock);
 		return;
+	}
+	list_del_init(&nilfs->ns_list);
+	spin_unlock(&nilfs_lock);
+
 	/*
-	 * Increment of ns_count never occur below because the caller
+	 * Increment of ns_count never occurs below because the caller
 	 * of get_nilfs() holds at least one reference to the_nilfs.
 	 * Thus its exclusion control is not required here.
 	 */
+
 	might_sleep();
 	if (nilfs_loaded(nilfs)) {
 		nilfs_mdt_clear(nilfs->ns_sufile);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 30fe587..116caf9 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -43,6 +43,7 @@ enum {
  * struct the_nilfs - struct to supervise multiple nilfs mount points
  * @ns_flags: flags
  * @ns_count: reference count
+ * @ns_list: list head for nilfs_list
  * @ns_bdev: block device
  * @ns_bdi: backing dev info
  * @ns_writer: back pointer to writable nilfs_sb_info
@@ -88,6 +89,7 @@ enum {
 struct the_nilfs {
 	unsigned long		ns_flags;
 	atomic_t		ns_count;
+	struct list_head	ns_list;
 
 	struct block_device    *ns_bdev;
 	struct backing_dev_info *ns_bdi;
@@ -191,7 +193,7 @@ THE_NILFS_FNS(DISCONTINUED, discontinued)
 #define NILFS_ALTSB_FREQ	60  /* spare superblock */
 
 void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
-struct the_nilfs *alloc_nilfs(struct block_device *);
+struct the_nilfs *find_or_create_nilfs(struct block_device *);
 void put_nilfs(struct the_nilfs *);
 int init_nilfs(struct the_nilfs *, struct nilfs_sb_info *, char *);
 int load_nilfs(struct the_nilfs *, struct nilfs_sb_info *);
-- 
1.6.2

