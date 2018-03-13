From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 38/61] mm: Convert page migration to XArray
Date: Tue, 13 Mar 2018 06:26:16 -0700
Message-ID: <20180313132639.17387-39-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZP49aq269tFFqpyGMczz8ZSYS9wJPmYPFVNznUUKnms=; b=quuMjzddJh3CvK/i+VkdWSe9Z
        UilGsfjJoopdWVpx5Exom/YrOMx1cQ3IHtfgTf7gvjCJKoxZwbHlr9IkEKofXwbTR7tY8g0cdIylS
        ijlN0zy+HOCYwEdLdZEweRqLTtBkKbzfGyyeUAXMlpisY/CUiDLUxb5SIVZcxI4raErPLPN1IIgEt
        5gk816xuJ2r0Fd8a/F6+NoHQz6mVzNUn22C/I21krWdXQ2sE8YtrmioGHmB88tkqYOmKjp51u++cg
        Z53gKv859GBW6s1GepWXtYfO6a8j6EEx2g+AFrf5atk91S/8HcVkFeS0QCtn2gGgGMGXdznBeRUlH
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/migrate.c | 41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 740b71857898..9a15d27768a0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -322,7 +322,7 @@ void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
 	page = migration_entry_to_page(entry);
 
 	/*
-	 * Once radix-tree replacement of page migration started, page_count
+	 * Once page cache replacement of page migration started, page_count
 	 * *must* be zero. And, we don't want to call wait_on_page_locked()
 	 * against a page without get_page().
 	 * So, we use get_page_unless_zero(), here. Even failed, page fault
@@ -437,10 +437,10 @@ int migrate_page_move_mapping(struct address_space *mapping,
 		struct buffer_head *head, enum migrate_mode mode,
 		int extra_count)
 {
+	XA_STATE(xas, &mapping->i_pages, page_index(page));
 	struct zone *oldzone, *newzone;
 	int dirty;
 	int expected_count = 1 + extra_count;
-	void **pslot;
 
 	/*
 	 * Device public or private pages have an extra refcount as they are
@@ -466,21 +466,16 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	oldzone = page_zone(page);
 	newzone = page_zone(newpage);
 
-	xa_lock_irq(&mapping->i_pages);
-
-	pslot = radix_tree_lookup_slot(&mapping->i_pages,
- 					page_index(page));
+	xas_lock_irq(&xas);
 
 	expected_count += 1 + page_has_private(page);
-	if (page_count(page) != expected_count ||
-		radix_tree_deref_slot_protected(pslot,
-					&mapping->i_pages.xa_lock) != page) {
-		xa_unlock_irq(&mapping->i_pages);
+	if (page_count(page) != expected_count || xas_load(&xas) != page) {
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
 	if (!page_ref_freeze(page, expected_count)) {
-		xa_unlock_irq(&mapping->i_pages);
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
@@ -494,7 +489,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	if (mode == MIGRATE_ASYNC && head &&
 			!buffer_migrate_lock_buffers(head, mode)) {
 		page_ref_unfreeze(page, expected_count);
-		xa_unlock_irq(&mapping->i_pages);
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
@@ -522,7 +517,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 		SetPageDirty(newpage);
 	}
 
-	radix_tree_replace_slot(&mapping->i_pages, pslot, newpage);
+	xas_store(&xas, newpage);
 
 	/*
 	 * Drop cache reference from old page by unfreezing
@@ -531,7 +526,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	 */
 	page_ref_unfreeze(page, expected_count - 1);
 
-	xa_unlock(&mapping->i_pages);
+	xas_unlock(&xas);
 	/* Leave irq disabled to prevent preemption while updating stats */
 
 	/*
@@ -571,22 +566,18 @@ EXPORT_SYMBOL(migrate_page_move_mapping);
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 				   struct page *newpage, struct page *page)
 {
+	XA_STATE(xas, &mapping->i_pages, page_index(page));
 	int expected_count;
-	void **pslot;
-
-	xa_lock_irq(&mapping->i_pages);
-
-	pslot = radix_tree_lookup_slot(&mapping->i_pages, page_index(page));
 
+	xas_lock_irq(&xas);
 	expected_count = 2 + page_has_private(page);
-	if (page_count(page) != expected_count ||
-		radix_tree_deref_slot_protected(pslot, &mapping->i_pages.xa_lock) != page) {
-		xa_unlock_irq(&mapping->i_pages);
+	if (page_count(page) != expected_count || xas_load(&xas) != page) {
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
 	if (!page_ref_freeze(page, expected_count)) {
-		xa_unlock_irq(&mapping->i_pages);
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
@@ -595,11 +586,11 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 
 	get_page(newpage);
 
-	radix_tree_replace_slot(&mapping->i_pages, pslot, newpage);
+	xas_store(&xas, newpage);
 
 	page_ref_unfreeze(page, expected_count - 1);
 
-	xa_unlock_irq(&mapping->i_pages);
+	xas_unlock_irq(&xas);
 
 	return MIGRATEPAGE_SUCCESS;
 }
-- 
2.16.1

