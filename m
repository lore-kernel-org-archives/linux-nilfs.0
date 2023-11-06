Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A17C001B2
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjKFRjk (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbjKFRjU (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B7710F5;
        Mon,  6 Nov 2023 09:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=C+aIuxXgUDGbbyNke79DCGODEJQx8W97A2KVuBf/oB4=; b=W92LZg2U7xoG1BiSgFqFT14sDq
        5xNQngzd/znLWrCtYUHdRdzHymNlBkhRjGw8WZhU7RQTcfg+r2/UPoVdI4ZxPp0haF6NWhw4aGx0c
        ja9cI9jVCwYNAVsVfDzGLDH1hmB6uiYNaHLq1BwCWsSwpiH7TDAgkzl0KJVAvz8D9LmbI+1G6AsfH
        2Ln7V6wy+tk5UI+pNJO8/Mb/1ZV2283emW6W453rGpr1MZL3HwckCkGnMDLgJIT3fMaE98Q3fgdCP
        8QeRHDsYgIYiqxkCYLpw/rxeTDVy+zirR3uXY6/g9el8/xqkort1vlWcFa0DDs2PbXSmkxjWPxJ51
        9260tH5w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z7-007HAm-An; Mon, 06 Nov 2023 17:39:09 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 27/35] nilfs2: Add nilfs_get_folio()
Date:   Mon,  6 Nov 2023 17:38:55 +0000
Message-Id: <20231106173903.1734114-28-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Convert nilfs_get_page() to be a wrapper.
Also convert nilfs_check_page() to nilfs_check_folio().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/dir.c | 53 +++++++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 01c57573211e..9e3339123d89 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -107,18 +107,18 @@ static void nilfs_commit_chunk(struct page *page,
 	unlock_page(page);
 }
 
-static bool nilfs_check_page(struct page *page, char *kaddr)
+static bool nilfs_check_folio(struct folio *folio, char *kaddr)
 {
-	struct inode *dir = page->mapping->host;
+	struct inode *dir = folio->mapping->host;
 	struct super_block *sb = dir->i_sb;
 	unsigned int chunk_size = nilfs_chunk_size(dir);
-	unsigned int offs, rec_len;
-	unsigned int limit = PAGE_SIZE;
+	size_t offs, rec_len;
+	size_t limit = folio_size(folio);
 	struct nilfs_dir_entry *p;
 	char *error;
 
-	if ((dir->i_size >> PAGE_SHIFT) == page->index) {
-		limit = dir->i_size & ~PAGE_MASK;
+	if (dir->i_size < folio_pos(folio) + limit) {
+		limit = dir->i_size - folio_pos(folio);
 		if (limit & (chunk_size - 1))
 			goto Ebadsize;
 		if (!limit)
@@ -140,7 +140,7 @@ static bool nilfs_check_page(struct page *page, char *kaddr)
 	if (offs != limit)
 		goto Eend;
 out:
-	SetPageChecked(page);
+	folio_set_checked(folio);
 	return true;
 
 	/* Too bad, we had an error */
@@ -163,8 +163,8 @@ static bool nilfs_check_page(struct page *page, char *kaddr)
 	error = "directory entry across blocks";
 bad_entry:
 	nilfs_error(sb,
-		    "bad entry in directory #%lu: %s - offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
-		    dir->i_ino, error, (page->index << PAGE_SHIFT) + offs,
+		    "bad entry in directory #%lu: %s - offset=%lu, inode=%lu, rec_len=%zd, name_len=%d",
+		    dir->i_ino, error, (folio->index << PAGE_SHIFT) + offs,
 		    (unsigned long)le64_to_cpu(p->inode),
 		    rec_len, p->name_len);
 	goto fail;
@@ -172,37 +172,48 @@ static bool nilfs_check_page(struct page *page, char *kaddr)
 	p = (struct nilfs_dir_entry *)(kaddr + offs);
 	nilfs_error(sb,
 		    "entry in directory #%lu spans the page boundary offset=%lu, inode=%lu",
-		    dir->i_ino, (page->index << PAGE_SHIFT) + offs,
+		    dir->i_ino, (folio->index << PAGE_SHIFT) + offs,
 		    (unsigned long)le64_to_cpu(p->inode));
 fail:
-	SetPageError(page);
+	folio_set_error(folio);
 	return false;
 }
 
-static void *nilfs_get_page(struct inode *dir, unsigned long n,
-		struct page **pagep)
+static void *nilfs_get_folio(struct inode *dir, unsigned long n,
+		struct folio **foliop)
 {
 	struct address_space *mapping = dir->i_mapping;
-	struct page *page = read_mapping_page(mapping, n, NULL);
+	struct folio *folio = read_mapping_folio(mapping, n, NULL);
 	void *kaddr;
 
-	if (IS_ERR(page))
-		return page;
+	if (IS_ERR(folio))
+		return folio;
 
-	kaddr = kmap_local_page(page);
-	if (unlikely(!PageChecked(page))) {
-		if (!nilfs_check_page(page, kaddr))
+	kaddr = kmap_local_folio(folio, 0);
+	if (unlikely(!folio_test_checked(folio))) {
+		if (!nilfs_check_folio(folio, kaddr))
 			goto fail;
 	}
 
-	*pagep = page;
+	*foliop = folio;
 	return kaddr;
 
 fail:
-	unmap_and_put_page(page, kaddr);
+	folio_release_kmap(folio, kaddr);
 	return ERR_PTR(-EIO);
 }
 
+static void *nilfs_get_page(struct inode *dir, unsigned long n,
+		struct page **pagep)
+{
+	struct folio *folio;
+	void *kaddr = nilfs_get_folio(dir, n, &folio);
+
+	if (!IS_ERR(kaddr))
+		*pagep = &folio->page;
+	return kaddr;
+}
+
 /*
  * NOTE! unlike strncmp, nilfs_match returns 1 for success, 0 for failure.
  *
-- 
2.42.0

