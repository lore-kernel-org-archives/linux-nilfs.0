From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: use set_mask_bits() for operations on buffer state bitmap
Date: Mon,  9 Feb 2015 00:30:48 +0900
Message-ID: <1423409448-5430-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1423409448-5430-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=wEDgsYh6OVkASf7EcmWad9f1VvEBX6VrqIDlUk6ErC0=;
        b=xoa3L+cgGcljjPLftVgzOYwv0YIOFCZBRRb01ZPiK+vuqYKJrbNZJhJdhTzxoMjcJ4
         IxScnAfhQhTF3n///H9w+wBlVM7UpJNGO0a4PqmtQy67oALuZuiIsI3UXiMVYA5bzDB0
         FyUzOnOvQy/qokq9BF4CgyGuYIM5idndJzXixZnLVhH4xstRAL2IpSv3/AQezRlc04qS
         LtfOv7NVbYb2m93uQJ47hOoDrdjftdXnukAvkYB4ydnCChL7UmpKetSidehZvhdQ7zej
         POywBCdCG9yI7C+jvO8EJ6PZmSCBgB32co6qaLYb3pMsrrioUUuGD0Bnd6glnkRCWZXN
         wscg==
In-Reply-To: <1423409448-5430-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_forget_buffer(), nilfs_clear_dirty_page(), and
nilfs_segctor_complete_write() are using a bunch of atomic bit
operations against buffer state bitmap.

This reduces the number of them by utilizing set_mask_bits() macro.
"BH_Dirty" bit is excluded from this aggregation since a Test-and-Set
bit operation is used to the bit and it's not clear whether the
replacement is safe.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/page.c    | 22 ++++++++++------------
 fs/nilfs2/segment.c | 13 ++++++++-----
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index da27664..9d6c8b9 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -89,18 +89,17 @@ struct buffer_head *nilfs_grab_buffer(struct inode *inode,
 void nilfs_forget_buffer(struct buffer_head *bh)
 {
 	struct page *page = bh->b_page;
+	const unsigned long clear_bits =
+		(1 << BH_Uptodate | 1 << BH_Mapped | 1 << BH_Async_Write |
+		 1 << BH_NILFS_Volatile | 1 << BH_NILFS_Checked |
+		 1 << BH_NILFS_Redirected);
 
 	lock_buffer(bh);
-	clear_buffer_nilfs_volatile(bh);
-	clear_buffer_nilfs_checked(bh);
-	clear_buffer_nilfs_redirected(bh);
-	clear_buffer_async_write(bh);
 	clear_buffer_dirty(bh);
 	if (nilfs_page_buffers_clean(page))
 		__nilfs_clear_page_dirty(page);
+	set_mask_bits(&bh->b_state, clear_bits, 0);
 
-	clear_buffer_uptodate(bh);
-	clear_buffer_mapped(bh);
 	bh->b_blocknr = -1;
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
@@ -421,6 +420,10 @@ void nilfs_clear_dirty_page(struct page *page, bool silent)
 
 	if (page_has_buffers(page)) {
 		struct buffer_head *bh, *head;
+		const unsigned long clear_bits =
+			(1 << BH_Uptodate | 1 << BH_Mapped |
+			 1 << BH_Async_Write | 1 << BH_NILFS_Volatile |
+			 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected);
 
 		bh = head = page_buffers(page);
 		do {
@@ -430,13 +433,8 @@ void nilfs_clear_dirty_page(struct page *page, bool silent)
 					"discard block %llu, size %zu",
 					(u64)bh->b_blocknr, bh->b_size);
 			}
-			clear_buffer_async_write(bh);
 			clear_buffer_dirty(bh);
-			clear_buffer_nilfs_volatile(bh);
-			clear_buffer_nilfs_checked(bh);
-			clear_buffer_nilfs_redirected(bh);
-			clear_buffer_uptodate(bh);
-			clear_buffer_mapped(bh);
+			set_mask_bits(&bh->b_state, clear_bits, 0);
 			unlock_buffer(bh);
 		} while (bh = bh->b_this_page, bh != head);
 	}
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 566cad8..e93b562 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -24,6 +24,7 @@
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
+#include <linux/bitops.h>
 #include <linux/bio.h>
 #include <linux/completion.h>
 #include <linux/blkdev.h>
@@ -1785,12 +1786,14 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 		 */
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			set_buffer_uptodate(bh);
+			const unsigned long set_bits = (1 << BH_Uptodate);
+			const unsigned long clear_bits =
+				(1 << BH_Async_Write | 1 << BH_Delay |
+				 1 << BH_NILFS_Volatile |
+				 1 << BH_NILFS_Redirected);
+
 			clear_buffer_dirty(bh);
-			clear_buffer_async_write(bh);
-			clear_buffer_delay(bh);
-			clear_buffer_nilfs_volatile(bh);
-			clear_buffer_nilfs_redirected(bh);
+			set_mask_bits(&bh->b_state, clear_bits, set_bits);
 			if (bh == segbuf->sb_super_root) {
 				if (bh->b_page != bd_page) {
 					end_page_writeback(bd_page);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
