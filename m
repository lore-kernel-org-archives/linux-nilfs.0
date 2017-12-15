From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 60/78] dax: More XArray conversion
Date: Fri, 15 Dec 2017 14:04:32 -0800
Message-ID: <20171215220450.7899-61-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
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
 bh=Kq5DOaD8l/tl3fYpzCywVxco/HVIeqlyEFy7Ddl/UtI=; b=Dr8MmQAfC0KwxI6hAbpefg/ijq
 UiN3dexUcr0i4DC0KV131QJylyPTz28sXuBTVpXlSwxIRxP8aMk6xw8/U5P4hXTKc8mVhWTgV/Z0p
 x43xd9goMZZolmLgO19VGz7b2pA3XWUqcgEHF/N1EliuXeKi/Ni0bAZnjpXxL6Dlq+2s=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=Kq5DOaD8l/tl3fYpzCywVxco/HVIeqlyEFy7Ddl/UtI=; b=AFz7sjikwRcuvl3flpuuIsWQlv
 OYuuCneha+7GjSjBWo6dB3u0ZBrRhCrnxYMlBC2oRW6vnL4zCwd34fg5sXrsRx3ckUTLtrcFlS2GP
 4pqGxwdDaLka2+LcETRv+cpLmROYjudHswm2DW3d2YM+7d8heACoFAVmeL4qDMynvwAk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=Kq5DOaD8l/tl3fYpzCywVxco/HVIeqlyEFy7Ddl/UtI=; b=UDtxsYvWbkjdPN27VmGwLYVNH
 5/VPnSJH3cT/v9H0Afu6yNUzfsBYnL905VDhF8Pe3KjLy2ogLv+u0MzTsnaP4yttPSxMn+bJBcWEW
 HTZRSKWNVi0mmwqkBT/+KCL9ajeB0J/nIf6vf2AJq3P6l1vaUPrQsd5zfnqVtp8c4y7coCTufIbre
 zQ7y3mfkJCkMGEW3CJN10ugak+xQzywCfRWvVO4XOFAJZ3q9bOjD39mOg/4fi0vlrKwP0dJarm/qE
 U/OP5G+GjyTNRaVOYzz9ttEs4vdwI8v2S8FKGKONJqg+5Xao+X04pH90ZRs1UNvjIWlp6tzreqdQ1
 oGGrVLAMw==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This time, we want to convert get_unlocked_mapping_entry() to use the
XArray.  That has a ripple effect, causing us to change the waitqueues
to hash on the address of the xarray rather than the address of the
mapping (functionally equivalent), and create a lot of on-the-stack
xa_state which are only used as a container for passing the xarray and
the index down to deeper function calls.

Also rename dax_wake_mapping_entry_waiter() to dax_wake_entry().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 72 +++++++++++++++++++++++++++++-----------------------------------
 1 file changed, 33 insertions(+), 39 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 46a4d83b1b46..2629ffa70575 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -120,7 +120,7 @@ static int dax_is_empty_entry(void *entry)
  * DAX radix tree locking
  */
 struct exceptional_entry_key {
-	struct address_space *mapping;
+	struct xarray *xa;
 	pgoff_t entry_start;
 };
 
@@ -129,9 +129,10 @@ struct wait_exceptional_entry_queue {
 	struct exceptional_entry_key key;
 };
 
