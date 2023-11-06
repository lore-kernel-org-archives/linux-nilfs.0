Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F62C0018A
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjKFRja (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbjKFRjS (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B8D10CE;
        Mon,  6 Nov 2023 09:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=95Zi5Uka8TKNZtzbGUB5Aonu6jfJqYtRnlAn1ErzqX4=; b=R+SzJr6Kt+JmIg04fFOkEPbpYT
        HeKXK6LsRy5mon9CQJ0NevMPF3pD/SJytde7lKDrbZpCDh693LBnZVsUQNpXYJy2Abo2gObWs2VJ5
        GMAlSTLT90mlifoyVfXwBxcAbe+W9yHB5+IUlgFvdsJUf1nOulTpHLB5JbhOysjJhmSwD/n/bx4e7
        dy4dX3cxzwvG/nLsSDFTxrW/sEjW4X9HsT1I8w/iM7Gg5jndYEXUzWsS7QTJTWptSB9GnPpaYzgBJ
        OVAfM/L5MtPXlWPwvRkSpaiThOytxUcjhrpd+TwxNc1UfOlXr/IbTxNGbjg2zDW9pZZfLgPRfES6x
        ETkpa2LA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z6-007H9n-8D; Mon, 06 Nov 2023 17:39:08 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 19/35] nilfs2: Convert nilfs_btnode_commit_change_key to use a folio
Date:   Mon,  6 Nov 2023 17:38:47 +0000
Message-Id: <20231106173903.1734114-20-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Saves one call to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/btnode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index da3e4366625f..fb1638765d54 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -238,15 +238,15 @@ void nilfs_btnode_commit_change_key(struct address_space *btnc,
 {
 	struct buffer_head *obh = ctxt->bh, *nbh = ctxt->newbh;
 	__u64 oldkey = ctxt->oldkey, newkey = ctxt->newkey;
-	struct page *opage;
+	struct folio *ofolio;
 
 	if (oldkey == newkey)
 		return;
 
 	if (nbh == NULL) {	/* blocksize == pagesize */
-		opage = obh->b_page;
-		if (unlikely(oldkey != opage->index))
-			NILFS_PAGE_BUG(opage,
+		ofolio = obh->b_folio;
+		if (unlikely(oldkey != ofolio->index))
+			NILFS_PAGE_BUG(&ofolio->page,
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
@@ -257,8 +257,8 @@ void nilfs_btnode_commit_change_key(struct address_space *btnc,
 		__xa_set_mark(&btnc->i_pages, newkey, PAGECACHE_TAG_DIRTY);
 		xa_unlock_irq(&btnc->i_pages);
 
-		opage->index = obh->b_blocknr = newkey;
-		unlock_page(opage);
+		ofolio->index = obh->b_blocknr = newkey;
+		folio_unlock(ofolio);
 	} else {
 		nilfs_copy_buffer(nbh, obh);
 		mark_buffer_dirty(nbh);
-- 
2.42.0

