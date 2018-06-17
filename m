From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 30/74] page cache: Convert filemap_map_pages
 to XArray
Date: Sat, 16 Jun 2018 19:00:08 -0700
Message-ID: <20180617020052.4759-31-willy@infradead.org>
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
 bh=Yeiu2kmNiusFRVYFnSwKz/rR6RSVxilKq9nNpzSrFOE=; b=K9NvW6IVqVxFzIGuBSvFrG/bKi
 5HpxSh76mYtFewNTjUdDsegYa+Db2mtOZKqt7qbmtc8Jdv9YCqheB1fbtcx9rJu6fuPP3fdDLcfgh
 meihcdEkPZF2bW4DJhgdD31P5J0/eLpUAJnG+g9mbDXRLzCgOIgv+tQnXVbNUK3PyYcA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=Yeiu2kmNiusFRVYFnSwKz/rR6RSVxilKq9nNpzSrFOE=; b=Cm+B5rxUVgtJYnfkrFtUAfxK/0
 MnYx4SbEN32BomJEGEXUIGjAM3vnXVV2UN2omOAVEd6KRTyHl7vchRYv97Aj4S+jeobH/gudIF0iB
 /RVv1aicmcB1NaB4eub/Bc7a47tHP4dWllYK6eF0ga7Or5ECVSBONnpSLyp9xMjJyecA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=Yeiu2kmNiusFRVYFnSwKz/rR6RSVxilKq9nNpzSrFOE=; b=m+LOI1px17ZSX5HKevG2D55D6
 WGE20+eKIdSX26zGYKp1NJ6fKmQVz9TeDZYY2DXweQpbJxgCHb3Hi5OE61FnLqgC9mCXy7ziofOeN
 9wrsRmwJGlNfGUUIX6s0jhoqytilmgM4katZytiJIuds+7k9iRJY0mVTVXPc+G9txr3bE2z8iCKPR
 w42OLBaGlBN/PWDF3t3EbBHftT2tyegU/WqWin9w+H/PFRZHu2IFFTXmhaTQ1DIOhMzcU2q4yNL0F
 sqRF1xwdUMq+DK8WxDBpeTFS51/Fu9NqDsrxJA8BmxnEyzJ3C93MWVLru6U1HWrEECsEWSazm8sIQ
 LaP1JPyjg==;
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

Slight change of strategy here; if we have trouble getting hold of a
page for whatever reason (eg a compound page is split underneath us),
don't spin to stabilise the page, just continue the iteration, like we
would if we failed to trylock the page.  Since this is a speculative
optimisation, it feels like we should allow the process to take an extra
fault if it turns out to need this page instead of spending time to pin
down a page it may not need.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/filemap.c | 42 +++++++++++++-----------------------------
 1 file changed, 13 insertions(+), 29 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 67f04bcdf9ef..4204d9df003b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2516,45 +2516,31 @@ EXPORT_SYMBOL(filemap_fault);
 void filemap_map_pages(struct vm_fault *vmf,
 		pgoff_t start_pgoff, pgoff_t end_pgoff)
 {
-	struct radix_tree_iter iter;
-	void **slot;
 	struct file *file = vmf->vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
 	pgoff_t last_pgoff = start_pgoff;
 	unsigned long max_idx;
+	XA_STATE(xas, &mapping->i_pages, start_pgoff);
 	struct page *head, *page;
 
 	rcu_read_lock();
-	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start_pgoff) {
-		if (iter.index > end_pgoff)
-			break;
-repeat:
-		page = radix_tree_deref_slot(slot);
-		if (unlikely(!page))
-			goto next;
-		if (radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page)) {
-				slot = radix_tree_iter_retry(&iter);
-				continue;
-			}
+	xas_for_each(&xas, page, end_pgoff) {
+		if (xas_retry(&xas, page))
+			continue;
+		if (xa_is_value(page))
 			goto next;
-		}
 
 		head = compound_head(page);
 		if (!page_cache_get_speculative(head))
-			goto repeat;
+			goto next;
 
 		/* The page was split under us? */
-		if (compound_head(page) != head) {
-			put_page(head);
-			goto repeat;
-		}
+		if (compound_head(page) != head)
+			goto skip;
 
 		/* Has the page moved? */
-		if (unlikely(page != *slot)) {
-			put_page(head);
-			goto repeat;
-		}
+		if (unlikely(page != xas_reload(&xas)))
+			goto skip;
 
 		if (!PageUptodate(page) ||
 				PageReadahead(page) ||
@@ -2573,10 +2559,10 @@ void filemap_map_pages(struct vm_fault *vmf,
 		if (file->f_ra.mmap_miss > 0)
 			file->f_ra.mmap_miss--;
 
-		vmf->address += (iter.index - last_pgoff) << PAGE_SHIFT;
+		vmf->address += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
 		if (vmf->pte)
-			vmf->pte += iter.index - last_pgoff;
-		last_pgoff = iter.index;
+			vmf->pte += xas.xa_index - last_pgoff;
+		last_pgoff = xas.xa_index;
 		if (alloc_set_pte(vmf, NULL, page))
 			goto unlock;
 		unlock_page(page);
@@ -2589,8 +2575,6 @@ void filemap_map_pages(struct vm_fault *vmf,
 		/* Huge page is mapped? No need to proceed. */
 		if (pmd_trans_huge(*vmf->pmd))
 			break;
-		if (iter.index == end_pgoff)
-			break;
 	}
 	rcu_read_unlock();
 }
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
