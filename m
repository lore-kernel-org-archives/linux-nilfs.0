From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 34/72] mm: Convert page-writeback to XArray
Date: Mon, 11 Jun 2018 07:06:01 -0700
Message-ID: <20180611140639.17215-35-willy@infradead.org>
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
 bh=/3YzULfexGbua07lmlYiArYoDeRyHrcgR7sKjSVOGIM=; b=I1jxc7zt4gTNLH9ZV9875RiOtF
 Vq7fxqDSkRjuhYZqRWqt1Lv+9XsLuSp3XvOi/b49Mi/rvasoYDv+nsdmz1VttdP1RQhcHFNKYHtvz
 jKPzhshPU2HX6SJgOZv7u43ycvDG8uNiF8V+IbR7A9Y6AJ3knnnywuLoPPRgKb82wqGI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=/3YzULfexGbua07lmlYiArYoDeRyHrcgR7sKjSVOGIM=; b=M5XUofaQT5KMkqq4mJvvsgRJjP
 FAhgSqF7qmjSf/z11morwc0EN01b01cuDKlto+h+XQ8B/Glxc71d+LwJ7oYqKbNzhpwFLbkxI11fD
 ICsl49xl9PV+otaaDbJUEcOpDc0ccnM5QuckHcPcdqbjbBNKTn/5Rn+daJYC00iL4tl4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=/3YzULfexGbua07lmlYiArYoDeRyHrcgR7sKjSVOGIM=; b=GbtDHdqZ7IvPUTrvIL7kwS0o2
 ryUEDW/nb+3VvPjFBlEqgUmHn0nwzsRpawlmmVZJEayfEzvfmdl9pgphp2tdhqKYyCTuTLNlZ9ZXw
 IH6DbiEocp+pxaHd49X2BsKI9TEpF6+i7dNeFILwK9nVreW1tE8JLTDLZQJS10iYeCBGw8U4JsXVC
 mTGYw7QX25nlx1r2/+AYu8+8VihPeX57gALAk4i4W74nhtp/QvVcszCJUIwcUYsKdUK8v024JEt1Z
 X4CP2ZLHB0oMMx67/xHCYX/UhTDx6JeW7vRQ1fvp8qm6uoh9Dk6DZ+j3/pQdizujEkixo/zNjqagS
 J+0Epbxig==;
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

Includes moving mapping_tagged() to fs.h as a static inline, and
changing it to return bool.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/fs.h  | 17 ++++++-----
 mm/page-writeback.c | 72 ++++++++++++++++-----------------------------
 2 files changed, 36 insertions(+), 53 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index aec2b05b056f..3f3e717e0d82 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -477,15 +477,18 @@ struct block_device {
 	struct mutex		bd_fsfreeze_mutex;
 } __randomize_layout;
 
+/* XArray tags, for tagging dirty and writeback pages in the pagecache. */
+#define PAGECACHE_TAG_DIRTY	XA_TAG_0
+#define PAGECACHE_TAG_WRITEBACK	XA_TAG_1
+#define PAGECACHE_TAG_TOWRITE	XA_TAG_2
+
 /*
- * Radix-tree tags, for tagging dirty and writeback pages within the pagecache
- * radix trees
+ * Returns true if any of the pages in the mapping are marked with the tag.
  */
-#define PAGECACHE_TAG_DIRTY	0
-#define PAGECACHE_TAG_WRITEBACK	1
-#define PAGECACHE_TAG_TOWRITE	2
-
-int mapping_tagged(struct address_space *mapping, int tag);
+static inline bool mapping_tagged(struct address_space *mapping, xa_tag_t tag)
+{
+	return xa_tagged(&mapping->i_pages, tag);
+}
 
 static inline void i_mmap_lock_write(struct address_space *mapping)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 337c6afb3345..0e502bd13ad9 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2098,34 +2098,25 @@ void __init page_writeback_init(void)
  * dirty pages in the file (thus it is important for this function to be quick
  * so that it can tag pages faster than a dirtying process can create them).
  */
-/*
- * We tag pages in batches of WRITEBACK_TAG_BATCH to reduce the i_pages lock
- * latency.
- */
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end)
 {
-#define WRITEBACK_TAG_BATCH 4096
-	unsigned long tagged = 0;
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->i_pages, start);
+	unsigned int tagged = 0;
+	void *page;
 
-	xa_lock_irq(&mapping->i_pages);
-	radix_tree_for_each_tagged(slot, &mapping->i_pages, &iter, start,
-							PAGECACHE_TAG_DIRTY) {
-		if (iter.index > end)
-			break;
-		radix_tree_iter_tag_set(&mapping->i_pages, &iter,
-							PAGECACHE_TAG_TOWRITE);
-		tagged++;
-		if ((tagged % WRITEBACK_TAG_BATCH) != 0)
+	xas_lock_irq(&xas);
+	xas_for_each_tagged(&xas, page, end, PAGECACHE_TAG_DIRTY) {
+		xas_set_tag(&xas, PAGECACHE_TAG_TOWRITE);
+		if (++tagged % XA_CHECK_SCHED)
 			continue;
-		slot = radix_tree_iter_resume(slot, &iter);
-		xa_unlock_irq(&mapping->i_pages);
+
+		xas_pause(&xas);
+		xas_unlock_irq(&xas);
 		cond_resched();
-		xa_lock_irq(&mapping->i_pages);
+		xas_lock_irq(&xas);
 	}
-	xa_unlock_irq(&mapping->i_pages);
+	xas_unlock_irq(&xas);
 }
 EXPORT_SYMBOL(tag_pages_for_writeback);
 
