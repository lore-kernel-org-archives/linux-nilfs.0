From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 05/61] Export __set_page_dirty
Date: Tue, 13 Mar 2018 06:25:43 -0700
Message-ID: <20180313132639.17387-6-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=c7XwEQF4XDkh6lGUOfLCsv8b+mb1lmt6s7JDZexOs1I=; b=rLs5O+UAgKTlCM+1Gk5ydK5U9
        vKqQlRhaPVe3RlRbJ++I2jIcbvye8s3DYd4I6BetANG2DDyCmoLB1mX1xGG6a3Yhgp5tUljgZZD6t
        HFfqE0NbAa9lFGPsL1K6sJ3/BuTJT2XU0e8GlQA8eqmqXXu5RZq4f8HX6RbGjKs9LUCB/kIHc7d66
        L4iKWLz/Ge8nCot8xHCslNBNWYsZ26g73Sg/uULlKVXiOIFYIoOeNjV0CHgN/dKeEw0+25vlSB7zi
        KoMkUQPNKgAEu9WUmFtY/icd30vPaNW8vTWbXkF5HZ/xzYKKA5dD4ZN8ESx8NXSPsNumZnnCTUOjR
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

XFS currently contains a copy-and-paste of __set_page_dirty().  Export
it from buffer.c instead.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
---
 fs/buffer.c        |  3 ++-
 fs/xfs/xfs_aops.c  | 15 ++-------------
 include/linux/mm.h |  1 +
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 17f13191a552..62bf5445c921 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -594,7 +594,7 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
  *
  * The caller must hold lock_page_memcg().
  */
-static void __set_page_dirty(struct page *page, struct address_space *mapping,
+void __set_page_dirty(struct page *page, struct address_space *mapping,
 			     int warn)
 {
 	unsigned long flags;
@@ -608,6 +608,7 @@ static void __set_page_dirty(struct page *page, struct address_space *mapping,
 	}
 	spin_unlock_irqrestore(&mapping->tree_lock, flags);
 }
+EXPORT_SYMBOL_GPL(__set_page_dirty);
 
 /*
  * Add a page to the dirty page list.
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a0afb6411417..f51350cb98a7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1473,19 +1473,8 @@ xfs_vm_set_page_dirty(
 	newly_dirty = !TestSetPageDirty(page);
 	spin_unlock(&mapping->private_lock);
 
-	if (newly_dirty) {
-		/* sigh - __set_page_dirty() is static, so copy it here, too */
-		unsigned long flags;
-
-		spin_lock_irqsave(&mapping->tree_lock, flags);
-		if (page->mapping) {	/* Race with truncate? */
-			WARN_ON_ONCE(!PageUptodate(page));
-			account_page_dirtied(page, mapping);
-			radix_tree_tag_set(&mapping->page_tree,
-					page_index(page), PAGECACHE_TAG_DIRTY);
-		}
-		spin_unlock_irqrestore(&mapping->tree_lock, flags);
-	}
+	if (newly_dirty)
+		__set_page_dirty(page, mapping, 1);
 	unlock_page_memcg(page);
 	if (newly_dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4d02524a7998..7f7bb4c28497 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1456,6 +1456,7 @@ extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned int offset,
 			      unsigned int length);
 
+void __set_page_dirty(struct page *, struct address_space *, int warn);
 int __set_page_dirty_nobuffers(struct page *page);
 int __set_page_dirty_no_writeback(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
-- 
2.16.1

