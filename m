From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: fix circular locking dependency
	of writer mutex
Date: Tue,  5 May 2009 21:33:03 +0900
Message-ID: <1241526783-25671-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1241526783-25671-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1241526783-25671-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This fixes the following circular locking dependency problem:

 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.30-rc3 #5
 -------------------------------------------------------
 segctord/3895 is trying to acquire lock:
  (&nilfs->ns_writer_mutex){+.+...}, at: [<d0d02172>]
   nilfs_mdt_get_block+0x89/0x20f [nilfs2]

 but task is already holding lock:
  (&bmap->b_sem){++++..}, at: [<d0d02d99>]
   nilfs_bmap_propagate+0x14/0x2e [nilfs2]

 which lock already depends on the new lock.

The bugfix is done by replacing call sites of nilfs_get_writer() which
are never called from read-only context with direct dereferencing of
pointer to a writable FS-instance.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c |    8 +++++---
 fs/nilfs2/mdt.c   |   13 +++++++------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 108d281..be387c6 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -516,14 +516,16 @@ static ssize_t
 nilfs_ioctl_do_free_segments(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			     void *buf, size_t size, size_t nmembs)
 {
-	struct nilfs_sb_info *sbi = nilfs_get_writer(nilfs);
+	struct nilfs_sb_info *sbi = nilfs->ns_writer;
 	int ret;
 
-	if (unlikely(!sbi))
+	if (unlikely(!sbi)) {
+		/* never happens because called for a writable mount */
+		WARN_ON(1);
 		return -EROFS;
+	}
 	ret = nilfs_segctor_add_segments_to_be_freed(
 		NILFS_SC(sbi), buf, nmembs);
-	nilfs_put_writer(nilfs);
 
 	return (ret < 0) ? ret : nmembs;
 }
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 47dd815..e1c6777 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -77,19 +77,22 @@ static int nilfs_mdt_create_block(struct inode *inode, unsigned long block,
 						     void *))
 {
 	struct the_nilfs *nilfs = NILFS_MDT(inode)->mi_nilfs;
-	struct nilfs_sb_info *writer = NULL;
 	struct super_block *sb = inode->i_sb;
 	struct nilfs_transaction_info ti;
 	struct buffer_head *bh;
 	int err;
 
 	if (!sb) {
-		writer = nilfs_get_writer(nilfs);
-		if (!writer) {
+		/*
+		 * Make sure this function is not called from any
+		 * read-only context.
+		 */
+		if (!nilfs->ns_writer) {
+			WARN_ON(1);
 			err = -EROFS;
 			goto out;
 		}
-		sb = writer->s_super;
+		sb = nilfs->ns_writer->s_super;
 	}
 
 	nilfs_transaction_begin(sb, &ti, 0);
@@ -127,8 +130,6 @@ static int nilfs_mdt_create_block(struct inode *inode, unsigned long block,
 		err = nilfs_transaction_commit(sb);
 	else
 		nilfs_transaction_abort(sb);
-	if (writer)
-		nilfs_put_writer(nilfs);
  out:
 	return err;
 }
-- 
1.6.2
