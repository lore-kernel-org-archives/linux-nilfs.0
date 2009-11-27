From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 6/9] nilfs2: change return type of
	nilfs_commit_chunk
Date: Fri, 27 Nov 2009 16:02:01 +0900
Message-ID: <1259305324-28050-7-git-send-email-jir@unicus.jp>
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

Change return type of nilfs_commit_chunk() as void from int,
for nilfs_set_file_dirty() usually does not return error.

This is an intermediate patch to reduce mark_inode_dirty() in
nilfs_commit_chunk().

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/dir.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 4f3fa00..173530d 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -99,9 +99,9 @@ static int nilfs_prepare_chunk(struct page *page,
 				 NULL, nilfs_get_block);
 }
 
-static int nilfs_commit_chunk(struct page *page,
-			      struct address_space *mapping,
-			      unsigned from, unsigned to)
+static void nilfs_commit_chunk(struct page *page,
+			       struct address_space *mapping,
+			       unsigned from, unsigned to)
 {
 	struct inode *dir = mapping->host;
 	struct nilfs_sb_info *sbi = NILFS_SB(dir->i_sb);
@@ -119,8 +119,8 @@ static int nilfs_commit_chunk(struct page *page,
 	if (IS_DIRSYNC(dir))
 		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 	err = nilfs_set_file_dirty(sbi, dir, nr_dirty);
+	WARN_ON(err); /* do not happen */
 	unlock_page(page);
-	return err;
 }
 
 static void nilfs_check_page(struct page *page)
@@ -455,7 +455,7 @@ void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 	BUG_ON(err);
 	de->inode = cpu_to_le64(inode->i_ino);
 	nilfs_set_de_type(de, inode);
-	err = nilfs_commit_chunk(page, mapping, from, to);
+	nilfs_commit_chunk(page, mapping, from, to);
 	nilfs_put_page(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 /*	NILFS_I(dir)->i_flags &= ~NILFS_BTREE_FL; */
@@ -547,7 +547,7 @@ got_it:
 	memcpy(de->name, name, namelen);
 	de->inode = cpu_to_le64(inode->i_ino);
 	nilfs_set_de_type(de, inode);
-	err = nilfs_commit_chunk(page, page->mapping, from, to);
+	nilfs_commit_chunk(page, page->mapping, from, to);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 /*	NILFS_I(dir)->i_flags &= ~NILFS_BTREE_FL; */
 	mark_inode_dirty(dir);
@@ -594,7 +594,7 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 	if (pde)
 		pde->rec_len = cpu_to_le16(to - from);
 	dir->inode = 0;
-	err = nilfs_commit_chunk(page, mapping, from, to);
+	nilfs_commit_chunk(page, mapping, from, to);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 /*	NILFS_I(inode)->i_flags &= ~NILFS_BTREE_FL; */
 	mark_inode_dirty(inode);
@@ -639,7 +639,7 @@ int nilfs_make_empty(struct inode *inode, struct inode *parent)
 	memcpy(de->name, "..\0", 4);
 	nilfs_set_de_type(de, inode);
 	kunmap_atomic(kaddr, KM_USER0);
-	err = nilfs_commit_chunk(page, mapping, 0, chunk_size);
+	nilfs_commit_chunk(page, mapping, 0, chunk_size);
 fail:
 	page_cache_release(page);
 	return err;
-- 
1.5.6.5
