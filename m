From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: Using nobarrier option instead of
	barrier=off
Date: Wed, 11 Nov 2009 18:04:17 +0900
Message-ID: <1257930258-3106-2-git-send-email-jir@unicus.jp>
References: <1257930258-3106-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1257930258-3106-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Since most of fs using nofoobar style option,
modified barrier=off option as nobarrier

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/super.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 644e667..02dcbb0 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -490,7 +490,7 @@ static int nilfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 
 	if (!nilfs_test_opt(sbi, BARRIER))
-		seq_printf(seq, ",barrier=off");
+		seq_printf(seq, ",nobarrier");
 	if (nilfs_test_opt(sbi, SNAPSHOT))
 		seq_printf(seq, ",cp=%llu",
 			   (unsigned long long int)sbi->s_snapshot_cno);
@@ -568,7 +568,7 @@ static const struct export_operations nilfs_export_ops = {
 
 enum {
 	Opt_err_cont, Opt_err_panic, Opt_err_ro,
-	Opt_barrier, Opt_snapshot, Opt_order,
+	Opt_nobarrier, Opt_snapshot, Opt_order,
 	Opt_err,
 };
 
@@ -576,7 +576,7 @@ static match_table_t tokens = {
 	{Opt_err_cont, "errors=continue"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
-	{Opt_barrier, "barrier=%s"},
+	{Opt_nobarrier, "nobarrier"},
 	{Opt_snapshot, "cp=%u"},
 	{Opt_order, "order=%s"},
 	{Opt_err, NULL}
@@ -612,13 +612,8 @@ static int parse_options(char *options, struct super_block *sb)
 
 		token = match_token(p, tokens, args);
 		switch (token) {
-		case Opt_barrier:
-			if (match_bool(&args[0], &option))
-				return 0;
-			if (option)
-				nilfs_set_opt(sbi, BARRIER);
-			else
-				nilfs_clear_opt(sbi, BARRIER);
+		case Opt_nobarrier:
+			nilfs_clear_opt(sbi, BARRIER);
 			break;
 		case Opt_order:
 			if (strcmp(args[0].from, "relaxed") == 0)
-- 
1.5.6.5
