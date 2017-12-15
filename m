From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 57/78] lustre: Convert to XArray
Date: Fri, 15 Dec 2017 14:04:29 -0800
Message-ID: <20171215220450.7899-58-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
	Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=iUwoT2jTeIJDsbftyjZLSRZC7V1QinGj9JYk3Mn7QX8=; b=t1eVZ0HwENaQZ9xd90ByIO51f
	d1zd28zN5aE+OYaLLfgH1TTEZGgwCWbWcTbmCHKQICfVvvna9ZG8LUhxM3sWDCq+Ev3VOyURI/7fv
	Nz5Kd5KHk9fp/pWoaho/7h6ikj7TlOB73LXn5HjeFH49EobDlbQW/LJ4lj9BWXgHjPOeOlXOlF5Y6
	pNXrj/Ljk4ceR31tkE9J8C0t3cbJ20PckL8f5/a0WBJlDK6l2BrIwJMYEer8Pw6gon5WKwbnledoI
	MabK5WcKnTg9QZI7La3WvKtLiapLfgm0tPYUTES+H1o4azgpAkdUQavodJXsgTQAQ2A1319GYsSUI
	bp0GgBxxg==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/staging/lustre/lustre/llite/glimpse.c   | 12 +++++-------
 drivers/staging/lustre/lustre/mdc/mdc_request.c | 16 ++++++++--------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/glimpse.c b/drivers/staging/lustre/lustre/llite/glimpse.c
index 5f2843da911c..25232fdf5797 100644
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
-		cnt += radix_tree_gang_lookup_tag(&inode->i_mapping->pages,
-						  results, 0, 1,
-						  PAGECACHE_TAG_DIRTY);
+	if (inode->i_mapping && xa_tagged(&inode->i_mapping->pages,
+				PAGECACHE_TAG_DIRTY))
+		cnt = 1;
 	if (cnt == 0 && atomic_read(&vob->vob_mmap_cnt) > 0)
 		cnt = 1;
 
-	return (cnt > 0) ? 1 : 0;
+	return cnt;
 }
 
 int cl_glimpse_lock(const struct lu_env *env, struct cl_io *io,
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 2ec79a6b17da..ea23247e9e02 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -934,17 +934,18 @@ static struct page *mdc_page_locate(struct address_space *mapping, __u64 *hash,
 	 * hash _smaller_ than one we are looking for.
 	 */
 	unsigned long offset = hash_x_index(*hash, hash64);
+	XA_STATE(xas, &mapping->pages, offset);
 	struct page *page;
-	int found;
 
-	xa_lock_irq(&mapping->pages);
-	found = radix_tree_gang_lookup(&mapping->pages,
-				       (void **)&page, offset, 1);
-	if (found > 0 && !xa_is_value(page)) {
+	xas_lock_irq(&xas);
+	page = xas_find(&xas, ULONG_MAX);
+	if (xa_is_value(page))
+		page = NULL;
+	if (page) {
 		struct lu_dirpage *dp;
 
 		get_page(page);
-		xa_unlock_irq(&mapping->pages);
+		xas_unlock_irq(&xas);
 		/*
 		 * In contrast to find_lock_page() we are sure that directory
 		 * page cannot be truncated (while DLM lock is held) and,
@@ -992,8 +993,7 @@ static struct page *mdc_page_locate(struct address_space *mapping, __u64 *hash,
 			page = ERR_PTR(-EIO);
 		}
 	} else {
-		xa_unlock_irq(&mapping->pages);
-		page = NULL;
+		xas_unlock_irq(&xas);
 	}
 	return page;
 }
-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
