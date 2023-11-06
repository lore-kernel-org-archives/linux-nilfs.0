Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C408CC41535
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjKFRjU (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjKFRjS (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DA8B7;
        Mon,  6 Nov 2023 09:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=8lLT5xkKCqdiPAnTDVlD/IYjZd/DMWn1oTzzcwjirl0=; b=FMhC7KmdIkEelN5hAo6+nA3DZs
        th8uriNh3lL0MtRwwNwuyKHP58xfRnrDxOh3DI5jSSNCPeSO3Mrya8Nu9v3gSd6vvTqe+MvhQ18fk
        re4kYrAuwr27XRpYFPxZz3Vu4hnWQ+hYyirM9AiNgolrjlOHgXaKGwZ4QvYuh9uDG3f8LUmFCo9Qm
        AsS1sYFL1jzzfdWzlGra5j+5zmfjAI9u4NIWJas2C3Ri0gAvNtjlIQ6LRsh+DdPBkYcli3qI8/mS4
        gencGaSKW/IWeaD7GRMNjwCFBWNp9p+yS+w8eHX+mqAkOlryL1VyWoRHuDSwTKsAMvHxTXbb1XkA0
        SgKSyTaw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z5-007H8q-7a; Mon, 06 Nov 2023 17:39:07 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 12/35] nilfs2: Convert nilfs_mdt_create_block to use a folio
Date:   Mon,  6 Nov 2023 17:38:40 +0000
Message-Id: <20231106173903.1734114-13-willy@infradead.org>
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
 fs/nilfs2/mdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 2e7952ac2f67..7e4dcff2c94b 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -97,8 +97,8 @@ static int nilfs_mdt_create_block(struct inode *inode, unsigned long block,
 	}
 
  failed_bh:
-	unlock_page(bh->b_page);
-	put_page(bh->b_page);
+	folio_unlock(bh->b_folio);
+	folio_put(bh->b_folio);
 	brelse(bh);
 
  failed_unlock:
-- 
2.42.0

