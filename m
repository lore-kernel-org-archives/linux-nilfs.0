From: "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 2/7] btrfs: Convert __process_pages_contig() to use filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 17:40:18 -0700
Message-ID: <20220824004023.77310-3-vishal.moola@gmail.com>
References: <20220824004023.77310-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=7skDaFS+wO3x7T1TXAuYW/BptQcipesiqb0XDCtUEEw=;
        b=eHdJm85W11mqHe7iSlXRQz2ygLqKExb3lA40z8uFuGfbXq3WXeGy9DXultohRdLawo
         7Qd4RYcqXdiOD1jVazkFWrVfbcEpZLkLKiYEbbVNpAP6i1Nd7Enztpw0rco/HtfAgelS
         yXfeHGXyD3xjvUoNPjR0C5NtRVGRp7UlscxmNBTFPWt1x2OwLuMcANfed4zmLsZjT/45
         2+zuuS+rYfMhq3rXHITdzud7s/woaEpElOxkAQsM6OVktlhuI4CydOja6ok5+Q7WCPNx
         7UYV6GrwTNA8j6aGb/1ATFVVL0qJDsULOKYgFWsLu62kFPJLVN89ECVXY93Qo3YIHNjG
         RWfw==
In-Reply-To: <20220824004023.77310-1-vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>

Convert to use folios throughout. This is in preparation for the removal of
find_get_pages_contig(). Now also supports large folios.

Since we may receive more than nr_pages pages, nr_pages may underflow.
Since nr_pages > 0 is equivalent to index <= end_index, we replaced it
with this check instead.

Acked-by: David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Vishal Moola (Oracle) <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/btrfs/extent_io.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8f6b544ae616..f16929bc531b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1882,9 +1882,8 @@ static int __process_pages_contig(struct address_space *mapping,
 	pgoff_t start_index = start >> PAGE_SHIFT;
 	pgoff_t end_index = end >> PAGE_SHIFT;
 	pgoff_t index = start_index;
-	unsigned long nr_pages = end_index - start_index + 1;
 	unsigned long pages_processed = 0;
-	struct page *pages[16];
+	struct folio_batch fbatch;
 	int err = 0;
 	int i;
 
@@ -1893,16 +1892,17 @@ static int __process_pages_contig(struct address_space *mapping,
 		ASSERT(processed_end && *processed_end == start);
 	}
 
-	if ((page_ops & PAGE_SET_ERROR) && nr_pages > 0)
+	if ((page_ops & PAGE_SET_ERROR) && start_index <= end_index)
 		mapping_set_error(mapping, -EIO);
 
-	while (nr_pages > 0) {
-		int found_pages;
+	folio_batch_init(&fbatch);
+	while (index <= end_index) {
+		int found_folios;
+
+		found_folios = filemap_get_folios_contig(mapping, &index,
+				end_index, &fbatch);
 
-		found_pages = find_get_pages_contig(mapping, index,
-				     min_t(unsigned long,
-				     nr_pages, ARRAY_SIZE(pages)), pages);
-		if (found_pages == 0) {
+		if (found_folios == 0) {
 			/*
 			 * Only if we're going to lock these pages, we can find
 			 * nothing at @index.
@@ -1912,23 +1912,20 @@ static int __process_pages_contig(struct address_space *mapping,
 			goto out;
 		}
 
-		for (i = 0; i < found_pages; i++) {
+		for (i = 0; i < found_folios; i++) {
 			int process_ret;
-
+			struct folio *folio = fbatch.folios[i];
 			process_ret = process_one_page(fs_info, mapping,
-					pages[i], locked_page, page_ops,
+					&folio->page, locked_page, page_ops,
 					start, end);
 			if (process_ret < 0) {
-				for (; i < found_pages; i++)
-					put_page(pages[i]);
 				err = -EAGAIN;
+				folio_batch_release(&fbatch);
 				goto out;
 			}
-			put_page(pages[i]);
-			pages_processed++;
+			pages_processed += folio_nr_pages(folio);
 		}
-		nr_pages -= found_pages;
-		index += found_pages;
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 out:
-- 
2.36.1

