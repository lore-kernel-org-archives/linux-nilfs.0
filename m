From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/7] mm: remove FGP_ENTRY
Date: Sat, 21 Jan 2023 07:57:54 +0100
Message-ID: <20230121065755.1140136-7-hch@lst.de>
References: <20230121065755.1140136-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=72dbPnQldghXJsWt6hBZ/ADNkiEKaZsKzxCkekJEdAU=; b=EwtGJdYhbY2t5msbayuhoiWkpe
        t6MwHMua7C4MCPLQpu3tFasW+WmUYj7lC4AOYQnwz08fambYeKpMPRiROaZQd5HO+QYqJCB1TNKNy
        NDrFLEbFZd7oXPqhg22FKmQ/iZyvTzrfDVoCr7fi/kMrj5I5xwyScolm4xH6P4xCA8wakx0Djui6w
        5gGQm0cHzgcYY4fVBu0uPaBIxMKCzwsH1+EMy0qjvlNu7sv+t/x+2tPkuaoQrrof7B6CQmFfx/lm6
        cNXGZSlwSjg0xTj8OBxNz35zWnQF3+xHMG9XkqAuteCgpWjW/af6YwE6nakL4Pe/4B+KdbLazR4zp
        PKWk1kjg==;
In-Reply-To: <20230121065755.1140136-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>
Cc: linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

FGP_ENTRY is unused now, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/pagemap.h | 3 +--
 mm/filemap.c            | 7 +------
 mm/folio-compat.c       | 4 ++--
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 24dedf6b12be49..e2208ee36966ea 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -504,8 +504,7 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
 #define FGP_NOFS		0x00000010
 #define FGP_NOWAIT		0x00000020
 #define FGP_FOR_MMAP		0x00000040
-#define FGP_ENTRY		0x00000080
-#define FGP_STABLE		0x00000100
+#define FGP_STABLE		0x00000080
 
 void *filemap_get_entry(struct address_space *mapping, pgoff_t index);
 struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
diff --git a/mm/filemap.c b/mm/filemap.c
index ed0583f9e27512..35baadd130795c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1889,8 +1889,6 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
  *
  * * %FGP_ACCESSED - The folio will be marked accessed.
  * * %FGP_LOCK - The folio is returned locked.
- * * %FGP_ENTRY - If there is a shadow / swap / DAX entry, return it
- *   instead of allocating a new folio to replace it.
  * * %FGP_CREAT - If no page is present then a new page is allocated using
  *   @gfp and added to the page cache and the VM's LRU list.
  *   The page is returned locked and with an increased refcount.
@@ -1916,11 +1914,8 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 
 repeat:
 	folio = filemap_get_entry(mapping, index);
-	if (xa_is_value(folio)) {
-		if (fgp_flags & FGP_ENTRY)
-			return folio;
+	if (xa_is_value(folio))
 		folio = NULL;
-	}
 	if (!folio)
 		goto no_page;
 
diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index 18c48b55792635..f3841b4977b68e 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -97,8 +97,8 @@ struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
 	struct folio *folio;
 
 	folio = __filemap_get_folio(mapping, index, fgp_flags, gfp);
-	if (!folio || xa_is_value(folio))
-		return &folio->page;
+	if (!folio)
+		return NULL;
 	return folio_file_page(folio, index);
 }
 EXPORT_SYMBOL(pagecache_get_page);
-- 
2.39.0

