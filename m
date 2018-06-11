From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 54/72] memfd: Convert memfd_tag_pins to XArray
Date: Mon, 11 Jun 2018 07:06:21 -0700
Message-ID: <20180611140639.17215-55-willy@infradead.org>
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
 bh=uFo/5SSJuJU2uEENvH3dxtsPOTxtY7hbgSaYCUX4Usk=; b=FunMBw+2fXbLTMHLzo/TqVP4DM
 0+8YCS1k/S9km3Et+0BUOp0shdJmtVEGDtmgK44xchybGrtfLkvaT3aMWXc6cCJAisjXUsYJX/AHW
 3+ywBAhaST/Tqw4BvGmqJBoh+fD1ZUkw1RZT7ogr5NtB5nmJpHxuv2cusUzkSHfCEoh0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=uFo/5SSJuJU2uEENvH3dxtsPOTxtY7hbgSaYCUX4Usk=; b=THi1WnaWYMrt83fRkY3WUfNqhl
 fEUrGYKcLiSc6W9n1AJhTKCzQqVhGhauVZcCcPkabNH/d12a/h/J1SpGhqN4ZDlP+1/QC+t4nGyMx
 97d/G14s+S6CrjZjDChq9Wu44mgfxGn//2ZRviRtEa73tYdfbDz+SZgYN1CXYfBXZqVs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=uFo/5SSJuJU2uEENvH3dxtsPOTxtY7hbgSaYCUX4Usk=; b=h11/WzvmVYmTtHuxhP/vXbtHq
 dKADqvsRxXl3BJUcHv4IJ4p53cP8HUWx0xJoRetj5/5VCDmt8hVU0HdVm2kcwAwPzg+En+wCwWxKi
 uJWkUFzGDnYeIV+1jDwQWRefnU02Yi/t19Tj3ZzGTNxpPqOKSIrzDzy9Pve8abGtDfy0Q6aM2zLk+
 K6MQc5B7k+R+t4QjA8KqHzfR41NDaHt2R6qQLftliEQ98cbP+/72kTpi79eovTAl38RsebkSL37LT
 DXDqeC+ty1LaJ1XDDrBO3EEA9zVYHYoNeDoIEJhtbS+i4uzf2n0lnS6kVMZI6WZN99pnPfPmvGwfL
 xYyZMRotg==;
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

Switch to a batch-processing model like memfd_wait_for_pins() and
use the xa_state previously set up by memfd_wait_for_pins().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/memfd.c | 44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index e7d6be725b7a..636de8d5c7c3 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -28,37 +28,29 @@
 #define MEMFD_TAG_PINNED        PAGECACHE_TAG_TOWRITE
 #define LAST_SCAN               4       /* about 150ms max */
 
-static void memfd_tag_pins(struct address_space *mapping)
+static void memfd_tag_pins(struct xa_state *xas)
 {
-	struct radix_tree_iter iter;
-	void __rcu **slot;
-	pgoff_t start;
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
-					   MEMFD_TAG_PINNED);
-			xa_unlock_irq(&mapping->i_pages);
-		}
 
-		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
-			cond_resched_rcu();
-		}
+	xas_lock_irq(xas);
+	xas_for_each(xas, page, ULONG_MAX) {
+		if (xa_is_value(page))
+			continue;
+		if (page_count(page) - page_mapcount(page) > 1)
+			xas_set_tag(xas, MEMFD_TAG_PINNED);
+
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
@@ -76,7 +68,7 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 	struct page *page;
 	int error, scan;
 
-	memfd_tag_pins(mapping);
+	memfd_tag_pins(&xas);
 
 	error = 0;
 	for (scan = 0; scan <= LAST_SCAN; scan++) {
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
