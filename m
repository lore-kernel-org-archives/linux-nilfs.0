From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 28/72] page cache: Convert
 find_get_entries_tag to XArray
Date: Mon, 11 Jun 2018 07:05:55 -0700
Message-ID: <20180611140639.17215-29-willy@infradead.org>
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
 bh=fwqoMbRfGsDMvYDOCVix3zU3Jbw64C7uj9ufKhyC6y4=; b=mcwzLLXOAJ42B8WX28t7ftSefs
 LiBnkrYtrhWYsr4K547OH/OhkrvzMgcDqHgLFxneodPCmwu4TLF6eGbJFotTe9CMXTGJ/BMgU9wj8
 npbBdNMFJEoUivEt7T1mK6All95N37KDvePWl/LTo4R/wWe4MlU+WmaOAgtcdGL9wzO8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=fwqoMbRfGsDMvYDOCVix3zU3Jbw64C7uj9ufKhyC6y4=; b=SHnTvsJCqRi19arvN4ZOK69E0A
 QS2/OAf/eP+2jvQlPKCMIeEqW08GSsiAoN41BpAQzWyAVlgUIX3pLVm+ixzgpmShBqqHtS3K7n/Rq
 043ZCVv9bOoqzUXmBoNAS5+/Jl5tu7nptVw0tt/+WX+yqtgiqDIcSjqTkxZNBi3f1D3Y=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=fwqoMbRfGsDMvYDOCVix3zU3Jbw64C7uj9ufKhyC6y4=; b=a4cv7/sWTzuX3VMy+74ENBJsu
 uDXnsLwh8pfamO8PHVtIM4BfGFuFmkuWaAuTd2OyiSzwc4yvucEgPS2M4CO1fKcI9tzuzZfSr7wcY
 49M405DypPQkLX2MqXuOaElrel2+hxTERI8Sx3xocIbWTLqNA0xnv+vCVDBkLSQvc3bC2Otopgb5k
 orYWU/Fj09Ch/hZh4TgyvmISicIli+YdFMbTpC1nuIOU4ekuXWNZG4au6rPtJ74XWny4VTXxO9Koq
 A4NVc+l9AZ8BJgOb5sslB15T9PTo6NdzkmBEduTVzLOR45aUY9gDp8vH6y78aI0HyO01q028HInGj
 iOsZN43Yg==;
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

Slightly shorter and simpler code.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/pagemap.h |  2 +-
 mm/filemap.c            | 54 ++++++++++++++++++-----------------------
 2 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index a6d635fefb01..442977811b59 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -373,7 +373,7 @@ static inline unsigned find_get_pages_tag(struct address_space *mapping,
 					nr_pages, pages);
 }
 unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
-			int tag, unsigned int nr_entries,
+			xa_tag_t tag, unsigned int nr_entries,
 			struct page **entries, pgoff_t *indices);
 
 struct page *grab_cache_page_write_begin(struct address_space *mapping,
diff --git a/mm/filemap.c b/mm/filemap.c
index 83328635edaa..67f04bcdf9ef 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1866,57 +1866,51 @@ EXPORT_SYMBOL(find_get_pages_range_tag);
  * @tag.
  */
 unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
-			int tag, unsigned int nr_entries,
+			xa_tag_t tag, unsigned int nr_entries,
 			struct page **entries, pgoff_t *indices)
 {
-	void **slot;
+	XA_STATE(xas, &mapping->i_pages, start);
+	struct page *page;
 	unsigned int ret = 0;
-	struct radix_tree_iter iter;
 
 	if (!nr_entries)
 		return 0;
 
 	rcu_read_lock();
-	radix_tree_for_each_tagged(slot, &mapping->i_pages, &iter, start, tag) {
-		struct page *head, *page;
-repeat:
-		page = radix_tree_deref_slot(slot);
-		if (unlikely(!page))
+	xas_for_each_tagged(&xas, page, ULONG_MAX, tag) {
+		struct page *head;
+		if (xas_retry(&xas, page))
 			continue;
-		if (radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page)) {
-				slot = radix_tree_iter_retry(&iter);
-				continue;
-			}
-
-			/*
-			 * A shadow entry of a recently evicted page, a swap
-			 * entry from shmem/tmpfs or a DAX entry.  Return it
-			 * without attempting to raise page count.
-			 */
+		/*
+		 * A shadow entry of a recently evicted page, a swap
+		 * entry from shmem/tmpfs or a DAX entry.  Return it
+		 * without attempting to raise page count.
+		 */
+		if (xa_is_value(page))
 			goto export;
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
+
 export:
-		indices[ret] = iter.index;
+		indices[ret] = xas.xa_index;
 		entries[ret] = page;
 		if (++ret == nr_entries)
 			break;
+		continue;
+put_page:
+		put_page(head);
+retry:
+		xas_reset(&xas);
 	}
 	rcu_read_unlock();
 	return ret;
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
