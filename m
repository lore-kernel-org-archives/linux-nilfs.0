From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 44/74] mm: Convert khugepaged_scan_shmem to
 XArray
Date: Sat, 16 Jun 2018 19:00:22 -0700
Message-ID: <20180617020052.4759-45-willy@infradead.org>
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
 bh=OoAF9vwIWIQcgx5UcrxtXLEzDcPJ64kC3chNz+6Igus=; b=a5CMpcPO37T0VBxXGk62/FTMew
 SvAm6RjF8yUDjdXMsV6d0WdqXSOtD2iu7fWAw58hc8oDA8bmnvZuXlnCKrxIUZeZJjfDHEG5Hyog8
 VyL1gvEe8KyBbKzqfIKbgq5A3tipDFU1krq+Zm5aWPGhjP1dXbwEH/bFk8x76971ITSs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=OoAF9vwIWIQcgx5UcrxtXLEzDcPJ64kC3chNz+6Igus=; b=IiMD6T3rUjcK9r6Krv+0Rb+Equ
 f8fDaAbTP/DfsMMaqtjRW0c4o12xq7BNE9UYsxnbUKziKdt1bZcQu+OB2lIYaTsZ4D7DGDh72p9ba
 EiRXR2x60tp4qVr2w/pBpIA/8uwTBbNSI20T79Ux/oJC9uvSwCEoiEWG53cE8fJRGGaY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=OoAF9vwIWIQcgx5UcrxtXLEzDcPJ64kC3chNz+6Igus=; b=NLAHcQX2xmKLG2q0l7Ph4IHHm
 g0dEUPNrCaenU+lq87ESTTrwADiCa8xM5oRjWIVJ+7YkfBybIlAWnbCl+jH/o2Y+IdFCZiLrG2AG9
 0BNiquc4siOPFazZEM1SHpoBt3BdOZstGZ8OBusQ6XVYZCfxk6dW5KRQ5Ls8GGM+9us0jiPXtGsfO
 ikd1RanlULfRVaw2LMW3x6eHAq6CgI3JzpkRPnh/WshmSHVIIbU986JVIJGiJOajtlXyyEhbi2PGT
 jhKLJrA6inLPl39kDSaq/wHd7/Mdbl+cn3tqvBRxBTewQvURXHCqyOf08obk1THt5DKWx25I6fYkB
 G4kGuI8ig==;
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

Slightly shorter and easier to read code.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/khugepaged.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 43598cc5998b..28579ad0c5fe 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1538,8 +1538,7 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 		pgoff_t start, struct page **hpage)
 {
 	struct page *page = NULL;
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->i_pages, start);
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	int result = SCAN_SUCCEED;
@@ -1548,17 +1547,11 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
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
@@ -1597,7 +1590,7 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 		present++;
 
 		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
+			xas_pause(&xas);
 			cond_resched_rcu();
 		}
 	}
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
