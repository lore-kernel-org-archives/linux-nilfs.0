From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: fix possible circular locking for
	get information ioctls
Date: Mon, 11 May 2009 20:09:47 +0900
Message-ID: <1242040188-22511-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This is one of two patches which are to correct possible circular
locking between mm->mmap_sem and nilfs->ns_segctor_sem.

The problem was detected by lockdep check as follows:

 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.30-rc3-nilfs-00002-g3552613 #6
 -------------------------------------------------------
 mmap/5418 is trying to acquire lock:
 (&nilfs->ns_segctor_sem){++++.+}, at: [<d0d0e852>] nilfs_transaction_begin+0xb6/0x10c [nilfs2]

 but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<c043700a>] do_page_fault+0x1d8/0x30a

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (&mm->mmap_sem){++++++}:
 [<c01470a5>] __lock_acquire+0x1066/0x13b0
 [<c01474a9>] lock_acquire+0xba/0xdd
 [<c01836bc>] might_fault+0x68/0x88
 [<c023c730>] copy_to_user+0x2c/0xfc
 [<d0d11b4f>] nilfs_ioctl_wrap_copy+0x103/0x160 [nilfs2]
 [<d0d11fa9>] nilfs_ioctl+0x30a/0x3b0 [nilfs2]
 [<c01a3be7>] vfs_ioctl+0x22/0x69
 [<c01a408e>] do_vfs_ioctl+0x460/0x499
 [<c01a4107>] sys_ioctl+0x40/0x5a
 [<c01031a4>] sysenter_do_call+0x12/0x38
 [<ffffffff>] 0xffffffff

 -> #0 (&nilfs->ns_segctor_sem){++++.+}:
 [<c0146e0b>] __lock_acquire+0xdcc/0x13b0
 [<c01474a9>] lock_acquire+0xba/0xdd
 [<c0433f1d>] down_read+0x2a/0x3e
 [<d0d0e852>] nilfs_transaction_begin+0xb6/0x10c [nilfs2]
 [<d0cfe0e5>] nilfs_page_mkwrite+0xe7/0x154 [nilfs2]
 [<c0183b0b>] __do_fault+0x165/0x376
 [<c01855cd>] handle_mm_fault+0x287/0x5d1
 [<c043712d>] do_page_fault+0x2fb/0x30a
 [<c0435462>] error_code+0x72/0x78
 [<ffffffff>] 0xffffffff

 other info that might help us debug this:

 1 lock held by mmap/5418:
 #0:  (&mm->mmap_sem){++++++}, at: [<c043700a>] do_page_fault+0x1d8/0x30a

 stack backtrace:
 Pid: 5418, comm: mmap Not tainted 2.6.30-rc3-nilfs-00002-g3552613 #6
 Call Trace:
 [<c0432145>] ? printk+0xf/0x12
 [<c0145c48>] print_circular_bug_tail+0xaa/0xb5
 [<c0146e0b>] __lock_acquire+0xdcc/0x13b0
 [<d0d10149>] ? nilfs_sufile_get_stat+0x1e/0x105 [nilfs2]
 [<c013b59a>] ? up_read+0x16/0x2c
 [<d0d10225>] ? nilfs_sufile_get_stat+0xfa/0x105 [nilfs2]
 [<c01474a9>] lock_acquire+0xba/0xdd
 [<d0d0e852>] ? nilfs_transaction_begin+0xb6/0x10c [nilfs2]
 [<c0433f1d>] down_read+0x2a/0x3e
 [<d0d0e852>] ? nilfs_transaction_begin+0xb6/0x10c [nilfs2]
 [<d0d0e852>] nilfs_transaction_begin+0xb6/0x10c [nilfs2]
 [<d0cfe0e5>] nilfs_page_mkwrite+0xe7/0x154 [nilfs2]
 [<c0183b0b>] __do_fault+0x165/0x376
 [<c01855cd>] handle_mm_fault+0x287/0x5d1
 [<c043700a>] ? do_page_fault+0x1d8/0x30a
 [<c013b54f>] ? down_read_trylock+0x39/0x43
 [<c043712d>] do_page_fault+0x2fb/0x30a
 [<c0436e32>] ? do_page_fault+0x0/0x30a
 [<c0435462>] error_code+0x72/0x78
 [<c0436e32>] ? do_page_fault+0x0/0x30a

This makes the lock granularity of nilfs->ns_segctor_sem finer than
that of the mmap semaphore for ioctl commands except
nilfs_clean_segments().

The successive patch ("nilfs2: fix lock order reversal in
nilfs_clean_segments ioctl") is required to fully resolve the problem.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c |  100 ++++++++++++++++++++---------------------------------
 1 files changed, 38 insertions(+), 62 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index be387c6..e3c693d 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -147,29 +147,12 @@ static ssize_t
 nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			  void *buf, size_t size, size_t nmembs)
 {
-	return nilfs_cpfile_get_cpinfo(nilfs->ns_cpfile, posp, flags, buf,
-				       nmembs);
-}
-
-static int nilfs_ioctl_get_cpinfo(struct inode *inode, struct file *filp,
-				  unsigned int cmd, void __user *argp)
-{
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
-	struct nilfs_argv argv;
 	int ret;
 
-	if (copy_from_user(&argv, argp, sizeof(argv)))
-		return -EFAULT;
-
 	down_read(&nilfs->ns_segctor_sem);
-	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
-				    nilfs_ioctl_do_get_cpinfo);
+	ret = nilfs_cpfile_get_cpinfo(nilfs->ns_cpfile, posp, flags, buf,
+				      nmembs);
 	up_read(&nilfs->ns_segctor_sem);
