Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C1BC001B2
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbjKFRjW (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjKFRjS (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4280ED71;
        Mon,  6 Nov 2023 09:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=NwhU+RYRS2KqhDUYWGDRZRyMStg4doHH4Ot5RU5n7LI=; b=Pr14DMGc9xyupLqn7HMLmbMg71
        HZwXoeEES9k7lMLdFtH0QaTa5IkOt/MKjRpMZjS3xmY5Y73mIHsJSqH9EYKfbcRybLQsMGRmQlTBG
        mfueIp08Z1pCFT4zMkx0VHhGvPKIaM6fIXEx9oKqUAs1MxK0MwY+AIxN8aKIxDYLQddD6wQ6seu2k
        V6dQTZrwJ7jTZX6bHUR2C6n2PluebKj/Ogw/pcz1kEsL3CmHF+J3rk1wf8flewZOu8F1mqTDkM71C
        4EMicxfaPpvMWnaFkDq8mgXtHgTIUSfChJEY0GbqTK+2ySStDj5izRFVc8xZ5a1OhnmW3bgUQfCdT
        tPpDsZrQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z4-007H8K-JP; Mon, 06 Nov 2023 17:39:06 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 07/35] nilfs2: Convert nilfs_mdt_write_page() to use a folio
Date:   Mon,  6 Nov 2023 17:38:35 +0000
Message-Id: <20231106173903.1734114-8-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Convert the incoming page to a folio.  Replaces three calls to
compound_head() with one.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/mdt.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index c97c77a39668..327408512b86 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -399,7 +399,8 @@ int nilfs_mdt_fetch_dirty(struct inode *inode)
 static int
 nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
+	struct folio *folio = page_folio(page);
+	struct inode *inode = folio->mapping->host;
 	struct super_block *sb;
 	int err = 0;
 
@@ -407,16 +408,16 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 		/*
 		 * It means that filesystem was remounted in read-only
 		 * mode because of error or metadata corruption. But we
-		 * have dirty pages that try to be flushed in background.
-		 * So, here we simply discard this dirty page.
+		 * have dirty folios that try to be flushed in background.
+		 * So, here we simply discard this dirty folio.
 		 */
 		nilfs_clear_dirty_page(page, false);
-		unlock_page(page);
+		folio_unlock(folio);
 		return -EROFS;
 	}
 
-	redirty_page_for_writepage(wbc, page);
-	unlock_page(page);
+	folio_redirty_for_writepage(wbc, folio);
+	folio_unlock(folio);
 
 	if (!inode)
 		return 0;
-- 
2.42.0

