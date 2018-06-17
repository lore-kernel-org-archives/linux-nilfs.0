From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 67/74] dax: Convert dax writeback to XArray
Date: Sat, 16 Jun 2018 19:00:45 -0700
Message-ID: <20180617020052.4759-68-willy@infradead.org>
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
 bh=uEhl2GVsZi2AzucrCrWLvoJ15vil7guXqBgRqe3hcQw=; b=X+Pr3gQma94TSzrc4NskVZDNnQ
 TrIE96IwnPy5APbjbTMA2q8qrqOtdq3EiKOU5457bhPkEbQE92s7zbmZNocENA/r2XOPTnGMAFx2r
 oNrTBvbx+aGjLMuxVSHcxeqdU9UppEAntaMLZcpLz277K/Uqs6segaOgEFUh0kJwrEZ0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=uEhl2GVsZi2AzucrCrWLvoJ15vil7guXqBgRqe3hcQw=; b=e527nVB7dyNkOVU1Yskq2LfNM8
 xd7tReS9wY97QjJ0kdYzF6frpMxapDIwOY4Kc2olGWA0TNq4NLlYiimzyIeMjd9jcLZXJjZxlOR99
 Si9DT8zyybmf9KLyS6uRbLf+Aq6Noyrd0O308ql+9uf80SyS2nSXU1huoAdecTxi/8cU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=uEhl2GVsZi2AzucrCrWLvoJ15vil7guXqBgRqe3hcQw=; b=T/bJ9W1gtAk//W2f7MmM28AhU
 sjdfVR8H1y2NHYYaEH5hrHoT4+mhVwCVsL8N8RVGaZTawVWRPkr4ZllO8GOAVnM/yt+r2c22VCttQ
 3Z+866SAC5WLAwzRCVZ/Sh7RydLOqbIU7nfGHaDOGCRmBYNl4tV2HSMAQmmGJsNjjdjYKgdfRdqFA
 XRrOfcGjPxzrvMKRVAFwjPApVCAXYCugxmVEfZZ8IsVQAmuu/eBpkgjDSBhIsxMbnGkCjtR7STxtf
 ImtM9h3509LsWMV5DTkROh2mysY7SU9/RsUfqtgUe0ZwuPZiepclyfySo2Hv4pae9ZsOKnXa1Q7bG
 qKe6w6/Fg==;
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

Use XArray iteration instead of a pagevec.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 fs/dax.c | 130 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 62 insertions(+), 68 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index fe5cc4470d99..08595ffde566 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -973,11 +973,9 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
 	i_mmap_unlock_read(mapping);
 }
 
