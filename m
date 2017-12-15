From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 64/78] dax: Convert dax_insert_mapping_entry
 to XArray
Date: Fri, 15 Dec 2017 14:04:36 -0800
Message-ID: <20171215220450.7899-65-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
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
 bh=7tPDoqs87772IfLubU8+tHtD87IxbWpnhrTcqQR7GQ0=; b=KffXCMko/jJ+OgEv5FQkb8tPST
 XjDnwSXnavwUIcMKYKSOicI1pip0d36u/3R6kIjtSx0j/bFPfL93egn6DWIfgLbR2463ya+Y4ZuaZ
 Meu+CbijEzFaqO8qKobndaia2tgHO05P4DoM+eFeQkNIwGMAK9c02oLYyWAQW/g9kSas=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=7tPDoqs87772IfLubU8+tHtD87IxbWpnhrTcqQR7GQ0=; b=O8hM6m3CC/PlJWoXmhpOfPjlYx
 Z++jfmBtMBy6PejrCthFl1tPaVrjFKzstjUAsMDuwmInJOfYlHHVEs4xMbmg+cY/PMeNfTAB3oVWM
 dFReN/CC2wBA0pviKvefVwX4GtwJTD2tPwuKCxHCOkjMB8dOXyLcPWWGfjZEjFpkLOPE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=7tPDoqs87772IfLubU8+tHtD87IxbWpnhrTcqQR7GQ0=; b=RuuaFQoFx91hAiDcIS6mrqbpl
 siLk4Zo4gdZ0fndX2MS4+7zHrSkfSGykGgxohYsjj4odKlMcZSg7i8K6gFOgyKzMxAl6+GLPhy9IW
 0O9Ts26HR7sWH130HgpjP40t8og+5Sf6aOGl6aBXIGg3joXEmtHQueEw4MfJ/DO5czpAwViCtcmAH
 zDY4amEHlltj3fagcp32TktjxAV3btBQa9KiK7GlqqRAI0wJuq7Afo9yaJ4CdX9zY1JErwxEMV4KU
 2XI0GuHNQe18xKHmkLpUYDxovH0ZLCARm+IVwCfIKQooC3cbL7X8supk32lm1SCxtr/6WXTo5/Cy8
 zYU2+sTNg==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9cfd4fcc0b0d..a3e795ad2493 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -498,9 +498,9 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 				      void *entry, sector_t sector,
 				      unsigned long flags, bool dirty)
 {
-	struct radix_tree_root *pages = &mapping->pages;
 	void *new_entry;
 	pgoff_t index = vmf->pgoff;
+	XA_STATE(xas, &mapping->pages, index);
 
 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -516,7 +516,7 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 					PAGE_SIZE, 0);
 	}
 
-	xa_lock_irq(&mapping->pages);
+	xas_lock_irq(&xas);
 	new_entry = dax_radix_locked_entry(sector, flags);
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
@@ -528,21 +528,15 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 		 * existing entry is a PMD, we will just leave the PMD in the
 		 * tree and dirty it if necessary.
 		 */
-		struct radix_tree_node *node;
-		void **slot;
-		void *ret;
-
-		ret = __radix_tree_lookup(pages, index, &node, &slot);
-		WARN_ON_ONCE(ret != entry);
-		__radix_tree_replace(pages, node, slot,
-				     new_entry, NULL);
+		void *prev = xas_store(&xas, new_entry);
+		WARN_ON_ONCE(prev != entry);
 		entry = new_entry;
 	}
 
 	if (dirty)
-		radix_tree_tag_set(pages, index, PAGECACHE_TAG_DIRTY);
+		xas_set_tag(&xas, PAGECACHE_TAG_DIRTY);
 
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
 	return entry;
 }
 
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
