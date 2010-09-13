From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 10/23] nilfs2: do not allocate multiple super block instances for a device
Date: Tue, 14 Sep 2010 00:37:11 +0900
Message-ID: <1284392244-27100-11-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This stops allocating multiple super block instances for a device.

All snapshots and a current mode mount (i.e. latest tree) will be
controlled with nilfs_root objects that are kept within an sb
instance.

nilfs_get_sb() is rewritten so that it always has a root object for
the latest tree and snapshots make additional root objects.

The root dentry of the latest tree is binded to sb->s_root even if it
isn't attached on a directory.  Root dentries of snapshots or the
latest tree are binded to mnt->mnt_root on which they are mounted.

With this patch, nilfs_find_sbinfo() function, nilfs->ns_supers list,
and nilfs->ns_current back pointer, are deleted.  In addition,
init_nilfs() and load_nilfs() are simplified since they will be called
once for a device, not repeatedly called for mount points.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sb.h        |    5 -
 fs/nilfs2/super.c     |  216 +++++++++++++++++++++++--------------------------
 fs/nilfs2/the_nilfs.c |   89 +--------------------
 fs/nilfs2/the_nilfs.h |   16 ----
 4 files changed, 101 insertions(+), 225 deletions(-)

diff --git a/fs/nilfs2/sb.h b/fs/nilfs2/sb.h
index 3cc3675..35a0715 100644
--- a/fs/nilfs2/sb.h
+++ b/fs/nilfs2/sb.h
@@ -42,9 +42,6 @@ struct nilfs_sc_info;
  * NILFS super-block data in memory
  */
 struct nilfs_sb_info {
-	/* Snapshot status */
-	__u64 s_snapshot_cno;		/* Checkpoint number */
-
 	/* Mount options */
 	unsigned long s_mount_opt;
 	uid_t s_resuid;
@@ -57,8 +54,6 @@ struct nilfs_sb_info {
 	/* Fundamental members */
 	struct super_block *s_super;	/* reverse pointer to super_block */
 	struct the_nilfs *s_nilfs;
-	struct list_head s_list;	/* list head for nilfs->ns_supers */
-	atomic_t s_count;		/* reference count */
 
 	/* Segment constructor */
 	struct list_head s_dirty_files;	/* dirty files list */
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 0ebe4c6..bd2eb42 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -358,16 +358,11 @@ static void nilfs_put_super(struct super_block *sb)
 		nilfs_cleanup_super(sbi);
 		up_write(&nilfs->ns_sem);
 	}
-	down_write(&nilfs->ns_super_sem);
-	if (nilfs->ns_current == sbi)
-		nilfs->ns_current = NULL;
-	list_del_init(&sbi->s_list);
-	up_write(&nilfs->ns_super_sem);
 
 	put_nilfs(sbi->s_nilfs);
 	sbi->s_super = NULL;
 	sb->s_fs_info = NULL;
-	nilfs_put_sbinfo(sbi);
+	kfree(sbi);
 
 	unlock_kernel();
 }
@@ -505,12 +500,12 @@ static int nilfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
 	struct super_block *sb = vfs->mnt_sb;
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct nilfs_root *root = NILFS_I(vfs->mnt_root->d_inode)->i_root;
 
 	if (!nilfs_test_opt(sbi, BARRIER))
 		seq_puts(seq, ",nobarrier");
-	if (nilfs_test_opt(sbi, SNAPSHOT))
-		seq_printf(seq, ",cp=%llu",
-			   (unsigned long long int)sbi->s_snapshot_cno);
+	if (root->cno != NILFS_CPTREE_CURRENT_CNO)
+		seq_printf(seq, ",cp=%llu", (unsigned long long)root->cno);
 	if (nilfs_test_opt(sbi, ERRORS_PANIC))
 		seq_puts(seq, ",errors=panic");
 	if (nilfs_test_opt(sbi, ERRORS_CONT))
