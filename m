Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CDEC0018A
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbjKFRjh (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbjKFRjS (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA91CD4C;
        Mon,  6 Nov 2023 09:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7PIZ8KqccUS2TOpXvumG29UeZnAYz8wZ5EmCGu95qn8=; b=bGUYcerxDfRbUaunwTgCJo1I3X
        9uyFVYlmU328+l45bB9viY9DsqbfIkZEFsbISO8l9u3Vk+frV/ZKWfjMV1i+emwS+DYzM2Edw0A7x
        lYhriL3rtzClJZ7uZd1lWrDvme6ok/CYI3Z2CTWKX9YXo7vLjzgm413fuOf7gecKyHeZrqgHWcNDD
        Oa0qpM2acvGSw8F4gJfgUYEH4L2rbFw6kqqeHoLRlDaib4ThlAcUfoCZmo0wVKBhd2omgzFR08QLj
        MfMGn1wv0cHvUnQ/Xwv6gQbHE4NRC7dlCHG6doidGbGM1nRlV+ICUz1INNVPonbc6oAlG+7GKlJvN
        ZGQwiiyw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z5-007H9N-Ny; Mon, 06 Nov 2023 17:39:07 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 16/35] nilfs2: Convert nilfs_btnode_submit_block to use a folio
Date:   Mon,  6 Nov 2023 17:38:44 +0000
Message-Id: <20231106173903.1734114-17-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Saves two calls to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/btnode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 691a50410ea9..5ef9eebd8d2e 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -75,7 +75,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 {
 	struct buffer_head *bh;
 	struct inode *inode = btnc->host;
-	struct page *page;
+	struct folio *folio;
 	int err;
 
 	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
@@ -83,7 +83,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 		return -ENOMEM;
 
 	err = -EEXIST; /* internal code */
-	page = bh->b_page;
+	folio = bh->b_folio;
 
 	if (buffer_uptodate(bh) || buffer_dirty(bh))
 		goto found;
@@ -130,8 +130,8 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 	*pbh = bh;
 
 out_locked:
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 	return err;
 }
 
-- 
2.42.0

