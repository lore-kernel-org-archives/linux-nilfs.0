Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE98C4167D
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjKFRj0 (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjKFRjS (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AEDD7B;
        Mon,  6 Nov 2023 09:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0AG2dMS81/SkWO59LwqrNQHYrTfMNl58mt0GO8sq17U=; b=cZaCLv8bbcXFDnMvnBmZ0tWWQK
        6eqpydnMRkohCxq4Dun8gN1srhkca5sflRbqc7I5cq/PtOt4nFlTZN4nPpj1P69XjfKWp8JzskUb+
        J/5/bHBdVArTePiZcM3y/+cdpFk/1yOddrHSvXV+NLa722aNkrbUGLaVGOE5xPA7EFOwFTk6e6rAo
        OQ5vtaSFqkJ99lx/aZkdhQ2xfTC2HC9fd6eXviRSaozUq7mdXLse/MJGNg7H2+waFFQkDxjX1hf7+
        2YMwLmFmcZeRtgUd3paDdSh6xkNPVOg3hAu7+U+/nMOpHLj6OLG+mgOlB3DJidzw3e5RNFQkKGPQR
        G2rNhgTQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z4-007H8W-RP; Mon, 06 Nov 2023 17:39:06 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 09/35] nilfs2: Convert to __nilfs_clear_folio_dirty()
Date:   Mon,  6 Nov 2023 17:38:37 +0000
Message-Id: <20231106173903.1734114-10-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

All callers now have a folio, so convert to pass a folio.  No caller
uses the return value, so make it return void.  Removes a couple of
hidden calls to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/page.c    | 19 ++++++++++---------
 fs/nilfs2/page.h    |  2 +-
 fs/nilfs2/segment.c |  2 +-
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 48a91ff059f5..94e11bcee05b 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -82,7 +82,7 @@ void nilfs_forget_buffer(struct buffer_head *bh)
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
 	if (nilfs_folio_buffers_clean(folio))
-		__nilfs_clear_page_dirty(&folio->page);
+		__nilfs_clear_folio_dirty(folio);
 
 	bh->b_blocknr = -1;
 	folio_clear_uptodate(folio);
@@ -428,7 +428,7 @@ void nilfs_clear_folio_dirty(struct folio *folio, bool silent)
 		} while (bh = bh->b_this_page, bh != head);
 	}
 
-	__nilfs_clear_page_dirty(&folio->page);
+	__nilfs_clear_folio_dirty(folio);
 }
 
 unsigned int nilfs_page_count_clean_buffers(struct page *page,
@@ -458,22 +458,23 @@ unsigned int nilfs_page_count_clean_buffers(struct page *page,
  * 2) Some B-tree operations like insertion or deletion may dispose buffers
  *    in dirty state, and this needs to cancel the dirty state of their pages.
  */
-int __nilfs_clear_page_dirty(struct page *page)
+void __nilfs_clear_folio_dirty(struct folio *folio)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = folio->mapping;
 
 	if (mapping) {
 		xa_lock_irq(&mapping->i_pages);
-		if (test_bit(PG_dirty, &page->flags)) {
-			__xa_clear_mark(&mapping->i_pages, page_index(page),
+		if (folio_test_dirty(folio)) {
+			__xa_clear_mark(&mapping->i_pages, folio->index,
 					     PAGECACHE_TAG_DIRTY);
 			xa_unlock_irq(&mapping->i_pages);
-			return clear_page_dirty_for_io(page);
+			folio_clear_dirty_for_io(folio);
+			return;
 		}
 		xa_unlock_irq(&mapping->i_pages);
-		return 0;
+		return;
 	}
-	return TestClearPageDirty(page);
+	folio_clear_dirty(folio);
 }
 
 /**
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index c419bb1f5b7d..968b311d265b 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -30,7 +30,7 @@ BUFFER_FNS(NILFS_Checked, nilfs_checked)	/* buffer is verified */
 BUFFER_FNS(NILFS_Redirected, nilfs_redirected)	/* redirected to a copy */
 
 
-int __nilfs_clear_page_dirty(struct page *);
+void __nilfs_clear_folio_dirty(struct folio *);
 
 struct buffer_head *nilfs_grab_buffer(struct inode *, struct address_space *,
 				      unsigned long, unsigned long);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 888b8606a1e8..8c675c118c66 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1760,7 +1760,7 @@ static void nilfs_end_folio_io(struct folio *folio, int err)
 			 */
 			folio_lock(folio);
 			if (nilfs_folio_buffers_clean(folio))
-				__nilfs_clear_page_dirty(&folio->page);
+				__nilfs_clear_folio_dirty(folio);
 			folio_unlock(folio);
 		}
 		return;
-- 
2.42.0

