From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 75/78] usb: Convert xhci-mem to XArray
Date: Fri, 15 Dec 2017 14:04:47 -0800
Message-ID: <20171215220450.7899-76-willy@infradead.org>
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
 bh=2s7FTcpqbBpqeoo53Wt/pymrRRQ6j9Pq9BgxI7UNCGU=; b=k8T5FWuDmNMIXm1WgqVh34tFqJ
 4GKkBONsQIxTR7ZCDNzRqvJl0PC6zy41OyV3v7Wyhyf0iQ2Tn0oFwP8FtEvhko1JDhfVTKn5XF6Rr
 gcpA3oysxGyQSzIutywIJBA7D1XZ5z/F/nB2HrRQL7TkyY94NXvvb5g3qsImZAwyy+9k=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=2s7FTcpqbBpqeoo53Wt/pymrRRQ6j9Pq9BgxI7UNCGU=; b=gJ7tkqZ0pdoDyxVig8tXBM1k8L
 Y9OWolOhkqlah692HfgLXQQq4llSRNZstPpTdRlRV8EibTKs00tpBXh3aiSmm2v0pCBJsJ7L6JRVj
 sA0dIsPdmV4zScauHmn/wto2uPqU1dVEZPJm32E3Kv1dYNQiCzbPwEhGSutXFCEvrkLs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=2s7FTcpqbBpqeoo53Wt/pymrRRQ6j9Pq9BgxI7UNCGU=; b=teYp7LTXcjedgzVFPMvpwS86N
 kUQwrXd7i13mBs+05hOPva//LvWO3rrumlyFSQxP2V0b5iwUR1N2JJbm2DKpOlwPPtSwSNJA8m9+E
 LpSOIKYsNStBE/vgr5YWbgRTIbQfxpNptxZ1Y6NvZx+272wUIW3H+IWq/9Wq/QuyrHOzZ92FvyKCN
 jab/nn4heRn1iYxBl68tyXYjfAJW9Z85msSPUuCN+nvLL6WDnkxq8IBsparhsWqEfR9kHjjFYSdux
 jK582Lbd0usWiJMG7NqvrwV5K57zPV6AfBy8UfkokZrZKlja1jz82geSKyI64pxQoGBHbXNxOvvAU
 AQQkaoxDQ==;
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

The XArray API is a slightly better fit for xhci_insert_segment_mapping()
than the radix tree API was.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/usb/host/xhci-mem.c | 68 +++++++++++++++++++--------------------------
 drivers/usb/host/xhci.h     |  6 ++--
 2 files changed, 32 insertions(+), 42 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 15f7d422885f..9a2a02d244b0 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -149,70 +149,60 @@ static void xhci_link_rings(struct xhci_hcd *xhci, struct xhci_ring *ring,
 }
 
 /*
- * We need a radix tree for mapping physical addresses of TRBs to which stream
- * ID they belong to.  We need to do this because the host controller won't tell
+ * We need to map physical addresses of TRBs to the stream ID they belong to.
+ * We need to do this because the host controller won't tell
  * us which stream ring the TRB came from.  We could store the stream ID in an
  * event data TRB, but that doesn't help us for the cancellation case, since the
  * endpoint may stop before it reaches that event data TRB.
  *
- * The radix tree maps the upper portion of the TRB DMA address to a ring
+ * The xarray maps the upper portion of the TRB DMA address to a ring
  * segment that has the same upper portion of DMA addresses.  For example, say I
  * have segments of size 1KB, that are always 1KB aligned.  A segment may
  * start at 0x10c91000 and end at 0x10c913f0.  If I use the upper 10 bits, the
- * key to the stream ID is 0x43244.  I can use the DMA address of the TRB to
- * pass the radix tree a key to get the right stream ID:
+ * index of the stream ID is 0x43244.  I can use the DMA address of the TRB as
+ * the xarray index to get the right stream ID:
  *
  *	0x10c90fff >> 10 = 0x43243
  *	0x10c912c0 >> 10 = 0x43244
  *	0x10c91400 >> 10 = 0x43245
  *
  * Obviously, only those TRBs with DMA addresses that are within the segment
- * will make the radix tree return the stream ID for that ring.
+ * will make the xarray return the stream ID for that ring.
  *
- * Caveats for the radix tree:
+ * Caveats for the xarray:
  *
- * The radix tree uses an unsigned long as a key pair.  On 32-bit systems, an
+ * The xarray uses an unsigned long for the index.  On 32-bit systems, an
  * unsigned long will be 32-bits; on a 64-bit system an unsigned long will be
  * 64-bits.  Since we only request 32-bit DMA addresses, we can use that as the
- * key on 32-bit or 64-bit systems (it would also be fine if we asked for 64-bit
- * PCI DMA addresses on a 64-bit system).  There might be a problem on 32-bit
- * extended systems (where the DMA address can be bigger than 32-bits),
+ * index on 32-bit or 64-bit systems (it would also be fine if we asked for
+ * 64-bit PCI DMA addresses on a 64-bit system).  There might be a problem on
+ * 32-bit extended systems (where the DMA address can be bigger than 32-bits),
  * if we allow the PCI dma mask to be bigger than 32-bits.  So don't do that.
  */