-	if (ret < 0)
-		return ret;
-
-	if (copy_to_user(argp, &argv, sizeof(argv)))
-		ret = -EFAULT;
 	return ret;
 }
 
@@ -195,28 +178,11 @@ static ssize_t
 nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			  void *buf, size_t size, size_t nmembs)
 {
-	return nilfs_sufile_get_suinfo(nilfs->ns_sufile, *posp, buf, nmembs);
-}
-
-static int nilfs_ioctl_get_suinfo(struct inode *inode, struct file *filp,
-				  unsigned int cmd, void __user *argp)
-{
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
-	struct nilfs_argv argv;
 	int ret;
 
-	if (copy_from_user(&argv, argp, sizeof(argv)))
-		return -EFAULT;
-
 	down_read(&nilfs->ns_segctor_sem);
-	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
-				    nilfs_ioctl_do_get_suinfo);
+	ret = nilfs_sufile_get_suinfo(nilfs->ns_sufile, *posp, buf, nmembs);
 	up_read(&nilfs->ns_segctor_sem);
-	if (ret < 0)
-		return ret;
-
-	if (copy_to_user(argp, &argv, sizeof(argv)))
-		ret = -EFAULT;
 	return ret;
 }
 
@@ -242,28 +208,11 @@ static ssize_t
 nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			 void *buf, size_t size, size_t nmembs)
 {
-	return nilfs_dat_get_vinfo(nilfs_dat_inode(nilfs), buf, nmembs);
-}
-
-static int nilfs_ioctl_get_vinfo(struct inode *inode, struct file *filp,
-				 unsigned int cmd, void __user *argp)
-{
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
-	struct nilfs_argv argv;
 	int ret;
 
-	if (copy_from_user(&argv, argp, sizeof(argv)))
-		return -EFAULT;
-
 	down_read(&nilfs->ns_segctor_sem);
-	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
-				    nilfs_ioctl_do_get_vinfo);
+	ret = nilfs_dat_get_vinfo(nilfs_dat_inode(nilfs), buf, nmembs);
 	up_read(&nilfs->ns_segctor_sem);
-	if (ret < 0)
-		return ret;
-
-	if (copy_to_user(argp, &argv, sizeof(argv)))
-		ret = -EFAULT;
 	return ret;
 }
 
@@ -276,17 +225,21 @@ nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
 	struct nilfs_bdesc *bdescs = buf;
 	int ret, i;
 
+	down_read(&nilfs->ns_segctor_sem);
 	for (i = 0; i < nmembs; i++) {
 		ret = nilfs_bmap_lookup_at_level(bmap,
 						 bdescs[i].bd_offset,
 						 bdescs[i].bd_level + 1,
 						 &bdescs[i].bd_blocknr);
 		if (ret < 0) {
-			if (ret != -ENOENT)
+			if (ret != -ENOENT) {
+				up_read(&nilfs->ns_segctor_sem);
 				return ret;
+			}
 			bdescs[i].bd_blocknr = 0;
 		}
 	}
+	up_read(&nilfs->ns_segctor_sem);
 	return nmembs;
 }
 
@@ -300,10 +253,8 @@ static int nilfs_ioctl_get_bdescs(struct inode *inode, struct file *filp,
 	if (copy_from_user(&argv, argp, sizeof(argv)))
 		return -EFAULT;
 
-	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
 				    nilfs_ioctl_do_get_bdescs);
-	up_read(&nilfs->ns_segctor_sem);
 	if (ret < 0)
 		return ret;
 
@@ -623,6 +574,29 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
 	return 0;
 }
 
+static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
+				unsigned int cmd, void __user *argp,
+				ssize_t (*dofunc)(struct the_nilfs *,
+						  __u64 *, int,
+						  void *, size_t, size_t))
+
+{
+	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	struct nilfs_argv argv;
+	int ret;
+
+	if (copy_from_user(&argv, argp, sizeof(argv)))
+		return -EFAULT;
+
+	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd), dofunc);
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user(argp, &argv, sizeof(argv)))
+		ret = -EFAULT;
+	return ret;
+}
+
 long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_dentry->d_inode;
@@ -634,16 +608,18 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case NILFS_IOCTL_DELETE_CHECKPOINT:
 		return nilfs_ioctl_delete_checkpoint(inode, filp, cmd, argp);
 	case NILFS_IOCTL_GET_CPINFO:
-		return nilfs_ioctl_get_cpinfo(inode, filp, cmd, argp);
+		return nilfs_ioctl_get_info(inode, filp, cmd, argp,
+					    nilfs_ioctl_do_get_cpinfo);
 	case NILFS_IOCTL_GET_CPSTAT:
 		return nilfs_ioctl_get_cpstat(inode, filp, cmd, argp);
 	case NILFS_IOCTL_GET_SUINFO:
-		return nilfs_ioctl_get_suinfo(inode, filp, cmd, argp);
+		return nilfs_ioctl_get_info(inode, filp, cmd, argp,
+					    nilfs_ioctl_do_get_suinfo);
 	case NILFS_IOCTL_GET_SUSTAT:
 		return nilfs_ioctl_get_sustat(inode, filp, cmd, argp);
 	case NILFS_IOCTL_GET_VINFO:
-		/* XXX: rename to ??? */
-		return nilfs_ioctl_get_vinfo(inode, filp, cmd, argp);
+		return nilfs_ioctl_get_info(inode, filp, cmd, argp,
+					    nilfs_ioctl_do_get_vinfo);
 	case NILFS_IOCTL_GET_BDESCS:
 		return nilfs_ioctl_get_bdescs(inode, filp, cmd, argp);
 	case NILFS_IOCTL_CLEAN_SEGMENTS:
-- 
1.6.2
