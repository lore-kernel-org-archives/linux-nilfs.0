From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 18/73] xarray: Add xas_create_range
Date: Tue,  5 Dec 2017 16:41:04 -0800
Message-ID: <20171206004159.3755-19-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ln8DVnVmZ/F8lfnVUjv5FGoEKLoDa90dAa4HcLubwzQ=; b=iA7nIfTljJ2VFoaKPgIypoVnp
        TR/hzhzsk0gUMA//34JSHZJIeNRVQ8eSXxFArDUhVA7vLEXyNvh9NsmVcuD3zf3Wlu2oLz/LluDHa
        5QtuFmbv432C0vJL2X42YBYkANFrF7yLG7IqngYJsWFvwWr7kV+jbUuwoi738aQehUJEDPeXRLSYf
        DeMS0zkRBrJGoy5b7k6ZCc71uIUPC8u+XizeIQybXRVIOIeCANCc6VJed4WF4JyM3Mf91+3pVmN1x
        fM1Y9fCdce9gSdMCHkdSTSv61EWHebVc0Fi9ImCEXd/O139e6l53L73FWGg8O8KXMuAl/xZd351cg
    
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This hopefully temporary function is useful for users who have not yet
been converted to multi-index entries.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h |  2 ++
 lib/xarray.c           | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 416708ace115..afa3374f20bd 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -594,6 +594,8 @@ void xas_init_tags(const struct xa_state *);
 bool xas_nomem(struct xa_state *, gfp_t);
 void xas_pause(struct xa_state *);
 
+void xas_create_range(struct xa_state *, unsigned long max);
+
 /**
  * xas_reload() - Refetch an entry from the xarray.
  * @xas: XArray operation state.
diff --git a/lib/xarray.c b/lib/xarray.c
index 8c6e83d10554..cc88df7bd6df 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -570,6 +570,28 @@ void *xas_create(struct xa_state *xas)
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
 static void store_siblings(struct xa_state *xas,
 				void *entry, int *countp, int *valuesp)
 {
-- 
2.15.0

