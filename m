From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 22/62] page cache: Convert delete_batch to
 XArray
Date: Thu, 29 Mar 2018 20:42:05 -0700
Message-ID: <20180330034245.10462-23-willy@infradead.org>
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
 bh=n6UJsH0ZJ2+Exj0jaKVq1SnplwU+7iAsTZ78a9fD6BQ=; b=fsDJsOaR5aSt2vRsOsgyxB3GoS
 0jL+aBHJhtHxqaOp8aKCQtsTGE3+B7LutHN/EuvKh3SNvifuXFLeGoh164m18ZGcb1P46gEJwN7QX
 e+5c1mQ4DPc1GqbIJaLqmYYyka5uiI9DpZdDWOwJkrStPAHeDw5LwWm0QIJY9VakwDqE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=n6UJsH0ZJ2+Exj0jaKVq1SnplwU+7iAsTZ78a9fD6BQ=; b=ZUPU5ldC6vN7YSk8NoM1Ihsq/1
 PgDhjvYCV5+D0qFVhoRAW2JzPOBhzkYo/coElBjy7RiN8knIt0M3zOKLkCOzlXs4cH/QXSYlLvvNg
 EOtZzGSbXrp6JG9VFu/zJo/fjJ8SPUcIEBb4Rgwf5cFd5+1/g3DQ9WM9vTW3G3LDoFJU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=n6UJsH0ZJ2+Exj0jaKVq1SnplwU+7iAsTZ78a9fD6BQ=; b=R0nq0zVcWdbada53pmqMaH/g2
 UOSH8VNVq3rOdNIMcIhlrclmwjVpqPDmIkF0qUVUmAbNZrF9MOuSq3zNjs+hmkGTENAY7EAfukEaI
 3ZF+CDB4LQ9CDU8NIxYq+rIFTcsSxj7U40l6uZ8oEjDTsqx63PjHgeWNsF9kxKEuxDbDLzNCOauBn
 hIk19aaSHZHn66hHv8dOwu8KDLBQKFQ5dP4HUapVuGq5z4pVnUIFGN9DhWscp7jgx9LLzxPGde6yh
 00nCFW1Z94TjZHtNvWA/sHeiaBuU87aZrhsBiTC/wZ/GRZ4hPTn6YvBreGRlWx0lR5LzIvGyrWKTw
 9LcIk+dSQ==;
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

Rename the function from page_cache_tree_delete_batch to just
page_cache_delete_batch.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5a6c7c874d45..0635e9cdbc06 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -275,7 +275,7 @@ void delete_from_page_cache(struct page *page)
 EXPORT_SYMBOL(delete_from_page_cache);
 
 /*
- * page_cache_tree_delete_batch - delete several pages from page cache
+ * page_cache_delete_batch - delete several pages from page cache
  * @mapping: the mapping to which pages belong
  * @pvec: pagevec with pages to delete
  *
@@ -288,23 +288,18 @@ EXPORT_SYMBOL(delete_from_page_cache);
  *
  * The function expects the i_pages lock to be held.
  */
-static void
-page_cache_tree_delete_batch(struct address_space *mapping,
+static void page_cache_delete_batch(struct address_space *mapping,
 			     struct pagevec *pvec)
 {
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->i_pages, pvec->pages[0]->index);
 	int total_pages = 0;
 	int i = 0, tail_pages = 0;
 	struct page *page;
-	pgoff_t start;
 
-	start = pvec->pages[0]->index;
-	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
+	mapping_set_update(&xas, mapping);
+	xas_for_each(&xas, page, ULONG_MAX) {
 		if (i >= pagevec_count(pvec) && !tail_pages)
 			break;
-		page = radix_tree_deref_slot_protected(slot,
-						       &mapping->i_pages.xa_lock);
 		if (xa_is_value(page))
 			continue;
 		if (!tail_pages) {
@@ -313,8 +308,11 @@ page_cache_tree_delete_batch(struct address_space *mapping,
 			 * have our pages locked so they are protected from
 			 * being removed.
 			 */
-			if (page != pvec->pages[i])
+			if (page != pvec->pages[i]) {
+				VM_BUG_ON_PAGE(page->index >
+						pvec->pages[i]->index, page);
 				continue;
+			}
 			WARN_ON_ONCE(!PageLocked(page));
 			if (PageTransHuge(page) && !PageHuge(page))
 				tail_pages = HPAGE_PMD_NR - 1;
@@ -325,11 +323,11 @@ page_cache_tree_delete_batch(struct address_space *mapping,
 			 */
 			i++;
 		} else {
+			VM_BUG_ON_PAGE(page->index + HPAGE_PMD_NR - tail_pages
+					!= pvec->pages[i]->index, page);
 			tail_pages--;
 		}
-		radix_tree_clear_tags(&mapping->i_pages, iter.node, slot);
-		__radix_tree_replace(&mapping->i_pages, iter.node, slot, NULL,
-				workingset_lookup_update(mapping));
+		xas_store(&xas, NULL);
 		total_pages++;
 	}
 	mapping->nrpages -= total_pages;
@@ -350,7 +348,7 @@ void delete_from_page_cache_batch(struct address_space *mapping,
 
 		unaccount_page_cache_page(mapping, pvec->pages[i]);
 	}
-	page_cache_tree_delete_batch(mapping, pvec);
+	page_cache_delete_batch(mapping, pvec);
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 
 	for (i = 0; i < pagevec_count(pvec); i++)
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
