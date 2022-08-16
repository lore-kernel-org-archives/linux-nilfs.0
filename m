From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v2 3/7] btrfs: Convert end_compressed_writeback() to use filemap_get_folios()
Date: Tue, 16 Aug 2022 10:52:42 -0700
Message-ID: <20220816175246.42401-4-vishal.moola@gmail.com>
References: <20220816175246.42401-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=seovf7hiIocC7KrgUovFX1N/tGF31/3t5G8CMyD0zNk=;
        b=A0QG8rMJwgPAuWRxPlxnmh0emyQWQHjQkk9hr6ZxAF1b/UlBzE2vwG6yDS6Onat/T1
         nRdTln1m+yYp5YakV3snbMptSKhwuNZzSDdp+NESr/ni9xiSwgMDPWEEifb5m0ZosUSV
         9sHCH+S1LknyJ/6Tl+mQPkMXI351gqUZSkqiEPyrq0vLFwuzTIVb8cRw4rdotfCRibYp
         RnT8Uco4OInEnU/NOs8Bxepr+KJ5ngBTyRUVkb2BB3TNyBoiNHJ22I2XvB3SLeWnaXDA
         Tp3f6UUxkmtH/JSg8yZtpECHMchQJlJVuq9dRAuUXMqoOgIXk5bosl31og54wQVNkTFS
         l2UA==
In-Reply-To: <20220816175246.42401-1-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>

Converted function to use folios throughout. This is in preparation for
the removal of find_get_pages_contig(). Now also supports large folios.

Since we may receive more than nr_pages pages, nr_pages may underflow.
Since nr_pages > 0 is equivalent to index <= end_index, we replaced it
with this check instead.

Also this function does not care about the pages being contiguous so we
can just use filemap_get_folios() to be more efficient.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/btrfs/compression.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index f4564f32f6d9..3dcd5006cfb4 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -8,6 +8,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/pagevec.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
 #include <linux/time.h>
@@ -339,8 +340,7 @@ static noinline void end_compressed_writeback(struct inode *inode,
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	unsigned long index = cb->start >> PAGE_SHIFT;
 	unsigned long end_index = (cb->start + cb->len - 1) >> PAGE_SHIFT;
-	struct page *pages[16];
-	unsigned long nr_pages = end_index - index + 1;
+	struct folio_batch fbatch;
 	const int errno = blk_status_to_errno(cb->status);
 	int i;
 	int ret;
@@ -348,24 +348,22 @@ static noinline void end_compressed_writeback(struct inode *inode,
 	if (errno)
 		mapping_set_error(inode->i_mapping, errno);
 
-	while (nr_pages > 0) {
-		ret = find_get_pages_contig(inode->i_mapping, index,
-				     min_t(unsigned long,
-				     nr_pages, ARRAY_SIZE(pages)), pages);
+	folio_batch_init(&fbatch);
+	while (index <= end_index) {
+		ret = filemap_get_folios(inode->i_mapping, &index, end_index,
+				&fbatch);
+
 		if (ret == 0) {
-			nr_pages -= 1;
-			index += 1;
-			continue;
+			return;
 		}
 		for (i = 0; i < ret; i++) {
+			struct folio *folio = fbatch.folios[i];
 			if (errno)
-				SetPageError(pages[i]);
-			btrfs_page_clamp_clear_writeback(fs_info, pages[i],
+				folio_set_error(folio);
+			btrfs_page_clamp_clear_writeback(fs_info, &folio->page,
 							 cb->start, cb->len);
-			put_page(pages[i]);
 		}
-		nr_pages -= ret;
-		index += ret;
+		folio_batch_release(&fbatch);
 	}
 	/* the inode may be gone now */
 }
-- 
2.36.1