@@ -610,27 +605,11 @@ static int parse_options(char *options, struct super_block *sb, int is_remount)
 			if (match_int(&args[0], &option) || option <= 0)
 				return 0;
 			if (is_remount) {
-				if (!nilfs_test_opt(sbi, SNAPSHOT)) {
-					printk(KERN_ERR
-					       "NILFS: cannot change regular "
-					       "mount to snapshot.\n");
-					return 0;
-				} else if (option != sbi->s_snapshot_cno) {
-					printk(KERN_ERR
-					       "NILFS: cannot remount to a "
-					       "different snapshot.\n");
-					return 0;
-				}
-				break;
-			}
-			if (!(sb->s_flags & MS_RDONLY)) {
-				printk(KERN_ERR "NILFS: cannot mount snapshot "
-				       "read/write.  A read-only option is "
-				       "required.\n");
+				printk(KERN_ERR
+				       "NILFS: \"%s\" option is invalid "
+				       "for remount.\n", p);
 				return 0;
 			}
-			sbi->s_snapshot_cno = option;
-			nilfs_set_opt(sbi, SNAPSHOT);
 			break;
 		case Opt_norecovery:
 			nilfs_set_opt(sbi, NORECOVERY);
@@ -776,16 +755,32 @@ static int nilfs_get_root_dentry(struct super_block *sb,
 		goto out;
 	}
 
-	dentry = d_alloc_root(inode);
-	if (!dentry) {
-		iput(inode);
-		printk(KERN_ERR "NILFS: get root dentry failed\n");
-		ret = -ENOMEM;
-		goto out;
+	if (root->cno == NILFS_CPTREE_CURRENT_CNO) {
+		dentry = d_find_alias(inode);
+		if (!dentry) {
+			dentry = d_alloc_root(inode);
+			if (!dentry) {
+				iput(inode);
+				ret = -ENOMEM;
+				goto failed_dentry;
+			}
+		} else {
+			iput(inode);
+		}
+	} else {
+		dentry = d_obtain_alias(inode);
+		if (IS_ERR(dentry)) {
+			ret = PTR_ERR(dentry);
+			goto failed_dentry;
+		}
 	}
 	*root_dentry = dentry;
  out:
 	return ret;
+
+ failed_dentry:
+	printk(KERN_ERR "NILFS: get root dentry failed\n");
+	goto out;
 }
 
 static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
@@ -822,6 +817,25 @@ static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
 	return ret;
 }
 
