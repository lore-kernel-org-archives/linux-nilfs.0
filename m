From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 26/74] page cache: Convert
 find_get_pages_range to XArray
Date: Sat, 16 Jun 2018 19:00:04 -0700
Message-ID: <20180617020052.4759-27-willy@infradead.org>
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
 bh=DJ+dstBiK4VALgrPZuDMj7L+o/CdChWFWdvZH44f17s=; b=XAQrX3BmrvvE8KgNLLuvl3LFmY
 hGp3yQQQwEkZg3S/CLpwnZOfPavKkv6GnpgOHDwI+aiyLntF/R20GJF4LxK9vBkZvS9iSR8T5+qBy
 c9J9NzrzL0sGSsARjvHgx9zNvsu9VDXx0wxLcdWb50wodJOaJSi5JDiECZa9g9mY7TPY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=DJ+dstBiK4VALgrPZuDMj7L+o/CdChWFWdvZH44f17s=; b=AyHI4ZU/6CrYsCJS5Wy7MtB+eG
 mvZgpgp04p2+rFeKbO5fqp6xloLzduFb5K5/PNin6t0vqC5D2Se+0rHJlxj6RllN1TExZYsy5jG1H
 KBGiqOtf0r10GxmlNUKcCQV8890Kdi8fbQFC5Drgyi7jQq4ALcUxXyfjf4+LMISA8Wqs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=DJ+dstBiK4VALgrPZuDMj7L+o/CdChWFWdvZH44f17s=; b=INyNmPzixk4Iz1eA54QXSKCAC
 LXiTbJfuzUeHSUZOgBVZBiK9SYrHS6o2gb3cXQ0eDvqcxFzV3PcFS6ZLb/03K8TzefDmyOAKMa73m
 nyvomD5baJtL8um6jdPYkxCEERKUDhfLacbpRrYHV9R8EFevpaw5cPrUEQ/WfCHuxsQiMw/unxQmW
 f/E6sPBowdhT4+snThknwZULxAD7oLlyLnB0fn51Pp1PlXh4LHNq5ZiEo1ARCOXsPQ+b3mtRoyYND
 3No1Tp0zHY5kT8cPmHz/94pc+EFRxrSkPABDskr+YSaNRIjlbgAyAhin6FmNDfH5pNINrjlBvGrHz
 V3x1PifuQ==;
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

The 'end' parameter of the xas_for_each iterator avoids a useless
iteration at the end of the range.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/filemap.c | 52 +++++++++++++++++++---------------------------------
 1 file changed, 19 insertions(+), 33 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b49290131e85..019c263bb6be 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1650,64 +1650,50 @@ unsigned find_get_pages_range(struct address_space *mapping, pgoff_t *start,
 			      pgoff_t end, unsigned int nr_pages,
 			      struct page **pages)
 {
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->i_pages, *start);
+	struct page *page;
 	unsigned ret = 0;
 
 	if (unlikely(!nr_pages))
 		return 0;
 
 	rcu_read_lock();
-	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, *start) {
-		struct page *head, *page;
-
-		if (iter.index > end)
-			break;
-repeat:
-		page = radix_tree_deref_slot(slot);
-		if (unlikely(!page))
+	xas_for_each(&xas, page, end) {
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
-			 * A shadow entry of a recently evicted page,
-			 * or a swap entry from shmem/tmpfs.  Skip
-			 * over it.
-			 */
+		/* Skip over shadow, swap and DAX entries */
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
-			*start = pages[ret - 1]->index + 1;
+			*start = page->index + 1;
 			goto out;
 		}
+		continue;
+put_page:
+		put_page(head);
+retry:
+		xas_reset(&xas);
 	}
 
 	/*
 	 * We come here when there is no page beyond @end. We take care to not
 	 * overflow the index @start as it confuses some of the callers. This
-	 * breaks the iteration when there is page at index -1 but that is
+	 * breaks the iteration when there is a page at index -1 but that is
 	 * already broken anyway.
 	 */
 	if (end == (pgoff_t)-1)
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
