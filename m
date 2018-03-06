From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 60/63] lustre: Convert to XArray
Date: Tue,  6 Mar 2018 11:24:10 -0800
Message-ID: <20180306192413.5499-61-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xGmjgauUfGLydkoWQBsKenPeBTGD1flvgBvi0gn26ng=; b=NIS2ZfSSfrEP0K9PYwSuGP2K5
        ZiJ7T6IoCqQ54Etgyn3NElb1aFx4JxnqWKPH5hgUgjd9l6243m820HDrtXvYdR34Pmayj35lu0BfR
        gIj9pCwDLHsrByfdtlItyELsvSQP1KXc+0erJLjYyiLHCFz39TDpxS06OuTv7rl3URHHbIK6In2jL
        UQKyiWgUBWsVrkLDeq1jC9C4DJn6EbPpHJSQXU8jecdU8lB0bPvFsLeP/tDgiNa/eoXjGBU+aOOxv
        Ke7rjVSYB7hJu+i99iEnw+htdR5YFWa689qA/oz5Ue4Txm3Xf8VzyGqXEx0qNQjI5P/9bG5gXekYK
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/staging/lustre/lustre/llite/glimpse.c   | 12 +++++-------
 drivers/staging/lustre/lustre/mdc/mdc_request.c | 16 ++++++++--------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/glimpse.c b/drivers/staging/lustre/lustre/llite/glimpse.c
index 3075358f3f08..014035be5ac7 100644
--- a/drivers/staging/lustre/lustre/llite/glimpse.c
+++ b/drivers/staging/lustre/lustre/llite/glimpse.c
@@ -57,7 +57,7 @@ static const struct cl_lock_descr whole_file = {
 };
 
 /*
- * Check whether file has possible unwriten pages.
+ * Check whether file has possible unwritten pages.
  *
  * \retval 1    file is mmap-ed or has dirty pages
  *	 0    otherwise
@@ -66,16 +66,14 @@ blkcnt_t dirty_cnt(struct inode *inode)
 {
 	blkcnt_t cnt = 0;
 	struct vvp_object *vob = cl_inode2vvp(inode);
-	void	      *results[1];
 
-	if (inode->i_mapping)
-		cnt += radix_tree_gang_lookup_tag(&inode->i_mapping->i_pages,
-						  results, 0, 1,
-						  PAGECACHE_TAG_DIRTY);
+	if (inode->i_mapping && xa_tagged(&inode->i_mapping->i_pages,
+				PAGECACHE_TAG_DIRTY))
+		cnt = 1;
 	if (cnt == 0 && atomic_read(&vob->vob_mmap_cnt) > 0)
 		cnt = 1;
 
-	return (cnt > 0) ? 1 : 0;
+	return cnt;
 }
 
 int cl_glimpse_lock(const struct lu_env *env, struct cl_io *io,
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 6950cb21638e..dbda8a9e351d 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -931,17 +931,18 @@ static struct page *mdc_page_locate(struct address_space *mapping, __u64 *hash,
 	 * hash _smaller_ than one we are looking for.
 	 */
 	unsigned long offset = hash_x_index(*hash, hash64);
+	XA_STATE(xas, &mapping->i_pages, offset);
 	struct page *page;
-	int found;
 
-	xa_lock_irq(&mapping->i_pages);
-	found = radix_tree_gang_lookup(&mapping->i_pages,
-				       (void **)&page, offset, 1);
-	if (found > 0 && !xa_is_value(page)) {
+	xas_lock_irq(&xas);
+	page = xas_find(&xas, ULONG_MAX);
+	if (xa_is_value(page))
+		page = NULL;
+	if (page) {
 		struct lu_dirpage *dp;
 
 		get_page(page);
-		xa_unlock_irq(&mapping->i_pages);
+		xas_unlock_irq(&xas);
 		/*
 		 * In contrast to find_lock_page() we are sure that directory
 		 * page cannot be truncated (while DLM lock is held) and,
@@ -989,8 +990,7 @@ static struct page *mdc_page_locate(struct address_space *mapping, __u64 *hash,
 			page = ERR_PTR(-EIO);
 		}
 	} else {
-		xa_unlock_irq(&mapping->i_pages);
-		page = NULL;
+		xas_unlock_irq(&xas);
 	}
 	return page;
 }
-- 
2.16.1

