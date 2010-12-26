From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/6] nilfs2: get rid of nilfs_mount_options structure
Date: Mon, 27 Dec 2010 01:02:40 +0900
Message-ID: <1293379362-3340-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1293379362-3340-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293379362-3340-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Only mount_opt member is used in the nilfs_mount_options structure,
and we can simplify it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sb.h    |    8 --------
 fs/nilfs2/super.c |    6 +++---
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/sb.h b/fs/nilfs2/sb.h
index 35a0715..7a17715 100644
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
index bef8cc6..69f3144 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1011,11 +1011,11 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	unsigned long old_sb_flags;
-	struct nilfs_mount_options old_opts;
+	unsigned long old_mount_opt;
 	int err;
 
 	old_sb_flags = sb->s_flags;
-	old_opts.mount_opt = sbi->s_mount_opt;
+	old_mount_opt = sbi->s_mount_opt;
 
 	if (!parse_options(data, sb, 1)) {
 		err = -EINVAL;
@@ -1084,7 +1084,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 
  restore_opts:
 	sb->s_flags = old_sb_flags;
-	sbi->s_mount_opt = old_opts.mount_opt;
+	sbi->s_mount_opt = old_mount_opt;
 	return err;
 }
 
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
