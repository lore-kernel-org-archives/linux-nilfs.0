From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv5 2/5] nilfs2: add nilfs_set_error
Date: Mon, 28 Jun 2010 17:49:30 +0900
Message-ID: <1277714973-12136-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1277714973-12136-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277714973-12136-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This function marks error state and write it on super blocks.  This is
a preparation for making super block writeback alternately.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f23a31b..4a85dfb 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -74,6 +74,19 @@ struct kmem_cache *nilfs_btree_path_cache;
 
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 
+static void nilfs_set_error(struct nilfs_sb_info *sbi)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+
+	down_write(&nilfs->ns_sem);
+	if (!(nilfs->ns_mount_state & NILFS_ERROR_FS)) {
+		nilfs->ns_mount_state |= NILFS_ERROR_FS;
+		nilfs->ns_sbp[0]->s_state |= cpu_to_le16(NILFS_ERROR_FS);
+		nilfs_commit_super(sbi, 1);
+	}
+	up_write(&nilfs->ns_sem);
+}
+
 /**
  * nilfs_error() - report failure condition on a filesystem
  *
@@ -99,16 +112,7 @@ void nilfs_error(struct super_block *sb, const char *function,
 	va_end(args);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		struct the_nilfs *nilfs = sbi->s_nilfs;
-
-		down_write(&nilfs->ns_sem);
-		if (!(nilfs->ns_mount_state & NILFS_ERROR_FS)) {
-			nilfs->ns_mount_state |= NILFS_ERROR_FS;
-			nilfs->ns_sbp[0]->s_state |=
-				cpu_to_le16(NILFS_ERROR_FS);
-			nilfs_commit_super(sbi, 1);
-		}
-		up_write(&nilfs->ns_sem);
+		nilfs_set_error(sbi);
 
 		if (nilfs_test_opt(sbi, ERRORS_RO)) {
 			printk(KERN_CRIT "Remounting filesystem read-only\n");
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
