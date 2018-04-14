From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 07/63] xarray: Add xa_get_tag,
 xa_set_tag and xa_clear_tag
Date: Sat, 14 Apr 2018 07:12:20 -0700
Message-ID: <20180414141316.7167-8-willy@infradead.org>
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
 bh=hakcaTo+qIsAzD6G1S8jc7ts+AEdwsG9v/meDToYN1s=; b=AkmTBlQRY8EE9vyPskLXteIDO2
 UgmW6L5TR6pB3iEpwdG05cpCJJchkNV5IAHY5KKIzkt3rNa31yMpq+VE2NJEUNSsOgDGjYMbjykSM
 On1ZUIxg38yTzoigX4E44KQQZzdIUsXY+9L4QSBH/HsQZ2lqbURyZGcaUBnJUc4M2dzw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=hakcaTo+qIsAzD6G1S8jc7ts+AEdwsG9v/meDToYN1s=; b=e+z3qc1+Sb7Z8euBxwiWGbd1In
 n2pFiMfkgcQV5HqNRonBpeGTthmoduF/OzfYPrK6cX77Jn6GVLoGbzsfEFKhdMVuUI76exMT2Cem1
 j4sgZtZrqFL5fxokLzEgSlg0nA7/5fPlF2J1bR3HO5osi2fWA3uxe0U5Uaoe0zreVvhc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=hakcaTo+qIsAzD6G1S8jc7ts+AEdwsG9v/meDToYN1s=; b=BC/gmtfCnd0bFHzXPKufxL7Wc
 ub79rk7Ff6jZZr2oXhq3xVUaQjJ1roYvV5N4lOTJAmeAfezAkvys9pw87lCZ4YVb48aGw4b8SZlvm
 Tfgxz6cM3VfG/wVE2AdZqaosNJLzDf6b9yiUxTE8+5qgATEfptydobI60lr4acOYshme0Qow6x72J
 EsCU/sLTIDIEEGAg88IEqSO67GD+54kmHKZk4jWoXX9eIt2ijr3jiJd0dN3qZQ52yk00jdN7S+f6A
 caqqGLFRyS6BhJUpvz9PVJY06rRcB1gbuYe1D3q+lKb/zFH3wZT/g4AoeRED/tnhP2Rr3khi2/zrY
 jSDqUvPzw==;
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

XArray tags are slightly more strongly typed than the radix tree tags,
but occupy the same bits.  This commit also adds the xas_ family of tag
operations, for cases where the caller is already holding the lock, and
xa_tagged() to ask whether any array member has a particular tag set.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h         |  41 ++++++
 lib/xarray.c                   | 235 +++++++++++++++++++++++++++++++++
 tools/include/linux/spinlock.h |   6 +
 3 files changed, 282 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 099fc36177b9..f5996f6ccb8e 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -11,6 +11,7 @@
 
 #include <linux/bug.h>
 #include <linux/compiler.h>
+#include <linux/gfp.h>
 #include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/rcupdate.h>
@@ -149,6 +150,20 @@ static inline int xa_err(void *entry)
 	return 0;
 }
 
