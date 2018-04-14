From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 63/63] radix tree: Remove
 radix_tree_clear_tags
Date: Sat, 14 Apr 2018 07:13:16 -0700
Message-ID: <20180414141316.7167-64-willy@infradead.org>
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
 bh=H05WaPyHHSTSA9y4XQ9GF+rrLwVFtHFYh8Sue/ujC3g=; b=NZlIwBZc+HAYH3hz0Luf9GwRo9
 M3PvmvfQEs+Z6z4ZY9uA7hSmzbH5s1q+3IlLGOQRirFajaU5QE8NcUc90sbSmjGTQrRi6YEJvYqdY
 RPdOkyF1RKwWB1MDKR9Vo31hE4527AE6ZcjNSizE7yaMKnVeFd5FcBu2BO8alN2oAuSM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=H05WaPyHHSTSA9y4XQ9GF+rrLwVFtHFYh8Sue/ujC3g=; b=FxXFxu5Fccol7TXSVfS4FZD7bW
 8D04779KUrlRwvuDmEMf5eApdYvSLoSNsaLCiH42ahCk2up3DscFcSb8rj3BdQWwRLi/RE3AptJ0v
 4UsUQYRFxOmrPr5is1hwl+mfyQXk/U+tgEN1Iob2BCMdDk9dHhqX1OgT7G15CwWEHNP8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=H05WaPyHHSTSA9y4XQ9GF+rrLwVFtHFYh8Sue/ujC3g=; b=TFhGf2JAkeoM9teK2AOLsBC4v
 Xc5BRBqFkVbNWsoDaVkJUqbWQGHHr3SGuEMdgtTVao6ZQww06KREKdmwu4uSxNaUMYLaHJdgns2wj
 ASSPFnyNu5FAMNRASi1QxB7Y2mZropRLVhI19Thb+byJ7Rqivwpowy/A2m887kel0MdqDeClg2BO7
 pc2r1OAuUTlPFcPveurdOAWn0zdwt428wXbahjCWD31xyCWeH5La8mZeslhgu8OJuctdXlVg+cY/8
 VXhHWH7R74ZkDbx7jGAHXf5rSQq9vR9MHQUdHJtaPxwaT+jSsmHu5/nyFpAmPmfTkj55XYej/npvE
 8AMwlNhiQ==;
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

The page cache was the only user of this interface and it has now
been converted to the XArray.  Transform the test into a test of
xas_init_tags().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/radix-tree.h           |  2 --
 lib/radix-tree.c                     | 13 -----------
 tools/testing/radix-tree/main.c      | 12 +++++------
 tools/testing/radix-tree/tag_check.c | 32 +++++++++++++---------------
 4 files changed, 21 insertions(+), 38 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index ceff6856470a..3f778e3beba6 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -255,8 +255,6 @@ void radix_tree_iter_delete(struct radix_tree_root *,
 			struct radix_tree_iter *iter, void __rcu **slot);
 void *radix_tree_delete_item(struct radix_tree_root *, unsigned long, void *);
 void *radix_tree_delete(struct radix_tree_root *, unsigned long);
-void radix_tree_clear_tags(struct radix_tree_root *, struct radix_tree_node *,
-			   void __rcu **slot);
 unsigned int radix_tree_gang_lookup(const struct radix_tree_root *,
 			void **results, unsigned long first_index,
 			unsigned int max_items);
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index f15b9ee000b8..13a2eb2baddc 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1709,19 +1709,6 @@ void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
 }
 EXPORT_SYMBOL(radix_tree_delete);
 
