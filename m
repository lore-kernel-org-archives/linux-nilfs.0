From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 5/7] nilfs2: Convert nilfs_find_uncommited_extent() to use filemap_get_folios_contig()
Date: Mon, 15 Aug 2022 11:54:50 -0700
Message-ID: <20220815185452.37447-6-vishal.moola@gmail.com>
References: <20220815185452.37447-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=EVNfKk5ZAzp2gPep1Yofo/UzU1m6EYLq8voCf56STj8=;
        b=M8IZIk7Jp8250xvZqGSMpvSUeZ3dvuFn3bLOlwIQycHml+YrzlnYk0wuRdVtsm8HzU
         bvV65mni8k2mo/XT9hYMsHRILCfrChluFWNGS/L4GOgJ3HhjZGjaAydrW7Z+ztq40Egv
         3wDl0SMEYJ2Fy/s4RzU0l1aGaYxJMmiBfcHn4FhsVr4s7NJVUw6ov8jHJZrpyd8vArg0
         c7Ko09i20UU7E/MjJRaWpiaq4u0vVa0I+rSEomiRhlwa/sFcyD/BE093QgNiriTA2ki7
         vz5yVxU4u1BU6qGKeJnATjpNPSjpB+ezcTUrbIiPkqD4tjBgq9e+1Ui3xXrJ+vmpSBN6
         LlKg==
In-Reply-To: <20220815185452.37447-1-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>

Converted function to use folios throughout. This is in preparation for
the removal of find_get_pages_contig(). Now also supports large folios.

Also cleaned up an unnecessary if statement - pvec.pages[0]->index > index
will always evaluate to false, and filemap_get_folios_contig() returns 0 if
there is no folio found at index.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/nilfs2/page.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 3267e96c256c..40cc8eb0bc8e 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -480,13 +480,13 @@ unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 					    sector_t start_blk,
 					    sector_t *blkoff)
 {
-	unsigned int i;
+	unsigned int i, nr;
 	pgoff_t index;
 	unsigned int nblocks_in_page;
 	unsigned long length = 0;
 	sector_t b;
-	struct pagevec pvec;
-	struct page *page;
+	struct folio_batch fbatch;
+	struct folio *folio;
 
 	if (inode->i_mapping->nrpages == 0)
 		return 0;
@@ -494,27 +494,24 @@ unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 	index = start_blk >> (PAGE_SHIFT - inode->i_blkbits);
 	nblocks_in_page = 1U << (PAGE_SHIFT - inode->i_blkbits);
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
 repeat:
-	pvec.nr = find_get_pages_contig(inode->i_mapping, index, PAGEVEC_SIZE,
-					pvec.pages);
-	if (pvec.nr == 0)
+	nr = filemap_get_folios_contig(inode->i_mapping, &index, ULONG_MAX,
+			&fbatch);
+	if (nr == 0)
 		return length;
 
-	if (length > 0 && pvec.pages[0]->index > index)
-		goto out;
-
-	b = pvec.pages[0]->index << (PAGE_SHIFT - inode->i_blkbits);
+	b = fbatch.folios[0]->index << (PAGE_SHIFT - inode->i_blkbits);
 	i = 0;
 	do {
-		page = pvec.pages[i];
+		folio = fbatch.folios[i];
 
-		lock_page(page);
-		if (page_has_buffers(page)) {
+		folio_lock(folio);
+		if (folio_buffers(folio)) {
 			struct buffer_head *bh, *head;
 
-			bh = head = page_buffers(page);
+			bh = head = folio_buffers(folio);
 			do {
 				if (b < start_blk)
 					continue;
@@ -532,18 +529,17 @@ unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 
 			b += nblocks_in_page;
 		}
-		unlock_page(page);
+		folio_unlock(folio);
 
-	} while (++i < pagevec_count(&pvec));
+	} while (++i < nr);
 
-	index = page->index + 1;
-	pagevec_release(&pvec);
+	folio_batch_release(&fbatch);
 	cond_resched();
 	goto repeat;
 
 out_locked:
-	unlock_page(page);
+	folio_unlock(folio);
 out:
-	pagevec_release(&pvec);
+	folio_batch_release(&fbatch);
 	return length;
 }
-- 
2.36.1

