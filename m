From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 05/63] Export __set_page_dirty
Date: Tue,  6 Mar 2018 11:23:15 -0800
Message-ID: <20180306192413.5499-6-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=X+noeKqTlH+Z2Zf1x3gZ3ce+xjwx5jIvAM9C8fAlmXQ=; b=S6c5BRRjiorPM00yjG/VkygYI
        dJJlxqMcgUSy7RJwTe8tsM8ti9A8qXNo7ks6SU1QwwhDXYpVEUbr981BZ52QNd5sKJZM1euGj5Eos
        DqT4/aXk2jtW4/T92UGUXZhoXFZfy+jGJmYAfnX5ziLGCMQc0NUT+ldI7GAJMKsCg1PhfM/D1/i55
        TgLQgUXWT4T6rFmBvyUYN5VSExn/JVZ17+VhB6TGhdvZaxCQkRU4amsEuNTwoHA+7WX5uJxC/FPJ5
        qIRp6HMQiB0i+YMbFn6o7coEidzbpy4Nzkjl3/LajGqf5lKd3xQWJRNqObHIcy/Hhr38bpNBy3PFj
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

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
index 3b2b415f1fcd..a17d47b55de1 100644
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
index 9c6a830da0ee..31f2c4895a46 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1472,19 +1472,8 @@ xfs_vm_set_page_dirty(
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
index 9f1270360983..8cf4714bfec8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1454,6 +1454,7 @@ extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned int offset,
 			      unsigned int length);
 
+void __set_page_dirty(struct page *, struct address_space *, int warn);
 int __set_page_dirty_nobuffers(struct page *page);
 int __set_page_dirty_no_writeback(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
-- 
2.16.1

