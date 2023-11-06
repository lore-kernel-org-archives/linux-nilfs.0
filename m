Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1DEC4332F
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbjKFRjm (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbjKFRjV (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F4910F8;
        Mon,  6 Nov 2023 09:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=vaMf6+ceFAF1BP5HFmDPS10ulzb64i/FkHesSTm9xno=; b=OC2PMPFjVpVlg2EfhoYkqMwOzP
        OJGvz8ttxlR23/WD8Wq/wVVEILmEv9i/P9cOgBXBMXg0XatwJUpoY3Yl0YnHZeyHqluQezk9PVz8x
        FdZsLzmHquhwKbmSOOeJ/XtcCu37k6mT9ekWbNXJovs94HhnkV1d9ThQVF2261AN1TwG+ndu2mUhC
        8p0KaAOsdFPaGsCO6k3YqOCCscQfuy2fp385HVt+gG32GwAeYVdKiyPuycNfYpBpnyi0I0aoun0NS
        Rqlabd6NsZ/FhHPLksN9KLXW0PGQ9g3pD1o7Z1ddiODzI245vO/mcEwLmsLKeeCPcfyz5U7V7jwS2
        V+RppHYw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z7-007HBG-Qw; Mon, 06 Nov 2023 17:39:09 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 31/35] nilfs2: Convert nilfs_add_link() to use a folio
Date:   Mon,  6 Nov 2023 17:38:59 +0000
Message-Id: <20231106173903.1734114-32-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Remove six calls to compound_head() by using the folio API.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/dir.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 25a468dda0f3..fd4f99a7f402 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -440,30 +440,28 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
 	unsigned int chunk_size = nilfs_chunk_size(dir);
 	unsigned int reclen = NILFS_DIR_REC_LEN(namelen);
 	unsigned short rec_len, name_len;
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct nilfs_dir_entry *de;
 	unsigned long npages = dir_pages(dir);
 	unsigned long n;
-	char *kaddr;
-	unsigned int from, to;
+	size_t from, to;
 	int err;
 
 	/*
 	 * We take care of directory expansion in the same loop.
-	 * This code plays outside i_size, so it locks the page
+	 * This code plays outside i_size, so it locks the folio
 	 * to protect that region.
 	 */
 	for (n = 0; n <= npages; n++) {
+		char *kaddr = nilfs_get_folio(dir, n, &folio);
 		char *dir_end;
 
-		kaddr = nilfs_get_page(dir, n, &page);
-		err = PTR_ERR(kaddr);
 		if (IS_ERR(kaddr))
-			goto out;
-		lock_page(page);
+			return PTR_ERR(kaddr);
+		folio_lock(folio);
 		dir_end = kaddr + nilfs_last_byte(dir, n);
 		de = (struct nilfs_dir_entry *)kaddr;
-		kaddr += PAGE_SIZE - reclen;
+		kaddr += folio_size(folio) - reclen;
 		while ((char *)de <= kaddr) {
 			if ((char *)de == dir_end) {
 				/* We hit i_size */
@@ -490,16 +488,16 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
 				goto got_it;
 			de = (struct nilfs_dir_entry *)((char *)de + rec_len);
 		}
-		unlock_page(page);
-		unmap_and_put_page(page, kaddr);
+		folio_unlock(folio);
+		folio_release_kmap(folio, kaddr);
 	}
 	BUG();
 	return -EINVAL;
 
 got_it:
-	from = offset_in_page(de);
+	from = offset_in_folio(folio, de);
 	to = from + rec_len;
-	err = nilfs_prepare_chunk(page, from, to);
+	err = nilfs_prepare_chunk(&folio->page, from, to);
 	if (err)
 		goto out_unlock;
 	if (de->inode) {
@@ -514,16 +512,15 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
 	memcpy(de->name, name, namelen);
 	de->inode = cpu_to_le64(inode->i_ino);
 	nilfs_set_de_type(de, inode);
-	nilfs_commit_chunk(page, page->mapping, from, to);
+	nilfs_commit_chunk(&folio->page, folio->mapping, from, to);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 	nilfs_mark_inode_dirty(dir);
 	/* OFFSET_CACHE */
 out_put:
-	unmap_and_put_page(page, de);
-out:
+	folio_release_kmap(folio, de);
 	return err;
 out_unlock:
-	unlock_page(page);
+	folio_unlock(folio);
 	goto out_put;
 }
 
-- 
2.42.0

