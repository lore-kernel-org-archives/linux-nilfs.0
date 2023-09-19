From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 10/26] nilfs2: Convert nilfs_grab_buffer() to use a folio
Date: Tue, 19 Sep 2023 05:51:19 +0100
Message-ID: <20230919045135.3635437-11-willy@infradead.org>
References: <20230919045135.3635437-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <reiserfs-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=+wTdVqWyKgBbS+9qDOyV58Ls9Ihpcoj+lHfeR43k9+Q=; b=EjS/vigaWbpkvkGHq21vO/7U48
        RQAWODt7t/VES3aBpMUIwR5YYN4T23Yijfp7DzSe3jp7TMySxccYDilu/C061YO7Zvc0Xa3XEZyqo
        vEJu89mX7GcmDNPthus4SryoavJutE7J0LgWie/fLkRXsjbJUu3wQh/lPGBQUlNpuvOLAl9UrE4wq
        264M38IuMR/1qDkHqrVxNpEMOf5yoOxuScr1xdtx+m4K74BNZY1OZy6yYHJ88XEuTDGSGnUOvsV2t
        5NwNAEnwlWO6I0eqbfEKWozrz2UvMdvXUfr3KhMwTOIxkj9zlT0wcwyqC+S7pv1+v8WPIT8eAEeBF
        KvQqUDCg==;
In-Reply-To: <20230919045135.3635437-1-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>

Remove a number of folio->page->folio conversions.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/page.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index b4e54d079b7d..1c075bd906c9 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -25,19 +25,19 @@
 	(BIT(BH_Uptodate) | BIT(BH_Mapped) | BIT(BH_NILFS_Node) |	\
 	 BIT(BH_NILFS_Volatile) | BIT(BH_NILFS_Checked))
 
-static struct buffer_head *
-__nilfs_get_page_block(struct page *page, unsigned long block, pgoff_t index,
-		       int blkbits, unsigned long b_state)
+static struct buffer_head *__nilfs_get_folio_block(struct folio *folio,
+		unsigned long block, pgoff_t index, int blkbits,
+		unsigned long b_state)
 
 {
 	unsigned long first_block;
-	struct buffer_head *bh;
+	struct buffer_head *bh = folio_buffers(folio);
 
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << blkbits, b_state);
+	if (!bh)
+		bh = folio_create_empty_buffers(folio, 1 << blkbits, b_state);
 
 	first_block = (unsigned long)index << (PAGE_SHIFT - blkbits);
-	bh = nilfs_page_get_nth_block(page, block - first_block);
+	bh = get_nth_bh(bh, block - first_block);
 
 	touch_buffer(bh);
 	wait_on_buffer(bh);
@@ -51,17 +51,17 @@ struct buffer_head *nilfs_grab_buffer(struct inode *inode,
 {
 	int blkbits = inode->i_blkbits;
 	pgoff_t index = blkoff >> (PAGE_SHIFT - blkbits);
-	struct page *page;
+	struct folio *folio;
 	struct buffer_head *bh;
 
-	page = grab_cache_page(mapping, index);
-	if (unlikely(!page))
+	folio = filemap_grab_folio(mapping, index);
+	if (IS_ERR(folio))
 		return NULL;
 
-	bh = __nilfs_get_page_block(page, blkoff, index, blkbits, b_state);
+	bh = __nilfs_get_folio_block(folio, blkoff, index, blkbits, b_state);
 	if (unlikely(!bh)) {
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 		return NULL;
 	}
 	return bh;
-- 
2.40.1

