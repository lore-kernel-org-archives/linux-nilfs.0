Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2D4C001B5
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjKFRj3 (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbjKFRjT (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820E210D7;
        Mon,  6 Nov 2023 09:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=dCruAMK3Rqxl4bYvNBg3suiRYWI7JSCeS94NZiWRCgM=; b=Fj204Md2qC4G55QtoSz3rrAfN7
        gkMxrzGy+248YyOHcOkAS5hh/J3sI61L0vVEFJ3kkV3VM/jIM/YcWylZSXTt0u0oTsXNX5dP/Anu7
        XjD946dyadclAC8MDnQ4v3srrlKrmNchpUMOnqA1nouDFsxpkyuQAe8j4l3rF/oSEa6jXgVd3QYLl
        I59CiX9gi3Z/uOjEbJXk55rkFL5FaFNaNG0On7E0/HJAO1Pm+5hj2rDgLxbd8vG/lwgb5iqnYnq+p
        dGL6MUDj7STQ6q0erDrxJ0fjV9SWyisd3n/yNoqnSgN7SmrH9IYRB0bJoxjyzcmsmp51gJuJGypHT
        B1+FD0Xw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z6-007HA4-HQ; Mon, 06 Nov 2023 17:39:08 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 21/35] nilfs2: Remove page_address() from nilfs_set_link
Date:   Mon,  6 Nov 2023 17:38:49 +0000
Message-Id: <20231106173903.1734114-22-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

In preparation for removing kmap from directory handling, use
offset_in_page() to calculate 'from'.  Matches ext2.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index de2073c47651..683101dcbddf 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -417,7 +417,7 @@ ino_t nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr)
 void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 		    struct page *page, struct inode *inode)
 {
-	unsigned int from = (char *)de - (char *)page_address(page);
+	unsigned int from = offset_in_page(de);
 	unsigned int to = from + nilfs_rec_len_from_disk(de->rec_len);
 	struct address_space *mapping = page->mapping;
 	int err;
-- 
2.42.0

