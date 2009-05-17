From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/6] nilfs2: use semaphore to protect pointer
	to a writable FS-instance
Date: Mon, 18 May 2009 00:29:41 +0900
Message-ID: <1242574186-21554-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1242574186-21554-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1242574186-21554-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This removes nilfs_get_writer() and nilfs_put_writer() pair which is
used to retain a writable FS-instance for a period.  The pair
functions were making up some kind of recursive lock, and they
eventually became obsolete by the bugfix patch ("nilfs2: fix circular
locking dependency of writer mutex").

This uses a reader/writer semaphore instead of the own lock.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.c       |   10 +++++++---
 fs/nilfs2/the_nilfs.c |    3 +--
 fs/nilfs2/the_nilfs.h |   27 ++++++---------------------
 3 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index bb78745..c3eb539 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -402,6 +402,7 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 	struct inode *inode = container_of(page->mapping,
 					   struct inode, i_data);
 	struct super_block *sb = inode->i_sb;
+	struct the_nilfs *nilfs = NILFS_MDT(inode)->mi_nilfs;
 	struct nilfs_sb_info *writer = NULL;
 	int err = 0;
 
@@ -411,9 +412,12 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 	if (page->mapping->assoc_mapping)
 		return 0; /* Do not request flush for shadow page cache */
 	if (!sb) {
-		writer = nilfs_get_writer(NILFS_MDT(inode)->mi_nilfs);
-		if (!writer)
+		down_read(&nilfs->ns_writer_sem);
+		writer = nilfs->ns_writer;
+		if (!writer) {
+			up_read(&nilfs->ns_writer_sem);
 			return -EROFS;
+		}
 		sb = writer->s_super;
 	}
 
@@ -423,7 +427,7 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 		nilfs_flush_segment(sb, inode->i_ino);
 
 	if (writer)
-		nilfs_put_writer(NILFS_MDT(inode)->mi_nilfs);
+		up_read(&nilfs->ns_writer_sem);
 	return err;
 }
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 7f65b3b..9befbc8 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -65,10 +65,9 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 
 	nilfs->ns_bdev = bdev;
 	atomic_set(&nilfs->ns_count, 1);
-	atomic_set(&nilfs->ns_writer_refcount, -1);
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
-	mutex_init(&nilfs->ns_writer_mutex);
+	init_rwsem(&nilfs->ns_writer_sem);
 	INIT_LIST_HEAD(&nilfs->ns_supers);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_gc_inodes_h = NULL;
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 30fe587..8732d37 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -47,8 +47,7 @@ enum {
  * @ns_bdi: backing dev info
  * @ns_writer: back pointer to writable nilfs_sb_info
  * @ns_sem: semaphore for shared states
- * @ns_writer_mutex: mutex protecting ns_writer attach/detach
- * @ns_writer_refcount: number of referrers on ns_writer
+ * @ns_writer_sem: semaphore protecting ns_writer attach/detach
  * @ns_sbh: buffer heads of on-disk super blocks
  * @ns_sbp: pointers to super block data
  * @ns_sbwtime: previous write time of super blocks
@@ -93,8 +92,7 @@ struct the_nilfs {
 	struct backing_dev_info *ns_bdi;
 	struct nilfs_sb_info   *ns_writer;
 	struct rw_semaphore	ns_sem;
-	struct mutex		ns_writer_mutex;
-	atomic_t		ns_writer_refcount;
+	struct rw_semaphore	ns_writer_sem;
 
 	/*
 	 * used for
@@ -208,34 +206,21 @@ static inline void get_nilfs(struct the_nilfs *nilfs)
 	atomic_inc(&nilfs->ns_count);
 }
 
-static inline struct nilfs_sb_info *nilfs_get_writer(struct the_nilfs *nilfs)
-{
-	if (atomic_inc_and_test(&nilfs->ns_writer_refcount))
-		mutex_lock(&nilfs->ns_writer_mutex);
-	return nilfs->ns_writer;
-}
-
-static inline void nilfs_put_writer(struct the_nilfs *nilfs)
-{
-	if (atomic_add_negative(-1, &nilfs->ns_writer_refcount))
-		mutex_unlock(&nilfs->ns_writer_mutex);
-}
-
 static inline void
 nilfs_attach_writer(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 {
-	mutex_lock(&nilfs->ns_writer_mutex);
+	down_write(&nilfs->ns_writer_sem);
 	nilfs->ns_writer = sbi;
-	mutex_unlock(&nilfs->ns_writer_mutex);
+	up_write(&nilfs->ns_writer_sem);
 }
 
 static inline void
 nilfs_detach_writer(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 {
-	mutex_lock(&nilfs->ns_writer_mutex);
+	down_write(&nilfs->ns_writer_sem);
 	if (sbi == nilfs->ns_writer)
 		nilfs->ns_writer = NULL;
-	mutex_unlock(&nilfs->ns_writer_mutex);
+	up_write(&nilfs->ns_writer_sem);
 }
 
 static inline void
-- 
1.6.2
