From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 41/72] mm: Convert huge_memory to XArray
Date: Mon, 11 Jun 2018 07:06:08 -0700
Message-ID: <20180611140639.17215-42-willy@infradead.org>
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
 bh=yMvq9C+7xk7yZk7cjnEEnp5fI210x4S9onkG7brkez0=; b=RPXyAEPeJFAaF9NCB8VS2EAUiS
 YMPCcU6jpvCSAa6/9J5Sto+dNJ1yXLjTZ23Id4dX4pT3DsdCKqXP49Tb6TPwOpHNFeRe4qbsuTGuz
 spJ7ZZaNjwrKvzV2iyfm/26WKs80FlMXprmDC3+Byn79Z3p/Lw8enyVAdGO9GM6VU93Q=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=yMvq9C+7xk7yZk7cjnEEnp5fI210x4S9onkG7brkez0=; b=cgvZTllFmBlah2N5oYF9j4RMiH
 TLwOMbO6zx8RRyu6llgF5SdRSAMvCtDoH4tjuh5PCYfZr17fXEPObfFjbz8B2ARVI0qVwMF5Q+Kj5
 FhMblF2iTP/AkqnXwS14FGZO3cmoikYSxHWkvhPmJhULE6CF1hoWMzHYRvfdpx8F3jwQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=yMvq9C+7xk7yZk7cjnEEnp5fI210x4S9onkG7brkez0=; b=ThsXXNtlY6IPV9ZR2YAl6K5Se
 FWn+hSURSdwUDmvX687LlqYlpCYeDLRmJFEqYpl8rJWTB4p0VmOJB7eEzFXKCPk6gzyCwpaO3ZlR0
 y3HUAt5NymLtJS5WL5WLoTi+Radwl4xIl5HfTZrxo37DBUorH7WcUX8St4Gufw+iTEHOZ8x5xE48t
 DAwBik0HH1MUJxycWDptrDFGu0n1SjFgO/UyccSBBWG7NVTHitCpARsVe+les9eecAIYOaPi8nlta
 jTgJ3dMPYcKQQaL6QKYF0cJV8bFYr/NXEgIMQCWQf0+dmOMJ+1GxfBYM1Ac7sScmBFKASCjzkGJdt
 iVzBqw4Ow==;
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

Quite a straightforward conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/huge_memory.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d43394fadbfd..1dfa4542fed9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2439,13 +2439,13 @@ static void __split_huge_page(struct page *page, struct list_head *list,
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
@@ -2557,7 +2557,7 @@ bool can_split_huge_page(struct page *page, int *pextra_pins)
 {
 	int extra_pins;
 
-	/* Additional pins from radix tree */
+	/* Additional pins from page cache */
 	if (PageAnon(page))
 		extra_pins = PageSwapCache(page) ? HPAGE_PMD_NR : 0;
 	else
@@ -2653,17 +2653,14 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
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
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
