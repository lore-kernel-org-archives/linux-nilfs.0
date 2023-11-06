Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDA9C001B2
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbjKFRjd (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjKFRjU (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C1310F4;
        Mon,  6 Nov 2023 09:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=/EIk8IFp+MoTx354i8IVq/Foy766pngJB0dETx6s62o=; b=o+je91/JpCT5gq72gWD1t1+JkT
        IYNv5STaT4nYmnulnYTk0orViCGn8dRMWPujaggmQJeegdHyGYUj0Bt2oVENL59jjUuAZe2XPED1H
        4KDv5Bgz7ZYrCeA8WZwAB6RXhu0lR+LWIJPDFwIMmBYirmwzoQlBfo0ZuCDrhWuSzxspMffIytAc5
        baKrtP6OviNQDqMlK05slkkr86k9pEAiNLuZoDcPRBvNX4CR56UYWpavwihTbAQMGvCjwz2sGAOaC
        yfy8EOwMh0k1NmTSI4l5+UyzUvO1G7MChqWw5gKygRQdCQy+wxGfjH9Q6chQiShhNqsGdQv70HlHj
        C0HOD8Rg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z7-007HB2-IK; Mon, 06 Nov 2023 17:39:09 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 29/35] nilfs2: Convert nilfs_find_entry to use a folio
Date:   Mon,  6 Nov 2023 17:38:57 +0000
Message-Id: <20231106173903.1734114-30-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Use the new folio APIs to remove calls to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/dir.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 8d74f1d9bb62..9f2a02b71ddc 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -339,7 +339,7 @@ nilfs_find_entry(struct inode *dir, const struct qstr *qstr,
 	unsigned int reclen = NILFS_DIR_REC_LEN(namelen);
 	unsigned long start, n;
 	unsigned long npages = dir_pages(dir);
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct nilfs_inode_info *ei = NILFS_I(dir);
 	struct nilfs_dir_entry *de;
 
@@ -354,7 +354,7 @@ nilfs_find_entry(struct inode *dir, const struct qstr *qstr,
 		start = 0;
 	n = start;
 	do {
-		char *kaddr = nilfs_get_page(dir, n, &page);
+		char *kaddr = nilfs_get_folio(dir, n, &folio);
 		if (!IS_ERR(kaddr)) {
 			de = (struct nilfs_dir_entry *)kaddr;
 			kaddr += nilfs_last_byte(dir, n) - reclen;
@@ -362,18 +362,18 @@ nilfs_find_entry(struct inode *dir, const struct qstr *qstr,
 				if (de->rec_len == 0) {
 					nilfs_error(dir->i_sb,
 						"zero-length directory entry");
-					unmap_and_put_page(page, kaddr);
+					folio_release_kmap(folio, kaddr);
 					goto out;
 				}
 				if (nilfs_match(namelen, name, de))
 					goto found;
 				de = nilfs_next_entry(de);
 			}
-			unmap_and_put_page(page, kaddr);
+			folio_release_kmap(folio, kaddr);
 		}
 		if (++n >= npages)
 			n = 0;
-		/* next page is past the blocks we've got */
+		/* next folio is past the blocks we've got */
 		if (unlikely(n > (dir->i_blocks >> (PAGE_SHIFT - 9)))) {
 			nilfs_error(dir->i_sb,
 			       "dir %lu size %lld exceeds block count %llu",
@@ -386,7 +386,7 @@ nilfs_find_entry(struct inode *dir, const struct qstr *qstr,
 	return NULL;
 
 found:
-	*res_page = page;
+	*res_page = &folio->page;
 	ei->i_dir_start_lookup = n;
 	return de;
 }
-- 
2.42.0

