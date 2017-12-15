From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 13/78] xarray: Add xa_cmpxchg
Date: Fri, 15 Dec 2017 14:03:45 -0800
Message-ID: <20171215220450.7899-14-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
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
 bh=bPInS0mdJcIklE9LE5q9S3CpTS2pu9XpJMN63/RdUtU=; b=jMk1E0paxGQF1whmynX7AOO2f2
 55cvg3WPnjXfr5+eTrgZxneb5ARARUFnIuE1Ap7NCCOnkz9hFY6zCu6ZcBlfmTs6sMUhTXvV3bdHv
 V0pp/k2uYBLnm2znNq6YpfIIp0HHs2AQfT107UpUtrZAD91M/TJKkb+MmRfogD59mt/A=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=bPInS0mdJcIklE9LE5q9S3CpTS2pu9XpJMN63/RdUtU=; b=hJ0jUYUkL3JW3hH7Dpr9WVzQpU
 BYoWEp4S24beJDbCLpcJhkcmJJ70ndksLESN1zQrb6ysa85+x7OdUWjYDCq3rxeUHaH5K0DXQ8M1n
 S/Z2sxFg3b+qRwK8wOllPRvztReO7xSfUGTFk+lGiv+q6G0Uyf9lnwZqrxp8zJktbYeI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=bPInS0mdJcIklE9LE5q9S3CpTS2pu9XpJMN63/RdUtU=; b=Ty16q4OnnHLpfoxr6JR1iHxXG
 GByl6BtfYEnagtapgGvInN4WIxCne3Lze7C2c4FGTskAmfjSFcTDb2ZIjMnaU1OOn3DhFZ1WHzazA
 f361gqkcTorj2awYHwRfDnS0aEv99WjT0WHeNzRCXkXMzUetNIaWO+KlFCqlovjJX/u+kwRKWXSrD
 BIIoqztdjrr+6Go1IQuuutFS0nYZzmus8H0sJezeYETgg3Qnse0Ld3u3GvV6JA1F432vnfpSe567T
 RYDGX3QSvcAzTULPTCg+B5MFp7hgK3VIGXcpOKebEq6o9F6hjbc9xWvhiqpfA80t0EObvdengd94t
 TKwlFKgww==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This works like doing cmpxchg() on an array entry.  Code which wants
the radix_tree_insert() semantic of not overwriting an existing entry
can cmpxchg() with NULL and get the action it wants.  Plus, instead of
having an error returned, they get the value currently stored in the
array, which often saves them a subsequent lookup.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h | 33 +++++++++++++++++++++++++
 lib/xarray.c           | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 05873095bc7f..56db23edac82 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -75,6 +75,8 @@ static inline void xa_init(struct xarray *xa)
 
 void *xa_load(struct xarray *, unsigned long index);
 void *xa_store(struct xarray *, unsigned long index, void *entry, gfp_t);
+void *xa_cmpxchg(struct xarray *, unsigned long index,
+			void *old, void *entry, gfp_t);
 
 /**
  * xa_erase() - Erase this entry from the XArray.
@@ -216,6 +218,32 @@ static inline int xa_err(void *entry)
 	return 0;
 }
 
+/**
+ * xa_store_empty() - Store this entry in the XArray unless another entry is
+ * 			already present.
+ * @xa: XArray.
+ * @index: Index into array.
+ * @entry: New entry.
+ * @gfp: Memory allocation flags.
+ *
+ * If you would rather see the existing entry in the array, use xa_cmpxchg().
+ * This function is for users who don't care what the entry is, only that
+ * one is present.
+ *
+ * Return: -EEXIST if another entry was present, 0 if the store succeeded,
+ * or another negative errno if a different error happened (eg -ENOMEM).
+ */
+static inline int xa_store_empty(struct xarray *xa, unsigned long index,
+		void *entry, gfp_t gfp)
+{
+	void *curr = xa_cmpxchg(xa, index, NULL, entry, gfp);
+	if (!curr)
+		return 0;
+	if (xa_is_err(curr))
+		return xa_err(curr);
+	return -EEXIST;
+}
+
 #define xa_trylock(xa)		spin_trylock(&(xa)->xa_lock)
 #define xa_lock(xa)		spin_lock(&(xa)->xa_lock)
 #define xa_unlock(xa)		spin_unlock(&(xa)->xa_lock)
