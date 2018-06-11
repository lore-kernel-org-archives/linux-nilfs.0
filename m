From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 27/72] page cache;
 Convert find_get_pages_range_tag to XArray
Date: Mon, 11 Jun 2018 07:05:54 -0700
Message-ID: <20180611140639.17215-28-willy@infradead.org>
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
 bh=mKlDprFcod+mEKzLVONxtmRV1mIt0qW8UDzOtSiZ0e8=; b=RRksyX7SEWFgGHl3XGW/X5bBpC
 Nlc4WwqQldlsB3SQEPP5LGe2l41jVU1zZ8ZpK1yJUOzVTxiPF1/F8+3zF01hM6QDCeAjNg4cV8YUw
 RSaIIoa5eYAEpdzmliNJF3kerT9ziL3h5QDCQV54tThiMaWufvdGKmR5uXeC8Am+WOIQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=mKlDprFcod+mEKzLVONxtmRV1mIt0qW8UDzOtSiZ0e8=; b=EFbr6zpq27RTX1TJ4rwRuTvCVO
 yaeIaSokVjYdGnEUHw6kVtCA3Kd+vIYSQcv5FMhxMgGVdhN7m8qoKDo7DArk+CM/WesoPKM+yzgmk
 lUwNuJV1EH77VP3ZQBGT9lxuLGIDuxAiq80NpgdRIOTOT0/GoE9NdihAs2EOb9Itiv8M=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=mKlDprFcod+mEKzLVONxtmRV1mIt0qW8UDzOtSiZ0e8=; b=stPY4WFippmnburrIWxLJ29Cf
 T2j8yEfcZ4UtMsVYKR9T6k/3vRlhc/b4GL6+L+1m+GFDzFXohAtcXrSxGXzK7QkMhOZU4SbvmkYFP
 Evb0oA5e5X4Wa46zPBcnctROlg25E1X5PNFnEBh+VXe/5/H2mGoM/awtxL68wymOVGUEsiPG3WRcR
 UIi5HcDl5EZd3J4zwr7Tel4FuKgOwGPMSm/sTe6huQRuMylaVLhznJGDenSa8STGQPbqankuM4Wbd
 J3eQ1qAY1hGg2VJ50SNBgHHepLnlxiAOvEB0RueMu8DrN0emEJz7li1KyX6hLxkGm/6Xa/WpAdOxg
 17uL4hxfQ==;
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

The 'end' parameter of the xas_for_each iterator avoids a useless
iteration at the end of the range.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/pagemap.h |  4 +--
 mm/filemap.c            | 68 ++++++++++++++++-------------------------
 2 files changed, 28 insertions(+), 44 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2f5d2d3ebaac..a6d635fefb01 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -363,10 +363,10 @@ static inline unsigned find_get_pages(struct address_space *mapping,
 unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
 			       unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_range_tag(struct address_space *mapping, pgoff_t *index,
-			pgoff_t end, int tag, unsigned int nr_pages,
+			pgoff_t end, xa_tag_t tag, unsigned int nr_pages,
 			struct page **pages);
 static inline unsigned find_get_pages_tag(struct address_space *mapping,
-			pgoff_t *index, int tag, unsigned int nr_pages,
+			pgoff_t *index, xa_tag_t tag, unsigned int nr_pages,
 			struct page **pages)
 {
 	return find_get_pages_range_tag(mapping, index, (pgoff_t)-1, tag,
diff --git a/mm/filemap.c b/mm/filemap.c
index 8a69613fcdf3..83328635edaa 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1789,74 +1789,58 @@ EXPORT_SYMBOL(find_get_pages_contig);
  * @tag.   We update @index to index the next page for the traversal.
  */
 unsigned find_get_pages_range_tag(struct address_space *mapping, pgoff_t *index,
-			pgoff_t end, int tag, unsigned int nr_pages,
+			pgoff_t end, xa_tag_t tag, unsigned int nr_pages,
 			struct page **pages)
 {
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->i_pages, *index);
+	struct page *page;
 	unsigned ret = 0;
 
 	if (unlikely(!nr_pages))
 		return 0;
 
 	rcu_read_lock();
-	radix_tree_for_each_tagged(slot, &mapping->i_pages, &iter, *index, tag) {
-		struct page *head, *page;
-
-		if (iter.index > end)
-			break;
-repeat:
-		page = radix_tree_deref_slot(slot);
-		if (unlikely(!page))
+	xas_for_each_tagged(&xas, page, end, tag) {
+		struct page *head;
+		if (xas_retry(&xas, page))
 			continue;
-
-		if (radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page)) {
-				slot = radix_tree_iter_retry(&iter);
-				continue;
-			}
-			/*
-			 * A shadow entry of a recently evicted page.
-			 *
-			 * Those entries should never be tagged, but
-			 * this tree walk is lockless and the tags are
-			 * looked up in bulk, one radix tree node at a
-			 * time, so there is a sizable window for page
-			 * reclaim to evict a page we saw tagged.
-			 *
-			 * Skip over it.
-			 */
+		/*
+		 * Shadow entries should never be tagged, but this iteration
+		 * is lockless so there is a window for page reclaim to evict
+		 * a page we saw tagged.  Skip over it.
+		 */
+		if (xa_is_value(page))
 			continue;
-		}
 
 		head = compound_head(page);
 		if (!page_cache_get_speculative(head))
-			goto repeat;
+			goto retry;
 
 		/* The page was split under us? */
-		if (compound_head(page) != head) {
-			put_page(head);
-			goto repeat;
-		}
+		if (compound_head(page) != head)
+			goto put_page;
 
 		/* Has the page moved? */
-		if (unlikely(page != *slot)) {
-			put_page(head);
-			goto repeat;
-		}
+		if (unlikely(page != xas_reload(&xas)))
+			goto put_page;
 
 		pages[ret] = page;
 		if (++ret == nr_pages) {
-			*index = pages[ret - 1]->index + 1;
+			*index = page->index + 1;
 			goto out;
 		}
+		continue;
+put_page:
+		put_page(head);
+retry:
+		xas_reset(&xas);
 	}
 
 	/*
-	 * We come here when we got at @end. We take care to not overflow the
+	 * We come here when we got to @end. We take care to not overflow the
 	 * index @index as it confuses some of the callers. This breaks the
-	 * iteration when there is page at index -1 but that is already broken
-	 * anyway.
+	 * iteration when there is a page at index -1 but that is already
+	 * broken anyway.
 	 */
 	if (end == (pgoff_t)-1)
 		*index = (pgoff_t)-1;
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
