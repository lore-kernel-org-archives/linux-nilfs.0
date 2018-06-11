From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 69/72] radix tree: Remove
 radix_tree_update_node_t
Date: Mon, 11 Jun 2018 07:06:36 -0700
Message-ID: <20180611140639.17215-70-willy@infradead.org>
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
 bh=ynh2wcxEjkHUCCf5sVGFt2iVMlo/bLiazXSXh5mbgyo=; b=jrJAaGROem/wqP/1epI8Ph0sHz
 Tltm6GEHpjhZF65DAAwREPpbEXehUsZEwnT9CoCGi5g3FYgXfh3vBqJMTlkSipuq6LAZ1LD0ubwcd
 uKsZs7UFbXwWCzTKGKFeaQ0Y9BP2C5WRUEOh/sss+t88mkzTDpd5UxOJl4s8ee3iWmak=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ynh2wcxEjkHUCCf5sVGFt2iVMlo/bLiazXSXh5mbgyo=; b=S7cwaWQA5V6/Cx0TJwelSZ2ijV
 eWPuO/YdsGtOlHvHVk6sXHIxjT5MlxTS2blG7+R6SYYWrWwkS8KFZJOTJSDpAMNmorvCHD7+TtFz0
 llpYQxBxxKtEh5FTN2QPOCVkbSJT9mrgaiLAmz870AwDPG9S8HABrjZcp7VHOZGv3YIM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ynh2wcxEjkHUCCf5sVGFt2iVMlo/bLiazXSXh5mbgyo=; b=W7MyQqs2mqDmueKISb2fnPkpk
 y/GOIFtUtIazDSRPCIdIrI7q0D3IDURUIyI8mPo8p6Mxtt8T4HR1TvdlXi4f7sohCdoiM7FljzA6d
 0vT6lvRK51yCe5Oyjd6aUtw8iAsF2p/qP0CvULrr6E+IIogqKNAhgiMiFi4X2lRfT++DSHhHg9NxK
 tn8CgFwxTADAlRbOIjRti4P0vRvPWCx7SJnzWP3SBtiKBpJyxGQ8rsQwkFXZKDBksCeW9grr3yp+N
 KNbow2xqcdOcqTrwe8x9VE2ynyS0DPNCmctlw1uPaYI7nMiiSWc1dnVt3Xo8IP+YCQqcnjcQHuFRg
 fRknCI0tQ==;
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

The only user of this functionality was the workingset code, and it's
now been converted to the XArray.  Remove __radix_tree_delete_node()
entirely as it was also only used by the workingset code.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/radix-tree.h            |  7 +----
 lib/idr.c                             |  2 +-
 lib/radix-tree.c                      | 42 +++++----------------------
 tools/testing/radix-tree/multiorder.c |  2 +-
 4 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 081e68b4376b..fc13c4b1afdb 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -242,17 +242,12 @@ void *__radix_tree_lookup(const struct radix_tree_root *, unsigned long index,
 void *radix_tree_lookup(const struct radix_tree_root *, unsigned long);
 void __rcu **radix_tree_lookup_slot(const struct radix_tree_root *,
 					unsigned long index);
-typedef void (*radix_tree_update_node_t)(struct radix_tree_node *);
 void __radix_tree_replace(struct radix_tree_root *, struct radix_tree_node *,
-			  void __rcu **slot, void *entry,
-			  radix_tree_update_node_t update_node);
+			  void __rcu **slot, void *entry);
 void radix_tree_iter_replace(struct radix_tree_root *,
 		const struct radix_tree_iter *, void __rcu **slot, void *entry);
 void radix_tree_replace_slot(struct radix_tree_root *,
 			     void __rcu **slot, void *entry);
-void __radix_tree_delete_node(struct radix_tree_root *,
-			      struct radix_tree_node *,
-			      radix_tree_update_node_t update_node);
 void radix_tree_iter_delete(struct radix_tree_root *,
 			struct radix_tree_iter *iter, void __rcu **slot);
 void *radix_tree_delete_item(struct radix_tree_root *, unsigned long, void *);
diff --git a/lib/idr.c b/lib/idr.c
index 0d7410d1fb7c..58b88f5eb672 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -303,7 +303,7 @@ void *idr_replace(struct idr *idr, void *ptr, unsigned long id)
 	if (!slot || radix_tree_tag_get(&idr->idr_rt, id, IDR_FREE))
 		return ERR_PTR(-ENOENT);
 
