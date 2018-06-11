From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 17/72] xarray: Add xas_create_range
Date: Mon, 11 Jun 2018 07:05:44 -0700
Message-ID: <20180611140639.17215-18-willy@infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rzcF3hO6XLxL1/X+Qfq4B5Sb1mRT7xWTj3jwSQZnKAY=; b=IlC4BzX2BUIPttCfGDa0MuHBd
        sD223X+RrLG5ghncJf7hAIf7tuAt7/O2sOzB8gok99ra8ROxmbf5/fvjMcQ5RwtSZFxso8L00YhOW
        EcBlBOZinbt4WRWaXOcFGBq+bahGYwHXWEd7jkqGIt8TS8YqTAP7Fg/r7E8keDBeqpWE5GlecKGWd
        fgfQM4S16OhVwiqe7tK/OgwgwHbWVsGCy9eTufPD/7UdLXYpj2siBjdyJY9bP5WHxIy6ORMFidiPm
        R2MoR44s+FogOy47TC8m0Twe4mucgilfBnd7rr0SUhWvVWnw1IqvvrPONn9t+sgUZtl9b18YwPisd
    
In-Reply-To: <20180611140639.17215-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net

From: Matthew Wilcox <mawilcox@microsoft.com>

This hopefully temporary function is useful for users who have not yet
been converted to multi-index entries.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h |  2 ++
 lib/xarray.c           | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 6a61aab11038..907ecb1d3077 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -761,6 +761,8 @@ void xas_init_tags(const struct xa_state *);
 bool xas_nomem(struct xa_state *, gfp_t);
 void xas_pause(struct xa_state *);
 
+void xas_create_range(struct xa_state *, unsigned long max);
+
 /**
  * xas_reload() - Refetch an entry from the xarray.
  * @xas: XArray operation state.
diff --git a/lib/xarray.c b/lib/xarray.c
index d76db0ff17cf..566c4e233c05 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -638,6 +638,28 @@ static void *xas_create(struct xa_state *xas)
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

