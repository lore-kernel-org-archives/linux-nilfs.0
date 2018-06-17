From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 14/74] xarray: Extract entries from an XArray
Date: Sat, 16 Jun 2018 18:59:52 -0700
Message-ID: <20180617020052.4759-15-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
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
 bh=6CtH22NpoaemDSFVaBuH/UKCnAIo12i5SDA7CsPpPB8=; b=mX5zunOZPK8lus927oYcORrGDo
 7NJtHR24AR76NEchYkiH8kzz9lZYlvx8kP8QpH2RSvNspPHnpchh6nMZzv3MBqtyOwczSwZ02ZB5Y
 wvPHODR25u4QbkkwLCJNVK36fRKqbq1QYoz9rU6EwaHF+UCND9yMpW/5wWQV9oq6Sskc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=6CtH22NpoaemDSFVaBuH/UKCnAIo12i5SDA7CsPpPB8=; b=foh1P8nZUnSRHIHhSIRj89wEEj
 CBP+awcX+b7sfOIQF5vLsDh+3B6xFYbgCtmIpwBzwAfp6JC0tpg1iqdiKDC5PoFRngLLjhtFHCt/u
 njauXCaq9K5f/PaN1VX0ZSPRmM7QzkuoY79ELh2bsFC5FoTEV7z/0UYzrzrR3ku26yjU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=6CtH22NpoaemDSFVaBuH/UKCnAIo12i5SDA7CsPpPB8=; b=enZlbfI9wXXz6+EBEkFiy9m/k
 kt+C1t9v+DOjsgRjSlROOtXSExB0JfbGElKzRRlkpDixFmAsj7NqoYl2vkaNRaAV9e2qsBLbawMd7
 2V+NPrpcpZr6Tz9vH6txcgm1gsZQEthoYzoWVpuIbZN9iKx8Nczisl6Kf7ODKpnWM5U4nNqJUzKQU
 k2dxk7v2a30hWRXlDFVIobiPkbwfGy5H5+5On4MFGEIG4gDqydppCgcT8oHofRynWzWHq3ynIWJKE
 yI4DbKG1dLpTYowlYpBvwZBWXNe7JCH1ajp+0EW+pTITfO03ovzN3TENi+EQ8pMTkW4/YaYTdvDrE
 75myFGVhg==;
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

The xa_extract function combines the functionality of
radix_tree_gang_lookup() and radix_tree_gang_lookup_tagged().
It extracts entries matching the specified filter into a normal array.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 include/linux/xarray.h |  2 ++
 lib/xarray.c           | 80 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 0790b3b098f0..6f398732b664 100644
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
index 8756ca22363e..1e15ead40d78 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1413,6 +1413,86 @@ void *xa_find_after(struct xarray *xa, unsigned long *indexp,
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
+	xas_for_each_tagged(xas, entry, max, tag) {
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
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
