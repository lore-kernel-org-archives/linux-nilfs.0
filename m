Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F531EF080
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 05:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746683399; cv=none; b=m5XvGOxc/JX+5WmDUgfggfVslQPJOaqxwBZ6pjr9oxLTZ9SUx2CqKlcWw6DtJqBzgANd+7v/NcUIqZbhU/7YzpKiD418fhiodG1957xuQk0oSlq1n7lyG9V8TJ5JbCrzHWnJzuOFM5AFBIhdF6Ua0nM5ksmGs034dc1VacVq9aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746683399; c=relaxed/simple;
	bh=kcuSFYyFB1pcz905y9wJcKGDdMyewxQnx5LcHfMtAeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNkI32ph8NW5pVNxCqVphErB8DlGQXSj5PKX40nWWeJdQq5s9axnNcNrWQloBEzwx0xES95QB0+/cbUEg06j3b6yZC/MeZNOL0jjsPjfo6nOsGzMpoWBbmaq2LALXpAnGFF9MGuH4YVLwvB5aotEF+tvE0dQjwz1pbsAHUwyiyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=esn2Leho; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="esn2Leho"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=s1gmv6y24bFSpWBvtv1MZJpjC3NY6Oec0Tse6wevvTw=; b=esn2LehoZOFTy/kgbIdvxyP+QV
	J2cw1uPl2yosOu8OP1AGcfSVNrDlxC3yrC7Q7PJ8o81KccGuNtq86VE+CNMk8DWI4aZlC0g44sGp4
	IgMZQzAhIJYLTJyk39WaJ+GE7Xiulo36ar1F2ep0pklm7DFrl19EbNdLF5nRMGQUXdmElhK8ryry3
	oyxjBwmkgfHQCHmZhSu0fhj2wlysfkBAMnC3ZrEIUtf6T06TlYij6zUUnG22v7Cj94rOimKAgNZvH
	IySKMYy8beCZYtvNpFaE+VsDl0uJRMC53MCJsMec8IrKDp3zNvzCpk9ZO3wUe4FzaV9x7HOPlBSEI
	5n5/3olQ==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCu8q-0000000HOrj-1UCF;
	Thu, 08 May 2025 05:49:56 +0000
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
Subject: [PATCH 5/7] mm: stop passing a writeback_control structure to swap_writeout
Date: Thu,  8 May 2025 07:47:47 +0200
Message-ID: <20250508054938.15894-6-hch@lst.de>
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

swap_writeout only needs the swap_iocb cookie from the writeback_control
structure, so pass it explicitly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/writeback.h |  7 -------
 mm/page_io.c              |  4 ++--
 mm/shmem.c                | 10 +---------
 mm/swap.h                 |  4 +++-
 mm/vmscan.c               | 10 +---------
 5 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 82f217970092..9e960f2faf79 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -72,13 +72,6 @@ struct writeback_control {
 	 */
 	unsigned no_cgroup_owner:1;
 
-	/* To enable batching of swap writes to non-block-device backends,
-	 * "plug" can be set point to a 'struct swap_iocb *'.  When all swap
-	 * writes have been submitted, if with swap_iocb is not NULL,
-	 * swap_write_unplug() should be called.
-	 */
-	struct swap_iocb **swap_plug;
-
 	/* internal fields used by the ->writepages implementation: */
 	struct folio_batch fbatch;
 	pgoff_t index;
diff --git a/mm/page_io.c b/mm/page_io.c
index fb52bedcc966..a2056a5ecb13 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -237,7 +237,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
  * We may have stale swap cache pages in memory: notice
  * them here and get rid of the unnecessary final write.
  */
-int swap_writeout(struct folio *folio, struct writeback_control *wbc)
+int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	int ret = 0;
 
@@ -281,7 +281,7 @@ int swap_writeout(struct folio *folio, struct writeback_control *wbc)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writepage(folio, wbc->swap_plug);
+	__swap_writepage(folio, swap_plug);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
diff --git a/mm/shmem.c b/mm/shmem.c
index 941b9b29e78a..2033d2e3d35d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1635,21 +1635,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		list_add(&info->swaplist, &shmem_swaplist);
 
 	if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
-		struct writeback_control wbc = {
-			.sync_mode	= WB_SYNC_NONE,
-			.nr_to_write	= SWAP_CLUSTER_MAX,
-			.range_start	= 0,
-			.range_end	= LLONG_MAX,
-			.for_reclaim	= 1,
-			.swap_plug	= plug,
-		};
 		shmem_recalc_inode(inode, 0, nr_pages);
 		swap_shmem_alloc(folio->swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		mutex_unlock(&shmem_swaplist_mutex);
 		BUG_ON(folio_mapped(folio));
-		return swap_writeout(folio, &wbc);
+		return swap_writeout(folio, plug);
 	}
 
 	list_del_init(&info->swaplist);
diff --git a/mm/swap.h b/mm/swap.h
index bd642078544a..c6d661fa9db7 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -3,6 +3,8 @@
 #define _MM_SWAP_H
 
 struct mempolicy;
+struct swap_iocb;
+
 extern int page_cluster;
 
 #ifdef CONFIG_SWAP
@@ -20,7 +22,7 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
 		__swap_read_unplug(plug);
 }
 void swap_write_unplug(struct swap_iocb *sio);
-int swap_writeout(struct folio *folio, struct writeback_control *wbc);
+int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
 void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index fea78f01d04e..ad89b36eba01 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -655,14 +655,6 @@ typedef enum {
 static pageout_t writeout(struct folio *folio, struct address_space *mapping,
 		struct swap_iocb **plug, struct list_head *folio_list)
 {
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_NONE,
-		.nr_to_write = SWAP_CLUSTER_MAX,
-		.range_start = 0,
-		.range_end = LLONG_MAX,
-		.for_reclaim = 1,
-		.swap_plug = plug,
-	};
 	int res;
 
 	folio_set_reclaim(folio);
@@ -675,7 +667,7 @@ static pageout_t writeout(struct folio *folio, struct address_space *mapping,
 	if (shmem_mapping(mapping))
 		res = shmem_writeout(folio, plug, folio_list);
 	else
-		res = swap_writeout(folio, &wbc);
+		res = swap_writeout(folio, plug);
 
 	if (res < 0)
 		handle_write_error(mapping, folio, res);
-- 
2.47.2

