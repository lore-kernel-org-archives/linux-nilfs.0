From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 15/78] xarray: Add xas_for_each_tag
Date: Fri, 15 Dec 2017 14:03:47 -0800
Message-ID: <20171215220450.7899-16-willy@infradead.org>
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
 bh=K3sGeIhFItgACVngHc9iPoNCAn3k8GAn3MwDMvCt9xM=; b=GTkvAR08J4W1BWUW7O9XhhsRNM
 AGgZGfuk+qqx4gbDK3W/BWFuhYI3LBa9s2fTO0dAtqb1ScoG7lsH+gnCw1E7wffP/z2X7wGYl9xG/
 jp5PH8280Jg5HnfBwyT2TuZ7iXYwgye3p7sVq1PzdCrBTYNauo8Nt0GhBgcWTfDXa4qs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=K3sGeIhFItgACVngHc9iPoNCAn3k8GAn3MwDMvCt9xM=; b=cUObWdMcxQKmfjFjTYJZSmqI8O
 HOzyva9Yhp4Ve4G7UC9AVPeGa4SAIoQ71LmPIw5foKXeQ0B9Ec5xi24dyKGDwqzwSDG3VORvmbfnT
 bnPwyjek4g1twlCWgVKl08A8xGDD8Hdm1ytEwMVE33fMLF8zjrQZgw/6VNyu1qwkiWN0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=K3sGeIhFItgACVngHc9iPoNCAn3k8GAn3MwDMvCt9xM=; b=EJpQ3+CD8+633tE+QKzxFgz17
 Qp0Fi5kRb54s/+e8dUlmllrkoWsUCKXT28nOIWEBt1t30WvkYtnKVV7VydSXk0BawlfI9ryQ+Sz3U
 ZBgddNy1mr9QLeXU1ndyQgMtU7O+W2PHmsBU8yLIcUjm4HGyRPfdkX5wCo7dBrlI+lVjP9e26lW62
 9zNFks8tj05s6+HgRXpcgE/8AmvlvCXqilSYEtjC7TSOth9t7BcVgdXHcqFCMgR5P5UFea/qCqbEW
 rXdzZZZZNbXNNr2MHDgWaUatWVsdUVsQWjcYdhQAkUd8jTvOzDLTeC6Z60j45Eunj2FRM76jmctir
 5NezVWNBA==;
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

This iterator operates across each tagged entry in the specified range.
We do not yet have a user for an xa_for_each_tag iterator, but it would
be straight-forward to add one if needed.  This commit also includes
xas_find_tag() and xas_next_tag().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h | 68 +++++++++++++++++++++++++++++++++++++++++++
 lib/xarray.c           | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 146 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index c4eef03ad12d..85a319463e46 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -645,6 +645,7 @@ void *xas_find(struct xa_state *, unsigned long max);
 bool xas_get_tag(const struct xa_state *, xa_tag_t);
 void xas_set_tag(const struct xa_state *, xa_tag_t);
 void xas_clear_tag(const struct xa_state *, xa_tag_t);
+void *xas_find_tag(struct xa_state *, unsigned long max, xa_tag_t);
 void xas_init_tags(const struct xa_state *);
 
 bool xas_nomem(struct xa_state *, gfp_t);
@@ -770,6 +771,55 @@ static inline void *xas_next_entry(struct xa_state *xas, unsigned long max)
 	return entry;
 }
 