-static int dax_writeback_one(struct dax_device *dax_dev,
-		struct address_space *mapping, pgoff_t index, void *entry)
+static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
+		struct address_space *mapping, void *entry)
 {
-	struct radix_tree_root *pages = &mapping->i_pages;
-	void *entry2, **slot;
 	unsigned long pfn;
 	long ret = 0;
 	size_t size;
@@ -989,29 +987,35 @@ static int dax_writeback_one(struct dax_device *dax_dev,
 	if (WARN_ON(!xa_is_value(entry)))
 		return -EIO;
 
-	xa_lock_irq(pages);
-	entry2 = get_unlocked_mapping_entry(mapping, index, &slot);
-	/* Entry got punched out / reallocated? */
-	if (!entry2 || WARN_ON_ONCE(!xa_is_value(entry2)))
-		goto put_unlocked;
-	/*
-	 * Entry got reallocated elsewhere? No need to writeback. We have to
-	 * compare pfns as we must not bail out due to difference in lockbit
-	 * or entry type.
-	 */
-	if (dax_to_pfn(entry2) != dax_to_pfn(entry))
-		goto put_unlocked;
-	if (WARN_ON_ONCE(dax_is_empty_entry(entry) ||
-				dax_is_zero_entry(entry))) {
-		ret = -EIO;
-		goto put_unlocked;
+	if (unlikely(dax_is_locked(entry))) {
+		void *old_entry = entry;
+
+		entry = get_unlocked_entry(xas);
+
+		/* Entry got punched out / reallocated? */
+		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
+			goto put_unlocked;
+		/*
+		 * Entry got reallocated elsewhere? No need to writeback.
+		 * We have to compare pfns as we must not bail out due to
+		 * difference in lockbit or entry type.
+		 */
+		if (dax_to_pfn(old_entry) != dax_to_pfn(entry))
+			goto put_unlocked;
+		if (WARN_ON_ONCE(dax_is_empty_entry(entry) ||
+					dax_is_zero_entry(entry))) {
+			ret = -EIO;
+			goto put_unlocked;
+		}
+
+		/* Another fsync thread may have already done this entry */
+		if (!xas_get_tag(xas, PAGECACHE_TAG_TOWRITE))
+			goto put_unlocked;
 	}
 
-	/* Another fsync thread may have already written back this entry */
-	if (!radix_tree_tag_get(pages, index, PAGECACHE_TAG_TOWRITE))
-		goto put_unlocked;
 	/* Lock the entry to serialize with page faults */
-	entry = lock_slot(mapping, slot);
+	dax_lock_entry(xas, entry);
+
 	/*
 	 * We can clear the tag now but we have to be careful so that concurrent
 	 * dax_writeback_one() calls for the same index cannot finish before we
@@ -1019,8 +1023,8 @@ static int dax_writeback_one(struct dax_device *dax_dev,
 	 * at the entry only under the i_pages lock and once they do that
 	 * they will see the entry locked and wait for it to unlock.
 	 */
-	radix_tree_tag_clear(pages, index, PAGECACHE_TAG_TOWRITE);
-	xa_unlock_irq(pages);
+	xas_clear_tag(xas, PAGECACHE_TAG_TOWRITE);
+	xas_unlock_irq(xas);
 
 	/*
 	 * Even if dax_writeback_mapping_range() was given a wbc->range_start
@@ -1032,7 +1036,7 @@ static int dax_writeback_one(struct dax_device *dax_dev,
 	pfn = dax_to_pfn(entry);
 	size = PAGE_SIZE << dax_entry_order(entry);
 
-	dax_entry_mkclean(mapping, index, pfn);
+	dax_entry_mkclean(mapping, xas->xa_index, pfn);
 	dax_flush(dax_dev, page_address(pfn_to_page(pfn)), size);
 	/*
 	 * After we have flushed the cache, we can clear the dirty tag. There
@@ -1040,16 +1044,18 @@ static int dax_writeback_one(struct dax_device *dax_dev,
 	 * the pfn mappings are writeprotected and fault waits for mapping
 	 * entry lock.
 	 */
-	xa_lock_irq(pages);
-	radix_tree_tag_clear(pages, index, PAGECACHE_TAG_DIRTY);
-	xa_unlock_irq(pages);
-	trace_dax_writeback_one(mapping->host, index, size >> PAGE_SHIFT);
-	put_locked_mapping_entry(mapping, index);
+	xas_reset(xas);
+	xas_lock_irq(xas);
+	xas_store(xas, entry);
+	xas_clear_tag(xas, PAGECACHE_TAG_DIRTY);
+	dax_wake_entry(xas, entry, false);
+
+	trace_dax_writeback_one(mapping->host, xas->xa_index,
+			size >> PAGE_SHIFT);
 	return ret;
 
  put_unlocked:
-	put_unlocked_mapping_entry(mapping, index, entry2);
-	xa_unlock_irq(pages);
+	put_unlocked_entry(xas, entry);
 	return ret;
 }
 
@@ -1061,13 +1067,13 @@ static int dax_writeback_one(struct dax_device *dax_dev,
 int dax_writeback_mapping_range(struct address_space *mapping,
 		struct block_device *bdev, struct writeback_control *wbc)
 {
+	XA_STATE(xas, &mapping->i_pages, wbc->range_start >> PAGE_SHIFT);
 	struct inode *inode = mapping->host;
-	pgoff_t start_index, end_index;
-	pgoff_t indices[PAGEVEC_SIZE];
+	pgoff_t end_index = wbc->range_end >> PAGE_SHIFT;
 	struct dax_device *dax_dev;
-	struct pagevec pvec;
-	bool done = false;
-	int i, ret = 0;
+	void *entry;
+	int ret = 0;
+	unsigned int scanned = 0;
 
 	if (WARN_ON_ONCE(inode->i_blkbits != PAGE_SHIFT))
 		return -EIO;
@@ -1079,41 +1085,29 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 	if (!dax_dev)
 		return -EIO;
 
-	start_index = wbc->range_start >> PAGE_SHIFT;
-	end_index = wbc->range_end >> PAGE_SHIFT;
-
-	trace_dax_writeback_range(inode, start_index, end_index);
-
-	tag_pages_for_writeback(mapping, start_index, end_index);
+	trace_dax_writeback_range(inode, xas.xa_index, end_index);
 
-	pagevec_init(&pvec);
-	while (!done) {
-		pvec.nr = find_get_entries_tag(mapping, start_index,
-				PAGECACHE_TAG_TOWRITE, PAGEVEC_SIZE,
-				pvec.pages, indices);
+	tag_pages_for_writeback(mapping, xas.xa_index, end_index);
 
-		if (pvec.nr == 0)
+	xas_lock_irq(&xas);
+	xas_for_each_tagged(&xas, entry, end_index, PAGECACHE_TAG_TOWRITE) {
+		ret = dax_writeback_one(&xas, dax_dev, mapping, entry);
+		if (ret < 0) {
+			mapping_set_error(mapping, ret);
 			break;
-
-		for (i = 0; i < pvec.nr; i++) {
-			if (indices[i] > end_index) {
-				done = true;
-				break;
-			}
-
-			ret = dax_writeback_one(dax_dev, mapping, indices[i],
-					pvec.pages[i]);
-			if (ret < 0) {
-				mapping_set_error(mapping, ret);
-				goto out;
-			}
 		}
-		start_index = indices[pvec.nr - 1] + 1;
+		if (++scanned % XA_CHECK_SCHED)
+			continue;
+
+		xas_pause(&xas);
+		xas_unlock_irq(&xas);
+		cond_resched();
+		xas_lock_irq(&xas);
 	}
-out:
+	xas_unlock_irq(&xas);
 	put_dax(dax_dev);
-	trace_dax_writeback_range_done(inode, start_index, end_index);
-	return (ret < 0 ? ret : 0);
+	trace_dax_writeback_range_done(inode, xas.xa_index, end_index);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
