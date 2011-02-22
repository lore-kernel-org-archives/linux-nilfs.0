From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: decrement inodes count only if raw inode was successfully deleted
Date: Wed, 23 Feb 2011 02:53:56 +0900
Message-ID: <1298397237-17468-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This fixes the issue that inodes count will not add up after removal
of raw inodes fails.  Hence, this prevents possible under flow of the
inodes count.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 2fd440d..3a6967d 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -707,6 +707,7 @@ void nilfs_evict_inode(struct inode *inode)
 	struct nilfs_transaction_info ti;
 	struct super_block *sb = inode->i_sb;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
+	int ret;
 
 	if (inode->i_nlink || !ii->i_root || unlikely(is_bad_inode(inode))) {
 		if (inode->i_data.nrpages)
@@ -725,8 +726,9 @@ void nilfs_evict_inode(struct inode *inode)
 	nilfs_mark_inode_dirty(inode);
 	end_writeback(inode);
 
-	nilfs_ifile_delete_inode(ii->i_root->ifile, inode->i_ino);
-	atomic_dec(&ii->i_root->inodes_count);
+	ret = nilfs_ifile_delete_inode(ii->i_root->ifile, inode->i_ino);
+	if (!ret)
+		atomic_dec(&ii->i_root->inodes_count);
 
 	nilfs_clear_inode(inode);
 
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
