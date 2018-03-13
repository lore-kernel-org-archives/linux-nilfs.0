From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 52/61] shmem: Comment fixups
Date: Tue, 13 Mar 2018 06:26:30 -0700
Message-ID: <20180313132639.17387-53-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ox2sTRQ87PNUtSRGfsNF7BbgSHI71IODEwo2d5bJ3rw=; b=rIl3WjDeEoWSpHmdyAtxPRqoz
        epGNBIkAJdwpIuqtl+iE7cLX2h4S0FCDuwzCDCGWxJqDJ5WGdWBEo2MhYP2IIUu6DnJqoC2zvXZcj
        Xp+LQLtlPyjXqwPaUagH31tqv4tjx2xp0CWFuzzf1ZPr4KippZfrDQ4HZd8cNDdszzzS2Js48sZOm
        4R2dKVYgPpOPWgaxllIeUjbt+diz+OEaudztVRYnOsgPnXrf3YYDBxbeE2Ewacz8P/hnkmqSmBVSF
        8RFv1A2XBYAhC+4w174lDqWv8AVh12LLyJzQ5vlX27kY32IGAZcXAvgbkZPwNzL89tOVSLyyCInS9
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Remove the last mentions of radix tree from various comments.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 707430003ec7..6b044cb6c8b5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -743,7 +743,7 @@ void shmem_unlock_mapping(struct address_space *mapping)
 }
 
 /*
- * Remove range of pages and swap entries from radix tree, and free them.
+ * Remove range of pages and swap entries from page cache, and free them.
  * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
  */
 static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
@@ -1118,10 +1118,10 @@ static int shmem_unuse_inode(struct shmem_inode_info *info,
 		 * We needed to drop mutex to make that restrictive page
 		 * allocation, but the inode might have been freed while we
 		 * dropped it: although a racing shmem_evict_inode() cannot
-		 * complete without emptying the radix_tree, our page lock
+		 * complete without emptying the page cache, our page lock
 		 * on this swapcache page is not enough to prevent that -
 		 * free_swap_and_cache() of our swap entry will only
-		 * trylock_page(), removing swap from radix_tree whatever.
+		 * trylock_page(), removing swap from page cache whatever.
 		 *
 		 * We must not proceed to shmem_add_to_page_cache() if the
 		 * inode has been freed, but of course we cannot rely on
@@ -1187,7 +1187,7 @@ int shmem_unuse(swp_entry_t swap, struct page *page)
 			false);
 	if (error)
 		goto out;
-	/* No radix_tree_preload: swap entry keeps a place for page in tree */
+	/* No memory allocation: swap entry occupies the slot for the page */
 	error = -EAGAIN;
 
 	mutex_lock(&shmem_swaplist_mutex);
@@ -1866,7 +1866,7 @@ alloc_nohuge:		page = shmem_alloc_and_acct_page(gfp, inode,
 		spin_unlock_irq(&info->lock);
 		goto repeat;
 	}
-	if (error == -EEXIST)	/* from above or from radix_tree_insert */
+	if (error == -EEXIST)
 		goto repeat;
 	return error;
 }
@@ -2478,7 +2478,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 }
 
 /*
- * llseek SEEK_DATA or SEEK_HOLE through the radix_tree.
+ * llseek SEEK_DATA or SEEK_HOLE through the page cache.
  */
 static pgoff_t shmem_seek_hole_data(struct address_space *mapping,
 				    pgoff_t index, pgoff_t end, int whence)
-- 
2.16.1

