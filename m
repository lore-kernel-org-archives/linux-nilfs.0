From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 37/73] mm: Convert huge_memory to XArray
Date: Tue,  5 Dec 2017 16:41:23 -0800
Message-ID: <20171206004159.3755-38-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=b9srtbS5uUbZOEtl1Do4lMqG4K06awoOVBKjPsn/OGY=; b=S0OWQ67QQwO2CUMWFya3pH4MM
        FEaiGyVjLS11vwgtz8ykWcMrAxz9Fz4+f8rClX40K0D1PaAao2awAOTAQkEIclYPd9+/CRuv7xgfW
        pdwgOZhi7mRtXG7SCmZLyq8htPpRCPcFwbBwohwOXo5aGxGY3OVm3UUc5KYX0KpwCvBDfSEVeut0h
        Hi7ebGW6lPjYbJmmJSzKVf5qvgL3a0PJdp5v3MVkInGDwHrxXlWKq5LJ91VB/AmVMT3HDzWTyentj
        JD9GD8Yx5CKLHJc/4B2CAiq7fJCTOXclXtDjdZLN3wuipa0TTbnl50DuELLBnS85dSdvDWRAB8905
    
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Quite a straightforward conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/huge_memory.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 28909c475ee5..5a41b00d86bd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2379,7 +2379,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
 	if (PageAnon(head) && !PageSwapCache(head)) {
 		page_ref_inc(page_tail);
 	} else {
-		/* Additional pin to radix tree */
+		/* Additional pin to page cache */
 		page_ref_add(page_tail, 2);
 	}
 
@@ -2450,13 +2450,13 @@ static void __split_huge_page(struct page *page, struct list_head *list,
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
 		xa_unlock(&head->mapping->pages);
 	}
@@ -2568,7 +2568,7 @@ bool can_split_huge_page(struct page *page, int *pextra_pins)
 {
 	int extra_pins;
 
-	/* Additional pins from radix tree */
+	/* Additional pins from page cache */
 	if (PageAnon(page))
 		extra_pins = PageSwapCache(page) ? HPAGE_PMD_NR : 0;
 	else
@@ -2664,17 +2664,14 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	spin_lock_irqsave(zone_lru_lock(page_zone(head)), flags);
 
 	if (mapping) {
-		void **pslot;
+		XA_STATE(xas, &mapping->pages, page_index(head));
 
-		xa_lock(&mapping->pages);
-		pslot = radix_tree_lookup_slot(&mapping->pages,
-				page_index(head));
 		/*
-		 * Check if the head page is present in radix tree.
+		 * Check if the head page is present in page cache.
 		 * We assume all tail are present too, if head is there.
 		 */
-		if (radix_tree_deref_slot_protected(pslot,
-					&mapping->pages.xa_lock) != head)
+		xa_lock(&mapping->pages);
+		if (xas_load(&xas) != head)
 			goto fail;
 	}
 
-- 
2.15.0

