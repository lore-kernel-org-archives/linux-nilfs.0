From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: deleted inconsistent comment in
	nilfs_load_inode_block()
Date: Sun, 15 Nov 2009 13:49:45 +0900
Message-ID: <1258260585-3479-3-git-send-email-jir@unicus.jp>
References: <1258260585-3479-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258260585-3479-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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

The comment says, "Caller of this function MUST lock s_inode_lock",
however just above the comment, it locks s_inode_lock in the function.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/inode.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 5040220..2a0a5a3 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -664,7 +664,6 @@ int nilfs_load_inode_block(struct nilfs_sb_info *sbi, struct inode *inode,
 	int err;
 
 	spin_lock(&sbi->s_inode_lock);
-	/* Caller of this function MUST lock s_inode_lock */
 	if (ii->i_bh == NULL) {
 		spin_unlock(&sbi->s_inode_lock);
 		err = nilfs_ifile_get_inode_block(sbi->s_ifile, inode->i_ino,
-- 
1.5.6.5