+static int nilfs_tree_was_touched(struct dentry *root_dentry)
+{
+	return atomic_read(&root_dentry->d_count) > 1;
+}
+
+/**
+ * nilfs_try_to_shrink_tree() - try to shrink dentries of a checkpoint
+ * @root_dentry: root dentry of the tree to be shrunk
+ *
+ * This function returns true if the tree was in-use.
+ */
+static int nilfs_try_to_shrink_tree(struct dentry *root_dentry)
+{
+	if (have_submounts(root_dentry))
+		return true;
+	shrink_dcache_parent(root_dentry);
+	return nilfs_tree_was_touched(root_dentry);
+}
+
 /**
  * nilfs_fill_super() - initialize a super block instance
  * @sb: super_block
@@ -850,7 +864,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	get_nilfs(nilfs);
 	sbi->s_nilfs = nilfs;
 	sbi->s_super = sb;
-	atomic_set(&sbi->s_count, 1);
 
 	err = init_nilfs(nilfs, sbi, (char *)data);
 	if (err)
@@ -858,7 +871,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 
 	spin_lock_init(&sbi->s_inode_lock);
 	INIT_LIST_HEAD(&sbi->s_dirty_files);
-	INIT_LIST_HEAD(&sbi->s_list);
 
 	/*
 	 * Following initialization is overlapped because
@@ -880,20 +892,11 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	if (err)
 		goto failed_sbi;
 
-	if (nilfs_test_opt(sbi, SNAPSHOT)) {
-		err = nilfs_attach_snapshot(sb, sbi->s_snapshot_cno,
-					    &sb->s_root);
-		if (err)
-			goto failed_sbi;
-
-		goto add_to_supers;
-	}
-
 	cno = nilfs_last_cno(nilfs);
 	err = nilfs_attach_checkpoint(sbi, cno, true, &fsroot);
 	if (err) {
-		printk(KERN_ERR "NILFS: error loading a checkpoint"
-		       " (checkpoint number=%llu).\n", (unsigned long long)cno);
+		printk(KERN_ERR "NILFS: error loading last checkpoint "
+		       "(checkpoint number=%llu).\n", (unsigned long long)cno);
 		goto failed_sbi;
 	}
 
@@ -915,13 +918,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 		up_write(&nilfs->ns_sem);
 	}
 
- add_to_supers:
-	down_write(&nilfs->ns_super_sem);
-	list_add(&sbi->s_list, &nilfs->ns_supers);
-	if (!nilfs_test_opt(sbi, SNAPSHOT))
-		nilfs->ns_current = sbi;
-	up_write(&nilfs->ns_super_sem);
-
 	return 0;
 
  failed_segctor:
@@ -933,7 +929,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
  failed_sbi:
 	put_nilfs(nilfs);
 	sb->s_fs_info = NULL;
-	nilfs_put_sbinfo(sbi);
+	kfree(sbi);
 	return err;
 }
 
@@ -943,15 +939,12 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	unsigned long old_sb_flags;
 	struct nilfs_mount_options old_opts;
-	int was_snapshot, err;
+	int err;
 
 	lock_kernel();
 
-	down_write(&nilfs->ns_super_sem);
 	old_sb_flags = sb->s_flags;
 	old_opts.mount_opt = sbi->s_mount_opt;
-	old_opts.snapshot_cno = sbi->s_snapshot_cno;
-	was_snapshot = nilfs_test_opt(sbi, SNAPSHOT);
 
 	if (!parse_options(data, sb, 1)) {
 		err = -EINVAL;
@@ -960,11 +953,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL);
 
 	err = -EINVAL;
-	if (was_snapshot && !(*flags & MS_RDONLY)) {
-		printk(KERN_ERR "NILFS (device %s): cannot remount snapshot "
-		       "read/write.\n", sb->s_id);
-		goto restore_opts;
-	}
 
 	if (!nilfs_valid_fs(nilfs)) {
 		printk(KERN_WARNING "NILFS (device %s): couldn't "
@@ -1021,15 +1009,12 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		up_write(&nilfs->ns_sem);
 	}
  out:
-	up_write(&nilfs->ns_super_sem);
 	unlock_kernel();
 	return 0;
 
  restore_opts:
 	sb->s_flags = old_sb_flags;
 	sbi->s_mount_opt = old_opts.mount_opt;
-	sbi->s_snapshot_cno = old_opts.snapshot_cno;
-	up_write(&nilfs->ns_super_sem);
 	unlock_kernel();
 	return err;
 }
@@ -1084,18 +1069,14 @@ static int nilfs_identify(char *data, struct nilfs_super_data *sd)
 
 static int nilfs_set_bdev_super(struct super_block *s, void *data)
 {
-	struct nilfs_super_data *sd = data;
-
-	s->s_bdev = sd->bdev;
+	s->s_bdev = data;
 	s->s_dev = s->s_bdev->bd_dev;
 	return 0;
 }
 
 static int nilfs_test_bdev_super(struct super_block *s, void *data)
 {
-	struct nilfs_super_data *sd = data;
-
-	return sd->sbi && s->s_fs_info == (void *)sd->sbi;
+	return (void *)s->s_bdev == data;
 }
 
 static int
@@ -1106,7 +1087,8 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	struct super_block *s;
 	fmode_t mode = FMODE_READ;
 	struct the_nilfs *nilfs;
-	int err, need_to_close = 1;
+	struct dentry *root_dentry;
+	int err, s_new = false;
 
 	if (!(flags & MS_RDONLY))
 		mode |= FMODE_WRITE;
@@ -1115,12 +1097,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	if (IS_ERR(sd.bdev))
 		return PTR_ERR(sd.bdev);
 
-	/*
-	 * To get mount instance using sget() vfs-routine, NILFS needs
-	 * much more information than normal filesystems to identify mount
-	 * instance.  For snapshot mounts, not only a mount type (ro-mount
-	 * or rw-mount) but also a checkpoint number is required.
-	 */
 	sd.cno = 0;
 	sd.flags = flags;
 	if (nilfs_identify((char *)data, &sd)) {
@@ -1136,38 +1112,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 
 	mutex_lock(&nilfs->ns_mount_mutex);
 
-	if (!sd.cno) {
-		/*
-		 * Check if an exclusive mount exists or not.
-		 * Snapshot mounts coexist with a current mount
-		 * (i.e. rw-mount or ro-mount), whereas rw-mount and
-		 * ro-mount are mutually exclusive.
-		 */
-		down_read(&nilfs->ns_super_sem);
-		if (nilfs->ns_current &&
-		    ((nilfs->ns_current->s_super->s_flags ^ flags)
-		     & MS_RDONLY)) {
-			up_read(&nilfs->ns_super_sem);
-			err = -EBUSY;
-			goto failed_unlock;
-		}
-		up_read(&nilfs->ns_super_sem);
-	}
-
-	/*
-	 * Find existing nilfs_sb_info struct
-	 */
-	sd.sbi = nilfs_find_sbinfo(nilfs, !(flags & MS_RDONLY), sd.cno);
-
-	/*
-	 * Get super block instance holding the nilfs_sb_info struct.
-	 * A new instance is allocated if no existing mount is present or
-	 * existing instance has been unmounted.
-	 */
-	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, &sd);
-	if (sd.sbi)
-		nilfs_put_sbinfo(sd.sbi);
-
+	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, sd.bdev);
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
 		goto failed_unlock;
