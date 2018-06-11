From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 40/72] mm: Convert page migration to XArray
Date: Mon, 11 Jun 2018 07:06:07 -0700
Message-ID: <20180611140639.17215-41-willy@infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=tRkUpxAn62xizVV0HSxWSbxkMPT1z8gWqMUFuTsxcsc=; b=D0m/I1sOWmV/88kijrlRK2awz1
 oAXry1BGtXW83i2hM9wEcm63fJTvfTVAEaLNw4u8Azra6QZLC6ufOeyuiP6C+LOCm/kKBxbMloG4o
 kwmleqRJHZ2gH/42OXgOZWenwQrcmWukV7YosGm7frasEpY4Us8pqfqyNHNickD2zS84=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=tRkUpxAn62xizVV0HSxWSbxkMPT1z8gWqMUFuTsxcsc=; b=czs5FshwnTfxp05YUHJN6ebSuK
 ZBuZkOi9M2fY2JbJYdPPY+6XcaZ0isY+6jCBbi0LdG4yVoC9gUNtWPISPjyj+7lNlBMeIyvEQaryK
 Azjzuzl/7NA/L4W2PETT6O6OUMmUyuBiRtZPBPUbbxBy1wxNAntMJCa+YQPi1qfgEHxw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=tRkUpxAn62xizVV0HSxWSbxkMPT1z8gWqMUFuTsxcsc=; b=slhmQnhKTfd7N3lynlfciaSsL
 eqe2DFon/BnpvAJqaWiliZDDsKMWrgv+TWZNbCDwmu2T7GvTWPxH3EVeNuailEhKAlATYSwO0EsOA
 icPDKHd5nYiy2Ba1g65++2970YuUw46dwfnU/pN6RqYAGUXJheRcSLGP6rJTC/6MsSN7ZgLqXwhok
 aFDJzQSaGcCjYA/RBiWp66QZDI9Oywf/nqNCV5C7reLJLwBBVR1vnc+UvficMEg7g1gsU3ha0WeQ0
 djI0VQzIIOMK0H4SJ/dgAghXGBusF+56TSIx+rQ+HYYWgS4II4MCUi8YzagpOkOxbml0EtQZ7Owmo
 4KGbfoYVA==;
In-Reply-To: <20180611140639.17215-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/migrate.c | 48 ++++++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 8c0af0f7cab1..80dc5b8c9738 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -323,7 +323,7 @@ void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
 	page = migration_entry_to_page(entry);
 
 	/*
-	 * Once radix-tree replacement of page migration started, page_count
+	 * Once page cache replacement of page migration started, page_count
 	 * *must* be zero. And, we don't want to call wait_on_page_locked()
 	 * against a page without get_page().
 	 * So, we use get_page_unless_zero(), here. Even failed, page fault
@@ -438,10 +438,10 @@ int migrate_page_move_mapping(struct address_space *mapping,
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
@@ -467,21 +467,16 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	oldzone = page_zone(page);
 	newzone = page_zone(newpage);
 
-	xa_lock_irq(&mapping->i_pages);
-
-	pslot = radix_tree_lookup_slot(&mapping->i_pages,
- 					page_index(page));
+	xas_lock_irq(&xas);
 
 	expected_count += hpage_nr_pages(page) + page_has_private(page);
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
 
@@ -495,7 +490,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	if (mode == MIGRATE_ASYNC && head &&
 			!buffer_migrate_lock_buffers(head, mode)) {
 		page_ref_unfreeze(page, expected_count);
-		xa_unlock_irq(&mapping->i_pages);
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
@@ -523,16 +518,13 @@ int migrate_page_move_mapping(struct address_space *mapping,
 		SetPageDirty(newpage);
 	}
 
-	radix_tree_replace_slot(&mapping->i_pages, pslot, newpage);
+	xas_store(&xas, newpage);
 	if (PageTransHuge(page)) {
 		int i;
-		int index = page_index(page);
 
 		for (i = 1; i < HPAGE_PMD_NR; i++) {
-			pslot = radix_tree_lookup_slot(&mapping->i_pages,
-						       index + i);
-			radix_tree_replace_slot(&mapping->i_pages, pslot,
-						newpage + i);
+			xas_next(&xas);
+			xas_store(&xas, newpage + i);
 		}
 	}
 
@@ -543,7 +535,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	 */
 	page_ref_unfreeze(page, expected_count - hpage_nr_pages(page));
 
-	xa_unlock(&mapping->i_pages);
+	xas_unlock(&xas);
 	/* Leave irq disabled to prevent preemption while updating stats */
 
 	/*
@@ -583,22 +575,18 @@ EXPORT_SYMBOL(migrate_page_move_mapping);
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
 
@@ -607,11 +595,11 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 
 	get_page(newpage);
 
-	radix_tree_replace_slot(&mapping->i_pages, pslot, newpage);
+	xas_store(&xas, newpage);
 
 	page_ref_unfreeze(page, expected_count - 1);
 
-	xa_unlock_irq(&mapping->i_pages);
+	xas_unlock_irq(&xas);
 
 	return MIGRATEPAGE_SUCCESS;
 }
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
