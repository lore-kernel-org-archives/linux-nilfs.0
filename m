From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 68/74] dax: Convert dax_lock_page to XArray
Date: Sat, 16 Jun 2018 19:00:46 -0700
Message-ID: <20180617020052.4759-69-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XHBdRC4wAAIIJPvc5v66ahFvCLbNhUPOOBir9x+fl4o=; b=MAFweyd8mRdC9AxifD41RhNDS
        eXPxz2MI78svrs1avUCBnzCxPjFzueL/9MXYznghlhEqD29UNRldYx/V78PD1OtWIBg1R286NiDeB
        8+wb2+5CBb6PAUqIckRog3g5JOL7/Q9Fk9sTq+IDQzyyMzkKAwemejKc1RL2uA3cAEEzQ89JZUzSn
        QAK50+nMaAfegvsRLk/j3xAeu2ZiUaVLsCJjzEHO+fq1rbhz7gCItne8lbiQ3VcyGpom7JGyail6D
        emv/0sbjzPYJXbEm5Mafgb9v9eESav32xE48uIR7Lk9RMmAFWL5NQ2eVrmPELYL/oOPLKjKm50RC/
    
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 fs/dax.c | 96 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 50 insertions(+), 46 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 08595ffde566..54a01380527a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -99,6 +99,22 @@ static void *dax_make_locked(unsigned long pfn, unsigned long flags)
 			DAX_LOCKED);
 }
 
+static unsigned long dax_is_pmd_entry(void *entry)
+{
+	return xa_to_value(entry) & DAX_PMD;
+}
+
+static void *dax_make_entry(pfn_t pfn, unsigned long flags)
+{
+	return xa_mk_value(flags | (pfn_t_to_pfn(pfn) << DAX_SHIFT));
+}
+
+static void *dax_make_page_entry(struct page *page, void *entry)
+{
+	pfn_t pfn = page_to_pfn_t(page);
+	return dax_make_entry(pfn, dax_is_pmd_entry(entry));
+}
+
 static bool dax_is_locked(void *entry)
 {
 	return xa_to_value(entry) & DAX_LOCKED;
@@ -111,11 +127,6 @@ static unsigned int dax_entry_order(void *entry)
 	return 0;
 }
 
-static int dax_is_pmd_entry(void *entry)
-{
-	return xa_to_value(entry) & DAX_PMD;
-}
-
 static int dax_is_pte_entry(void *entry)
 {
 	return !(xa_to_value(entry) & DAX_PMD);
@@ -466,78 +477,71 @@ static struct page *dax_busy_page(void *entry)
 
 struct page *dax_lock_page(unsigned long pfn)
 {
-	pgoff_t index;
-	struct inode *inode;
-	wait_queue_head_t *wq;
-	void *entry = NULL, **slot;
+	struct page *page = pfn_to_page(pfn);
+	XA_STATE(xas, NULL, 0);
+	void *entry;
 	struct address_space *mapping;
-	struct wait_exceptional_entry_queue ewait;
-	struct page *ret = NULL, *page = pfn_to_page(pfn);
 
-	rcu_read_lock();
 	for (;;) {
+		rcu_read_lock();
 		mapping = READ_ONCE(page->mapping);
 
-		if (!mapping || !IS_DAX(mapping->host))
+		if (!mapping || !IS_DAX(mapping->host)) {
+			page = NULL;
 			break;
+		}
 
 		/*
 		 * In the device-dax case there's no need to lock, a
 		 * struct dev_pagemap pin is sufficient to keep the
 		 * inode alive.
 		 */
-		inode = mapping->host;
-		if (S_ISCHR(inode->i_mode)) {
-			ret = page;
+		if (S_ISCHR(mapping->host->i_mode))
 			break;
-		}
 
-		xa_lock_irq(&mapping->i_pages);
+		xas.xa = &mapping->i_pages;
+		xas_lock_irq(&xas);
+		rcu_read_unlock();
 		if (mapping != page->mapping) {
 			xa_unlock_irq(&mapping->i_pages);
 			continue;
 		}
-		index = page->index;
-
-		init_wait(&ewait.wait);
-		ewait.wait.func = wake_exceptional_entry_func;
-
-		entry = __radix_tree_lookup(&mapping->i_pages, index, NULL,
-				&slot);
-		if (!entry || WARN_ON_ONCE(!xa_is_value(entry))) {
-			xa_unlock_irq(&mapping->i_pages);
-			break;
-		} else if (!slot_locked(mapping, slot)) {
-			lock_slot(mapping, slot);
-			ret = page;
-			xa_unlock_irq(&mapping->i_pages);
-			break;
+		xas_set(&xas, page->index);
+		entry = xas_load(&xas);
+		if (dax_is_locked(entry)) {
+			entry = get_unlocked_entry(&xas);
+			/* Did the page move while we slept? */
+			if (dax_to_pfn(entry) != pfn) {
+				xas_unlock_irq(&xas);
+				continue;
+			}
 		}
-
-		wq = dax_entry_waitqueue(&mapping->i_pages, index, entry,
-				&ewait.key);
-		prepare_to_wait_exclusive(wq, &ewait.wait,
-				TASK_UNINTERRUPTIBLE);
-		xa_unlock_irq(&mapping->i_pages);
-		rcu_read_unlock();
-		schedule();
-		finish_wait(wq, &ewait.wait);
-		rcu_read_lock();
+		dax_lock_entry(&xas, entry);
+		xas_unlock_irq(&xas);
+		goto out;
 	}
 	rcu_read_unlock();
 
+out:
 	return page;
 }
 
 void dax_unlock_page(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
-	struct inode *inode = mapping->host;
+	XA_STATE(xas, &mapping->i_pages, page->index);
+	void *entry;
 
-	if (S_ISCHR(inode->i_mode))
+	if (S_ISCHR(mapping->host->i_mode))
 		return;
 
-	dax_unlock_mapping_entry(mapping, page->index);
+	xas_lock_irq(&xas);
+	entry = xas_load(&xas);
+	BUG_ON(!dax_is_locked(entry));
+	entry = dax_make_page_entry(page, entry);
+	xas_store(&xas, entry);
+	dax_wake_entry(&xas, entry, false);
+	xas_unlock_irq(&xas);
 }
 
 /*
-- 
2.17.1

