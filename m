From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/6] nilfs2: do not pass sbi to functions which can get it from inode
Date: Mon, 27 Dec 2010 01:02:41 +0900
Message-ID: <1293379362-3340-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1293379362-3340-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293379362-3340-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This removes argument for passing nilfs_sb_info structure from
nilfs_set_file_dirty and nilfs_load_inode_block functions.  We can get
a pointer to the structure from inodes.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/dir.c      |    3 +--
 fs/nilfs2/inode.c    |   18 ++++++++----------
 fs/nilfs2/nilfs.h    |    6 ++----
 fs/nilfs2/recovery.c |    2 +-
 4 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index cb003c8..9d45773 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -91,7 +91,6 @@ static void nilfs_commit_chunk(struct page *page,
 			       unsigned from, unsigned to)
 {
 	struct inode *dir = mapping->host;
-	struct nilfs_sb_info *sbi = NILFS_SB(dir->i_sb);
 	loff_t pos = page_offset(page) + from;
 	unsigned len = to - from;
 	unsigned nr_dirty, copied;
@@ -103,7 +102,7 @@ static void nilfs_commit_chunk(struct page *page,
 		i_size_write(dir, pos + copied);
 	if (IS_DIRSYNC(dir))
 		nilfs_set_transaction_flag(NILFS_TI_SYNC);
-	err = nilfs_set_file_dirty(sbi, dir, nr_dirty);
+	err = nilfs_set_file_dirty(dir, nr_dirty);
 	WARN_ON(err); /* do not happen */
 	unlock_page(page);
 }
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index e96ef23..de38843 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -181,10 +181,9 @@ static int nilfs_set_page_dirty(struct page *page)
 
 	if (ret) {
 		struct inode *inode = page->mapping->host;
-		struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
 		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
 
-		nilfs_set_file_dirty(sbi, inode, nr_dirty);
+		nilfs_set_file_dirty(inode, nr_dirty);
 	}
 	return ret;
 }
@@ -225,7 +224,7 @@ static int nilfs_write_end(struct file *file, struct address_space *mapping,
 						  start + copied);
 	copied = generic_write_end(file, mapping, pos, len, copied, page,
 				   fsdata);
-	nilfs_set_file_dirty(NILFS_SB(inode->i_sb), inode, nr_dirty);
+	nilfs_set_file_dirty(inode, nr_dirty);
 	err = nilfs_transaction_commit(inode->i_sb);
 	return err ? : copied;
 }
@@ -674,7 +673,7 @@ void nilfs_truncate(struct inode *inode)
 		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 
 	nilfs_mark_inode_dirty(inode);
-	nilfs_set_file_dirty(NILFS_SB(sb), inode, 0);
+	nilfs_set_file_dirty(inode, 0);
 	nilfs_transaction_commit(sb);
 	/* May construct a logical segment and may fail in sync mode.
 	   But truncate has no return value. */
@@ -788,9 +787,9 @@ int nilfs_permission(struct inode *inode, int mask)
 	return generic_permission(inode, mask, NULL);
 }
 
-int nilfs_load_inode_block(struct nilfs_sb_info *sbi, struct inode *inode,
-			   struct buffer_head **pbh)
+int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh)
 {
+	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	int err;
 
@@ -831,9 +830,9 @@ int nilfs_inode_dirty(struct inode *inode)
 	return ret;
 }
 
-int nilfs_set_file_dirty(struct nilfs_sb_info *sbi, struct inode *inode,
-			 unsigned nr_dirty)
+int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty)
 {
+	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 
 	atomic_add(nr_dirty, &sbi->s_nilfs->ns_ndirtyblks);
@@ -866,11 +865,10 @@ int nilfs_set_file_dirty(struct nilfs_sb_info *sbi, struct inode *inode,
 
 int nilfs_mark_inode_dirty(struct inode *inode)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
 	struct buffer_head *ibh;
 	int err;
 
-	err = nilfs_load_inode_block(sbi, inode, &ibh);
+	err = nilfs_load_inode_block(inode, &ibh);
 	if (unlikely(err)) {
 		nilfs_warning(inode->i_sb, __func__,
 			      "failed to reget inode block.\n");
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 5b10f14..80b867f 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -257,11 +257,9 @@ extern void nilfs_truncate(struct inode *);
 extern void nilfs_evict_inode(struct inode *);
 extern int nilfs_setattr(struct dentry *, struct iattr *);
 int nilfs_permission(struct inode *inode, int mask);
-extern int nilfs_load_inode_block(struct nilfs_sb_info *, struct inode *,
-				  struct buffer_head **);
+int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh);
 extern int nilfs_inode_dirty(struct inode *);
-extern int nilfs_set_file_dirty(struct nilfs_sb_info *, struct inode *,
-				unsigned);
+int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty);
 extern int nilfs_mark_inode_dirty(struct inode *);
 extern void nilfs_dirty_inode(struct inode *);
 int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 5d2711c2..3dfcd3b 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -535,7 +535,7 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 		if (unlikely(err))
 			goto failed_page;
 
-		err = nilfs_set_file_dirty(sbi, inode, 1);
+		err = nilfs_set_file_dirty(inode, 1);
 		if (unlikely(err))
 			goto failed_page;
 
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
