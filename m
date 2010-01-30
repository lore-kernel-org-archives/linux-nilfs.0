From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: use mnt_want_write in ioctls where write access is needed
Date: Sat, 30 Jan 2010 19:58:21 +0900
Message-ID: <1264849101-24449-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

A few nilfs2 ioctls need to ask for and then later release write
access to the mount in order to avoid potential write to read-only
mounts.

This adds the missing mnt_want_write and mnt_drop_write in
nilfs_ioctl_change_cpmode, nilfs_ioctl_delete_checkpoint, and
nilfs_ioctl_clean_segments.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c |   60 ++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index d6b2b83..8e5cad0 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -26,6 +26,7 @@
 #include <linux/capability.h>	/* capable() */
 #include <linux/uaccess.h>	/* copy_from_user(), copy_to_user() */
 #include <linux/vmalloc.h>
+#include <linux/mount.h>	/* mnt_want_write(), mnt_drop_write() */
 #include <linux/nilfs2_fs.h>
 #include "nilfs.h"
 #include "segment.h"
@@ -107,20 +108,28 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
+
+	ret = mnt_want_write(filp->f_path.mnt);
+	if (ret)
+		return ret;
+
+	ret = -EFAULT;
 	if (copy_from_user(&cpmode, argp, sizeof(cpmode)))
-		return -EFAULT;
+		goto out;
 
 	mutex_lock(&nilfs->ns_mount_mutex);
+
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	ret = nilfs_cpfile_change_cpmode(
 		cpfile, cpmode.cm_cno, cpmode.cm_mode);
-	if (unlikely(ret < 0)) {
+	if (unlikely(ret < 0))
 		nilfs_transaction_abort(inode->i_sb);
-		mutex_unlock(&nilfs->ns_mount_mutex);
-		return ret;
-	}
-	nilfs_transaction_commit(inode->i_sb); /* never fails */
+	else
+		nilfs_transaction_commit(inode->i_sb); /* never fails */
+
 	mutex_unlock(&nilfs->ns_mount_mutex);
+out:
+	mnt_drop_write(filp->f_path.mnt);
 	return ret;
 }
 
@@ -135,16 +144,23 @@ nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
+
+	ret = mnt_want_write(filp->f_path.mnt);
+	if (ret)
+		return ret;
+
+	ret = -EFAULT;
 	if (copy_from_user(&cno, argp, sizeof(cno)))
-		return -EFAULT;
+		goto out;
 
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	ret = nilfs_cpfile_delete_checkpoint(cpfile, cno);
-	if (unlikely(ret < 0)) {
+	if (unlikely(ret < 0))
 		nilfs_transaction_abort(inode->i_sb);
-		return ret;
-	}
-	nilfs_transaction_commit(inode->i_sb); /* never fails */
+	else
+		nilfs_transaction_commit(inode->i_sb); /* never fails */
+out:
+	mnt_drop_write(filp->f_path.mnt);
 	return ret;
 }
 
@@ -496,12 +512,19 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	ret = mnt_want_write(filp->f_path.mnt);
+	if (ret)
+		return ret;
+
+	ret = -EFAULT;
 	if (copy_from_user(argv, argp, sizeof(argv)))
-		return -EFAULT;
+		goto out;
 
+	ret = -EINVAL;
 	nsegs = argv[4].v_nmembs;
 	if (argv[4].v_size != argsz[4])
-		return -EINVAL;
+		goto out;
+
 	/*
 	 * argv[4] points to segment numbers this ioctl cleans.  We
 	 * use kmalloc() for its buffer because memory used for the
@@ -509,9 +532,10 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	 */
 	kbufs[4] = memdup_user((void __user *)(unsigned long)argv[4].v_base,
 			       nsegs * sizeof(__u64));
-	if (IS_ERR(kbufs[4]))
-		return PTR_ERR(kbufs[4]);
-
+	if (IS_ERR(kbufs[4])) {
+		ret = PTR_ERR(kbufs[4]);
+		goto out;
+	}
 	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
 
 	for (n = 0; n < 4; n++) {
@@ -563,10 +587,12 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 		nilfs_remove_all_gcinode(nilfs);
 	clear_nilfs_gc_running(nilfs);
 
- out_free:
+out_free:
 	while (--n >= 0)
 		vfree(kbufs[n]);
 	kfree(kbufs[4]);
+out:
+	mnt_drop_write(filp->f_path.mnt);
 	return ret;
 }
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
