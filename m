Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276F9C4167D
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbjKFRjf (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbjKFRjU (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887DE10EC;
        Mon,  6 Nov 2023 09:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Ct3KgawDRCsn2AuzicsAuc01DGd4DxrTPkN7HUc95r0=; b=G7EhUs+yoMqc8sB2Z5IUlIm1eN
        4bItUKbZqFDsppTsbPciaNL6Y+Y8ZQwEm9eku8BjDcQRq4mjc2W1I2pQvR2Au6HbkptBzdDmX0gpU
        ebjGew6OrGWLDJCikGVZuCtrp1PQ6N39WXkdUGX1fRXj7k5DuoNjhvikoMecy6VNpmdc8a957pEcr
        92scMhp90eyqpECTWGtpprhcJ/8g/jpjxF6wM8OATazdgCZMop7pHwQxSby3RFa0pgVGfEOpg361J
        /xI2hc8zqy+lzoExtwyoeUIOwDKHTVova5Psj7bhRtBicZyFTDkPCs8dk9bXXxn1NnNMi2keEBKCi
        4fbLjLMg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z7-007HAb-5V; Mon, 06 Nov 2023 17:39:09 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 26/35] nilfs2: Switch to kmap_local for directory handling
Date:   Mon,  6 Nov 2023 17:38:54 +0000
Message-Id: <20231106173903.1734114-27-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Match ext2 by using kmap_local() instead of kmap().  This is more
efficient.  Also use unmap_and_put_page() instead of duplicating
it as a nilfs function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/dir.c   | 37 +++++++++++++++----------------------
 fs/nilfs2/namei.c |  9 +++------
 2 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 1ae370521249..01c57573211e 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -64,12 +64,6 @@ static inline unsigned int nilfs_chunk_size(struct inode *inode)
 	return inode->i_sb->s_blocksize;
 }
 
-static inline void nilfs_put_page(struct page *page)
-{
-	kunmap(page);
-	put_page(page);
-}
-
 /*
  * Return the offset into page `page_nr' of the last valid
  * byte in that page, plus one.
@@ -195,7 +189,7 @@ static void *nilfs_get_page(struct inode *dir, unsigned long n,
 	if (IS_ERR(page))
 		return page;
 
-	kaddr = kmap(page);
+	kaddr = kmap_local_page(page);
 	if (unlikely(!PageChecked(page))) {
 		if (!nilfs_check_page(page, kaddr))
 			goto fail;
@@ -205,7 +199,7 @@ static void *nilfs_get_page(struct inode *dir, unsigned long n,
 	return kaddr;
 
 fail:
-	nilfs_put_page(page);
+	unmap_and_put_page(page, kaddr);
 	return ERR_PTR(-EIO);
 }
 
@@ -293,7 +287,7 @@ static int nilfs_readdir(struct file *file, struct dir_context *ctx)
 		for ( ; (char *)de <= limit; de = nilfs_next_entry(de)) {
 			if (de->rec_len == 0) {
 				nilfs_error(sb, "zero-length directory entry");
-				nilfs_put_page(page);
+				unmap_and_put_page(page, kaddr);
 				return -EIO;
 			}
 			if (de->inode) {
@@ -306,13 +300,13 @@ static int nilfs_readdir(struct file *file, struct dir_context *ctx)
 
 				if (!dir_emit(ctx, de->name, de->name_len,
 						le64_to_cpu(de->inode), t)) {
-					nilfs_put_page(page);
+					unmap_and_put_page(page, kaddr);
 					return 0;
 				}
 			}
 			ctx->pos += nilfs_rec_len_from_disk(de->rec_len);
 		}
-		nilfs_put_page(page);
+		unmap_and_put_page(page, kaddr);
 	}
 	return 0;
 }
@@ -357,14 +351,14 @@ nilfs_find_entry(struct inode *dir, const struct qstr *qstr,
 				if (de->rec_len == 0) {
 					nilfs_error(dir->i_sb,
 						"zero-length directory entry");
-					nilfs_put_page(page);
+					unmap_and_put_page(page, kaddr);
 					goto out;
 				}
 				if (nilfs_match(namelen, name, de))
 					goto found;
 				de = nilfs_next_entry(de);
 			}
-			nilfs_put_page(page);
+			unmap_and_put_page(page, kaddr);
 		}
 		if (++n >= npages)
 			n = 0;
@@ -404,8 +398,7 @@ ino_t nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr)
 	de = nilfs_find_entry(dir, qstr, &page);
 	if (de) {
 		res = le64_to_cpu(de->inode);
-		kunmap(page);
-		put_page(page);
+		unmap_and_put_page(page, de);
 	}
 	return res;
 }
@@ -425,7 +418,7 @@ void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 	de->inode = cpu_to_le64(inode->i_ino);
 	nilfs_set_de_type(de, inode);
 	nilfs_commit_chunk(page, mapping, from, to);
-	nilfs_put_page(page);
+	unmap_and_put_page(page, de);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 }
 
@@ -491,7 +484,7 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
 			de = (struct nilfs_dir_entry *)((char *)de + rec_len);
 		}
 		unlock_page(page);
-		nilfs_put_page(page);
+		unmap_and_put_page(page, kaddr);
 	}
 	BUG();
 	return -EINVAL;
@@ -519,7 +512,7 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
 	nilfs_mark_inode_dirty(dir);
 	/* OFFSET_CACHE */
 out_put:
-	nilfs_put_page(page);
+	unmap_and_put_page(page, de);
 out:
 	return err;
 out_unlock:
@@ -565,7 +558,7 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 	nilfs_commit_chunk(page, mapping, from, to);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 out:
-	nilfs_put_page(page);
+	unmap_and_put_page(page, kaddr);
 	return err;
 }
 
@@ -617,10 +610,10 @@ int nilfs_make_empty(struct inode *inode, struct inode *parent)
 int nilfs_empty_dir(struct inode *inode)
 {
 	struct page *page = NULL;
+	char *kaddr;
 	unsigned long i, npages = dir_pages(inode);
 
 	for (i = 0; i < npages; i++) {
-		char *kaddr;
 		struct nilfs_dir_entry *de;
 
 		kaddr = nilfs_get_page(inode, i, &page);
@@ -652,12 +645,12 @@ int nilfs_empty_dir(struct inode *inode)
 			}
 			de = nilfs_next_entry(de);
 		}
-		nilfs_put_page(page);
+		unmap_and_put_page(page, kaddr);
 	}
 	return 1;
 
 not_empty:
-	nilfs_put_page(page);
+	unmap_and_put_page(page, kaddr);
 	return 0;
 }
 
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 2a4e7f4a8102..8eebd8a464d8 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -421,13 +421,10 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 	return err;
 
 out_dir:
-	if (dir_de) {
-		kunmap(dir_page);
-		put_page(dir_page);
-	}
+	if (dir_de)
+		unmap_and_put_page(dir_page, dir_de);
 out_old:
-	kunmap(old_page);
-	put_page(old_page);
+	unmap_and_put_page(old_page, old_de);
 out:
 	nilfs_transaction_abort(old_dir->i_sb);
 	return err;
-- 
2.42.0

