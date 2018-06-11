From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 63/72] dax: Convert dax_insert_pfn_mkwrite to
 XArray
Date: Mon, 11 Jun 2018 07:06:30 -0700
Message-ID: <20180611140639.17215-64-willy@infradead.org>
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
 bh=2u6+qgyveiDkqLJM8FJpbQoqNhFUWbl8SL25NGa49r4=; b=T4zzygS8GJyLuHk38GZL0kAcG6
 wfuGIS3OWuCxoburkx5uIU8OwvfSny7F+9xmYFVduDnZvjov00Hy5GLPA1EAh1yqgGUpWVzKQT7p/
 VPGy/zCiVUYp3O1ECeGxK1uux4LmrTPUNd07vQMMPO1JU2PjAyQDpAkt2IFEvBnJ5gok=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=2u6+qgyveiDkqLJM8FJpbQoqNhFUWbl8SL25NGa49r4=; b=JrqqKluNIpCwtO32xaBo0vijgy
 etKxqVhc5qdG6iLckGZpnmPjrknX//qYlTLEaXxvudIWbXXHiCTN9zrmEJwxFQt4FyjrY+kDqqYcZ
 uzjJ1zxOJyQgTJNoexsnaWe1Hun6+Evyg52y27Tqwoa8HxETvN/wzDKvS9lvaUZNjf/o=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=2u6+qgyveiDkqLJM8FJpbQoqNhFUWbl8SL25NGa49r4=; b=mZpnL+aRY2gJ/21PALfF2FW1X
 2e11UTeU4GSb/Yl2U93jG5tF/7LeFk/A99SFeONNGtImef7jCcP8kh0CnW5NrrvrrXs9JK0Dydcp6
 gsENHgsQMBuBSb03fIIwL/JYCSa93YZRFt8CpzPhsyDNY2+QqHf3dxp6K7Ll5SHzCbK/2Y4RmwOWp
 X5AqVsXKwMrP5cAcYrxiv2yd45A2CfxQOY71h2pC3qYd59M9XV1qhxn5TgyyXn9g1GC5AqsnGbnfA
 611okxWktqdfGTuJIA4T7Xlf5AxBDQM2MAeKSYlnltMj5LOYrbyOsM4Cud8v9cPCE/FB/BRWUP2kj
 LC5RaeBzw==;
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

Add some XArray-based helper functions to replace the radix tree based
metaphors currently in use.  The biggest change is that converted code
doesn't see its own lock bit; get_unlocked_entry() always returns an
entry with the lock bit clear, and locking the entry now returns void.
So we don't have to mess around loading the current entry and clearing
the lock bit; we can just store the entry that we were using.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 145 +++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 113 insertions(+), 32 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7d0712c45da5..1c9b736147d3 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -38,6 +38,17 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/fs_dax.h>
 
+static inline unsigned int pe_order(enum page_entry_size pe_size)
+{
+	if (pe_size == PE_SIZE_PTE)
+		return PAGE_SHIFT - PAGE_SHIFT;
+	if (pe_size == PE_SIZE_PMD)
+		return PMD_SHIFT - PAGE_SHIFT;
+	if (pe_size == PE_SIZE_PUD)
+		return PUD_SHIFT - PAGE_SHIFT;
+	return ~0;
+}
+
 /* We choose 4096 entries - same as per-zone page wait tables */
 #define DAX_WAIT_TABLE_BITS 12
 #define DAX_WAIT_TABLE_ENTRIES (1 << DAX_WAIT_TABLE_BITS)
@@ -46,6 +57,9 @@
 #define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
 #define PG_PMD_NR	(PMD_SIZE >> PAGE_SHIFT)
 
+/* The order of a PMD entry */
+#define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
+
 static wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
 
 static int __init init_dax_wait_table(void)
@@ -85,10 +99,15 @@ static void *dax_make_locked(unsigned long pfn, unsigned long flags)
 			DAX_LOCKED);
 }
 
+static bool dax_is_locked(void *entry)
+{
+	return xa_to_value(entry) & DAX_LOCKED;
+}
+
 static unsigned int dax_entry_order(void *entry)
 {
 	if (xa_to_value(entry) & DAX_PMD)
-		return PMD_SHIFT - PAGE_SHIFT;
+		return PMD_ORDER;
 	return 0;
 }
 
@@ -181,6 +200,77 @@ static void dax_wake_mapping_entry_waiter(struct xarray *xa,
 		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
 }
 
