Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B394BC0018A
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjKFRjc (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjKFRjT (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AF810DD;
        Mon,  6 Nov 2023 09:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=h6bp/fpI9MZt0dEiyzYk9ugleWMsOz4HzORTtXlfGKw=; b=FXXCFxDjk7qTLQVqVDLIR/rpAL
        aLEHHFEtJribXy0gOL56NoNA5Zs9slJpnYjHXetQsOnuidyl2b3H9f5zg7zcbzmgD21+tHRzskFgQ
        UOYNsgeFLLLNnPJDH+phuhddBzXQZHRgNC7bk9ZsWxFA0PmKHxYfvozhizCeQsORhJZLrKreMWkaM
        4S3ykDn/v1gp7HdLIf6g6RtTcLckvx4CAtKg4Y4qmzXmyn0MaXxqc0Fwu4tfuaPQfYzdPxml1AMqC
        m9Vwunj17gd3+YTWscU6QRed/3Irm4CN1dY8Ppf56+j52QkgG+HdhZh3O+3MA7vrt44dXtFB4ntcV
        mH4WhetA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z6-007HAH-Oz; Mon, 06 Nov 2023 17:39:08 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 23/35] nilfs2: Remove page_address() from nilfs_delete_entry
Date:   Mon,  6 Nov 2023 17:38:51 +0000
Message-Id: <20231106173903.1734114-24-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

In preparation for removing kmap from directory handling, mask
the directory entry pointer to discover the start address of the
page.  Matches ext2.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 0cf4fe91aebe..07a906d0c786 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -539,7 +539,7 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
-	char *kaddr = page_address(page);
+	char *kaddr = (char *)((unsigned long)dir & PAGE_MASK);
 	unsigned int from, to;
 	struct nilfs_dir_entry *de, *pde = NULL;
 	int err;
@@ -559,7 +559,7 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 		de = nilfs_next_entry(de);
 	}
 	if (pde)
-		from = (char *)pde - (char *)page_address(page);
+		from = (char *)pde - kaddr;
 	lock_page(page);
 	err = nilfs_prepare_chunk(page, from, to);
 	BUG_ON(err);
-- 
2.42.0

