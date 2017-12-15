From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 16/78] xarray: Add xa_get_entries,
 xa_get_tagged and xa_get_maybe_tag
Date: Fri, 15 Dec 2017 14:03:48 -0800
Message-ID: <20171215220450.7899-17-willy@infradead.org>
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
 bh=jKe1ZrNZpyBizfXUAfzyeNZ5H7p6YSdw9NZBHIlcNmY=; b=QZb2it2+kTGvs7lTtT1Mdsi0UR
 k9SAVDD/Y8wvmcWO1psORYFJ966AJ8be24E6zdhQ2H1/H7k9lnFHtDkSd3CDcm/PolUTsfD5QrhjT
 L9A72Ob+4J8KsKBJ9Uo8I1x2O8f7OUZHZypebM6Q+HIJvXpL643Kr44NMGfg5+4Cf0vg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=jKe1ZrNZpyBizfXUAfzyeNZ5H7p6YSdw9NZBHIlcNmY=; b=TiskrbwIE+XnRrUc2MQNY/3DWH
 to67PEeJjF5nKVWRjXQwU5Fr/earhCggzHKJ4gv5i1Oxk8RQfgGnW4aeSGLl8fAak8G6FoDYviMHl
 jr7168iagpMwvNzQMhg98ueZH0tTHyXfYkTzwP+CF6MOWWIcdYjOjDLky4NNvnsl8Y1A=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=jKe1ZrNZpyBizfXUAfzyeNZ5H7p6YSdw9NZBHIlcNmY=; b=Kaw/aQhiZuM+Z3zIzyCs80JqP
 CoaO/Nd1cT8MMMwzMsMk8lZriXN1sSbYdOHPQTo2wAnfWesBRHJGXQyykg8Oj3kQWH2dMkQe0LYaP
 2ssgbxHbMwCAFYZKLwja01Pkf6cXEiThGHN6iXOMY6TlJxfVSGIDkU8HVLtn7s0FsduxAis0zhjcB
 L+vXygSS3u9YsdIFrXsPjaCZmNPyoQ3M5XcA68BhyvfwC7E3drGRIH8+Riy2cS8/O8kerJguB77nB
 p/MfWhCb3C04G+qw/zKpBda3iBo4KWFV5INWb8I5P8qR93bT5W7gbW6hCV4eZno/h/Xzv+oTa7e2Z
 pvXFrnUbQ==;
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

These functions allow a range of xarray entries to be extracted into a
compact normal array.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h | 27 ++++++++++++++++
 lib/xarray.c           | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 85a319463e46..1367d694eebd 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -140,6 +140,33 @@ void xa_clear_tag(struct xarray *, unsigned long index, xa_tag_t);
 
 void *xa_find(struct xarray *xa, unsigned long *index, unsigned long max);
 void *xa_find_after(struct xarray *xa, unsigned long *index, unsigned long max);
+int xa_get_entries(struct xarray *, void **dst, unsigned long start,
+			unsigned long max, unsigned int n);
+int xa_get_tagged(struct xarray *, void **dst, unsigned long start,
+			unsigned long max, unsigned int n, xa_tag_t);
+
+/**
+ * xa_get_maybe_tag() - Copy entries from the XArray into a normal array.
+ * @xa: The source XArray to copy from.
+ * @dst: The buffer to copy pointers into.
+ * @start: The first index in the XArray eligible to be copied from.
+ * @max: The last index in the XArray eligible to be copied from.
+ * @n: The maximum number of entries to copy.
+ * @tag: Tag number.
+ *
+ * If you specify %XA_NO_TAG as the tag number, this is the same as
+ * xa_get_entries().  Otherwise, it is the same as xa_get_tagged().
+ *
+ * Return: The number of entries copied.
+ */
+static inline int xa_get_maybe_tag(struct xarray *xa, void **dst,
+			unsigned long start, unsigned long max,
+			unsigned int n, xa_tag_t tag)
+{
+	if (tag == XA_NO_TAG)
+		return xa_get_entries(xa, dst, start, max, n);
+	return xa_get_tagged(xa, dst, start, max, n, tag);
+}
 
 /**
  * xa_for_each() - Iterate over a portion of an XArray.
diff --git a/lib/xarray.c b/lib/xarray.c
index 9ac1e9730c24..e73ae7b57fc9 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1330,6 +1330,94 @@ void *xa_find_after(struct xarray *xa, unsigned long *indexp, unsigned long max)
 }
 EXPORT_SYMBOL(xa_find_after);
 
+/**
+ * xa_get_entries() - Copy entries from the XArray into a normal array.
+ * @xa: The source XArray to copy from.
+ * @dst: The buffer to copy pointers into.
+ * @start: The first index in the XArray eligible to be copied from.
+ * @max: The last index in the XArray eligible to be copied from.
+ * @n: The maximum number of entries to copy.
+ *
+ * Copies up to @n non-NULL entries from the XArray.  The copied entries will
+ * have indices between @start and @max, inclusive.
+ *
+ * This function uses the RCU lock to protect itself.  That means that the
+ * entries returned may not represent a snapshot of the XArray at a moment
+ * in time.  For example, if index 5 is stored to, then index 10 is stored to,
+ * calling xa_get_entries() may return the old contents of index 5 and the
+ * new contents of index 10.  Indices not modified while this function is
+ * running will not be skipped.
+ *
+ * If you need stronger guarantees, holding the xa_lock across calls to this
+ * function will prevent concurrent modification.
+ *
+ * Return: The number of entries copied.
+ */
+int xa_get_entries(struct xarray *xa, void **dst, unsigned long start,
+			unsigned long max, unsigned int n)
+{
+	XA_STATE(xas, xa, start);
+	void *entry;
+	unsigned int i = 0;
+
+	if (!n)
+		return 0;
+
+	rcu_read_lock();
+	xas_for_each(&xas, entry, max) {
+		if (xas_retry(&xas, entry))
+			continue;
+		dst[i++] = entry;
+		if (i == n)
+			break;
+	}
+	rcu_read_unlock();
+
+	return i;
+}
+EXPORT_SYMBOL(xa_get_entries);
+
+/**
+ * xa_get_tagged() - Copy tagged entries from the XArray into a normal array.
+ * @xa: The source XArray to copy from.
+ * @dst: The buffer to copy pointers into.
+ * @start: The first index in the XArray eligible to be copied from.
+ * @max: The last index in the XArray eligible to be copied from
+ * @n: The maximum number of entries to copy.
+ * @tag: Tag number.
+ *
+ * Copies up to @n non-NULL entries that have @tag set from the XArray.  The
+ * copied entries will have indices between @start and @max, inclusive.
+ *
+ * See the xa_get_entries() documentation for the consistency guarantees
+ * provided.
+ *
+ * Return: The number of entries copied.
+ */
+int xa_get_tagged(struct xarray *xa, void **dst, unsigned long start,
+			unsigned long max, unsigned int n, xa_tag_t tag)
+{
+	XA_STATE(xas, xa, start);
+	void *entry;
+	unsigned int i = 0;
+
+	if (!n)
+		return 0;
+
+	rcu_read_lock();
+	xas_for_each_tag(&xas, entry, max, tag) {
+		if (xas_retry(&xas, entry))
+			continue;
+		dst[i++] = entry;
+		if (i == n)
+			break;
+	}
+	rcu_read_unlock();
+
+	return i;
+}
+EXPORT_SYMBOL(xa_get_tagged);
+
 #ifdef XA_DEBUG
 void xa_dump_node(const struct xa_node *node)
 {
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
