From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 18/23] nilfs2: unfold
	nilfs_palloc_block_get_bitmap function
Date: Sun, 15 Nov 2009 21:46:56 +0900
Message-ID: <1258289221-3827-19-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258289221-3827-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258289221-3827-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This expands a trivial address calculation in the function into its
every callsite. This expansion improves readability of the callers.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index d69e6ae..7e2b3ce 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -176,13 +176,6 @@ nilfs_palloc_block_get_group_desc(const struct inode *inode,
 		group % nilfs_palloc_groups_per_desc_block(inode);
 }
 
-static unsigned char *
-nilfs_palloc_block_get_bitmap(const struct inode *inode,
-			      const struct buffer_head *bh, void *kaddr)
-{
-	return (unsigned char *)(kaddr + bh_offset(bh));
-}
-
 void *nilfs_palloc_block_get_entry(const struct inode *inode, __u64 nr,
 				   const struct buffer_head *bh, void *kaddr)
 {
@@ -289,8 +282,7 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 				if (ret < 0)
 					goto out_desc;
 				bitmap_kaddr = kmap(bitmap_bh->b_page);
-				bitmap = nilfs_palloc_block_get_bitmap(
-					inode, bitmap_bh, bitmap_kaddr);
+				bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 				pos = nilfs_palloc_find_available_slot(
 					inode, group, group_offset, bitmap,
 					entries_per_group);
@@ -351,8 +343,7 @@ void nilfs_palloc_commit_free_entry(struct inode *inode,
 	desc = nilfs_palloc_block_get_group_desc(inode, group,
 						 req->pr_desc_bh, desc_kaddr);
 	bitmap_kaddr = kmap(req->pr_bitmap_bh->b_page);
-	bitmap = nilfs_palloc_block_get_bitmap(inode, req->pr_bitmap_bh,
-					       bitmap_kaddr);
+	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
 
 	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
 				    group_offset, bitmap))
@@ -385,8 +376,7 @@ void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 	desc = nilfs_palloc_block_get_group_desc(inode, group,
 						 req->pr_desc_bh, desc_kaddr);
 	bitmap_kaddr = kmap(req->pr_bitmap_bh->b_page);
-	bitmap = nilfs_palloc_block_get_bitmap(inode, req->pr_bitmap_bh,
-					       bitmap_kaddr);
+	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
 	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
 				    group_offset, bitmap))
 		printk(KERN_WARNING "%s: entry numer %llu already freed\n",
@@ -472,8 +462,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 		desc = nilfs_palloc_block_get_group_desc(
 			inode, group, desc_bh, desc_kaddr);
 		bitmap_kaddr = kmap(bitmap_bh->b_page);
-		bitmap = nilfs_palloc_block_get_bitmap(
-			inode, bitmap_bh, bitmap_kaddr);
+		bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 		for (j = i, n = 0;
 		     (j < nitems) && nilfs_palloc_group_is_in(inode, group,
 							      entry_nrs[j]);
-- 
1.6.3.4
