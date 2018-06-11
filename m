From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 52/72] shmem: Convert
 shmem_partial_swap_usage to XArray
Date: Mon, 11 Jun 2018 07:06:19 -0700
Message-ID: <20180611140639.17215-53-willy@infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=oTHiFdNe4Vn6UitekWmDmg9p/jcGgir3VQorWtPf2OU=; b=Uz0jwlg6OcDwy0y3JTqeeNmECn
 hsQc8CaOKlMm8Ya0+NBrCztcOnFYSb31kgZ8caFrJS3uTrjAeW2WCExuyVKmZvCP5kDGKI9AUEtAJ
 SfYpsTfcN23q9lRF4WQx0Lz79/XP/Hx2hwNf+LOfBWQ5zN40n6YZ+K+/Jwr4mib1RaUQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=oTHiFdNe4Vn6UitekWmDmg9p/jcGgir3VQorWtPf2OU=; b=BRgBOTSJ9bKBVrR4RZ8z1fWIie
 ZgtURS3TWg4ABKKCsHnM3YBhfeppGU1pjKr+AuoYM3L66r2oXOeAGfkV+m9vIqpPTBPHhNIbEwf8S
 RyRoBjEHbAm0iGqmk1dYLY1pEVHmJCX/elxTd8cTxZuw2lXu7arR+SSyKtGMlJsmAKQY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=oTHiFdNe4Vn6UitekWmDmg9p/jcGgir3VQorWtPf2OU=; b=Voy8qDgaiHz4YuIZATm3+m9j7
 VmoYUsTWRN+oCLYOpbsfoZuvK6VneyZOgM2YrCokdEjf93cHQtIVgby73oscjYMUVTwJPLKkbMu+Y
 zNt3zh/2KJBq/JTnmrU3M10/+qZmD5RegS7dqd4un7dYmw7qraGg0o/YpHHHg2BcBuwPQbAwNOIqZ
 kBgLCBE4UZ+msZFEle9AfKaZlGfsRH2GEkT4zwfj/1EYM+lvcfGy9Jt/UKMmEfftW8HYTuZWuVNoX
 D35yUymwUPu9MoAAXUgPj49FeRr1nJCRtspS0LtgqpinlxDdPBIYXxQNt9EOW6/7cG+cPc5mPr7Yp
 C37CYV7Vg==;
In-Reply-To: <20180611140639.17215-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Simpler code because the xarray takes care of things like the limit and
dereferencing the slot.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 9dbbdd5dee30..bffb87854852 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -679,29 +679,19 @@ static int shmem_free_swap(struct address_space *mapping,
 unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 						pgoff_t start, pgoff_t end)
 {
-	struct radix_tree_iter iter;
-	void __rcu **slot;
+	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
 	unsigned long swapped = 0;
 
 	rcu_read_lock();
-
-	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
-		if (iter.index >= end)
-			break;
-
-		page = radix_tree_deref_slot(slot);
-
-		if (radix_tree_deref_retry(page)) {
-			slot = radix_tree_iter_retry(&iter);
+	xas_for_each(&xas, page, end - 1) {
+		if (xas_retry(&xas, page))
 			continue;
-		}
-
 		if (xa_is_value(page))
 			swapped++;
 
 		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
+			xas_pause(&xas);
 			cond_resched_rcu();
 		}
 	}
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
