From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v2 4/7] btrfs: Convert process_page_range() to use filemap_get_folios_contig()
Date: Tue, 16 Aug 2022 10:52:43 -0700
Message-ID: <20220816175246.42401-5-vishal.moola@gmail.com>
References: <20220816175246.42401-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=zEWA5Mz5qgiKRAyUDs57laoSTQi4JTinbk89K1VeDTg=;
        b=Q0jTOXo0r8co2kNY7avhSUyp1min9bEFsIm1c2a5izPGeJQJyrPEAdD/n+GuHi8PWd
         WDStj6ozmxAN2tU8n0OKp1MPPxLW30a+rTvbx7Em+x0pgSFHhDJIWxTzr8OhJrSdE1iQ
         J/cZAICwfQm78pCbo4YRcdifiMgACJZJJeJfKQ90aQHcbOLTrcfKeLde4inZkvLukGdo
         fsrPaibUyeZTQcqDwhOMT3JDJ+Niv+a0cdWCMmdyIVFOUoqIraeDZhAU0Lz0n0wHdAni
         CbdZ22zpnt5sFgJAo2zIgwtwYFfiaDOqSKqpG+qLfvUloduCa5fc3Mk2m1FjVMPb80Bj
         gjBQ==
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

Also minor comment renaming for consistency in subpage.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/btrfs/subpage.c               |  2 +-
 fs/btrfs/tests/extent-io-tests.c | 31 ++++++++++++++++---------------
 2 files changed, 17 insertions(+), 16 deletions(-)

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
index a232b15b8021..530073868916 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/pagemap.h>
+#include <linux/pagevec.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sizes.h>
@@ -20,39 +21,39 @@ static noinline int process_page_range(struct inode *inode, u64 start, u64 end,
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

