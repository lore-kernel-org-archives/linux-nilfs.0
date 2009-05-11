From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: check size of array structured data
	exchanged via ioctls
Date: Tue, 12 May 2009 03:36:52 +0900
Message-ID: <1242067012-24994-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Although some ioctls of nilfs2 exchange data in the form of indirectly
referenced array, some of them lack size check on the array elements.

This inserts the missing checks and rejects requests if data of ioctl
does not have a valid format.

We usually don't have to check size of structures that we associated
with ioctl commands because the size is tested implicitly for
identifying ioctl command; the checks this patch adds are for the
cases where the implicit check is not applied.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 49489f6..50ff3f2 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -254,6 +254,9 @@ static int nilfs_ioctl_get_bdescs(struct inode *inode, struct file *filp,
 	if (copy_from_user(&argv, argp, sizeof(argv)))
 		return -EFAULT;
 
+	if (argv.v_size != sizeof(struct nilfs_bdesc))
+		return -EINVAL;
+
 	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
 				    nilfs_ioctl_do_get_bdescs);
 	if (ret < 0)
@@ -599,6 +602,7 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
 
 static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 				unsigned int cmd, void __user *argp,
+				size_t membsz,
 				ssize_t (*dofunc)(struct the_nilfs *,
 						  __u64 *, int,
 						  void *, size_t, size_t))
@@ -611,6 +615,9 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 	if (copy_from_user(&argv, argp, sizeof(argv)))
 		return -EFAULT;
 
+	if (argv.v_size != membsz)
+		return -EINVAL;
+
 	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd), dofunc);
 	if (ret < 0)
 		return ret;
@@ -632,16 +639,19 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return nilfs_ioctl_delete_checkpoint(inode, filp, cmd, argp);
 	case NILFS_IOCTL_GET_CPINFO:
 		return nilfs_ioctl_get_info(inode, filp, cmd, argp,
+					    sizeof(struct nilfs_cpinfo),
 					    nilfs_ioctl_do_get_cpinfo);
 	case NILFS_IOCTL_GET_CPSTAT:
 		return nilfs_ioctl_get_cpstat(inode, filp, cmd, argp);
 	case NILFS_IOCTL_GET_SUINFO:
 		return nilfs_ioctl_get_info(inode, filp, cmd, argp,
+					    sizeof(struct nilfs_suinfo),
 					    nilfs_ioctl_do_get_suinfo);
 	case NILFS_IOCTL_GET_SUSTAT:
 		return nilfs_ioctl_get_sustat(inode, filp, cmd, argp);
 	case NILFS_IOCTL_GET_VINFO:
 		return nilfs_ioctl_get_info(inode, filp, cmd, argp,
+					    sizeof(struct nilfs_vinfo),
 					    nilfs_ioctl_do_get_vinfo);
 	case NILFS_IOCTL_GET_BDESCS:
 		return nilfs_ioctl_get_bdescs(inode, filp, cmd, argp);
-- 
1.6.2
