From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 43/63] memfd: Convert shmem_tag_pins to XArray
Date: Sat, 14 Apr 2018 07:12:56 -0700
Message-ID: <20180414141316.7167-44-willy@infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
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
 bh=VKIJ4u4A8pFxCimfrgVRm9mBJTvuUSMNrTyO3HBFPq8=; b=EWcnVgSiTmdcOyRiALGrXrsL5e
 JQeK7vTlIzfZEofGX6hfJEMzxClbgNz4/SvQWDmXySVHn1B402J1pl8N+2xSVhK025DU/QJQJ8xXc
 GIQe/yX7TvGP4oo0fNEYF/KxD+nt5x2vWJl9uAGpF7Ieu0mfm1kVLmx1TQlcpfyK/gC0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=VKIJ4u4A8pFxCimfrgVRm9mBJTvuUSMNrTyO3HBFPq8=; b=H/Xg2eMydH+AX5HFSdTYfVnowG
 3yaZVEDIG25EpczpvFzjwkBdrOv4cs5SovTAE1uZY22WBt/CPRuF9g3F7owhDr9Ogi6T8mEdMjGbx
 9Ov7blAJJyuGv5GuL/LbdXaB+XOGWvNJApi/NLDxe+kZ4GQcZPzTyX72DUP/OZMLvwPE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=VKIJ4u4A8pFxCimfrgVRm9mBJTvuUSMNrTyO3HBFPq8=; b=tBGoB0qmXFvkTLcLkr3+ewj6c
 oxPOY+MfF6iXtEHFlvtul9clY9r5mHXvzoqQdNtp9U0ZPW9+O/WjXfxlp9wbhtepB+bLJgLOpMMok
 a3swr6ArMgjTlukFr1tJX+mc4COucU8SFoFi6pSmNXNa7pGTlbNhxo77mH2Xe4zNQ8r15vVsXHgaK
 UzBiB0Wfffz4TdsqHNXRggAotngav8Zp0RG4N8m6WN38bejPYzSFAqWKl/tjyaIFD6m/4cTBqQLCf
 9+B+ebhs/w4cyzJAAkmRz6krzjZtN0AhvpsUjp/QVAG+GUXarKS2q9QT3t2ppvz3R5qrNKBPS/XR+
 fGT7FfggA==;
In-Reply-To: <20180414141316.7167-1-willy@infradead.org>
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

Switch to a batch-processing model like shmem_wait_for_pins() and
use the xa_state previously set up by shmem_wait_for_pins().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/shmem.c | 44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 017340fe933d..2283872a84a1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2577,43 +2577,35 @@ static loff_t shmem_file_llseek(struct file *file, loff_t offset, int whence)
 }
 
 /*
- * We need a tag: a new tag would expand every radix_tree_node by 8 bytes,
+ * We need a tag: a new tag would expand every xa_node by 8 bytes,
  * so reuse a tag which we firmly believe is never set or cleared on shmem.
  */
 #define SHMEM_TAG_PINNED        PAGECACHE_TAG_TOWRITE
 #define LAST_SCAN               4       /* about 150ms max */
 
-static void shmem_tag_pins(struct address_space *mapping)
+static void shmem_tag_pins(struct xa_state *xas)
 {
-	struct radix_tree_iter iter;
-	void **slot;
-	pgoff_t start;
 	struct page *page;
+	unsigned int tagged = 0;
 
 	lru_add_drain();
-	start = 0;
-	rcu_read_lock();
 
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
+	xas_lock_irq(xas);
+	xas_for_each(xas, page, ULONG_MAX) {
+		if (xa_is_value(page))
+			continue;
+		if (page_count(page) - page_mapcount(page) > 1)
+			xas_set_tag(xas, SHMEM_TAG_PINNED);
 
-		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
-			cond_resched_rcu();
-		}
+		if (++tagged % XA_CHECK_SCHED)
+			continue;
+		
+		xas_pause(xas);
+		xas_unlock_irq(xas);
+		cond_resched();
+		xas_lock_irq(xas);
 	}
-	rcu_read_unlock();
+	xas_unlock_irq(xas);
 }
 
 /*
@@ -2631,7 +2623,7 @@ static int shmem_wait_for_pins(struct address_space *mapping)
 	struct page *page;
 	int error, scan;
 
-	shmem_tag_pins(mapping);
+	shmem_tag_pins(&xas);
 
 	error = 0;
 	for (scan = 0; scan <= LAST_SCAN; scan++) {
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
