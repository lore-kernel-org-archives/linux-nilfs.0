From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 38/63] shmem: Convert shmem_add_to_page_cache
 to XArray
Date: Sat, 14 Apr 2018 07:12:51 -0700
Message-ID: <20180414141316.7167-39-willy@infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
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
 bh=YnRNXsr+MU7Euw/YrTFWe3evF0dOleXdA0pls7Ztxzw=; b=ZZSVs5Ewharg1I0ns8CI5hN9kM
 IFgz9FQP6tw8kzk0V2tpokKWGusmBhD5iuVXhgU01lWWZPtv0Ig7sIhEnGb3uji/B4QqTXMcOGmsf
 wiUyaRJ++Q+nmCQMYvbYA1D/2ivflQ/LhDFplDeudyzuiIV96rnq95wp8yOSPKSl1QFw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=YnRNXsr+MU7Euw/YrTFWe3evF0dOleXdA0pls7Ztxzw=; b=BAIK3QJPsj/RxbKd0B9t3cWy2g
 9foGWSX2XfnFr0Yr4Nagfk3cgtfKZFv5nWNff4oP1lf/leiwIfX3IEouzZs2A4uNJiRvoS58IM78K
 2IBs9wGpybXSTP0kqSzMft2wHcLEbaMxVpOiHRrrHroD56Ib0GSlKWCjaAyueM3/j0Y8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=YnRNXsr+MU7Euw/YrTFWe3evF0dOleXdA0pls7Ztxzw=; b=Qk/5S3hUYufMa76cBuUuSWsST
 JzBeGRqi80RUiA5MYw+u8Y1vMeKAKE+TN7WumCt6LeUgq3Y2AMjZ9j4cW0qTwsZLtfXXhAlwe92Pi
 3ZZh3Dn51vtpjtoeXESoF7hxnOmlVn+UGAhwreNRv5fJrUcvVVCgiOof83IdDFm9TEtHoG7KlOPPF
 25g5qhFki+mM8onfIYnkx0GxrkH0utxIZukaeSkAU74Tky75yxDKLeyi2y9Jlg9sZALWu9AyIIiwC
 nzP1cidxzaB/dOlEPZ7i6AWhpyXQkasXLiR0sQqps/BUcJYkK0/fgkfOL6QA/UlIeDOIFvUU1DylN
 jq7yIMfTg==;
In-Reply-To: <20180414141316.7167-1-willy@infradead.org>
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

This removes the last caller of radix_tree_maybe_preload_order().
Simpler code, unless we run out of memory for new xa_nodes partway through
inserting entries into the xarray.  Hopefully we can support multi-index
entries in the page cache soon and all the awful code goes away.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 87 ++++++++++++++++++++++++------------------------------
 1 file changed, 39 insertions(+), 48 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 784a49aad902..8d24d59b0e67 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -567,9 +567,10 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
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
@@ -578,49 +579,47 @@ static int shmem_add_to_page_cache(struct page *page,
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
-		error = shmem_xa_replace(mapping, index, expected, page);
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
@@ -1168,7 +1167,7 @@ static int shmem_unuse_inode(struct shmem_inode_info *info,
 	 */
 	if (!error)
 		error = shmem_add_to_page_cache(*pagep, mapping, index,
-						radswap);
+						radswap, gfp);
 	if (error != -ENOMEM) {
 		/*
 		 * Truncation and eviction use free_swap_and_cache(), which
@@ -1689,7 +1688,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 				false);
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
-						swp_to_radix_entry(swap));
+						swp_to_radix_entry(swap), gfp);
 			/*
 			 * We already confirmed swap under page lock, and make
 			 * no memory allocation here, so usually no possibility
@@ -1795,13 +1794,8 @@ alloc_nohuge:		page = shmem_alloc_and_acct_page(gfp, inode,
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
@@ -2268,11 +2262,8 @@ static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
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
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
