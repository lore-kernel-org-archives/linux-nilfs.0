From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 9/9] nilfs2: add ioctl to lookup pathname of inode
Date: Mon, 16 May 2011 18:05:22 +0900
Message-ID: <1305536722-1311-10-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1305536722-1311-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305536722-1311-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Adds a new ioctl command to look up pathnames of an inode from its
inode number.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c         |   76 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nilfs2_fs.h |   13 ++++++++
 2 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 79f3719..cc468ff 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -812,6 +812,80 @@ out:
 	return ret;
 }
 
+/**
+ * nilfs_ioctl_ino_lookup - lookup pathname of inode
+ * @inode: inode on which this ioctl was issued
+ * @argp: pointer to nilfs_ino_lookup_args structure. Where the argv
+ *        member holds the following information
+ *
+ *   argv.v_nmembs: number of pathnames (used for both request and result)
+ *   argv.v_base: buffer in which pathnames will be stored
+ *   argv.v_size: size of pathnames buffer
+ *   argv.v_index: index number of pathnames
+ */
+static int nilfs_ioctl_ino_lookup(struct inode *inode, void __user *argp)
+{
+	struct nilfs_ino_lookup_args largs;
+	struct nilfs_root *root;
+	size_t namesz, bufsz;
+	void *kbuf;
+	void __user *base;
+	int ret;
+
+	ret = -EPERM;
+	if (!capable(CAP_SYS_ADMIN))
+		goto out;
+
+	ret = -EFAULT;
+	if (copy_from_user(&largs, argp, sizeof(largs)))
+		goto out;
+
+	ret = 0;
+	if (largs.argv.v_nmembs == 0)
+		goto out;
+
+	ret = -ERANGE;
+	if (largs.argv.v_size > 4096)
+		goto out;
+
+	bufsz = largs.argv.v_size;
+	base = (void __user *)(unsigned long)largs.argv.v_base;
+	kbuf = kmalloc(bufsz, GFP_NOFS);
+	if (!kbuf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	down_read(&inode->i_sb->s_umount);
+
+	ret = nilfs_attach_checkpoint(inode->i_sb, largs.cno, false, &root);
+	if (ret < 0)
+		goto out_unlock;
+
+	ret = nilfs_search_path(inode->i_sb, root, largs.ino,
+				largs.argv.v_index, kbuf, bufsz, &namesz);
+	if (ret >= 0) {
+		largs.argv.v_nmembs = ret;
+		largs.argv.v_size = namesz;
+		ret = 0;
+	}
+	nilfs_put_root(root);
+
+out_unlock:
+	up_read(&inode->i_sb->s_umount);
+
+	if (!ret && copy_to_user(base, kbuf + bufsz - namesz, namesz))
+		ret = -EFAULT;
+
+	kfree(kbuf);
+
+	if (!ret && copy_to_user(&((struct nilfs_ino_lookup_args *)argp)->argv,
+				 &largs.argv, sizeof(largs.argv)))
+		ret = -EFAULT;
+out:
+	return ret;
+}
+
 static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 				unsigned int cmd, void __user *argp,
 				size_t membsz,
@@ -883,6 +957,8 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return nilfs_ioctl_set_alloc_range(inode, argp);
 	case NILFS_IOCTL_COMPARE_CHECKPOINTS:
 		return nilfs_ioctl_compare_checkpoints(inode, argp);
+	case NILFS_IOCTL_INO_LOOKUP:
+		return nilfs_ioctl_ino_lookup(inode, argp);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 599ccd1..9d2f425 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -863,6 +863,17 @@ struct nilfs_comp_args {
 	struct nilfs_argv argv;
 };
 
+/**
+ * struct nilfs_ino_lookup_args - ioctl argument to lookup inode pathname
+ * @ino: inode number
+ * @cno: checkpoint number
+ * @argv: argument vector to exchange pathnames
+ */
+struct nilfs_ino_lookup_args {
+	__u64 ino;
+	__u64 cno;
+	struct nilfs_argv argv;
+};
 
 #define NILFS_IOCTL_IDENT		'n'
 
@@ -892,5 +903,7 @@ struct nilfs_comp_args {
 	_IOW(NILFS_IOCTL_IDENT, 0x8C, __u64[2])
 #define NILFS_IOCTL_COMPARE_CHECKPOINTS  \
 	_IOWR(NILFS_IOCTL_IDENT, 0x8D, struct nilfs_comp_args)
+#define NILFS_IOCTL_INO_LOOKUP  \
+	_IOWR(NILFS_IOCTL_IDENT, 0x8E, struct nilfs_ino_lookup_args)
 
 #endif	/* _LINUX_NILFS_FS_H */
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
