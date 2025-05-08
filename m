Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C772D13C3F2
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 05:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746683392; cv=none; b=eg4AdN+/3t6+4FAG92ni5PTbCnAdY9u6SL8R564zFfnw8Oz08kWQMpLR1Qi6v6ld1xfuQBWeLud8YmLqLN4B34W18dNHS8kwnF4X8/RecYCo8xO0dNmnBzy/8bNYX2kj0Ks1UEjKC25u1qpcxn3e9R+8oIK4L7f6SPvl2nt8NWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746683392; c=relaxed/simple;
	bh=5hqB2+OQgbZE0A0LT9WQCqwtWFL2nEQoFVT16JN7cuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfUzslkTL1/fNocKWSWeRpq3K+WDgWpBuaMFU1poMe64+eLqBddJOSFVGUi884mTHYftaca4VrDzPdPAQPIAEGkKDVqcExIurvHW0YfUzUotpeCTF0PBqb8uNbXzcmDCjt2h/q1lCo9IyPeV24bLY3cmsjitWEh1fvAoD3u8odE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kJqzVHCD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kJqzVHCD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ixw+bKvpWgol0fJUQ/qNvhtEbBX7XP7jMh7c2yr7UN4=; b=kJqzVHCDdOAfLI4PkTp10e+6Ex
	NPhCI4v+zcSvFS0PNzCyLmts9dMNYP4OeJM8LhOL4YuqtSp8KzZbvoMqRimmZaB5HqwdsdT9qckUy
	I7ghgGTfSi4F/M5biPOVBaX3RzqZtRiDuI1OQDc/FerkpAsaiGl51EcJQw+0gxLwXE3UTYLNExlcq
	u5ywVQa5bnWxeaPy2ZLc5XwqP5R+i/HZX0ngnpPe6xvsS3JcwgvwrNy+0ZaWjZDclRqrrdjFTs1Km
	uoS5hc/cO+XFjHwrnQkzES6A0CoYJUUC98oVFSIPMbmVfl8/3v7xW/Ky5CDeczazh59e48ORl7VvF
	A2cSSbaw==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCu8i-0000000HOqx-2ufQ;
	Thu, 08 May 2025 05:49:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-nilfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/7] mm: stop passing a writeback_control structure to shmem_writeout
Date: Thu,  8 May 2025 07:47:44 +0200
Message-ID: <20250508054938.15894-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250508054938.15894-1-hch@lst.de>
References: <20250508054938.15894-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

shmem_writeout only needs the swap_iocb cookie and the split folio
list.  Pass those explicitly and remove the now unused list member
from struct writeback_control.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |  2 +-
 drivers/gpu/drm/ttm/ttm_backup.c          |  9 +-------
 include/linux/shmem_fs.h                  |  5 ++++-
 include/linux/writeback.h                 |  3 ---
 mm/shmem.c                                | 25 ++++++++++++++---------
 mm/vmscan.c                               | 12 +++++------
 6 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index 5e784db9f315..dbb7a78ceea7 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -318,7 +318,7 @@ void __shmem_writeback(size_t size, struct address_space *mapping)
 		if (folio_mapped(folio))
 			folio_redirty_for_writepage(&wbc, folio);
 		else
-			error = shmem_writeout(folio, &wbc);
+			error = shmem_writeout(folio, NULL, NULL);
 	}
 }
 
diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ttm_backup.c
index ffaab68bd5dd..6f2e58be4f3e 100644
--- a/drivers/gpu/drm/ttm/ttm_backup.c
+++ b/drivers/gpu/drm/ttm/ttm_backup.c
@@ -112,15 +112,8 @@ ttm_backup_backup_page(struct file *backup, struct page *page,
 
 	if (writeback && !folio_mapped(to_folio) &&
 	    folio_clear_dirty_for_io(to_folio)) {
-		struct writeback_control wbc = {
-			.sync_mode = WB_SYNC_NONE,
-			.nr_to_write = SWAP_CLUSTER_MAX,
-			.range_start = 0,
-			.range_end = LLONG_MAX,
-			.for_reclaim = 1,
-		};
 		folio_set_reclaim(to_folio);
-		ret = shmem_writeout(to_folio, &wbc);
+		ret = shmem_writeout(to_folio, NULL, NULL);
 		if (!folio_test_writeback(to_folio))
 			folio_clear_reclaim(to_folio);
 		/*
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 5f03a39a26f7..6d0f9c599ff7 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -11,6 +11,8 @@
 #include <linux/fs_parser.h>
 #include <linux/userfaultfd_k.h>
 
+struct swap_iocb;
+
 /* inode in-kernel data */
 
 #ifdef CONFIG_TMPFS_QUOTA
@@ -107,7 +109,8 @@ static inline bool shmem_mapping(struct address_space *mapping)
 void shmem_unlock_mapping(struct address_space *mapping);
 struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					pgoff_t index, gfp_t gfp_mask);
-int shmem_writeout(struct folio *folio, struct writeback_control *wbc);
+int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+		struct list_head *folio_list);
 void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 int shmem_unuse(unsigned int type);
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index eda4b62511f7..82f217970092 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -79,9 +79,6 @@ struct writeback_control {
 	 */
 	struct swap_iocb **swap_plug;
 
-	/* Target list for splitting a large folio */
-	struct list_head *list;
-
 	/* internal fields used by the ->writepages implementation: */
 	struct folio_batch fbatch;
 	pgoff_t index;
diff --git a/mm/shmem.c b/mm/shmem.c
index 858cee02ca49..941b9b29e78a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1540,10 +1540,13 @@ int shmem_unuse(unsigned int type)
  * shmem_writeout - Write the folio to swap
  * @folio: The folio to write
  * @wbc: How writeback is to be done
+ * @plug: swap plug
+ * @folio_list: list to put back folios on split
  *
  * Move the folio from the page cache to the swap cache.
  */
-int shmem_writeout(struct folio *folio, struct writeback_control *wbc)
+int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+		struct list_head *folio_list)
 {
 	struct address_space *mapping = folio->mapping;
 	struct inode *inode = mapping->host;
@@ -1553,9 +1556,6 @@ int shmem_writeout(struct folio *folio, struct writeback_control *wbc)
 	int nr_pages;
 	bool split = false;
 
-	if (WARN_ON_ONCE(!wbc->for_reclaim))
-		goto redirty;
-
 	if ((info->flags & VM_LOCKED) || sbinfo->noswap)
 		goto redirty;
 
@@ -1582,7 +1582,7 @@ int shmem_writeout(struct folio *folio, struct writeback_control *wbc)
 try_split:
 		/* Ensure the subpages are still dirty */
 		folio_test_set_dirty(folio);
-		if (split_folio_to_list(folio, wbc->list))
+		if (split_folio_to_list(folio, folio_list))
 			goto redirty;
 		folio_clear_dirty(folio);
 	}
@@ -1635,13 +1635,21 @@ int shmem_writeout(struct folio *folio, struct writeback_control *wbc)
 		list_add(&info->swaplist, &shmem_swaplist);
 
 	if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
+		struct writeback_control wbc = {
+			.sync_mode	= WB_SYNC_NONE,
+			.nr_to_write	= SWAP_CLUSTER_MAX,
+			.range_start	= 0,
+			.range_end	= LLONG_MAX,
+			.for_reclaim	= 1,
+			.swap_plug	= plug,
+		};
 		shmem_recalc_inode(inode, 0, nr_pages);
 		swap_shmem_alloc(folio->swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		mutex_unlock(&shmem_swaplist_mutex);
 		BUG_ON(folio_mapped(folio));
-		return swap_writeout(folio, wbc);
+		return swap_writeout(folio, &wbc);
 	}
 
 	list_del_init(&info->swaplist);
@@ -1650,10 +1658,7 @@ int shmem_writeout(struct folio *folio, struct writeback_control *wbc)
 		goto try_split;
 redirty:
 	folio_mark_dirty(folio);
-	if (wbc->for_reclaim)
-		return AOP_WRITEPAGE_ACTIVATE;	/* Return with folio locked */
-	folio_unlock(folio);
-	return 0;
+	return AOP_WRITEPAGE_ACTIVATE;	/* Return with folio locked */
 }
 EXPORT_SYMBOL_GPL(shmem_writeout);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 42302d2b8739..fea78f01d04e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -669,15 +669,13 @@ static pageout_t writeout(struct folio *folio, struct address_space *mapping,
 
 	/*
 	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
-	 * or we failed to allocate contiguous swap entries.
+	 * or we failed to allocate contiguous swap entries, in which case
+	 * the split out folios get added back to folio_list.
 	 */
-	if (shmem_mapping(mapping)) {
-		if (folio_test_large(folio))
-			wbc.list = folio_list;
-		res = shmem_writeout(folio, &wbc);
-	} else {
+	if (shmem_mapping(mapping))
+		res = shmem_writeout(folio, plug, folio_list);
+	else
 		res = swap_writeout(folio, &wbc);
-	}
 
 	if (res < 0)
 		handle_write_error(mapping, folio, res);
-- 
2.47.2

