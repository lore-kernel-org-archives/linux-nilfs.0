From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 17/17] mm: remove get_swap_bio
Date: Tue, 26 Jan 2021 15:52:47 +0100
Message-ID: <20210126145247.1964410-18-hch@lst.de>
References: <20210126145247.1964410-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=imDKE4404TVupECTT3CTRw+cqCPUxNPppd2/iiQCXMs=;
	b=aQgfKd6q628v0njktwMXtO+tpa
	VQ6AN2ML+AjC9smASiy0wrdfS4sFFCnIEmcIXu/uC9Ta7v/gFWb+6z6PpQmY8jMFGWtYqV8VJSHA0
	dXAF/4pi0+HC8kVchlMaU5GmAZa714wa2/luSOmABw0GZfAT6AU7MbJuMKkGL5tnR0JtqQacKoy8n
	WCCfmaNoO8QrPSmsSJPHsjQGoOnH268uw3Hhya2Ewhml5arq/gCxUDMs/smtqApFBFC+qBFUve6kd
	hWTlztN9lb5yJebq1pTZJuSmAUl3qDJDAbW4e+pnBNWS1tiUosnRkCm/5hJV/Kb0mS6xYMUviraAV
	ixL6cw1Q==;
In-Reply-To: <20210126145247.1964410-1-hch-jcswGhMUV9g@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Damien Le Moal <damien.lemoal-Sjgp3cTcYWE@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Just reuse the block_device and sector from the swap_info structure,
just as used by the SWP_SYNCHRONOUS path.  Also remove the checks for
NULL returns from bio_alloc as that can't happen for sleeping
allocations.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 include/linux/swap.h |  1 -
 mm/page_io.c         | 45 +++++++++++++-------------------------------
 mm/swapfile.c        | 10 ----------
 3 files changed, 13 insertions(+), 43 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 596bc2f4d9b03e..3f1f7ae0fbe9e1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -468,7 +468,6 @@ extern int free_swap_and_cache(swp_entry_t);
 int swap_type_of(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
-extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int page_swapcount(struct page *);
 extern int __swap_count(swp_entry_t entry);
diff --git a/mm/page_io.c b/mm/page_io.c
index a75f35464a4e73..92f7941c6d018b 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -26,25 +26,6 @@
 #include <linux/uio.h>
 #include <linux/sched/task.h>
 
-static struct bio *get_swap_bio(gfp_t gfp_flags,
-				struct page *page, bio_end_io_t end_io)
-{
-	struct bio *bio;
-
-	bio = bio_alloc(gfp_flags, 1);
-	if (bio) {
-		struct block_device *bdev;
-
-		bio->bi_iter.bi_sector = map_swap_page(page, &bdev);
-		bio_set_dev(bio, bdev);
-		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
-		bio->bi_end_io = end_io;
-
-		bio_add_page(bio, page, thp_size(page), 0);
-	}
-	return bio;
-}
-
 void end_swap_bio_write(struct bio *bio)
 {
 	struct page *page = bio_first_page_all(bio);
@@ -361,13 +342,13 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		return 0;
 	}
 
-	bio = get_swap_bio(GFP_NOIO, page, end_write_func);
-	if (bio == NULL) {
-		set_page_dirty(page);
-		unlock_page(page);
-		return -ENOMEM;
-	}
+	bio = bio_alloc(GFP_NOIO, 1);
+	bio_set_dev(bio, sis->bdev);
+	bio->bi_iter.bi_sector = swap_page_sector(page);
 	bio->bi_opf = REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc);
+	bio->bi_end_io = end_write_func;
+	bio_add_page(bio, page, thp_size(page), 0);
+
 	bio_associate_blkg_from_page(bio, page);
 	count_swpout_vm_event(page);
 	set_page_writeback(page);
@@ -427,18 +408,18 @@ int swap_readpage(struct page *page, bool synchronous)
 	}
 
 	ret = 0;
-	bio = get_swap_bio(GFP_KERNEL, page, end_swap_bio_read);
-	if (bio == NULL) {
-		unlock_page(page);
-		ret = -ENOMEM;
-		goto out;
-	}
+	bio = bio_alloc(GFP_KERNEL, 1);
+	bio_set_dev(bio, sis->bdev);
+	bio->bi_opf = REQ_OP_READ;
+	bio->bi_iter.bi_sector = swap_page_sector(page);
+	bio->bi_end_io = end_swap_bio_read;
+	bio_add_page(bio, page, thp_size(page), 0);
+
 	disk = bio->bi_bdev->bd_disk;
 	/*
 	 * Keep this task valid during swap readpage because the oom killer may
 	 * attempt to access it in the page fault retry time check.
 	 */
-	bio_set_op_attrs(bio, REQ_OP_READ, 0);
 	if (synchronous) {
 		bio->bi_opf |= REQ_HIPRI;
 		get_task_struct(current);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9fffc5af29d1b9..bfa9e8b0c2ef61 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2301,16 +2301,6 @@ static sector_t map_swap_entry(swp_entry_t entry, struct block_device **bdev)
 	return se->start_block + (offset - se->start_page);
 }
 
-/*
- * Returns the page offset into bdev for the specified page's swap entry.
- */
-sector_t map_swap_page(struct page *page, struct block_device **bdev)
-{
-	swp_entry_t entry;
-	entry.val = page_private(page);
-	return map_swap_entry(entry, bdev);
-}
-
 /*
  * Free all of a swapdev's extent information
  */
-- 
2.29.2
