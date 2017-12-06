From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v4 22/73] page cache: Convert hole search to XArray
Date: Tue,  5 Dec 2017 16:41:08 -0800
Message-ID: <20171206004159.3755-23-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=89RMrD6LqDknnqx4+Wpxud9pcim+PfEuonK6gVJ+YIA=; b=jrLK8fAhC8KULqr5aMlt5wQ3H
        eEWmgGiHqz9D5326fBy7i6+etVPW/O+XdXswMIk+qIv0k1jDY4XZLYwaNv+dZAQwYA9zKFE2g4aQY
        zzfnS3/jYGz5yJOdcrVwVu6I4LhC2J7p4duMliK4sTb2oQ9xdMQuc1leye4OnomtJn+7ZBIKxAifX
        RXXxVku6KXyhoRbB0HHL7/oxywvd7HSvlGB/wujkAXUQqdDKvhkD2YaU5loyu+hB80hkEbrwrfPVO
        Gka7+IZcbuWLhRLtuz2Cd7itfL6EUxhP8v4wpX5TRZ7yzvXQ2h66YUIcnZp2jlYccMTszMdPHRRJd
    
In-Reply-To: <20171206004159.3755-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

The page cache offers the ability to search for a miss in the previous or
next N locations.  Rather than teach the XArray about the page cache's
definition of a miss, use xas_prev() and xas_next() to search the page
array.  This should be more efficient as it does not have to start the
lookup from the top for each index.

Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/nfs/blocklayout/blocklayout.c |   2 +-
 include/linux/pagemap.h          |   4 +-
 mm/filemap.c                     | 110 ++++++++++++++++++---------------------
 mm/readahead.c                   |   4 +-
 4 files changed, 55 insertions(+), 65 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 995d707537da..7bd643538cff 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -826,7 +826,7 @@ static u64 pnfs_num_cont_bytes(struct inode *inode, pgoff_t idx)
 	end = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
 	if (end != inode->i_mapping->nrpages) {
 		rcu_read_lock();
-		end = page_cache_next_hole(mapping, idx + 1, ULONG_MAX);
+		end = page_cache_next_gap(mapping, idx + 1, ULONG_MAX);
 		rcu_read_unlock();
 	}
 
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 80a6149152d4..0db127c3ccac 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -241,9 +241,9 @@ static inline gfp_t readahead_gfp_mask(struct address_space *x)
 
 typedef int filler_t(void *, struct page *);
 
