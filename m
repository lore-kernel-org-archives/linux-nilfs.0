Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643A0C4167B
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjKFRjb (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbjKFRjT (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A180910DB;
        Mon,  6 Nov 2023 09:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=TgmUIUcJvy4zgyjRhv0niN+gofsFTMFSxbjhNAOTL9Q=; b=j/u3rT8OZvCzrc1Ql619YCcG4g
        sZhAqEy+ytTKBXt941J6a1j71tkAZtLovN7tOYnOqMIQJmKnw9ncS+y+9hYybqK3ZHufDurfrgIc+
        Ce+MmL1vS8TxFQH7sI+frFVKsasHg/tgBC9Qbr+u0soRwW3fw7hsCFTb86evmc0zTg5PFXOZsZDHE
        F2QtZe/XH3qaVH1pXA5w1jWs1sRniOF3XXbuWf4caGrJOShgORtqcT6E++DVUrEv92ZeLDvi1clyI
        /E/Bn+mYidURczrP+Gn7joj7N0uwC+1EkbhJ4VOltEJUXswlQUftuGDeVtwZTYlRJS1B2VyEq/EpX
        jGfbZmuw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z6-007H9w-CV; Mon, 06 Nov 2023 17:39:08 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 20/35] nilfs2: Convert nilfs_btnode_abort_change_key to use a folio
Date:   Mon,  6 Nov 2023 17:38:48 +0000
Message-Id: <20231106173903.1734114-21-willy@infradead.org>
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
 fs/nilfs2/btnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index fb1638765d54..1204dd06ead8 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -284,7 +284,7 @@ void nilfs_btnode_abort_change_key(struct address_space *btnc,
 
 	if (nbh == NULL) {	/* blocksize == pagesize */
 		xa_erase_irq(&btnc->i_pages, newkey);
-		unlock_page(ctxt->bh->b_page);
+		folio_unlock(ctxt->bh->b_folio);
 	} else {
 		/*
 		 * When canceling a buffer that a prepare operation has
-- 
2.42.0