+static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
+{
+	return dax_wake_mapping_entry_waiter(xas->xa, xas->xa_index, entry,
+								wake_all);
+}
+
+/*
+ * Look up entry in page cache, wait for it to become unlocked if it
+ * is a DAX entry and return it.  The caller must subsequently call
+ * put_unlocked_entry() if it did not lock the entry or put_locked_entry()
+ * if it did.
+ *
+ * Must be called with the i_pages lock held.
+ */
+static void *get_unlocked_entry(struct xa_state *xas)
+{
+	void *entry;
+	struct wait_exceptional_entry_queue ewait;
+	wait_queue_head_t *wq;
+
+	init_wait(&ewait.wait);
+	ewait.wait.func = wake_exceptional_entry_func;
+
+	for (;;) {
+		entry = xas_load(xas);
+		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
+				!dax_is_locked(entry))
+			return entry;
+
+		wq = dax_entry_waitqueue(xas->xa, xas->xa_index, entry,
+				&ewait.key);
+		prepare_to_wait_exclusive(wq, &ewait.wait,
+					  TASK_UNINTERRUPTIBLE);
+		xas_unlock_irq(xas);
+		xas_reset(xas);
+		schedule();
+		finish_wait(wq, &ewait.wait);
+		xas_lock_irq(xas);
+	}
+}
+
+static void put_unlocked_entry(struct xa_state *xas, void *entry)
+{
+	/* If we were the only waiter woken, wake the next one */
+	if (entry)
+		dax_wake_entry(xas, entry, false);
+}
+
+/*
+ * We used the xa_state to get the entry, but then we locked the entry and
+ * dropped the xa_lock, so we know the xa_state is stale and must be reset
+ * before use.
+ */
+static void put_locked_entry(struct xa_state *xas, void *entry)
+{
+	void *old;
+
+	xas_reset(xas);
+	xas_lock_irq(xas);
+	old = xas_store(xas, entry);
+	xas_unlock_irq(xas);
+	BUG_ON(!dax_is_locked(old));
+	dax_wake_entry(xas, entry, false);
+}
+
+static void dax_lock_entry(struct xa_state *xas, void *entry)
+{
+	unsigned long v = xa_to_value(entry);
+	xas_store(xas, xa_mk_value(v | DAX_LOCKED));
+}
+
 /*
  * Check whether the given slot is locked.  Must be called with the i_pages
  * lock held.
@@ -1629,50 +1719,46 @@ EXPORT_SYMBOL_GPL(dax_iomap_fault);
 /*
  * dax_insert_pfn_mkwrite - insert PTE or PMD entry into page tables
  * @vmf: The description of the fault
- * @pe_size: Size of entry to be inserted
  * @pfn: PFN to insert
+ * @order: Order of entry to insert.
  *
  * This function inserts a writeable PTE or PMD entry into the page tables
  * for an mmaped DAX file.  It also marks the page cache entry as dirty.
  */
-static vm_fault_t dax_insert_pfn_mkwrite(struct vm_fault *vmf,
-				  enum page_entry_size pe_size,
-				  pfn_t pfn)
+static vm_fault_t
+dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
-	void *entry, **slot;
-	pgoff_t index = vmf->pgoff;
+	XA_STATE_ORDER(xas, &mapping->i_pages, vmf->pgoff, order);
+	void *entry;
 	vm_fault_t ret;
 
-	xa_lock_irq(&mapping->i_pages);
-	entry = get_unlocked_mapping_entry(mapping, index, &slot);
+	xas_lock_irq(&xas);
+	entry = get_unlocked_entry(&xas);
 	/* Did we race with someone splitting entry or so? */
 	if (!entry ||
-	    (pe_size == PE_SIZE_PTE && !dax_is_pte_entry(entry)) ||
-	    (pe_size == PE_SIZE_PMD && !dax_is_pmd_entry(entry))) {
-		put_unlocked_mapping_entry(mapping, index, entry);
-		xa_unlock_irq(&mapping->i_pages);
+	    (order == 0 && !dax_is_pte_entry(entry)) ||
+	    (order == PMD_ORDER && (xa_is_internal(entry) ||
+				    !dax_is_pmd_entry(entry)))) {
+		put_unlocked_entry(&xas, entry);
+		xas_unlock_irq(&xas);
 		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
 						      VM_FAULT_NOPAGE);
 		return VM_FAULT_NOPAGE;
 	}
-	radix_tree_tag_set(&mapping->i_pages, index, PAGECACHE_TAG_DIRTY);
-	entry = lock_slot(mapping, slot);
-	xa_unlock_irq(&mapping->i_pages);
-	switch (pe_size) {
-	case PE_SIZE_PTE:
+	xas_set_tag(&xas, PAGECACHE_TAG_DIRTY);
+	dax_lock_entry(&xas, entry);
+	xas_unlock_irq(&xas);
+	if (order == 0)
 		ret = vmf_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
-		break;
 #ifdef CONFIG_FS_DAX_PMD
-	case PE_SIZE_PMD:
+	else if (order == PMD_ORDER)
 		ret = vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
 			pfn, true);
-		break;
 #endif
-	default:
+	else
 		ret = VM_FAULT_FALLBACK;
-	}
-	put_locked_mapping_entry(mapping, index);
+	put_locked_entry(&xas, entry);
 	trace_dax_insert_pfn_mkwrite(mapping->host, vmf, ret);
 	return ret;
 }
@@ -1692,17 +1778,12 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 {
 	int err;
 	loff_t start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
-	size_t len = 0;
+	unsigned int order = pe_order(pe_size);
+	size_t len = PAGE_SIZE << order;
 
-	if (pe_size == PE_SIZE_PTE)
-		len = PAGE_SIZE;
-	else if (pe_size == PE_SIZE_PMD)
-		len = PMD_SIZE;
-	else
-		WARN_ON_ONCE(1);
 	err = vfs_fsync_range(vmf->vma->vm_file, start, start + len - 1, 1);
 	if (err)
 		return VM_FAULT_SIGBUS;
-	return dax_insert_pfn_mkwrite(vmf, pe_size, pfn);
+	return dax_insert_pfn_mkwrite(vmf, pfn, order);
 }
 EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
