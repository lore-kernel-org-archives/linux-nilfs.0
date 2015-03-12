From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/7] nilfs2: use set_mask_bits() for operations on buffer state bitmap
Date: Thu, 12 Mar 2015 23:38:09 +0900
Message-ID: <1426171094-27414-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1426171094-27414-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=CcV8nRt1r2kHLcQomoBzmhbNP/2kIxF1snP7nU4S1WM=;
        b=VYpNH3YL59P0iRmHL6zD+KM46a6+wehaQ754M9jvohU4L2wn+psScjGz5mimoyWUPo
         qE5JKWNk3kN30XQIVSmPHK/lVlazXpv65szLwzBngzIqnr3O/7BR+UHO/g55GOMFrewQ
         vyHNlULVVMwi+1/LVCE7TCLN7KlG/634DZUZ9lKoih3l2xsPMinXkmpqR4Moo4Gdq9vc
         LPFR2hUFgxmD08wui94EM5w4ov4irwJDS+2s3Rmh9uGtNAKHpmoCDWOX5+Hs3flFNGS0
         WEgqBzQ3EXNLb2KsnjxU6VTyVMMA4go79fzx5w2jchSfq8WV/kov93DVSy6+O1o4pdaL
         Aj2Q==
In-Reply-To: <1426171094-27414-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_forget_buffer(), nilfs_clear_dirty_page(), and
nilfs_segctor_complete_write() are using a bunch of atomic bit
operations against buffer state bitmap.

This reduces the number of them by utilizing set_mask_bits() macro.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/page.c    | 24 ++++++++++--------------
 fs/nilfs2/segment.c | 14 ++++++++------
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 700ecbc..45d650a 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -89,18 +89,16 @@ struct buffer_head *nilfs_grab_buffer(struct inode *inode,
 void nilfs_forget_buffer(struct buffer_head *bh)
 {
 	struct page *page = bh->b_page;
+	const unsigned long clear_bits =
+		(1 << BH_Uptodate | 1 << BH_Dirty | 1 << BH_Mapped |
+		 1 << BH_Async_Write | 1 << BH_NILFS_Volatile |
+		 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected);
 
 	lock_buffer(bh);
-	clear_buffer_nilfs_volatile(bh);
-	clear_buffer_nilfs_checked(bh);
-	clear_buffer_nilfs_redirected(bh);
-	clear_buffer_async_write(bh);
-	clear_buffer_dirty(bh);
+	set_mask_bits(&bh->b_state, clear_bits, 0);
 	if (nilfs_page_buffers_clean(page))
 		__nilfs_clear_page_dirty(page);
 
-	clear_buffer_uptodate(bh);
-	clear_buffer_mapped(bh);
 	bh->b_blocknr = -1;
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
@@ -421,6 +419,10 @@ void nilfs_clear_dirty_page(struct page *page, bool silent)
 
 	if (page_has_buffers(page)) {
 		struct buffer_head *bh, *head;
+		const unsigned long clear_bits =
+			(1 << BH_Uptodate | 1 << BH_Dirty | 1 << BH_Mapped |
+			 1 << BH_Async_Write | 1 << BH_NILFS_Volatile |
+			 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected);
 
 		bh = head = page_buffers(page);
 		do {
@@ -430,13 +432,7 @@ void nilfs_clear_dirty_page(struct page *page, bool silent)
 					"discard block %llu, size %zu",
 					(u64)bh->b_blocknr, bh->b_size);
 			}
-			clear_buffer_async_write(bh);
-			clear_buffer_dirty(bh);
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
index c9a4e60..c6abbad9 100644
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
@@ -1785,12 +1786,13 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 		 */
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			set_buffer_uptodate(bh);
-			clear_buffer_dirty(bh);
-			clear_buffer_async_write(bh);
-			clear_buffer_delay(bh);
-			clear_buffer_nilfs_volatile(bh);
-			clear_buffer_nilfs_redirected(bh);
+			const unsigned long set_bits = (1 << BH_Uptodate);
+			const unsigned long clear_bits =
+				(1 << BH_Dirty | 1 << BH_Async_Write |
+				 1 << BH_Delay | 1 << BH_NILFS_Volatile |
+				 1 << BH_NILFS_Redirected);
+
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
