From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: fix lock order reversal in
	nilfs_clean_segments ioctl
Date: Mon, 11 May 2009 20:09:48 +0900
Message-ID: <1242040188-22511-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1242040188-22511-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1242040188-22511-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This is a companion patch to ("nilfs2: fix possible circular locking
for get information ioctls").

This corrects lock order reversal between mm->mmap_sem and
nilfs->ns_segctor_sem in nilfs_clean_segments() which was detected by
lockdep check:

 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.30-rc3-nilfs-00003-g360bdc1 #7
 -------------------------------------------------------
 mmap/5294 is trying to acquire lock:
  (&nilfs->ns_segctor_sem){++++.+}, at: [<d0d0e846>] nilfs_transaction_begin+0xb6/0x10c [nilfs2]

 but task is already holding lock:
  (&mm->mmap_sem){++++++}, at: [<c043700a>] do_page_fault+0x1d8/0x30a

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (&mm->mmap_sem){++++++}:
        [<c01470a5>] __lock_acquire+0x1066/0x13b0
        [<c01474a9>] lock_acquire+0xba/0xdd
        [<c01836bc>] might_fault+0x68/0x88
        [<c023c61d>] copy_from_user+0x2a/0x111
        [<d0d120d0>] nilfs_ioctl_prepare_clean_segments+0x1d/0xf1 [nilfs2]
        [<d0d0e2aa>] nilfs_clean_segments+0x6d/0x1b9 [nilfs2]
        [<d0d11f68>] nilfs_ioctl+0x2ad/0x318 [nilfs2]
        [<c01a3be7>] vfs_ioctl+0x22/0x69
        [<c01a408e>] do_vfs_ioctl+0x460/0x499
        [<c01a4107>] sys_ioctl+0x40/0x5a
        [<c01031a4>] sysenter_do_call+0x12/0x38
        [<ffffffff>] 0xffffffff

 -> #0 (&nilfs->ns_segctor_sem){++++.+}:
        [<c0146e0b>] __lock_acquire+0xdcc/0x13b0
        [<c01474a9>] lock_acquire+0xba/0xdd
        [<c0433f1d>] down_read+0x2a/0x3e
        [<d0d0e846>] nilfs_transaction_begin+0xb6/0x10c [nilfs2]
        [<d0cfe0e5>] nilfs_page_mkwrite+0xe7/0x154 [nilfs2]
        [<c0183b0b>] __do_fault+0x165/0x376
        [<c01855cd>] handle_mm_fault+0x287/0x5d1
        [<c043712d>] do_page_fault+0x2fb/0x30a
        [<c0435462>] error_code+0x72/0x78
        [<ffffffff>] 0xffffffff

where nilfs_clean_segments() holds:

  nilfs->ns_segctor_sem -> copy_from_user()
                             --> page fault -> mm->mmap_sem

And, page fault path may hold:

  page fault -> mm->mmap_sem
         --> nilfs_page_mkwrite() -> nilfs->ns_segctor_sem

Even though nilfs_clean_segments() does not perform write access on
given user pages, it may cause deadlock because nilfs->ns_segctor_sem
is shared per device and mm->mmap_sem can be shared with other tasks.

To avoid this problem, this patch moves all calls of copy_from_user()
outside the nilfs->ns_segctor_sem lock in the ioctl.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c   |  163 +++++++++++++++++++++++++++++----------------------
 fs/nilfs2/nilfs.h   |    3 +-
 fs/nilfs2/segment.c |    5 +-
 fs/nilfs2/segment.h |    3 +-
 4 files changed, 100 insertions(+), 74 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index e3c693d..49489f6 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -25,6 +25,7 @@
 #include <linux/smp_lock.h>	/* lock_kernel(), unlock_kernel() */
 #include <linux/capability.h>	/* capable() */
 #include <linux/uaccess.h>	/* copy_from_user(), copy_to_user() */
+#include <linux/vmalloc.h>
 #include <linux/nilfs2_fs.h>
 #include "nilfs.h"
 #include "segment.h"
@@ -297,10 +298,10 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
 	return 0;
 }
 
