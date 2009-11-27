From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 7/9] nilfs2: delete mark_inode_dirty in
	nilfs_commit_chunk
Date: Fri, 27 Nov 2009 16:02:02 +0900
Message-ID: <1259305324-28050-8-git-send-email-jir@unicus.jp>
References: <1259305324-28050-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1259305324-28050-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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

Delete mark_inode_dirty() in nilfs_commit_chunk(), for callers of
nilfs_commit_chunk() will call equivalent mark_inode_dirty()
after calling nilfs_commit_chunk().

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/dir.c   |    4 +---
 fs/nilfs2/namei.c |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 173530d..693539b 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -112,10 +112,8 @@ static void nilfs_commit_chunk(struct page *page,
 
 	nr_dirty = nilfs_page_count_clean_buffers(page, from, to);
 	copied = block_write_end(NULL, mapping, pos, len, len, page, NULL);
-	if (pos + copied > dir->i_size) {
+	if (pos + copied > dir->i_size)
 		i_size_write(dir, pos + copied);
-		mark_inode_dirty(dir);
-	}
 	if (IS_DIRSYNC(dir))
 		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 	err = nilfs_set_file_dirty(sbi, dir, nr_dirty);
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index aea6c1a..c662f8e 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -259,7 +259,6 @@ static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	inode->i_mapping->a_ops = &nilfs_aops;
 
 	inc_nlink(inode);
-	mark_inode_dirty(inode);
 
 	err = nilfs_make_empty(inode, dir);
 	if (err)
@@ -269,6 +268,7 @@ static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (err)
 		goto out_fail;
 
+	mark_inode_dirty(inode);
 	d_instantiate(dentry, inode);
 out:
 	if (!err)
-- 
1.5.6.5