+typedef unsigned __bitwise xa_tag_t;
+#define XA_TAG_0		((__force xa_tag_t)0U)
+#define XA_TAG_1		((__force xa_tag_t)1U)
+#define XA_TAG_2		((__force xa_tag_t)2U)
+#define XA_PRESENT		((__force xa_tag_t)8U)
+#define XA_TAG_MAX		XA_TAG_2
+
+/*
+ * Values for xa_flags.  The radix tree stores its GFP flags in the xa_flags,
+ * and we remain compatible with that.
+ */
+#define XA_FLAGS_TAG(tag)	((__force gfp_t)((1U << __GFP_BITS_SHIFT) << \
+						(__force unsigned)(tag)))
+
 /**
  * struct xarray - The anchor of the XArray.
  * @xa_lock: Lock that protects the contents of the XArray.
@@ -195,6 +210,9 @@ struct xarray {
 
 void xa_init_flags(struct xarray *, gfp_t flags);
 void *xa_load(struct xarray *, unsigned long index);
+bool xa_get_tag(struct xarray *, unsigned long index, xa_tag_t);
+void xa_set_tag(struct xarray *, unsigned long index, xa_tag_t);
+void xa_clear_tag(struct xarray *, unsigned long index, xa_tag_t);
 
 /**
  * xa_init() - Initialise an empty XArray.
@@ -209,6 +227,19 @@ static inline void xa_init(struct xarray *xa)
 	xa_init_flags(xa, 0);
 }
 
+/**
+ * xa_tagged() - Inquire whether any entry in this array has a tag set
+ * @xa: Array
+ * @tag: Tag value
+ *
+ * Context: Any context.
+ * Return: %true if any entry has this tag set.
+ */
+static inline bool xa_tagged(const struct xarray *xa, xa_tag_t tag)
+{
+	return xa->xa_flags & XA_FLAGS_TAG(tag);
+}
+
 #define xa_trylock(xa)		spin_trylock(&(xa)->xa_lock)
 #define xa_lock(xa)		spin_lock(&(xa)->xa_lock)
 #define xa_unlock(xa)		spin_unlock(&(xa)->xa_lock)
@@ -221,6 +252,12 @@ static inline void xa_init(struct xarray *xa)
 #define xa_unlock_irqrestore(xa, flags) \
 				spin_unlock_irqrestore(&(xa)->xa_lock, flags)
 
+/*
+ * Versions of the normal API which require the caller to hold the xa_lock.
+ */
+void __xa_set_tag(struct xarray *, unsigned long index, xa_tag_t);
+void __xa_clear_tag(struct xarray *, unsigned long index, xa_tag_t);
+
 /* Everything below here is the Advanced API.  Proceed with caution. */
 
 /*
@@ -551,6 +588,10 @@ static inline bool xas_retry(struct xa_state *xas, const void *entry)
 
 void *xas_load(struct xa_state *);
 
+bool xas_get_tag(const struct xa_state *, xa_tag_t);
+void xas_set_tag(const struct xa_state *, xa_tag_t);
+void xas_clear_tag(const struct xa_state *, xa_tag_t);
+
 /**
  * xas_reload() - Refetch an entry from the xarray.
  * @xas: XArray operation state.
diff --git a/lib/xarray.c b/lib/xarray.c
index caa997535174..07c1155fa933 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -5,6 +5,7 @@
  * Author: Matthew Wilcox <mawilcox@microsoft.com>
  */
 
+#include <linux/bitmap.h>
 #include <linux/export.h>
 #include <linux/xarray.h>
 
@@ -24,6 +25,55 @@
  * @entry refers to something stored in a slot in the xarray
  */
 
+static inline struct xa_node *xa_parent(struct xarray *xa,
+					const struct xa_node *node)
+{
+	return rcu_dereference_check(node->parent,
+						lockdep_is_held(&xa->xa_lock));
+}
+
+static inline struct xa_node *xa_parent_locked(struct xarray *xa,
+					const struct xa_node *node)
+{
+	return rcu_dereference_protected(node->parent,
+						lockdep_is_held(&xa->xa_lock));
+}
+
+static inline void xa_tag_set(struct xarray *xa, xa_tag_t tag)
+{
+	if (!(xa->xa_flags & XA_FLAGS_TAG(tag)))
+		xa->xa_flags |= XA_FLAGS_TAG(tag);
+}
+
+static inline void xa_tag_clear(struct xarray *xa, xa_tag_t tag)
+{
+	if (xa->xa_flags & XA_FLAGS_TAG(tag))
+		xa->xa_flags &= ~(XA_FLAGS_TAG(tag));
+}
+
+static inline bool node_get_tag(const struct xa_node *node, unsigned int offset,
+				xa_tag_t tag)
+{
+	return test_bit(offset, node->tags[(__force unsigned)tag]);
+}
+
+static inline void node_set_tag(struct xa_node *node, unsigned int offset,
+				xa_tag_t tag)
+{
+	__set_bit(offset, node->tags[(__force unsigned)tag]);
+}
+
+static inline void node_clear_tag(struct xa_node *node, unsigned int offset,
+				xa_tag_t tag)
+{
+	__clear_bit(offset, node->tags[(__force unsigned)tag]);
+}
+
+static inline bool node_any_tag(struct xa_node *node, xa_tag_t tag)
+{
+	return !bitmap_empty(node->tags[(__force unsigned)tag], XA_CHUNK_SIZE);
+}
+
 /* extracts the offset within this node from the index */
 static unsigned int get_offset(unsigned long index, struct xa_node *node)
 {
@@ -132,6 +182,85 @@ void *xas_load(struct xa_state *xas)
 }
 EXPORT_SYMBOL_GPL(xas_load);
 
