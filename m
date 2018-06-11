From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 48/72] shmem: Convert find_swap_entry to
 XArray
Date: Mon, 11 Jun 2018 07:06:15 -0700
Message-ID: <20180611140639.17215-49-willy@infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
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
 bh=jGmi8q2eJKLoEu0xg6LdGVZ3YCLCZYH2N+fwRAOSbTc=; b=DtM28/Xzh2FyGJuY+omNlZxqez
 CbiW2xWMj8WN6QsOd/9rApZBwPJFLSrWsWswfNIlBiIMLHB9xZWag52D8xN0OjSpvzo0tKRCApH6t
 FP6UhuguQCelsjBY3yn8qF8RP1j/3/iUcBh7hHCW5gLfQ5fWsjBOq8RHOHxRBO1G2Uu8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=jGmi8q2eJKLoEu0xg6LdGVZ3YCLCZYH2N+fwRAOSbTc=; b=UwonW00bzmeWWDF79Atc4UxyvZ
 Zt7KfPoh+iNTBbWRYW7+qLgqWc2WaERy9iutcZHSGpXOlWLYNsm7BJtyk9wU4gMwab8AZBGH9Sc1n
 EsaVlaDGAK4H6aQo5pDGvwpviz8izRvgoxh7b+oEjrmphLN/sG4HQPCLMQZYBjhm79i8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=jGmi8q2eJKLoEu0xg6LdGVZ3YCLCZYH2N+fwRAOSbTc=; b=nw5wsaxAg7PXkxISMGsjS8auB
 exTQMXQmjdTXaF6KLSbpPUiWdc1XjGtKxLW3jdNr9ilXGBLBLjj/QXv3adaAXAwFo08bN+RcDmafy
 U1xBJF9Iz7EIMOlFMIpSUnCOgOfw7A761enXRxKmHjwUGqC4MoWffQQsTtHLA8CuHLs1JSbje7R9c
 HBlQgTEUXhxtJ9dtdh2yA0BhDc62PQPkx9KoDlx8SodXIMuxsfHu1JYJTLBNqfiSa1TdS4y0H56C8
 fgsleLGoFeo72pRnDoL63XgHbv9pfdGUb2Ezdi3TCFDf9/vdT0SwtqOnqBzo/oC/txDEAF0ZyyG0k
 pC1qXzGXg==;
In-Reply-To: <20180611140639.17215-1-willy@infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

This is a 1:1 conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 479e4a8e6d68..983a27656e2e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1099,34 +1099,27 @@ static void shmem_evict_inode(struct inode *inode)
 	clear_inode(inode);
 }
 
-static unsigned long find_swap_entry(struct radix_tree_root *root, void *item)
+static unsigned long find_swap_entry(struct xarray *xa, void *item)
 {
-	struct radix_tree_iter iter;
-	void __rcu **slot;
-	unsigned long found = -1;
+	XA_STATE(xas, xa, 0);
 	unsigned int checked = 0;
+	void *entry;
 
 	rcu_read_lock();
-	radix_tree_for_each_slot(slot, root, &iter, 0) {
-		void *entry = radix_tree_deref_slot(slot);
-
-		if (radix_tree_deref_retry(entry)) {
-			slot = radix_tree_iter_retry(&iter);
+	xas_for_each(&xas, entry, ULONG_MAX) {
+		if (xas_retry(&xas, entry))
 			continue;
-		}
-		if (entry == item) {
-			found = iter.index;
+		if (entry == item)
 			break;
-		}
 		checked++;
-		if ((checked % 4096) != 0)
+		if ((checked % XA_CHECK_SCHED) != 0)
 			continue;
-		slot = radix_tree_iter_resume(slot, &iter);
+		xas_pause(&xas);
 		cond_resched_rcu();
 	}
-
 	rcu_read_unlock();
-	return found;
+
+	return xas_invalid(&xas) ? -1 : xas.xa_index;
 }
 
 /*
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
