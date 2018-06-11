From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 23/72] page cache: Convert find_get_entry to
 XArray
Date: Mon, 11 Jun 2018 07:05:50 -0700
Message-ID: <20180611140639.17215-24-willy@infradead.org>
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
 bh=t6zM/qfm33anwBHTDJRDqef1HwwyX7RB48+ecTyMpRE=; b=SojS/+B8RkFnL8O7aOotTWKN5X
 MTt29MotQCx1TSuONAS54c9/QDyc0BQZTu3GYTMRmBRuXLJkcOOD1AmVUiWYFj9GYtJAb5FRdYSvM
 vAbxmzWu0JA4//7cg38WD9vRNHAYNHTx5O8ZdQkCFjapg1dtJBsmkz8El2iz1fPdRhs4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=t6zM/qfm33anwBHTDJRDqef1HwwyX7RB48+ecTyMpRE=; b=RMGIVVwwC8NYuKuW6jXqQ/D513
 EKgfLtVTPONlxYP2AMW6cHtCrPlxE5DRhjie41Ca1Tf5rrU9XulL7aMrvqNXchrmB74xNt2fBWTMj
 AHr2lqQSTaVaEozkiYMYF517rIzkbLy1Bln+tcv5ncFGD8Z9N1dExDZu5SZmr+X9TSrU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=t6zM/qfm33anwBHTDJRDqef1HwwyX7RB48+ecTyMpRE=; b=FnvKd5k0mRY3tpyDxpW8zkaxy
 Qksjm/1NbQtSQqwZvTLuPVg1DPG0IrxfxWhP6XSrUPD1nW+Ie06qfuhi5qeaUQ6fHRtS/gapSRDJt
 J0L8eNUc0ykFt/OxWaMKcJBLKTZU92R9+qWZlgSkpHd5qnviQBFdlXP6JvLdDCNpv+s4rwhU+XGMf
 m1I4rA+CccFm6egoeLNhJxcSJTq/yI1LV4uB9vKabAbahlyhMKBoiqjbKOQH2Dk5b17WY0Op8rxPG
 LP4Qy3PO5A9uGvrp7rUDfDnzVC/5XDEa34VrqjiOfaVIXeQVgcaEFaGevDcUhuIwTCjSY0EKa4wpY
 ivUTAjmiA==;
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
 mm/filemap.c | 63 +++++++++++++++++++++++-----------------------------
 1 file changed, 28 insertions(+), 35 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 7cdb1d4b8117..6db3d35ff5f6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1382,47 +1382,40 @@ EXPORT_SYMBOL(page_cache_prev_gap);
  */
 struct page *find_get_entry(struct address_space *mapping, pgoff_t offset)
 {
-	void **pagep;
+	XA_STATE(xas, &mapping->i_pages, offset);
 	struct page *head, *page;
 
 	rcu_read_lock();
 repeat:
-	page = NULL;
-	pagep = radix_tree_lookup_slot(&mapping->i_pages, offset);
-	if (pagep) {
-		page = radix_tree_deref_slot(pagep);
-		if (unlikely(!page))
-			goto out;
-		if (radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page))
-				goto repeat;
-			/*
-			 * A shadow entry of a recently evicted page,
-			 * or a swap entry from shmem/tmpfs.  Return
-			 * it without attempting to raise page count.
-			 */
-			goto out;
-		}
+	xas_reset(&xas);
+	page = xas_load(&xas);
+	if (xas_retry(&xas, page))
+		goto repeat;
+	/*
+	 * A shadow entry of a recently evicted page, or a swap entry from
+	 * shmem/tmpfs.  Return it without attempting to raise page count.
+	 */
+	if (!page || xa_is_value(page))
+		goto out;
 
-		head = compound_head(page);
-		if (!page_cache_get_speculative(head))
-			goto repeat;
+	head = compound_head(page);
+	if (!page_cache_get_speculative(head))
+		goto repeat;
 
-		/* The page was split under us? */
-		if (compound_head(page) != head) {
-			put_page(head);
-			goto repeat;
-		}
+	/* The page was split under us? */
+	if (compound_head(page) != head) {
+		put_page(head);
+		goto repeat;
+	}
 
-		/*
-		 * Has the page moved?
-		 * This is part of the lockless pagecache protocol. See
-		 * include/linux/pagemap.h for details.
-		 */
-		if (unlikely(page != *pagep)) {
-			put_page(head);
-			goto repeat;
-		}
+	/*
+	 * Has the page moved?
+	 * This is part of the lockless pagecache protocol. See
+	 * include/linux/pagemap.h for details.
+	 */
+	if (unlikely(page != xas_reload(&xas))) {
+		put_page(head);
+		goto repeat;
 	}
 out:
 	rcu_read_unlock();
@@ -1453,7 +1446,7 @@ struct page *find_lock_entry(struct address_space *mapping, pgoff_t offset)
 
 repeat:
 	page = find_get_entry(mapping, offset);
-	if (page && !radix_tree_exception(page)) {
+	if (page && !xa_is_value(page)) {
 		lock_page(page);
 		/* Has the page been truncated? */
 		if (unlikely(page_mapping(page) != mapping)) {
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
