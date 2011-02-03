From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv2 5/5] nilfs2: add compat ioctl
Date: Fri,  4 Feb 2011 00:20:14 +0900
Message-ID: <1296746414-11444-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1296746414-11444-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296746414-11444-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The current FS_IOC_GETFLAGS/SETFLAGS/GETVERSION will fail if
application is 32 bit and kernel is 64 bit.

This issue is avoidable by adding compat_ioctl method.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/dir.c   |    2 +-
 fs/nilfs2/file.c  |    2 +-
 fs/nilfs2/ioctl.c |   21 +++++++++++++++++++++
 fs/nilfs2/nilfs.h |    1 +
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index b72833a..3a19239 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -681,7 +681,7 @@ const struct file_operations nilfs_dir_operations = {
 	.readdir	= nilfs_readdir,
 	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl	= nilfs_ioctl,
+	.compat_ioctl	= nilfs_compat_ioctl,
 #endif	/* CONFIG_COMPAT */
 	.fsync		= nilfs_sync_file,
 
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 2f560c9..7a5e4ab 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -142,7 +142,7 @@ const struct file_operations nilfs_file_operations = {
 	.aio_write	= generic_file_aio_write,
 	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl	= nilfs_ioctl,
+	.compat_ioctl	= nilfs_compat_ioctl,
 #endif	/* CONFIG_COMPAT */
 	.mmap		= nilfs_file_mmap,
 	.open		= generic_file_open,
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 3aad641..d89173e 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -26,6 +26,7 @@
 #include <linux/capability.h>	/* capable() */
 #include <linux/uaccess.h>	/* copy_from_user(), copy_to_user() */
 #include <linux/vmalloc.h>
+#include <linux/compat.h>	/* compat_ptr() */
 #include <linux/mount.h>	/* mnt_want_write(), mnt_drop_write() */
 #include <linux/nilfs2_fs.h>
 #include "nilfs.h"
@@ -766,3 +767,23 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return -ENOTTY;
 	}
 }
+
+#ifdef CONFIG_COMPAT
+long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case FS_IOC32_GETFLAGS:
+		cmd = FS_IOC_GETFLAGS;
+		break;
+	case FS_IOC32_SETFLAGS:
+		cmd = FS_IOC_SETFLAGS;
+		break;
+	case FS_IOC32_GETVERSION:
+		cmd = FS_IOC_GETVERSION;
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return nilfs_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 3e3acb1..45b1fd1 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -246,6 +246,7 @@ extern int nilfs_sync_file(struct file *, int);
 
 /* ioctl.c */
 long nilfs_ioctl(struct file *, unsigned int, unsigned long);
+long nilfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *, struct nilfs_argv *,
 				       void **);
 
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
