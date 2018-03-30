From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 19/62] page cache: Add and replace pages
 using the XArray
Date: Thu, 29 Mar 2018 20:42:02 -0700
Message-ID: <20180330034245.10462-20-willy@infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
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
 bh=Yj9Cf8xPQIjGLBb09TpYkb5La7qdtdKAKdAQca2F4B0=; b=IN7rw2ty4R60fuRW8fEqScX4I9
 UmMORveddKK5QNP7MwKYKDM5cWqGjhqAjnEq5juJqAuLG/NeUU0T1p/PIi7fpJVbmjCtByLl1AvRa
 uGjDyTHyVEOzMA4x47fLOCDo07Mva1jCZ34DwcAHpJAGzGGNkMkPpMsbyTRvBheNIDp8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=Yj9Cf8xPQIjGLBb09TpYkb5La7qdtdKAKdAQca2F4B0=; b=UMOi0nAmmUjhP27maHloOi+Lu3
 vY9+Yt2YUrS+TBCTYg6RJS0avrETrqWUN4ivXRmnc+cUTbJgb55JnYFvsqOnpe845kIfU8z4s+OIh
 isMVxh0oije5xQ8muCKkZd/NcA1bGrWtP2/DNNGJ5dQlPtT/pog1KvSAHkG0RjctkyUQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=Yj9Cf8xPQIjGLBb09TpYkb5La7qdtdKAKdAQca2F4B0=; b=qgEIh4Ra7rhwRWkcjOg9SfrNM
 8y9fDqbmbfsbFIULdO0YHoub4vNNZh6omcl3Wv4CqCc+VZWg4sFMH/FYb5ChUyduFSMIKSxnp0cey
 NpHxYHk8v5V5sO4zGl0H4MJ9fRqPEXBw+BZffHWpOaAeeHINqRa5dexi50b31q+DARET2WHTlGzEY
 k8g8cmAyE9oc636W3H4dE46ZSJdI8jZSn8vY7XJq3MkVHudCNigTUglPWClTr+vQJd4TlkYFBBr9w
 6AEYpTBOq4YtDPPwdna2/CqK2RLHqtHJriwwO1KLyS2JsdnGyb9l8AcfP4MBvlwufoFoTkqb2XXpP
 EBwtXlb7Q==;
In-Reply-To: <20180330034245.10462-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Use the XArray APIs to add and replace pages in the page cache.  This
removes two uses of the radix tree preload API and is significantly
shorter code.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/swap.h |   8 ++-
 mm/filemap.c         | 143 ++++++++++++++++++++++-----------------------------
 2 files changed, 67 insertions(+), 84 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1985940af479..a0ebb5deea2d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -300,8 +300,12 @@ void *workingset_eviction(struct address_space *mapping, struct page *page);
 bool workingset_refault(void *shadow);
 void workingset_activation(struct page *page);
 
-/* Do not use directly, use workingset_lookup_update */
-void workingset_update_node(struct radix_tree_node *node);
+/* Only track the nodes of mappings with shadow entries */
+void workingset_update_node(struct xa_node *node);
+#define mapping_set_update(xas, mapping) do {				\
+	if (!dax_mapping(mapping) && !shmem_mapping(mapping))		\
+		xas_set_update(xas, workingset_update_node);		\
+} while (0)
 
 /* Returns workingset_update_node() if the mapping has shadow entries. */
 #define workingset_lookup_update(mapping)				\
diff --git a/mm/filemap.c b/mm/filemap.c
index efe227940784..0e19ea454cba 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -111,35 +111,6 @@
  *   ->tasklist_lock            (memory_failure, collect_procs_ao)
  */
 
