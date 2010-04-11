From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix typo "numer" -> "number" in alloc.c
Date: Mon, 12 Apr 2010 02:02:16 +0900
Message-ID: <1271005336-22015-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fixes the typo found in a warning message of a persistent object
allocator function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 3f959f1..c2a1387 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -425,7 +425,7 @@ void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
 	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
 				    group_offset, bitmap))
-		printk(KERN_WARNING "%s: entry numer %llu already freed\n",
+		printk(KERN_WARNING "%s: entry number %llu already freed\n",
 		       __func__, (unsigned long long)req->pr_entry_nr);
 
 	nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
