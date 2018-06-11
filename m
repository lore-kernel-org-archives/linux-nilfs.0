From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 22/72] page cache: Convert page deletion to
 XArray
Date: Mon, 11 Jun 2018 07:05:49 -0700
Message-ID: <20180611140639.17215-23-willy@infradead.org>
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
 bh=xgN5I86dlSi53bLy0zP0slssD0IoeCly8roO5uiBf6g=; b=QRJu+Nw8FEUcMZJXGOSDbC77e3
 1DAHQZO8998zWm8iNaN63ccebS2u9i4ei3H6mLXh+RJnmeI+D9uLdtAdDfPO8VrVHzP67qqpmVdBZ
 QqDbTFLTM3CfIwwOeRtBR09l9S/Gd0zA8Mbf+rlqOJ6pMDxkrwLAZMf3xhXLC8kqVJzE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=xgN5I86dlSi53bLy0zP0slssD0IoeCly8roO5uiBf6g=; b=l6R+UHgm6DMmrdgrfuJyaADEYe
 pniWo2Bb+vS62wNSV0UoFV0fgQmkSpcDdnn4jV0YC9YCEPTryCwen7in6NSwPLnlQC3QXNnuMzSKx
 O+bEijcbXnK/bc3fDYh5o5ZWDJuMea/43oy7YEoTcLtUMqbM7iciR1PjCIE8NnHnxvjg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=xgN5I86dlSi53bLy0zP0slssD0IoeCly8roO5uiBf6g=; b=R1VwQYpNTyLCGomBjeT//5+TU
 JDOn3gv29DKZlI7fLZwDSnmlVLadQJE6EAuddV7MO1WzLBKlsg0qUXgar0AVGJBmOSZkPpxtkcnKE
 MBQuIPWOnjFhPcHi5GhOa3DJo2OW46clunsLADcfquya6wxMRxzhvMJiw/ScTXvq8gclwhBxYyYRr
 0So/upa+AODnb60UxFal3h3InRgRHPGkiH9uTBo3ZqJ9rYHu50yLVNe3U4yQWOV6pu2dmYOtlzoUf
 Tp8a/ck1PE50zcZ4rWJAJ29cxo93qobxaBSjGYXqz2qKv4tPYCANTG06IM13QRoV7k+fmbfByVGpz
 D9DefgZfA==;
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

The code is slightly shorter and simpler.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 965ff68e5b8d..7cdb1d4b8117 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -111,31 +111,26 @@
  *   ->tasklist_lock            (memory_failure, collect_procs_ao)
  */
 
-static void page_cache_tree_delete(struct address_space *mapping,
+static void page_cache_delete(struct address_space *mapping,
 				   struct page *page, void *shadow)
 {
-	int i, nr;
+	XA_STATE(xas, &mapping->i_pages, page->index);
+	unsigned int nr = 1;
 
-	/* hugetlb pages are represented by one entry in the radix tree */
-	nr = PageHuge(page) ? 1 : hpage_nr_pages(page);
+	mapping_set_update(&xas, mapping);
+
+	/* hugetlb pages are represented by a single entry in the xarray */
+	if (!PageHuge(page)) {
+		xas_set_order(&xas, page->index, compound_order(page));
+		nr = 1U << compound_order(page);
+	}
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	VM_BUG_ON_PAGE(nr != 1 && shadow, page);
 
-	for (i = 0; i < nr; i++) {
-		struct radix_tree_node *node;
-		void **slot;
-
-		__radix_tree_lookup(&mapping->i_pages, page->index + i,
-				    &node, &slot);
-
-		VM_BUG_ON_PAGE(!node && nr != 1, page);
-
-		radix_tree_clear_tags(&mapping->i_pages, node, slot);
-		__radix_tree_replace(&mapping->i_pages, node, slot, shadow,
-				workingset_lookup_update(mapping));
-	}
+	xas_store(&xas, shadow);
+	xas_init_tags(&xas);
 
 	page->mapping = NULL;
 	/* Leave page->index set: truncation lookup relies upon it */
@@ -234,7 +229,7 @@ void __delete_from_page_cache(struct page *page, void *shadow)
 	trace_mm_filemap_delete_from_page_cache(page);
 
 	unaccount_page_cache_page(mapping, page);
-	page_cache_tree_delete(mapping, page, shadow);
+	page_cache_delete(mapping, page, shadow);
 }
 
 static void page_cache_free_page(struct address_space *mapping,
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
