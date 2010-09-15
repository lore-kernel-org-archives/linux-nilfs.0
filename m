From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: accept 64-bit checkpoint numbers in cp mount option
Date: Thu, 16 Sep 2010 01:18:34 +0900
Message-ID: <1284567514-9257-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The current implementation doesn't mount snapshots with checkpoint
numbers larger than INT_MAX since it uses match_int() for parsing
"cp=" mount option.

This uses simple_strtoull() for the conversion to resolves the issue.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7bd4b75..8418bd0 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -561,7 +561,6 @@ static int parse_options(char *options, struct super_block *sb, int is_remount)
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
-	int option;
 
 	if (!options)
 		return 1;
@@ -599,8 +598,6 @@ static int parse_options(char *options, struct super_block *sb, int is_remount)
 			nilfs_write_opt(sbi, ERROR_MODE, ERRORS_CONT);
 			break;
 		case Opt_snapshot:
-			if (match_int(&args[0], &option) || option <= 0)
-				return 0;
 			if (is_remount) {
 				printk(KERN_ERR
 				       "NILFS: \"%s\" option is invalid "
@@ -1074,7 +1071,7 @@ static int nilfs_identify(char *data, struct nilfs_super_data *sd)
 {
 	char *p, *options = data;
 	substring_t args[MAX_OPT_ARGS];
-	int option, token;
+	int token;
 	int ret = 0;
 
 	do {
@@ -1082,16 +1079,18 @@ static int nilfs_identify(char *data, struct nilfs_super_data *sd)
 		if (p != NULL && *p) {
 			token = match_token(p, tokens, args);
 			if (token == Opt_snapshot) {
-				if (!(sd->flags & MS_RDONLY))
+				if (!(sd->flags & MS_RDONLY)) {
 					ret++;
-				else {
-					ret = match_int(&args[0], &option);
-					if (!ret) {
-						if (option > 0)
-							sd->cno = option;
-						else
-							ret++;
-					}
+				} else {
+					sd->cno = simple_strtoull(args[0].from,
+								  NULL, 0);
+					/*
+					 * No need to see the end pointer;
+					 * match_token() has done syntax
+					 * checking.
+					 */
+					if (sd->cno == 0)
+						ret++;
 				}
 			}
 			if (ret)
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
