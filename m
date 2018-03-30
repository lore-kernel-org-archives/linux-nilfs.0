From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 29/62] mm: Convert delete_from_swap_cache to
 XArray
Date: Thu, 29 Mar 2018 20:42:12 -0700
Message-ID: <20180330034245.10462-30-willy@infradead.org>
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
 bh=yiBn0tT0UQvJ7uhJeijnbSC2sFGtLQUouSdfdEjM7cM=; b=I8kHik6kqSqN7gx7/05XXnT0KL
 D4IKe2pNR3CVnGoWaiNhpBdO3FZc6rgbYj/O7hBIpas9BAs2+Wxf/yxU/Ng64e42b0N4jzdg2F/xw
 98vekebi4iZTH8yY17V8WB2hpUmEMHu87q22nrWkI/qPvuWmkrH37TqAyK0bELyJvHb0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=yiBn0tT0UQvJ7uhJeijnbSC2sFGtLQUouSdfdEjM7cM=; b=HbiEx66dZDe+XKig7P6HodleVn
 RZGsI8ladKIQ92ImEDrr9kzg1IKX5fkeeeCZhI8qZBWVMqnMEQmeOUTmKwbaFMV0jp5a7IY+EE+5P
 EOJjvHcJiFg4ASwDuawBf3pmM6Z6wx35qsVnrmv9RBDoXzbXj6MXRmkUYauC1khxB1eg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=yiBn0tT0UQvJ7uhJeijnbSC2sFGtLQUouSdfdEjM7cM=; b=dRX35DrHOEvMGTr/WURybIvFG
 fInjkJhlymJDnLair4E34VBuP2ofRPlZo3tep9iz71JCIfj2zobiPM6Ue+w+zmd2X3u2NyT+Ss63H
 jAUeBCqp30IeabXKsf/6zqW2g0EF4UF/ee0X6LHKvaACWHh6GryD7cKlQdRjw3PQ8DFChyBSUlPdw
 MfX4Abj+BK+HQDunoa4Ufhy5QGCVdm4BUZutD/mUN9/lsNpgZHIJeX6qLQlVq7SLaIsVG/pDWyB+r
 7gPe3TM5oeeZ7C5X5q93pWLA6QnYnwAyCxu7lD6o4eoSXrfkW6Usm52GgJKpQ32M4lSKYgTa1+unS
 gEKTsbqQQ==;
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

Both callers of __delete_from_swap_cache have the swp_entry_t already,
so pass that in to make constructing the XA_STATE easier.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/swap.h |  5 +++--
 mm/swap_state.c      | 24 ++++++++++--------------
 mm/vmscan.c          |  2 +-
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index dab96af23d96..0b6a47a46c55 100644
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
index 53e27894c1bc..a0a562fbc65f 100644
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
@@ -246,14 +245,11 @@ int add_to_swap(struct page *page)
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
index 4e57f97c579b..e42d3fdb38fe 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -721,7 +721,7 @@ static int __remove_mapping(struct address_space *mapping, struct page *page,
 	if (PageSwapCache(page)) {
 		swp_entry_t swap = { .val = page_private(page) };
 		mem_cgroup_swapout(page, swap);
-		__delete_from_swap_cache(page);
+		__delete_from_swap_cache(page, swap);
 		xa_unlock_irqrestore(&mapping->i_pages, flags);
 		put_swap_page(page, swap);
 	} else {
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
