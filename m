From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 12/62] xarray: Add xa_extract
Date: Thu, 29 Mar 2018 20:41:55 -0700
Message-ID: <20180330034245.10462-13-willy@infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
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
 bh=hcH0cEvpSONNcZEswbv0iDOVWk5uLCFDLS1OUlRcoBo=; b=H5qCaeSupJpGLMaP906tEoYic/
 nm8KyWndNsPk4pfQ3BEiS4HKE0zskJaHIcXgk0VLw25FcrhjKe50Vzh1KF+U4PxQu7fp4reMn1JHj
 ShCxXxVSKmwElterGrHcDOHfXUwToSgdpT/NS23mHpdMVvleFeZoJLvbYrozIWRJVtko=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=hcH0cEvpSONNcZEswbv0iDOVWk5uLCFDLS1OUlRcoBo=; b=Uu+SlhVzd+8k6jU5ziuC70kZBg
 c7OMZ41PJrltnPqT2LrN4A83o7bpqiKWo/tTfhVp1BNTdaLmqLpyImFQYJajqq/Ly3PelK9AoInmw
 +Lz0ldk6Qlvm231TI5mWU8F6elMsujRPHsPOxO1MV8xszGBMBcqzJ+cVRMMDkcOOZc+w=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=hcH0cEvpSONNcZEswbv0iDOVWk5uLCFDLS1OUlRcoBo=; b=LkMJwNG5Zybslevgubi/K36PM
 4QJL8MHM/0CyiSmEAMDC+NnOHSVRbo0xeqigAICcBSu51bwaCDkXulWQW7STAN+hpOK7TXPrgA4Eu
 +1sR5Cl1WTR9678b3mD0niwzlOzbdKuNPHtEMOLqmdMU5m9l1mUiM7wS4cLwuVxCEIem/TqqLu9r7
 KAj1drcIVat+6E2BTnat0dLzljaO9Be29i+YcRkVXFFIGk08uIktlP3CF9uIDe/nKTon66NZpgLCm
 Z5zL5u0y09j4bLJlPPo7zPNzBOKFvwcKTixfM0XibOFoLDbq6WG6brakc5T77TQQUXUWDyBUEDTr6
 1sZBnxPvQ==;
In-Reply-To: <20180330034245.10462-1-willy@infradead.org>
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

This function combines the functionality of radix_tree_gang_lookup() and
radix_tree_gang_lookup_tagged().  It extracts entries matching the
specified filter into a normal array.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h |  2 ++
 lib/xarray.c           | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index c8b3645c6760..864f16660785 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -227,6 +227,8 @@ void *xa_find(struct xarray *xa, unsigned long *index,
 		unsigned long max, xa_tag_t) __attribute__((nonnull(2)));
 void *xa_find_after(struct xarray *xa, unsigned long *index,
 		unsigned long max, xa_tag_t) __attribute__((nonnull(2)));
+unsigned int xa_extract(struct xarray *, void **dst, unsigned long start,
+		unsigned long max, unsigned int n, xa_tag_t);
 
 /**
  * xa_init() - Initialise an empty XArray.
diff --git a/lib/xarray.c b/lib/xarray.c
index 73cf4c984c2d..77133bc5419f 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1402,6 +1402,86 @@ void *xa_find_after(struct xarray *xa, unsigned long *indexp,
 }
 EXPORT_SYMBOL(xa_find_after);
 
+static unsigned int xas_extract_present(struct xa_state *xas, void **dst,
+			unsigned long max, unsigned int n)
+{
+	void *entry;
+	unsigned int i = 0;
+
+	rcu_read_lock();
+	xas_for_each(xas, entry, max) {
+		if (xas_retry(xas, entry))
+			continue;
+		dst[i++] = entry;
+		if (i == n)
+			break;
+	}
+	rcu_read_unlock();
+
+	return i;
+}
+
+static unsigned int xas_extract_tag(struct xa_state *xas, void **dst,
+			unsigned long max, unsigned int n, xa_tag_t tag)
+{
+	void *entry;
+	unsigned int i = 0;
+
+	rcu_read_lock();
+	xas_for_each_tag(xas, entry, max, tag) {
+		if (xas_retry(xas, entry))
+			continue;
+		dst[i++] = entry;
+		if (i == n)
+			break;
+	}
+	rcu_read_unlock();
+
+	return i;
+}
+
+/**
+ * xa_extract() - Copy selected entries from the XArray into a normal array.
+ * @xa: The source XArray to copy from.
+ * @dst: The buffer to copy entries into.
+ * @start: The first index in the XArray eligible to be selected.
+ * @max: The last index in the XArray eligible to be selected.
+ * @n: The maximum number of entries to copy.
+ * @filter: Selection criterion.
+ *
+ * Copies up to @n entries that match @filter from the XArray.  The
+ * copied entries will have indices between @start and @max, inclusive.
+ *
+ * The @filter may be an XArray tag value, in which case entries which are
+ * tagged with that tag will be copied.  It may also be %XA_PRESENT, in
+ * which case non-NULL entries will be copied.
+ *
+ * The entries returned may not represent a snapshot of the XArray at a
+ * moment in time.  For example, if another thread stores to index 5, then
+ * index 10, calling xa_extract() may return the old contents of index 5
+ * and the new contents of index 10.  Indices not modified while this
+ * function is running will not be skipped.
+ *
+ * If you need stronger guarantees, holding the xa_lock across calls to this
+ * function will prevent concurrent modification.
+ *
+ * Context: Any context.  Takes and releases the RCU lock.
+ * Return: The number of entries copied.
+ */
+unsigned int xa_extract(struct xarray *xa, void **dst, unsigned long start,
+			unsigned long max, unsigned int n, xa_tag_t filter)
+{
+	XA_STATE(xas, xa, start);
+
+	if (!n)
+		return 0;
+
+	if ((__force unsigned int)filter < XA_MAX_TAGS)
+		return xas_extract_tag(&xas, dst, max, n, filter);
+	return xas_extract_present(&xas, dst, max, n);
+}
+EXPORT_SYMBOL(xa_extract);
+
 #ifdef XA_DEBUG
 void xa_dump_node(const struct xa_node *node)
 {
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
