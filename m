From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: simplify nilfs_get_page function
Date: Sat, 24 Jul 2010 18:04:13 +0900
Message-ID: <1279962253-10468-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Implementation of nilfs_get_page() is a bit old as below:

 - A common read_mapping_page inline function is now available instead
   of its read_cache_page use.
 - wait_on_page_locked() use in the function is eliminable since
   read_cache_page function does the same thing through wait_on_page_read().
 - PageUptodate() check is eliminable for the same reason.

This renews nilfs_get_page() based on these points.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/dir.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 85c89df..d8d183e 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -199,13 +199,10 @@ fail:
 static struct page *nilfs_get_page(struct inode *dir, unsigned long n)
 {
 	struct address_space *mapping = dir->i_mapping;
-	struct page *page = read_cache_page(mapping, n,
-				(filler_t *)mapping->a_ops->readpage, NULL);
+	struct page *page = read_mapping_page(mapping, n, NULL);
+
 	if (!IS_ERR(page)) {
-		wait_on_page_locked(page);
 		kmap(page);
-		if (!PageUptodate(page))
-			goto fail;
 		if (!PageChecked(page))
 			nilfs_check_page(page);
 		if (PageError(page))
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
