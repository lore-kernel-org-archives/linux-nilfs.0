From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v4 41/73] shmem: Convert replace to XArray
Date: Tue,  5 Dec 2017 16:41:27 -0800
Message-ID: <20171206004159.3755-42-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/V17poIwP1VS7qgDZTl5tuP3V56CrMgQYcinI53RlMo=; b=fWNF7BboGYlHoljjsvrhmXEI9
        TfMile61sXpRLQpvEK328FV1ukuLTcC+/kojXheJO8UJeuZJE/grG7gkWpgg7kahT2RmTBi9rIPNl
        xH95f/YyfKl3f2jgBm8SUNf0M9T8hs3O2XCJElOlcdhGjVgTrObsWuWbPC9Pkg9AKm2X7wfcLuQ4P
        Mk3ce1gCt2d5JODEeY9TK6+BB58yvkdEByfujRLG2F+JHx68ht7/YkU3nGMQOyOS7HVpFaJpOs8KZ
        Bc+7qo+23EsJM4d3Z0BDWXBkYcyuUkArevvLlzgIfJmIcqc3rPt+BRHesj+1M/k/jmcaXPk/a4cfI
    
In-Reply-To: <20171206004159.3755-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

shmem_radix_tree_replace() is renamed to shmem_xa_replace() and
converted to use the XArray API.

Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 mm/shmem.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index c5731bb954a1..fad6c9e7402e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -321,24 +321,20 @@ void shmem_uncharge(struct inode *inode, long pages)
 }
 
 /*
- * Replace item expected in radix tree by a new item, while holding tree lock.
+ * Replace item expected in xarray by a new item, while holding xa_lock.
  */
-static int shmem_radix_tree_replace(struct address_space *mapping,
+static int shmem_xa_replace(struct address_space *mapping,
 			pgoff_t index, void *expected, void *replacement)
 {
-	struct radix_tree_node *node;
-	void **pslot;
+	XA_STATE(xas, &mapping->pages, index);
 	void *item;
 
 	VM_BUG_ON(!expected);
 	VM_BUG_ON(!replacement);
-	item = __radix_tree_lookup(&mapping->pages, index, &node, &pslot);
-	if (!item)
-		return -ENOENT;
+	item = xas_load(&xas);
 	if (item != expected)
 		return -ENOENT;
-	__radix_tree_replace(&mapping->pages, node, pslot,
-			     replacement, NULL);
+	xas_store(&xas, replacement);
 	return 0;
 }
 
@@ -605,8 +601,7 @@ static int shmem_add_to_page_cache(struct page *page,
 	} else if (!expected) {
 		error = radix_tree_insert(&mapping->pages, index, page);
 	} else {
-		error = shmem_radix_tree_replace(mapping, index, expected,
-								 page);
+		error = shmem_xa_replace(mapping, index, expected, page);
 	}
 
 	if (!error) {
@@ -635,7 +630,7 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 	VM_BUG_ON_PAGE(PageCompound(page), page);
 
 	xa_lock_irq(&mapping->pages);
-	error = shmem_radix_tree_replace(mapping, page->index, page, radswap);
+	error = shmem_xa_replace(mapping, page->index, page, radswap);
 	page->mapping = NULL;
 	mapping->nrpages--;
 	__dec_node_page_state(page, NR_FILE_PAGES);
@@ -1550,8 +1545,7 @@ static int shmem_replace_page(struct page **pagep, gfp_t gfp,
 	 * a nice clean interface for us to replace oldpage by newpage there.
 	 */
 	xa_lock_irq(&swap_mapping->pages);
-	error = shmem_radix_tree_replace(swap_mapping, swap_index, oldpage,
-								   newpage);
+	error = shmem_xa_replace(swap_mapping, swap_index, oldpage, newpage);
 	if (!error) {
 		__inc_node_page_state(newpage, NR_FILE_PAGES);
 		__dec_node_page_state(oldpage, NR_FILE_PAGES);
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
