From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 50/63] lustre: Convert to XArray
Date: Sat, 14 Apr 2018 07:13:03 -0700
Message-ID: <20180414141316.7167-51-willy@infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
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
 bh=buSbyNGChDzOdA9uOE7ncDZ5eZoC22NyH+/dYQmwE1Q=; b=Ux/mAmZjNd4tdi8W/c6ssmj+AE
 0n2amI4cTsRoKXnWAW3rXsh7w4TC9dj3Xkyi4NvQ9nGydvOj5EJkCYeurKyTiaLt7nvWFuRnpNarS
 SMsbSzJNkwPZvf+tC6le2qcs4bE5r4OPiDB46m2dAaAQdMpEBce5MFVD0uTlOtMvqIA8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=buSbyNGChDzOdA9uOE7ncDZ5eZoC22NyH+/dYQmwE1Q=; b=R6idKXTV93mszU2U9ycCUG/g8u
 kz5azNgfQKRn8DiCMfaoI8YSwsRokbVkixbph/slKG0X83emsf0TMbKIoMIcHhwJIPnb5NReOmOqJ
 oWpBUhj5OZIKYi9V9Sc0NW8x6t8n2Vx5MI+obM8BeLRr5Ix0ybatPuKH13yp2GF6LYHQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=buSbyNGChDzOdA9uOE7ncDZ5eZoC22NyH+/dYQmwE1Q=; b=sYxYvkA5dEmgrfI5nTIm+AXFR
 ErdmMraTahnNQWM3sDfC488RKNmEb79ZWlMHmxSXiOJlxaSUr9RQtkczRY8mrT4Y4UeLwzjKjvBgw
 n8cbep22t5pQL/33+CdLPCP+CIatQ1TrB1fSzTz2dVeEwjKCAKpl4B1KMbS9Xe3Iroj+knS1xchGh
 jDqONeVRKmP16slQUop2qbLveMmhrwim+5zvtyJ0eR50xyRuaeH0pfSv1qywP5RleaniS2D9g0hfq
 SWnYqDR21PF6Q3h1wmamjnUP2ureC9OWkLcerETRnD6igPYJD6eGt4BWNv0UEvN2sHzZgK2epvQQO
 VQnNOrdXw==;
In-Reply-To: <20180414141316.7167-1-willy@infradead.org>
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
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