@@ -2165,7 +2156,7 @@ int write_cache_pages(struct address_space *mapping,
 	pgoff_t done_index;
 	int cycled;
 	int range_whole = 0;
-	int tag;
+	xa_tag_t tag;
 
 	pagevec_init(&pvec);
 	if (wbc->range_cyclic) {
@@ -2446,7 +2437,7 @@ void account_page_cleaned(struct page *page, struct address_space *mapping,
 
 /*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
- * its radix tree.
+ * the xarray.
  *
  * This is also used when a single buffer is being dirtied: we want to set the
  * page dirty in that case, but not all the buffers.  This is a "bottom-up"
@@ -2472,7 +2463,7 @@ int __set_page_dirty_nobuffers(struct page *page)
 		BUG_ON(page_mapping(page) != mapping);
 		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 		account_page_dirtied(page, mapping);
-		radix_tree_tag_set(&mapping->i_pages, page_index(page),
+		__xa_set_tag(&mapping->i_pages, page_index(page),
 				   PAGECACHE_TAG_DIRTY);
 		xa_unlock_irqrestore(&mapping->i_pages, flags);
 		unlock_page_memcg(page);
@@ -2635,13 +2626,13 @@ EXPORT_SYMBOL(__cancel_dirty_page);
  * Returns true if the page was previously dirty.
  *
  * This is for preparing to put the page under writeout.  We leave the page
- * tagged as dirty in the radix tree so that a concurrent write-for-sync
+ * tagged as dirty in the xarray so that a concurrent write-for-sync
  * can discover it via a PAGECACHE_TAG_DIRTY walk.  The ->writepage
  * implementation will run either set_page_writeback() or set_page_dirty(),
- * at which stage we bring the page's dirty flag and radix-tree dirty tag
+ * at which stage we bring the page's dirty flag and xarray dirty tag
  * back into sync.
  *
- * This incoherency between the page's dirty flag and radix-tree tag is
+ * This incoherency between the page's dirty flag and xarray tag is
  * unfortunate, but it only exists while the page is locked.
  */
 int clear_page_dirty_for_io(struct page *page)
@@ -2722,7 +2713,7 @@ int test_clear_page_writeback(struct page *page)
 		xa_lock_irqsave(&mapping->i_pages, flags);
 		ret = TestClearPageWriteback(page);
 		if (ret) {
-			radix_tree_tag_clear(&mapping->i_pages, page_index(page),
+			__xa_clear_tag(&mapping->i_pages, page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi)) {
 				struct bdi_writeback *wb = inode_to_wb(inode);
@@ -2762,11 +2753,13 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 
 	lock_page_memcg(page);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
+		XA_STATE(xas, &mapping->i_pages, page_index(page));
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
 		unsigned long flags;
 
-		xa_lock_irqsave(&mapping->i_pages, flags);
+		xas_lock_irqsave(&xas, flags);
+		xas_load(&xas);
 		ret = TestSetPageWriteback(page);
 		if (!ret) {
 			bool on_wblist;
@@ -2774,8 +2767,7 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 			on_wblist = mapping_tagged(mapping,
 						   PAGECACHE_TAG_WRITEBACK);
 
-			radix_tree_tag_set(&mapping->i_pages, page_index(page),
-						PAGECACHE_TAG_WRITEBACK);
+			xas_set_tag(&xas, PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi))
 				inc_wb_stat(inode_to_wb(inode), WB_WRITEBACK);
 
@@ -2788,12 +2780,10 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 				sb_mark_inode_writeback(mapping->host);
 		}
 		if (!PageDirty(page))
-			radix_tree_tag_clear(&mapping->i_pages, page_index(page),
-						PAGECACHE_TAG_DIRTY);
+			xas_clear_tag(&xas, PAGECACHE_TAG_DIRTY);
 		if (!keep_write)
-			radix_tree_tag_clear(&mapping->i_pages, page_index(page),
-						PAGECACHE_TAG_TOWRITE);
-		xa_unlock_irqrestore(&mapping->i_pages, flags);
+			xas_clear_tag(&xas, PAGECACHE_TAG_TOWRITE);
+		xas_unlock_irqrestore(&xas, flags);
 	} else {
 		ret = TestSetPageWriteback(page);
 	}
@@ -2807,16 +2797,6 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 }
 EXPORT_SYMBOL(__test_set_page_writeback);
 
-/*
- * Return true if any of the pages in the mapping are marked with the
- * passed tag.
- */
-int mapping_tagged(struct address_space *mapping, int tag)
-{
-	return radix_tree_tagged(&mapping->i_pages, tag);
-}
-EXPORT_SYMBOL(mapping_tagged);
-
 /**
  * wait_for_stable_page() - wait for writeback to finish, if necessary.
  * @page:	The page to wait on.
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
