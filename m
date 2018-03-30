From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 34/62] mm: Convert khugepaged_scan_shmem to
 XArray
Date: Thu, 29 Mar 2018 20:42:17 -0700
Message-ID: <20180330034245.10462-35-willy@infradead.org>
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
 bh=6Ag7s+WCgv3NYy4oQKuiKK/U/vmt39wadKktm69cMis=; b=PETnxYko4ZwZry4dI7dSrpiXJw
 cDHmk/1XXFakOkqBrUp+jSKS55oECpEIr8D6m0a47MyK7sFaG0yalLygxabE3ty3OIFYP6vYkPAzr
 bN9IV6J1zEwcTxZ/nRXFCksbJ3WjxnCTey7+Zb9OCVofWVm1aTELGmtmGxGeIY9DUS1o=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=6Ag7s+WCgv3NYy4oQKuiKK/U/vmt39wadKktm69cMis=; b=Zrku71qUOvqGYvO52Uz5hywyCz
 Y5FCYcOq0pFQ1q+i0kWVKV9t57r/CbSomMi4SYQGz1KLFlfeTEGUzrwtXOVyTVSBNdVIbOU6SdonS
 4cdwSQYG+jcVYU2J0yZ6rvg5/nzoPuZQ+kpUKvGPsGMxj9T0F+mFczk2xaqHa/3H3JoE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=6Ag7s+WCgv3NYy4oQKuiKK/U/vmt39wadKktm69cMis=; b=Tv3idaBe1Afux9KAwlvq3TFHI
 PNOmZud7MBAqsEaWf5I8qnh2KxVcku29999SereoBjvD2y2n5O1lLaVwUtpO8Gb1fhFyJKli6UON1
 lgaYR5peEChikYd1NjBN+98XKTNNTOTVrrNc+2z3+rvFR3b8mM4eD5mrEA5eUEQs5D+eGj+w3QaVN
 d5K2mlmHRGdnOST7fAr0CMpTU7LH2gixWp74WnjuvOt7KDogd0oaEsu6jA5tXOIeglRU32/4pYILp
 7uKmTODb3GROXPg1ObMIJnMnDw8RF9zQAaezzXMB6JtbGk4dTHun8JteyK8e3fHmSFdf0AsVYhuqA
 T6om9M9rg==;
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

Slightly shorter and easier to read code.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/khugepaged.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 193bacac91a8..7c6343db7de0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1542,8 +1542,7 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 		pgoff_t start, struct page **hpage)
 {
 	struct page *page = NULL;
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->i_pages, start);
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	int result = SCAN_SUCCEED;
@@ -1552,17 +1551,11 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
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
@@ -1601,7 +1594,7 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 		present++;
 
 		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
+			xas_pause(&xas);
 			cond_resched_rcu();
 		}
 	}
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
