From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 02/10] buffer: Convert clean_bdev_aliases() to use filemap_get_folios()
Date: Sun,  5 Jun 2022 20:38:46 +0100
Message-ID: <20220605193854.2371230-3-willy@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=qbG5jYA5/B/9NK52X0Zwpy+RVhS8Khdm3bEIuVIcSSs=; b=dOOkwE/qwu6ai6SUG6KU2Tcj1b
        tYf86pT1eVKho3dRG7hvwfX/ICj+XRb4tRZDY8EXwKCl7ilsNUd9anX0RT70ecMt1/vbB4uTsJa03
        6G9046ewtZLLSDSY86dJSRTdn3qjPyrzchTDI7Vi8EL0DNHGZ/8j/SWIP6c9Huez/h5GoE/7d8YU3
        sKyP6kBMp9MY/fjj7QQgCy9/z7ux3TGP37ac4Purw7SgOVkW3wBetmcl1SZADajRYm/kr0rUaF6vt
        VdvVDgkAGQvgMjThr4db/KHBEvWcsMQrBgqzAprcRIAtIkegr3AoYkWgpMhBM6RcwtgML5fjs8gL0
        j/U8tA5A==;
In-Reply-To: <20220605193854.2371230-1-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-nilfs@vger.kernel.org

Use a folio throughout this function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/buffer.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 898c7f301b1b..276769d3715a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1604,7 +1604,7 @@ void clean_bdev_aliases(struct block_device *bdev, sector_t block, sector_t len)
 {
 	struct inode *bd_inode = bdev->bd_inode;
 	struct address_space *bd_mapping = bd_inode->i_mapping;
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	pgoff_t index = block >> (PAGE_SHIFT - bd_inode->i_blkbits);
 	pgoff_t end;
 	int i, count;
@@ -1612,24 +1612,24 @@ void clean_bdev_aliases(struct block_device *bdev, sector_t block, sector_t len)
 	struct buffer_head *head;
 
 	end = (block + len - 1) >> (PAGE_SHIFT - bd_inode->i_blkbits);
-	pagevec_init(&pvec);
-	while (pagevec_lookup_range(&pvec, bd_mapping, &index, end)) {
-		count = pagevec_count(&pvec);
+	folio_batch_init(&fbatch);
+	while (filemap_get_folios(bd_mapping, &index, end, &fbatch)) {
+		count = folio_batch_count(&fbatch);
 		for (i = 0; i < count; i++) {
-			struct page *page = pvec.pages[i];
+			struct folio *folio = fbatch.folios[i];
 
-			if (!page_has_buffers(page))
+			if (!folio_buffers(folio))
 				continue;
 			/*
-			 * We use page lock instead of bd_mapping->private_lock
+			 * We use folio lock instead of bd_mapping->private_lock
 			 * to pin buffers here since we can afford to sleep and
 			 * it scales better than a global spinlock lock.
 			 */
-			lock_page(page);
-			/* Recheck when the page is locked which pins bhs */
-			if (!page_has_buffers(page))
+			folio_lock(folio);
+			/* Recheck when the folio is locked which pins bhs */
+			head = folio_buffers(folio);
+			if (!head)
 				goto unlock_page;
-			head = page_buffers(page);
 			bh = head;
 			do {
 				if (!buffer_mapped(bh) || (bh->b_blocknr < block))
@@ -1643,9 +1643,9 @@ void clean_bdev_aliases(struct block_device *bdev, sector_t block, sector_t len)
 				bh = bh->b_this_page;
 			} while (bh != head);
 unlock_page:
-			unlock_page(page);
+			folio_unlock(folio);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 		/* End of range already reached? */
 		if (index > end || !index)
-- 
2.35.1

