From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv2 5/9] nilfs2: split nilfs_unlink as
	nilfs_do_unlink and nilfs_unlink
Date: Fri, 27 Nov 2009 19:41:10 +0900
Message-ID: <1259318474-28342-6-git-send-email-jir@unicus.jp>
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

Split nilfs_unlink() to reduce nested transaction and duplicate
mark_inode_dirty() calls when calling nilfs_unlink() from nilfs_rmdir().

nilfs_do_unlink() is an actual unlink functionality which is not
in transaction and does not call mark_inode_dirty() for dentry argument.

nilfs_unlink() is a wrapper function for do_nilfs_unlink() with
transaction and mark_inode_dirty() for dentry argument.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/namei.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 35f59da..d92e839 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -288,18 +288,13 @@ out_dir:
 	goto out;
 }
 
-static int nilfs_unlink(struct inode *dir, struct dentry *dentry)
+static int nilfs_do_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode;
 	struct nilfs_dir_entry *de;
 	struct page *page;
-	struct nilfs_transaction_info ti;
 	int err;
 
-	err = nilfs_transaction_begin(dir->i_sb, &ti, 0);
-	if (err)
-		return err;
-
 	err = -ENOENT;
 	de = nilfs_find_entry(dir, dentry, &page);
 	if (!de)
@@ -322,12 +317,26 @@ static int nilfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	inode->i_ctime = dir->i_ctime;
 	drop_nlink(inode);
-	mark_inode_dirty(inode);
 	err = 0;
 out:
-	if (!err)
+	return err;
+}
+
+static int nilfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct nilfs_transaction_info ti;
+	int err;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 0);
+	if (err)
+		return err;
+
+	err = nilfs_do_unlink(dir, dentry);
+
+	if (!err) {
+		mark_inode_dirty(dentry->d_inode);
 		err = nilfs_transaction_commit(dir->i_sb);
-	else
+	} else
 		nilfs_transaction_abort(dir->i_sb);
 
 	return err;
@@ -345,7 +354,7 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	err = -ENOTEMPTY;
 	if (nilfs_empty_dir(inode)) {
-		err = nilfs_unlink(dir, dentry);
+		err = nilfs_do_unlink(dir, dentry);
 		if (!err) {
 			inode->i_size = 0;
 			drop_nlink(inode);
-- 
1.5.6.5
