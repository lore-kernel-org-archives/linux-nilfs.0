From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/5] nilfs2: pass remount flag to parse_options
Date: Tue,  6 Jul 2010 00:09:49 +0900
Message-ID: <1278342590-5912-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This adds is_remount argument to the parse_options() function that
obtains mount options from strings.

Previously, parse_options did not distinguish context whether it's
called for a new mount or remount, so the caller needed additional
verifications outside the function.

This allows parse_options to verify options and print messages
depending on the context.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |   49 ++++++++++++++++++++++++++-----------------------
 1 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index fb02e4a..9bc7485 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -616,7 +616,7 @@ static match_table_t tokens = {
 	{Opt_err, NULL}
 };
 
-static int parse_options(char *options, struct super_block *sb)
+static int parse_options(char *options, struct super_block *sb, int is_remount)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	char *p;
@@ -661,8 +661,26 @@ static int parse_options(char *options, struct super_block *sb)
 		case Opt_snapshot:
 			if (match_int(&args[0], &option) || option <= 0)
 				return 0;
-			if (!(sb->s_flags & MS_RDONLY))
+			if (is_remount) {
+				if (!nilfs_test_opt(sbi, SNAPSHOT)) {
+					printk(KERN_ERR
+					       "NILFS: cannot change regular "
+					       "mount to snapshot.\n");
+					return 0;
+				} else if (option != sbi->s_snapshot_cno) {
+					printk(KERN_ERR
+					       "NILFS: cannot remount to a "
+					       "different snapshot.\n");
+					return 0;
+				}
+				break;
+			}
+			if (!(sb->s_flags & MS_RDONLY)) {
+				printk(KERN_ERR "NILFS: cannot mount snapshot "
+				       "read/write.  A read-only option is "
+				       "required.\n");
 				return 0;
+			}
 			sbi->s_snapshot_cno = option;
 			nilfs_set_opt(sbi, SNAPSHOT);
 			break;
@@ -762,7 +780,7 @@ int nilfs_store_magic_and_option(struct super_block *sb,
 	sbi->s_interval = le32_to_cpu(sbp->s_c_interval);
 	sbi->s_watermark = le32_to_cpu(sbp->s_c_block_max);
 
-	return !parse_options(data, sb) ? -EINVAL : 0 ;
+	return !parse_options(data, sb, 0) ? -EINVAL : 0 ;
 }
 
 /**
@@ -922,32 +940,17 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	old_opts.snapshot_cno = sbi->s_snapshot_cno;
 	was_snapshot = nilfs_test_opt(sbi, SNAPSHOT);
 
-	if (!parse_options(data, sb)) {
+	if (!parse_options(data, sb, 1)) {
 		err = -EINVAL;
 		goto restore_opts;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL);
 
 	err = -EINVAL;
-	if (was_snapshot) {
-		if (!(*flags & MS_RDONLY)) {
-			printk(KERN_ERR "NILFS (device %s): cannot remount "
-			       "snapshot read/write.\n",
-			       sb->s_id);
-			goto restore_opts;
-		} else if (sbi->s_snapshot_cno != old_opts.snapshot_cno) {
-			printk(KERN_ERR "NILFS (device %s): cannot "
-			       "remount to a different snapshot.\n",
-			       sb->s_id);
-			goto restore_opts;
-		}
-	} else {
-		if (nilfs_test_opt(sbi, SNAPSHOT)) {
-			printk(KERN_ERR "NILFS (device %s): cannot change "
-			       "a regular mount to a snapshot.\n",
-			       sb->s_id);
-			goto restore_opts;
-		}
+	if (was_snapshot && !(*flags & MS_RDONLY)) {
+		printk(KERN_ERR "NILFS (device %s): cannot remount snapshot "
+		       "read/write.\n", sb->s_id);
+		goto restore_opts;
 	}
 
 	if (!nilfs_valid_fs(nilfs)) {
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
