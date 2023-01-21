From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/7] mm: make mapping_get_entry available outside of filemap.c
Date: Sat, 21 Jan 2023 07:57:50 +0100
Message-ID: <20230121065755.1140136-3-hch@lst.de>
References: <20230121065755.1140136-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bHu6JRelc+qZi6VORfZamvMyu/HPfdmrjb1TOTy3Elw=; b=o85/NWmcxDB/Xm7nZyJ0u/OaV4
        ggW//BSlYDr37PRhsjTqUedxbeyHbfv86D0FnsnWS/acgHDwbC7vRGBjt++MRUgQ/3pbPOeeMsEB+
        yjRRjbsrkonl6kRfgvlX4vfhstx9bcDnXebOYT7/I0dFKcfOFG+xhP8bJ1sS4rofk1BV3nKNKtCGc
        HP9YgxyOp5ORr9AQtDyrxpJvPs+obr8M5TM+rXPqQkOu3400e818tBxrWdFkj8ktdzJIM00uyH77B
        JKhwoaJWyaUV/XVYcRHjxVXq35tjpdi8v6cqJRfKVL3Oajn10ei14YSeO22Z6+5oB5hPcuEztJVSc
        Ss7hYuVg==;
In-Reply-To: <20230121065755.1140136-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>
Cc: linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

mapping_get_entry is useful for page cache API users that need to know
about xa_value internals.  Rename it and make it available in pagemap.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 1 +
 mm/filemap.c            | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 9f108168377195..24dedf6b12be49 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -507,6 +507,7 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
 #define FGP_ENTRY		0x00000080
 #define FGP_STABLE		0x00000100
 
+void *filemap_get_entry(struct address_space *mapping, pgoff_t index);
 struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 		int fgp_flags, gfp_t gfp);
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
diff --git a/mm/filemap.c b/mm/filemap.c
index c915ded191f03f..ed0583f9e27512 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1834,7 +1834,7 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  */
 
 /*
- * mapping_get_entry - Get a page cache entry.
+ * filemap_get_entry - Get a page cache entry.
  * @mapping: the address_space to search
  * @index: The page cache index.
  *
@@ -1845,7 +1845,7 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  *
  * Return: The folio, swap or shadow entry, %NULL if nothing is found.
  */
-static void *mapping_get_entry(struct address_space *mapping, pgoff_t index)
+void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	struct folio *folio;
@@ -1915,7 +1915,7 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 	struct folio *folio;
 
 repeat:
-	folio = mapping_get_entry(mapping, index);
+	folio = filemap_get_entry(mapping, index);
 	if (xa_is_value(folio)) {
 		if (fgp_flags & FGP_ENTRY)
 			return folio;
-- 
2.39.0

