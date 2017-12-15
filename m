From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 53/78] fs: Convert buffer to XArray
Date: Fri, 15 Dec 2017 14:04:25 -0800
Message-ID: <20171215220450.7899-54-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
	Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=Pu5JcXjlly25xQrgLzXZh25F7ow6+azETppMFJy1RFw=; b=mMIH9iAoB1YpEinuKwJnVAv06
	TmGdLzpkwJUIKE+qylmXeja5VAKmBVPz5CWWLtef58+GMjSWyyZ4jFWhp6DkOCAlKR8rHgBQbPhiC
	6TOstLyH3jiFUn00BImHEGRnt++FqburdhzX3hgeDffqlDUD7mOydhAU2wPMJabBlciLDwBU7+b+P
	2UtLm+7VcLrKqWRnWEKuVviN1od0H8SVA9CxNz1BgU/maJfiGkIUowCx3K6VCsBISFtRdj63C6kUp
	hxAS7m8gnYaoJKzYX2CvFKXpuquzrJ43TcyN+/XACvZNke5S6zWCBV7aF/T43bdGTGrBVFzjwges+
	C833xg9zw==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Mostly comment fixes, but one use of __xa_set_tag.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/buffer.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 1a6ae530156b..e1d18307d5c8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -592,7 +592,7 @@ void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 EXPORT_SYMBOL(mark_buffer_dirty_inode);
 
 /*
- * Mark the page dirty, and set it dirty in the radix tree, and mark the inode
+ * Mark the page dirty, and set it dirty in the page cache, and mark the inode
  * dirty.
  *
  * If warn is true, then emit a warning if the page is not uptodate and has
@@ -609,8 +609,8 @@ void __set_page_dirty(struct page *page, struct address_space *mapping,
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
 		account_page_dirtied(page, mapping);
-		radix_tree_tag_set(&mapping->pages,
-				page_index(page), PAGECACHE_TAG_DIRTY);
+		__xa_set_tag(&mapping->pages, page_index(page),
+				PAGECACHE_TAG_DIRTY);
 	}
 	xa_unlock_irqrestore(&mapping->pages, flags);
 }
@@ -1072,7 +1072,7 @@ __getblk_slow(struct block_device *bdev, sector_t block,
  * The relationship between dirty buffers and dirty pages:
  *
  * Whenever a page has any dirty buffers, the page's dirty bit is set, and
- * the page is tagged dirty in its radix tree.
+ * the page is tagged dirty in the page cache.
  *
  * At all times, the dirtiness of the buffers represents the dirtiness of
  * subsections of the page.  If the page has buffers, the page dirty bit is
@@ -1095,9 +1095,9 @@ __getblk_slow(struct block_device *bdev, sector_t block,
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
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
