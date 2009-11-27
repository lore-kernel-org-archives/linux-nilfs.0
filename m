From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv2 2/9] nilfs2: delete mark_inode_dirty from
	nilfs_set_link
Date: Fri, 27 Nov 2009 19:41:07 +0900
Message-ID: <1259318474-28342-3-git-send-email-jir@unicus.jp>
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

Delete mark_inode_dirty() from nilfs_set_link() to reduce redundant
mark_inode_dirty() calls in caller of nilfs_set_link().

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/dir.c   |    1 -
 fs/nilfs2/namei.c |    4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index e097099..4f3fa00 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -459,7 +459,6 @@ void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 	nilfs_put_page(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 /*	NILFS_I(dir)->i_flags &= ~NILFS_BTREE_FL; */
-	mark_inode_dirty(dir);
 }
 
 /*
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 01adda8..4616f96 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -397,6 +397,7 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto out_dir;
 		inode_inc_link_count(old_inode);
 		nilfs_set_link(new_dir, new_de, new_page, old_inode);
+		mark_inode_dirty(new_dir);
 		new_inode->i_ctime = CURRENT_TIME;
 		if (dir_de)
 			drop_nlink(new_inode);
@@ -425,12 +426,13 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_inode->i_ctime = CURRENT_TIME;
 
 	nilfs_delete_entry(old_de, old_page);
-	inode_dec_link_count(old_inode);
+	drop_nlink(old_inode);
 
 	if (dir_de) {
 		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
 		inode_dec_link_count(old_dir);
 	}
+	mark_inode_dirty(old_inode);
 
 	err = nilfs_transaction_commit(old_dir->i_sb);
 	return err;
-- 
1.5.6.5
