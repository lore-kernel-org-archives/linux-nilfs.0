Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E05C4332F
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjKFRj0 (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjKFRjS (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DC010C6;
        Mon,  6 Nov 2023 09:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=nxKQJgvtD4VqNVRQ69Ua94Y9Py0FFllSC6PheIwXIKg=; b=m3r6FbXa6aIDObJ9Ku4Z5KU2yz
        YjcX08tzp9PVxn3/UGoghlc98qpFAbiUXaOIE67EmtlxEfJF6Ohmd3P7mPAhWDv2KRNAmEph1vRV9
        GjOGP6fFJOrs40Fw6m4vNvM7v+UGiWPFN+QoCTzhmR/sVxLgBkZJ7Xs2qGZBpNqBOONbnacbUMjTn
        FTOmPsGv8+y/Kz9TD7+DSRPwih7nJLx91e7FD2uZjnsllpCjNtjc2Z08Tmb4P/NGzSrRyQ3pB0/Eh
        +QfTzgG+opRsXVDbGWYEUthMxqFhRbH7SZMOLNlF5MLsmA4fDGZEBFZftUU43eFcgF4h1c6a8zOpC
        AAUsfnag==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z5-007H9V-Sk; Mon, 06 Nov 2023 17:39:07 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 17/35] nilfs2: Convert nilfs_btnode_delete to use a folio
Date:   Mon,  6 Nov 2023 17:38:45 +0000
Message-Id: <20231106173903.1734114-18-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Saves six calls to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/btnode.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 5ef9eebd8d2e..e077d4a7a11c 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -145,19 +145,19 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 void nilfs_btnode_delete(struct buffer_head *bh)
 {
 	struct address_space *mapping;
-	struct page *page = bh->b_page;
-	pgoff_t index = page_index(page);
+	struct folio *folio = bh->b_folio;
+	pgoff_t index = folio->index;
 	int still_dirty;
 
-	get_page(page);
-	lock_page(page);
-	wait_on_page_writeback(page);
+	folio_get(folio);
+	folio_lock(folio);
+	folio_wait_writeback(folio);
 
 	nilfs_forget_buffer(bh);
-	still_dirty = PageDirty(page);
-	mapping = page->mapping;
-	unlock_page(page);
-	put_page(page);
+	still_dirty = folio_test_dirty(folio);
+	mapping = folio->mapping;
+	folio_unlock(folio);
+	folio_put(folio);
 
 	if (!still_dirty && mapping)
 		invalidate_inode_pages2_range(mapping, index, index);
-- 
2.42.0

