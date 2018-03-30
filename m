From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 15/62] xarray: Add xas_create_range
Date: Thu, 29 Mar 2018 20:41:58 -0700
Message-ID: <20180330034245.10462-16-willy@infradead.org>
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
 bh=LcJlXy9u9EDaPZiTa37FCvjmWDdzNfvQb2mg2qOYsSM=; b=eG19Zr5B5RHiD88DXOdtIH8EW7
 vtnCMGoUTYTnPP13Rwgf6fjx22nRVBH8Vyq0bBDECLimYuXr8Vh6PwK0fNmk+e0Eh9NGdT/P2IJRI
 beQsu+9dokpDHNMbw+ytqfG6kq/0AzfIaY5L4o1gKUg1X3xmJVsJTxLZd+E2UWwUatbQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=LcJlXy9u9EDaPZiTa37FCvjmWDdzNfvQb2mg2qOYsSM=; b=Wu3VJmlVtx6Wp7YXvmFvgt6rxW
 tqu831SblbGJIvdhUmXsFqWhj2KWvFuefQZOT3g44KHfpFY0A3r79aq6JmHlvQ6EOnrg3DydvFtxh
 xur2DO0hBGxiwc3rM73+P9VC8xn/KX/5aoFRVPF2/dH7k/Q5htQcjOq8rzDfObi9YLGI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=LcJlXy9u9EDaPZiTa37FCvjmWDdzNfvQb2mg2qOYsSM=; b=ct81CkP8oaPrOHcnVW7AEuw8X
 tVMZRM/nSsgrX48eKNDRlLDzmvocPchT6tGw7QgVMGbzgSwKVrWhi+P8eLr4DpRqPUdS8gxRRCPrv
 slWT+R1n/DpOO5IHDOmQhjQU68MIN4kVAyqM4J1mg2WW6Az0NSLlRZim4epbw1v8yvwubO4DJWSfo
 iJ1mYktQcdKambc9edHMRZ9rNM+kb+PA210W3/zGp4QD/5AAnH6eJ9LJ7Pas4GxE4gZhKaHN5SPbz
 lzu5yyj1pKo5ydva22QTQ57/6NFwcuU1mwFGIjcrNdHZS31xT99Y6OZGEayI+VvX1TX77jV00QdQO
 2JxLKvwpA==;
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

This hopefully temporary function is useful for users who have not yet
been converted to multi-index entries.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h |  2 ++
 lib/xarray.c           | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 998a5bc0cbac..18ea970ca67d 100644
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
index 7574bafbc6ff..653ab0555673 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -626,6 +626,28 @@ void *xas_create(struct xa_state *xas)
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
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
