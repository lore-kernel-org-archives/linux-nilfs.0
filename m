From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 15/74] xarray: Destroy an XArray
Date: Sat, 16 Jun 2018 18:59:53 -0700
Message-ID: <20180617020052.4759-16-willy@infradead.org>
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
 bh=06qd/xlJg/OzH4I18kD3SK7TPii4ugk5m7Ua6YGXEhI=; b=iEvlSIqjcPG/ao11MF1p4MVwjc
 nQsybGQDhM6NNWti8M7u0ql4IFMQkZiSPA0Gipa+fvOry44UPVYjMINYyEXEYXzUksd2UG/Hcsjki
 ScNBQc9rGuqVpJdQyTEcwk7FOZapmxNMcu7wjDCKDQ/kkhR0TNFgAEasNp5UnD8/0Kd8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=06qd/xlJg/OzH4I18kD3SK7TPii4ugk5m7Ua6YGXEhI=; b=MMJ5luBtEe6VGmG8+rYXeqLcZ4
 gcmkyC4Ekk0+aklJWH6E6DBUIitJ13MqBCA0H5AzLI8T75OBXTpwhlXVgFArECuWctdTTidEzuORj
 HcUK/2RLqbXMYEdSMq6McRUfZewkBkrSjpkYUiLPtmHE6mIrOGACPpWiCc9gN6WtVOoI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=06qd/xlJg/OzH4I18kD3SK7TPii4ugk5m7Ua6YGXEhI=; b=ZRmlSBK92lq0ByjszBgzabJBy
 aN+v+EI3JNlMVXilNUWIQFVrfnJW3WWV80YUVEOmF/MeDPK2aYwOmxGlpmgR0+CBwALn0TRsOSQgh
 YTgKc7CZvvGIwIDDu0udK860oheV4TKYTQnDcoNf33oPV0YMk9UgyVZLb3jQXD+4IRRf1Xu4hFtOC
 jUpEWOWfOkpnmczEkeOjirw7TGBaQAJa2U9NEV3kVWdiCcpRUpS3cx9Q3PWtu8r52SmaRSrIaWacN
 sKTeeRUK12AvQWdFXuJmVfN5VfAzTrrswe1Y05hw6yfj6JRdP5z/I9RX0W2HCPN/YR9KKqsof817B
 mpdXxOE4w==;
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

This function frees all the internal memory allocated to the xarray
and reinitialises it to be empty.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 include/linux/xarray.h |  1 +
 lib/xarray.c           | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 6f398732b664..fa36a0670988 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -229,6 +229,7 @@ void *xa_find_after(struct xarray *xa, unsigned long *index,
 		unsigned long max, xa_tag_t) __attribute__((nonnull(2)));
 unsigned int xa_extract(struct xarray *, void **dst, unsigned long start,
 		unsigned long max, unsigned int n, xa_tag_t);
+void xa_destroy(struct xarray *);
 
 /**
  * xa_init() - Initialise an empty XArray.
diff --git a/lib/xarray.c b/lib/xarray.c
index 1e15ead40d78..e90ba76404ae 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1493,6 +1493,34 @@ unsigned int xa_extract(struct xarray *xa, void **dst, unsigned long start,
 }
 EXPORT_SYMBOL(xa_extract);
 
+/**
+ * xa_destroy() - Free all internal data structures.
+ * @xa: XArray.
+ *
+ * After calling this function, the XArray is empty and has freed all memory
+ * allocated for its internal data structures.  You are responsible for
+ * freeing the objects referenced by the XArray.
+ *
+ * Context: Any context.  Takes and releases the xa_lock, interrupt-safe.
+ */
+void xa_destroy(struct xarray *xa)
+{
+	XA_STATE(xas, xa, 0);
+	unsigned long flags;
+	void *entry;
+
+	xas.xa_node = NULL;
+	xas_lock_irqsave(&xas, flags);
+	entry = xa_head_locked(xa);
+	RCU_INIT_POINTER(xa->xa_head, NULL);
+	xas_init_tags(&xas);
+	/* lockdep checks we're still holding the lock in xas_free_nodes() */
+	if (xa_is_node(entry))
+		xas_free_nodes(&xas, xa_to_node(entry));
+	xas_unlock_irqrestore(&xas, flags);
+}
+EXPORT_SYMBOL(xa_destroy);
+
 #ifdef XA_DEBUG
 void xa_dump_node(const struct xa_node *node)
 {
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
