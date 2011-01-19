From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/4] nilfs2: implement FS_IOC_GETFLAGS/SETFLAGS/GETVERSION
Date: Thu, 20 Jan 2011 02:41:31 +0900
Message-ID: <1295458891-22715-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1295458891-22715-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295458891-22715-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Add support for the standard attributes set via chattr and read via
lsattr.  These attributes are already in the flags value in the nilfs2
inode, but currently we don't have any ioctl commands that expose them
to the userland.

Collaterally, this adds the FS_IOC_GETVERSION ioctl for getting
i_generation, which allows users to list the file's generation number
with "lsattr -v".

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 4967389..3aad641 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -97,6 +97,70 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	return ret;
 }
 
+static int nilfs_ioctl_getflags(struct inode *inode, void __user *argp)
+{
+	unsigned int flags = NILFS_I(inode)->i_flags & FS_FL_USER_VISIBLE;
+
+	return put_user(flags, (int __user *)argp);
+}
+
+static int nilfs_ioctl_setflags(struct inode *inode, struct file *filp,
+				void __user *argp)
+{
+	struct nilfs_transaction_info ti;
+	unsigned int flags, oldflags;
+	int ret;
+
+	if (!is_owner_or_cap(inode))
+		return -EACCES;
+
+	if (get_user(flags, (int __user *)argp))
+		return -EFAULT;
+
+	ret = mnt_want_write(filp->f_path.mnt);
+	if (ret)
+		return ret;
+
+	flags = nilfs_mask_flags(inode->i_mode, flags);
+
+	mutex_lock(&inode->i_mutex);
+
+	oldflags = NILFS_I(inode)->i_flags;
+
+	/*
+	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by the
+	 * relevant capability.
+	 */
+	ret = -EPERM;
+	if (((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) &&
+	    !capable(CAP_LINUX_IMMUTABLE))
+		goto out;
+
+	ret = nilfs_transaction_begin(inode->i_sb, &ti, 0);
+	if (ret)
+		goto out;
+
+	NILFS_I(inode)->i_flags = (oldflags & ~FS_FL_USER_MODIFIABLE) |
+		(flags & FS_FL_USER_MODIFIABLE);
+
+	nilfs_set_inode_flags(inode);
+	inode->i_ctime = CURRENT_TIME;
+	if (IS_SYNC(inode))
+		nilfs_set_transaction_flag(NILFS_TI_SYNC);
+
+	nilfs_mark_inode_dirty(inode);
+	ret = nilfs_transaction_commit(inode->i_sb);
+out:
+	mutex_unlock(&inode->i_mutex);
+	mnt_drop_write(filp->f_path.mnt);
+	return ret;
+}
+
+static int nilfs_ioctl_getversion(struct inode *inode, void __user *argp)
+{
+	return put_user(inode->i_generation, (int __user *)argp);
+}
+
 static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 				     unsigned int cmd, void __user *argp)
 {
@@ -666,6 +730,12 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 
 	switch (cmd) {
+	case FS_IOC_GETFLAGS:
+		return nilfs_ioctl_getflags(inode, argp);
+	case FS_IOC_SETFLAGS:
+		return nilfs_ioctl_setflags(inode, filp, argp);
+	case FS_IOC_GETVERSION:
+		return nilfs_ioctl_getversion(inode, argp);
 	case NILFS_IOCTL_CHANGE_CPMODE:
 		return nilfs_ioctl_change_cpmode(inode, filp, cmd, argp);
 	case NILFS_IOCTL_DELETE_CHECKPOINT:
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
