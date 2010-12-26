From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/6] nilfs2: simplify nilfs_mdt_freeze_buffer
Date: Mon, 27 Dec 2010 01:02:39 +0900
Message-ID: <1293379362-3340-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

nilfs_page_get_nth_block() function used in nilfs_mdt_freeze_buffer()
always returns a valid buffer head, so its validity check can be
removed.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index f5d4b18..6a0e2a1 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -493,31 +493,29 @@ int nilfs_mdt_freeze_buffer(struct inode *inode, struct buffer_head *bh)
 	struct buffer_head *bh_frozen;
 	struct page *page;
 	int blkbits = inode->i_blkbits;
-	int ret = -ENOMEM;
 
 	page = grab_cache_page(&shadow->frozen_data, bh->b_page->index);
 	if (!page)
-		return ret;
+		return -ENOMEM;
 
 	if (!page_has_buffers(page))
 		create_empty_buffers(page, 1 << blkbits, 0);
 
 	bh_frozen = nilfs_page_get_nth_block(page, bh_offset(bh) >> blkbits);
-	if (bh_frozen) {
-		if (!buffer_uptodate(bh_frozen))
-			nilfs_copy_buffer(bh_frozen, bh);
-		if (list_empty(&bh_frozen->b_assoc_buffers)) {
-			list_add_tail(&bh_frozen->b_assoc_buffers,
-				      &shadow->frozen_buffers);
-			set_buffer_nilfs_redirected(bh);
-		} else {
-			brelse(bh_frozen); /* already frozen */
-		}
-		ret = 0;
+
+	if (!buffer_uptodate(bh_frozen))
+		nilfs_copy_buffer(bh_frozen, bh);
+	if (list_empty(&bh_frozen->b_assoc_buffers)) {
+		list_add_tail(&bh_frozen->b_assoc_buffers,
+			      &shadow->frozen_buffers);
+		set_buffer_nilfs_redirected(bh);
+	} else {
+		brelse(bh_frozen); /* already frozen */
 	}
+
 	unlock_page(page);
 	page_cache_release(page);
-	return ret;
+	return 0;
 }
 
 struct buffer_head *
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
