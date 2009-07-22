From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 1/3] nilfs2: fix disorder of nilfs_write_super
	in nilfs_sync_fs
Date: Wed, 22 Jul 2009 17:45:21 +0900
Message-ID: <1248252323-22959-2-git-send-email-jir@unicus.jp>
References: <1248252323-22959-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1248252323-22959-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

fix disorder of nilfs_write_super in nilfs_sync_fs.
commiting super block must be the end of the function
so that every chanages are reflected.

->sync_fs() is not called frequently so call nilfs_commit_super
instead of calling nilfs_write_super.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/super.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 63ab2d1..13614d8 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -384,12 +384,18 @@ static void nilfs_write_super(struct super_block *sb)
 static int nilfs_sync_fs(struct super_block *sb, int wait)
 {
 	int err = 0;
-
-	nilfs_write_super(sb);
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct the_nilfs *nilfs = sbi->s_nilfs;
 
 	/* This function is called when super block should be written back */
 	if (wait)
 		err = nilfs_construct_segment(sb);
+
+	down_write(&nilfs->ns_sem);
+	if (sb->s_dirt)
+		nilfs_commit_super(NILFS_SB(sb), 1);
+	up_write(&nilfs->ns_sem);
+
 	return err;
 }
 
-- 
1.5.6.5
