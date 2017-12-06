From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 25/73] page cache: Convert page deletion to XArray
Date: Tue,  5 Dec 2017 16:41:11 -0800
Message-ID: <20171206004159.3755-26-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+425r3a0OoEPolD++8zZvINFfR04/G0jmhPNXmh+2SU=; b=gkobQ6hYmx7Bko056+0KbJR4V
        try0Y4qAEdmesjC2gogDAwLEWpUWM03xgwQajUhDrNy5gzjBvMpoQ+nAuV/KL2rWCC7Zy227lGX1m
        SyW3fa6OY0XlnWYoAp9o5zLFexIyeaAwlkApms4rbSkpTF8EE718ay3aQi1zsU6lhcCyiOSSYRctE
        sr5cq0Tlh5/sDlC3tTTT1wu0twWAHEyLVocBYvTzMH0JxehuXBFeUYOdWwzi5lBY5VJFyTf/uVxn/
        +gnXNNpB8KtzGT9XkcVkiU+VjFVyQJxK85VSLcpreBDtIYRzQ0L47bbAIqEvjqGKHmYSiefpHf+w8
    
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

The code is slightly shorter and simpler.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 2439747a0a17..6e2808fd3c06 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -115,27 +115,25 @@
 static void page_cache_tree_delete(struct address_space *mapping,
 				   struct page *page, void *shadow)
 {
-	int i, nr;
+	XA_STATE(xas, &mapping->pages, page->index);
+	unsigned int i, nr;
 
-	/* hugetlb pages are represented by one entry in the radix tree */
+	xas_set_update(&xas, workingset_lookup_update(mapping));
+
+	/* hugetlb pages are represented by a single entry in the xarray */
 	nr = PageHuge(page) ? 1 : hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	VM_BUG_ON_PAGE(nr != 1 && shadow, page);
 
-	for (i = 0; i < nr; i++) {
-		struct radix_tree_node *node;
-		void **slot;
-
-		__radix_tree_lookup(&mapping->pages, page->index + i,
-				    &node, &slot);
-
-		VM_BUG_ON_PAGE(!node && nr != 1, page);
-
-		radix_tree_clear_tags(&mapping->pages, node, slot);
-		__radix_tree_replace(&mapping->pages, node, slot, shadow,
-				workingset_lookup_update(mapping));
+	i = nr;
+repeat:
+	xas_store(&xas, shadow);
+	xas_init_tags(&xas);
+	if (--i) {
+		xas_next(&xas);
+		goto repeat;
 	}
 
 	page->mapping = NULL;
-- 
2.15.0

