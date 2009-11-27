From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv2 8/9] nilfs2: delete mark_inode_dirty in
	nilfs_delete_entry
Date: Fri, 27 Nov 2009 19:41:13 +0900
Message-ID: <1259318474-28342-9-git-send-email-jir@unicus.jp>
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

Delete mark_inode_dirty() in nilfs_delete_entry() to reduce duplicate
mark_inode_dirty() calls both in nilfs_rename() and nilfs_delete_entry().

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/dir.c   |    1 -
 fs/nilfs2/namei.c |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 693539b..1d9a4e4 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -595,7 +595,6 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 	nilfs_commit_chunk(page, mapping, from, to);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 /*	NILFS_I(inode)->i_flags &= ~NILFS_BTREE_FL; */
-	mark_inode_dirty(inode);
 out:
 	nilfs_put_page(page);
 	return err;
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index d6aa8f4..4237722 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -334,6 +334,7 @@ static int nilfs_unlink(struct inode *dir, struct dentry *dentry)
 	err = nilfs_do_unlink(dir, dentry);
 
 	if (!err) {
+		mark_inode_dirty(dir);
 		mark_inode_dirty(dentry->d_inode);
 		err = nilfs_transaction_commit(dir->i_sb);
 	} else
@@ -450,8 +451,8 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (dir_de) {
 		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
 		drop_nlink(old_dir);
-		mark_inode_dirty(old_dir);
 	}
+	mark_inode_dirty(old_dir);
 	mark_inode_dirty(old_inode);
 
 	err = nilfs_transaction_commit(old_dir->i_sb);
-- 
1.5.6.5
