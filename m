From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 16/72] xarray: Add xas_for_each_conflict
Date: Mon, 11 Jun 2018 07:05:43 -0700
Message-ID: <20180611140639.17215-17-willy@infradead.org>
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
 bh=/OXuoNN01nhzSTU6HgfbvZIzFPLZd+W81a8DkuntQPA=; b=ATDU1fY2JyHKJv/TpmzrHXAH6g
 rAnyn89FGf2UwQ19qHtTvvG6hj4fhZVJLFojTI+3GNE5I06IOeEG3KP1SaixuwhQWMhEaF58Ggr0p
 KcwU9co5MMsAvW8OR0pfhwamzQMfhw9XQKZxENh1xoV7aOWKhlwsj5H0tlIquUfHNV0I=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=/OXuoNN01nhzSTU6HgfbvZIzFPLZd+W81a8DkuntQPA=; b=MSyH5fAMCplcG413e7RHW80mWT
 6OqhqUa+k2XQfA9HwNBza7Df0XlgQ23Srt8Aogooa+L4bR4p4wtjE6dcwMxMIh8rIn9GNdLMA7gdY
 tjcujXpVQUROzNYH1IaXnKuB6+Oc4e/1jCB6dlERoXKBEze8FQz9zpeiQMMKNGk0pYxI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=/OXuoNN01nhzSTU6HgfbvZIzFPLZd+W81a8DkuntQPA=; b=fhCmjc0sb8KAhLmuFlr1+POvw
 Jq1LGFUkBThFZymX5NjKJX/mXAMHpuFoYgS8xF5DFQ4OrZmlNn0jqUtO9Ods9r30jjCEac+mG4t1z
 yUBrTHIwOAgx/INY0KSV2hbKREWkgC6d/7yqu96pH9w6g5Jt49qc14XS36+XIhgyGu2xIIchow4Qz
 BW+5ahtfcg5tlK9MAQGV/if7x7G36MRXucUdzi4Pm433ZfNWXB4GQKDK6tpaRa9b9WLE/4eNwotsQ
 WYJU0V3ymjWi/vygICy/VM7sHmuyl6AEEOhdn+hgIPLQrknYf6RUcBi7t2+U9uZR7FAYMk0lGCpt0
 sOmyZdAcQ==;
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

This iterator iterates over each entry that is stored in the index or
indices specified by the xa_state.  This is intended for use for a
conditional store of a multiindex entry, or to allow entries which are
about to be removed from the xarray to be disposed of properly.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h                 | 17 +++++++
 lib/xarray.c                           | 61 +++++++++++++++++++++++++
 tools/testing/radix-tree/xarray-test.c | 63 ++++++++++++++++++++++++++
 3 files changed, 141 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index dd941454bb5b..6a61aab11038 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -750,6 +750,7 @@ static inline bool xas_retry(struct xa_state *xas, const void *entry)
 void *xas_load(struct xa_state *);
 void *xas_store(struct xa_state *, void *entry);
 void *xas_find(struct xa_state *, unsigned long max);
+void *xas_next_conflict(struct xa_state *);
 
 bool xas_get_tag(const struct xa_state *, xa_tag_t);
 void xas_set_tag(const struct xa_state *, xa_tag_t);
@@ -964,6 +965,22 @@ enum {
 	for (entry = xas_find_tagged(xas, max, tag); entry; \
 	     entry = xas_next_tagged(xas, max, tag))
 
+/**
+ * xas_for_each_conflict() - Iterate over a range of an XArray.
+ * @xas: XArray operation state.
+ * @entry: Entry retrieved from the array.
+ *
+ * The loop body will be executed for each entry in the XArray that lies
+ * within the range specified by @xas.  If the loop completes successfully,
+ * any entries that lie in this range will be replaced by @entry.  The caller
+ * may break out of the loop; if they do so, the contents of the XArray will
+ * be unchanged.  The operation may fail due to an out of memory condition.
+ * The caller may also call xa_set_err() to exit the loop while setting an
+ * error to record the reason.
+ */
+#define xas_for_each_conflict(xas, entry) \
+	while ((entry = xas_next_conflict(xas)))
+
 void *__xas_next(struct xa_state *);
 void *__xas_prev(struct xa_state *);
 
diff --git a/lib/xarray.c b/lib/xarray.c
index 3b2c2f2240bf..d76db0ff17cf 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1100,6 +1100,67 @@ void *xas_find_tagged(struct xa_state *xas, unsigned long max, xa_tag_t tag)
 }
 EXPORT_SYMBOL_GPL(xas_find_tagged);
 
