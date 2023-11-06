Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A77AC0018A
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbjKFRjV (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbjKFRjS (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E33910C1;
        Mon,  6 Nov 2023 09:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7t3zYAQvCkvirdJu4c4Q9fMP5+7V3p76B5YGNYy1k74=; b=SO28Zj4NA5VaNVuNsb6c0KEeMO
        fpEih//rVqdmeIPyFGObhgj8twtgy3oytVduPiNEGv+StD3t4bu7FxMhJ92QVE6z+8PSvuOaXs5Tk
        5YYeDxEVUy9EEybmJb98XXOQ/XVQ/HZTLDzqcsu4XjYymhTUipGfj0ZEWIjnpGhswPft3D6pF601v
        tw0Xh0ayBb6XjXS3FgVJb6mZ/1spO2olubqWjhwirFqpoRb6NCBHwVlU9iUp1eIAp7Dh49v79pWcl
        +2P9xXtZMAbNbWK016Mow6Rs8uLL5H/4RjYQmhr0z49NzUg61VXldeIbSVYEBrpG9FvapCm8YNWbj
        7AmW1Sig==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z5-007H98-H1; Mon, 06 Nov 2023 17:39:07 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 14/35] nilfs2: Convert nilfs_gccache_submit_read_data to use a folio
Date:   Mon,  6 Nov 2023 17:38:42 +0000
Message-Id: <20231106173903.1734114-15-willy@infradead.org>
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
 fs/nilfs2/gcinode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 8beb2730929d..bf9a11d58817 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -98,8 +98,8 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 	*out_bh = bh;
 
  failed:
-	unlock_page(bh->b_page);
-	put_page(bh->b_page);
+	folio_unlock(bh->b_folio);
+	folio_put(bh->b_folio);
 	if (unlikely(err))
 		brelse(bh);
 	return err;
-- 
2.42.0

