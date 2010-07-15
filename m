From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix buffer head leak in nilfs_btnode_submit_block
Date: Thu, 15 Jul 2010 12:59:09 +0900
Message-ID: <1279166349-17791-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_btnode_submit_block() refers to buffer head just before
returning from the function, but it releases the buffer head earlier
than that if nilfs_dat_translate() gets an error.

This has potential for oops in the erroneous case.  This fixes the
issue.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btnode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 447ce47..0a6834b 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -100,6 +100,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 {
 	struct buffer_head *bh;
 	struct inode *inode = NILFS_BTNC_I(btnc);
+	struct page *page;
 	int err;
 
 	bh = nilfs_grab_buffer(inode, btnc, blocknr, 1 << BH_NILFS_Node);
@@ -107,6 +108,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 		return -ENOMEM;
 
 	err = -EEXIST; /* internal code */
+	page = bh->b_page;
 
 	if (buffer_uptodate(bh) || buffer_dirty(bh))
 		goto found;
@@ -143,8 +145,8 @@ found:
 	*pbh = bh;
 
 out_locked:
-	unlock_page(bh->b_page);
-	page_cache_release(bh->b_page);
+	unlock_page(page);
+	page_cache_release(page);
 	return err;
 }
 
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
