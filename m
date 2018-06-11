From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 36/72] mm: Convert truncate to XArray
Date: Mon, 11 Jun 2018 07:06:03 -0700
Message-ID: <20180611140639.17215-37-willy@infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
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
 bh=Uf6g1DCKoZTcsIod4MBFbPjjHdDF87hOdzkkZTr2U34=; b=LsoT0jGV4gyok9R+2DA/17rESY
 CUZ0bzzEbXaaZOCqvqyhPWk6etA2UZAoSmlLI8HPKKEY70TKaSIsSZoZBGSfp8uMnDgL8Rv1ZYJOm
 fsjHGVwbUtCIBk3v4zJww8OOigT2Ggqwkcss5mfnth4sf/rQp8bhLINNIPNNlAhGVJk4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=Uf6g1DCKoZTcsIod4MBFbPjjHdDF87hOdzkkZTr2U34=; b=TKY7VxyJBU76tmHxdQQzciZzsS
 f1IBmyhch1RO5qmlksjs0jfb8fhcKVMmwnIEU8MgApdtjI1Thrc9hAsZfP+TSY/RRxSVaVlMSVQKk
 EplLtaPcGq1lDE2tAT5KWdcFsVw3QJCFNEFBWIk9hliMgqN68uU7m8I7EiFmeKEb98pA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=Uf6g1DCKoZTcsIod4MBFbPjjHdDF87hOdzkkZTr2U34=; b=o+RFy7+6TUUhlW2A8nui01xxd
 /Glab80k/TZGU2wA0JpNNAQlgTl8vnyVOsvoxO7vVfQwTIwqVY91UvDdxk2wAZbHjjMfZee0aDYL/
 61ehSv+o8e31ex3K+xGOPK56//Ua44BCMImv3rfWrI/DEuU4J5a8hUuKduiSa3e2oSZq+nY6DluE1
 yU7SBK1e+qHo5FJkdSEVmlBUg/ZP5vEVJIAGGg7pCHS0mJaDGdACPJ7jneyhdTOsBABxSWYP3KKD6
 zcsPVVPOSBRln7DGa5appg0Tz7uwMk9jxqAlB5/WIsDFr92Lg1HQ38Ttudtxb8Ms5uOFJ9p0w+crE
 p3MpYxtfg==;
In-Reply-To: <20180611140639.17215-1-willy@infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

This is essentially xa_cmpxchg() with the locking handled above us,
and it doesn't have to handle replacing a NULL entry.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/truncate.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index ed778555c9f3..45d68e90b703 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -33,15 +33,12 @@
 static inline void __clear_shadow_entry(struct address_space *mapping,
 				pgoff_t index, void *entry)
 {
-	struct radix_tree_node *node;
-	void **slot;
+	XA_STATE(xas, &mapping->i_pages, index);
 
-	if (!__radix_tree_lookup(&mapping->i_pages, index, &node, &slot))
+	xas_set_update(&xas, workingset_update_node);
+	if (xas_load(&xas) != entry)
 		return;
-	if (*slot != entry)
-		return;
-	__radix_tree_replace(&mapping->i_pages, node, slot, NULL,
-			     workingset_update_node);
+	xas_store(&xas, NULL);
 	mapping->nrexceptional--;
 }
 
@@ -738,10 +735,10 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 		index++;
 	}
 	/*
-	 * For DAX we invalidate page tables after invalidating radix tree.  We
+	 * For DAX we invalidate page tables after invalidating page cache.  We
 	 * could invalidate page tables while invalidating each entry however
 	 * that would be expensive. And doing range unmapping before doesn't
-	 * work as we have no cheap way to find whether radix tree entry didn't
+	 * work as we have no cheap way to find whether page cache entry didn't
 	 * get remapped later.
 	 */
 	if (dax_mapping(mapping)) {
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
