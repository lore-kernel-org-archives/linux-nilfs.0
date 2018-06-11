From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 38/72] mm: Convert delete_from_swap_cache to
 XArray
Date: Mon, 11 Jun 2018 07:06:05 -0700
Message-ID: <20180611140639.17215-39-willy@infradead.org>
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
 bh=uvWT6f10klRi6JfdlHzw39lMupXUF1V/YTllgCogeUs=; b=OdAw7EkBJMYEO/b6C/4QoqOIpU
 7H7kLJIUbxTtlve0d4gZh/JHAGE+gwrGpF7LbBIVbGwlIHIErBqqitCtDmIumC1eToDiYXwQr3tSO
 E+BpAKIQFLY8ScQO6FiPKffStI5BhH0AOO+eMUE5sgcwQ7lqI/OiT8nLRAe+qN+V/9os=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=uvWT6f10klRi6JfdlHzw39lMupXUF1V/YTllgCogeUs=; b=FhP9LDP347Ofgc5WBpjjRFgL7u
 6GFj2Z5xxFKS0Rky8h5skKpWJr1G+e6qdTD/EZdGsWIc1mKtCy5iuBMN8Et0D2jgYevZx3Ipk3MfG
 KaDD3T6I0TQnoALPrwbLBi3KBh5qnlTxIy7Ff5uh+hBGMdVsZ1WXW6SzPvpNjIFtBPd8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=uvWT6f10klRi6JfdlHzw39lMupXUF1V/YTllgCogeUs=; b=Tb4OH0Jto49hcS/OlmqvrGaTX
 2w31KZDWmN1UCgddj7yKcHNvky0pWsrvTvMVqnUMh4QYJXcmQqwfLgBRe3rlb/xsJOCJmLU0a9RmS
 ztKBocaDK4KTW+ljTWVyJ7jiJwiF15ZSBEs0HrrK0POdgfFx7ahLhh+yz1pHN8mc6BhHymvud3Spg
 MDbWWjjAYt813vsO+EJ4bXkY0jIfa5hjx1iTswqdxUiLjYmG4ZFrCYIh8XpdupdbwDbS7Nvn2Uj5i
 hOAzMqz9kOBhxddYRnGRENmzPlUVJppdn7Ip7K9pX/fQ4VmwOmlCcRAZQ8Je0nl+T4yZ+I8fDw8+w
 iipgW+04w==;
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

Both callers of __delete_from_swap_cache have the swp_entry_t already,
so pass that in to make constructing the XA_STATE easier.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/swap.h |  5 +++--
 mm/swap_state.c      | 24 ++++++++++--------------
 mm/vmscan.c          |  2 +-
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a450a1d40b19..470570dac9e8 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -404,7 +404,7 @@ extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *page);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
 extern int __add_to_swap_cache(struct page *page, swp_entry_t entry);
-extern void __delete_from_swap_cache(struct page *);
+extern void __delete_from_swap_cache(struct page *, swp_entry_t entry);
 extern void delete_from_swap_cache(struct page *);
 extern void free_page_and_swap_cache(struct page *);
 extern void free_pages_and_swap_cache(struct page **, int);
@@ -564,7 +564,8 @@ static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
 	return -1;
 }
 
-static inline void __delete_from_swap_cache(struct page *page)
+static inline void __delete_from_swap_cache(struct page *page,
+							swp_entry_t entry)
 {
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index ac07db436c15..84595e1a4cd7 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -154,23 +154,22 @@ int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp)
  * This must be called only on pages that have
  * been verified to be in the swap cache.
  */
-void __delete_from_swap_cache(struct page *page)
+void __delete_from_swap_cache(struct page *page, swp_entry_t entry)
 {
-	struct address_space *address_space;
+	struct address_space *address_space = swap_address_space(entry);
 	int i, nr = hpage_nr_pages(page);
-	swp_entry_t entry;
-	pgoff_t idx;
+	pgoff_t idx = swp_offset(entry);
+	XA_STATE(xas, &address_space->i_pages, idx);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	VM_BUG_ON_PAGE(PageWriteback(page), page);
 
-	entry.val = page_private(page);
-	address_space = swap_address_space(entry);
-	idx = swp_offset(entry);
 	for (i = 0; i < nr; i++) {
-		radix_tree_delete(&address_space->i_pages, idx + i);
+		void *entry = xas_store(&xas, NULL);
+		VM_BUG_ON_PAGE(entry != page + i, entry);
 		set_page_private(page + i, 0);
+		xas_next(&xas);
 	}
 	ClearPageSwapCache(page);
 	address_space->nrpages -= nr;
@@ -243,14 +242,11 @@ int add_to_swap(struct page *page)
  */
 void delete_from_swap_cache(struct page *page)
 {
-	swp_entry_t entry;
-	struct address_space *address_space;
-
-	entry.val = page_private(page);
+	swp_entry_t entry = { .val = page_private(page) };
+	struct address_space *address_space = swap_address_space(entry);
 
-	address_space = swap_address_space(entry);
 	xa_lock_irq(&address_space->i_pages);
-	__delete_from_swap_cache(page);
+	__delete_from_swap_cache(page, entry);
 	xa_unlock_irq(&address_space->i_pages);
 
 	put_swap_page(page, entry);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 03822f86f288..0448b1b366d9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -753,7 +753,7 @@ static int __remove_mapping(struct address_space *mapping, struct page *page,
 	if (PageSwapCache(page)) {
 		swp_entry_t swap = { .val = page_private(page) };
 		mem_cgroup_swapout(page, swap);
-		__delete_from_swap_cache(page);
+		__delete_from_swap_cache(page, swap);
 		xa_unlock_irqrestore(&mapping->i_pages, flags);
 		put_swap_page(page, swap);
 	} else {
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
