From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 29/78] page cache: Convert delete_batch to
 XArray
Date: Fri, 15 Dec 2017 14:04:01 -0800
Message-ID: <20171215220450.7899-30-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
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
 bh=2UdkSbeyH7o122AhifWZe0OaxN3Chpm99T7iA99mJVg=; b=ATcUVbDacsk0WQBn5udE9bohv0
 fY2ljzr9+iGZIVubQWa98GQNR0YtbMtAER8deN1ZkypFT1whlISSWEmI2t5ZlJQ1u9axpNXObsy39
 rPpV37ynNlS75YfNrWETKKKu/GEqRzjW2IIDzTXdZlGA21yxsdPL2mnz9LH5fcmQr8gc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=2UdkSbeyH7o122AhifWZe0OaxN3Chpm99T7iA99mJVg=; b=EI7GTgK8b9IUAy6ONdQ96ptS4X
 QzqqHahIQFEIC/Op3+XTVC/ES9fO9SxVDb4HXEKpjuYlCvWFth3M3WSTnG4E/yQZTA10pA6mHo8nt
 F5Y7r/+xWsxrM2qgLJNjALcdBKIaF9uP8XDNzPO6E2x0uO1cDEFns4sfqxJVc6rMUC7c=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=2UdkSbeyH7o122AhifWZe0OaxN3Chpm99T7iA99mJVg=; b=lPAX3b+4yYBdyqQCjBX/7ve0V
 ytkcOIOXvIk9NEhFuXYswxTd+IKpWKgLLZpeTJdKpmOImqfPBnijGb+7CisEiYjwL32h3ZUS+E/vD
 jdbQBy8raNr6WL7/HbS3TXTtwMy0Tp7Zh7pRg0O+daZ3sKtvGT16rw+1lFHHfVhDP7iRcKPXNa9qx
 Xh3hLAYDPIIx3QSp5ejE5oJjmqPjKu2gqyO90iB7ekalPkOIB/Gh8cGhGsZgDqwqC5XSjevo/iahF
 IzPRCSh/yQbySCq78fGRfs42dEKFOWoKMpdXK4rPvXeonZJyWS3P74rDORci0IL5Wp6YlAeWIA54j
 s8bXpUtcA==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Rename the function from page_cache_tree_delete_batch to just
page_cache_delete_batch.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 94496567d2c2..92ddee25f19b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -276,7 +276,7 @@ void delete_from_page_cache(struct page *page)
 EXPORT_SYMBOL(delete_from_page_cache);
 
 /*
- * page_cache_tree_delete_batch - delete several pages from page cache
+ * page_cache_delete_batch - delete several pages from page cache
  * @mapping: the mapping to which pages belong
  * @pvec: pagevec with pages to delete
  *
@@ -289,23 +289,18 @@ EXPORT_SYMBOL(delete_from_page_cache);
  *
  * The function expects xa_lock to be held.
  */
-static void
-page_cache_tree_delete_batch(struct address_space *mapping,
+static void page_cache_delete_batch(struct address_space *mapping,
 			     struct pagevec *pvec)
 {
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->pages, pvec->pages[0]->index);
 	int total_pages = 0;
 	int i = 0, tail_pages = 0;
 	struct page *page;
-	pgoff_t start;
 
-	start = pvec->pages[0]->index;
-	radix_tree_for_each_slot(slot, &mapping->pages, &iter, start) {
+	xas_set_update(&xas, workingset_lookup_update(mapping));
+	xas_for_each(&xas, page, ULONG_MAX) {
 		if (i >= pagevec_count(pvec) && !tail_pages)
 			break;
-		page = radix_tree_deref_slot_protected(slot,
-						       &mapping->pages.xa_lock);
 		if (xa_is_value(page))
 			continue;
 		if (!tail_pages) {
@@ -326,11 +321,11 @@ page_cache_tree_delete_batch(struct address_space *mapping,
 			 */
 			i++;
 		} else {
+			VM_BUG_ON_PAGE(page->index + HPAGE_PMD_NR - tail_pages
+					!= pvec->pages[i]->index, page);
 			tail_pages--;
 		}
-		radix_tree_clear_tags(&mapping->pages, iter.node, slot);
-		__radix_tree_replace(&mapping->pages, iter.node, slot, NULL,
-				workingset_lookup_update(mapping));
+		xas_store(&xas, NULL);
 		total_pages++;
 	}
 	mapping->nrpages -= total_pages;
@@ -351,7 +346,7 @@ void delete_from_page_cache_batch(struct address_space *mapping,
 
 		unaccount_page_cache_page(mapping, pvec->pages[i]);
 	}
-	page_cache_tree_delete_batch(mapping, pvec);
+	page_cache_delete_batch(mapping, pvec);
 	xa_unlock_irqrestore(&mapping->pages, flags);
 
 	for (i = 0; i < pagevec_count(pvec); i++)
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
