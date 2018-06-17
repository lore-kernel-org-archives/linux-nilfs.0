From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 18/74] xarray: Add xas_create_range
Date: Sat, 16 Jun 2018 18:59:56 -0700
Message-ID: <20180617020052.4759-19-willy@infradead.org>
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
 bh=OyTxRmV4rAGKG2darjx2yztVr7oEJA+CTmBQXtKXahU=; b=Bu/Dv3+4aJnylOhJiLBtFG5XPq
 9g5JGDILoq3tTBavnM5gKuG6ujtX4mgd5qFrvQMhAAnXNSzq3XNFP1g8xeaZr6q6PjcaDdEA2ViOg
 wjxfeyC9Im86oQaDhKaqOiv7c4ApTA6wqP+XNzEWCGgqfScNdLlcWggA+cp7dPxMC/5I=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=OyTxRmV4rAGKG2darjx2yztVr7oEJA+CTmBQXtKXahU=; b=SRFJiT02yeBC0ByT4T2Oa8e6fm
 RBMEkHHmHOC7OyvNf/2JObC90wFrj1PCW8RbVow827xh++K2DS27XZ5HSv3EIocSdH6v8BBVQAEEe
 nhdK+eC8wxAEZ57Ohg2ITIMsqmSjYdOtdowFz7zUtT779ir2ZDrUQky9MgUI4v4fPFB0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=OyTxRmV4rAGKG2darjx2yztVr7oEJA+CTmBQXtKXahU=; b=gDF3lmtKPsIfl/KAjw0ZGO5lb
 Oz3l57T7cUbwXB++x26fnGv4h1FC/U7AwhfOSit0DD0lz+suJ7uk1YdKchwDBcBBbvGhsRGzwpG1A
 KsBakYBNx9W0h5XuKS33Hd3Xg8A31SplhEfMTJrD0ZkTLOPhqNdYZI9vNcdFn3vTJ1AJxOIdICnMw
 SoRP5Eqf8Nk0vREpa8lgzOsLVOH1M8U5ABopvFYzPgtjbCzCUGepXp94Z2AAwYQNjw1ufqVpWjS5J
 QjpNih1c0jMNLwMvl62NQTpaZqt3NqGEKmoLoL4M/8VR3Hn8l6FwDkc4IClxwJw8w+sbQwk2WEG7F
 jrCv2EQXw==;
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

This hopefully temporary function is useful for users who have not yet
been converted to multi-index entries.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 include/linux/xarray.h |  2 ++
 lib/xarray.c           | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 0a9f66266c9a..b78c2e9aa065 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -780,6 +780,8 @@ void xas_init_tags(const struct xa_state *);
 bool xas_nomem(struct xa_state *, gfp_t);
 void xas_pause(struct xa_state *);
 
+void xas_create_range(struct xa_state *, unsigned long max);
+
 /**
  * xas_reload() - Refetch an entry from the xarray.
  * @xas: XArray operation state.
diff --git a/lib/xarray.c b/lib/xarray.c
index 31c5332c8146..8dddad5b237c 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -624,6 +624,28 @@ static void *xas_create(struct xa_state *xas)
 	return entry;
 }
 
+/**
+ * xas_create_range() - Ensure that stores to this range will succeed
+ * @xas: XArray operation state.
+ * @max: The highest index to create a slot for.
+ *
+ * Creates all of the slots in the range between the current position of
+ * @xas and @max.  This is for the benefit of users who have not yet been
+ * converted to multi-index entries.
+ *
+ * The implementation is naive.
+ */
+void xas_create_range(struct xa_state *xas, unsigned long max)
+{
+	XA_STATE(tmp, xas->xa, xas->xa_index);
+
+	do {
+		xas_create(&tmp);
+		xas_set(&tmp, tmp.xa_index + XA_CHUNK_SIZE);
+	} while (tmp.xa_index < max);
+}
+EXPORT_SYMBOL_GPL(xas_create_range);
+
 static void update_node(struct xa_state *xas, struct xa_node *node,
 		int count, int values)
 {
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
