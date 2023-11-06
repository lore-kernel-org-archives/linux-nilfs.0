Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B99C4332F
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbjKFRjg (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbjKFRjT (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F122410E4;
        Mon,  6 Nov 2023 09:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=SR/M6J1eCYzIfQnXQGYhFKKiXejmTRdamnCzS3EwsIM=; b=hZtcL/enOfsVgkh/Xwpllkix9F
        HBCfh6jJtyzI6iodIhegX6pFz/1Vb6UZjkmrKXtmTKf3bKqFDmKFXoG5nw3QwoA/f08bHNpXUNGqF
        ahxemfdhPA8H/bZCS31RE29/vTG5OVf9+s1rrrk6LFRCwYPtfsppHEufVQg+Csi5CkU9575oKp9n3
        nxGOD6OJbbjKBIoBcCWG1cV+gnaTUQjw5C+7ABkuMWxgaYzY0Gjyx/W222nEGC03povpERLvaXnD6
        hCdqppExoQqdcOW8TLRY7FXdqudr8n6xR0qwtkyAwx0romWgLimZZqGQFA0jDDrc98etFHPnJPzJp
        cp8eDV3g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z3-007H7p-R1; Mon, 06 Nov 2023 17:39:05 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 01/35] nilfs2: Add nilfs_end_folio_io()
Date:   Mon,  6 Nov 2023 17:38:29 +0000
Message-Id: <20231106173903.1734114-2-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

This is the folio counterpart of the existing nilfs_end_page_io()
which is retained as a wrapper of nilfs_end_folio_io().  Replaces
nine hidden calls to compound_head() with one.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/segment.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 55e31cc903d1..1df03d0895be 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1739,17 +1739,18 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
 	return ret;
 }
 
-static void nilfs_end_page_io(struct page *page, int err)
+static void nilfs_end_folio_io(struct folio *folio, int err)
 {
-	if (!page)
+	if (!folio)
 		return;
 
-	if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page)) {
+	if (buffer_nilfs_node(folio_buffers(folio)) &&
+			!folio_test_writeback(folio)) {
 		/*
 		 * For b-tree node pages, this function may be called twice
 		 * or more because they might be split in a segment.
 		 */
-		if (PageDirty(page)) {
+		if (folio_test_dirty(folio)) {
 			/*
 			 * For pages holding split b-tree node buffers, dirty
 			 * flag on the buffers may be cleared discretely.
@@ -1757,24 +1758,31 @@ static void nilfs_end_page_io(struct page *page, int err)
 			 * remaining buffers, and it must be cancelled if
 			 * all the buffers get cleaned later.
 			 */
-			lock_page(page);
-			if (nilfs_page_buffers_clean(page))
-				__nilfs_clear_page_dirty(page);
-			unlock_page(page);
+			folio_lock(folio);
+			if (nilfs_page_buffers_clean(&folio->page))
+				__nilfs_clear_page_dirty(&folio->page);
+			folio_unlock(folio);
 		}
 		return;
 	}
 
 	if (!err) {
-		if (!nilfs_page_buffers_clean(page))
-			__set_page_dirty_nobuffers(page);
-		ClearPageError(page);
+		if (!nilfs_page_buffers_clean(&folio->page))
+			filemap_dirty_folio(folio->mapping, folio);
+		folio_clear_error(folio);
 	} else {
-		__set_page_dirty_nobuffers(page);
-		SetPageError(page);
+		filemap_dirty_folio(folio->mapping, folio);
+		folio_set_error(folio);
 	}
 
-	end_page_writeback(page);
+	folio_end_writeback(folio);
+}
+
+static void nilfs_end_page_io(struct page *page, int err)
+{
+	if (!page)
+		return;
+	nilfs_end_folio_io(page_folio(page), err);
 }
 
 static void nilfs_abort_logs(struct list_head *logs, int err)
-- 
2.42.0

