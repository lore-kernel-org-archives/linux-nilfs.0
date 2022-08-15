From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 2/7] btrfs: Convert __process_pages_contig() to use filemap_get_folios_contig()
Date: Mon, 15 Aug 2022 11:54:47 -0700
Message-ID: <20220815185452.37447-3-vishal.moola@gmail.com>
References: <20220815185452.37447-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=YNgoWYCY1lPrjzW0L6uvTUDhqO8Va4cbu+Lukza45Kk=;
        b=LLqk6nZx0CZaFFAKrYtayFNSQtFEufiNWAnBpPZzb6NuyTnfFHJ50yjihvOX09BnKM
         S47QhKHOD34cTFOPR6PhaMP7mmdaLrRYSmY3S08Yq78sPmyEiJxae5DQvOOdYruhjV2K
         VainybYqq60xbvb9Mjvhb2WTFrPUhyaHxn2OUAWwknzK883JGnUdbEkTFKzA/VFk6DlK
         U8j6FtQ9cjPFpqQ5YnVDfhVJc2COUwxSydLt+v/jUsytUL1hfqyDMVpnBKcHVytFmRqk
         lLrXpBUiei5hCA+Dw8+0AgZvhFxuDhaZTjwgI8a7Iu6XaMONbkJrwlTwh1AJurWNAhXM
         TeLQ==
In-Reply-To: <20220815185452.37447-1-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>

Convert to use folios throughout. This is in preparation for the removal of
find_get_pages_contig(). Now also supports large folios.

Since we may receive more than nr_pages pages, nr_pages may underflow.
Since nr_pages > 0 is equivalent to index <= end_index, we replaced it
with this check instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/btrfs/extent_io.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bfae67c593c5..2c2f0e281014 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1900,9 +1900,8 @@ static int __process_pages_contig(struct address_space *mapping,
 	pgoff_t start_index = start >> PAGE_SHIFT;
 	pgoff_t end_index = end >> PAGE_SHIFT;
 	pgoff_t index = start_index;
-	unsigned long nr_pages = end_index - start_index + 1;
 	unsigned long pages_processed = 0;
-	struct page *pages[16];
+	struct folio_batch fbatch;
 	int err = 0;
 	int i;
 
@@ -1911,16 +1910,17 @@ static int __process_pages_contig(struct address_space *mapping,
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
@@ -1930,23 +1930,20 @@ static int __process_pages_contig(struct address_space *mapping,
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

