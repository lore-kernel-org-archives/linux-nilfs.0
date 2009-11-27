From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv2 9/9] nilfs2: replace mark_inode_dirty as
	nilfs_mark_inode_dirty
Date: Fri, 27 Nov 2009 19:41:14 +0900
Message-ID: <1259318474-28342-10-git-send-email-jir@unicus.jp>
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

Replace mark_inode_dirty() as nilfs_mark_inode_dirty()
to reduce deep function calls.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/dir.c   |    2 +-
 fs/nilfs2/inode.c |    6 +++---
 fs/nilfs2/namei.c |   32 ++++++++++++++++----------------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 1d9a4e4..76d803e 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -548,7 +548,7 @@ got_it:
 	nilfs_commit_chunk(page, page->mapping, from, to);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 /*	NILFS_I(dir)->i_flags &= ~NILFS_BTREE_FL; */
-	mark_inode_dirty(dir);
+	nilfs_mark_inode_dirty(dir);
 	/* OFFSET_CACHE */
 out_put:
 	nilfs_put_page(page);
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index ede0375..7868cc1 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -97,7 +97,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 			nilfs_transaction_abort(inode->i_sb);
 			goto out;
 		}
-		mark_inode_dirty(inode);
+		nilfs_mark_inode_dirty(inode);
 		nilfs_transaction_commit(inode->i_sb); /* never fails */
 		/* Error handling should be detailed */
 		set_buffer_new(bh_result);
@@ -598,7 +598,7 @@ void nilfs_truncate(struct inode *inode)
 	if (IS_SYNC(inode))
 		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 
-	mark_inode_dirty(inode);
+	nilfs_mark_inode_dirty(inode);
 	nilfs_set_file_dirty(NILFS_SB(sb), inode, 0);
 	nilfs_transaction_commit(sb);
 	/* May construct a logical segment and may fail in sync mode.
@@ -623,7 +623,7 @@ void nilfs_delete_inode(struct inode *inode)
 		truncate_inode_pages(&inode->i_data, 0);
 
 	nilfs_truncate_bmap(ii, 0);
-	mark_inode_dirty(inode);
+	nilfs_mark_inode_dirty(inode);
 	nilfs_free_inode(inode);
 	/* nilfs_free_inode() marks inode buffer dirty */
 	if (IS_SYNC(inode))
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 4237722..07ba838 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -120,7 +120,7 @@ static int nilfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		inode->i_op = &nilfs_file_inode_operations;
 		inode->i_fop = &nilfs_file_operations;
 		inode->i_mapping->a_ops = &nilfs_aops;
-		mark_inode_dirty(inode);
+		nilfs_mark_inode_dirty(inode);
 		err = nilfs_add_nondir(dentry, inode);
 	}
 	if (!err)
@@ -148,7 +148,7 @@ nilfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
-		mark_inode_dirty(inode);
+		nilfs_mark_inode_dirty(inode);
 		err = nilfs_add_nondir(dentry, inode);
 	}
 	if (!err)
@@ -201,7 +201,7 @@ out:
 
 out_fail:
 	drop_nlink(inode);
-	mark_inode_dirty(inode);
+	nilfs_mark_inode_dirty(inode);
 	iput(inode);
 	goto out;
 }
@@ -267,7 +267,7 @@ static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (err)
 		goto out_fail;
 
-	mark_inode_dirty(inode);
+	nilfs_mark_inode_dirty(inode);
 	d_instantiate(dentry, inode);
 out:
 	if (!err)
@@ -280,11 +280,11 @@ out:
 out_fail:
 	drop_nlink(inode);
 	drop_nlink(inode);
-	mark_inode_dirty(inode);
+	nilfs_mark_inode_dirty(inode);
 	iput(inode);
 out_dir:
 	drop_nlink(dir);
-	mark_inode_dirty(dir);
+	nilfs_mark_inode_dirty(dir);
 	goto out;
 }
 
@@ -334,8 +334,8 @@ static int nilfs_unlink(struct inode *dir, struct dentry *dentry)
 	err = nilfs_do_unlink(dir, dentry);
 
 	if (!err) {
-		mark_inode_dirty(dir);
-		mark_inode_dirty(dentry->d_inode);
+		nilfs_mark_inode_dirty(dir);
+		nilfs_mark_inode_dirty(dentry->d_inode);
 		err = nilfs_transaction_commit(dir->i_sb);
 	} else
 		nilfs_transaction_abort(dir->i_sb);
@@ -359,9 +359,9 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 		if (!err) {
 			inode->i_size = 0;
 			drop_nlink(inode);
-			mark_inode_dirty(inode);
+			nilfs_mark_inode_dirty(inode);
 			drop_nlink(dir);
-			mark_inode_dirty(dir);
+			nilfs_mark_inode_dirty(dir);
 		}
 	}
 	if (!err)
@@ -414,12 +414,12 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto out_dir;
 		inc_nlink(old_inode);
 		nilfs_set_link(new_dir, new_de, new_page, old_inode);
-		mark_inode_dirty(new_dir);
+		nilfs_mark_inode_dirty(new_dir);
 		new_inode->i_ctime = CURRENT_TIME;
 		if (dir_de)
 			drop_nlink(new_inode);
 		drop_nlink(new_inode);
-		mark_inode_dirty(new_inode);
+		nilfs_mark_inode_dirty(new_inode);
 	} else {
 		if (dir_de) {
 			err = -EMLINK;
@@ -430,12 +430,12 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		err = nilfs_add_link(new_dentry, old_inode);
 		if (err) {
 			drop_nlink(old_inode);
-			mark_inode_dirty(old_inode);
+			nilfs_mark_inode_dirty(old_inode);
 			goto out_dir;
 		}
 		if (dir_de) {
 			inc_nlink(new_dir);
-			mark_inode_dirty(new_dir);
+			nilfs_mark_inode_dirty(new_dir);
 		}
 	}
 
@@ -452,8 +452,8 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
 		drop_nlink(old_dir);
 	}
-	mark_inode_dirty(old_dir);
-	mark_inode_dirty(old_inode);
+	nilfs_mark_inode_dirty(old_dir);
+	nilfs_mark_inode_dirty(old_inode);
 
 	err = nilfs_transaction_commit(old_dir->i_sb);
 	return err;
-- 
1.5.6.5
