From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 22/26] ufs: Add ufs_get_locked_folio and ufs_put_locked_folio
Date: Tue, 19 Sep 2023 05:51:31 +0100
Message-ID: <20230919045135.3635437-23-willy@infradead.org>
References: <20230919045135.3635437-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=pZNvvzzb8w2vdFH9XpjAcLrT4q6laln9GH3DKBbL5lk=; b=vlHuFO3J5hTc0bA9Y5eZsBGTUR
        gIOokCz7IVLf8s9nb1CBtsPw4gYX8HsPRNyEkacAQL0BEaXuYi4W2E/fpL9QuwlajtlmT++3kY4C/
        JI+8DQUdEY3kgmUq6I0GOCUijjI3lrcOTGdz+b91Ld2VQAJd4d9JgWqhJv+tXvtUNQqKJUsT9Qnrp
        UWfEVLRs2HnkJveuwkXhz38ERzovHe6GR+SUmi8hiT6s1DG9pFBOfBnA4WNAacKceLtHFTsobRu0Q
        gCkWduE1kfBuReaCTnb7P6VxZxCvLoRs69GVk6bYbJDaUMNfmgBVpsUNUzWqiFWAIM54eceNmXt0O
        YKcB2s/g==;
In-Reply-To: <20230919045135.3635437-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Convert the _page variants to call them.  Saves a few hidden calls to
compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 fs/ufs/util.c | 43 +++++++++++++++++++++++++------------------
 fs/ufs/util.h | 13 +++++++++----
 2 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/fs/ufs/util.c b/fs/ufs/util.c
index 08ddf41eaaad..151b400cb3b6 100644
--- a/fs/ufs/util.c
+++ b/fs/ufs/util.c
@@ -229,43 +229,50 @@ ufs_set_inode_dev(struct super_block *sb, struct ufs_inode_info *ufsi, dev_t dev
 		ufsi->i_u1.i_data[0] = cpu_to_fs32(sb, fs32);
 }
 
+struct page *ufs_get_locked_page(struct address_space *mapping, pgoff_t index)
+{
+	struct folio *folio = ufs_get_locked_folio(mapping, index);
+
+	if (folio)
+		return folio_file_page(folio, index);
+	return NULL;
+}
+
 /**
- * ufs_get_locked_page() - locate, pin and lock a pagecache page, if not exist
+ * ufs_get_locked_folio() - locate, pin and lock a pagecache folio, if not exist
  * read it from disk.
  * @mapping: the address_space to search
  * @index: the page index
  *
- * Locates the desired pagecache page, if not exist we'll read it,
+ * Locates the desired pagecache folio, if not exist we'll read it,
  * locks it, increments its reference
  * count and returns its address.
  *
  */
-
-struct page *ufs_get_locked_page(struct address_space *mapping,
+struct folio *ufs_get_locked_folio(struct address_space *mapping,
 				 pgoff_t index)
 {
 	struct inode *inode = mapping->host;
-	struct page *page = find_lock_page(mapping, index);
-	if (!page) {
-		page = read_mapping_page(mapping, index, NULL);
+	struct folio *folio = filemap_lock_folio(mapping, index);
+	if (!folio) {
+		folio = read_mapping_folio(mapping, index, NULL);
 
-		if (IS_ERR(page)) {
-			printk(KERN_ERR "ufs_change_blocknr: "
-			       "read_mapping_page error: ino %lu, index: %lu\n",
+		if (IS_ERR(folio)) {
+			printk(KERN_ERR "ufs_change_blocknr: read_mapping_folio error: ino %lu, index: %lu\n",
 			       mapping->host->i_ino, index);
-			return page;
+			return folio;
 		}
 
-		lock_page(page);
+		folio_lock(folio);
 
-		if (unlikely(page->mapping == NULL)) {
+		if (unlikely(folio->mapping == NULL)) {
 			/* Truncate got there first */
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			return NULL;
 		}
 	}
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
-	return page;
+	if (!folio_buffers(folio))
+		folio_create_empty_buffers(folio, 1 << inode->i_blkbits, 0);
+	return folio;
 }
diff --git a/fs/ufs/util.h b/fs/ufs/util.h
index 89247193d96d..62542561d150 100644
--- a/fs/ufs/util.h
+++ b/fs/ufs/util.h
@@ -273,12 +273,17 @@ extern void _ubh_ubhcpymem_(struct ufs_sb_private_info *, unsigned char *, struc
 extern void _ubh_memcpyubh_(struct ufs_sb_private_info *, struct ufs_buffer_head *, unsigned char *, unsigned);
 
 /* This functions works with cache pages*/
-extern struct page *ufs_get_locked_page(struct address_space *mapping,
-					pgoff_t index);
+struct page *ufs_get_locked_page(struct address_space *mapping, pgoff_t index);
+struct folio *ufs_get_locked_folio(struct address_space *mapping, pgoff_t index);
+static inline void ufs_put_locked_folio(struct folio *folio)
+{
+       folio_unlock(folio);
+       folio_put(folio);
+}
+
 static inline void ufs_put_locked_page(struct page *page)
 {
-       unlock_page(page);
-       put_page(page);
+	ufs_put_locked_folio(page_folio(page));
 }
 
 
-- 
2.40.1