@@ -1176,6 +1121,8 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	if (!s->s_root) {
 		char b[BDEVNAME_SIZE];
 
+		s_new = true;
+
 		/* New superblock instance created */
 		s->s_flags = flags;
 		s->s_mode = mode;
@@ -1188,16 +1135,53 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 			goto cancel_new;
 
 		s->s_flags |= MS_ACTIVE;
-		need_to_close = 0;
+	} else if (!sd.cno) {
+		int busy = false;
+
+		if (nilfs_tree_was_touched(s->s_root)) {
+			busy = nilfs_try_to_shrink_tree(s->s_root);
+			if (busy && (flags ^ s->s_flags) & MS_RDONLY) {
+				printk(KERN_ERR "NILFS: the device already "
+				       "has a %s mount.\n",
+				       (s->s_flags & MS_RDONLY) ?
+				       "read-only" : "read/write");
+				err = -EBUSY;
+				goto failed_super;
+			}
+		}
+		if (!busy) {
+			/*
+			 * Try remount to setup mount states if the current
+			 * tree is not mounted and only snapshots use this sb.
+			 */
+			err = nilfs_remount(s, &flags, data);
+			if (err)
+				goto failed_super;
+		}
+	}
+
+	if (sd.cno) {
+		err = nilfs_attach_snapshot(s, sd.cno, &root_dentry);
+		if (err) {
+			if (s_new)
+				goto cancel_new;
+			goto failed_super;
+		}
+	} else {
+		root_dentry = dget(s->s_root);
 	}
 
 	mutex_unlock(&nilfs->ns_mount_mutex);
 	put_nilfs(nilfs);
-	if (need_to_close)
+	if (!s_new)
 		close_bdev_exclusive(sd.bdev, mode);
