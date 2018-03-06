From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 24/63] xarray: Add xas_create_range
Date: Tue,  6 Mar 2018 11:23:34 -0800
Message-ID: <20180306192413.5499-25-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5DGecaPqz+MyuZZNxvRv/n4mcETcUg6v7sGnAIwI8ng=; b=EvjoZymR96jrZkWJTSqV24xfz
        /PKxEGfeybapJue0RKOOJZQp2GbS9bNk6g8PIYn3kSb2phLDa212NWYbN070g6LFTYSCIFopSCnwQ
        NwcyA959z3osc8B5XiU+yBHyU2qeEMaNR6BGzp3QdYDSUIPVrUO2xON0fMqPbt/7VDI3T8qPg/X77
        TVbdDV2+FtwJDa8PNdOHlo9XXg883pRnAGS3gqryMsjLQmVZNTdLzaj845xdICbH3XhQPs4WJhPAD
        Yftj8DqwNgDGn7k90m4jhHGa78fpobtjNrFQeBl3VD78NNnGBw6tr0NTrROaUoSY/MYQsMc3uLuoC
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This hopefully temporary function is useful for users who have not yet
been converted to multi-index entries.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h |  2 ++
 lib/xarray.c           | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index c8a0ddc1b3df..387be18d05ba 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -744,6 +744,8 @@ void xas_init_tags(const struct xa_state *);
 bool xas_nomem(struct xa_state *, gfp_t);
 void xas_pause(struct xa_state *);
 
+void xas_create_range(struct xa_state *, unsigned long max);
+
 /**
  * xas_reload() - Refetch an entry from the xarray.
  * @xas: XArray operation state.
diff --git a/lib/xarray.c b/lib/xarray.c
index 7cf195b6e740..1d94ecc2dca3 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -612,6 +612,28 @@ void *xas_create(struct xa_state *xas)
 }
 EXPORT_SYMBOL_GPL(xas_create);
 
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
 static void store_siblings(struct xa_state *xas, void *entry, void *curr,
 				int *countp, int *valuesp)
 {
-- 
2.16.1

