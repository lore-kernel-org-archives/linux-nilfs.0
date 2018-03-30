From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 20/62] page cache: Convert page deletion to
 XArray
Date: Thu, 29 Mar 2018 20:42:03 -0700
Message-ID: <20180330034245.10462-21-willy@infradead.org>
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
 bh=XZT1ZXMHbQwVX1NX6/t0S1MNa7GhuGeZMNMbI0p4suQ=; b=iQ3z7fLR+pvyZRb47U5Ki/j02Y
 yk+uGVeSMebLYwVyWG2m83ucQ6akB+UlY4hpV9BBz3Mf/YZdqZiJQaeMo4NCMAa3YTVJe+mvI6eGn
 DUSWoRDOkiv9xJb3thx5Ka9FEWptNK2gfhSCP0a18Vti+J/k7fZC7y7sa2DWwdXh0TtI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=XZT1ZXMHbQwVX1NX6/t0S1MNa7GhuGeZMNMbI0p4suQ=; b=PH6AtDyopZwmnRo3ixoOqmV4uL
 p4icPHGmpX4g4wcxgUezHCgk4/Nc1XGAQPGFp1b+NAJ65jLgdFMEPsYf53qtPyd48jIMXitYcfKFn
 NApOpFOORPXqajeubgc2P0Ktiz923Vv2hHWU8dXGxNnoluZpiTsTUw5qmzLUw2q2evNM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=XZT1ZXMHbQwVX1NX6/t0S1MNa7GhuGeZMNMbI0p4suQ=; b=f+UGuRzrp1vqH26Wz4Ztk9aFE
 2WsDSpK2qgA/v9ec1JzZ3HIE7Jue2oTYv9PevX3HKXPzEDvjLY22NlTWrDSy1MrRD6EqirsyNyu8F
 H0zfnbpQDJcb3mKYzUJQiV+kbTyxgSwYx0uOuRvst5wKidL+kwV1vthMjl3lt1likFvjNfdq+v/JE
 yxursOvtda1+xVkWKWjHguSk7GEHszTIprlABfD7Z/ra9gKJJF2y8QFvYdBf9HLuuMkKsj0a4J7KB
 LAJi6L7aw5vKjPDxLY+yxVX2p6es1E3Cmfjq43PmImZiyvD01vFaMXnpqcbIt94kw6J+KzlPWzI8o
 RWkrUlwhw==;
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

The code is slightly shorter and simpler.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 0e19ea454cba..bdda1beda932 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -111,30 +111,28 @@
  *   ->tasklist_lock            (memory_failure, collect_procs_ao)
  */
 
-static void page_cache_tree_delete(struct address_space *mapping,
+static void page_cache_delete(struct address_space *mapping,
 				   struct page *page, void *shadow)
 {
-	int i, nr;
+	XA_STATE(xas, &mapping->i_pages, page->index);
+	unsigned int i, nr;
 
-	/* hugetlb pages are represented by one entry in the radix tree */
+	mapping_set_update(&xas, mapping);
+
+	/* hugetlb pages are represented by a single entry in the xarray */
 	nr = PageHuge(page) ? 1 : hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	VM_BUG_ON_PAGE(nr != 1 && shadow, page);
 
-	for (i = 0; i < nr; i++) {
-		struct radix_tree_node *node;
-		void **slot;
-
-		__radix_tree_lookup(&mapping->i_pages, page->index + i,
-				    &node, &slot);
-
-		VM_BUG_ON_PAGE(!node && nr != 1, page);
-
-		radix_tree_clear_tags(&mapping->i_pages, node, slot);
-		__radix_tree_replace(&mapping->i_pages, node, slot, shadow,
-				workingset_lookup_update(mapping));
+	i = nr;
+repeat:
+	xas_store(&xas, shadow);
+	xas_init_tags(&xas);
+	if (--i) {
+		xas_next(&xas);
+		goto repeat;
 	}
 
 	page->mapping = NULL;
@@ -234,7 +232,7 @@ void __delete_from_page_cache(struct page *page, void *shadow)
 	trace_mm_filemap_delete_from_page_cache(page);
 
 	unaccount_page_cache_page(mapping, page);
-	page_cache_tree_delete(mapping, page, shadow);
+	page_cache_delete(mapping, page, shadow);
 }
 
 static void page_cache_free_page(struct address_space *mapping,
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
