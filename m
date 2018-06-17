From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 29/74] page cache: Convert
 find_get_entries_tag to XArray
Date: Sat, 16 Jun 2018 19:00:07 -0700
Message-ID: <20180617020052.4759-30-willy@infradead.org>
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
 bh=swEIFSIKt2NvfdWOTUWTQV6Qzybb5fYEWm8H1x1L5ac=; b=VTcz0IZgXfImE761b1U9KdKisE
 Hf/X7OI9/d35YhqPqMXN+Af6YBF4A0R8XIJ+IMM4g/Hy1ITxvpQ2t0e0S/bc9c0+6SPmKmvPY9tMF
 BdhtdzgV8O3yiTl+leGqhr+SgjLMKmpb9f2y4exiVLS7lIU/3/zFX0F1S+635cCusPek=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=swEIFSIKt2NvfdWOTUWTQV6Qzybb5fYEWm8H1x1L5ac=; b=YY7L8BCcTR4vReAmeTnkQhBXxD
 PuOgcHuT/VNvebTRbGrUqJmSMKHh2QWSJfrMz9uUQwlv+x+jSPVt/4N911Z7hEyOQSdAQg478KGTl
 QMn4a5E71hEOWtRhRp9QqqQEHL69Ug1k1hU4zES4iebHx13Nkza4dfA7gb8y6RqxLRLk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=swEIFSIKt2NvfdWOTUWTQV6Qzybb5fYEWm8H1x1L5ac=; b=aAQmFyx0cVjTXqtePBlN/Gge1
 6GAqypN2Sd/9jLth3wwwkxuXRtSKKxfGDSJxHjw7XruOko4f2+J0aQEazFxZbT9st3pkFvQLjdS5O
 Uk8iT+UyZGL2vvJgRvMNeJOih+Olkwe0ZNKGxWm42YfgBEXYLL+Ma3PKpwudp432g9+I4RYJqK+Rh
 ShFqf+Mwx7QTpycJl7TivE24r6HwkGfGeKRQP82noTMR4vc4FBRZ7+njOGBaBtiXX9Myku4R08p+7
 jzlcpj59lkspt2+2QvIHBLvky5rchFeVlmSuULPcfE4kugcNx4j+dd/kEeomdvqXgUTOhmgR/EyOe
 4DdD+SVBA==;
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

Slightly shorter and simpler code.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 include/linux/pagemap.h |  2 +-
 mm/filemap.c            | 54 ++++++++++++++++++-----------------------
 2 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index a6d635fefb01..442977811b59 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -373,7 +373,7 @@ static inline unsigned find_get_pages_tag(struct address_space *mapping,
 					nr_pages, pages);
 }
 unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
-			int tag, unsigned int nr_entries,
+			xa_tag_t tag, unsigned int nr_entries,
 			struct page **entries, pgoff_t *indices);
 
 struct page *grab_cache_page_write_begin(struct address_space *mapping,
diff --git a/mm/filemap.c b/mm/filemap.c
index 83328635edaa..67f04bcdf9ef 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1866,57 +1866,51 @@ EXPORT_SYMBOL(find_get_pages_range_tag);
  * @tag.
  */
 unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
-			int tag, unsigned int nr_entries,
+			xa_tag_t tag, unsigned int nr_entries,
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
-	radix_tree_for_each_tagged(slot, &mapping->i_pages, &iter, start, tag) {
-		struct page *head, *page;
-repeat:
-		page = radix_tree_deref_slot(slot);
-		if (unlikely(!page))
+	xas_for_each_tagged(&xas, page, ULONG_MAX, tag) {
+		struct page *head;
+		if (xas_retry(&xas, page))
 			continue;
-		if (radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page)) {
-				slot = radix_tree_iter_retry(&iter);
-				continue;
-			}
-
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