-static int xhci_insert_segment_mapping(struct radix_tree_root *trb_address_map,
+
+static unsigned long trb_index(dma_addr_t dma)
+{
+	return (unsigned long)(dma >> TRB_SEGMENT_SHIFT);
+}
+
+static int xhci_insert_segment_mapping(struct xarray *trb_address_map,
 		struct xhci_ring *ring,
 		struct xhci_segment *seg,
-		gfp_t mem_flags)
+		gfp_t gfp)
 {
-	unsigned long key;
-	int ret;
-
-	key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
 	/* Skip any segments that were already added. */
-	if (radix_tree_lookup(trb_address_map, key))
-		return 0;
-
-	ret = radix_tree_maybe_preload(mem_flags);
-	if (ret)
-		return ret;
-	ret = radix_tree_insert(trb_address_map,
-			key, ring);
-	radix_tree_preload_end();
-	return ret;
+	return xa_err(xa_cmpxchg(trb_address_map, trb_index(seg->dma), NULL,
+								ring, gfp));
 }
 
-static void xhci_remove_segment_mapping(struct radix_tree_root *trb_address_map,
+static void xhci_remove_segment_mapping(struct xarray *trb_address_map,
 		struct xhci_segment *seg)
 {
-	unsigned long key;
-
-	key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
-	if (radix_tree_lookup(trb_address_map, key))
-		radix_tree_delete(trb_address_map, key);
+	xa_erase(trb_address_map, trb_index(seg->dma));
 }
 
 static int xhci_update_stream_segment_mapping(
-		struct radix_tree_root *trb_address_map,
+		struct xarray *trb_address_map,
 		struct xhci_ring *ring,
 		struct xhci_segment *first_seg,
 		struct xhci_segment *last_seg,
@@ -574,8 +564,8 @@ struct xhci_ring *xhci_dma_to_transfer_ring(
 		u64 address)
 {
 	if (ep->ep_state & EP_HAS_STREAMS)
-		return radix_tree_lookup(&ep->stream_info->trb_address_map,
-				address >> TRB_SEGMENT_SHIFT);
+		return xa_load(&ep->stream_info->trb_address_map,
+				trb_index(address));
 	return ep->ring;
 }
 
@@ -654,10 +644,10 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 	if (!stream_info->free_streams_command)
 		goto cleanup_ctx;
 
-	INIT_RADIX_TREE(&stream_info->trb_address_map, GFP_ATOMIC);
+	xa_init(&stream_info->trb_address_map);
 
 	/* Allocate rings for all the streams that the driver will use,
-	 * and add their segment DMA addresses to the radix tree.
+	 * and add their segment DMA addresses to the map.
 	 * Stream 0 is reserved.
 	 */
 
@@ -2369,7 +2359,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	 * Initialize the ring segment pool.  The ring must be a contiguous
 	 * structure comprised of TRBs.  The TRBs must be 16 byte aligned,
 	 * however, the command ring segment needs 64-byte aligned segments
-	 * and our use of dma addresses in the trb_address_map radix tree needs
+	 * and our use of dma addresses in the trb_address_map xarray needs
 	 * TRB_SEGMENT_SIZE alignment, so we pick the greater alignment need.
 	 */
 	xhci->segment_pool = dma_pool_create("xHCI ring segments", dev,
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 054ce74524af..e8208a3eee3c 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -15,7 +15,7 @@
 #include <linux/usb.h>
 #include <linux/timer.h>
 #include <linux/kernel.h>
-#include <linux/radix-tree.h>
+#include <linux/xarray.h>
 #include <linux/usb/hcd.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 
@@ -837,7 +837,7 @@ struct xhci_stream_info {
 	unsigned int			num_stream_ctxs;
 	dma_addr_t			ctx_array_dma;
 	/* For mapping physical TRB addresses to segments in stream rings */
-	struct radix_tree_root		trb_address_map;
+	struct xarray			trb_address_map;
 	struct xhci_command		*free_streams_command;
 };
 
@@ -1584,7 +1584,7 @@ struct xhci_ring {
 	unsigned int		bounce_buf_len;
 	enum xhci_ring_type	type;
 	bool			last_td_was_short;
-	struct radix_tree_root	*trb_address_map;
+	struct xarray		*trb_address_map;
 };
 
 struct xhci_erst_entry {
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
