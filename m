From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 24/72] page cache: Convert find_get_entries
 to XArray
Date: Mon, 11 Jun 2018 07:05:51 -0700
Message-ID: <20180611140639.17215-25-willy@infradead.org>
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
 bh=twa7itpLIU58lfU+MddoEIWcRCNFcsboeQJXmsXbu6U=; b=ag9GHYR0kRM4+dzGGqZXSTDORM
 Hfp3n8q6jubcQ6AuI4hqrlbTeDNxDg/1pdZV1yfiOcgxGadxFkT9Yo/IStP92+4n6n4OqTxvYSWz9
 40yHG3IrtxDV4392o30jnihdtsF/qXthIEjMSqQhWqmEqklhzx/hSe5+KWiODmsvgrt8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=twa7itpLIU58lfU+MddoEIWcRCNFcsboeQJXmsXbu6U=; b=LxH/mWG1w5oMuZxwe+KG1ReD3J
 hBx9yyprSVq8GL3HroE8167UtAYRNoAkGW7O9pE4BCcNRA1/pwtWasKIUHN7Nw4eb61+pcMop7Ga/
 U9QeBMz8prLj5aJEXkCYYOVmJKx99yHa2paR3vovALfUKRpIhdThYOhJO4wAOryOZ5eE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=twa7itpLIU58lfU+MddoEIWcRCNFcsboeQJXmsXbu6U=; b=mSlf1ufG8UA2KgMlNo35S+NaM
 4CjH391z2F6+7znnZEMPVL7go8HO+W+TN2hpsuDyFrxz2OPuWskz/wYlj552FIvE4Hpog7SO9kcxg
 DrprQ4hWv0/bDKjgatLik6LF4krDh/OsLmsXbm3H/eM8s/VqgBF6Jv98EvDxXszTyk12YNiqF1xpv
 d66vJwkvlPIKpNzbuT1hNaXfa2tF/8BtSOYLkWCuBKfTJPDSloDiG5SlNPm2EyWEqL2jml1g7woV7
 cFqwjvs/OUsSqOtb6Q7OeV9m5zQAHgFlN7ay+NhOW5o6BjmAeP1/XMJC3yq2oo1UX/WygmkKtIClE
 3CWvgUinA==;
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
 mm/filemap.c | 51 +++++++++++++++++++++++----------------------------
 1 file changed, 23 insertions(+), 28 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6db3d35ff5f6..b49290131e85 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1578,53 +1578,48 @@ unsigned find_get_entries(struct address_space *mapping,
 			  pgoff_t start, unsigned int nr_entries,
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
-	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
-		struct page *head, *page;
-repeat:
-		page = radix_tree_deref_slot(slot);
-		if (unlikely(!page))
+	xas_for_each(&xas, page, ULONG_MAX) {
+		struct page *head;
+		if (xas_retry(&xas, page))
 			continue;
-		if (radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page)) {
-				slot = radix_tree_iter_retry(&iter);
-				continue;
-			}
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
