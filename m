From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 49/62] nilfs2: Convert to XArray
Date: Thu, 29 Mar 2018 20:42:32 -0700
Message-ID: <20180330034245.10462-50-willy@infradead.org>
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
 bh=ikkfEm3LEacfpUtZXFlqd5hvGaJPGtzhapOyST9TBSY=; b=d1N8relBItSYxeveTl+lZGpGTd
 mVg9l+JEPwvwxuqMoYLepZpPU1x005KzZ74V8jw/6Ruh/3jQUOEOc/HZCrxfS/UPffuAKocNiTQiD
 lkByjtmB1jXxpCkIqAaPERkJY7Z86wIontTSLOK24qH+cJcU1lr+JJtF3bSFJGWGq8To=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ikkfEm3LEacfpUtZXFlqd5hvGaJPGtzhapOyST9TBSY=; b=nGGw05yARoPYgQBLgQKM6HbA7p
 3m+zhiMnaEKL3Oyco8schdhZXS7cMH0tntjgxrd7Jz8p8I7TqAAKH+aoCWX+cEx//zu5P1qV3HORK
 5lBewHg4a67UTX5OnlDKkQ9KGj3xxtybNgGJiby1VcbxwHk24qbd0iv+lJDyV0zeg75U=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ikkfEm3LEacfpUtZXFlqd5hvGaJPGtzhapOyST9TBSY=; b=GCF7FrnueofyAWGnCgjAfbdsn
 polQQFNrUXdP+fgcpuT729vhl59q7nhQSMrXyq0EHpf5HUOpdCiCI72wNgDoJxfh3oBfviAxtObSC
 CNIuzJLvtSjHH09DzRC+g8oRiSBJyGEtE1pXKYRQ2iAeZU/gSd8Isi2yJdrq4P4p/PZfXAM1s6QBS
 HpJ1DU4z4BKli6eFBapzZBZvtsgLX0bZah1W+Wja04QDJJgQ8XGgRlaC9JF3pUlbvthoDktjpd7uR
 o6EmXvjUCoFTkECwjawmusWf/6oTHdLlGI/OVjIRhlEAXhHXJhBMdFnQJpFJw8KdgENdrT2LkWcoS
 ss1xuU20A==;
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

