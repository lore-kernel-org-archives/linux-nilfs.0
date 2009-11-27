From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv2 4/9] nilfs2: delete redundant
	mark_inode_dirty
Date: Fri, 27 Nov 2009 19:41:09 +0900
Message-ID: <1259318474-28342-5-git-send-email-jir@unicus.jp>
References: <1259318474-28342-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1259318474-28342-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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

delete redundant mark_inode_dirty() calls

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/namei.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index f952439..35f59da 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -247,7 +247,6 @@ static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		return err;
 
 	inc_nlink(dir);
-	mark_inode_dirty(dir);
 
 	inode = nilfs_new_inode(dir, S_IFDIR | mode);
 	err = PTR_ERR(inode);
@@ -280,7 +279,6 @@ out:
 
 out_fail:
 	drop_nlink(inode);
-	mark_inode_dirty(inode);
 	drop_nlink(inode);
 	mark_inode_dirty(inode);
 	iput(inode);
@@ -405,7 +403,6 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (!new_de)
 			goto out_dir;
 		inc_nlink(old_inode);
-		mark_inode_dirty(old_inode);
 		nilfs_set_link(new_dir, new_de, new_page, old_inode);
 		mark_inode_dirty(new_dir);
 		new_inode->i_ctime = CURRENT_TIME;
@@ -420,7 +417,6 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				goto out_dir;
 		}
 		inc_nlink(old_inode);
-		mark_inode_dirty(old_inode);
 		err = nilfs_add_link(new_dentry, old_inode);
 		if (err) {
 			drop_nlink(old_inode);
-- 
1.5.6.5
