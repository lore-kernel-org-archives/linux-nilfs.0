From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 54/61] fs: Convert buffer to XArray
Date: Tue, 13 Mar 2018 06:26:32 -0700
Message-ID: <20180313132639.17387-55-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TOQIcEGLd9uWoqlAYOTm/Gwp0H1LSs5uFWv1aD+804c=; b=PS9DZCSgJwsjzf4yKBvV9MLRC
        cWZVsxW4Xxy3hNJrysIiD/7d/V6gh9Qbh9ThsqhgZ2KP16XOiqzrXSqAFDOeOQSFsM47pN3x45hxZ
        j6hDIx8yQFoRYQ77Hes5OgjnsDUdwejW7lO7XHZCHDCV7FovILl/HcafTIgNPA9tTD4otgUnnaF/S
        +4+b9f8V4IpkOZXs8VJRjNjnSoX8zsTt7EfSZ5kTjg88to+LN7grRDfCC/oCPbvjtzmjpeeJK8vfy
        x2Z5VY/QdCnmhf/eQgOHjUY5CzJO4mh+JnJe8FDZfHujQYkEXXlB0bTsQGqTFWrCOeEpd7V8Wd2G+
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Mostly comment fixes, but one use of __xa_set_tag.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/buffer.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index f3059f929dd6..5c798ecf7a39 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -585,7 +585,7 @@ void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 EXPORT_SYMBOL(mark_buffer_dirty_inode);
 
 /*
- * Mark the page dirty, and set it dirty in the radix tree, and mark the inode
+ * Mark the page dirty, and set it dirty in the page cache, and mark the inode
  * dirty.
  *
  * If warn is true, then emit a warning if the page is not uptodate and has
@@ -602,8 +602,8 @@ void __set_page_dirty(struct page *page, struct address_space *mapping,
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
 		account_page_dirtied(page, mapping);
-		radix_tree_tag_set(&mapping->i_pages,
-				page_index(page), PAGECACHE_TAG_DIRTY);
+		__xa_set_tag(&mapping->i_pages, page_index(page),
+				PAGECACHE_TAG_DIRTY);
 	}
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 }
@@ -1066,7 +1066,7 @@ __getblk_slow(struct block_device *bdev, sector_t block,
  * The relationship between dirty buffers and dirty pages:
  *
  * Whenever a page has any dirty buffers, the page's dirty bit is set, and
- * the page is tagged dirty in its radix tree.
+ * the page is tagged dirty in the page cache.
  *
  * At all times, the dirtiness of the buffers represents the dirtiness of
  * subsections of the page.  If the page has buffers, the page dirty bit is
@@ -1089,9 +1089,9 @@ __getblk_slow(struct block_device *bdev, sector_t block,
  * mark_buffer_dirty - mark a buffer_head as needing writeout
  * @bh: the buffer_head to mark dirty
  *
- * mark_buffer_dirty() will set the dirty bit against the buffer, then set its
- * backing page dirty, then tag the page as dirty in its address_space's radix
- * tree and then attach the address_space's inode to its superblock's dirty
+ * mark_buffer_dirty() will set the dirty bit against the buffer, then set
+ * its backing page dirty, then tag the page as dirty in the page cache
+ * and then attach the address_space's inode to its superblock's dirty
  * inode list.
  *
  * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
-- 
2.16.1

