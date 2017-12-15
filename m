From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 59/78] dax: Convert lock_slot to XArray
Date: Fri, 15 Dec 2017 14:04:31 -0800
Message-ID: <20171215220450.7899-60-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
	Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=eTGl5HIv1w09VLEBmBMyy19O432tsQS20nmvI5iOwFI=; b=tYR1r0SsgSgTNX2IZiCjpop4P
	ut3xS7EEJC6+HGKmOeR6xQesAm8awCxV3VBWTedcjcn5M8DbekAppnYkqO65cnyCbsp8pC1z8mBfb
	zMDK+Si/t/wJQhH4PiLh6mVY2x1X/UExooyyntn/P2KhmS0g+GCLL6cv5k+dVUK2Y21EWZVRqUgkP
	ueC1sTdEk79yssOjjEmaOHx3RcTbFiPuktIncnlh7T2JcCEdfvWeNtRXFHBuwnhrIWgQNsH3Z2OWW
	lHjUnMDpw/4gK+tMeRRVBYHqJs9H4DUAi8vQ4xkn1N5sv67r+QypPhuw/xGF6lX4DUDOZEDox81hb
	FzSEqZlUA==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index dd4674ce48f5..46a4d83b1b46 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -188,12 +188,11 @@ static void dax_wake_mapping_entry_waiter(struct address_space *mapping,
 /*
  * Mark the given slot as locked.  Must be called with xa_lock held.
  */
-static inline void *lock_slot(struct address_space *mapping, void **slot)
+static inline void *lock_slot(struct xa_state *xas)
 {
-	unsigned long v = xa_to_value(
-		radix_tree_deref_slot_protected(slot, &mapping->pages.xa_lock));
+	unsigned long v = xa_to_value(xas_load(xas));
 	void *entry = xa_mk_value(v | DAX_ENTRY_LOCK);
-	radix_tree_replace_slot(&mapping->pages, slot, entry);
+	xas_store(xas, entry);
 	return entry;
 }
 
@@ -244,7 +243,7 @@ static void dax_unlock_mapping_entry(struct address_space *mapping,
 
 	xas_lock_irq(&xas);
 	entry = xas_load(&xas);
-	if (WARN_ON_ONCE(!entry || !xa_is_value(entry) || !dax_locked(entry))) {
+	if (WARN_ON_ONCE(!xa_is_value(entry) || !dax_locked(entry))) {
 		xas_unlock_irq(&xas);
 		return;
 	}
@@ -303,6 +302,7 @@ static void put_unlocked_mapping_entry(struct address_space *mapping,
 static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 		unsigned long size_flag)
 {
+	XA_STATE(xas, &mapping->pages, index);
 	bool pmd_downgrade = false; /* splitting 2MiB entry into 4k entries? */
 	void *entry, **slot;
 
@@ -341,7 +341,7 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 			 * Make sure 'entry' remains valid while we drop
 			 * xa_lock.
 			 */
-			entry = lock_slot(mapping, slot);
+			entry = lock_slot(&xas);
 		}
 
 		xa_unlock_irq(&mapping->pages);
@@ -408,7 +408,7 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 		xa_unlock_irq(&mapping->pages);
 		return entry;
 	}
-	entry = lock_slot(mapping, slot);
+	entry = lock_slot(&xas);
  out_unlock:
 	xa_unlock_irq(&mapping->pages);
 	return entry;
@@ -640,6 +640,7 @@ static int dax_writeback_one(struct block_device *bdev,
 		pgoff_t index, void *entry)
 {
 	struct radix_tree_root *pages = &mapping->pages;
+	XA_STATE(xas, pages, index);
 	void *entry2, **slot, *kaddr;
 	long ret = 0, id;
 	sector_t sector;
@@ -676,7 +677,7 @@ static int dax_writeback_one(struct block_device *bdev,
 	if (!radix_tree_tag_get(pages, index, PAGECACHE_TAG_TOWRITE))
 		goto put_unlocked;
 	/* Lock the entry to serialize with page faults */
-	entry = lock_slot(mapping, slot);
+	entry = lock_slot(&xas);
 	/*
 	 * We can clear the tag now but we have to be careful so that concurrent
 	 * dax_writeback_one() calls for the same index cannot finish before we
@@ -1501,8 +1502,9 @@ static int dax_insert_pfn_mkwrite(struct vm_fault *vmf,
 				  pfn_t pfn)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
-	void *entry, **slot;
 	pgoff_t index = vmf->pgoff;
+	XA_STATE(xas, &mapping->pages, index);
+	void *entry, **slot;
 	int vmf_ret, error;
 
 	xa_lock_irq(&mapping->pages);
@@ -1518,7 +1520,7 @@ static int dax_insert_pfn_mkwrite(struct vm_fault *vmf,
 		return VM_FAULT_NOPAGE;
 	}
 	radix_tree_tag_set(&mapping->pages, index, PAGECACHE_TAG_DIRTY);
-	entry = lock_slot(mapping, slot);
+	entry = lock_slot(&xas);
 	xa_unlock_irq(&mapping->pages);
 	switch (pe_size) {
 	case PE_SIZE_PTE:
-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
