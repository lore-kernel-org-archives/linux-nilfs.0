From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 39/61] mm: Convert huge_memory to XArray
Date: Tue, 13 Mar 2018 06:26:17 -0700
Message-ID: <20180313132639.17387-40-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WFrOnpWlMxyHK+TcocscUhQSNXN36mC6U7YpeofUF8o=; b=bT9kc+eroyMNTOmE7+Vbf8NoX
        Sp7m/ZDGuJJT/A0zDr+Nn4Rqm9DDcEHVL5adtu+Q02LvwPibG+18FaCIRyKdsREeu2lkc9iDOHa/U
        KAy5mS5X//KP+HUean+Leln16B+TCNtIVCSrbHjEIzxtQ3mqOX6YB7yf0nY1fRprhTYdwTKj841A9
        ZmIZQBhhtoxRyx65e9Bn6Ds98oaOzfBbVf3fQ3ebrk0+8ZjQQ164jisvXJa/2ufPzNZEPyAjuYNmL
        XIkWPdqfQKAdp+oKEYTWlKBG6EIBDS3GwpPMO6o69gzOfR2hp8rut6ljluOaAyX+mm6k89zO8OMrr
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Quite a straightforward conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/huge_memory.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 89737c0e0d34..354b7f768d0f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2442,13 +2442,13 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	ClearPageCompound(head);
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
-		/* Additional pin to radix tree of swap cache */
+		/* Additional pin to swap cache */
 		if (PageSwapCache(head))
 			page_ref_add(head, 2);
 		else
 			page_ref_inc(head);
 	} else {
-		/* Additional pin to radix tree */
+		/* Additional pin to page cache */
 		page_ref_add(head, 2);
 		xa_unlock(&head->mapping->i_pages);
 	}
@@ -2560,7 +2560,7 @@ bool can_split_huge_page(struct page *page, int *pextra_pins)
 {
 	int extra_pins;
 
-	/* Additional pins from radix tree */
+	/* Additional pins from page cache */
 	if (PageAnon(page))
 		extra_pins = PageSwapCache(page) ? HPAGE_PMD_NR : 0;
 	else
@@ -2656,17 +2656,14 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	spin_lock_irqsave(zone_lru_lock(page_zone(head)), flags);
 
 	if (mapping) {
-		void **pslot;
+		XA_STATE(xas, &mapping->i_pages, page_index(head));
 
-		xa_lock(&mapping->i_pages);
-		pslot = radix_tree_lookup_slot(&mapping->i_pages,
-				page_index(head));
 		/*
-		 * Check if the head page is present in radix tree.
+		 * Check if the head page is present in page cache.
 		 * We assume all tail are present too, if head is there.
 		 */
-		if (radix_tree_deref_slot_protected(pslot,
-					&mapping->i_pages.xa_lock) != head)
+		xa_lock(&mapping->i_pages);
+		if (xas_load(&xas) != head)
 			goto fail;
 	}
 
-- 
2.16.1

