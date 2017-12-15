From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 58/78] dax: Convert dax_unlock_mapping_entry to XArray
Date: Fri, 15 Dec 2017 14:04:30 -0800
Message-ID: <20171215220450.7899-59-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
	Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=v+g14DtC3skiBvmutg3kcRRKKavypN1RZyoNY/sA3j0=; b=NgsIc1XVllx6QvWv+VXg/P2kU
	hmLr+fbBhEanfhNtXFjMnK1n6kqtGXD5SkZBQqzqmZ/WyOwh4nUZPlDfAnGbGxx16Wc7sP+VjKHLz
	66lmhMIY4MA7psWGwXn7z/11y3HlaGkfgA66kA8qhsxePe5/LMtQI+k4iERmbNePRH4P/z0V+4eBD
	xxVuKbLxWIL7nf5dY/eYK8gY2fUu8Pcxq17vOtOHe2Ib0V0cXRlQWPU07BWpqpuzuqCQtkrBq9JbH
	XCR33wBBseFikvsu1LWQOe4MiXnnTjSZto2JtnlXupBxNedxSaSw0sbc8UGcxAbcHFSvR3r3qMXzM
	dabln7Gtg==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Replace slot_locked() with dax_locked() and inline unlock_slot() into
its only caller.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 48 ++++++++++++++++--------------------------------
 1 file changed, 16 insertions(+), 32 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 92693859efb5..dd4674ce48f5 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -73,6 +73,11 @@ fs_initcall(init_dax_wait_table);
 #define DAX_ZERO_PAGE	(1UL << 2)
 #define DAX_EMPTY	(1UL << 3)
 
+static bool dax_locked(void *entry)
+{
+	return xa_to_value(entry) & DAX_ENTRY_LOCK;
+}
+
 static unsigned long dax_radix_sector(void *entry)
 {
 	return xa_to_value(entry) >> DAX_SHIFT;
@@ -180,16 +185,6 @@ static void dax_wake_mapping_entry_waiter(struct address_space *mapping,
 		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
 }
 
-/*
- * Check whether the given slot is locked.  Must be called with xa_lock held.
- */
-static inline int slot_locked(struct address_space *mapping, void **slot)
-{
-	unsigned long entry = xa_to_value(
-		radix_tree_deref_slot_protected(slot, &mapping->pages.xa_lock));
-	return entry & DAX_ENTRY_LOCK;
-}
-
 /*
  * Mark the given slot as locked.  Must be called with xa_lock held.
  */
@@ -202,18 +197,6 @@ static inline void *lock_slot(struct address_space *mapping, void **slot)
 	return entry;
 }
 
-/*
- * Mark the given slot as unlocked.  Must be called with xa_lock held.
- */
-static inline void *unlock_slot(struct address_space *mapping, void **slot)
-{
-	unsigned long v = xa_to_value(
-		radix_tree_deref_slot_protected(slot, &mapping->pages.xa_lock));
-	void *entry = xa_mk_value(v & ~DAX_ENTRY_LOCK);
-	radix_tree_replace_slot(&mapping->pages, slot, entry);
-	return entry;
-}
-
 /*
  * Lookup entry in radix tree, wait for it to become unlocked if it is
  * a DAX entry and return it. The caller must call
@@ -237,8 +220,7 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
 		entry = __radix_tree_lookup(&mapping->pages, index, NULL,
 					  &slot);
 		if (!entry ||
-		    WARN_ON_ONCE(!xa_is_value(entry)) ||
-		    !slot_locked(mapping, slot)) {
+		    WARN_ON_ONCE(!xa_is_value(entry)) || !dax_locked(entry)) {
 			if (slotp)
 				*slotp = slot;
 			return entry;
@@ -257,17 +239,19 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
 static void dax_unlock_mapping_entry(struct address_space *mapping,
 				     pgoff_t index)
 {
-	void *entry, **slot;
+	XA_STATE(xas, &mapping->pages, index);
+	void *entry;
 
-	xa_lock_irq(&mapping->pages);
-	entry = __radix_tree_lookup(&mapping->pages, index, NULL, &slot);
-	if (WARN_ON_ONCE(!entry || !xa_is_value(entry) ||
-			 !slot_locked(mapping, slot))) {
-		xa_unlock_irq(&mapping->pages);
+	xas_lock_irq(&xas);
+	entry = xas_load(&xas);
+	if (WARN_ON_ONCE(!entry || !xa_is_value(entry) || !dax_locked(entry))) {
+		xas_unlock_irq(&xas);
 		return;
 	}
-	unlock_slot(mapping, slot);
-	xa_unlock_irq(&mapping->pages);
+	entry = xa_mk_value(xa_to_value(entry) & ~DAX_ENTRY_LOCK);
+	xas_store(&xas, entry);
+	/* Safe to not call xas_pause here -- we don't touch the array after */
+	xas_unlock_irq(&xas);
 	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
 }
 
-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