-static int page_cache_tree_insert(struct address_space *mapping,
-				  struct page *page, void **shadowp)
-{
-	struct radix_tree_node *node;
-	void **slot;
-	int error;
-
-	error = __radix_tree_create(&mapping->i_pages, page->index, 0,
-				    &node, &slot);
-	if (error)
-		return error;
-	if (*slot) {
-		void *p;
-
-		p = radix_tree_deref_slot_protected(slot,
-						    &mapping->i_pages.xa_lock);
-		if (!xa_is_value(p))
-			return -EEXIST;
-
-		mapping->nrexceptional--;
-		if (shadowp)
-			*shadowp = p;
-	}
-	__radix_tree_replace(&mapping->i_pages, node, slot, page,
-			     workingset_lookup_update(mapping));
-	mapping->nrpages++;
-	return 0;
-}
-
 static void page_cache_tree_delete(struct address_space *mapping,
 				   struct page *page, void *shadow)
 {
@@ -775,51 +746,44 @@ EXPORT_SYMBOL(file_write_and_wait_range);
  * locked.  This function does not add the new page to the LRU, the
  * caller must do that.
  *
- * The remove + add is atomic.  The only way this function can fail is
- * memory allocation failure.
+ * The remove + add is atomic.  This function cannot fail.
  */
 int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
 {
-	int error;
+	struct address_space *mapping = old->mapping;
+	void (*freepage)(struct page *) = mapping->a_ops->freepage;
+	pgoff_t offset = old->index;
+	XA_STATE(xas, &mapping->i_pages, offset);
+	unsigned long flags;
 
 	VM_BUG_ON_PAGE(!PageLocked(old), old);
 	VM_BUG_ON_PAGE(!PageLocked(new), new);
 	VM_BUG_ON_PAGE(new->mapping, new);
 
-	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
-	if (!error) {
-		struct address_space *mapping = old->mapping;
-		void (*freepage)(struct page *);
-		unsigned long flags;
-
-		pgoff_t offset = old->index;
-		freepage = mapping->a_ops->freepage;
-
-		get_page(new);
-		new->mapping = mapping;
-		new->index = offset;
+	get_page(new);
+	new->mapping = mapping;
+	new->index = offset;
 
-		xa_lock_irqsave(&mapping->i_pages, flags);
-		__delete_from_page_cache(old, NULL);
-		error = page_cache_tree_insert(mapping, new, NULL);
-		BUG_ON(error);
+	xas_lock_irqsave(&xas, flags);
+	xas_store(&xas, new);
 
-		/*
-		 * hugetlb pages do not participate in page cache accounting.
-		 */
-		if (!PageHuge(new))
-			__inc_node_page_state(new, NR_FILE_PAGES);
-		if (PageSwapBacked(new))
-			__inc_node_page_state(new, NR_SHMEM);
-		xa_unlock_irqrestore(&mapping->i_pages, flags);
-		mem_cgroup_migrate(old, new);
-		radix_tree_preload_end();
-		if (freepage)
-			freepage(old);
-		put_page(old);
-	}
+	old->mapping = NULL;
+	/* hugetlb pages do not participate in page cache accounting. */
+	if (!PageHuge(old))
+		__dec_node_page_state(new, NR_FILE_PAGES);
+	if (!PageHuge(new))
+		__inc_node_page_state(new, NR_FILE_PAGES);
+	if (PageSwapBacked(old))
+		__dec_node_page_state(new, NR_SHMEM);
+	if (PageSwapBacked(new))
+		__inc_node_page_state(new, NR_SHMEM);
+	xas_unlock_irqrestore(&xas, flags);
+	mem_cgroup_migrate(old, new);
+	if (freepage)
+		freepage(old);
+	put_page(old);
 
-	return error;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
@@ -828,12 +792,15 @@ static int __add_to_page_cache_locked(struct page *page,
 				      pgoff_t offset, gfp_t gfp_mask,
 				      void **shadowp)
 {
+	XA_STATE(xas, &mapping->i_pages, offset);
 	int huge = PageHuge(page);
 	struct mem_cgroup *memcg;
 	int error;
+	void *old;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageSwapBacked(page), page);
+	mapping_set_update(&xas, mapping);
 
 	if (!huge) {
 		error = mem_cgroup_try_charge(page, current->mm,
@@ -842,39 +809,51 @@ static int __add_to_page_cache_locked(struct page *page,
 			return error;
 	}
 
-	error = radix_tree_maybe_preload(gfp_mask & ~__GFP_HIGHMEM);
-	if (error) {
-		if (!huge)
-			mem_cgroup_cancel_charge(page, memcg, false);
-		return error;
-	}
-
 	get_page(page);
 	page->mapping = mapping;
 	page->index = offset;
 
-	xa_lock_irq(&mapping->i_pages);
-	error = page_cache_tree_insert(mapping, page, shadowp);
-	radix_tree_preload_end();
-	if (unlikely(error))
-		goto err_insert;
+	do {
+		xas_lock_irq(&xas);
+		old = xas_create(&xas);
+		if (xas_error(&xas))
+			goto unlock;
+		if (xa_is_value(old)) {
+			mapping->nrexceptional--;
+			if (shadowp)
+				*shadowp = old;
+		} else if (old) {
+			xas_set_err(&xas, -EEXIST);
+			goto unlock;
+		}
+
+		xas_store(&xas, page);
+		mapping->nrpages++;
+
+		/*
+		 * hugetlb pages do not participate in
+		 * page cache accounting.
+		 */
+		if (!huge)
+			__inc_node_page_state(page, NR_FILE_PAGES);
+unlock:
+		xas_unlock_irq(&xas);
+	} while (xas_nomem(&xas, gfp_mask & ~__GFP_HIGHMEM));
+
+	if (xas_error(&xas))
+		goto error;
 
-	/* hugetlb pages do not participate in page cache accounting. */
-	if (!huge)
-		__inc_node_page_state(page, NR_FILE_PAGES);
-	xa_unlock_irq(&mapping->i_pages);
 	if (!huge)
 		mem_cgroup_commit_charge(page, memcg, false, false);
 	trace_mm_filemap_add_to_page_cache(page);
 	return 0;
-err_insert:
+error:
 	page->mapping = NULL;
 	/* Leave page->index set: truncation relies upon it */
-	xa_unlock_irq(&mapping->i_pages);
 	if (!huge)
 		mem_cgroup_cancel_charge(page, memcg, false);
 	put_page(page);
-	return error;
+	return xas_error(&xas);
 }
 
 /**
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
