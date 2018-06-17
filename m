From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 50/74] shmem: Convert shmem_add_to_page_cache
 to XArray
Date: Sat, 16 Jun 2018 19:00:28 -0700
Message-ID: <20180617020052.4759-51-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
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
 bh=EUefWlPtQqMMGRj8qCB7qo8Y+Ow2jmws/Yul8+rze/I=; b=MJO6Ht4ZD4A0JmmA8MqtYeomxU
 gcwTwS2FUxGYILL/rMlXOvBEqLxzSH/qMBMrFLHcnecRdGSacV9rWBPsVzOLb4bYawlK4x9bhGA/x
 lR1Pg2/fzjDlySqcWpaHU83jW52Sdh/yehQK+06l7LivmpY7llz6FJEjo35MEWBpmuTk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=EUefWlPtQqMMGRj8qCB7qo8Y+Ow2jmws/Yul8+rze/I=; b=gynse5g1xeKRMlRi0EhuKvqTQ3
 OCLsbWLCacJSCRvS+28WRqkZf6JTOvAJzmlopcZVaZO4CNhuMzDGXTwcUS8A7okxI8sTYDNLm006u
 ZJMPy5AN1d4TqZqnjl5vT5azjzvjjEvgP2NdWsJh27eHJdhDuG+Ye8EaFhEwe52+MBiI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=EUefWlPtQqMMGRj8qCB7qo8Y+Ow2jmws/Yul8+rze/I=; b=ubmAvRa/gSM066Y2eaNBAl66n
 611KdyOjA+KprTOl7abAVHlueGLZsWCxfpyp98t5v6FvfebiiVz4aScCUmiHz4W5WgUujN+d04FHm
 QzEXp2mUWHlfo0gTL2AbYpw9kh2Qf0AFYN1k1Wxle+QgX9bOautnNBV79m/Kg4DZjZSfxsS6bhdKa
 YCYu1U+3Khh1oUSMEGdcp72OF9tymGgV+6jkFhJ8SjY+wEM8NN6yfYIWgvQBclawyE2JxzqQMx6vZ
 1QzB1FYRkt4OC5gFQr81GIqCEY+ygu11V5s8uFIINtpAxyZiuvMVMOGrUfZoL+ZK9EEWpPb3gLBfu
 rpL7BRdzw==;
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