@@ -242,9 +270,14 @@ enum xa_ctx {
 void *__xa_erase(struct xarray *, unsigned long index);
 void *___xa_store(struct xarray *, unsigned long index,
 		void *entry, gfp_t, enum xa_ctx);
+void *___xa_cmpxchg(struct xarray *, unsigned long index, void *old,
+		void *entry, gfp_t, enum xa_ctx);
 #define __xa_store(x, i, e, g)		___xa_store(x, i, e, g, XA_CTX_PRC)
 #define __xa_store_bh(x, i, e, g)	___xa_store(x, i, e, g, XA_CTX_BH)
 #define __xa_store_irq(x, i, e, g)	___xa_store(x, i, e, g, XA_CTX_IRQ)
+#define __xa_cmpxchg(x, i, o, e, g)	___xa_cmpxchg(x, i, o, e, g, XA_CTX_PRC)
+#define __xa_cmpxchg_bh(x, i, o, e, g)	___xa_cmpxchg(x, i, o, e, g, XA_CTX_BH)
+#define __xa_cmpxchg_irq(x, i, o, e, g) ___xa_cmpxchg(x, i, o, e, g, XA_CTX_IRQ)
 void __xa_set_tag(struct xarray *, unsigned long index, xa_tag_t);
 void __xa_clear_tag(struct xarray *, unsigned long index, xa_tag_t);
 
diff --git a/lib/xarray.c b/lib/xarray.c
index 64f88ce23392..ef3340471e5c 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -921,6 +921,71 @@ void *___xa_store(struct xarray *xa, unsigned long index, void *entry,
 }
 EXPORT_SYMBOL(___xa_store);
 
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
+ * Return: The old value at this index or xa_err() if an error happened.
+ */
+void *xa_cmpxchg(struct xarray *xa, unsigned long index,
+			void *old, void *entry, gfp_t gfp)
+{
+	XA_STATE(xas, xa, index);
+	void *curr;
+
+	if (WARN_ON_ONCE(xa_is_internal(entry)))
+		return XA_ERROR(-EINVAL);
+
+	do {
+		xas_lock(&xas);
+		curr = xas_create(&xas);
+		if (curr == old)
+			xas_store(&xas, entry);
+		xas_unlock(&xas);
+	} while (xas_nomem(&xas, gfp));
+
+	return xas_result(&xas, curr);
+}
+EXPORT_SYMBOL(xa_cmpxchg);
+
+/*
+ * ___xa_cmpxchg() - Store this entry in the XArray.
+ * @xa: XArray.
+ * @index: Index into array.
+ * @entry: New entry.
+ * @gfp: Allocation flags.
+ * @lock_type: Lock acquisition type.
+ *
+ * Internal implementation detail.
+ *
+ * Return: The old entry at this index or xa_err() if an error happened.
+ */
+void *___xa_cmpxchg(struct xarray *xa, unsigned long index,
+			void *old, void *entry, gfp_t gfp, enum xa_ctx ctx)
+{
+	XA_STATE(xas, xa, index);
+	void *curr;
+
+	if (WARN_ON_ONCE(xa_is_internal(entry)))
+		return XA_ERROR(-EINVAL);
+
+	do {
+		curr = xas_create(&xas);
+		if (curr == old)
+			xas_store(&xas, entry);
+	} while (__xas_nomem(&xas, gfp, ctx));
+
+	return xas_result(&xas, curr);
+}
+EXPORT_SYMBOL(___xa_cmpxchg);
+
 /**
  * __xa_set_tag() - Set this tag on this entry while locked.
  * @xa: XArray.
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