-void radix_tree_clear_tags(struct radix_tree_root *root,
-			   struct radix_tree_node *node,
-			   void __rcu **slot)
-{
-	if (node) {
-		unsigned int tag, offset = get_slot_offset(node, slot);
-		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
-			node_tag_clear(root, node, tag, offset);
-	} else {
-		root_tag_clear_all(root);
-	}
-}
-
 /**
  *	radix_tree_tagged - test whether any items in the tree are tagged
  *	@root:		radix tree root
diff --git a/tools/testing/radix-tree/main.c b/tools/testing/radix-tree/main.c
index 257f3f8aacaa..13987313311c 100644
--- a/tools/testing/radix-tree/main.c
+++ b/tools/testing/radix-tree/main.c
@@ -35,12 +35,12 @@ void __gang_check(unsigned long middle, long down, long up, int chunk, int hop)
 
 void gang_check(void)
 {
-	__gang_check(1 << 30, 128, 128, 35, 2);
-	__gang_check(1 << 31, 128, 128, 32, 32);
-	__gang_check(1 << 31, 128, 128, 32, 100);
-	__gang_check(1 << 31, 128, 128, 17, 7);
-	__gang_check(0xffff0000, 0, 65536, 17, 7);
-	__gang_check(0xfffffffe, 1, 1, 17, 7);
+	__gang_check(1UL << 30, 128, 128, 35, 2);
+	__gang_check(1UL << 31, 128, 128, 32, 32);
+	__gang_check(1UL << 31, 128, 128, 32, 100);
+	__gang_check(1UL << 31, 128, 128, 17, 7);
+	__gang_check(0xffff0000UL, 0, 65536, 17, 7);
+	__gang_check(0xfffffffeUL, 1, 1, 17, 7);
 }
 
 void __big_gang_check(void)
diff --git a/tools/testing/radix-tree/tag_check.c b/tools/testing/radix-tree/tag_check.c
index 543181e4847b..340bc4f72f34 100644
--- a/tools/testing/radix-tree/tag_check.c
+++ b/tools/testing/radix-tree/tag_check.c
@@ -331,29 +331,27 @@ static void single_check(void)
 	item_kill_tree(&tree);
 }
 
-void radix_tree_clear_tags_test(void)
+void init_tags_test(void)
 {
+	DEFINE_XARRAY(tree);
+	XA_STATE(xas, &tree, 0);
 	unsigned long index;
-	struct radix_tree_node *node;
-	struct radix_tree_iter iter;
-	void **slot;
+	void *entry;
 
-	RADIX_TREE(tree, GFP_KERNEL);
-
-	item_insert(&tree, 0);
-	item_tag_set(&tree, 0, 0);
-	__radix_tree_lookup(&tree, 0, &node, &slot);
-	radix_tree_clear_tags(&tree, node, slot);
-	assert(item_tag_get(&tree, 0, 0) == 0);
+	xa_store(&tree, 0, xa_mk_value(0), GFP_KERNEL);
+	item_tag_set(&tree, 0, XA_TAG_0);
+	xas_load(&xas);
+	xas_init_tags(&xas);
+	assert(item_tag_get(&tree, 0, XA_TAG_0) == 0);
 
 	for (index = 0; index < 1000; index++) {
-		item_insert(&tree, index);
-		item_tag_set(&tree, index, 0);
+		xa_store(&tree, index, xa_mk_value(index), GFP_KERNEL);
+		item_tag_set(&tree, index, XA_TAG_0);
 	}
 
-	radix_tree_for_each_slot(slot, &tree, &iter, 0) {
-		radix_tree_clear_tags(&tree, iter.node, slot);
-		assert(item_tag_get(&tree, iter.index, 0) == 0);
+	xas_for_each(&xas, entry, ULONG_MAX) {
+		xas_init_tags(&xas);
+		assert(item_tag_get(&tree, xas.xa_index, XA_TAG_0) == 0);
 	}
 
 	item_kill_tree(&tree);
@@ -376,5 +374,5 @@ void tag_check(void)
 	thrash_tags();
 	rcu_barrier();
 	printv(2, "after thrash_tags: %d allocated\n", nr_allocated);
-	radix_tree_clear_tags_test();
+	init_tags_test();
 }
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
