From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 6/7] ramfs: Convert ramfs_nommu_get_unmapped_area() to use filemap_get_folios_contig()
Date: Mon, 15 Aug 2022 11:54:51 -0700
Message-ID: <20220815185452.37447-7-vishal.moola@gmail.com>
References: <20220815185452.37447-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=JxYlL9B7PcenLE4u6mpHNMIpwNwBfeAtvgsgZnBC2EQ=;
        b=Ia1O+/fmqiUDytIZqSmA1V3vSbkX1zepYr8UWJ1xOY+Au2TuQsU1CjaK+zT0PLsmd/
         E+O3yzfMaR5NdY5ImhVrdZFqgG8IY6GLyAkAuZAxXNJ7g1frwjv+xObysOMw9ZQj9N38
         V4kBxNRZzYBXVht6J1C8aUFPM4q7f2/Mr6FKOhM86huxwwIsCgF7Ec+Fkmx2Imxe112s
         8rZyF/n/+Pg4xSWae5jHMVbRnTduCkxC52xGgOOsHGt0tWEXwod/MCwauyzBrtSeu3v4
         sUXY2yNRl9HIjovNajfVtO2mLmyLZtZShw82f7ZwxsdOEL4uwXFqQMMX21AafPCChnds
         jq0w==
In-Reply-To: <20220815185452.37447-1-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>

Converted to use folios throughout. This is in preparation for the
removal for find_get_pages_contig(). Now also supports large folios.

The initial version of this function set the page_address to be returned
after finishing all the checks. Since folio_batches have a maximum of 15
folios, the function had to be modified to support getting and checking up
to lpages, 15 pages at a time while still returning the initial page address.
Now the function sets ret as soon as the first batch arrives, and updates it
only if a check fails.

The physical adjacency check utilizes the page frame numbers. The page frame
number of each folio must be nr_pages away from the first folio.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/ramfs/file-nommu.c | 50 +++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index ba3525ccc27e..81817f301e17 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -203,9 +203,9 @@ static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 					    unsigned long addr, unsigned long len,
 					    unsigned long pgoff, unsigned long flags)
 {
-	unsigned long maxpages, lpages, nr, loop, ret;
+	unsigned long maxpages, lpages, nr, loop, ret, nr_pages, pfn;
 	struct inode *inode = file_inode(file);
-	struct page **pages = NULL, **ptr, *page;
+	struct folio_batch fbatch;
 	loff_t isize;
 
 	/* the mapping mustn't extend beyond the EOF */
@@ -221,31 +221,39 @@ static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 		goto out;
 
 	/* gang-find the pages */
-	pages = kcalloc(lpages, sizeof(struct page *), GFP_KERNEL);
-	if (!pages)
-		goto out_free;
-
-	nr = find_get_pages_contig(inode->i_mapping, pgoff, lpages, pages);
-	if (nr != lpages)
-		goto out_free_pages; /* leave if some pages were missing */
+	folio_batch_init(&fbatch);
+	nr_pages = 0;
+repeat:
+	nr = filemap_get_folios_contig(inode->i_mapping, &pgoff,
+			ULONG_MAX, &fbatch);
+	if (!nr) {
+		ret = -ENOSYS;
+		return ret;
+	}
 
+	if (ret == -ENOSYS) {
+		ret = (unsigned long) folio_address(fbatch.folios[0]);
+		pfn = folio_pfn(fbatch.folios[0]);
+	}
 	/* check the pages for physical adjacency */
-	ptr = pages;
-	page = *ptr++;
-	page++;
-	for (loop = lpages; loop > 1; loop--)
-		if (*ptr++ != page++)
-			goto out_free_pages;
+	for (loop = 0; loop < nr; loop++) {
+		if (pfn + nr_pages != folio_pfn(fbatch.folios[loop])) {
+			ret = -ENOSYS;
+			goto out_free; /* leave if not physical adjacent */
+		}
+		nr_pages += folio_nr_pages(fbatch.folios[loop]);
+		if (nr_pages >= lpages)
+			goto out_free; /* successfully found desired pages*/
+	}
 
+	if (nr_pages < lpages) {
+		folio_batch_release(&fbatch);
+		goto repeat; /* loop if pages are missing */
+	}
 	/* okay - all conditions fulfilled */
-	ret = (unsigned long) page_address(pages[0]);
 
-out_free_pages:
-	ptr = pages;
-	for (loop = nr; loop > 0; loop--)
-		put_page(*ptr++);
 out_free:
-	kfree(pages);
+	folio_batch_release(&fbatch);
 out:
 	return ret;
 }
-- 
2.36.1