-	simple_set_mnt(mnt, s);
+
+	mnt->mnt_sb = s;
+	mnt->mnt_root = root_dentry;
 	return 0;
 
+ failed_super:
+	deactivate_locked_super(s);
  failed_unlock:
 	mutex_unlock(&nilfs->ns_mount_mutex);
 	put_nilfs(nilfs);
@@ -1212,7 +1196,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	put_nilfs(nilfs);
 	deactivate_locked_super(s);
 	/*
-	 * deactivate_locked_super() invokes close_bdev_exclusive().
+	 * This deactivate_locked_super() invokes close_bdev_exclusive().
 	 * We must finish all post-cleaning before this call;
 	 * put_nilfs() needs the block device.
 	 */
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 3bb1579..e8d950d 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -82,11 +82,9 @@ static struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	atomic_set(&nilfs->ns_count, 1);
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
-	init_rwsem(&nilfs->ns_super_sem);
 	mutex_init(&nilfs->ns_mount_mutex);
 	init_rwsem(&nilfs->ns_writer_sem);
 	INIT_LIST_HEAD(&nilfs->ns_list);
-	INIT_LIST_HEAD(&nilfs->ns_supers);
 	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_cptree = RB_ROOT;
@@ -307,15 +305,6 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	int valid_fs = nilfs_valid_fs(nilfs);
 	int err;
 
-	if (nilfs_loaded(nilfs)) {
-		if (valid_fs ||
-		    ((s_flags & MS_RDONLY) && nilfs_test_opt(sbi, NORECOVERY)))
-			return 0;
-		printk(KERN_ERR "NILFS: the filesystem is in an incomplete "
-		       "recovery state.\n");
-		return -EINVAL;
-	}
-
 	if (!valid_fs) {
 		printk(KERN_WARNING "NILFS warning: mounting unchecked fs\n");
 		if (s_flags & MS_RDONLY) {
@@ -632,12 +621,7 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
  *
  * init_nilfs() performs common initialization per block device (e.g.
  * reading the super block, getting disk layout information, initializing
- * shared fields in the_nilfs). It takes on some portion of the jobs
- * typically done by a fill_super() routine. This division arises from
- * the nature that multiple NILFS instances may be simultaneously
- * mounted on a device.
- * For multiple mounts on the same device, only the first mount
- * invokes these tasks.
+ * shared fields in the_nilfs).
  *
  * Return Value: On success, 0 is returned. On error, a negative error
  * code is returned.
@@ -651,27 +635,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 	int err;
 
 	down_write(&nilfs->ns_sem);
-	if (nilfs_init(nilfs)) {
-		/* Load values from existing the_nilfs */
-		sbp = nilfs->ns_sbp[0];
-		err = nilfs_store_magic_and_option(sb, sbp, data);
-		if (err)
-			goto out;
-
-		err = nilfs_check_feature_compatibility(sb, sbp);
-		if (err)
-			goto out;
-
-		blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
-		if (sb->s_blocksize != blocksize &&
-		    !sb_set_blocksize(sb, blocksize)) {
-			printk(KERN_ERR "NILFS: blocksize %d unfit to device\n",
-			       blocksize);
-			err = -EINVAL;
-		}
-		sb->s_maxbytes = nilfs_max_size(sb->s_blocksize_bits);
-		goto out;
-	}
 
 	blocksize = sb_min_blocksize(sb, NILFS_MIN_BLOCK_SIZE);
 	if (!blocksize) {
@@ -901,56 +864,6 @@ void nilfs_put_root(struct nilfs_root *root)
 	}
 }
 
