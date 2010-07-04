From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: remove BKL uses
Date: Sun,  4 Jul 2010 14:22:08 +0900
Message-ID: <1278220928-28121-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Nilfs has BKL uses in its put_super and remount functions, but none of
them are necessary, just came from earlier push downs.  This
eliminates the BKL uses from nilfs.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c |    1 -
 fs/nilfs2/super.c |    9 ---------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index f90a33d..0442ee3 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -22,7 +22,6 @@
 
 #include <linux/fs.h>
 #include <linux/wait.h>
-#include <linux/smp_lock.h>	/* lock_kernel(), unlock_kernel() */
 #include <linux/slab.h>
 #include <linux/capability.h>	/* capable() */
 #include <linux/uaccess.h>	/* copy_from_user(), copy_to_user() */
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f2cfbba..29be735 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -45,7 +45,6 @@
 #include <linux/parser.h>
 #include <linux/random.h>
 #include <linux/crc32.h>
-#include <linux/smp_lock.h>
 #include <linux/vfs.h>
 #include <linux/writeback.h>
 #include <linux/kobject.h>
@@ -357,8 +356,6 @@ static void nilfs_put_super(struct super_block *sb)
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 
-	lock_kernel();
-
 	nilfs_detach_segment_constructor(sbi);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -376,8 +373,6 @@ static void nilfs_put_super(struct super_block *sb)
 	sbi->s_super = NULL;
 	sb->s_fs_info = NULL;
 	nilfs_put_sbinfo(sbi);
-
-	unlock_kernel();
 }
 
 static int nilfs_sync_fs(struct super_block *sb, int wait)
@@ -913,8 +908,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	struct nilfs_mount_options old_opts;
 	int was_snapshot, err;
 
-	lock_kernel();
-
 	down_write(&nilfs->ns_super_sem);
 	old_sb_flags = sb->s_flags;
 	old_opts.mount_opt = sbi->s_mount_opt;
@@ -988,7 +981,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	}
  out:
 	up_write(&nilfs->ns_super_sem);
-	unlock_kernel();
 	return 0;
 
  restore_opts:
@@ -996,7 +988,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	sbi->s_mount_opt = old_opts.mount_opt;
 	sbi->s_snapshot_cno = old_opts.snapshot_cno;
 	up_write(&nilfs->ns_super_sem);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
