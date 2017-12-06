From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v4 50/73] shmem: Comment fixups
Date: Tue,  5 Dec 2017 16:41:36 -0800
Message-ID: <20171206004159.3755-51-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rY3H+K78v/RSBSne8AxzVd+yWBDyYAkzavQu38JdXmE=; b=MRtjnl97pTARH4DGg1bG16Qvh
        5U3vorj3/vcHE775utWRMLHaLrl9o+jgLh4rGRg+TctACE3c75KqP5fJ3++7ER8dzhCqAwT3vH02y
        OEWOZ5+5LwV5xqX9lyDo2p1vg2LK40o44dDI+YLgoao4xvvSemZoJTdRqBqC3pYA+DbvYnHcrRNdO
        or/RToTJnhCni8HocK+4vkcOrxrjZrmLH+j6oKnn/q8t7wafqQcf764ZfJgMJDi/f6aF987M2rDlY
        qJGctkDDj++ffBoDIhpMMDejoTAXrgB+C+7P1Gngu4yXxhYlSsfz6TiWOv1ygyLkRbkNFjD2qjs9N
    
In-Reply-To: <20171206004159.3755-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Remove the last mentions of radix tree from various comments.

Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 mm/shmem.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 01102e2e0ef3..090937922c1d 100644
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
@@ -1862,7 +1862,7 @@ alloc_nohuge:		page = shmem_alloc_and_acct_page(gfp, inode,
 		spin_unlock_irq(&info->lock);
 		goto repeat;
 	}
-	if (error == -EEXIST)	/* from above or from radix_tree_insert */
+	if (error == -EEXIST)
 		goto repeat;
 	return error;
 }
@@ -2474,7 +2474,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 }
 
 /*
- * llseek SEEK_DATA or SEEK_HOLE through the radix_tree.
+ * llseek SEEK_DATA or SEEK_HOLE through the page cache.
  */
 static pgoff_t shmem_seek_hole_data(struct address_space *mapping,
 				    pgoff_t index, pgoff_t end, int whence)
@@ -2562,7 +2562,7 @@ static loff_t shmem_file_llseek(struct file *file, loff_t offset, int whence)
 }
 
 /*
- * We need a tag: a new tag would expand every radix_tree_node by 8 bytes,
+ * We need a tag: a new tag would expand every xa_node by 8 bytes,
  * so reuse a tag which we firmly believe is never set or cleared on shmem.
  */
 #define SHMEM_TAG_PINNED        PAGECACHE_TAG_TOWRITE
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
