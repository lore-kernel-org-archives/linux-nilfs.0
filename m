From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 62/63] radix tree: Remove
 radix_tree_update_node_t
Date: Sat, 14 Apr 2018 07:13:15 -0700
Message-ID: <20180414141316.7167-63-willy@infradead.org>
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
 bh=0fZ7cFUMPPNyZdmRxG4yRmTYMkPnmDcS8GQAgVZw524=; b=M+mpi5+Li0PM3h8zkhSTBWlXfu
 /HJIBsHQr+PaWx7UuLZc+izSbpZAfBFDpzhvG/lYXnZ1wAuiKWNtWyMMv8xQGbfcLkzTBEV/wZX7o
 Sa5WCbN/Uwaloo8hqCOmIDdrp9aY4o2DAnS/r/B8gNRCC2QJaI/3qs84KGveh46WzHu4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=0fZ7cFUMPPNyZdmRxG4yRmTYMkPnmDcS8GQAgVZw524=; b=TRG3ZRaNgePc7v2tGnIMRgECFv
 4dEW2lJfGyAgAyESvp4zun/uPAYL6BMJMwfO2OxVYWk9A8Qx8iaUis0aP/SeAC1JHhjXXWs6wjja/
 6eEjIPkBAbxELjsVkbWQX8VIdID99xtB9Mzla+yVNR9XnBHJDxG1juiyrZ6bJB1DjZus=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=0fZ7cFUMPPNyZdmRxG4yRmTYMkPnmDcS8GQAgVZw524=; b=EImI4SVepuFmc7gZVjxI+YTjV
 TnXw/jiZytPQaoyKk4PnPVn1UySf66hgmk/ChIGZJaypsyMDqKdbB9z2OwO3srpArKaGMsNLjkB5o
 vnv8Gq8EEJRQJl+QkqxEbPICP1bbBZjqMAaEkjEdeeB5gqP4tvMJ3NkJ8XviU4m67uJ/ZUNWniu+h
 SgRYxX4TVdJOBPKO+MBSZBY5hUTo2ztglwLCgtjgS0Qz5HVrRVN2yZp6m72zDECZKrNeAd+aOetR8
 WGJWFO7+HSgjlpEGUbqrNEQzmp+AGR6wBN7ACa710r/bFrkQ6hdrBdWv1A30uY380x8uB346tXlLS
 fQNlP0FLQ==;
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

The only user of this functionality was the page cache, and it's now
been converted to the XArray.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/radix-tree.h            |  4 +---
 lib/idr.c                             |  2 +-
 lib/radix-tree.c                      | 25 ++++++++-----------------
 tools/testing/radix-tree/multiorder.c |  2 +-
 4 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 3f0cecc6122c..ceff6856470a 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -245,10 +245,8 @@ void *__radix_tree_lookup(const struct radix_tree_root *, unsigned long index,
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
diff --git a/lib/idr.c b/lib/idr.c
index 696f9df87e4e..7d1e7a9f8702 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -304,7 +304,7 @@ void *idr_replace(struct idr *idr, void *ptr, unsigned long id)
 	if (!slot || radix_tree_tag_get(&idr->idr_rt, id, IDR_FREE))
 		return ERR_PTR(-ENOENT);
 
-	__radix_tree_replace(&idr->idr_rt, node, slot, ptr, NULL);
+	__radix_tree_replace(&idr->idr_rt, node, slot, ptr);
 
 	return entry;
 }
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 5a1f2b052194..f15b9ee000b8 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -540,8 +540,7 @@ static int radix_tree_extend(struct radix_tree_root *root, gfp_t gfp,
  *	radix_tree_shrink    -    shrink radix tree to minimum height
  *	@root		radix tree root
  */
-static inline bool radix_tree_shrink(struct radix_tree_root *root,
-				     radix_tree_update_node_t update_node)
+static inline bool radix_tree_shrink(struct radix_tree_root *root)
 {
 	bool shrunk = false;
 
@@ -601,8 +600,6 @@ static inline bool radix_tree_shrink(struct radix_tree_root *root,
 		node->count = 0;
 		if (!radix_tree_is_internal_node(child)) {
 			node->slots[0] = (void __rcu *)RADIX_TREE_RETRY;
-			if (update_node)
-				update_node(node);
 		}
 
 		WARN_ON_ONCE(!list_empty(&node->private_list));
@@ -614,8 +611,7 @@ static inline bool radix_tree_shrink(struct radix_tree_root *root,
 }
 
 static bool delete_node(struct radix_tree_root *root,
-			struct radix_tree_node *node,
-			radix_tree_update_node_t update_node)
+			struct radix_tree_node *node)
 {
 	bool deleted = false;
 
@@ -625,7 +621,7 @@ static bool delete_node(struct radix_tree_root *root,
 		if (node->count) {
 			if (node_to_entry(node) ==
 					rcu_dereference_raw(root->xa_head))
-				deleted |= radix_tree_shrink(root, update_node);
+				deleted |= radix_tree_shrink(root);
 			return deleted;
 		}
 
@@ -1030,15 +1026,13 @@ static int calculate_count(struct radix_tree_root *root,
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
@@ -1056,10 +1050,7 @@ void __radix_tree_replace(struct radix_tree_root *root,
 	if (!node)
 		return;
 
-	if (update_node)
-		update_node(node);
-
-	delete_node(root, node, update_node);
+	delete_node(root, node);
 }
 
 /**
@@ -1081,7 +1072,7 @@ void __radix_tree_replace(struct radix_tree_root *root,
 void radix_tree_replace_slot(struct radix_tree_root *root,
 			     void __rcu **slot, void *item)
 {
-	__radix_tree_replace(root, NULL, slot, item, NULL);
+	__radix_tree_replace(root, NULL, slot, item);
 }
 EXPORT_SYMBOL(radix_tree_replace_slot);
 
@@ -1098,7 +1089,7 @@ void radix_tree_iter_replace(struct radix_tree_root *root,
 				const struct radix_tree_iter *iter,
 				void __rcu **slot, void *item)
 {
-	__radix_tree_replace(root, iter->node, slot, item, NULL);
+	__radix_tree_replace(root, iter->node, slot, item);
 }
 
 static void node_tag_set(struct radix_tree_root *root,
@@ -1648,7 +1639,7 @@ static bool __radix_tree_delete(struct radix_tree_root *root,
 			node_tag_clear(root, node, tag, offset);
 
 	replace_slot(slot, NULL, node, -1, values);
-	return node && delete_node(root, node, NULL);
+	return node && delete_node(root, node);
 }
 
 /**
diff --git a/tools/testing/radix-tree/multiorder.c b/tools/testing/radix-tree/multiorder.c
index 146b490d5823..26212bd33c9d 100644
--- a/tools/testing/radix-tree/multiorder.c
+++ b/tools/testing/radix-tree/multiorder.c
@@ -372,7 +372,7 @@ static void multiorder_account(void)
 	__radix_tree_insert(&tree, 1 << 5, 5, xa_mk_value(5));
 	__radix_tree_lookup(&tree, 1 << 5, &node, &slot);
 	assert(node->count == node->nr_values * 2);
-	__radix_tree_replace(&tree, node, slot, NULL, NULL);
+	__radix_tree_replace(&tree, node, slot, NULL);
 	assert(node->nr_values == 0);
 
 	item_kill_tree(&tree);
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