-pgoff_t page_cache_next_hole(struct address_space *mapping,
+pgoff_t page_cache_next_gap(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan);
-pgoff_t page_cache_prev_hole(struct address_space *mapping,
+pgoff_t page_cache_prev_gap(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan);
 
 #define FGP_ACCESSED		0x00000001
diff --git a/mm/filemap.c b/mm/filemap.c
index 1d012dd3629e..650624f7b79d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1326,86 +1326,76 @@ int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
 }
 
 /**
- * page_cache_next_hole - find the next hole (not-present entry)
- * @mapping: mapping
- * @index: index
- * @max_scan: maximum range to search
- *
- * Search the set [index, min(index+max_scan-1, MAX_INDEX)] for the
- * lowest indexed hole.
- *
- * Returns: the index of the hole if found, otherwise returns an index
- * outside of the set specified (in which case 'return - index >=
- * max_scan' will be true). In rare cases of index wrap-around, 0 will
- * be returned.
- *
- * page_cache_next_hole may be called under rcu_read_lock. However,
- * like radix_tree_gang_lookup, this will not atomically search a
- * snapshot of the tree at a single point in time. For example, if a
- * hole is created at index 5, then subsequently a hole is created at
- * index 10, page_cache_next_hole covering both indexes may return 10
- * if called under rcu_read_lock.
+ * page_cache_next_gap() - Find the next gap in the page cache.
+ * @mapping: Mapping.
+ * @index: Index.
+ * @max_scan: Maximum range to search.
+ *
+ * Search the range [index, min(index + max_scan - 1, ULONG_MAX)] for the
+ * gap with the lowest index.
+ *
+ * This function may be called under the rcu_read_lock.  However, this will
+ * not atomically search a snapshot of the cache at a single point in time.
+ * For example, if a gap is created at index 5, then subsequently a gap is
+ * created at index 10, page_cache_next_gap covering both indices may
+ * return 10 if called under the rcu_read_lock.
+ *
+ * Return: The index of the gap if found, otherwise an index outside the
+ * range specified (in which case 'return - index >= max_scan' will be true).
+ * In the rare case of index wrap-around, 0 will be returned.
  */
-pgoff_t page_cache_next_hole(struct address_space *mapping,
+pgoff_t page_cache_next_gap(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan)
 {
-	unsigned long i;
+	XA_STATE(xas, &mapping->pages, index);
 
-	for (i = 0; i < max_scan; i++) {
-		struct page *page;
-
-		page = radix_tree_lookup(&mapping->pages, index);
-		if (!page || xa_is_value(page))
+	while (max_scan--) {
+		void *entry = xas_next(&xas);
+		if (!entry || xa_is_value(entry))
 			break;
-		index++;
-		if (index == 0)
+		if (xas.xa_index == 0)
 			break;
 	}
 
-	return index;
+	return xas.xa_index;
 }
-EXPORT_SYMBOL(page_cache_next_hole);
+EXPORT_SYMBOL(page_cache_next_gap);
 
 /**
- * page_cache_prev_hole - find the prev hole (not-present entry)
- * @mapping: mapping
- * @index: index
- * @max_scan: maximum range to search
- *
- * Search backwards in the range [max(index-max_scan+1, 0), index] for
- * the first hole.
- *
- * Returns: the index of the hole if found, otherwise returns an index
- * outside of the set specified (in which case 'index - return >=
- * max_scan' will be true). In rare cases of wrap-around, ULONG_MAX
- * will be returned.
- *
- * page_cache_prev_hole may be called under rcu_read_lock. However,
- * like radix_tree_gang_lookup, this will not atomically search a
- * snapshot of the tree at a single point in time. For example, if a
- * hole is created at index 10, then subsequently a hole is created at
- * index 5, page_cache_prev_hole covering both indexes may return 5 if
- * called under rcu_read_lock.
+ * page_cache_prev_gap() - Find the next gap in the page cache.
+ * @mapping: Mapping.
+ * @index: Index.
+ * @max_scan: Maximum range to search.
+ *
+ * Search the range [max(index - max_scan + 1, 0), index] for the
+ * gap with the highest index.
+ *
+ * This function may be called under the rcu_read_lock.  However, this will
+ * not atomically search a snapshot of the cache at a single point in time.
+ * For example, if a gap is created at index 10, then subsequently a gap is
+ * created at index 5, page_cache_prev_gap() covering both indices may
+ * return 5 if called under the rcu_read_lock.
+ *
+ * Return: The index of the gap if found, otherwise an index outside the
+ * range specified (in which case 'index - return >= max_scan' will be true).
+ * In the rare case of wrap-around, ULONG_MAX will be returned.
  */
-pgoff_t page_cache_prev_hole(struct address_space *mapping,
+pgoff_t page_cache_prev_gap(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan)
 {
-	unsigned long i;
-
-	for (i = 0; i < max_scan; i++) {
-		struct page *page;
+	XA_STATE(xas, &mapping->pages, index);
 
-		page = radix_tree_lookup(&mapping->pages, index);
-		if (!page || xa_is_value(page))
+	while (max_scan--) {
+		void *entry = xas_prev(&xas);
+		if (!entry || xa_is_value(entry))
 			break;
-		index--;
-		if (index == ULONG_MAX)
+		if (xas.xa_index == ULONG_MAX)
 			break;
 	}
 
-	return index;
+	return xas.xa_index;
 }
-EXPORT_SYMBOL(page_cache_prev_hole);
+EXPORT_SYMBOL(page_cache_prev_gap);
 
 /**
  * find_get_entry - find and get a page cache entry
diff --git a/mm/readahead.c b/mm/readahead.c
index 4851f002605f..f64b31b3a84a 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -329,7 +329,7 @@ static pgoff_t count_history_pages(struct address_space *mapping,
 	pgoff_t head;
 
 	rcu_read_lock();
-	head = page_cache_prev_hole(mapping, offset - 1, max);
+	head = page_cache_prev_gap(mapping, offset - 1, max);
 	rcu_read_unlock();
 
 	return offset - 1 - head;
@@ -417,7 +417,7 @@ ondemand_readahead(struct address_space *mapping,
 		pgoff_t start;
 
 		rcu_read_lock();
-		start = page_cache_next_hole(mapping, offset + 1, max_pages);
+		start = page_cache_next_gap(mapping, offset + 1, max_pages);
 		rcu_read_unlock();
 
 		if (!start || start - offset > max_pages)
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
