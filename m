Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5643C0018A
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbjKFRjZ (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbjKFRjS (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390ABD7E;
        Mon,  6 Nov 2023 09:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=WMfnqygTYr57TB2SIEdKYkur5BHxcXcMLwxo3SfQNGE=; b=Z/309ShVqrHgJqjX5ad1rsasUc
        pdnYm23pylROeLhCd0AXo3RzXv+7Tjwh1fFqEpDWJmVN3m1ObHnDQ+NSTBKEkLL9jMlvJt+QnGM6J
        GpQiyi/FgES/QyWR79e9jWEcKcu7jdfhQImrDExriDXWu9Kj83iNLyczONsUkwxTT6v7YzkwbtZyj
        N3MTUYh7NDEGbL17r7FTQzT191MRsGZl4btLawcz4i57LVW2D+JCCvJVAoRx4xaqAnnuxzJRiD+Ni
        pTQl7yYygdi3s7UwOOAIyg7iLjEb0Spu7bQXgZRf5h3YTWqQSRqAEnDF3EavVaCIzRhZ1QASk+Q9m
        7J2QdmsQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z4-007H8d-Us; Mon, 06 Nov 2023 17:39:07 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 10/35] nilfs2: Convert nilfs_segctor_prepare_write to use folios
Date:   Mon,  6 Nov 2023 17:38:38 +0000
Message-Id: <20231106173903.1734114-11-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Use the new folio APIs, saving 17 hidden calls to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/segment.c | 58 ++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 8c675c118c66..52995838f2de 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1665,39 +1665,39 @@ static int nilfs_segctor_assign(struct nilfs_sc_info *sci, int mode)
 	return 0;
 }
 
-static void nilfs_begin_page_io(struct page *page)
+static void nilfs_begin_folio_io(struct folio *folio)
 {
-	if (!page || PageWriteback(page))
+	if (!folio || folio_test_writeback(folio))
 		/*
 		 * For split b-tree node pages, this function may be called
 		 * twice.  We ignore the 2nd or later calls by this check.
 		 */
 		return;
 
-	lock_page(page);
-	clear_page_dirty_for_io(page);
-	set_page_writeback(page);
-	unlock_page(page);
+	folio_lock(folio);
+	folio_clear_dirty_for_io(folio);
+	folio_start_writeback(folio);
+	folio_unlock(folio);
 }
 
 static void nilfs_segctor_prepare_write(struct nilfs_sc_info *sci)
 {
 	struct nilfs_segment_buffer *segbuf;
-	struct page *bd_page = NULL, *fs_page = NULL;
+	struct folio *bd_folio = NULL, *fs_folio = NULL;
 
 	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
 		struct buffer_head *bh;
 
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
-			if (bh->b_page != bd_page) {
-				if (bd_page) {
-					lock_page(bd_page);
-					clear_page_dirty_for_io(bd_page);
-					set_page_writeback(bd_page);
-					unlock_page(bd_page);
+			if (bh->b_folio != bd_folio) {
+				if (bd_folio) {
+					folio_lock(bd_folio);
+					folio_clear_dirty_for_io(bd_folio);
+					folio_start_writeback(bd_folio);
+					folio_unlock(bd_folio);
 				}
-				bd_page = bh->b_page;
+				bd_folio = bh->b_folio;
 			}
 		}
 
@@ -1705,28 +1705,28 @@ static void nilfs_segctor_prepare_write(struct nilfs_sc_info *sci)
 				    b_assoc_buffers) {
 			set_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
-				if (bh->b_page != bd_page) {
-					lock_page(bd_page);
-					clear_page_dirty_for_io(bd_page);
-					set_page_writeback(bd_page);
-					unlock_page(bd_page);
-					bd_page = bh->b_page;
+				if (bh->b_folio != bd_folio) {
+					folio_lock(bd_folio);
+					folio_clear_dirty_for_io(bd_folio);
+					folio_start_writeback(bd_folio);
+					folio_unlock(bd_folio);
+					bd_folio = bh->b_folio;
 				}
 				break;
 			}
-			if (bh->b_page != fs_page) {
-				nilfs_begin_page_io(fs_page);
-				fs_page = bh->b_page;
+			if (bh->b_folio != fs_folio) {
+				nilfs_begin_folio_io(fs_folio);
+				fs_folio = bh->b_folio;
 			}
 		}
 	}
-	if (bd_page) {
-		lock_page(bd_page);
-		clear_page_dirty_for_io(bd_page);
-		set_page_writeback(bd_page);
-		unlock_page(bd_page);
+	if (bd_folio) {
+		folio_lock(bd_folio);
+		folio_clear_dirty_for_io(bd_folio);
+		folio_start_writeback(bd_folio);
+		folio_unlock(bd_folio);
 	}
-	nilfs_begin_page_io(fs_page);
+	nilfs_begin_folio_io(fs_folio);
 }
 
 static int nilfs_segctor_write(struct nilfs_sc_info *sci,
-- 
2.42.0

