From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 32/62] mm: Convert huge_memory to XArray
Date: Thu, 29 Mar 2018 20:42:15 -0700
Message-ID: <20180330034245.10462-33-willy@infradead.org>
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
 bh=jI6SZ/Os78TIb9FtyyeHdJaeqQJYtcYzMBgbF/FUNWg=; b=G5ZWg+PvCdLYUQqa7kejbyNuHH
 BzL97wJoSq3mUxhh986lBcHIYjVqxTcpGzrKxcIj5XmC9NT4rLLf0IpEPGhfqRtfMTGRcmlxBQ2ct
 CLgFsAml3CzTagphCzHYh2NQv7Uh5FY6xnEx5EmWudf0ttc6tcN74yzStAvvhG4alYPg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=jI6SZ/Os78TIb9FtyyeHdJaeqQJYtcYzMBgbF/FUNWg=; b=Sa4TtdE6NIocGi7Bncexw1/dwi
 tHqIn7SXsBkOJkItIhnW35rI7E/Eik2Pauibk8FN3hFJuniZbC18McaF+zXUB4D6hymCL4zWIooWc
 ZhVTALnzQl5NgSJGmeU85DKUSScmY/vvy15ma/0/MEEZYlFVF+jBN9F7qj9Z5ekvv9gE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=jI6SZ/Os78TIb9FtyyeHdJaeqQJYtcYzMBgbF/FUNWg=; b=eq/MpuPOxrh2MwGb6AjNV4dGT
 2m1hXT8pn0C2ik4j28Ir+lqA7QCLM5YQ0/DQ0tqLEz937kaySiJUhxbGZT99RonOt+WYE1lDTNiik
 3ciwL17T4L4Dt8xTMclCqZ13PFApwQRrT8xn3zWibINEvlcB49MlRQ6VgxQ1EwThXVsIF6+NrwgeA
 5JO7jTwG5Hk0rzX9+VihVN6bUxGBdzAKRTjG4NiVJICorjyeZzgssCDUSgOnBE7paZfGahByTcg8Z
 YFLyp2UqgEIVR9qC2zFlGBITOU204syW0uPJIENuCkrKvmrgW+tU3mf75m2iti8Oii7tLHRmN0jpG
 4Y55UbySw==;
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

Quite a straightforward conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/huge_memory.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2aff58624886..56559ee1cb13 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2443,13 +2443,13 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	ClearPageCompound(head);
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
-		/* Additional pin to radix tree of swap cache */
+		/* Additional pin to swap cache */
 		if (PageSwapCache(head))
 			page_ref_add(head, 2);
 		else
 			page_ref_inc(head);
 	} else {
-		/* Additional pin to radix tree */
+		/* Additional pin to page cache */
 		page_ref_add(head, 2);
 		xa_unlock(&head->mapping->i_pages);
 	}
@@ -2561,7 +2561,7 @@ bool can_split_huge_page(struct page *page, int *pextra_pins)
 {
 	int extra_pins;
 
-	/* Additional pins from radix tree */
+	/* Additional pins from page cache */
 	if (PageAnon(page))
 		extra_pins = PageSwapCache(page) ? HPAGE_PMD_NR : 0;
 	else
@@ -2657,17 +2657,14 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	spin_lock_irqsave(zone_lru_lock(page_zone(head)), flags);
 
 	if (mapping) {
-		void **pslot;
+		XA_STATE(xas, &mapping->i_pages, page_index(head));
 
-		xa_lock(&mapping->i_pages);
-		pslot = radix_tree_lookup_slot(&mapping->i_pages,
-				page_index(head));
 		/*
-		 * Check if the head page is present in radix tree.
+		 * Check if the head page is present in page cache.
 		 * We assume all tail are present too, if head is there.
 		 */
-		if (radix_tree_deref_slot_protected(pslot,
-					&mapping->i_pages.xa_lock) != head)
+		xa_lock(&mapping->i_pages);
+		if (xas_load(&xas) != head)
 			goto fail;
 	}
 
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
