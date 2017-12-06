From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v4 07/73] xarray: Define struct xa_node
Date: Tue,  5 Dec 2017 16:40:53 -0800
Message-ID: <20171206004159.3755-8-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dQ1NqeA8wp9BmB63zj4IbtPPfSrTf5alzJbwxSnBm6U=; b=dwvUqh1l0tzKS2LMfNnrdT2D+
        60lAJH2ZdbngxAol4lwhQbnCi2RuT5wqeHrSl2YKFor+IvdpvWvoH2oiqo7juI7o9xwsSv3CbYcfu
        5UEzfbNBL2fVEqe7BPLpuu02Tm5es4yO6xKwoEECcTUOVWjOAdkAm7fKbHyJrAEhyseIfiibPLLQz
        xwM9E3hJ2WTarlueBTCPuiBjvo6r0nytJlNixyUjfxXMD0Zr6w6umonBTRuC1sLU2ba2pWXWpBeIv
        zpziM77Qhn64y+mNfabl3C1dmqmWOCYV0sZ2B0/uhebUTZyhZdCgR/gnhptz27tFeqT6tzRM+3t/T
    
In-Reply-To: <20171206004159.3755-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

This is a direct replacement for struct radix_tree_node.  Use a #define
so that radix tree users continue to work without change.

Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 include/linux/radix-tree.h | 29 +++--------------------------
 include/linux/xarray.h     | 24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index f31a278de8eb..f46e3de57115 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -32,6 +32,7 @@
 
 /* Keep unconverted code working */
 #define radix_tree_root		xarray
+#define radix_tree_node		xa_node
 
 /*
  * The bottom two bits of the slot determine how the remaining bits in the
@@ -60,41 +61,17 @@ static inline bool radix_tree_is_internal_node(void *ptr)
 
 /*** radix-tree API starts here ***/
 
-#define RADIX_TREE_MAX_TAGS 3
-
 #define RADIX_TREE_MAP_SHIFT	XA_CHUNK_SHIFT
 #define RADIX_TREE_MAP_SIZE	(1UL << RADIX_TREE_MAP_SHIFT)
 #define RADIX_TREE_MAP_MASK	(RADIX_TREE_MAP_SIZE-1)
 
-#define RADIX_TREE_TAG_LONGS	\
-	((RADIX_TREE_MAP_SIZE + BITS_PER_LONG - 1) / BITS_PER_LONG)
+#define RADIX_TREE_MAX_TAGS	XA_MAX_TAGS
+#define RADIX_TREE_TAG_LONGS	XA_TAG_LONGS
 
 #define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
 #define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
 					  RADIX_TREE_MAP_SHIFT))
 
-/*
- * @count is the count of every non-NULL element in the ->slots array
- * whether that is a data entry, a retry entry, a user pointer,
- * a sibling entry or a pointer to the next level of the tree.
- * @exceptional is the count of every element in ->slots which is
- * either a data entry or a sibling entry for data.
- */
-struct radix_tree_node {
-	unsigned char	shift;		/* Bits remaining in each slot */
-	unsigned char	offset;		/* Slot offset in parent */
-	unsigned char	count;		/* Total entry count */
-	unsigned char	exceptional;	/* Exceptional entry count */
-	struct radix_tree_node *parent;		/* Used when ascending tree */
-	struct radix_tree_root *root;		/* The tree we belong to */
-	union {
-		struct list_head private_list;	/* For tree user */
-		struct rcu_head	rcu_head;	/* Used when freeing node */
-	};
-	void __rcu	*slots[RADIX_TREE_MAP_SIZE];
-	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
-};
-
 /* The top bits of xa_flags are used to store the root tags and the IDR flag */
 #define ROOT_IS_IDR	((__force gfp_t)(1 << __GFP_BITS_SHIFT))
 #define ROOT_TAG_SHIFT	(__GFP_BITS_SHIFT + 1)
diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index dcdac2053ea6..1aff0069458b 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -133,6 +133,30 @@ static inline bool xa_is_value(void *entry)
 #endif
 #define XA_CHUNK_SIZE		(1UL << XA_CHUNK_SHIFT)
 #define XA_CHUNK_MASK		(XA_CHUNK_SIZE - 1)
+#define XA_MAX_TAGS		3
+#define XA_TAG_LONGS		DIV_ROUND_UP(XA_CHUNK_SIZE, BITS_PER_LONG)
+
+/*
+ * @count is the count of every non-NULL element in the ->slots array
+ * whether that is a data value entry, a retry entry, a user pointer,
+ * a sibling entry or a pointer to the next level of the tree.
+ * @exceptional is the count of every element in ->slots which is
+ * either a data value entry or a sibling entry for a data value.
+ */
+struct xa_node {
+	unsigned char	shift;		/* Bits remaining in each slot */
+	unsigned char	offset;		/* Slot offset in parent */
+	unsigned char	count;		/* Total entry count */
+	unsigned char	exceptional;	/* Exceptional entry count */
+	struct xa_node *parent;		/* Used when ascending tree */
+	struct xarray *	root;		/* The tree we belong to */
+	union {
+		struct list_head private_list;	/* For tree user */
+		struct rcu_head	rcu_head;	/* Used when freeing node */
+	};
+	void __rcu	*slots[XA_CHUNK_SIZE];
+	unsigned long	tags[XA_MAX_TAGS][XA_TAG_LONGS];
+};
 
 /*
  * Internal entries have the bottom two bits set to the value 10b.  Most
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
