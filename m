From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 63/73] dax: Convert dax_insert_mapping_entry to XArray
Date: Tue,  5 Dec 2017 16:41:49 -0800
Message-ID: <20171206004159.3755-64-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3vSufFtVaBp330DYuQlkXPlX6FSw0W6jIGrytLDCHoE=; b=Q8oNOhmomDaaC/43zUjA0mDA/
        QjD2dfPryjlN9N4ci48jCpIleaa6rdyoVHs1WrMkQLiWVGU+fep7WSWYe4pkOR75sUFk9wr+SJN+8
        Vk1mLHNgcLbRkUl0EcGNmEGrseUC8kXvX2emn8nncnnZV7ZGKDHvR5DSs/KHVxA/yjIvte/inSoLP
        PUQ5ve/XiXRajMG7w3qrPpZwHAmAvrlKZ/SsJ3nPKOC6Y6nN9GnCDKTt+9WqfXFAd3dyxWpR6NPOw
        FrjdFiwam5aCOc1ubICOuZiXNKIUKw9VWPf44KjhG6o9Nx4/W6veJZmLtwLEDXXS9+TgwoV5CsvVs
    
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 619aff70583f..de85ce87d333 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -498,9 +498,9 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 				      void *entry, sector_t sector,
 				      unsigned long flags, bool dirty)
 {
-	struct radix_tree_root *pages = &mapping->pages;
 	void *new_entry;
 	pgoff_t index = vmf->pgoff;
+	XA_STATE(xas, &mapping->pages, index);
 
 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -516,7 +516,7 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 					PAGE_SIZE, 0);
 	}
 
-	xa_lock_irq(&mapping->pages);
+	xas_lock_irq(&xas);
 	new_entry = dax_radix_locked_entry(sector, flags);
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
@@ -528,21 +528,15 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 		 * existing entry is a PMD, we will just leave the PMD in the
 		 * tree and dirty it if necessary.
 		 */
-		struct radix_tree_node *node;
-		void **slot;
-		void *ret;
-
-		ret = __radix_tree_lookup(pages, index, &node, &slot);
-		WARN_ON_ONCE(ret != entry);
-		__radix_tree_replace(pages, node, slot,
-				     new_entry, NULL);
+		void *prev = xas_store(&xas, new_entry);
+		WARN_ON_ONCE(prev != entry);
 		entry = new_entry;
 	}
 
 	if (dirty)
-		radix_tree_tag_set(pages, index, PAGECACHE_TAG_DIRTY);
+		xas_set_tag(&xas, PAGECACHE_TAG_DIRTY);
 
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
 	return entry;
 }
 
-- 
2.15.0

