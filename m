From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 5/6] nilfs2: correct exclusion control in nilfs_remount function
Date: Mon,  8 Jun 2009 01:39:32 +0900
Message-ID: <1244392773-14230-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

nilfs_remount() changes mount state of a superblock instance.  Even
though nilfs accesses other superblock instances during mount or
remount, the mount state was not properly protected in
nilfs_remount().

Moreover, nilfs_remount() has a lock order reversal problem;
nilfs_get_sb() holds:

  1. bdev->bd_mount_sem
  2. sb->s_umount  (sget acquires)

and nilfs_remount() holds:

  1. sb->s_umount  (locked by the caller in vfs)
  2. bdev->bd_mount_sem

To avoid these problems, this patch divides a semaphore protecting
super block instances from nilfs->ns_sem, and applies it to the mount
state protection in nilfs_remount().

With this change, bd_mount_sem use is removed from nilfs_remount() and
the lock order reversal will be resolved.  And the new rw-semaphore,
nilfs->ns_super_sem will properly protect the mount state except the
modification from nilfs_error function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/super.c     |   44 ++++++++++++++++++++------------------------
 fs/nilfs2/the_nilfs.c |   13 +++++++------
 fs/nilfs2/the_nilfs.h |    7 ++++++-
 3 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7370bc5..aa658c3 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -321,10 +321,10 @@ static void nilfs_put_super(struct super_block *sb)
 		nilfs_commit_super(sbi, 1);
 		up_write(&nilfs->ns_sem);
 	}
-	down_write(&nilfs->ns_sem);
+	down_write(&nilfs->ns_super_sem);
 	if (nilfs->ns_current == sbi)
 		nilfs->ns_current = NULL;
-	up_write(&nilfs->ns_sem);
+	up_write(&nilfs->ns_super_sem);
 
 	nilfs_detach_checkpoint(sbi);
 	put_nilfs(sbi->s_nilfs);
@@ -398,9 +398,9 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
 	struct buffer_head *bh_cp;
 	int err;
 
-	down_write(&nilfs->ns_sem);
+	down_write(&nilfs->ns_super_sem);
 	list_add(&sbi->s_list, &nilfs->ns_supers);
-	up_write(&nilfs->ns_sem);
+	up_write(&nilfs->ns_super_sem);
 
 	sbi->s_ifile = nilfs_mdt_new(
 		nilfs, sbi->s_super, NILFS_IFILE_INO, NILFS_IFILE_GFP);
@@ -438,9 +438,9 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
 	nilfs_mdt_destroy(sbi->s_ifile);
 	sbi->s_ifile = NULL;
 
-	down_write(&nilfs->ns_sem);
+	down_write(&nilfs->ns_super_sem);
 	list_del_init(&sbi->s_list);
-	up_write(&nilfs->ns_sem);
+	up_write(&nilfs->ns_super_sem);
 
 	return err;
 }
@@ -452,9 +452,9 @@ void nilfs_detach_checkpoint(struct nilfs_sb_info *sbi)
 	nilfs_mdt_clear(sbi->s_ifile);
 	nilfs_mdt_destroy(sbi->s_ifile);
 	sbi->s_ifile = NULL;
-	down_write(&nilfs->ns_sem);
+	down_write(&nilfs->ns_super_sem);
 	list_del_init(&sbi->s_list);
-	up_write(&nilfs->ns_sem);
+	up_write(&nilfs->ns_super_sem);
 }
 
 static int nilfs_mark_recovery_complete(struct nilfs_sb_info *sbi)
@@ -873,10 +873,10 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 		goto failed_root;
 	}
 
-	down_write(&nilfs->ns_sem);
+	down_write(&nilfs->ns_super_sem);
 	if (!nilfs_test_opt(sbi, SNAPSHOT))
 		nilfs->ns_current = sbi;
-	up_write(&nilfs->ns_sem);
+	up_write(&nilfs->ns_super_sem);
 
 	return 0;
 
@@ -906,6 +906,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	struct nilfs_mount_options old_opts;
 	int err;
 
+	down_write(&nilfs->ns_super_sem);
 	old_sb_flags = sb->s_flags;
 	old_opts.mount_opt = sbi->s_mount_opt;
 	old_opts.snapshot_cno = sbi->s_snapshot_cno;
@@ -953,24 +954,20 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		 * store the current valid flag.  (It may have been changed
 		 * by fsck since we originally mounted the partition.)
 		 */
-		down(&sb->s_bdev->bd_mount_sem);
-		down_read(&nilfs->ns_sem);
 		if (nilfs->ns_current && nilfs->ns_current != sbi) {
 			printk(KERN_WARNING "NILFS (device %s): couldn't "
 			       "remount because an RW-mount exists.\n",
 			       sb->s_id);
-			up_read(&nilfs->ns_sem);
 			err = -EBUSY;
-			goto rw_remount_failed;
+			goto restore_opts;
 		}
