From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 73/74] radix tree: Remove radix_tree_maybe_preload_order
Date: Sat, 16 Jun 2018 19:00:51 -0700
Message-ID: <20180617020052.4759-74-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jpDj55nnZzY2oE988t2G5k90VBDDvIKhi51+JUE9KDc=; b=kUSPEDR2TlIhlWmySWpHHeDzy
        PrXOpZ1y64bTep41fvjcaw69gAk7haVv5SP+XdJEBLKXFrpSokGi4njzrXOp2tDSsAtAbFdDX3tva
        NO+QmUa+SbuXjy2Ngr+OgPcgKogHHaVR+Ai7ZoNy3SYxneT0Fr7nIyPhXQKY6trKeqTIESAsHZ9T4
        wI2EZglfKrTfZwkmSzSM+Pxi3gpe95l84KZAfTnw2+ETh/ECTNDxjSaGJHUgramqS3kSRYFHbTFMd
        lCwHjtxPdDuDt5p9rRQYxFTWU2ccjWpliUM75gBenJzq1k+6oT7orDktacMlYhvthZxTOo5pJkpUi
    
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net

This function was only used by the page cache which is now converted
to the XArray.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 include/linux/radix-tree.h |  1 -
 lib/radix-tree.c           | 74 --------------------------------------
 2 files changed, 75 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index b882d644cc47..f8ef267e4975 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -259,7 +259,6 @@ unsigned int radix_tree_gang_lookup(const struct radix_tree_root *,
 			unsigned int max_items);
 int radix_tree_preload(gfp_t gfp_mask);
 int radix_tree_maybe_preload(gfp_t gfp_mask);
-int radix_tree_maybe_preload_order(gfp_t gfp_mask, int order);
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *,
 			unsigned long index, unsigned int tag);
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index c472ceeb6a97..ad03dc0c562f 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -41,9 +41,6 @@
 #include <linux/xarray.h>
 
 
-/* Number of nodes in fully populated tree of given height */
-static unsigned long height_to_maxnodes[RADIX_TREE_MAX_PATH + 1] __read_mostly;
-
 /*
  * Radix tree node cache.
  */
@@ -463,51 +460,6 @@ int radix_tree_maybe_preload(gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(radix_tree_maybe_preload);
 
-/*
- * The same as function above, but preload number of nodes required to insert
- * (1 << order) continuous naturally-aligned elements.
- */
-int radix_tree_maybe_preload_order(gfp_t gfp_mask, int order)
-{
-	unsigned long nr_subtrees;
-	int nr_nodes, subtree_height;
-
-	/* Preloading doesn't help anything with this gfp mask, skip it */
-	if (!gfpflags_allow_blocking(gfp_mask)) {
-		preempt_disable();
-		return 0;
-	}
-
-	/*
-	 * Calculate number and height of fully populated subtrees it takes to
-	 * store (1 << order) elements.
-	 */
-	nr_subtrees = 1 << order;
-	for (subtree_height = 0; nr_subtrees > RADIX_TREE_MAP_SIZE;
-			subtree_height++)
-		nr_subtrees >>= RADIX_TREE_MAP_SHIFT;
-
-	/*
-	 * The worst case is zero height tree with a single item at index 0 and
-	 * then inserting items starting at ULONG_MAX - (1 << order).
-	 *
-	 * This requires RADIX_TREE_MAX_PATH nodes to build branch from root to
-	 * 0-index item.
-	 */
-	nr_nodes = RADIX_TREE_MAX_PATH;
-
-	/* Plus branch to fully populated subtrees. */
-	nr_nodes += RADIX_TREE_MAX_PATH - subtree_height;
-
-	/* Root node is shared. */
-	nr_nodes--;
-
-	/* Plus nodes required to build subtrees. */
-	nr_nodes += nr_subtrees * height_to_maxnodes[subtree_height];
-
-	return __radix_tree_preload(gfp_mask, nr_nodes);
-}
-
 static unsigned radix_tree_load_root(const struct radix_tree_root *root,
 		struct radix_tree_node **nodep, unsigned long *maxindex)
 {
@@ -1928,31 +1880,6 @@ radix_tree_node_ctor(void *arg)
 	INIT_LIST_HEAD(&node->private_list);
 }
 
-static __init unsigned long __maxindex(unsigned int height)
-{
-	unsigned int width = height * RADIX_TREE_MAP_SHIFT;
-	int shift = RADIX_TREE_INDEX_BITS - width;
-
-	if (shift < 0)
-		return ~0UL;
-	if (shift >= BITS_PER_LONG)
-		return 0UL;
-	return ~0UL >> shift;
-}
-
-static __init void radix_tree_init_maxnodes(void)
-{
-	unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH + 1];
-	unsigned int i, j;
-
-	for (i = 0; i < ARRAY_SIZE(height_to_maxindex); i++)
-		height_to_maxindex[i] = __maxindex(i);
-	for (i = 0; i < ARRAY_SIZE(height_to_maxnodes); i++) {
-		for (j = i; j > 0; j--)
-			height_to_maxnodes[i] += height_to_maxindex[j - 1] + 1;
-	}
-}
-
 static int radix_tree_cpu_dead(unsigned int cpu)
 {
 	struct radix_tree_preload *rtp;
@@ -1982,7 +1909,6 @@ void __init radix_tree_init(void)
 			sizeof(struct radix_tree_node), 0,
 			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
 			radix_tree_node_ctor);
-	radix_tree_init_maxnodes();
 	ret = cpuhp_setup_state_nocalls(CPUHP_RADIX_DEAD, "lib/radix:dead",
 					NULL, radix_tree_cpu_dead);
 	WARN_ON(ret < 0);
-- 
2.17.1