-/**
- * nilfs_find_sbinfo - find existing nilfs_sb_info structure
- * @nilfs: nilfs object
- * @rw_mount: mount type (non-zero value for read/write mount)
- * @cno: checkpoint number (zero for read-only mount)
- *
- * nilfs_find_sbinfo() returns the nilfs_sb_info structure which
- * @rw_mount and @cno (in case of snapshots) matched.  If no instance
- * was found, NULL is returned.  Although the super block instance can
- * be unmounted after this function returns, the nilfs_sb_info struct
- * is kept on memory until nilfs_put_sbinfo() is called.
- */
-struct nilfs_sb_info *nilfs_find_sbinfo(struct the_nilfs *nilfs,
-					int rw_mount, __u64 cno)
-{
-	struct nilfs_sb_info *sbi;
-
-	down_read(&nilfs->ns_super_sem);
-	/*
-	 * The SNAPSHOT flag and sb->s_flags are supposed to be
-	 * protected with nilfs->ns_super_sem.
-	 */
-	sbi = nilfs->ns_current;
-	if (rw_mount) {
-		if (sbi && !(sbi->s_super->s_flags & MS_RDONLY))
-			goto found; /* read/write mount */
-		else
-			goto out;
-	} else if (cno == 0) {
-		if (sbi && (sbi->s_super->s_flags & MS_RDONLY))
-			goto found; /* read-only mount */
-		else
-			goto out;
-	}
-
-	list_for_each_entry(sbi, &nilfs->ns_supers, s_list) {
-		if (nilfs_test_opt(sbi, SNAPSHOT) &&
-		    sbi->s_snapshot_cno == cno)
-			goto found; /* snapshot mount */
-	}
- out:
-	up_read(&nilfs->ns_super_sem);
-	return NULL;
-
- found:
-	atomic_inc(&sbi->s_count);
-	up_read(&nilfs->ns_super_sem);
-	return sbi;
-}
-
 int nilfs_checkpoint_is_mounted(struct the_nilfs *nilfs, __u64 cno,
 				int snapshot_mount)
 {
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 0afede6..7b43693 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -52,16 +52,13 @@ enum {
  * @ns_bdi: backing dev info
  * @ns_writer: back pointer to writable nilfs_sb_info
  * @ns_sem: semaphore for shared states
- * @ns_super_sem: semaphore for global operations across super block instances
  * @ns_mount_mutex: mutex protecting mount process of nilfs
  * @ns_writer_sem: semaphore protecting ns_writer attach/detach
- * @ns_current: back pointer to current mount
  * @ns_sbh: buffer heads of on-disk super blocks
  * @ns_sbp: pointers to super block data
  * @ns_sbwtime: previous write time of super block
  * @ns_sbwcount: write count of super block
  * @ns_sbsize: size of valid data in super block
- * @ns_supers: list of nilfs super block structs
  * @ns_seg_seq: segment sequence counter
  * @ns_segnum: index number of the latest full segment.
  * @ns_nextnum: index number of the full segment index to be used next
@@ -104,17 +101,10 @@ struct the_nilfs {
 	struct backing_dev_info *ns_bdi;
 	struct nilfs_sb_info   *ns_writer;
 	struct rw_semaphore	ns_sem;
-	struct rw_semaphore	ns_super_sem;
 	struct mutex		ns_mount_mutex;
 	struct rw_semaphore	ns_writer_sem;
 
 	/*
-	 * components protected by ns_super_sem
-	 */
-	struct nilfs_sb_info   *ns_current;
-	struct list_head	ns_supers;
-
-	/*
 	 * used for
 	 * - loading the latest checkpoint exclusively.
 	 * - allocating a new full segment.
@@ -294,12 +284,6 @@ nilfs_detach_writer(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	up_write(&nilfs->ns_writer_sem);
 }
 
-static inline void nilfs_put_sbinfo(struct nilfs_sb_info *sbi)
-{
-	if (atomic_dec_and_test(&sbi->s_count))
-		kfree(sbi);
-}
-
 static inline int nilfs_valid_fs(struct the_nilfs *nilfs)
 {
 	unsigned valid_fs;
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