-static ssize_t
-nilfs_ioctl_do_move_blocks(struct the_nilfs *nilfs, __u64 *posp, int flags,
-			   void *buf, size_t size, size_t nmembs)
+static int nilfs_ioctl_move_blocks(struct the_nilfs *nilfs,
+				   struct nilfs_argv *argv, void *buf)
 {
+	size_t nmembs = argv->v_nmembs;
 	struct inode *inode;
 	struct nilfs_vdesc *vdesc;
 	struct buffer_head *bh, *n;
@@ -361,19 +362,10 @@ nilfs_ioctl_do_move_blocks(struct the_nilfs *nilfs, __u64 *posp, int flags,
 	return ret;
 }
 
-static inline int nilfs_ioctl_move_blocks(struct the_nilfs *nilfs,
-					  struct nilfs_argv *argv,
-					  int dir)
-{
-	return nilfs_ioctl_wrap_copy(nilfs, argv, dir,
-				     nilfs_ioctl_do_move_blocks);
-}
-
-static ssize_t
-nilfs_ioctl_do_delete_checkpoints(struct the_nilfs *nilfs, __u64 *posp,
-				  int flags, void *buf, size_t size,
-				  size_t nmembs)
+static int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
+					  struct nilfs_argv *argv, void *buf)
 {
+	size_t nmembs = argv->v_nmembs;
 	struct inode *cpfile = nilfs->ns_cpfile;
 	struct nilfs_period *periods = buf;
 	int ret, i;
@@ -387,36 +379,21 @@ nilfs_ioctl_do_delete_checkpoints(struct the_nilfs *nilfs, __u64 *posp,
 	return nmembs;
 }
 
-static inline int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
-						 struct nilfs_argv *argv,
-						 int dir)
+static int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
+				      struct nilfs_argv *argv, void *buf)
 {
-	return nilfs_ioctl_wrap_copy(nilfs, argv, dir,
-				     nilfs_ioctl_do_delete_checkpoints);
-}
+	size_t nmembs = argv->v_nmembs;
+	int ret;
 
-static ssize_t
-nilfs_ioctl_do_free_vblocknrs(struct the_nilfs *nilfs, __u64 *posp, int flags,
-			      void *buf, size_t size, size_t nmembs)
-{
-	int ret = nilfs_dat_freev(nilfs_dat_inode(nilfs), buf, nmembs);
+	ret = nilfs_dat_freev(nilfs_dat_inode(nilfs), buf, nmembs);
 
 	return (ret < 0) ? ret : nmembs;
 }
 
-static inline int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
-					     struct nilfs_argv *argv,
-					     int dir)
-{
-	return nilfs_ioctl_wrap_copy(nilfs, argv, dir,
-				     nilfs_ioctl_do_free_vblocknrs);
-}
-
-static ssize_t
-nilfs_ioctl_do_mark_blocks_dirty(struct the_nilfs *nilfs, __u64 *posp,
-				 int flags, void *buf, size_t size,
-				 size_t nmembs)
+static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
+					 struct nilfs_argv *argv, void *buf)
 {
+	size_t nmembs = argv->v_nmembs;
 	struct inode *dat = nilfs_dat_inode(nilfs);
 	struct nilfs_bmap *bmap = NILFS_I(dat)->i_bmap;
 	struct nilfs_bdesc *bdescs = buf;
@@ -455,18 +432,10 @@ nilfs_ioctl_do_mark_blocks_dirty(struct the_nilfs *nilfs, __u64 *posp,
 	return nmembs;
 }
 
-static inline int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
-						struct nilfs_argv *argv,
-						int dir)
-{
-	return nilfs_ioctl_wrap_copy(nilfs, argv, dir,
-				     nilfs_ioctl_do_mark_blocks_dirty);
-}
-
-static ssize_t
-nilfs_ioctl_do_free_segments(struct the_nilfs *nilfs, __u64 *posp, int flags,
-			     void *buf, size_t size, size_t nmembs)
+static int nilfs_ioctl_free_segments(struct the_nilfs *nilfs,
+				     struct nilfs_argv *argv, void *buf)
 {
+	size_t nmembs = argv->v_nmembs;
 	struct nilfs_sb_info *sbi = nilfs->ns_writer;
 	int ret;
 
@@ -481,31 +450,19 @@ nilfs_ioctl_do_free_segments(struct the_nilfs *nilfs, __u64 *posp, int flags,
 	return (ret < 0) ? ret : nmembs;
 }
 
-static inline int nilfs_ioctl_free_segments(struct the_nilfs *nilfs,
-					     struct nilfs_argv *argv,
-					     int dir)
-{
-	return nilfs_ioctl_wrap_copy(nilfs, argv, dir,
-				     nilfs_ioctl_do_free_segments);
-}
-
 int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
-				       void __user *argp)
+				       struct nilfs_argv *argv, void **kbufs)
 {
-	struct nilfs_argv argv[5];
 	const char *msg;
-	int dir, ret;
-
-	if (copy_from_user(argv, argp, sizeof(argv)))
-		return -EFAULT;
+	int ret;
 
-	dir = _IOC_WRITE;
-	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], dir);
+	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], kbufs[0]);
 	if (ret < 0) {
 		msg = "cannot read source blocks";
 		goto failed;
 	}
