From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 58/62] dax: Convert __dax_invalidate_entry to
 XArray
Date: Thu, 29 Mar 2018 20:42:41 -0700
Message-ID: <20180330034245.10462-59-willy@infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
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
 bh=/hoyvJfSQ8XPECasNt1y0DFxFFem/HyGGfp+4alq+LA=; b=HlDabNDUySJx7wT3a9I+NBc3XS
 hf2et5AoPKvSQRG4CHvTWgHzgvJsjEDfp3IaTih15l4IBzOrZbhOO6IW5selMnmbXVIvhQKfruSbb
 B8lixOoC5BxBBtsXOQMWdk+u2thkfqMQavETMtXwjg13XtPAOeOOZ7B7fC3godIfFZrQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=/hoyvJfSQ8XPECasNt1y0DFxFFem/HyGGfp+4alq+LA=; b=cnYK+eZHC/mCbCZJ8Y81SLLDIn
 hZTlNULuYfpBtjcDJcl1qIwT+1cZJ8+8+GfWzDXZzwRBAsdXrgAmkXoO81BkBuapJYYzg5uGG4d3f
 sdcH8iLJusdAJdfIkjtpWoVSjAdFimlkiIiQm18oNWAI8u8OcLkytqU1ReqVGxEh8zgo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=/hoyvJfSQ8XPECasNt1y0DFxFFem/HyGGfp+4alq+LA=; b=N+maLKdqhc2aZBlIb2I1Gw9AP
 9xAqKTM2jX6Wax1np+ANxeylakaWurPZ4tnYHd3G0KiUTQuzCiUWY9Xn+3SPAhJs17FTHRAsaXcLS
 4KAFiNE/p8IGdF/oBeGCv7dWPNuhOkRu004TJo4nko++OQ0UFu8Dce8j2b7PlZrD+0wEFQ18aeEZd
 wwjr6NKOQcJipzsxOkKOHaqgb9ORlAysIuwxKYTjUg8ri75SR5oRnR91bI/bwSQVoDNLQ4X471LRu
 fUKQlYq8PcRVFdhDgaweWnJyLegLDnHIPu9Qf9xLshxARd1xf99dxpHlVIbpDUIGpFSTAhmzGP71t
 ZGONrb6jQ==;
In-Reply-To: <20180330034245.10462-1-willy@infradead.org>
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

Avoids walking the radix tree multiple times looking for tags.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 825bf153f499..9602db13aa65 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -657,27 +657,28 @@ EXPORT_SYMBOL_GPL(dax_layout_busy_page);
 static int __dax_invalidate_entry(struct address_space *mapping,
 					  pgoff_t index, bool trunc)
 {
+	XA_STATE(xas, &mapping->i_pages, index);
 	int ret = 0;
 	void *entry;
-	struct radix_tree_root *pages = &mapping->i_pages;
 
-	xa_lock_irq(pages);
-	entry = get_unlocked_mapping_entry(mapping, index, NULL);
+	xas_lock_irq(&xas);
+	entry = get_unlocked_entry(&xas);
 	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
 		goto out;
 	if (!trunc &&
-	    (radix_tree_tag_get(pages, index, PAGECACHE_TAG_DIRTY) ||
-	     radix_tree_tag_get(pages, index, PAGECACHE_TAG_TOWRITE)))
+	    (xas_get_tag(&xas, PAGECACHE_TAG_DIRTY) ||
+	     xas_get_tag(&xas, PAGECACHE_TAG_TOWRITE)))
 		goto out;
 	dax_disassociate_entry(entry, mapping, trunc);
-	radix_tree_delete(pages, index);
+	xas_store(&xas, NULL);
 	mapping->nrexceptional--;
 	ret = 1;
 out:
-	put_unlocked_mapping_entry(mapping, index, entry);
-	xa_unlock_irq(pages);
+	put_unlocked_entry(&xas, entry);
+	xas_unlock_irq(&xas);
 	return ret;
 }
+
 /*
  * Delete DAX entry at @index from @mapping.  Wait for it
  * to be unlocked before deleting it.
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
