From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: use semaphore to protect pointer to a
 writable FS-instance
Date: Thu, 06 Aug 2009 16:10:41 +0900 (JST)
Message-ID: <20090806.161041.116443498.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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

This is a patch to clean up an own lock used in nilfs.  I've tested
this for a few days, but it should be tested more.

So, I think this is a 2.6.32 material so far.  I may push this to
2.6.31 if it turns out to be a priority.

Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

will get rid of nilfs_get_writer() and nilfs_put_writer() pair used to
retain a writable FS-instance for a period.

The pair functions were making up some kind of recursive lock with a
mutex, but they became overkill since the commit
201913ed746c7724a40d33ee5a0b6a1fd2ef3193.  Furthermore, they caused
the following lockdep warning because the mutex can be released by a
task which didn't lock it:

 =====================================
 [ BUG: bad unlock balance detected! ]
 -------------------------------------
 kswapd0/422 is trying to release lock (&nilfs->ns_writer_mutex) at:
 [<c1359ff5>] mutex_unlock+0x8/0xa
 but there are no more locks to release!

 other info that might help us debug this:
 no locks held by kswapd0/422.

 stack backtrace:
 Pid: 422, comm: kswapd0 Not tainted 2.6.31-rc4-nilfs #51
 Call Trace:
  [<c1358f97>] ? printk+0xf/0x18
  [<c104fea7>] print_unlock_inbalance_bug+0xcc/0xd7
  [<c11578de>] ? prop_put_global+0x3/0x35
  [<c1050195>] lock_release+0xed/0x1dc
  [<c1359ff5>] ? mutex_unlock+0x8/0xa
  [<c1359f83>] __mutex_unlock_slowpath+0xaf/0x119
  [<c1359ff5>] mutex_unlock+0x8/0xa
  [<d1284add>] nilfs_mdt_write_page+0xd8/0xe1 [nilfs2]
  [<c1092653>] shrink_page_list+0x379/0x68d
  [<c109171b>] ? isolate_pages_global+0xb4/0x18c
  [<c1092bd2>] shrink_list+0x26b/0x54b
  [<c10930be>] shrink_zone+0x20c/0x2a2
  [<c10936b7>] kswapd+0x407/0x591
  [<c1091667>] ? isolate_pages_global+0x0/0x18c
  [<c1040603>] ? autoremove_wake_function+0x0/0x33
  [<c10932b0>] ? kswapd+0x0/0x591
  [<c104033b>] kthread+0x69/0x6e
  [<c10402d2>] ? kthread+0x0/0x6e
  [<c1003e33>] kernel_thread_helper+0x7/0x1a

This patch uses a reader/writer semaphore instead of the own lock and
kills this warning.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.c       |    8 +++++---
 fs/nilfs2/the_nilfs.c |    3 +--
 fs/nilfs2/the_nilfs.h |   27 ++++++---------------------
 3 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 2dfd477..a5cd801 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -402,6 +402,7 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 	struct inode *inode = container_of(page->mapping,
 					   struct inode, i_data);
 	struct super_block *sb = inode->i_sb;
+	struct the_nilfs *nilfs = NILFS_MDT(inode)->mi_nilfs;
 	struct nilfs_sb_info *writer = NULL;
 	int err = 0;
 
@@ -411,9 +412,10 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 	if (page->mapping->assoc_mapping)
 		return 0; /* Do not request flush for shadow page cache */
 	if (!sb) {
-		writer = nilfs_get_writer(NILFS_MDT(inode)->mi_nilfs);
+		down_read(&nilfs->ns_writer_sem);
+		writer = nilfs->ns_writer;
 		if (!writer) {
-			nilfs_put_writer(NILFS_MDT(inode)->mi_nilfs);
+			up_read(&nilfs->ns_writer_sem);
 			return -EROFS;
 		}
 		sb = writer->s_super;
@@ -425,7 +427,7 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 		nilfs_flush_segment(sb, inode->i_ino);
 
 	if (writer)
-		nilfs_put_writer(NILFS_MDT(inode)->mi_nilfs);
+		up_read(&nilfs->ns_writer_sem);
 	return err;
 }
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 8b88898..0c45736 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -68,12 +68,11 @@ static struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 
 	nilfs->ns_bdev = bdev;
 	atomic_set(&nilfs->ns_count, 1);
-	atomic_set(&nilfs->ns_writer_refcount, -1);
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
 	init_rwsem(&nilfs->ns_super_sem);
 	mutex_init(&nilfs->ns_mount_mutex);
-	mutex_init(&nilfs->ns_writer_mutex);
+	init_rwsem(&nilfs->ns_writer_sem);
 	INIT_LIST_HEAD(&nilfs->ns_list);
 	INIT_LIST_HEAD(&nilfs->ns_supers);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index e8adbff..53fb1e6 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -50,8 +50,7 @@ enum {
  * @ns_sem: semaphore for shared states
  * @ns_super_sem: semaphore for global operations across super block instances
  * @ns_mount_mutex: mutex protecting mount process of nilfs
- * @ns_writer_mutex: mutex protecting ns_writer attach/detach
- * @ns_writer_refcount: number of referrers on ns_writer
+ * @ns_writer_sem: semaphore protecting ns_writer attach/detach
  * @ns_current: back pointer to current mount
  * @ns_sbh: buffer heads of on-disk super blocks
  * @ns_sbp: pointers to super block data
@@ -100,8 +99,7 @@ struct the_nilfs {
 	struct rw_semaphore	ns_sem;
 	struct rw_semaphore	ns_super_sem;
 	struct mutex		ns_mount_mutex;
-	struct mutex		ns_writer_mutex;
-	atomic_t		ns_writer_refcount;
+	struct rw_semaphore	ns_writer_sem;
 
 	/*
 	 * components protected by ns_super_sem
@@ -221,34 +219,21 @@ static inline void get_nilfs(struct the_nilfs *nilfs)
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
 
 static inline void nilfs_put_sbinfo(struct nilfs_sb_info *sbi)
-- 
1.6.3.4
