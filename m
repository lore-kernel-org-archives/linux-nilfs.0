From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 43/62] memfd: Convert shmem_tag_pins to XArray
Date: Thu, 29 Mar 2018 20:42:26 -0700
Message-ID: <20180330034245.10462-44-willy@infradead.org>
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
 bh=Kwmjn3C+1I1auj74fd/REnYkivjtnlP75vjR3ufF7kk=; b=LdZHWS0h8P+n3DRP2XIMy4HvuD
 yhko81ABFbuudsFvAD0rAB7NHBpHnPau0vHSq/cSobmbc5BUiTiuqw2we46Whe7/R3xAZQOQXR5Cg
 kO4Uhtwz7JdGCvAur07dzLVKrmGJxPIwpWjdP8l/6W35R4T1zyCylEDQto2yI8uTyXz0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=Kwmjn3C+1I1auj74fd/REnYkivjtnlP75vjR3ufF7kk=; b=NxylogfKVl1qnNItpxqYalqDOF
 sbdEPs/9xY5ULU5969HrSVakX3gtieENohTGyKm4SeXnfjVjx4fGRmBgMfGSaGYW0ZWANvjoIsVDC
 m7+k7hxEIiWvE+XRkH2BFOekftVojRs2xCFOvB7lyR2ab0NboUxwkxCgHodF7TKPGCGA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=Kwmjn3C+1I1auj74fd/REnYkivjtnlP75vjR3ufF7kk=; b=GF8u9qVPiJpYlJ6ZCyIPg7ydx
 YgcVgmzBPCsCK2F4al1/LTwStaz1NNLuDj+VmhMsxdNIuB67vmE1iO50Wo5NwweGUYxdc1i14Srdo
 pm2AuzhphVmmXOqsmh8T8mAuHxoXobXbV+ur9pYy5DX8Zk4g8W72+hR3BoZLtyq+BRRJ8bpW/JoUu
 xANbMElcudRdQeHM4TRoeMM/uSyd3oXH2NZCi14dsvgKsfNGLtS2lb6xpgcWQI9bDq2Jh+0gGOwuX
 Clz8Znj4Dgw5VIIlwEh/ndXlXfL8Kti2/f+dk6QV52b9OvWA8fYyeVeriZxREvFVSUFt/lnK5skPs
 oSzHnDpZw==;
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
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
