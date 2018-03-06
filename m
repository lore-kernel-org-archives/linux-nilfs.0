From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 02/63] radix tree: Use GFP_ZONEMASK bits of gfp_t for flags
Date: Tue,  6 Mar 2018 11:23:12 -0800
Message-ID: <20180306192413.5499-3-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=f0mFIbZmdawc5WccDIk+eKJwMZ3Sl+TFjGUFpf23LaU=; b=L50EJjmxCJwUUumu46EORQ6IE
        SjCpOjj6blYYU3wDz9f6Qlj074XkROE/b/RgJykaL7H2PE2Y99B1yFnO1qSyIlh07d9gEfkXE2Zle
        kqV3SvwL4dAWtiMJC6kldMfe4TDI9EDkq5T0K2pCnreby3pHWn421/pHFeOgpsdST0I0DNjjFVqnX
        fQvVr1qdsaM8SYDN4Pf+FQjK0TBC7Vko/iNTPGgr2nV3+YhCNG87CaGQ4kAr1ya916IThbqL50W5/
        nyfVwtZI2XBNel8xVO18tqsZtBBER2U/PK1ukDkjwqLN3lhcaVSLIWaQqXK7oSI2uQt2FZHtt1Rlr
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

None of these bits may be used for slab allocations, so we can use them
as radix tree flags as long as we mask them off before passing them
to the slab allocator.  Move the IDR flag from the high bits to the
GFP_ZONEMASK bits.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/idr.h                  | 3 ++-
 include/linux/radix-tree.h           | 7 ++++---
 lib/radix-tree.c                     | 3 ++-
 tools/testing/radix-tree/linux/gfp.h | 1 +
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 7d6a6313f0ab..913c335054f0 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -29,7 +29,8 @@ struct idr {
 #define IDR_FREE	0
 
 /* Set the IDR flag and the IDR_FREE tag */
-#define IDR_RT_MARKER		((__force gfp_t)(3 << __GFP_BITS_SHIFT))
+#define IDR_RT_MARKER	(ROOT_IS_IDR | (__force gfp_t)			\
+					(1 << (ROOT_TAG_SHIFT + IDR_FREE)))
 
 #define IDR_INIT_BASE(base) {						\
 	.idr_rt = RADIX_TREE_INIT(IDR_RT_MARKER),			\
diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index fc55ff31eca7..6c4e2e716dac 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -104,9 +104,10 @@ struct radix_tree_node {
 	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
 };
 
-/* The top bits of gfp_mask are used to store the root tags and the IDR flag */
-#define ROOT_IS_IDR	((__force gfp_t)(1 << __GFP_BITS_SHIFT))
-#define ROOT_TAG_SHIFT	(__GFP_BITS_SHIFT + 1)
+/* The IDR tag is stored in the low bits of the GFP flags */
+#define ROOT_IS_IDR	((__force gfp_t)4)
+/* The top bits of gfp_mask are used to store the root tags */
+#define ROOT_TAG_SHIFT	(__GFP_BITS_SHIFT)
 
 struct radix_tree_root {
 	gfp_t			gfp_mask;
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 8e00138d593f..da9e10c827df 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -146,7 +146,7 @@ static unsigned int radix_tree_descend(const struct radix_tree_node *parent,
 
 static inline gfp_t root_gfp_mask(const struct radix_tree_root *root)
 {
-	return root->gfp_mask & __GFP_BITS_MASK;
+	return root->gfp_mask & (__GFP_BITS_MASK & ~GFP_ZONEMASK);
 }
 
 static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
@@ -2285,6 +2285,7 @@ void __init radix_tree_init(void)
 	int ret;
 
 	BUILD_BUG_ON(RADIX_TREE_MAX_TAGS + __GFP_BITS_SHIFT > 32);
+	BUILD_BUG_ON(ROOT_IS_IDR & ~GFP_ZONEMASK);
 	radix_tree_node_cachep = kmem_cache_create("radix_tree_node",
 			sizeof(struct radix_tree_node), 0,
 			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
diff --git a/tools/testing/radix-tree/linux/gfp.h b/tools/testing/radix-tree/linux/gfp.h
index e3201ccf54c3..32159c08a52e 100644
--- a/tools/testing/radix-tree/linux/gfp.h
+++ b/tools/testing/radix-tree/linux/gfp.h
@@ -19,6 +19,7 @@
 
 #define __GFP_RECLAIM	(__GFP_DIRECT_RECLAIM|__GFP_KSWAPD_RECLAIM)
 
+#define GFP_ZONEMASK	0x0fu
 #define GFP_ATOMIC	(__GFP_HIGH|__GFP_ATOMIC|__GFP_KSWAPD_RECLAIM)
 #define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
 #define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM)
-- 
2.16.1

