From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 41/61] mm: Convert khugepaged_scan_shmem to XArray
Date: Tue, 13 Mar 2018 06:26:19 -0700
Message-ID: <20180313132639.17387-42-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fMGveMqJ+AfhMwu7w/CIfEaV6iAA+0Ik35yRaUfo3/M=; b=SRr/BE8GLJxqx0I3nGvrZKAa+
        60m+TCC/6bJNOYAJy2HAULPF0+RekBS21OmNSpL03z625N22Hb8g3wisnV8rHCKY9q757ChIWRqY4
        c5dgy8KhulqEareeQfzekK4DR4grjsiOwvpp2arWKX8kPLNNJvrwtrKxmRytUQKkAZ49IjiFxrYwO
        K/I8YzOHA6/04wx52KfeJizzuLIe1W5YCEhSqDj2WMou8+V12R4Kdh4/LRYkwA+kizGYUG7XF6HoE
        7E7wD1nMH8Sc2hAGwOO2I7llLq89IB/mOK+tEGQUL9Aa9qARWuakHJfks3xYrVHVGyewfSsxGvGxa
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Slightly shorter and easier to read code.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/khugepaged.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 3685c8e2b3dc..39e260a0639c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1533,8 +1533,7 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 		pgoff_t start, struct page **hpage)
 {
 	struct page *page = NULL;
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->i_pages, start);
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	int result = SCAN_SUCCEED;
@@ -1543,17 +1542,11 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 	swap = 0;
 	memset(khugepaged_node_load, 0, sizeof(khugepaged_node_load));
 	rcu_read_lock();
-	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
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
@@ -1592,7 +1585,7 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 		present++;
 
 		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
+			xas_pause(&xas);
 			cond_resched_rcu();
 		}
 	}
-- 
2.16.1

