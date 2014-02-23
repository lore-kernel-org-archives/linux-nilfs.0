From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 2/3] nilfs2: add FITRIM ioctl support for nilfs2
Date: Mon, 24 Feb 2014 01:58:40 +0900
Message-ID: <1393174721-27246-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1393174721-27246-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393174721-27246-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Andreas Rohner <andreas.rohner@gmx.net>

From: Andreas Rohner <andreas.rohner@gmx.net>

This patch adds support for the FITRIM ioctl, which enables user space
tools to issue TRIM/DISCARD requests to the underlying device. Every
clean segment within the specified range will be discarded.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/ioctl.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index c19a231..422fb54 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1072,6 +1072,48 @@ out:
 }
 
 /**
+ * nilfs_ioctl_trim_fs() - trim ioctl handle function
+ * @inode: inode object
+ * @argp: pointer on argument from userspace
+ *
+ * Decription: nilfs_ioctl_trim_fs is the FITRIM ioctl handle function. It
+ * checks the arguments from userspace and calls nilfs_sufile_trim_fs, which
+ * performs the actual trim operation.
+ *
+ * Return Value: On success, 0 is returned or negative error code, otherwise.
+ */
+static int nilfs_ioctl_trim_fs(struct inode *inode, void __user *argp)
+{
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct request_queue *q = bdev_get_queue(nilfs->ns_bdev);
+	struct fstrim_range range;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!blk_queue_discard(q))
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&range, argp, sizeof(range)))
+		return -EFAULT;
+
+	range.minlen = max_t(u64, range.minlen, q->limits.discard_granularity);
+
+	down_read(&nilfs->ns_segctor_sem);
+	ret = nilfs_sufile_trim_fs(nilfs->ns_sufile, &range);
+	up_read(&nilfs->ns_segctor_sem);
+
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user(argp, &range, sizeof(range)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/**
  * nilfs_ioctl_set_alloc_range - limit range of segments to be allocated
  * @inode: inode object
  * @argp: pointer on argument from userspace
@@ -1296,6 +1338,8 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return nilfs_ioctl_resize(inode, filp, argp);
 	case NILFS_IOCTL_SET_ALLOC_RANGE:
 		return nilfs_ioctl_set_alloc_range(inode, argp);
+	case FITRIM:
+		return nilfs_ioctl_trim_fs(inode, argp);
 	default:
 		return -ENOTTY;
 	}
@@ -1327,6 +1371,7 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case NILFS_IOCTL_SYNC:
 	case NILFS_IOCTL_RESIZE:
 	case NILFS_IOCTL_SET_ALLOC_RANGE:
+	case FITRIM:
 		break;
 	default:
 		return -ENOIOCTLCMD;
-- 
1.7.9.3