This removes the last caller of radix_tree_maybe_preload_order().
Simpler code, unless we run out of memory for new xa_nodes partway through
inserting entries into the xarray.  Hopefully we can support multi-index
entries in the page cache soon and all the awful code goes away.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/shmem.c | 87 ++++++++++++++++++++++++------------------------------
 1 file changed, 39 insertions(+), 48 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 983a27656e2e..8e702b6d84a5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -576,9 +576,10 @@ static inline bool is_huge_enabled(struct shmem_sb_info *sbinfo)
  */
 static int shmem_add_to_page_cache(struct page *page,
 				   struct address_space *mapping,
-				   pgoff_t index, void *expected)
+				   pgoff_t index, void *expected, gfp_t gfp)
 {
-	int error, nr = hpage_nr_pages(page);
+	XA_STATE(xas, &mapping->i_pages, index);
+	unsigned long i, nr = 1UL << compound_order(page);
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	VM_BUG_ON_PAGE(index != round_down(index, nr), page);
@@ -587,49 +588,47 @@ static int shmem_add_to_page_cache(struct page *page,
 	VM_BUG_ON(expected && PageTransHuge(page));
 
 	page_ref_add(page, nr);
-	page->mapping = mapping;
 	page->index = index;
+	page->mapping = mapping;
 
-	xa_lock_irq(&mapping->i_pages);
-	if (PageTransHuge(page)) {
-		void __rcu **results;
-		pgoff_t idx;
-		int i;
-
-		error = 0;
-		if (radix_tree_gang_lookup_slot(&mapping->i_pages,
-					&results, &idx, index, 1) &&
-				idx < index + HPAGE_PMD_NR) {
-			error = -EEXIST;
+	do {
+		xas_lock_irq(&xas);
+		xas_create_range(&xas, index + nr - 1);
+		if (xas_error(&xas))
+			goto unlock;
+		for (i = 0; i < nr; i++) {
+			void *entry = xas_load(&xas);
+			if (entry != expected)
+				xas_set_err(&xas, -ENOENT);
+			if (xas_error(&xas))
+				goto undo;
+			xas_store(&xas, page + i);
+			xas_next(&xas);
 		}
-
-		if (!error) {
-			for (i = 0; i < HPAGE_PMD_NR; i++) {
-				error = radix_tree_insert(&mapping->i_pages,
-						index + i, page + i);
-				VM_BUG_ON(error);
-			}
+		if (PageTransHuge(page)) {
 			count_vm_event(THP_FILE_ALLOC);
+			__inc_node_page_state(page, NR_SHMEM_THPS);
 		}
-	} else if (!expected) {
-		error = radix_tree_insert(&mapping->i_pages, index, page);
-	} else {
-		error = shmem_replace_entry(mapping, index, expected, page);
-	}
-
-	if (!error) {
 		mapping->nrpages += nr;
-		if (PageTransHuge(page))
-			__inc_node_page_state(page, NR_SHMEM_THPS);
 		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
 		__mod_node_page_state(page_pgdat(page), NR_SHMEM, nr);
-		xa_unlock_irq(&mapping->i_pages);
-	} else {
+		goto unlock;
+undo:
+		while (i-- > 0) {
+			xas_store(&xas, NULL);
+			xas_prev(&xas);
+		}
+unlock:
+		xas_unlock_irq(&xas);
+	} while (xas_nomem(&xas, gfp));
+
+	if (xas_error(&xas)) {
 		page->mapping = NULL;
-		xa_unlock_irq(&mapping->i_pages);
 		page_ref_sub(page, nr);
+		return xas_error(&xas);
 	}
-	return error;
+
+	return 0;
 }
 
 /*
@@ -1182,7 +1181,7 @@ static int shmem_unuse_inode(struct shmem_inode_info *info,
 	 */
 	if (!error)
 		error = shmem_add_to_page_cache(*pagep, mapping, index,
-						radswap);
+						radswap, gfp);
 	if (error != -ENOMEM) {
 		/*
 		 * Truncation and eviction use free_swap_and_cache(), which
@@ -1698,7 +1697,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 				false);
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
-						swp_to_radix_entry(swap));
+						swp_to_radix_entry(swap), gfp);
 			/*
 			 * We already confirmed swap under page lock, and make
 			 * no memory allocation here, so usually no possibility
@@ -1804,13 +1803,8 @@ alloc_nohuge:		page = shmem_alloc_and_acct_page(gfp, inode,
 				PageTransHuge(page));
 		if (error)
 			goto unacct;
-		error = radix_tree_maybe_preload_order(gfp & GFP_RECLAIM_MASK,
-				compound_order(page));
-		if (!error) {
-			error = shmem_add_to_page_cache(page, mapping, hindex,
-							NULL);
-			radix_tree_preload_end();
-		}
+		error = shmem_add_to_page_cache(page, mapping, hindex,
+						NULL, gfp & GFP_RECLAIM_MASK);
 		if (error) {
 			mem_cgroup_cancel_charge(page, memcg,
 					PageTransHuge(page));
@@ -2277,11 +2271,8 @@ static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 	if (ret)
 		goto out_release;
 
-	ret = radix_tree_maybe_preload(gfp & GFP_RECLAIM_MASK);
-	if (!ret) {
-		ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL);
-		radix_tree_preload_end();
-	}
+	ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL,
+						gfp & GFP_RECLAIM_MASK);
 	if (ret)
 		goto out_release_uncharge;
 
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
