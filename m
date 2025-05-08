Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D85613C3F2
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 05:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746683389; cv=none; b=mQUYGWQAzGq+1k3piSZNmw1T8Gv85Vwc+dnFih/YVlG5UAAb10srYBZZmDvRCqmkvoHp/wpy+x9cx5hiPcwEhWxaUF0et/pi/daHvwkBu3xG4bpJycJB6oQKkprTMUZARifOJgfOVSngNJamBd5JnY28GJou7SEmEJQ/DUxt5eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746683389; c=relaxed/simple;
	bh=uhKvLdj0XLL5qxK90a7+g5SKs4sf+I+iFz45q+tOTFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtpTUUsQXnkfbUoOJaM1tJeuCWUTIWuYzt2aDB4i8swx2zEzGWBRI6Z/Li0zBr08nj/FEqtg9CNCOURidNYxlOfOMaxe1kGckbB73o7IN2KUf7H4NK9omkezlvCglvPg8G4bCG5e9Ryapp+5hSwjKim9Tyt6bphfHrsgGnkpJ9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ITL7nB2X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ITL7nB2X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lDS4CQDMt6fBaz6f4nKyy3R5IS7pBQJb3cwOF5lvFLU=; b=ITL7nB2XoHNUfF9pD4GO3+jPWQ
	HeS502StPxivfEaxWdJG3TpHg2sBkKVrixiJKqRzfdvMZ2fGYoKglFCE9i/2ATEkdHH2oEuMcePV1
	pwr8FCgd1dVJFKuphgTKM5sXWyx9+XlIOH5A0DlEFyfYgFq3s1EH7JZCBovVKTotQLdH7vnElYBwN
	W9ah3nMfx+epnR+DY10V3+IR8gsi+vnTj/xNr+jE09fjL628Iuib7zSp6bUO/ervxjwGwJI/c7uis
	Tk6v2Atsi+g/LafxEHgpfCGYdEEz92RSCdtBLzrdMThExiwWXQNU+cXFZEcCeDnepOGoBoBJTqP56
	fENX+Gpg==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCu8g-0000000HOqh-0edU;
	Thu, 08 May 2025 05:49:46 +0000
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
Subject: [PATCH 1/7] mm: split out a writeout helper from pageout
Date: Thu,  8 May 2025 07:47:43 +0200
Message-ID: <20250508054938.15894-2-hch@lst.de>
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

Move the code to write back swap / shmem folios into a self-contained
helper to keep prepare for refactoring it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/vmscan.c | 94 +++++++++++++++++++++++++++--------------------------
 1 file changed, 48 insertions(+), 46 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c9f22abf0d38..42302d2b8739 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -652,14 +652,55 @@ typedef enum {
 	PAGE_CLEAN,
 } pageout_t;
 
+static pageout_t writeout(struct folio *folio, struct address_space *mapping,
+		struct swap_iocb **plug, struct list_head *folio_list)
+{
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE,
+		.nr_to_write = SWAP_CLUSTER_MAX,
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+		.for_reclaim = 1,
+		.swap_plug = plug,
+	};
+	int res;
+
+	folio_set_reclaim(folio);
+
+	/*
+	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
+	 * or we failed to allocate contiguous swap entries.
+	 */
+	if (shmem_mapping(mapping)) {
+		if (folio_test_large(folio))
+			wbc.list = folio_list;
+		res = shmem_writeout(folio, &wbc);
+	} else {
+		res = swap_writeout(folio, &wbc);
+	}
+
+	if (res < 0)
+		handle_write_error(mapping, folio, res);
+	if (res == AOP_WRITEPAGE_ACTIVATE) {
+		folio_clear_reclaim(folio);
+		return PAGE_ACTIVATE;
+	}
+
+	/* synchronous write? */
+	if (!folio_test_writeback(folio))
+		folio_clear_reclaim(folio);
+
+	trace_mm_vmscan_write_folio(folio);
+	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
+	return PAGE_SUCCESS;
+}
+
 /*
  * pageout is called by shrink_folio_list() for each dirty folio.
  */
 static pageout_t pageout(struct folio *folio, struct address_space *mapping,
 			 struct swap_iocb **plug, struct list_head *folio_list)
 {
-	int (*writeout)(struct folio *, struct writeback_control *);
-
 	/*
 	 * We no longer attempt to writeback filesystem folios here, other
 	 * than tmpfs/shmem.  That's taken care of in page-writeback.
@@ -690,51 +731,12 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
 		}
 		return PAGE_KEEP;
 	}
-	if (shmem_mapping(mapping))
-		writeout = shmem_writeout;
-	else if (folio_test_anon(folio))
-		writeout = swap_writeout;
-	else
-		return PAGE_ACTIVATE;
-
-	if (folio_clear_dirty_for_io(folio)) {
-		int res;
-		struct writeback_control wbc = {
-			.sync_mode = WB_SYNC_NONE,
-			.nr_to_write = SWAP_CLUSTER_MAX,
-			.range_start = 0,
-			.range_end = LLONG_MAX,
-			.for_reclaim = 1,
-			.swap_plug = plug,
-		};
 
-		/*
-		 * The large shmem folio can be split if CONFIG_THP_SWAP is
-		 * not enabled or contiguous swap entries are failed to
-		 * allocate.
-		 */
-		if (shmem_mapping(mapping) && folio_test_large(folio))
-			wbc.list = folio_list;
-
-		folio_set_reclaim(folio);
-		res = writeout(folio, &wbc);
-		if (res < 0)
-			handle_write_error(mapping, folio, res);
-		if (res == AOP_WRITEPAGE_ACTIVATE) {
-			folio_clear_reclaim(folio);
-			return PAGE_ACTIVATE;
-		}
-
-		if (!folio_test_writeback(folio)) {
-			/* synchronous write? */
-			folio_clear_reclaim(folio);
-		}
-		trace_mm_vmscan_write_folio(folio);
-		node_stat_add_folio(folio, NR_VMSCAN_WRITE);
-		return PAGE_SUCCESS;
-	}
-
-	return PAGE_CLEAN;
+	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
+		return PAGE_ACTIVATE;
+	if (!folio_clear_dirty_for_io(folio))
+		return PAGE_CLEAN;
+	return writeout(folio, mapping, plug, folio_list);
 }
 
 /*
-- 
2.47.2

