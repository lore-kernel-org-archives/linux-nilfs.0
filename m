Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF8EC4332F
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbjKFRjd (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbjKFRjU (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F9C10E7;
        Mon,  6 Nov 2023 09:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=bPdw8wBJlFg2JRU9mjLBkI9Pe++wsQanm7l3H2XE7tQ=; b=pkQOg3yabK93Jvr0HEijxh0/6j
        YeA+bM0k4jx8ClvfdK+nEBsl/Ln1hTa2bxH+5LcwfMAnEMokvUt7Vg4XnV10y/mTdCiqTVBOd6YSD
        j+jcJ4L2pIdOn7flkhYXCUckChh89wUnTIHUzjL5u9VSvqjACKQUk9wCrMsvs+OpgGXDMeE6VYHHZ
        dT6XM2c4Lzgol48VdV4ukQF635ky53ZxChHtwdCIbMQOgcvPYGgC43Gxx5eSOvobBSTeoCLLlR+3N
        QJ4aROGIEWlcih828RFrHuxqGn9zIIaNzbbHI6B+/p4pkPCEu/GUuBYka1CqaChsF2BweuUKxyiR8
        TFEfbUvA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z4-007H81-6w; Mon, 06 Nov 2023 17:39:06 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 04/35] nilfs2: Convert nilfs_forget_buffer to use a folio
Date:   Mon,  6 Nov 2023 17:38:32 +0000
Message-Id: <20231106173903.1734114-5-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Save two hidden calls to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/page.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 06b04758f289..3882acde1b3e 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -73,7 +73,7 @@ struct buffer_head *nilfs_grab_buffer(struct inode *inode,
  */
 void nilfs_forget_buffer(struct buffer_head *bh)
 {
-	struct page *page = bh->b_page;
+	struct folio *folio = bh->b_folio;
 	const unsigned long clear_bits =
 		(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
 		 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
@@ -81,12 +81,12 @@ void nilfs_forget_buffer(struct buffer_head *bh)
 
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
-	if (nilfs_page_buffers_clean(page))
-		__nilfs_clear_page_dirty(page);
+	if (nilfs_page_buffers_clean(&folio->page))
+		__nilfs_clear_page_dirty(&folio->page);
 
 	bh->b_blocknr = -1;
-	ClearPageUptodate(page);
-	ClearPageMappedToDisk(page);
+	folio_clear_uptodate(folio);
+	folio_clear_mappedtodisk(folio);
 	unlock_buffer(bh);
 	brelse(bh);
 }
-- 
2.42.0