+/* Private */
+static inline unsigned int xas_find_chunk(struct xa_state *xas, bool advance,
+		xa_tag_t tag)
+{
+	unsigned long *addr = xas->xa_node->tags[(__force unsigned)tag];
+	unsigned int offset = xas->xa_offset;
+
+	if (advance)
+		offset++;
+	if (XA_CHUNK_SIZE == BITS_PER_LONG) {
+		unsigned long data = *addr & (~0UL << offset);
+		if (data)
+			return __ffs(data);
+		return XA_CHUNK_SIZE;
+	}
+
+	return find_next_bit(addr, XA_CHUNK_SIZE, offset);
+}
+
+/**
+ * xas_next_tag() - Advance iterator to next tagged entry.
+ * @xas: XArray operation state.
+ * @max: Highest index to return.
+ * @tag: Tag to search for.
+ *
+ * xas_next_tag() is an inline function to optimise xarray traversal for
+ * speed.  It is equivalent to calling xas_find_tag(), and will call
+ * xas_find_tag() for all the hard cases.
+ *
+ * Return: The next tagged entry after the one currently referred to by @xas.
+ */
+static inline void *xas_next_tag(struct xa_state *xas, unsigned long max,
+								xa_tag_t tag)
+{
+	struct xa_node *node = xas->xa_node;
+	unsigned int offset;
+
+	if (unlikely(xas_not_node(node) || xa_node_shift(node)))
+		return xas_find_tag(xas, max, tag);
+	offset = xas_find_chunk(xas, true, tag);
+	xas->xa_offset = offset;
+	xas->xa_index = (xas->xa_index & ~XA_CHUNK_MASK) + offset;
+	if (xas->xa_index > max)
+		return NULL;
+	if (offset == XA_CHUNK_SIZE)
+		return xas_find_tag(xas, max, tag);
+	return xa_entry(xas->xa, node, offset);
+}
+
 /*
  * If iterating while holding a lock, drop the lock and reschedule
  * every %XA_CHECK_SCHED loops.
@@ -795,6 +845,24 @@ enum {
 	for (entry = xas_find(xas, max); entry; \
 	     entry = xas_next_entry(xas, max))
 
+/**
+ * xas_for_each_tag() - Iterate over a range of an XArray
+ * @xas: XArray operation state.
+ * @entry: Entry retrieved from array.
+ * @max: Maximum index to retrieve from array.
+ * @tag: Tag to search for.
+ *
+ * The loop body will be executed for each tagged entry in the xarray
+ * between the current xas position and @max.  @entry will be set to
+ * the entry retrieved from the xarray.  It is safe to delete entries
+ * from the array in the loop body.  You should hold either the RCU lock
+ * or the xa_lock while iterating.  If you need to drop the lock, call
+ * xas_pause() first.
+ */
+#define xas_for_each_tag(xas, entry, max, tag) \
+	for (entry = xas_find_tag(xas, max, tag); entry; \
+	     entry = xas_next_tag(xas, max, tag))
+
 /* Internal functions, mostly shared between radix-tree.c, xarray.c and idr.c */
 void xas_destroy(struct xa_state *);
 
diff --git a/lib/xarray.c b/lib/xarray.c
index 4d8962d2341c..9ac1e9730c24 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -897,6 +897,84 @@ void *xas_find(struct xa_state *xas, unsigned long max)
 }
 EXPORT_SYMBOL_GPL(xas_find);
 
+/**
+ * xas_find_tag() - Find the next tagged entry in the XArray.
+ * @xas: XArray operation state.
+ * @max: Highest index to return.
+ * @tag: Tag number to search for.
+ *
+ * If the xas has not yet been walked to an entry, return the tagged entry
+ * which has an index >= xas.xa_index.  If it has been walked, the entry
+ * currently being pointed at has been processed, and so we move to the
+ * next tagged entry.
+ *
+ * If no tagged entry is found and the array is smaller than @max, @xas is
+ * set to the restart state and xas->xa_index is set to the smallest index
+ * not yet in the array.  This allows @xas to be immediately passed to
+ * xas_create().
+ *
+ * Return: The entry, if found, otherwise NULL.
+ */
+void *xas_find_tag(struct xa_state *xas, unsigned long max, xa_tag_t tag)
+{
+	bool advance = true;
+	unsigned int offset;
+	void *entry;
+
+	if (xas_error(xas))
+		return NULL;
+
+	if (!xas->xa_node) {
+		xas->xa_index = 1;
+		goto out;
+	} else if (xas_top(xas->xa_node)) {
+		advance = false;
+		entry = xa_head(xas->xa);
+		if (xas->xa_index > max_index(entry))
+			goto out;
+		if (!xa_is_node(entry)) {
+			if (xa_tagged(xas->xa, tag)) {
+				xas->xa_node = NULL;
+				return entry;
+			}
+			xas->xa_index = 1;
+			goto out;
+		}
+		xas->xa_node = xa_to_node(entry);
+		xas->xa_offset = xas->xa_index >> xas->xa_node->shift;
+	}
+
+	while (xas->xa_index <= max) {
+		if (unlikely(xas->xa_offset == XA_CHUNK_SIZE)) {
+			xas->xa_offset = xas->xa_node->offset + 1;
+			xas->xa_node = xa_parent(xas->xa, xas->xa_node);
+			if (!xas->xa_node)
+				break;
+			advance = false;
+			continue;
+		}
+
+		offset = xas_find_chunk(xas, advance, tag);
+		xas_add(xas, offset - xas->xa_offset);
+		if (offset == XA_CHUNK_SIZE) {
+			advance = false;
+			continue;
+		}
+
+		entry = xa_entry(xas->xa, xas->xa_node, xas->xa_offset);
+		if (!xa_is_node(entry))
+			return entry;
+		xas->xa_node = xa_to_node(entry);
+		xas->xa_offset = get_offset(xas->xa_index, xas->xa_node);
+	}
+
+ out:
+	if (!xas->xa_node)
+		xas->xa_node = XAS_BOUNDS;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(xas_find_tag);
+
 /**
  * __xa_init() - Initialise an empty XArray with flags.
  * @xa: XArray.
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
