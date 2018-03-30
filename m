From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 01/62] page cache: Use xa_lock
Date: Thu, 29 Mar 2018 20:41:44 -0700
Message-ID: <20180330034245.10462-2-willy@infradead.org>
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
 bh=EOx1L4BPJFJpuhRnZv45Tpt8sej/xMf7k+ssjF5Qnps=; b=cftd8GhIKfAqkxK5DBvyM2NYPC
 Y+qBQyGhCkOqEBRI3aAHOcBJVvYAkJ+35xqsIbaPMMDqdDAnRAwemqPsrBdcOQ1lZHP8RcTNbAPJn
 SsDi0ikXyJrLe+pQUyhSys93EUCONZmTT64oncOidTs906p5g8mPyhSf89QlRfh1DIjY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=EOx1L4BPJFJpuhRnZv45Tpt8sej/xMf7k+ssjF5Qnps=; b=Cq9j+W71+KY7WPO5EI4ugDOlXm
 HaogY0PYUfR2BWmrUcuxrqcFNcWABMQVHGa15ezCstq1tZoIGMYHhIFngKXAGmv8oOkpD/WfC8WuC
 XjgUb/mKzZpd9ZCR+dm9g59XyU45SzYBhk9ee8ReuQHcLEnjGtdcdqm7NgEaFpzToTH0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=EOx1L4BPJFJpuhRnZv45Tpt8sej/xMf7k+ssjF5Qnps=; b=jMO+Ld8rF9ToBdbOvILRj71Q2
 exGCyVNuz+Bgs5Fm/8Cybj6mwcqHbOvFSYTZOmkoVZvF/yjI4Fp/42unQ5+gTINA0kSrcY8dAOJTR
 R8bnThmADZLNLPrAufxzsMcysVXBQlYeFt4CMQIP5dMil909n93jyk+f9TEQMKCDLJb8p7yw/sAxt
 vg0SIqcvcYo5/YRnbgv8IpnOlxWDQwSilH4PtyXPNZy7nULNR98E7hb8gQNrMYK6lqKoIA7Aks1xm
 EoIJ/C2bQKeFNSa3z0W0WP8OKiw67uu5TfZ98oSQ9rAPUO0cxur76O8cLM2ZpvYT0NkmyelQECp8N
 G3ZUWEm4g==;
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

Remove the address_space ->tree_lock and use the xa_lock newly added to
the radix_tree_root.  Rename the address_space ->page_tree to ->i_pages,
since we don't really care that it's a tree.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 arch/nds32/include/asm/cacheflush.h | 4 ++--
 fs/dax.c                            | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/nds32/include/asm/cacheflush.h b/arch/nds32/include/asm/cacheflush.h
index 7b9b20a381cb..1240f148ec0f 100644
--- a/arch/nds32/include/asm/cacheflush.h
+++ b/arch/nds32/include/asm/cacheflush.h
@@ -34,8 +34,8 @@ void flush_anon_page(struct vm_area_struct *vma,
 void flush_kernel_dcache_page(struct page *page);
 void flush_icache_range(unsigned long start, unsigned long end);
 void flush_icache_page(struct vm_area_struct *vma, struct page *page);
-#define flush_dcache_mmap_lock(mapping)   spin_lock_irq(&(mapping)->tree_lock)
-#define flush_dcache_mmap_unlock(mapping) spin_unlock_irq(&(mapping)->tree_lock)
+#define flush_dcache_mmap_lock(mapping)   xa_lock_irq(&(mapping)->i_pages)
+#define flush_dcache_mmap_unlock(mapping) xa_unlock_irq(&(mapping)->i_pages)
 
 #else
 #include <asm-generic/cacheflush.h>
diff --git a/fs/dax.c b/fs/dax.c
index eeedecc8367b..9dc7337ef571 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -584,7 +584,7 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 	void *entry;
 	struct radix_tree_root *pages = &mapping->i_pages;
 
-	xa_lock_irq(&mapping->i_pages);
+	xa_lock_irq(pages);
 	entry = get_unlocked_mapping_entry(mapping, index, NULL);
 	if (!entry || WARN_ON_ONCE(!radix_tree_exceptional_entry(entry)))
 		goto out;
@@ -598,7 +598,7 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 	ret = 1;
 out:
 	put_unlocked_mapping_entry(mapping, index, entry);
-	xa_unlock_irq(&mapping->i_pages);
+	xa_unlock_irq(pages);
 	return ret;
 }
 /*
@@ -685,7 +685,7 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 			unmap_mapping_pages(mapping, vmf->pgoff, 1, false);
 	}
 
-	xa_lock_irq(&mapping->i_pages);
+	xa_lock_irq(pages);
 	new_entry = dax_radix_locked_entry(pfn, flags);
 	if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
 		dax_disassociate_entry(entry, mapping, false);
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
