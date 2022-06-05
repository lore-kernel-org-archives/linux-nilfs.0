From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 04/10] ext4: Convert mpage_map_and_submit_buffers() to use filemap_get_folios()
Date: Sun,  5 Jun 2022 20:38:48 +0100
Message-ID: <20220605193854.2371230-5-willy@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=W0H1cUQxatSgPZ6f11mLW4N05/pdthUaWOiji2r395Q=; b=vuZO7CSb7H6HQ4un97k5YqfJpv
        WRg4mesPevoGA4XIOIVE2ut/fbhfu85CTaveBcVULnFub7Mfq5oIGpDukf0GFFOtdms/yjo0srNbQ
        qAmlTagDosQ/iwYURVheI7Qn+0e+JiM35saYHuorbgNvOmwFZTGBSMX9gPqyPwtmqTCUpQrgxt08L
        zl+fZroMOE3CbrwEnxjVw9xWa9I9OBtn3/LlANUrlXOhUPAwmGVpiC8vKuDk0hB0q5d8Esreir30M
        qp+56a/8G270ZD18zh3VnRwQbfUZOj9Qy+FiUOVDgrzK9OgPFG3nJ+7PP+FJ4hse3IB4PQ0w6ecGA
        OfEX515Q==;
In-Reply-To: <20220605193854.2371230-1-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-nilfs@vger.kernel.org

The called functions all use pages, so just convert back to a page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ext4/inode.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 32a7f5e024d6..1aaea53e67b5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2314,8 +2314,8 @@ static int mpage_process_page(struct mpage_da_data *mpd, struct page *page,
  */
 static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 {
-	struct pagevec pvec;
-	int nr_pages, i;
+	struct folio_batch fbatch;
+	unsigned nr, i;
 	struct inode *inode = mpd->inode;
 	int bpp_bits = PAGE_SHIFT - inode->i_blkbits;
 	pgoff_t start, end;
@@ -2329,14 +2329,13 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 	lblk = start << bpp_bits;
 	pblock = mpd->map.m_pblk;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	while (start <= end) {
-		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping,
-						&start, end);
-		if (nr_pages == 0)
+		nr = filemap_get_folios(inode->i_mapping, &start, end, &fbatch);
+		if (nr == 0)
 			break;
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr; i++) {
+			struct page *page = &fbatch.folios[i]->page;
 
 			err = mpage_process_page(mpd, page, &lblk, &pblock,
 						 &map_bh);
@@ -2352,14 +2351,14 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 			if (err < 0)
 				goto out;
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 	}
 	/* Extent fully mapped and matches with page boundary. We are done. */
 	mpd->map.m_len = 0;
 	mpd->map.m_flags = 0;
 	return 0;
 out:
-	pagevec_release(&pvec);
+	folio_batch_release(&fbatch);
 	return err;
 }
 
-- 
2.35.1

