From: "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 4/7] btrfs: Convert process_page_range() to use filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 17:40:20 -0700
Message-ID: <20220824004023.77310-5-vishal.moola@gmail.com>
References: <20220824004023.77310-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=fsvLs3dxCPx9IBTgjKC5zI8Z7kYUASZBA4STFA8FapY=;
        b=kl5Ynp+b/qJi5XM2umHjmSQHEkTDDMvpacUO50PPBjgNqBHxyxqWoXIUMOfjvHAJG3
         oTGpKYfRiQ2GATQsJK0r9x42oinbboBr24fMIoK5LkiCM+8rQCJpZ15JcqKG+SzzWWdV
         /ChBcvv2dcdg92KmuvoNdeZZDzs+3KpmPPVT3ALy0+KQgopUCBZSq4NP89tr0HGtT/0V
         RP+TGfuY37/5Cg37DKL/cYxkJQRHYkhYRtyap5srPgo9RhQ9HCuU/cMf42hMXoTI+xfi
         de7hAL1mVJQ5y0T8dbCMF93yPMTrknbk2/3R/gCW32MNC4js0B9AaAgywAg9xISbM646
         tVJw==
In-Reply-To: <20220824004023.77310-1-vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Sterba <dsterb-IBi9RG/b67k@public.gmane.org>

Converted function to use folios throughout. This is in preparation for
the removal of find_get_pages_contig(). Now also supports large folios.

Since we may receive more than nr_pages pages, nr_pages may underflow.
Since nr_pages > 0 is equivalent to index <= end_index, we replaced it
with this check instead.

Also minor comment renaming for consistency in subpage.

Acked-by: David Sterba <dsterb-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Vishal Moola (Oracle) <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/btrfs/subpage.c               |  2 +-
 fs/btrfs/tests/extent-io-tests.c | 32 +++++++++++++++++---------------
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index a105b291444f..6418c38c4b30 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -337,7 +337,7 @@ bool btrfs_subpage_end_and_test_writer(const struct btrfs_fs_info *fs_info,
  *
  * Even with 0 returned, the page still need extra check to make sure
  * it's really the correct page, as the caller is using
- * find_get_pages_contig(), which can race with page invalidating.
+ * filemap_get_folios_contig(), which can race with page invalidating.
  */
 int btrfs_page_start_writer_lock(const struct btrfs_fs_info *fs_info,
 		struct page *page, u64 start, u32 len)
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index a232b15b8021..26b0c99f54b8 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/pagemap.h>
+#include <linux/pagevec.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sizes.h>
@@ -20,39 +21,40 @@ static noinline int process_page_range(struct inode *inode, u64 start, u64 end,
 				       unsigned long flags)
 {
 	int ret;
-	struct page *pages[16];
+	struct folio_batch fbatch;
 	unsigned long index = start >> PAGE_SHIFT;
 	unsigned long end_index = end >> PAGE_SHIFT;
-	unsigned long nr_pages = end_index - index + 1;
 	int i;
 	int count = 0;
 	int loops = 0;
 
-	while (nr_pages > 0) {
-		ret = find_get_pages_contig(inode->i_mapping, index,
-				     min_t(unsigned long, nr_pages,
-				     ARRAY_SIZE(pages)), pages);
+	folio_batch_init(&fbatch);
+
+	while (index <= end_index) {
+		ret = filemap_get_folios_contig(inode->i_mapping, &index,
+				end_index, &fbatch);
 		for (i = 0; i < ret; i++) {
+			struct folio *folio = fbatch.folios[i];
+
 			if (flags & PROCESS_TEST_LOCKED &&
-			    !PageLocked(pages[i]))
+			    !folio_test_locked(folio))
 				count++;
-			if (flags & PROCESS_UNLOCK && PageLocked(pages[i]))
-				unlock_page(pages[i]);
-			put_page(pages[i]);
+			if (flags & PROCESS_UNLOCK && folio_test_locked(folio))
+				folio_unlock(folio);
 			if (flags & PROCESS_RELEASE)
-				put_page(pages[i]);
+				folio_put(folio);
 		}
-		nr_pages -= ret;
-		index += ret;
+		folio_batch_release(&fbatch);
 		cond_resched();
 		loops++;
 		if (loops > 100000) {
 			printk(KERN_ERR
-		"stuck in a loop, start %llu, end %llu, nr_pages %lu, ret %d\n",
-				start, end, nr_pages, ret);
+		"stuck in a loop, start %llu, end %llu, ret %d\n",
+				start, end, ret);
 			break;
 		}
 	}
+
 	return count;
 }
 
-- 
2.36.1

