From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 50/61] memfd: Convert shmem_tag_pins to XArray
Date: Tue, 13 Mar 2018 06:26:28 -0700
Message-ID: <20180313132639.17387-51-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gyb9Qm4DfyPt3dYM4uU9XVaSLgvPmG8u7M2kgi/AW98=; b=Zb4sYGdCFt1Rv32iFSYGmH28y
        mLnjtRY1YhyhXtN0RzcdX6kbUZ7TrgnEliu/RLCIcdUV7KCHSv3AmHF5JlIQlBos9qpvzimSyHb/0
        cNqJtGMVBz/aGmi65nJ+JZvyA2aEoLaqVOuuN6l7tnkk9sBvyYkGEROFYQicin+1nD5Q57qy3KnOY
        lNrK33OlXSOigzfmhZywn27MD2MY7MACrRtrMQ/v1rH5q3omPWwlJxwQpYvo83Dksm/btwK40WDXb
        zpTXI9nXYmeXrHsKmhFQnUdNvCYvjcYg7mUcf2isAapMH8KIzU002D6M+88J7h3Dvt15Esai0Lx8X
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Simplify the locking by taking the spinlock while we walk the tree on
the assumption that many acquires and releases of the lock will be
worse than holding the lock for a (potentially) long time.

We could replicate the same locking behaviour with the xarray, but would
have to be careful that the xa_node wasn't RCU-freed under us before we
took the lock.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/memfd.c | 43 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index 4cf7401cb09c..3b299d72df78 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -21,7 +21,7 @@
 #include <uapi/linux/memfd.h>
 
 /*
- * We need a tag: a new tag would expand every radix_tree_node by 8 bytes,
+ * We need a tag: a new tag would expand every xa_node by 8 bytes,
  * so reuse a tag which we firmly believe is never set or cleared on shmem.
  */
 #define SHMEM_TAG_PINNED        PAGECACHE_TAG_TOWRITE
@@ -29,35 +29,28 @@
 
 static void shmem_tag_pins(struct address_space *mapping)
 {
-	struct radix_tree_iter iter;
-	void __rcu **slot;
-	pgoff_t start;
+	XA_STATE(xas, &mapping->i_pages, 0);
 	struct page *page;
+	unsigned int tagged = 0;
 
 	lru_add_drain();
-	start = 0;
-	rcu_read_lock();
-
-	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
-		page = radix_tree_deref_slot(slot);
-		if (!page || radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page)) {
-				slot = radix_tree_iter_retry(&iter);
-				continue;
-			}
-		} else if (page_count(page) - page_mapcount(page) > 1) {
-			xa_lock_irq(&mapping->i_pages);
-			radix_tree_tag_set(&mapping->i_pages, iter.index,
-					   SHMEM_TAG_PINNED);
-			xa_unlock_irq(&mapping->i_pages);
-		}
 
-		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
-			cond_resched_rcu();
-		}
+	xas_lock_irq(&xas);
+	xas_for_each(&xas, page, ULONG_MAX) {
+		if (xa_is_value(page))
+			continue;
+		if (page_count(page) - page_mapcount(page) > 1)
+			xas_set_tag(&xas, SHMEM_TAG_PINNED);
+
+		if (++tagged % XA_CHECK_SCHED)
+			continue;
+
+		xas_pause(&xas);
+		xas_unlock_irq(&xas);
+		cond_resched();
+		xas_lock_irq(&xas);
 	}
-	rcu_read_unlock();
+	xas_unlock_irq(&xas);
 }
 
 /*
-- 
2.16.1

