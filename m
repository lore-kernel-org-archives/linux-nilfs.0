From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/7] mm: make mapping_get_entry available outside of filemap.c
Date: Tue,  7 Mar 2023 15:34:05 +0100
Message-ID: <20230307143410.28031-3-hch@lst.de>
References: <20230307143410.28031-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=T+jAzTrCOcTdsZuDMqbhZg8e+Lk8/gtW6xDS7q+hTuo=; b=w58U8ZXu+59sOnTWDVgjj3NsgY
        RabGvLbPyQrbHHUK7YMaegwuozB1kSfuiWWaPdFIYVydj9tGriDv7yY0wdoNRx9jbsb2SSnJMA4sQ
        eLE41Z6l5eru+IidX4hSlaoB7Gxm8vsE7pSw/6rlPP3GbudSluzZfm+uf6ottEe7maM5kK3NuEJKW
        o+0wbLpAmlwnNsxDlEno9x2AiaEggHmDAsWW90u1NMmqFG/n9YBf/yKj1ufJdOIktfAgxIzK/rq14
        Sr/JY8w89s4iKNaBFv11LgxxovavBGmCdNXFuxUKCEZTeIwdqINnl1J5JT5gckesh7xpIuPY2YT5u
        zwcp2RyA==;
In-Reply-To: <20230307143410.28031-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

mapping_get_entry is useful for page cache API users that need to know
about xa_value internals.  Rename it and make it available in pagemap.h.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 include/linux/pagemap.h | 1 +
 mm/filemap.c            | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0acb8e1fb7afdc..5d9b51d3854220 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -507,6 +507,7 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
 #define FGP_ENTRY		0x00000080
 #define FGP_STABLE		0x00000100
 
+void *filemap_get_entry(struct address_space *mapping, pgoff_t index);
 struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 		int fgp_flags, gfp_t gfp);
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
diff --git a/mm/filemap.c b/mm/filemap.c
index 2723104cc06a12..a674108a4d524b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1836,7 +1836,7 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  */
 
 /*
- * mapping_get_entry - Get a page cache entry.
+ * filemap_get_entry - Get a page cache entry.
  * @mapping: the address_space to search
  * @index: The page cache index.
  *
@@ -1847,7 +1847,7 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  *
  * Return: The folio, swap or shadow entry, %NULL if nothing is found.
  */
-static void *mapping_get_entry(struct address_space *mapping, pgoff_t index)
+void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	struct folio *folio;
@@ -1917,7 +1917,7 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 	struct folio *folio;
 
 repeat:
-	folio = mapping_get_entry(mapping, index);
+	folio = filemap_get_entry(mapping, index);
 	if (xa_is_value(folio)) {
 		if (fgp_flags & FGP_ENTRY)
 			return folio;
-- 
2.39.1

