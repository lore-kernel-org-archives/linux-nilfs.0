From: "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/7] btrfs: Convert __process_pages_contig() to use filemap_get_folios_contig()
Date: Tue, 16 Aug 2022 10:52:41 -0700
Message-ID: <20220816175246.42401-3-vishal.moola@gmail.com>
References: <20220816175246.42401-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=jx5etBacOfgeXw8OAxR7RH5xH7gasMcsy/7VBjftCKo=;
        b=H4w5e03AG8w22x3dkX4OcAQ/fXJPEqBuxomQqu935pHvx9qnv6UXB89C7TehiRczmJ
         +FQpqijjHerlPV7QgbLD9Svk01RL23Cq8zB1agtQdTKICezXQlLztKbYqQG1U9PrYB3F
         zyWqZ6RrPzRD3dLiMvI5ykjFnKfybBoCI8pBmmEXw98ZnWN2weK8bBLgA5U9I2Z+eIUM
         QKiR22gp7i+ANjq/+XdN02Ns7oj11Mwz8KxmhJOAHV0Heca0OEqx2IZI7t82b/W2MAFn
         2iMRbdUPNsHr/ID8+Wt6iBOyBWHr7BuWOnifm62JTx2pKAaCJskWB35TDHj4rVoHTHoq
         ts3Q==
In-Reply-To: <20220816175246.42401-1-vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Convert to use folios throughout. This is in preparation for the removal of
find_get_pages_contig(). Now also supports large folios.

Since we may receive more than nr_pages pages, nr_pages may underflow.
Since nr_pages > 0 is equivalent to index <= end_index, we replaced it
with this check instead.

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