-	ret = nilfs_ioctl_delete_checkpoints(nilfs, &argv[1], dir);
+
+	ret = nilfs_ioctl_delete_checkpoints(nilfs, &argv[1], kbufs[1]);
 	if (ret < 0) {
 		/*
 		 * can safely abort because checkpoints can be removed
@@ -514,7 +471,7 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 		msg = "cannot delete checkpoints";
 		goto failed;
 	}
-	ret = nilfs_ioctl_free_vblocknrs(nilfs, &argv[2], dir);
+	ret = nilfs_ioctl_free_vblocknrs(nilfs, &argv[2], kbufs[2]);
 	if (ret < 0) {
 		/*
 		 * can safely abort because DAT file is updated atomically
@@ -523,7 +480,7 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 		msg = "cannot delete virtual blocks from DAT file";
 		goto failed;
 	}
-	ret = nilfs_ioctl_mark_blocks_dirty(nilfs, &argv[3], dir);
+	ret = nilfs_ioctl_mark_blocks_dirty(nilfs, &argv[3], kbufs[3]);
 	if (ret < 0) {
 		/*
 		 * can safely abort because the operation is nondestructive.
@@ -531,7 +488,7 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 		msg = "cannot mark copying blocks dirty";
 		goto failed;
 	}
-	ret = nilfs_ioctl_free_segments(nilfs, &argv[4], dir);
+	ret = nilfs_ioctl_free_segments(nilfs, &argv[4], kbufs[4]);
 	if (ret < 0) {
 		/*
 		 * can safely abort because this operation is atomic.
@@ -551,9 +508,75 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 				      unsigned int cmd, void __user *argp)
 {
+	struct nilfs_argv argv[5];
+	const static size_t argsz[5] = {
+		sizeof(struct nilfs_vdesc),
+		sizeof(struct nilfs_period),
+		sizeof(__u64),
+		sizeof(struct nilfs_bdesc),
+		sizeof(__u64),
+	};
+	void __user *base;
+	void *kbufs[5];
+	struct the_nilfs *nilfs;
+	size_t len, nsegs;
+	int n, ret;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	return nilfs_clean_segments(inode->i_sb, argp);
+
+	if (copy_from_user(argv, argp, sizeof(argv)))
+		return -EFAULT;
+
+	nsegs = argv[4].v_nmembs;
+	if (argv[4].v_size != argsz[4])
+		return -EINVAL;
+	/*
+	 * argv[4] points to segment numbers this ioctl cleans.  We
+	 * use kmalloc() for its buffer because memory used for the
+	 * segment numbers is enough small.
+	 */
+	kbufs[4] = memdup_user((void __user *)(unsigned long)argv[4].v_base,
+			       nsegs * sizeof(__u64));
+	if (IS_ERR(kbufs[4]))
+		return PTR_ERR(kbufs[4]);
+
+	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+
+	for (n = 0; n < 4; n++) {
+		ret = -EINVAL;
+		if (argv[n].v_size != argsz[n])
+			goto out_free;
+
+		if (argv[n].v_nmembs > nsegs * nilfs->ns_blocks_per_segment)
+			goto out_free;
+
+		len = argv[n].v_size * argv[n].v_nmembs;
+		base = (void __user *)(unsigned long)argv[n].v_base;
+		if (len == 0) {
+			kbufs[n] = NULL;
+			continue;
+		}
+
+		kbufs[n] = vmalloc(len);
+		if (!kbufs[n]) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+		if (copy_from_user(kbufs[n], base, len)) {
+			ret = -EFAULT;
+			vfree(kbufs[n]);
+			goto out_free;
+		}
+	}
+
+	ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
+
+ out_free:
+	while (--n > 0)
+		vfree(kbufs[n]);
+	kfree(kbufs[4]);
+	return ret;
 }
 
 static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 3d0c18a..da6fc0b 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -236,7 +236,8 @@ extern int nilfs_sync_file(struct file *, struct dentry *, int);
 
 /* ioctl.c */
 long nilfs_ioctl(struct file *, unsigned int, unsigned long);
-int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *, void __user *);
+int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *, struct nilfs_argv *,
+				       void **);
 
 /* inode.c */
 extern struct inode *nilfs_new_inode(struct inode *, int);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index fb70ec3..22c7f65 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2589,7 +2589,8 @@ nilfs_remove_written_gcinodes(struct the_nilfs *nilfs, struct list_head *head)
 	}
 }
 
-int nilfs_clean_segments(struct super_block *sb, void __user *argp)
+int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
+			 void **kbufs)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct nilfs_sc_info *sci = NILFS_SC(sbi);
@@ -2606,7 +2607,7 @@ int nilfs_clean_segments(struct super_block *sb, void __user *argp)
 	err = nilfs_init_gcdat_inode(nilfs);
 	if (unlikely(err))
 		goto out_unlock;
-	err = nilfs_ioctl_prepare_clean_segments(nilfs, argp);
+	err = nilfs_ioctl_prepare_clean_segments(nilfs, argv, kbufs);
 	if (unlikely(err))
 		goto out_unlock;
 
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index a98fc1e..476bdd5 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -222,7 +222,8 @@ extern int nilfs_construct_segment(struct super_block *);
 extern int nilfs_construct_dsync_segment(struct super_block *, struct inode *,
 					 loff_t, loff_t);
 extern void nilfs_flush_segment(struct super_block *, ino_t);
-extern int nilfs_clean_segments(struct super_block *, void __user *);
+extern int nilfs_clean_segments(struct super_block *, struct nilfs_argv *,
+				void **);
 
 extern int nilfs_segctor_add_segments_to_be_freed(struct nilfs_sc_info *,
 						  __u64 *, size_t);
-- 
1.6.2
