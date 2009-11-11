From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix lock order reversal in chcp
	operation
Date: Thu, 12 Nov 2009 00:37:06 +0900
Message-ID: <1257953826-28545-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Will fix the following lock order reversal lockdep detected:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.32-rc6 #7
-------------------------------------------------------
chcp/30157 is trying to acquire lock:
 (&nilfs->ns_mount_mutex){+.+.+.}, at: [<fed7cfcc>] nilfs_cpfile_change_cpmode+0x46/0x752 [nilfs2]

but task is already holding lock:
 (&nilfs->ns_segctor_sem){++++.+}, at: [<fed7ca32>] nilfs_transaction_begin+0xba/0x110 [nilfs2]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&nilfs->ns_segctor_sem){++++.+}:
       [<c105799c>] __lock_acquire+0x109c/0x139d
       [<c1057d26>] lock_acquire+0x89/0xa0
       [<c14151e2>] down_read+0x31/0x45
       [<fed6d77b>] nilfs_attach_checkpoint+0x8f/0x16b [nilfs2]
       [<fed6e393>] nilfs_get_sb+0x3e7/0x653 [nilfs2]
       [<c10c0ccb>] vfs_kern_mount+0x8b/0x124
       [<c10c0db2>] do_kern_mount+0x37/0xc3
       [<c10d7517>] do_mount+0x64d/0x69d
       [<c10d75cd>] sys_mount+0x66/0x95
       [<c1002a14>] sysenter_do_call+0x12/0x32

-> #1 (&type->s_umount_key#31/1){+.+.+.}:
       [<c105799c>] __lock_acquire+0x109c/0x139d
       [<c1057d26>] lock_acquire+0x89/0xa0
       [<c104c0f3>] down_write_nested+0x34/0x52
       [<c10c08fe>] sget+0x22e/0x389
       [<fed6e133>] nilfs_get_sb+0x187/0x653 [nilfs2]
       [<c10c0ccb>] vfs_kern_mount+0x8b/0x124
       [<c10c0db2>] do_kern_mount+0x37/0xc3
       [<c10d7517>] do_mount+0x64d/0x69d
       [<c10d75cd>] sys_mount+0x66/0x95
       [<c1002a14>] sysenter_do_call+0x12/0x32

-> #0 (&nilfs->ns_mount_mutex){+.+.+.}:
       [<c1057727>] __lock_acquire+0xe27/0x139d
       [<c1057d26>] lock_acquire+0x89/0xa0
       [<c1414d63>] mutex_lock_nested+0x41/0x23e
       [<fed7cfcc>] nilfs_cpfile_change_cpmode+0x46/0x752 [nilfs2]
       [<fed801b2>] nilfs_ioctl+0x11a/0x7da [nilfs2]
       [<c10cca12>] vfs_ioctl+0x27/0x6e
       [<c10ccf93>] do_vfs_ioctl+0x491/0x4db
       [<c10cd022>] sys_ioctl+0x45/0x5f
       [<c1002a14>] sysenter_do_call+0x12/0x32

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/cpfile.c |    2 --
 fs/nilfs2/ioctl.c  |    6 +++++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 1c6cfb5..3f5d5d0 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -871,7 +871,6 @@ int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 		 * exclusive with a new mount job.  Though it doesn't cover
 		 * umount, it's enough for the purpose.
 		 */
-		mutex_lock(&nilfs->ns_mount_mutex);
 		if (nilfs_checkpoint_is_mounted(nilfs, cno, 1)) {
 			/* Current implementation does not have to protect
 			   plain read-only mounts since they are exclusive
@@ -880,7 +879,6 @@ int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 			ret = -EBUSY;
 		} else
 			ret = nilfs_cpfile_clear_snapshot(cpfile, cno);
-		mutex_unlock(&nilfs->ns_mount_mutex);
 		return ret;
 	case NILFS_SNAPSHOT:
 		return nilfs_cpfile_set_snapshot(cpfile, cno);
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index d24057d..f6af760 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -99,7 +99,8 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 				     unsigned int cmd, void __user *argp)
 {
-	struct inode *cpfile = NILFS_SB(inode->i_sb)->s_nilfs->ns_cpfile;
+	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	struct inode *cpfile = nilfs->ns_cpfile;
 	struct nilfs_transaction_info ti;
 	struct nilfs_cpmode cpmode;
 	int ret;
@@ -109,14 +110,17 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 	if (copy_from_user(&cpmode, argp, sizeof(cpmode)))
 		return -EFAULT;
 
+	mutex_lock(&nilfs->ns_mount_mutex);
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	ret = nilfs_cpfile_change_cpmode(
 		cpfile, cpmode.cm_cno, cpmode.cm_mode);
 	if (unlikely(ret < 0)) {
 		nilfs_transaction_abort(inode->i_sb);
+		mutex_unlock(&nilfs->ns_mount_mutex);
 		return ret;
 	}
 	nilfs_transaction_commit(inode->i_sb); /* never fails */
+	mutex_unlock(&nilfs->ns_mount_mutex);
 	return ret;
 }
 
-- 
1.6.3.4
