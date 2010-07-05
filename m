From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/5] nilfs2: get rid of nilfs_mount_options struct
Date: Tue,  6 Jul 2010 00:09:50 +0900
Message-ID: <1278342590-5912-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1278342590-5912-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1278342590-5912-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This removes nilfs_mount_options structure and simplifies restoration
of mount options in remount function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sb.h    |    8 --------
 fs/nilfs2/super.c |    8 +++-----
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/sb.h b/fs/nilfs2/sb.h
index 0776ccc..5d44f0f 100644
--- a/fs/nilfs2/sb.h
+++ b/fs/nilfs2/sb.h
@@ -27,14 +27,6 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 
-/*
- * Mount options
- */
-struct nilfs_mount_options {
-	unsigned long mount_opt;
-	__u64 snapshot_cno;
-};
-
 struct the_nilfs;
 struct nilfs_sc_info;
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 9bc7485..b26211c 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -931,13 +931,12 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	unsigned long old_sb_flags;
-	struct nilfs_mount_options old_opts;
+	unsigned long old_mount_opt;
 	int was_snapshot, err;
 
 	down_write(&nilfs->ns_super_sem);
 	old_sb_flags = sb->s_flags;
-	old_opts.mount_opt = sbi->s_mount_opt;
-	old_opts.snapshot_cno = sbi->s_snapshot_cno;
+	old_mount_opt = sbi->s_mount_opt;
 	was_snapshot = nilfs_test_opt(sbi, SNAPSHOT);
 
 	if (!parse_options(data, sb, 1)) {
@@ -996,8 +995,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 
  restore_opts:
 	sb->s_flags = old_sb_flags;
-	sbi->s_mount_opt = old_opts.mount_opt;
-	sbi->s_snapshot_cno = old_opts.snapshot_cno;
+	sbi->s_mount_opt = old_mount_opt;
 	up_write(&nilfs->ns_super_sem);
 	return err;
 }
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