+/**
+ * xas_get_tag() - Returns the state of this tag.
+ * @xas: XArray operation state.
+ * @tag: Tag number.
+ *
+ * Return: true if the tag is set, false if the tag is clear or @xas
+ * is in an error state.
+ */
+bool xas_get_tag(const struct xa_state *xas, xa_tag_t tag)
+{
+	if (xas_invalid(xas))
+		return false;
+	if (!xas->xa_node)
+		return xa_tagged(xas->xa, tag);
+	return node_get_tag(xas->xa_node, xas->xa_offset, tag);
+}
+EXPORT_SYMBOL_GPL(xas_get_tag);
+
+/**
+ * xas_set_tag() - Sets the tag on this entry and its parents.
+ * @xas: XArray operation state.
+ * @tag: Tag number.
+ *
+ * Sets the specified tag on this entry, and walks up the tree setting it
+ * on all the ancestor entries.  Does nothing if @xas has not been walked to
+ * an entry, or is in an error state.
+ */
+void xas_set_tag(const struct xa_state *xas, xa_tag_t tag)
+{
+	struct xa_node *node = xas->xa_node;
+	unsigned int offset = xas->xa_offset;
+
+	if (xas_invalid(xas))
+		return;
+
+	while (node) {
+		if (node_get_tag(node, offset, tag))
+			return;
+		node_set_tag(node, offset, tag);
+		offset = node->offset;
+		node = xa_parent_locked(xas->xa, node);
+	}
+
+	if (!xa_tagged(xas->xa, tag))
+		xa_tag_set(xas->xa, tag);
+}
+EXPORT_SYMBOL_GPL(xas_set_tag);
+
+/**
+ * xas_clear_tag() - Clears the tag on this entry and its parents.
+ * @xas: XArray operation state.
+ * @tag: Tag number.
+ *
+ * Clears the specified tag on this entry, and walks back to the head
+ * attempting to clear it on all the ancestor entries.  Does nothing if
+ * @xas has not been walked to an entry, or is in an error state.
+ */
+void xas_clear_tag(const struct xa_state *xas, xa_tag_t tag)
+{
+	struct xa_node *node = xas->xa_node;
+	unsigned int offset = xas->xa_offset;
+
+	if (xas_invalid(xas))
+		return;
+
+	while (node) {
+		node_clear_tag(node, offset, tag);
+		if (node_any_tag(node, tag))
+			return;
+
+		offset = node->offset;
+		node = xa_parent_locked(xas->xa, node);
+	}
+
+	if (xa_tagged(xas->xa, tag))
+		xa_tag_clear(xas->xa, tag);
+}
+EXPORT_SYMBOL_GPL(xas_clear_tag);
+
 /**
  * xa_init_flags() - Initialise an empty XArray with flags.
  * @xa: XArray.
@@ -174,6 +303,112 @@ void *xa_load(struct xarray *xa, unsigned long index)
 }
 EXPORT_SYMBOL(xa_load);
 
+/**
+ * __xa_set_tag() - Set this tag on this entry while locked.
+ * @xa: XArray.
+ * @index: Index of entry.
+ * @tag: Tag number.
+ *
+ * Attempting to set a tag on a NULL entry does not succeed.
+ *
+ * Context: Any context.  Expects xa_lock to be held on entry.
+ */
+void __xa_set_tag(struct xarray *xa, unsigned long index, xa_tag_t tag)
+{
+	XA_STATE(xas, xa, index);
+	void *entry = xas_load(&xas);
+
+	if (entry)
+		xas_set_tag(&xas, tag);
+}
+EXPORT_SYMBOL_GPL(__xa_set_tag);
+
+/**
+ * __xa_clear_tag() - Clear this tag on this entry while locked.
+ * @xa: XArray.
+ * @index: Index of entry.
+ * @tag: Tag number.
+ *
+ * Context: Any context.  Expects xa_lock to be held on entry.
+ */
+void __xa_clear_tag(struct xarray *xa, unsigned long index, xa_tag_t tag)
+{
+	XA_STATE(xas, xa, index);
+	void *entry = xas_load(&xas);
+
+	if (entry)
+		xas_clear_tag(&xas, tag);
+}
+EXPORT_SYMBOL_GPL(__xa_clear_tag);
+
+/**
+ * xa_get_tag() - Inquire whether this tag is set on this entry.
+ * @xa: XArray.
+ * @index: Index of entry.
+ * @tag: Tag number.
+ *
+ * This function uses the RCU read lock, so the result may be out of date
+ * by the time it returns.  If you need the result to be stable, use a lock.
+ *
+ * Context: Any context.  Takes and releases the RCU lock.
+ * Return: True if the entry at @index has this tag set, false if it doesn't.
+ */
+bool xa_get_tag(struct xarray *xa, unsigned long index, xa_tag_t tag)
+{
+	XA_STATE(xas, xa, index);
+	void *entry;
+
+	rcu_read_lock();
+	entry = xas_start(&xas);
+	while (xas_get_tag(&xas, tag)) {
+		if (!xa_is_node(entry))
+			goto found;
+		entry = xas_descend(&xas, xa_to_node(entry));
+	}
+	rcu_read_unlock();
+	return false;
+ found:
+	rcu_read_unlock();
+	return true;
+}
+EXPORT_SYMBOL(xa_get_tag);
+
+/**
+ * xa_set_tag() - Set this tag on this entry.
+ * @xa: XArray.
+ * @index: Index of entry.
+ * @tag: Tag number.
+ *
+ * Attempting to set a tag on a NULL entry does not succeed.
+ *
+ * Context: Process context.  Takes and releases the xa_lock.
+ */
+void xa_set_tag(struct xarray *xa, unsigned long index, xa_tag_t tag)
+{
+	xa_lock(xa);
+	__xa_set_tag(xa, index, tag);
+	xa_unlock(xa);
+}
+EXPORT_SYMBOL(xa_set_tag);
+
+/**
+ * xa_clear_tag() - Clear this tag on this entry.
+ * @xa: XArray.
+ * @index: Index of entry.
+ * @tag: Tag number.
+ *
+ * Clearing a tag always succeeds.
+ *
+ * Context: Process context.  Takes and releases the xa_lock.
+ */
+void xa_clear_tag(struct xarray *xa, unsigned long index, xa_tag_t tag)
+{
+	xa_lock(xa);
+	__xa_clear_tag(xa, index, tag);
+	xa_unlock(xa);
+}
+EXPORT_SYMBOL(xa_clear_tag);
+
 #ifdef XA_DEBUG
 void xa_dump_node(const struct xa_node *node)
 {
diff --git a/tools/include/linux/spinlock.h b/tools/include/linux/spinlock.h
index 4ec4d2cbe27a..622266b197d0 100644
--- a/tools/include/linux/spinlock.h
+++ b/tools/include/linux/spinlock.h
@@ -10,6 +10,12 @@
 #define __SPIN_LOCK_UNLOCKED(x)	(pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER
 #define spin_lock_init(x)	pthread_mutex_init(x, NULL)
 
+#define spin_lock(x)			pthread_mutex_lock(x)
+#define spin_unlock(x)			pthread_mutex_unlock(x)
+#define spin_lock_bh(x)			pthread_mutex_lock(x)
+#define spin_unlock_bh(x)		pthread_mutex_unlock(x)
+#define spin_lock_irq(x)		pthread_mutex_lock(x)
+#define spin_unlock_irq(x)		pthread_mutex_unlock(x)
 #define spin_lock_irqsave(x, f)		(void)f, pthread_mutex_lock(x)
 #define spin_unlock_irqrestore(x, f)	(void)f, pthread_mutex_unlock(x)
 
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