-		up_read(&nilfs->ns_sem);
 		if (sbi->s_snapshot_cno != nilfs_last_cno(nilfs)) {
 			printk(KERN_WARNING "NILFS (device %s): couldn't "
 			       "remount because the current RO-mount is not "
 			       "the latest one.\n",
 			       sb->s_id);
 			err = -EINVAL;
-			goto rw_remount_failed;
+			goto restore_opts;
 		}
 		sb->s_flags &= ~MS_RDONLY;
 		nilfs_clear_opt(sbi, SNAPSHOT);
@@ -978,24 +975,23 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 
 		err = nilfs_attach_segment_constructor(sbi);
 		if (err)
-			goto rw_remount_failed;
+			goto restore_opts;
 
 		down_write(&nilfs->ns_sem);
 		nilfs_setup_super(sbi);
-		nilfs->ns_current = sbi;
 		up_write(&nilfs->ns_sem);
 
-		up(&sb->s_bdev->bd_mount_sem);
+		nilfs->ns_current = sbi;
 	}
  out:
+	up_write(&nilfs->ns_super_sem);
 	return 0;
 
- rw_remount_failed:
-	up(&sb->s_bdev->bd_mount_sem);
  restore_opts:
 	sb->s_flags = old_sb_flags;
 	sbi->s_mount_opt = old_opts.mount_opt;
 	sbi->s_snapshot_cno = old_opts.snapshot_cno;
+	up_write(&nilfs->ns_super_sem);
 	return err;
 }
 
@@ -1104,15 +1100,15 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 		 * (i.e. rw-mount or ro-mount), whereas rw-mount and
 		 * ro-mount are mutually exclusive.
 		 */
-		down_read(&nilfs->ns_sem);
+		down_read(&nilfs->ns_super_sem);
 		if (nilfs->ns_current &&
 		    ((nilfs->ns_current->s_super->s_flags ^ flags)
 		     & MS_RDONLY)) {
-			up_read(&nilfs->ns_sem);
+			up_read(&nilfs->ns_super_sem);
 			err = -EBUSY;
 			goto failed_unlock;
 		}
-		up_read(&nilfs->ns_sem);
+		up_read(&nilfs->ns_super_sem);
 	}
 
 	/*
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index ff8600e..fa46320 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -72,6 +72,7 @@ static struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	atomic_set(&nilfs->ns_writer_refcount, -1);
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
+	init_rwsem(&nilfs->ns_super_sem);
 	mutex_init(&nilfs->ns_writer_mutex);
 	INIT_LIST_HEAD(&nilfs->ns_list);
 	INIT_LIST_HEAD(&nilfs->ns_supers);
@@ -681,10 +682,10 @@ struct nilfs_sb_info *nilfs_find_sbinfo(struct the_nilfs *nilfs,
 {
 	struct nilfs_sb_info *sbi;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_super_sem);
 	/*
 	 * The SNAPSHOT flag and sb->s_flags are supposed to be
-	 * protected with nilfs->ns_sem.
+	 * protected with nilfs->ns_super_sem.
 	 */
 	sbi = nilfs->ns_current;
 	if (rw_mount) {
@@ -705,12 +706,12 @@ struct nilfs_sb_info *nilfs_find_sbinfo(struct the_nilfs *nilfs,
 			goto found; /* snapshot mount */
 	}
  out:
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_super_sem);
 	return NULL;
 
  found:
 	atomic_inc(&sbi->s_count);
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_super_sem);
 	return sbi;
 }
 
@@ -720,7 +721,7 @@ int nilfs_checkpoint_is_mounted(struct the_nilfs *nilfs, __u64 cno,
 	struct nilfs_sb_info *sbi;
 	int ret = 0;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_super_sem);
 	if (cno == 0 || cno > nilfs->ns_cno)
 		goto out_unlock;
 
@@ -737,6 +738,6 @@ int nilfs_checkpoint_is_mounted(struct the_nilfs *nilfs, __u64 cno,
 		ret++;
 
  out_unlock:
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_super_sem);
 	return ret;
 }
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index be4c040..d0cf4fb 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -48,6 +48,7 @@ enum {
  * @ns_bdi: backing dev info
  * @ns_writer: back pointer to writable nilfs_sb_info
  * @ns_sem: semaphore for shared states
+ * @ns_super_sem: semaphore for global operations across super block instances
  * @ns_writer_mutex: mutex protecting ns_writer attach/detach
  * @ns_writer_refcount: number of referrers on ns_writer
  * @ns_current: back pointer to current mount
@@ -96,10 +97,15 @@ struct the_nilfs {
 	struct backing_dev_info *ns_bdi;
 	struct nilfs_sb_info   *ns_writer;
 	struct rw_semaphore	ns_sem;
+	struct rw_semaphore	ns_super_sem;
 	struct mutex		ns_writer_mutex;
 	atomic_t		ns_writer_refcount;
 
+	/*
+	 * components protected by ns_super_sem
+	 */
 	struct nilfs_sb_info   *ns_current;
+	struct list_head	ns_supers;
 
 	/*
 	 * used for
@@ -113,7 +119,6 @@ struct the_nilfs {
 	time_t			ns_sbwtime[2];
 	unsigned		ns_sbsize;
 	unsigned		ns_mount_state;
-	struct list_head	ns_supers;
 
 	/*
 	 * Following fields are dedicated to a writable FS-instance.
-- 
1.6.2

