Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC65C1F416A
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 05:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746683398; cv=none; b=ok3Up3K6NJ1cekiwHtvBgszWZwhp01m3MDopzcAcsbhzaWBjtiXX07cNv32sQ5vMqQXwT3T2KVqCeKI6mLWSyD0g2o3H1kBJRjdscJxcdz69f7LfFzbZMHb6CP4REM8AjSooQJSizjprjBPDG6b9PsYDqLtr14fffqm8QWMJQCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746683398; c=relaxed/simple;
	bh=rdvCSvBkVkgbn2EQsJdXzIFlB0/XZGsIjNkD0kmySlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXXaleFPEqS1AqRhQhHYzrzYoTFc6n7E1akfZTMHG0zo0WhZWeuTcIisJTUsuddrKKXERbf27RK9TjT8VNmgL8q1nap+4AUmJgvUigmrisj+bjjMqMNypq+8tMMcdaoh3h1fCG6mBzOGX9iFnPJUZjcUoWoce6tn4QjUe+vLlj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c/Jwy+g6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c/Jwy+g6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UUGd2Menm4yk6hX3VlkTglv2nMywGaE0Azul0h+Ge5E=; b=c/Jwy+g6szms5tvw7fZZCchJPW
	+CJdBv+wmSQPkd9VQAr1QUzGOtp+7Ga/mIaxlcaOND6rOkYbT4z/zzcjj6u6BUHSreFZXKXJg4g++
	PwR5cjsq4HGE7lcNbK4620tzJhzm6iWqtzz4mIjg6Q0dgZero7O5uDS1LLz9WDVQXFh5mhvkhdgi6
	SUtU/Sp5zM/02mzhgs/Pn7Gi1nlhhEcLIZgSMlYsIQY+2V1mK4kUWQrRJ9wO/P+/iu1it8BsUomZZ
	x6/QByGUiYHI8MCUqimIC0GlPooFerKGfCqR6sYUOOTewuYH+hOTTN87XKqZ5wBLFVsWOGD12ZqOO
	SpfgtqhQ==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCu8n-0000000HOrT-3JZ0;
	Thu, 08 May 2025 05:49:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-nilfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/7] mm: stop passing a writeback_control structure to __swap_writepage
Date: Thu,  8 May 2025 07:47:46 +0200
Message-ID: <20250508054938.15894-5-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250508054938.15894-1-hch@lst.de>
References: <20250508054938.15894-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

__swap_writepage only needs the swap_iocb cookie from the
writeback_control structure, so pass it explicitly and remove the
now unused swap_iocb member from struct writeback_control.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c | 33 ++++++++++++++-------------------
 mm/swap.h    |  2 +-
 mm/zswap.c   |  5 +----
 3 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index c420b0aa0f22..fb52bedcc966 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -281,7 +281,7 @@ int swap_writeout(struct folio *folio, struct writeback_control *wbc)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writepage(folio, wbc);
+	__swap_writepage(folio, wbc->swap_plug);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -371,9 +371,9 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_writepage_fs(struct folio *folio, struct writeback_control *wbc)
+static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 {
-	struct swap_iocb *sio = NULL;
+	struct swap_iocb *sio = swap_plug ? *swap_plug : NULL;
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = swap_dev_pos(folio->swap);
@@ -381,8 +381,6 @@ static void swap_writepage_fs(struct folio *folio, struct writeback_control *wbc
 	count_swpout_vm_event(folio);
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	if (wbc->swap_plug)
-		sio = *wbc->swap_plug;
 	if (sio) {
 		if (sio->iocb.ki_filp != swap_file ||
 		    sio->iocb.ki_pos + sio->len != pos) {
@@ -401,22 +399,21 @@ static void swap_writepage_fs(struct folio *folio, struct writeback_control *wbc
 	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
 	sio->pages += 1;
-	if (sio->pages == ARRAY_SIZE(sio->bvec) || !wbc->swap_plug) {
+	if (sio->pages == ARRAY_SIZE(sio->bvec) || !swap_plug) {
 		swap_write_unplug(sio);
 		sio = NULL;
 	}
-	if (wbc->swap_plug)
-		*wbc->swap_plug = sio;
+	if (swap_plug)
+		*swap_plug = sio;
 }
 
 static void swap_writepage_bdev_sync(struct folio *folio,
-		struct writeback_control *wbc, struct swap_info_struct *sis)
+		struct swap_info_struct *sis)
 {
 	struct bio_vec bv;
 	struct bio bio;
 
-	bio_init(&bio, sis->bdev, &bv, 1,
-		 REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc));
+	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_WRITE | REQ_SWAP);
 	bio.bi_iter.bi_sector = swap_folio_sector(folio);
 	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
 
@@ -431,13 +428,11 @@ static void swap_writepage_bdev_sync(struct folio *folio,
 }
 
 static void swap_writepage_bdev_async(struct folio *folio,
-		struct writeback_control *wbc, struct swap_info_struct *sis)
+		struct swap_info_struct *sis)
 {
 	struct bio *bio;
 
-	bio = bio_alloc(sis->bdev, 1,
-			REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc),
-			GFP_NOIO);
+	bio = bio_alloc(sis->bdev, 1, REQ_OP_WRITE | REQ_SWAP, GFP_NOIO);
 	bio->bi_iter.bi_sector = swap_folio_sector(folio);
 	bio->bi_end_io = end_swap_bio_write;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
@@ -449,7 +444,7 @@ static void swap_writepage_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
-void __swap_writepage(struct folio *folio, struct writeback_control *wbc)
+void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
 
@@ -460,16 +455,16 @@ void __swap_writepage(struct folio *folio, struct writeback_control *wbc)
 	 * is safe.
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
-		swap_writepage_fs(folio, wbc);
+		swap_writepage_fs(folio, swap_plug);
 	/*
 	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
 	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
 	 * is safe.
 	 */
 	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
-		swap_writepage_bdev_sync(folio, wbc, sis);
+		swap_writepage_bdev_sync(folio, sis);
 	else
-		swap_writepage_bdev_async(folio, wbc, sis);
+		swap_writepage_bdev_async(folio, sis);
 }
 
 void swap_write_unplug(struct swap_iocb *sio)
diff --git a/mm/swap.h b/mm/swap.h
index aa62463976d5..bd642078544a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -21,7 +21,7 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writeout(struct folio *folio, struct writeback_control *wbc);
-void __swap_writepage(struct folio *folio, struct writeback_control *wbc);
+void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
 /* One swap address space for each 64M swap space */
diff --git a/mm/zswap.c b/mm/zswap.c
index 455e9425c5f5..3c0fd8a13718 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1070,9 +1070,6 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
 	struct swap_info_struct *si;
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_NONE,
-	};
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1134,7 +1131,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(folio, &wbc);
+	__swap_writepage(folio, NULL);
 
 out:
 	if (ret && ret != -EEXIST) {
-- 
2.47.2

