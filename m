From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv2 3/9] nilfs2: expand inode_inc_link_count and
	inode_dec_link_count
Date: Fri, 27 Nov 2009 19:41:08 +0900
Message-ID: <1259318474-28342-4-git-send-email-jir@unicus.jp>
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

This is an intermidiate patch to reduce redandunt mark_inode_dirty() calls
by calling inode_inc_link_count() and inode_dec_link_count() functions.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/namei.c |   49 ++++++++++++++++++++++++++++++++-----------------
 1 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 4616f96..f952439 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -200,7 +200,8 @@ out:
 	return err;
 
 out_fail:
-	inode_dec_link_count(inode);
+	drop_nlink(inode);
+	mark_inode_dirty(inode);
 	iput(inode);
 	goto out;
 }
@@ -245,7 +246,8 @@ static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (err)
 		return err;
 
-	inode_inc_link_count(dir);
+	inc_nlink(dir);
+	mark_inode_dirty(dir);
 
 	inode = nilfs_new_inode(dir, S_IFDIR | mode);
 	err = PTR_ERR(inode);
@@ -256,7 +258,8 @@ static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	inode->i_fop = &nilfs_dir_operations;
 	inode->i_mapping->a_ops = &nilfs_aops;
 
-	inode_inc_link_count(inode);
+	inc_nlink(inode);
+	mark_inode_dirty(inode);
 
 	err = nilfs_make_empty(inode, dir);
 	if (err)
@@ -276,11 +279,14 @@ out:
 	return err;
 
 out_fail:
-	inode_dec_link_count(inode);
-	inode_dec_link_count(inode);
+	drop_nlink(inode);
+	mark_inode_dirty(inode);
+	drop_nlink(inode);
+	mark_inode_dirty(inode);
 	iput(inode);
 out_dir:
-	inode_dec_link_count(dir);
+	drop_nlink(dir);
+	mark_inode_dirty(dir);
 	goto out;
 }
 
@@ -317,7 +323,8 @@ static int nilfs_unlink(struct inode *dir, struct dentry *dentry)
 		goto out;
 
 	inode->i_ctime = dir->i_ctime;
-	inode_dec_link_count(inode);
+	drop_nlink(inode);
+	mark_inode_dirty(inode);
 	err = 0;
 out:
 	if (!err)
@@ -343,8 +350,10 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 		err = nilfs_unlink(dir, dentry);
 		if (!err) {
 			inode->i_size = 0;
-			inode_dec_link_count(inode);
-			inode_dec_link_count(dir);
+			drop_nlink(inode);
+			mark_inode_dirty(inode);
+			drop_nlink(dir);
+			mark_inode_dirty(dir);
 		}
 	}
 	if (!err)
@@ -395,33 +404,38 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		new_de = nilfs_find_entry(new_dir, new_dentry, &new_page);
 		if (!new_de)
 			goto out_dir;
-		inode_inc_link_count(old_inode);
+		inc_nlink(old_inode);
+		mark_inode_dirty(old_inode);
 		nilfs_set_link(new_dir, new_de, new_page, old_inode);
 		mark_inode_dirty(new_dir);
 		new_inode->i_ctime = CURRENT_TIME;
 		if (dir_de)
 			drop_nlink(new_inode);
-		inode_dec_link_count(new_inode);
+		drop_nlink(new_inode);
+		mark_inode_dirty(new_inode);
 	} else {
 		if (dir_de) {
 			err = -EMLINK;
 			if (new_dir->i_nlink >= NILFS_LINK_MAX)
 				goto out_dir;
 		}
-		inode_inc_link_count(old_inode);
+		inc_nlink(old_inode);
+		mark_inode_dirty(old_inode);
 		err = nilfs_add_link(new_dentry, old_inode);
 		if (err) {
-			inode_dec_link_count(old_inode);
+			drop_nlink(old_inode);
+			mark_inode_dirty(old_inode);
 			goto out_dir;
 		}
-		if (dir_de)
-			inode_inc_link_count(new_dir);
+		if (dir_de) {
+			inc_nlink(new_dir);
+			mark_inode_dirty(new_dir);
+		}
 	}
 
 	/*
 	 * Like most other Unix systems, set the ctime for inodes on a
 	 * rename.
-	 * inode_dec_link_count() will mark the inode dirty.
 	 */
 	old_inode->i_ctime = CURRENT_TIME;
 
@@ -430,7 +444,8 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	if (dir_de) {
 		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
-		inode_dec_link_count(old_dir);
+		drop_nlink(old_dir);
+		mark_inode_dirty(old_dir);
 	}
 	mark_inode_dirty(old_inode);
 
-- 
1.5.6.5
