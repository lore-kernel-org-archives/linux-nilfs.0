From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v4 12/73] xarray: Add xa_cmpxchg
Date: Tue,  5 Dec 2017 16:40:58 -0800
Message-ID: <20171206004159.3755-13-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7gmPfR6sEN3OZqX34LT7hoRjNs5dFLccOVO1jiX2ybk=; b=Q7b/BXhwjOPDVvNvoSsSdl3kH
        cgP2iOXmrKuFru5azsPN/+memUMyG9o67IiEudy0QCEE299tu7aPwJuKOrczDupFJHoLLD6bY21Vq
        7KpsEZFr6/ZG8EWWqVD0dIORnILkKqLIs/TACVa1ky1+6JQVYGHuT1zEzR67wxVdO2/FsNNhrOgab
        Gu28u5hkRTTxhaBcTa5fv61Vo4MN8I4SZ+dQ2bUaEdSKbM82tLY06mMhhihioKzmHWHwUw6DOTNvg
        Vo03QEWNmN20bNGbgsahBZTr7Pne1E1P3Aa2nRcDdD/NP27hkk4TlLqZTVLEDSlRMgKGOx1hbUe6O
    
In-Reply-To: <20171206004159.3755-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

This works like doing cmpxchg() on an array entry.  Code which wants
the radix_tree_insert() semantic of not overwriting an existing entry
can cmpxchg() with NULL and get the action it wants.  Plus, instead of
having an error returned, they get the value currently stored in the
array, which often saves them a subsequent lookup.

Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 include/linux/xarray.h |  2 ++
 lib/xarray.c           | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 6f1f55d9fc94..a570d7d9a252 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -72,6 +72,8 @@ static inline void xa_init(struct xarray *xa)
 
 void *xa_load(struct xarray *, unsigned long index);
 void *xa_store(struct xarray *, unsigned long index, void *entry, gfp_t);
+void *xa_cmpxchg(struct xarray *, unsigned long index,
+			void *old, void *entry, gfp_t);
 
 /**
  * xa_erase() - Erase this entry from the XArray.
diff --git a/lib/xarray.c b/lib/xarray.c
index fbbb02c25b6d..6625b1763123 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -852,6 +852,43 @@ void *xa_store(struct xarray *xa, unsigned long index, void *entry, gfp_t gfp)
 }
 EXPORT_SYMBOL(xa_store);
 
+/**
+ * xa_cmpxchg() - Conditionally replace an entry in the XArray.
+ * @xa: XArray.
+ * @index: Index into array.
+ * @old: Old value to test against.
+ * @entry: New value to place in array.
+ * @gfp: Allocation flags.
+ *
+ * If the entry at @index is the same as @old, replace it with @entry.
+ * If the return value is equal to @old, then the exchange was successful.
+ *
+ * Return: The old value at this index or ERR_PTR() if an error happened.
+ */
+void *xa_cmpxchg(struct xarray *xa, unsigned long index,
+			void *old, void *entry, gfp_t gfp)
+{
+	XA_STATE(xas, xa, index);
+	unsigned long flags;
+	void *curr;
+
+	if (WARN_ON_ONCE(xa_is_internal(entry)))
+		return ERR_PTR(-EINVAL);
+
+	do {
+		xa_lock_irqsave(xa, flags);
+		curr = xas_create(&xas);
+		if (curr == old)
+			xas_store(&xas, entry);
+		xa_unlock_irqrestore(xa, flags);
+	} while (xas_nomem(&xas, gfp));
+
+	if (xas_error(&xas))
+		curr = ERR_PTR(xas_error(&xas));
+	return curr;
+}
+EXPORT_SYMBOL(xa_cmpxchg);
+
 /**
  * __xa_set_tag() - Set this tag on this entry while locked.
  * @xa: XArray.
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