I'm not 100% convinced that the rewrite of nilfs_copy_back_pages is
correct, but it will at least have different bugs from the current
version.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/nilfs2/btnode.c | 37 +++++++++++-----------------
 fs/nilfs2/page.c   | 72 +++++++++++++++++++++++++++++++-----------------------
 2 files changed, 56 insertions(+), 53 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index dec98cab729d..68797603bc08 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -177,42 +177,36 @@ int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 	ctxt->newbh = NULL;
 
 	if (inode->i_blkbits == PAGE_SHIFT) {
-		lock_page(obh->b_page);
-		/*
-		 * We cannot call radix_tree_preload for the kernels older
-		 * than 2.6.23, because it is not exported for modules.
-		 */
+		void *entry;
+		struct page *opage = obh->b_page;
+		lock_page(opage);
 retry:
-		err = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
-		if (err)
-			goto failed_unlock;
 		/* BUG_ON(oldkey != obh->b_page->index); */
-		if (unlikely(oldkey != obh->b_page->index))
-			NILFS_PAGE_BUG(obh->b_page,
+		if (unlikely(oldkey != opage->index))
+			NILFS_PAGE_BUG(opage,
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
 
-		xa_lock_irq(&btnc->i_pages);
-		err = radix_tree_insert(&btnc->i_pages, newkey, obh->b_page);
-		xa_unlock_irq(&btnc->i_pages);
+		entry = xa_cmpxchg(&btnc->i_pages, newkey, NULL, opage, GFP_NOFS);
 		/*
 		 * Note: page->index will not change to newkey until
 		 * nilfs_btnode_commit_change_key() will be called.
 		 * To protect the page in intermediate state, the page lock
 		 * is held.
 		 */
-		radix_tree_preload_end();
-		if (!err)
+		if (!entry)
 			return 0;
-		else if (err != -EEXIST)
+		if (xa_is_err(entry)) {
+			err = xa_err(entry);
 			goto failed_unlock;
+		}
 
 		err = invalidate_inode_pages2_range(btnc, newkey, newkey);
 		if (!err)
 			goto retry;
 		/* fallback to copy mode */
-		unlock_page(obh->b_page);
+		unlock_page(opage);
 	}
 
 	nbh = nilfs_btnode_create_block(btnc, newkey);
@@ -252,9 +246,8 @@ void nilfs_btnode_commit_change_key(struct address_space *btnc,
 		mark_buffer_dirty(obh);
 
 		xa_lock_irq(&btnc->i_pages);
-		radix_tree_delete(&btnc->i_pages, oldkey);
-		radix_tree_tag_set(&btnc->i_pages, newkey,
-				   PAGECACHE_TAG_DIRTY);
+		__xa_erase(&btnc->i_pages, oldkey);
+		__xa_set_tag(&btnc->i_pages, newkey, PAGECACHE_TAG_DIRTY);
 		xa_unlock_irq(&btnc->i_pages);
 
 		opage->index = obh->b_blocknr = newkey;
@@ -283,9 +276,7 @@ void nilfs_btnode_abort_change_key(struct address_space *btnc,
 		return;
 
 	if (nbh == NULL) {	/* blocksize == pagesize */
-		xa_lock_irq(&btnc->i_pages);
-		radix_tree_delete(&btnc->i_pages, newkey);
-		xa_unlock_irq(&btnc->i_pages);
+		xa_erase(&btnc->i_pages, newkey);
 		unlock_page(ctxt->bh->b_page);
 	} else
 		brelse(nbh);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 4cb850a6f1c2..a3995406d5d3 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -304,10 +304,10 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 void nilfs_copy_back_pages(struct address_space *dmap,
 			   struct address_space *smap)
 {
+	XA_STATE(xas, &dmap->i_pages, 0);
 	struct pagevec pvec;
 	unsigned int i, n;
 	pgoff_t index = 0;
-	int err;
 
 	pagevec_init(&pvec);
 repeat:
@@ -317,43 +317,56 @@ void nilfs_copy_back_pages(struct address_space *dmap,
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
 		struct page *page = pvec.pages[i], *dpage;
-		pgoff_t offset = page->index;
+		xas_set(&xas, page->index);
 
 		lock_page(page);
-		dpage = find_lock_page(dmap, offset);
+		do {
+			xas_lock_irq(&xas);
+			dpage = xas_create(&xas);
+			if (!xas_error(&xas))
+				break;
+			xas_unlock_irq(&xas);
+			if (!xas_nomem(&xas, GFP_NOFS)) {
+				unlock_page(page);
+				/*
+				 * Callers have a touching faith that this
+				 * function cannot fail.  Just leak the page.
+				 * Other pages may be salvagable if the
+				 * xarray doesn't need to allocate memory
+				 * to store them.
+				 */
+				WARN_ON(1);
+				page->mapping = NULL;
+				put_page(page);
+				goto shadow_remove;
+			}
+		} while (1);
+
 		if (dpage) {
-			/* override existing page on the destination cache */
+			get_page(dpage);
+			xas_unlock_irq(&xas);
+			lock_page(dpage);
+			/* override existing page in the destination cache */
 			WARN_ON(PageDirty(dpage));
 			nilfs_copy_page(dpage, page, 0);
 			unlock_page(dpage);
 			put_page(dpage);
 		} else {
-			struct page *page2;
-
-			/* move the page to the destination cache */
-			xa_lock_irq(&smap->i_pages);
-			page2 = radix_tree_delete(&smap->i_pages, offset);
-			WARN_ON(page2 != page);
-
-			smap->nrpages--;
-			xa_unlock_irq(&smap->i_pages);
-
-			xa_lock_irq(&dmap->i_pages);
-			err = radix_tree_insert(&dmap->i_pages, offset, page);
-			if (unlikely(err < 0)) {
-				WARN_ON(err == -EEXIST);
-				page->mapping = NULL;
-				put_page(page); /* for cache */
-			} else {
-				page->mapping = dmap;
-				dmap->nrpages++;
-				if (PageDirty(page))
-					radix_tree_tag_set(&dmap->i_pages,
-							   offset,
-							   PAGECACHE_TAG_DIRTY);
-			}
+			xas_store(&xas, page);
+			page->mapping = dmap;
+			dmap->nrpages++;
+			if (PageDirty(page))
+				xas_set_tag(&xas, PAGECACHE_TAG_DIRTY);
 			xa_unlock_irq(&dmap->i_pages);
 		}
+
+shadow_remove:
+		/* remove the page from the shadow cache */
+		xa_lock_irq(&smap->i_pages);
+		WARN_ON(__xa_erase(&smap->i_pages, xas.xa_index) != page);
+		smap->nrpages--;
+		xa_unlock_irq(&smap->i_pages);
+
 		unlock_page(page);
 	}
 	pagevec_release(&pvec);
@@ -476,8 +489,7 @@ int __nilfs_clear_page_dirty(struct page *page)
 	if (mapping) {
 		xa_lock_irq(&mapping->i_pages);
 		if (test_bit(PG_dirty, &page->flags)) {
-			radix_tree_tag_clear(&mapping->i_pages,
-					     page_index(page),
+			__xa_clear_tag(&mapping->i_pages, page_index(page),
 					     PAGECACHE_TAG_DIRTY);
 			xa_unlock_irq(&mapping->i_pages);
 			return clear_page_dirty_for_io(page);
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
