From: "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 3/7] btrfs: Convert end_compressed_writeback() to use filemap_get_folios()
Date: Tue, 23 Aug 2022 17:40:19 -0700
Message-ID: <20220824004023.77310-4-vishal.moola@gmail.com>
References: <20220824004023.77310-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=qAIZUZ0pgScRmQa0duFh/+V4CGm9o36zgCrAtR/Z4DI=;
        b=oI3O32y9Nc1raAftWQD45HU0GA4593iugYPxYzJPeePQFlHLBee2vueXj2ulohnlGD
         0apI5Vd2fXUvaSfIfbhGlpXWV8qX5pAShMjdTMdoMsZPlf0qnMkxYf0Mt7om59P/zn0D
         nkf6+QPwhFNNcbPSMmPiebGNWB5Fyut9TU52gVuzsPb0lqdPHa06BWertBwZr/3AkyLF
         6G3GMlyy5cWyGBlHl/U/aIJUlygwCrZndzi8pl6TFqpKdhcY0snfUl3PeC/zdS/Z90cK
         XGmdiXzwyIPV20FBVatPpV4QZVBMlp43v26aUh+bcTSoSOOt++Szi9rUHP6iiXXqbfVr
         Ntuw==
In-Reply-To: <20220824004023.77310-1-vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>

Converted function to use folios throughout. This is in preparation for
the removal of find_get_pages_contig(). Now also supports large folios.

Since we may receive more than nr_pages pages, nr_pages may underflow.
Since nr_pages > 0 is equivalent to index <= end_index, we replaced it
with this check instead.

Also this function does not care about the pages being contiguous so we
can just use filemap_get_folios() to be more efficient.

Acked-by: David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Vishal Moola (Oracle) <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/btrfs/compression.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index f4564f32f6d9..e0f8839cdd94 100644
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
@@ -348,24 +348,23 @@ static noinline void end_compressed_writeback(struct inode *inode,
 	if (errno)
 		mapping_set_error(inode->i_mapping, errno);
 
-	while (nr_pages > 0) {
-		ret = find_get_pages_contig(inode->i_mapping, index,
-				     min_t(unsigned long,
-				     nr_pages, ARRAY_SIZE(pages)), pages);
-		if (ret == 0) {
-			nr_pages -= 1;
-			index += 1;
-			continue;
-		}
+	folio_batch_init(&fbatch);
+	while (index <= end_index) {
+		ret = filemap_get_folios(inode->i_mapping, &index, end_index,
+				&fbatch);
+
+		if (ret == 0)
+			return;
+
 		for (i = 0; i < ret; i++) {
+			struct folio *folio = fbatch.folios[i];
+
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

