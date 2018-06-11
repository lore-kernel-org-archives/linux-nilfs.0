From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 25/72] page cache: Convert
 find_get_pages_range to XArray
Date: Mon, 11 Jun 2018 07:05:52 -0700
Message-ID: <20180611140639.17215-26-willy@infradead.org>
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
 bh=+c+l1NkAi3vmmhzDtUhhMVC9W/oaDCjLLlNg0JM0yu4=; b=JSTE+20LgN+oNIYcPDbbmcj4+Y
 +Phr7HmEZIrKQPBdmrtMye6dX+5rD4T2NgtyrSru6Ni/RtRdoVl0Iu3MKsHOMlhRrlVTAZedKfczZ
 JacJvVAxUOdPNrp7iTjBebwJS5Wmwa/37imJgPQ+sfKef1U26jlCPr9jU4gYm0Z54Ka4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=+c+l1NkAi3vmmhzDtUhhMVC9W/oaDCjLLlNg0JM0yu4=; b=RrsHE5+7+czp5GBoq7hEqcUsj7
 67qb/mD6TN1php8GpxCjsHXp/Vgb5Xn3IjC3Eao0hQhHDeuwXYogLJPncwtKUox+HzwIShVOMZZLC
 Ih/IoCTu0mpi2xVQ5ZavQDCIAuujY8hLGm3vPY+UqaSgwyzAVKGdWgHzjRpnckkPLuYQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=+c+l1NkAi3vmmhzDtUhhMVC9W/oaDCjLLlNg0JM0yu4=; b=iEUzAMRfHgRfvebMaKJqDTGkZ
 AaNbUk3keL7ve5wapSApkl5+mV3v6qoydpMdkJaTheMjI6vELUAdZU7QV/Gsku9Qj5HJqsJuUGUju
 hEOklifUvPIFNxfAV/+BLxaH43R3gguKxR9TGAFhAR3ApsMtoy2g/OJAY81zBLZ7D//mUKx+TJ1nH
 XIOr0bJJG3hKcwutCd9wuDfNpSxB7JPfVuK3fr10xw2Vqzqek7elH9kPmdy1syE0EN9dpT5i0UWZp
 B1EutnH3BwxjpC7Eonj/XQwGsrIyMe+ma6OfxKOHwuY5UHwjd/+0MQAltp2LJz13nU0lI5DfIer38
 dSj+2S0jg==;
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
