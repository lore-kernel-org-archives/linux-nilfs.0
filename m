Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300131F416A
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 05:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746683395; cv=none; b=ULSrd+BJZpic2Cj46oQoLm1tIeIZw5Man4E6qSnsIOQi+hGB90spFtZrb/EPzTuOOeMTjQvGncei3O86XNPerrm8ZHKkycLleErvDj3JGjE4ahvaXZRsuwH3tiBee/U0XW4wwXX8o/Ah1oMhES44kWU7FpcUkbAouhNFcfdZaqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746683395; c=relaxed/simple;
	bh=afiQq7ho02aNe4ObOoADjnOLShREfKhGlFR4lJA8O4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QY9Lv55CqkpEZeBZBACr2elJaWJBoXIYxnaiR+3FAU3cKLYUnh6G4DhI4u+HEnsiVyix9540SdIPJTzL/a0+MuymK8CVSnEBAXUfdrhshhiD86rkaUD52rCvJCd/OZi5rTBCDn98JK38n2jVZGmsqxGQNSrrY0Pe/Y98gV+sWZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FfL9hF8N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FfL9hF8N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EWfztysoS9q0Ohe4ZbDKYOGyK03Dn0jHTk9wrcmOdwg=; b=FfL9hF8NU+Hp0BY612+ahLfH3/
	oaHfnVhbrUIn3bPFJ1/WTr0Rjy8nkt+INjViqhoSvOe57gx4lCbBsFcVl5sLEwrINoZ9f9f7yDDtQ
	Z9/vKoQcKVIn5RCgdjrV/r5onkK9zlvF8DsA+iWIJO5rcsZgeNOPOV2xzFMPPIxPreH6oClAmic0y
	4JX/iK7PJll10fkVX194hBX9FLxEoz0eZAUsQPuNp3NkIoSTlO15FOABehnLF5Ej2URe/VDOk4Xys
	bmCfzro6eKJ65D6LFnlCfr12/FgUqqGdeZ6n42hUZcX54JcduQlYU3qh83RUrpiBDbRinAkNVp0RV
	Y+Qg2qXg==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCu8l-0000000HOrE-0xtj;
	Thu, 08 May 2025 05:49:51 +0000
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
Subject: [PATCH 3/7] mm: tidy up swap_writeout
Date: Thu,  8 May 2025 07:47:45 +0200
Message-ID: <20250508054938.15894-4-hch@lst.de>
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

Use a goto label to consolidate the unlock folio and return pattern
and don't bother with an else after a return / goto.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index f7716b6569fa..c420b0aa0f22 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -239,12 +239,11 @@ static void swap_zeromap_folio_clear(struct folio *folio)
  */
 int swap_writeout(struct folio *folio, struct writeback_control *wbc)
 {
-	int ret;
+	int ret = 0;
+
+	if (folio_free_swap(folio))
+		goto out_unlock;
 
-	if (folio_free_swap(folio)) {
-		folio_unlock(folio);
-		return 0;
-	}
 	/*
 	 * Arch code may have to preserve more data than just the page
 	 * contents, e.g. memory tags.
@@ -252,8 +251,7 @@ int swap_writeout(struct folio *folio, struct writeback_control *wbc)
 	ret = arch_prepare_to_swap(folio);
 	if (ret) {
 		folio_mark_dirty(folio);
-		folio_unlock(folio);
-		return ret;
+		goto out_unlock;
 	}
 
 	/*
@@ -264,20 +262,19 @@ int swap_writeout(struct folio *folio, struct writeback_control *wbc)
 	 */
 	if (is_folio_zero_filled(folio)) {
 		swap_zeromap_folio_set(folio);
-		folio_unlock(folio);
-		return 0;
-	} else {
-		/*
-		 * Clear bits this folio occupies in the zeromap to prevent
-		 * zero data being read in from any previous zero writes that
-		 * occupied the same swap entries.
-		 */
-		swap_zeromap_folio_clear(folio);
+		goto out_unlock;
 	}
+
+	/*
+	 * Clear bits this folio occupies in the zeromap to prevent zero data
+	 * being read in from any previous zero writes that occupied the same
+	 * swap entries.
+	 */
+	swap_zeromap_folio_clear(folio);
+
 	if (zswap_store(folio)) {
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
-		folio_unlock(folio);
-		return 0;
+		goto out_unlock;
 	}
 	if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
 		folio_mark_dirty(folio);
@@ -286,6 +283,9 @@ int swap_writeout(struct folio *folio, struct writeback_control *wbc)
 
 	__swap_writepage(folio, wbc);
 	return 0;
+out_unlock:
+	folio_unlock(folio);
+	return ret;
 }
 
 static inline void count_swpout_vm_event(struct folio *folio)
-- 
2.47.2

