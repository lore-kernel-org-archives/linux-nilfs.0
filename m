Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A0EC4167D
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjKFRjb (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbjKFRjT (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D5310E3;
        Mon,  6 Nov 2023 09:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=TTSeUUY7mg0GJ9TXXjIb/6dT6nWGvJK/p7aiURR/UJI=; b=gdSwE33D56RhB64ADlVVasG82t
        fuDTAspNPPbaptYloIXh3RRP/z+htUc/O+7pIj02rrK63v2wlO6/6zcpnITRXM5FeavOYiHem7Dwj
        YVaVgX+JZwaHkv5mLV2kFgOD/ywesGCrSLlXfGUUkmN1wDUfUAw48u3zLCdhkDzNSNqHkpZ3bSHkV
        w5/npb3d4YWOHrlyeS9e4mUBu2WzE+Jc+onoBr5q3l5LwdD4+hGZ06YJm+VhRWju2HXlS+BdJD/J/
        Il0rizxJcNH0rUPGKqYJEJUBE6nMkCkpn5Zmx2BkXvUCYfpa3chr6sLFsLsluabYS3O/LlbqS7f28
        fOpfBtKQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z7-007HAU-2E; Mon, 06 Nov 2023 17:39:09 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 25/35] nilfs2: Pass the mapped address to nilfs_check_page()
Date:   Mon,  6 Nov 2023 17:38:53 +0000
Message-Id: <20231106173903.1734114-26-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Remove another use of page_address() as part of preparing for
the kmap to kmap_local transition.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/dir.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 0308b618fb87..1ae370521249 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -113,12 +113,11 @@ static void nilfs_commit_chunk(struct page *page,
 	unlock_page(page);
 }
 
-static bool nilfs_check_page(struct page *page)
+static bool nilfs_check_page(struct page *page, char *kaddr)
 {
 	struct inode *dir = page->mapping->host;
 	struct super_block *sb = dir->i_sb;
 	unsigned int chunk_size = nilfs_chunk_size(dir);
-	char *kaddr = page_address(page);
 	unsigned int offs, rec_len;
 	unsigned int limit = PAGE_SIZE;
 	struct nilfs_dir_entry *p;
@@ -198,7 +197,7 @@ static void *nilfs_get_page(struct inode *dir, unsigned long n,
 
 	kaddr = kmap(page);
 	if (unlikely(!PageChecked(page))) {
-		if (!nilfs_check_page(page))
+		if (!nilfs_check_page(page, kaddr))
 			goto fail;
 	}
 
-- 
2.42.0

