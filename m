From: Chaitanya Kulkarni <chaitanya.kulkarni-Sjgp3cTcYWE@public.gmane.org>
Subject: [RFC PATCH 34/34] mm: add swap_bio_new common bio helper
Date: Wed, 27 Jan 2021 23:11:33 -0800
Message-ID: <20210128071133.60335-35-chaitanya.kulkarni@wdc.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
	d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
	t=1611818241; x=1643354241;
	h=from:to:cc:subject:date:message-id:in-reply-to:
	references:mime-version:content-transfer-encoding;
	bh=KxHF3VRS1HdpvW1dkgXeP6+bfyoqSsbsdMU7tIvbgNk=;
	b=bALs/mSsHRYfgxMPhZSpHkUbSFtzqyKAiOx/ENsMGTRBKeRA4mkEFI4A
	G9u886gZVbGrhOEeaBDJwNae3FuUC3EE19DJGgRrVUHDGV8w5CRvZeV91
	CsVyFR+VdxWpTv1J51w9bYlf27Q5WDOLJE5KAn00uOmqsM70aT7vmb7kE
	nQe9sWTOFz2tejanmb0X9D2MOuT5RgOvfuCAL9Wsvau8/8s0oBnDjBmJZ
	pr9md7vTOEDqsFnH9OpRhERC4uXls/vzSr0umPKy9iyIeiqHtsJtD63b5
	MN/MerGLZoLNefuavKkKhsKZ9fH7lZgYptQMsj00cutLjRYN1Zmc8QoLZ w==;
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni-Sjgp3cTcYWE@public.gmane.org>
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
To: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tiwai-l3A5Bk7waGM@public.gmane.org, djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, naohiro.aota-Sjgp3cTcYWE@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, mark-qFb/fKtWg+rQT0dZR+AlfA@public.gmane.org, osandov-b10kYP2dOMg@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org, len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, chaitanya.kulkarni-Sjgp3cTcYWE@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, jefflexu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, damien.lemoal-Sjgp3cTcYWE@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org, roger.pau-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni-Sjgp3cTcYWE@public.gmane.org>
---
 mm/page_io.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 7579485ccb5e..cc30c9a0b0a7 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -287,6 +287,17 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct page *page)
 #define bio_associate_blkg_from_page(bio, page)		do { } while (0)
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
+static inline struct bio *swap_bio_new(struct block_device *dev,
+		unsigned op, unsigned opf, gfp_t gfp, struct page *p,
+		bio_end_io_t *end_io)
+{
+	struct bio *bio = bio_new(dev, swap_page_sector(p), op, opf, 1, gfp);
+
+	bio->bi_end_io = end_io;
+	bio_add_page(bio, p, thp_size(p), 0);
+	return bio;
+}
+
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		bio_end_io_t end_write_func)
 {
@@ -342,11 +353,9 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		return 0;
 	}
 
-	bio = bio_new(sis->bdev, swap_page_sector(page), REQ_OP_WRITE,
-			REQ_SWAP | wbc_to_write_flags(wbc), 1, GFP_NOIO);
-	bio->bi_end_io = end_write_func;
-	bio_add_page(bio, page, thp_size(page), 0);
-
+	bio = swap_bio_new(sis->bdev, REQ_OP_WRITE,
+			REQ_SWAP | wbc_to_write_flags(wbc), GFP_KERNEL,
+			page, end_write_func);
 	bio_associate_blkg_from_page(bio, page);
 	count_swpout_vm_event(page);
 	set_page_writeback(page);
@@ -406,11 +415,8 @@ int swap_readpage(struct page *page, bool synchronous)
 	}
 
 	ret = 0;
-	bio = bio_new(sis->bdev, swap_page_sector(page), REQ_OP_READ, 0, 1,
-			GFP_KERNEL);
-	bio->bi_end_io = end_swap_bio_read;
-	bio_add_page(bio, page, thp_size(page), 0);
-
+	bio = swap_bio_new(sis->bdev, REQ_OP_READ, 0, GFP_KERNEL, page,
+			end_swap_bio_read);
 	disk = bio->bi_bdev->bd_disk;
 	/*
 	 * Keep this task valid during swap readpage because the oom killer may
-- 
2.22.1
