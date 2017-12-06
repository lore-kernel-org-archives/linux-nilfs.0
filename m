From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v4 67/73] vmalloc: Convert to XArray
Date: Tue,  5 Dec 2017 16:41:53 -0800
Message-ID: <20171206004159.3755-68-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RKZQGpmQNKayCSkcAjk2A5OsPf6EdyX1MOKO23TZbVY=; b=k6U0wYBMKxvqE3GBVB4fjcckD
        RS/z5rWEPhFLfirQYHExMQBsAtEOCpGdvtOM9k0OKid9PL+fcOefbpeEVDMQM4Bhha1Hb1gVq6JUw
        WeMdEcxenL1No3T4LOnLvYxyCm6IJhanV/0sIDvaRJaEQK1h9g/p08Jf/4Gtg8enfkKCM78c1ncEw
        WFUFdjx3vtWoTA+aAqLBy17z+IqDFNUD+fGVKFqvTEV8Uco04ivzTdohT9jm96mVx22+3ZQqhCr9U
        tvCUdZY972gnMNbNOJuWM5QbDwKIxqrOynRGPTUyN7h7w4r4+Q7hNcrC6ZQrEUuWXRx7SPShW7NYz
    
In-Reply-To: <20171206004159.3755-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

The radix tree of vmap blocks is simpler to express as an XArray.
Saves a couple of hundred bytes of text and eliminates a user of the
radix tree preload API.

Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 mm/vmalloc.c | 39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 673942094328..3a46efc27525 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -23,7 +23,7 @@
 #include <linux/list.h>
 #include <linux/notifier.h>
 #include <linux/rbtree.h>
-#include <linux/radix-tree.h>
+#include <linux/xarray.h>
 #include <linux/rcupdate.h>
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
@@ -821,12 +821,11 @@ struct vmap_block {
 static DEFINE_PER_CPU(struct vmap_block_queue, vmap_block_queue);
 
 /*
- * Radix tree of vmap blocks, indexed by address, to quickly find a vmap block
+ * XArray of vmap blocks, indexed by address, to quickly find a vmap block
  * in the free path. Could get rid of this if we change the API to return a
  * "cookie" from alloc, to be passed to free. But no big deal yet.
  */
-static DEFINE_SPINLOCK(vmap_block_tree_lock);
-static RADIX_TREE(vmap_block_tree, GFP_ATOMIC);
+static DEFINE_XARRAY(vmap_block_tree);
 
 /*
  * We should probably have a fallback mechanism to allocate virtual memory
@@ -865,8 +864,8 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 	struct vmap_block *vb;
 	struct vmap_area *va;
 	unsigned long vb_idx;
-	int node, err;
-	void *vaddr;
+	int node;
+	void *ret, *vaddr;
 
 	node = numa_node_id();
 
@@ -883,13 +882,6 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 		return ERR_CAST(va);
 	}
 
-	err = radix_tree_preload(gfp_mask);
-	if (unlikely(err)) {
-		kfree(vb);
-		free_vmap_area(va);
-		return ERR_PTR(err);
-	}
-
 	vaddr = vmap_block_vaddr(va->va_start, 0);
 	spin_lock_init(&vb->lock);
 	vb->va = va;
@@ -902,11 +894,12 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 	INIT_LIST_HEAD(&vb->free_list);
 
 	vb_idx = addr_to_vb_idx(va->va_start);
-	spin_lock(&vmap_block_tree_lock);
-	err = radix_tree_insert(&vmap_block_tree, vb_idx, vb);
-	spin_unlock(&vmap_block_tree_lock);
-	BUG_ON(err);
-	radix_tree_preload_end();
+	ret = xa_store(&vmap_block_tree, vb_idx, vb, gfp_mask);
+	if (IS_ERR(ret)) {
+		kfree(vb);
+		free_vmap_area(va);
+		return ret;
+	}
 
 	vbq = &get_cpu_var(vmap_block_queue);
 	spin_lock(&vbq->lock);
@@ -923,9 +916,7 @@ static void free_vmap_block(struct vmap_block *vb)
 	unsigned long vb_idx;
 
 	vb_idx = addr_to_vb_idx(vb->va->va_start);
-	spin_lock(&vmap_block_tree_lock);
-	tmp = radix_tree_delete(&vmap_block_tree, vb_idx);
-	spin_unlock(&vmap_block_tree_lock);
+	tmp = xa_erase(&vmap_block_tree, vb_idx);
 	BUG_ON(tmp != vb);
 
 	free_vmap_area_noflush(vb->va);
@@ -1031,7 +1022,6 @@ static void *vb_alloc(unsigned long size, gfp_t gfp_mask)
 static void vb_free(const void *addr, unsigned long size)
 {
 	unsigned long offset;
-	unsigned long vb_idx;
 	unsigned int order;
 	struct vmap_block *vb;
 
@@ -1045,10 +1035,7 @@ static void vb_free(const void *addr, unsigned long size)
 	offset = (unsigned long)addr & (VMAP_BLOCK_SIZE - 1);
 	offset >>= PAGE_SHIFT;
 
-	vb_idx = addr_to_vb_idx((unsigned long)addr);
-	rcu_read_lock();
-	vb = radix_tree_lookup(&vmap_block_tree, vb_idx);
-	rcu_read_unlock();
+	vb = xa_load(&vmap_block_tree, addr_to_vb_idx((unsigned long)addr));
 	BUG_ON(!vb);
 
 	vunmap_page_range((unsigned long)addr, (unsigned long)addr + size);
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
