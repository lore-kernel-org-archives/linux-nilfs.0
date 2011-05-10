From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix infinite loop in nilfs_palloc_freev function
Date: Tue, 10 May 2011 22:30:06 +0900
Message-ID: <1305034206-15338-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

After having applied commit 9954e7af14868b8b ("nilfs2: add free
entries count only if clear bit operation succeeded"), a free routine
of nilfs came to fall into an infinite loop, outputting the same
message endlessly:

 nilfs_palloc_freev: entry number 29497 already freed
 nilfs_palloc_freev: entry number 29497 already freed
 nilfs_palloc_freev: entry number 29497 already freed
 nilfs_palloc_freev: entry number 29497 already freed
 nilfs_palloc_freev: entry number 29497 already freed ...

That patch broke the routine so that a loop counter is never updated
in an abnormal state.  This fixes the regression.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 0a0a66d..f768448 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -646,7 +646,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 	unsigned long group, group_offset;
 	int i, j, n, ret;
 
-	for (i = 0; i < nitems; i += n) {
+	for (i = 0; i < nitems; i = j) {
 		group = nilfs_palloc_group(inode, entry_nrs[i], &group_offset);
 		ret = nilfs_palloc_get_desc_block(inode, group, 0, &desc_bh);
 		if (ret < 0)
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
