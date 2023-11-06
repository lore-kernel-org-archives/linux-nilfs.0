Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B238C4167D
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjKFRji (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbjKFRjV (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EEB10FC;
        Mon,  6 Nov 2023 09:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=FlLbEVf0PN4kX7ByTNMKLyW2/z0i6E9D6N10cj5kGFU=; b=CHON0uSQvxnKZ31wwV5oToeTyz
        lnyVoG2tfrzTZTHqNEp4kWmm6LkYGiLI9SCJTzl5Df/Fd7SlrLvekWmnMSu9JOmh3h0Q9KVs1GVyb
        AeALwf/2hqKXEa7eP+IeujASdkVZmDD7ZfdhfIS5QKszUVyVPp7G6jXTnSEPFlJh0LkPPJMvyh5XZ
        vHO/p5WrfYwuJA7JDD3REGM6VKcPW6GOHW9JIPlfwgNHmWkdA4o1gsKV5IcDVexARgHGKutDDBwax
        8E/m53kB6wGSHwYMiYxSOhkot8080U/WRm0K5LkIPe83fyLDDjAjiq5s8XorF64OG2N2YU+tE11eO
        tWa36Rlw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z8-007HBZ-5A; Mon, 06 Nov 2023 17:39:10 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 33/35] nilfs2: Convert nilfs_make_empty() to use a folio
Date:   Mon,  6 Nov 2023 17:39:01 +0000
Message-Id: <20231106173903.1734114-34-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Remove two calls to compound_head() and switch from kmap_atomic to
kmap_local.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/dir.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index e598431516fc..1085e9a5b84e 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -561,21 +561,21 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct folio *folio)
 int nilfs_make_empty(struct inode *inode, struct inode *parent)
 {
 	struct address_space *mapping = inode->i_mapping;
-	struct page *page = grab_cache_page(mapping, 0);
+	struct folio *folio = filemap_grab_folio(mapping, 0);
 	unsigned int chunk_size = nilfs_chunk_size(inode);
 	struct nilfs_dir_entry *de;
 	int err;
 	void *kaddr;
 
-	if (!page)
-		return -ENOMEM;
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
 
-	err = nilfs_prepare_chunk(page, 0, chunk_size);
+	err = nilfs_prepare_chunk(&folio->page, 0, chunk_size);
 	if (unlikely(err)) {
-		unlock_page(page);
+		folio_unlock(folio);
 		goto fail;
 	}
-	kaddr = kmap_atomic(page);
+	kaddr = kmap_local_folio(folio, 0);
 	memset(kaddr, 0, chunk_size);
 	de = (struct nilfs_dir_entry *)kaddr;
 	de->name_len = 1;
@@ -590,10 +590,10 @@ int nilfs_make_empty(struct inode *inode, struct inode *parent)
 	de->inode = cpu_to_le64(parent->i_ino);
 	memcpy(de->name, "..\0", 4);
 	nilfs_set_de_type(de, inode);
-	kunmap_atomic(kaddr);
-	nilfs_commit_chunk(page, mapping, 0, chunk_size);
+	kunmap_local(kaddr);
+	nilfs_commit_chunk(&folio->page, mapping, 0, chunk_size);
 fail:
-	put_page(page);
+	folio_put(folio);
 	return err;
 }
 
-- 
2.42.0

