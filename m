From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 04/26] buffer: Add get_nth_bh()
Date: Tue, 19 Sep 2023 05:51:13 +0100
Message-ID: <20230919045135.3635437-5-willy@infradead.org>
References: <20230919045135.3635437-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=nArwds4hDHBhHYufta7EFXQvOR30NKKhjUtIyvFznt4=; b=RTTNLwriDilS/kAKdKH3GwxU+Z
        7jktCZAGBgGUmuWIt+5Pse+UewyOWiwO3uXEu8zXRi4MU3iF27q0hSUVvxkGsxkrXyyodbljvAcTp
        0LMy4wLm7Of+4x8zyZiuxQCq/rSIpgFdS8Wi2Vjs0saHDOwl9OPAP5MHyEcN0pkK3zuOeVDeN+J6f
        9LIzJ1L7U+P7GbH6ABVZJvsvhPtasrFVv307p1uIJDRigSb7QqthAk0YeppXMZvCx6gCNKIr5soCQ
        TPdbgB84XvpOr5H3RR/9eBDj9R540Bb/LAdli8aC/6jB6QiZLjbt7Mg6a/GJxGfSxBpI87NOJLLrD
        VfuCNkWA==;
In-Reply-To: <20230919045135.3635437-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Extract this useful helper from nilfs_page_get_nth_block()

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 fs/nilfs2/page.h            |  7 +------
 include/linux/buffer_head.h | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 21ddcdd4d63e..344d71942d36 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -55,12 +55,7 @@ unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 static inline struct buffer_head *
 nilfs_page_get_nth_block(struct page *page, unsigned int count)
 {
-	struct buffer_head *bh = page_buffers(page);
-
-	while (count-- > 0)
-		bh = bh->b_this_page;
-	get_bh(bh);
-	return bh;
+	return get_nth_bh(page_buffers(page), count);
 }
 
 #endif /* _NILFS_PAGE_H */
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 1001244a8941..9fc615ee17fd 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -457,6 +457,28 @@ __bread(struct block_device *bdev, sector_t block, unsigned size)
 	return __bread_gfp(bdev, block, size, __GFP_MOVABLE);
 }
 
+/**
+ * get_nth_bh - Get a reference on the n'th buffer after this one.
+ * @bh: The buffer to start counting from.
+ * @count: How many buffers to skip.
+ *
+ * This is primarily useful for finding the nth buffer in a folio; in
+ * that case you pass the head buffer and the byte offset in the folio
+ * divided by the block size.  It can be used for other purposes, but
+ * it will wrap at the end of the folio rather than returning NULL or
+ * proceeding to the next folio for you.
+ *
+ * Return: The requested buffer with an elevated refcount.
+ */
+static inline struct buffer_head *get_nth_bh(struct buffer_head *bh,
+		unsigned int count)
+{
+	while (count--)
+		bh = bh->b_this_page;
+	get_bh(bh);
+	return bh;
+}
+
 bool block_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 #ifdef CONFIG_BUFFER_HEAD
-- 
2.40.1