-static wait_queue_head_t *dax_entry_waitqueue(struct address_space *mapping,
-		pgoff_t index, void *entry, struct exceptional_entry_key *key)
+static wait_queue_head_t *dax_entry_waitqueue(struct xa_state *xas,
+		void *entry, struct exceptional_entry_key *key)
 {
+	unsigned long index = xas->xa_index;
 	unsigned long hash;
 
 	/*
@@ -142,10 +143,10 @@ static wait_queue_head_t *dax_entry_waitqueue(struct address_space *mapping,
 	if (dax_is_pmd_entry(entry))
 		index &= ~PG_PMD_COLOUR;
 
-	key->mapping = mapping;
+	key->xa = xas->xa;
 	key->entry_start = index;
 
-	hash = hash_long((unsigned long)mapping ^ index, DAX_WAIT_TABLE_BITS);
+	hash = hash_long((unsigned long)xas->xa ^ index, DAX_WAIT_TABLE_BITS);
 	return wait_table + hash;
 }
 
@@ -156,7 +157,7 @@ static int wake_exceptional_entry_func(wait_queue_entry_t *wait, unsigned int mo
 	struct wait_exceptional_entry_queue *ewait =
 		container_of(wait, struct wait_exceptional_entry_queue, wait);
 
-	if (key->mapping != ewait->key.mapping ||
+	if (key->xa != ewait->key.xa ||
 	    key->entry_start != ewait->key.entry_start)
 		return 0;
 	return autoremove_wake_function(wait, mode, sync, NULL);
@@ -167,13 +168,12 @@ static int wake_exceptional_entry_func(wait_queue_entry_t *wait, unsigned int mo
  * The important information it's conveying is whether the entry at
  * this index used to be a PMD entry.
  */
-static void dax_wake_mapping_entry_waiter(struct address_space *mapping,
-		pgoff_t index, void *entry, bool wake_all)
+static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
 {
 	struct exceptional_entry_key key;
 	wait_queue_head_t *wq;
 
-	wq = dax_entry_waitqueue(mapping, index, entry, &key);
+	wq = dax_entry_waitqueue(xas, entry, &key);
 
 	/*
 	 * Checking for locked entry and prepare_to_wait_exclusive() happens
@@ -205,10 +205,9 @@ static inline void *lock_slot(struct xa_state *xas)
  *
  * Must be called with xa_lock held.
  */
-static void *get_unlocked_mapping_entry(struct address_space *mapping,
-					pgoff_t index, void ***slotp)
+static void *get_unlocked_mapping_entry(struct xa_state *xas)
 {
-	void *entry, **slot;
+	void *entry;
 	struct wait_exceptional_entry_queue ewait;
 	wait_queue_head_t *wq;
 
@@ -216,22 +215,19 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
 	ewait.wait.func = wake_exceptional_entry_func;
 
 	for (;;) {
-		entry = __radix_tree_lookup(&mapping->pages, index, NULL,
-					  &slot);
-		if (!entry ||
-		    WARN_ON_ONCE(!xa_is_value(entry)) || !dax_locked(entry)) {
-			if (slotp)
-				*slotp = slot;
+		entry = xas_load(xas);
+		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
+		    !dax_locked(entry))
 			return entry;
-		}
 
-		wq = dax_entry_waitqueue(mapping, index, entry, &ewait.key);
+		wq = dax_entry_waitqueue(xas, entry, &ewait.key);
 		prepare_to_wait_exclusive(wq, &ewait.wait,
 					  TASK_UNINTERRUPTIBLE);
-		xa_unlock_irq(&mapping->pages);
+		xas_pause(xas);
+		xas_unlock_irq(xas);
 		schedule();
 		finish_wait(wq, &ewait.wait);
-		xa_lock_irq(&mapping->pages);
+		xas_lock_irq(xas);
 	}
 }
 
@@ -251,7 +247,7 @@ static void dax_unlock_mapping_entry(struct address_space *mapping,
 	xas_store(&xas, entry);
 	/* Safe to not call xas_pause here -- we don't touch the array after */
 	xas_unlock_irq(&xas);
-	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
+	dax_wake_entry(&xas, entry, false);
 }
 
 static void put_locked_mapping_entry(struct address_space *mapping,
@@ -264,14 +260,13 @@ static void put_locked_mapping_entry(struct address_space *mapping,
  * Called when we are done with radix tree entry we looked up via
  * get_unlocked_mapping_entry() and which we didn't lock in the end.
  */
-static void put_unlocked_mapping_entry(struct address_space *mapping,
-				       pgoff_t index, void *entry)
+static void put_unlocked_mapping_entry(struct xa_state *xas, void *entry)
 {
 	if (!entry)
 		return;
 
 	/* We have to wake up next waiter for the radix tree entry lock */
-	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
+	dax_wake_entry(xas, entry, false);
 }
 
 /*
@@ -308,7 +303,7 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 
 restart:
 	xa_lock_irq(&mapping->pages);
-	entry = get_unlocked_mapping_entry(mapping, index, &slot);
+	entry = get_unlocked_mapping_entry(&xas);
 
 	if (WARN_ON_ONCE(entry && !xa_is_value(entry))) {
 		entry = ERR_PTR(-EIO);
@@ -318,8 +313,7 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 	if (entry) {
 		if (size_flag & DAX_PMD) {
 			if (dax_is_pte_entry(entry)) {
-				put_unlocked_mapping_entry(mapping, index,
-						entry);
+				put_unlocked_mapping_entry(&xas, entry);
 				entry = ERR_PTR(-EEXIST);
 				goto out_unlock;
 			}
@@ -382,8 +376,7 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 		if (pmd_downgrade) {
 			radix_tree_delete(&mapping->pages, index);
 			mapping->nrexceptional--;
-			dax_wake_mapping_entry_waiter(mapping, index, entry,
-					true);
+			dax_wake_entry(&xas, entry, true);
 		}
 
 		entry = dax_radix_locked_entry(0, size_flag | DAX_EMPTY);
@@ -417,12 +410,13 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 					  pgoff_t index, bool trunc)
 {
+	XA_STATE(xas, &mapping->pages, index);
 	int ret = 0;
 	void *entry;
 	struct radix_tree_root *pages = &mapping->pages;
 
 	xa_lock_irq(&mapping->pages);
-	entry = get_unlocked_mapping_entry(mapping, index, NULL);
+	entry = get_unlocked_mapping_entry(&xas);
 	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
 		goto out;
 	if (!trunc &&
@@ -433,7 +427,7 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 	mapping->nrexceptional--;
 	ret = 1;
 out:
-	put_unlocked_mapping_entry(mapping, index, entry);
+	put_unlocked_mapping_entry(&xas, entry);
 	xa_unlock_irq(&mapping->pages);
 	return ret;
 }
@@ -641,7 +635,7 @@ static int dax_writeback_one(struct block_device *bdev,
 {
 	struct radix_tree_root *pages = &mapping->pages;
 	XA_STATE(xas, pages, index);
-	void *entry2, **slot, *kaddr;
+	void *entry2, *kaddr;
 	long ret = 0, id;
 	sector_t sector;
 	pgoff_t pgoff;
@@ -656,7 +650,7 @@ static int dax_writeback_one(struct block_device *bdev,
 		return -EIO;
 
 	xa_lock_irq(&mapping->pages);
-	entry2 = get_unlocked_mapping_entry(mapping, index, &slot);
+	entry2 = get_unlocked_mapping_entry(&xas);
 	/* Entry got punched out / reallocated? */
 	if (!entry2 || WARN_ON_ONCE(!xa_is_value(entry2)))
 		goto put_unlocked;
@@ -734,7 +728,7 @@ static int dax_writeback_one(struct block_device *bdev,
 	return ret;
 
  put_unlocked:
-	put_unlocked_mapping_entry(mapping, index, entry2);
+	put_unlocked_mapping_entry(&xas, entry2);
 	xa_unlock_irq(&mapping->pages);
 	return ret;
 }
@@ -1504,16 +1498,16 @@ static int dax_insert_pfn_mkwrite(struct vm_fault *vmf,
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	pgoff_t index = vmf->pgoff;
 	XA_STATE(xas, &mapping->pages, index);
-	void *entry, **slot;
+	void *entry;
 	int vmf_ret, error;
 
 	xa_lock_irq(&mapping->pages);
-	entry = get_unlocked_mapping_entry(mapping, index, &slot);
+	entry = get_unlocked_mapping_entry(&xas);
 	/* Did we race with someone splitting entry or so? */
 	if (!entry ||
 	    (pe_size == PE_SIZE_PTE && !dax_is_pte_entry(entry)) ||
 	    (pe_size == PE_SIZE_PMD && !dax_is_pmd_entry(entry))) {
-		put_unlocked_mapping_entry(mapping, index, entry);
+		put_unlocked_mapping_entry(&xas, entry);
 		xa_unlock_irq(&mapping->pages);
 		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
 						      VM_FAULT_NOPAGE);
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
