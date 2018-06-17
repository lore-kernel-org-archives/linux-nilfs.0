From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 58/74] fs: Convert buffer to XArray
Date: Sat, 16 Jun 2018 19:00:36 -0700
Message-ID: <20180617020052.4759-59-willy@infradead.org>
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
 bh=OqzVPn6mYy8g9+6jefdMDT4tdMX8rFTuXWopfcwuKSE=; b=ZdbB6mM4emkd14yImRL5S7AYf6
 vbCH5JP5zgADB84hlVyIlP7JhZMhx0U/zBOqr5sLt1+t6edwTr47UTW4eSff1ZZnHqr377KaIIs2g
 tU8XldY6dMb3kYBpzff3WFODL6VOi8s7f04FBkZSmQTBP2JcDeHX0J+LoMgWNgYbiJlU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=OqzVPn6mYy8g9+6jefdMDT4tdMX8rFTuXWopfcwuKSE=; b=A8s/wBmrLzmG/pJru+a5uVaeNQ
 DrJ/6vlcyMXeSbrtgnlkJuZuYAAc2wRxptKKATOFJ4QI/2x35J8UJ0nvJyCrnUcu/CvFnCm/3VtUS
 PI9Ye235VIY6sDOkLSUpGhXM1nETsoZMP5d5m8L8BfaUOLJ4LZFqhEYdFjbZ6bKzBwI4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=OqzVPn6mYy8g9+6jefdMDT4tdMX8rFTuXWopfcwuKSE=; b=LK7hNKasD9BmKXG6K9Zi2ZUEX
 jHFr90oJfeGjubgg7qdO2H9lTdDUz1bfQA9nPwPKlntkxwq12gJU+FSAjAEePTM6bU7jQkDnOc4Z5
 DA7BPrpRcomFDHcBzjU5mJuSS3dIZ/N4WyGYe1SExRYHhLqwYGqFd3zV9yMinkZ2Wfuy+gR7Wu+kp
 LpS3ZLK2Mha+XwFHruQ8+SmiXPtY4GuwqixsEDcCNUoEBoCqzWXGklJ296v20Ci2zgodD4th+Sa1n
 8ieGJxc3yzbOyYdvP/F1Fo2YYKljSQd82P536AAlec2GBV0FgR4Ac4X4Tqh/yLhF8z5tNRCdUnKRb
 riAmsv8DQ==;
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

Mostly comment fixes, but one use of __xa_set_tag.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 fs/buffer.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 8194e3049fc5..deae44fd64e9 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -562,7 +562,7 @@ void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 EXPORT_SYMBOL(mark_buffer_dirty_inode);
 
 /*
- * Mark the page dirty, and set it dirty in the radix tree, and mark the inode
+ * Mark the page dirty, and set it dirty in the page cache, and mark the inode
  * dirty.
  *
  * If warn is true, then emit a warning if the page is not uptodate and has
@@ -579,8 +579,8 @@ void __set_page_dirty(struct page *page, struct address_space *mapping,
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
@@ -1043,7 +1043,7 @@ __getblk_slow(struct block_device *bdev, sector_t block,
  * The relationship between dirty buffers and dirty pages:
  *
  * Whenever a page has any dirty buffers, the page's dirty bit is set, and
- * the page is tagged dirty in its radix tree.
+ * the page is tagged dirty in the page cache.
  *
  * At all times, the dirtiness of the buffers represents the dirtiness of
  * subsections of the page.  If the page has buffers, the page dirty bit is
@@ -1066,9 +1066,9 @@ __getblk_slow(struct block_device *bdev, sector_t block,
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
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
