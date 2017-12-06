From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v4 64/73] dax: Convert grab_mapping_entry to XArray
Date: Tue,  5 Dec 2017 16:41:50 -0800
Message-ID: <20171206004159.3755-65-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l1Sh9L2Pkxc3VDBGxP4tA737fbcjmn0xjeXBPfjiFfo=; b=LJc5f0zTkcJJNyhWBLTzqA0js
        LYqKT+y4AE+4EKiXyricuqP6kbtv1rS5/omlByu+mxkoo5Dn9PXujgcD8ZWktwE0XSm23zfxKnqnn
        Mlh+s11cqrIeXuxbc8olm1+xS4CcdaM4VfKniFWbNTOPjzadLpFyAQodjiMJKO1Xw33YhGNcwLYO5
        9jsOjx1piYRHhrxeiTSQQbXNSYbvke6zpqtS9RFu9lWgDsybSLIjLK2WO8nML3r+FxmF4leW58NUK
        le8o0gfGRSZC/hTNww7VjRcL/Sqzru8D4l+5vG6Lq3NZ8OFY2DC45cOV+Us+iXoBJbKMfoO8iIz28
    
In-Reply-To: <20171206004159.3755-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/dax.c | 98 +++++++++++++++++-----------------------------------------------
 1 file changed, 26 insertions(+), 72 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index de85ce87d333..c663d82e8ba3 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -44,6 +44,7 @@
 
 /* The 'colour' (ie low bits) within a PMD of a page offset.  */
 #define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
+#define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
 
 static wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
 
@@ -89,10 +90,10 @@ static void *dax_radix_locked_entry(sector_t sector, unsigned long flags)
 			DAX_ENTRY_LOCK);
 }
 
-static unsigned int dax_radix_order(void *entry)
+static unsigned int dax_entry_order(void *entry)
 {
 	if (xa_to_value(entry) & DAX_PMD)
-		return PMD_SHIFT - PAGE_SHIFT;
+		return PMD_ORDER;
 	return 0;
 }
 
@@ -299,10 +300,11 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 {
 	XA_STATE(xas, &mapping->pages, index);
 	bool pmd_downgrade = false; /* splitting 2MiB entry into 4k entries? */
-	void *entry, **slot;
+	void *entry;
 
+	xas_set_order(&xas, index, size_flag ? PMD_ORDER : 0);
 restart:
-	xa_lock_irq(&mapping->pages);
+	xas_lock_irq(&xas);
 	entry = get_unlocked_mapping_entry(&xas);
 
 	if (WARN_ON_ONCE(entry && !xa_is_value(entry))) {
@@ -326,84 +328,36 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 		}
 	}
 
-	/* No entry for given index? Make sure radix tree is big enough. */
-	if (!entry || pmd_downgrade) {
-		int err;
-
-		if (pmd_downgrade) {
-			/*
-			 * Make sure 'entry' remains valid while we drop
-			 * mapping xa_lock.
-			 */
-			entry = lock_slot(&xas);
-		}
-
-		xa_unlock_irq(&mapping->pages);
+	if (pmd_downgrade) {
+		entry = lock_slot(&xas);
 		/*
 		 * Besides huge zero pages the only other thing that gets
 		 * downgraded are empty entries which don't need to be
 		 * unmapped.
 		 */
-		if (pmd_downgrade && dax_is_zero_entry(entry))
+		if (dax_is_zero_entry(entry)) {
+			xas_pause(&xas);
+			xas_unlock_irq(&xas);
 			unmap_mapping_range(mapping,
 				(index << PAGE_SHIFT) & PMD_MASK, PMD_SIZE, 0);
-
-		err = radix_tree_preload(
-				mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM);
-		if (err) {
-			if (pmd_downgrade)
-				put_locked_mapping_entry(mapping, index);
-			return ERR_PTR(err);
+			xas_lock_irq(&xas);
 		}
-		xa_lock_irq(&mapping->pages);
-
-		if (!entry) {
-			/*
-			 * We needed to drop the pages lock while calling
-			 * radix_tree_preload() and we didn't have an entry to
-			 * lock.  See if another thread inserted an entry at
-			 * our index during this time.
-			 */
-			entry = __radix_tree_lookup(&mapping->pages, index,
-					NULL, &slot);
-			if (entry) {
-				radix_tree_preload_end();
-				xa_unlock_irq(&mapping->pages);
-				goto restart;
-			}
-		}
-
-		if (pmd_downgrade) {
-			radix_tree_delete(&mapping->pages, index);
-			mapping->nrexceptional--;
-			dax_wake_entry(&xas, entry, true);
-		}
-
+		xas_store(&xas, NULL);
+		mapping->nrexceptional--;
+		dax_wake_entry(&xas, entry, true);
+	}
+	if (!entry || pmd_downgrade) {
 		entry = dax_radix_locked_entry(0, size_flag | DAX_EMPTY);
-
-		err = __radix_tree_insert(&mapping->pages, index,
-				dax_radix_order(entry), entry);
-		radix_tree_preload_end();
-		if (err) {
-			xa_unlock_irq(&mapping->pages);
-			/*
-			 * Our insertion of a DAX entry failed, most likely
-			 * because we were inserting a PMD entry and it
-			 * collided with a PTE sized entry at a different
-			 * index in the PMD range.  We haven't inserted
-			 * anything into the radix tree and have no waiters to
-			 * wake.
-			 */
-			return ERR_PTR(err);
-		}
-		/* Good, we have inserted empty locked entry into the tree. */
-		mapping->nrexceptional++;
-		xa_unlock_irq(&mapping->pages);
-		return entry;
+		xas_store(&xas, entry);
+		if (!xas_error(&xas))
+			mapping->nrexceptional++;
+	} else {
+		entry = lock_slot(&xas);
 	}
-	entry = lock_slot(&xas);
  out_unlock:
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
+	if (xas_nomem(&xas, GFP_NOIO))
+		goto restart;
 	return entry;
 }
 
@@ -683,7 +637,7 @@ static int dax_writeback_one(struct block_device *bdev,
 	 * worry about partial PMD writebacks.
 	 */
 	sector = dax_radix_sector(entry);
-	size = PAGE_SIZE << dax_radix_order(entry);
+	size = PAGE_SIZE << dax_entry_order(entry);
 
 	id = dax_read_lock();
 	ret = bdev_dax_pgoff(bdev, sector, size, &pgoff);
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
