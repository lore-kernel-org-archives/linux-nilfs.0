From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 46/72] shmem: Convert
 shmem_radix_tree_replace to XArray
Date: Mon, 11 Jun 2018 07:06:13 -0700
Message-ID: <20180611140639.17215-47-willy@infradead.org>
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
 bh=p6NnmI89u0sq1FU15L+NpkGefGHhKJMhHQetKgwT18I=; b=GY5lIbreDnsruZs+zJseoYMGrM
 6QGSoMdp80KOcpcojs3NYw2gd0eM5EbF8OQR4c5FgTsdZC6pwDyrwSKiTsmN7wk6IvDWqj4MCYDwE
 1mj2iwLm2Vr5LPothHsAIXCE6veQn/P4GbqEgg/6e2fi6dppUVyt07jSfJc3d+VfB+Ys=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=p6NnmI89u0sq1FU15L+NpkGefGHhKJMhHQetKgwT18I=; b=NyiL2Hz3fBwbFQ+q18LTICs5PD
 PnCRccKXKxGpTL+9rR6f8ErVMx4e2Z+O8aus/P/3oQiDahAwM5uGqV5cupMfItAO+Dijl6ZXyN8kH
 iEJPfThww9ub341AfcMoy5efq46oweptpjeZHYY9zCKU8BY9VGDFzRjyKrr3a+RzVB+M=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=p6NnmI89u0sq1FU15L+NpkGefGHhKJMhHQetKgwT18I=; b=K9IZIManm8qnl8VgceF/LH0sE
 /TEB0rGfI7w/GjS50xYkL8QnUx/M1GRU+kQhbvu8pFpQm9Rvf2P/bl5U4stjs0x9T0PV3qPqcEt1U
 yPEqiURARaAtIWWiGU1uICNlSofinMRaghWmX5dUXrOl+iaivI83KdlY91+vF9IHaF9D8JuH3o8vE
 IwL8gKdyjIBfDdNaT5Z3nuBWbm3WIl8kAb0s/qTvhG+oL9rIr8Npn6v4QHUtlmDFIn/av8UlMx8z/
 0pbQuqo2lLrba0JnCGBz0D/ULrmR74/IvSfhkXhtulXLLeJZzGNXGTdfzW0gG3RfkpH3cMm3fHQ2X
 noVVn9ktQ==;
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

Rename shmem_radix_tree_replace() to shmem_replace_entry() and
convert it to use the XArray API.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b03ede3515c..2b8720d32e7a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -321,24 +321,20 @@ void shmem_uncharge(struct inode *inode, long pages)
 }
 
 /*
- * Replace item expected in radix tree by a new item, while holding tree lock.
+ * Replace item expected in xarray by a new item, while holding xa_lock.
  */
-static int shmem_radix_tree_replace(struct address_space *mapping,
+static int shmem_replace_entry(struct address_space *mapping,
 			pgoff_t index, void *expected, void *replacement)
 {
-	struct radix_tree_node *node;
-	void __rcu **pslot;
+	XA_STATE(xas, &mapping->i_pages, index);
 	void *item;
 
 	VM_BUG_ON(!expected);
 	VM_BUG_ON(!replacement);
-	item = __radix_tree_lookup(&mapping->i_pages, index, &node, &pslot);
-	if (!item)
-		return -ENOENT;
+	item = xas_load(&xas);
 	if (item != expected)
 		return -ENOENT;
-	__radix_tree_replace(&mapping->i_pages, node, pslot,
-			     replacement, NULL);
+	xas_store(&xas, replacement);
 	return 0;
 }
 
@@ -623,8 +619,7 @@ static int shmem_add_to_page_cache(struct page *page,
 	} else if (!expected) {
 		error = radix_tree_insert(&mapping->i_pages, index, page);
 	} else {
-		error = shmem_radix_tree_replace(mapping, index, expected,
-								 page);
+		error = shmem_replace_entry(mapping, index, expected, page);
 	}
 
 	if (!error) {
@@ -653,7 +648,7 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 	VM_BUG_ON_PAGE(PageCompound(page), page);
 
 	xa_lock_irq(&mapping->i_pages);
-	error = shmem_radix_tree_replace(mapping, page->index, page, radswap);
+	error = shmem_replace_entry(mapping, page->index, page, radswap);
 	page->mapping = NULL;
 	mapping->nrpages--;
 	__dec_node_page_state(page, NR_FILE_PAGES);
@@ -1577,8 +1572,7 @@ static int shmem_replace_page(struct page **pagep, gfp_t gfp,
 	 * a nice clean interface for us to replace oldpage by newpage there.
 	 */
 	xa_lock_irq(&swap_mapping->i_pages);
-	error = shmem_radix_tree_replace(swap_mapping, swap_index, oldpage,
-								   newpage);
+	error = shmem_replace_entry(swap_mapping, swap_index, oldpage, newpage);
 	if (!error) {
 		__inc_node_page_state(newpage, NR_FILE_PAGES);
 		__dec_node_page_state(oldpage, NR_FILE_PAGES);
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
