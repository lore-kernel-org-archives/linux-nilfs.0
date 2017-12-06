From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 39/73] mm: Convert khugepaged_scan_shmem to XArray
Date: Tue,  5 Dec 2017 16:41:25 -0800
Message-ID: <20171206004159.3755-40-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dlAj5/7pYBlaLnGQx3d4VMz5UCI2iMcdpxDKKVLRCW0=; b=QfqH1LYiK34tMKtgb6nPHdHJo
        78YTLWjzx+k6Jn73diQno5H4jxUDw8kAPoQOqzE/doackSn15VswTLiASzvNpFMNQ3qK4O9TJHlgc
        YTtSjlMPklpix3sKOcZYwsqXyt0HlOWnAap5q/ez91jqRYtyAhc0JJfjueHJtVaPvT45xJ/kLSojr
        s1nOlsGQwRbiY7Z/+AKsVZ3i4UTloXVBZx7mh78jWG82m9K+iB41DrYG1EBIrC2AF4UX094QC/4yJ
        H2rcebGJEO6ryuYQZQVCgSVokK0ClXFd0N3eakV41/v1HX9V0NwMcmQi26Eknd7EOArquz43ve56A
    
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Slightly shorter and easier to read code.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/khugepaged.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9f49d0cd61c2..15f1b2d81a69 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1534,8 +1534,7 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 		pgoff_t start, struct page **hpage)
 {
 	struct page *page = NULL;
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->pages, start);
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	int result = SCAN_SUCCEED;
@@ -1544,17 +1543,11 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 	swap = 0;
 	memset(khugepaged_node_load, 0, sizeof(khugepaged_node_load));
 	rcu_read_lock();
-	radix_tree_for_each_slot(slot, &mapping->pages, &iter, start) {
-		if (iter.index >= start + HPAGE_PMD_NR)
-			break;
-
-		page = radix_tree_deref_slot(slot);
-		if (radix_tree_deref_retry(page)) {
-			slot = radix_tree_iter_retry(&iter);
+	xas_for_each(&xas, page, start + HPAGE_PMD_NR - 1) {
+		if (xas_retry(&xas, page))
 			continue;
-		}
 
-		if (radix_tree_exception(page)) {
+		if (xa_is_value(page)) {
 			if (++swap > khugepaged_max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				break;
@@ -1593,7 +1586,7 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 		present++;
 
 		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
+			xas_pause(&xas);
 			cond_resched_rcu();
 		}
 	}
-- 
2.15.0

