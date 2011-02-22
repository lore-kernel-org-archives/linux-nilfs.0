From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: add free entries count only if clear bit operation succeeded
Date: Wed, 23 Feb 2011 02:53:57 +0900
Message-ID: <1298397237-17468-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1298397237-17468-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298397237-17468-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Three functions of the current persistent object allocator,
nilfs_palloc_commit_free_entry, nilfs_palloc_abort_alloc_entry, and
nilfs_palloc_freev functions unconditionally add a counter after clear
bit operation on a bitmap block succeeded.

If the clear bit operation overlapped, the counter will not add up.
This fixes the issue by making the counter operations conditional.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index d7fd696..0a0a66d 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -521,8 +521,8 @@ void nilfs_palloc_commit_free_entry(struct inode *inode,
 				    group_offset, bitmap))
 		printk(KERN_WARNING "%s: entry number %llu already freed\n",
 		       __func__, (unsigned long long)req->pr_entry_nr);
-
-	nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
+	else
+		nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
 
 	kunmap(req->pr_bitmap_bh->b_page);
 	kunmap(req->pr_desc_bh->b_page);
@@ -558,8 +558,8 @@ void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 				    group_offset, bitmap))
 		printk(KERN_WARNING "%s: entry number %llu already freed\n",
 		       __func__, (unsigned long long)req->pr_entry_nr);
-
-	nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
+	else
+		nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
 
 	kunmap(req->pr_bitmap_bh->b_page);
 	kunmap(req->pr_desc_bh->b_page);
@@ -665,7 +665,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 		for (j = i, n = 0;
 		     (j < nitems) && nilfs_palloc_group_is_in(inode, group,
 							      entry_nrs[j]);
-		     j++, n++) {
+		     j++) {
 			nilfs_palloc_group(inode, entry_nrs[j], &group_offset);
 			if (!nilfs_clear_bit_atomic(
 				    nilfs_mdt_bgl_lock(inode, group),
@@ -674,6 +674,8 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 				       "%s: entry number %llu already freed\n",
 				       __func__,
 				       (unsigned long long)entry_nrs[j]);
+			} else {
+				n++;
 			}
 		}
 		nilfs_palloc_group_desc_add_entries(inode, group, desc, n);
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