+/**
+ * xas_next_conflict() - Step for xas_for_each_conflict().
+ * @xas: XArray operation state.
+ *
+ * This function does the work for xas_for_each_conflict().
+ *
+ * Context: Any context.  Expects xa_lock to be held.
+ * Return: The next entry in the range covered by @xas or %NULL.
+ */
+void *xas_next_conflict(struct xa_state *xas)
+{
+	void *curr;
+
+	if (xas_error(xas))
+		return NULL;
+
+	if (!xas->xa_node)
+		return NULL;
+
+	if (xas_top(xas->xa_node)) {
+		curr = xas_start(xas);
+		if (!curr)
+			return NULL;
+		while (xa_is_node(curr)) {
+			struct xa_node *node = xa_to_node(curr);
+			curr = xas_descend(xas, node);
+		}
+		if (curr)
+			return curr;
+	}
+
+	if (xas->xa_node->shift > xas->xa_shift)
+		return NULL;
+
+	for (;;) {
+		if (xas->xa_node->shift == xas->xa_shift) {
+			if ((xas->xa_offset & xas->xa_sibs) == xas->xa_sibs)
+				break;
+		} else if (xas->xa_offset == XA_CHUNK_MASK) {
+			xas->xa_offset = xas->xa_node->offset;
+			xas->xa_node = xas->xa_node->parent;
+			if (!xas->xa_node)
+				break;
+			continue;
+		}
+		curr = xa_entry_locked(xas->xa, xas->xa_node, ++xas->xa_offset);
+		if (xa_is_sibling(curr))
+			continue;
+		while (xa_is_node(curr)) {
+			xas->xa_node = xa_to_node(curr);
+			xas->xa_offset = 0;
+			curr = xa_entry_locked(xas->xa, xas->xa_node, 0);
+		}
+		if (curr)
+			return curr;
+	}
+	xas->xa_offset -= xas->xa_sibs;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(xas_next_conflict);
+
 /**
  * xa_init_flags() - Initialise an empty XArray with flags.
  * @xa: XArray.
diff --git a/tools/testing/radix-tree/xarray-test.c b/tools/testing/radix-tree/xarray-test.c
index eeafbf8c948c..296ace77c4f4 100644
--- a/tools/testing/radix-tree/xarray-test.c
+++ b/tools/testing/radix-tree/xarray-test.c
@@ -315,6 +315,68 @@ void check_multi_store(struct xarray *xa)
 	BUG_ON(!xa_empty(xa));
 }
 
+void __check_store_iter(struct xarray *xa, unsigned long start,
+			unsigned int order, unsigned int present)
+{
+	XA_STATE_ORDER(xas, xa, start, order);
+	void *entry;
+	unsigned int count = 0;
+
+retry:
+	xas_for_each_conflict(&xas, entry) {
+		BUG_ON(!xa_is_value(entry));
+		BUG_ON(entry < xa_mk_value(start));
+		BUG_ON(entry > xa_mk_value(start + (1UL << order) - 1));
+		count++;
+	}
+	xas_store(&xas, xa_mk_value(start));
+	if (xas_nomem(&xas, GFP_KERNEL)) {
+		count = 0;
+		goto retry;
+	}
+	BUG_ON(xas_error(&xas));
+	BUG_ON(count != present);
+	BUG_ON(xa_load(xa, start) != xa_mk_value(start));
+	BUG_ON(xa_load(xa, start + (1UL << order) - 1) != xa_mk_value(start));
+	xa_store(xa, start, NULL, 0);
+}
+
+void check_store_iter(struct xarray *xa)
+{
+	unsigned int i, j;
+
+	for (i = 0; i < 20; i++) {
+		unsigned int min = 1 << i;
+		unsigned int max = (2 << i) - 1;
+		__check_store_iter(xa, 0, i, 0);
+		BUG_ON(!xa_empty(xa));
+		__check_store_iter(xa, min, i, 0);
+		BUG_ON(!xa_empty(xa));
+
+		xa_store(xa, min, xa_mk_value(min), GFP_KERNEL);
+		__check_store_iter(xa, min, i, 1);
+		BUG_ON(!xa_empty(xa));
+		xa_store(xa, max, xa_mk_value(max), GFP_KERNEL);
+		__check_store_iter(xa, min, i, 1);
+		BUG_ON(!xa_empty(xa));
+
+		for (j = 0; j < min; j++)
+			xa_store(xa, j, xa_mk_value(j), GFP_KERNEL);
+		__check_store_iter(xa, 0, i, min);
+		BUG_ON(!xa_empty(xa));
+		for (j = 0; j < min; j++)
+			xa_store(xa, min + j, xa_mk_value(min + j), GFP_KERNEL);
+		__check_store_iter(xa, min, i, min);
+		BUG_ON(!xa_empty(xa));
+	}
+	xa_store(xa, 63, xa_mk_value(63), GFP_KERNEL);
+	xa_store(xa, 65, xa_mk_value(65), GFP_KERNEL);
+	__check_store_iter(xa, 64, 2, 1);
+	BUG_ON(xa_load(xa, 63) != xa_mk_value(63));
+	xa_store(xa, 63, NULL, 0);
+	BUG_ON(!xa_empty(xa));
+}
+
 void check_multi_find(struct xarray *xa)
 {
 	unsigned long index;
@@ -537,6 +599,7 @@ void xarray_checks(void)
 	check_cmpxchg(&array);
 	check_multi_store(&array);
 	item_kill_tree(&array);
+	check_store_iter(&array);
 
 	check_find(&array);
 	check_xas_delete(&array);
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
