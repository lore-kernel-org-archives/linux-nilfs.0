From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 54/74] memfd: Convert memfd_wait_for_pins to
 XArray
Date: Sat, 16 Jun 2018 19:00:32 -0700
Message-ID: <20180617020052.4759-55-willy@infradead.org>
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
 bh=taP8BwheHg3CEkDXuvl7b4R9WQ7b3YzBrhJkOgu4qeA=; b=eThhcq3hnlabVMYntTsJMvITVt
 mX5EOnB2D5qx4UF46KTem8I6bIC/P+U0mDHYtvLY2LXCuytD0Q3hRNr2VJo977bRppYD8PDKQoRYu
 KIkYwkw1LN8cSXxpnXCKwPwPCkXTxhEtqtdTqCV6YcTGVxBom38JQCDK9yvakKrQmqsU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=taP8BwheHg3CEkDXuvl7b4R9WQ7b3YzBrhJkOgu4qeA=; b=TJVlxgPjgRZ4kLiUdDwT95QIYV
 iWuIGMu8SK2Jvh8In1vXw29LM4RkAPkrOisw1l/ciITJzg+rCSZ3x0PVSr9tkNViFwJOyfiWAmD0M
 Xn6DQ98XElnDtE7/kCEoXtJSK22R5j1PkOsLaUmr3y+j/D0Xb0lmJ2Mz+/a1uMaZAbxs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=taP8BwheHg3CEkDXuvl7b4R9WQ7b3YzBrhJkOgu4qeA=; b=mnOUCgq42hLXgcqQvdSJolBa4
 M2pHHerVUVQEAix/TXoPd/ZLNBXq46cwsAlwSXV34gaKqxdjMLDbIBuoLXtyO82BlJoMu8EfMh9ux
 pU3APwkzHc+vWtyGCLTLQ0cASLWRek2CsfN52jLPIlRjl9TV8tFIG/BNt6M9s9LZtM+AhKQ7EzJAp
 Y0JCImZZCPzVXB8OH2ekbiLa4xE5a2zPEzVoiptNgLCITKe5yxa70ZBRvxCZSbxxWiBqH4a2eOYWC
 +vtRoNDpb/8Lt7UHE2Cbqt6i3VnUNVTgVl8WLCtiLvyowoAKYnhgT5Dk3nnSM+cKTl0E7N2qZ6y0Q
 a/tTBK1sw==;
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

Simplify the locking by taking the spinlock while we walk the tree on
the assumption that many acquires and releases of the lock will be worse
than holding the lock while we process an entire batch of pages.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/memfd.c | 61 ++++++++++++++++++++++--------------------------------
 1 file changed, 25 insertions(+), 36 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index 27069518e3c5..e7d6be725b7a 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -21,7 +21,7 @@
 #include <uapi/linux/memfd.h>
 
 /*
- * We need a tag: a new tag would expand every radix_tree_node by 8 bytes,
+ * We need a tag: a new tag would expand every xa_node by 8 bytes,
  * so reuse a tag which we firmly believe is never set or cleared on tmpfs
  * or hugetlbfs because they are memory only filesystems.
  */
@@ -72,9 +72,7 @@ static void memfd_tag_pins(struct address_space *mapping)
  */
 static int memfd_wait_for_pins(struct address_space *mapping)
 {
-	struct radix_tree_iter iter;
-	void __rcu **slot;
-	pgoff_t start;
+	XA_STATE(xas, &mapping->i_pages, 0);
 	struct page *page;
 	int error, scan;
 
@@ -82,7 +80,9 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 
 	error = 0;
 	for (scan = 0; scan <= LAST_SCAN; scan++) {
-		if (!radix_tree_tagged(&mapping->i_pages, MEMFD_TAG_PINNED))
+		unsigned int tagged = 0;
+
+		if (!xas_tagged(&xas, MEMFD_TAG_PINNED))
 			break;
 
 		if (!scan)
@@ -90,45 +90,34 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 		else if (schedule_timeout_killable((HZ << scan) / 200))
 			scan = LAST_SCAN;
 
-		start = 0;
-		rcu_read_lock();
-		radix_tree_for_each_tagged(slot, &mapping->i_pages, &iter,
-					   start, MEMFD_TAG_PINNED) {
-
-			page = radix_tree_deref_slot(slot);
-			if (radix_tree_exception(page)) {
-				if (radix_tree_deref_retry(page)) {
-					slot = radix_tree_iter_retry(&iter);
-					continue;
-				}
-
-				page = NULL;
-			}
-
-			if (page &&
-			    page_count(page) - page_mapcount(page) != 1) {
-				if (scan < LAST_SCAN)
-					goto continue_resched;
-
+		xas_set(&xas, 0);
+		xas_lock_irq(&xas);
+		xas_for_each_tagged(&xas, page, ULONG_MAX, MEMFD_TAG_PINNED) {
+			bool clear = true;
+			if (xa_is_value(page))
+				continue;
+			if (page_count(page) - page_mapcount(page) != 1) {
 				/*
 				 * On the last scan, we clean up all those tags
 				 * we inserted; but make a note that we still
 				 * found pages pinned.
 				 */
-				error = -EBUSY;
+				if (scan == LAST_SCAN)
+					error = -EBUSY;
+				else
+					clear = false;
 			}
+			if (clear)
+				xas_clear_tag(&xas, MEMFD_TAG_PINNED);
+			if (++tagged % XA_CHECK_SCHED)
+				continue;
 
-			xa_lock_irq(&mapping->i_pages);
-			radix_tree_tag_clear(&mapping->i_pages,
-					     iter.index, MEMFD_TAG_PINNED);
-			xa_unlock_irq(&mapping->i_pages);
-continue_resched:
-			if (need_resched()) {
-				slot = radix_tree_iter_resume(slot, &iter);
-				cond_resched_rcu();
-			}
+			xas_pause(&xas);
+			xas_unlock_irq(&xas);
+			cond_resched();
+			xas_lock_irq(&xas);
 		}
-		rcu_read_unlock();
+		xas_unlock_irq(&xas);
 	}
 
 	return error;
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
