From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: cleanup unused match_bool function
Date: Wed, 11 Nov 2009 18:04:18 +0900
Message-ID: <1257930258-3106-3-git-send-email-jir@unicus.jp>
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

deleted unused match_bool() function.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/super.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 02dcbb0..b6837f4 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -582,19 +582,6 @@ static match_table_t tokens = {
 	{Opt_err, NULL}
 };
 
-static int match_bool(substring_t *s, int *result)
-{
-	int len = s->to - s->from;
-
-	if (strncmp(s->from, "on", len) == 0)
-		*result = 1;
-	else if (strncmp(s->from, "off", len) == 0)
-		*result = 0;
-	else
-		return 1;
-	return 0;
-}
-
 static int parse_options(char *options, struct super_block *sb)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-- 
1.5.6.5