-	__radix_tree_replace(&idr->idr_rt, node, slot, ptr, NULL);
+	__radix_tree_replace(&idr->idr_rt, node, slot, ptr);
 
 	return entry;
 }
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index d0f44ea96945..001062d41f9f 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -610,8 +610,7 @@ static int radix_tree_extend(struct radix_tree_root *root, gfp_t gfp,
  *	radix_tree_shrink    -    shrink radix tree to minimum height
  *	@root		radix tree root
  */
-static inline bool radix_tree_shrink(struct radix_tree_root *root,
-				     radix_tree_update_node_t update_node)
+static inline bool radix_tree_shrink(struct radix_tree_root *root)
 {
 	bool shrunk = false;
 
@@ -671,8 +670,6 @@ static inline bool radix_tree_shrink(struct radix_tree_root *root,
 		node->count = 0;
 		if (!radix_tree_is_internal_node(child)) {
 			node->slots[0] = (void __rcu *)RADIX_TREE_RETRY;
-			if (update_node)
-				update_node(node);
 		}
 
 		WARN_ON_ONCE(!list_empty(&node->private_list));
@@ -684,8 +681,7 @@ static inline bool radix_tree_shrink(struct radix_tree_root *root,
 }
 
 static bool delete_node(struct radix_tree_root *root,
-			struct radix_tree_node *node,
-			radix_tree_update_node_t update_node)
+			struct radix_tree_node *node)
 {
 	bool deleted = false;
 
@@ -695,7 +691,7 @@ static bool delete_node(struct radix_tree_root *root,
 		if (node->count) {
 			if (node_to_entry(node) ==
 					rcu_dereference_raw(root->xa_head))
-				deleted |= radix_tree_shrink(root, update_node);
+				deleted |= radix_tree_shrink(root);
 			return deleted;
 		}
 
@@ -1100,15 +1096,13 @@ static int calculate_count(struct radix_tree_root *root,
  * @node:		pointer to tree node
  * @slot:		pointer to slot in @node
  * @item:		new item to store in the slot.
- * @update_node:	callback for changing leaf nodes
  *
  * For use with __radix_tree_lookup().  Caller must hold tree write locked
  * across slot lookup and replacement.
  */
 void __radix_tree_replace(struct radix_tree_root *root,
 			  struct radix_tree_node *node,
-			  void __rcu **slot, void *item,
-			  radix_tree_update_node_t update_node)
+			  void __rcu **slot, void *item)
 {
 	void *old = rcu_dereference_raw(*slot);
 	int values = !!xa_is_value(item) - !!xa_is_value(old);
@@ -1126,10 +1120,7 @@ void __radix_tree_replace(struct radix_tree_root *root,
 	if (!node)
 		return;
 
-	if (update_node)
-		update_node(node);
-
-	delete_node(root, node, update_node);
+	delete_node(root, node);
 }
 
 /**
@@ -1151,7 +1142,7 @@ void __radix_tree_replace(struct radix_tree_root *root,
 void radix_tree_replace_slot(struct radix_tree_root *root,
 			     void __rcu **slot, void *item)
 {
-	__radix_tree_replace(root, NULL, slot, item, NULL);
+	__radix_tree_replace(root, NULL, slot, item);
 }
 EXPORT_SYMBOL(radix_tree_replace_slot);
 
@@ -1168,7 +1159,7 @@ void radix_tree_iter_replace(struct radix_tree_root *root,
 				const struct radix_tree_iter *iter,
 				void __rcu **slot, void *item)
 {
-	__radix_tree_replace(root, iter->node, slot, item, NULL);
+	__radix_tree_replace(root, iter->node, slot, item);
 }
 
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
@@ -1848,23 +1839,6 @@ radix_tree_gang_lookup_tag_slot(const struct radix_tree_root *root,
 }
 EXPORT_SYMBOL(radix_tree_gang_lookup_tag_slot);
 
-/**
- *	__radix_tree_delete_node    -    try to free node after clearing a slot
- *	@root:		radix tree root
- *	@node:		node containing @index
- *	@update_node:	callback for changing leaf nodes
- *
- *	After clearing the slot at @index in @node from radix tree
- *	rooted at @root, call this function to attempt freeing the
- *	node and shrinking the tree.
- */
-void __radix_tree_delete_node(struct radix_tree_root *root,
-			      struct radix_tree_node *node,
-			      radix_tree_update_node_t update_node)
-{
-	delete_node(root, node, update_node);
-}
-
 static bool __radix_tree_delete(struct radix_tree_root *root,
 				struct radix_tree_node *node, void __rcu **slot)
 {
@@ -1880,7 +1854,7 @@ static bool __radix_tree_delete(struct radix_tree_root *root,
 			node_tag_clear(root, node, tag, offset);
 
 	replace_slot(slot, NULL, node, -1, values);
-	return node && delete_node(root, node, NULL);
+	return node && delete_node(root, node);
 }
 
 /**
diff --git a/tools/testing/radix-tree/multiorder.c b/tools/testing/radix-tree/multiorder.c
index c659056340df..fc7d0c4e812a 100644
--- a/tools/testing/radix-tree/multiorder.c
+++ b/tools/testing/radix-tree/multiorder.c
@@ -618,7 +618,7 @@ static void multiorder_account(void)
 	__radix_tree_insert(&tree, 1 << 5, 5, xa_mk_value(5));
 	__radix_tree_lookup(&tree, 1 << 5, &node, &slot);
 	assert(node->count == node->nr_values * 2);
-	__radix_tree_replace(&tree, node, slot, NULL, NULL);
+	__radix_tree_replace(&tree, node, slot, NULL);
 	assert(node->nr_values == 0);
 
 	item_kill_tree(&tree);
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
