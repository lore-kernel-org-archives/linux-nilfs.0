From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 6/6] nilfs2: get rid of bd_mount_sem use from nilfs
Date: Mon,  8 Jun 2009 01:39:33 +0900
Message-ID: <1244392773-14230-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This will remove every bd_mount_sem use in nilfs.

The intended exclusion control was replaced by the previous patch
("nilfs2: correct exclusion control in nilfs_remount function") for
nilfs_remount(), and this patch will replace remains with a new mutex
that this inserts in nilfs object.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/nilfs2/cpfile.c    |    6 +++---
 fs/nilfs2/super.c     |   12 ++++++------
 fs/nilfs2/the_nilfs.c |    1 +
 fs/nilfs2/the_nilfs.h |    2 ++
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 300f1cd..cadd36b 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -864,11 +864,11 @@ int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 	case NILFS_CHECKPOINT:
 		/*
 		 * Check for protecting existing snapshot mounts:
-		 * bd_mount_sem is used to make this operation atomic and
+		 * ns_mount_mutex is used to make this operation atomic and
 		 * exclusive with a new mount job.  Though it doesn't cover
 		 * umount, it's enough for the purpose.
 		 */
-		down(&nilfs->ns_bdev->bd_mount_sem);
+		mutex_lock(&nilfs->ns_mount_mutex);
 		if (nilfs_checkpoint_is_mounted(nilfs, cno, 1)) {
 			/* Current implementation does not have to protect
 			   plain read-only mounts since they are exclusive
@@ -877,7 +877,7 @@ int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 			ret = -EBUSY;
 		} else
 			ret = nilfs_cpfile_clear_snapshot(cpfile, cno);
-		up(&nilfs->ns_bdev->bd_mount_sem);
+		mutex_unlock(&nilfs->ns_mount_mutex);
 		return ret;
 	case NILFS_SNAPSHOT:
 		return nilfs_cpfile_set_snapshot(cpfile, cno);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index aa658c3..1feb588 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -754,7 +754,7 @@ int nilfs_store_magic_and_option(struct super_block *sb,
  * @silent: silent mode flag
  * @nilfs: the_nilfs struct
  *
- * This function is called exclusively by bd_mount_mutex.
+ * This function is called exclusively by nilfs->ns_mount_mutex.
  * So, the recovery process is protected from other simultaneous mounts.
  */
 static int
@@ -1091,7 +1091,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 		goto failed;
 	}
 
-	down(&sd.bdev->bd_mount_sem);
+	mutex_lock(&nilfs->ns_mount_mutex);
 
 	if (!sd.cno) {
 		/*
@@ -1150,7 +1150,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 		need_to_close = 0;
 	}
 
-	up(&sd.bdev->bd_mount_sem);
+	mutex_unlock(&nilfs->ns_mount_mutex);
 	put_nilfs(nilfs);
 	if (need_to_close)
 		close_bdev_exclusive(sd.bdev, flags);
@@ -1158,7 +1158,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	return 0;
 
  failed_unlock:
-	up(&sd.bdev->bd_mount_sem);
+	mutex_unlock(&nilfs->ns_mount_mutex);
 	put_nilfs(nilfs);
  failed:
 	close_bdev_exclusive(sd.bdev, flags);
@@ -1167,14 +1167,14 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 
  cancel_new:
 	/* Abandoning the newly allocated superblock */
-	up(&sd.bdev->bd_mount_sem);
+	mutex_unlock(&nilfs->ns_mount_mutex);
 	put_nilfs(nilfs);
 	up_write(&s->s_umount);
 	deactivate_super(s);
 	/*
 	 * deactivate_super() invokes close_bdev_exclusive().
 	 * We must finish all post-cleaning before this call;
-	 * put_nilfs() and unlocking bd_mount_sem need the block device.
+	 * put_nilfs() needs the block device.
 	 */
 	return err;
 }
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index fa46320..fdac4db 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -73,6 +73,7 @@ static struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
 	init_rwsem(&nilfs->ns_super_sem);
+	mutex_init(&nilfs->ns_mount_mutex);
 	mutex_init(&nilfs->ns_writer_mutex);
 	INIT_LIST_HEAD(&nilfs->ns_list);
 	INIT_LIST_HEAD(&nilfs->ns_supers);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index d0cf4fb..e8adbff 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -49,6 +49,7 @@ enum {
  * @ns_writer: back pointer to writable nilfs_sb_info
  * @ns_sem: semaphore for shared states
  * @ns_super_sem: semaphore for global operations across super block instances
+ * @ns_mount_mutex: mutex protecting mount process of nilfs
  * @ns_writer_mutex: mutex protecting ns_writer attach/detach
  * @ns_writer_refcount: number of referrers on ns_writer
  * @ns_current: back pointer to current mount
@@ -98,6 +99,7 @@ struct the_nilfs {
 	struct nilfs_sb_info   *ns_writer;
 	struct rw_semaphore	ns_sem;
 	struct rw_semaphore	ns_super_sem;
+	struct mutex		ns_mount_mutex;
 	struct mutex		ns_writer_mutex;
 	atomic_t		ns_writer_refcount;
 
-- 
1.6.2

