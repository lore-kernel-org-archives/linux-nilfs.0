From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 13/23] f2fs: Convert f2fs_sync_node_pages() to
 use filemap_get_folios_tag()
Date: Thu,  1 Sep 2022 15:01:28 -0700
Message-ID: <20220901220138.182896-14-vishal.moola@gmail.com>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:References:
 In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=pWqS4ooFUTFHzhqRBDvFvbwutPU6GCzkgDePLKh0xDE=; b=ZH8CMD29By5Dpqth2nWE+q2K/B
 maTR01Kgq2fe9aJmTDZR0Oxp/yHGMTx+1N2k1lyla9FAOADif2IVExZYKVdTAIsRtc8bdTLRoISDu
 6qJ+vEaFAwfmyt8anKnxm9AyHCHK9XnnYXXjlyOBNk2sKZyDocps+fc/pLCsnSlTfBcE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=pWqS4ooFUTFHzhqRBDvFvbwutPU6GCzkgDePLKh0xDE=; b=XRecrT6GeOyiH6cjpUkjzMggYw
 0gog2hYN8Rvka0lyGuQvmNdzp/eQ1dw+VYu/ZgE1pFjz4m3AG4ljg84z3AUFQKoYub/b3AM49G2FC
 es/3pbtqfvg1+JAtsVtBQxnN+/1yqBx/A/4s39Wu9wCuKlEyB47bflMR8DOpSe4+4DP0=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
 bh=pWqS4ooFUTFHzhqRBDvFvbwutPU6GCzkgDePLKh0xDE=;
 b=ltbTUVZlF/Z87l55Zx7YIMdiSlF79NxCKA3kDzN/UdHnBbOhUkxYokZciUF5yB23IQ
 3aZV0dCORuNfmkqtB4Um8rih0THqW1I8+Kg6eCX7JtCSq0qK5FxY5JJ3W+WjbZVvFS/N
 SHzuRTNRkOZU91jiFJ75s3/HaNBfpPrOuW0Q5xjsFySVCqjGc+FQww/RxS0JKeXHhL7h
 kAOi4h68L/U7Zh4Cxk29fMBM+9NAxnpOY6BN4/Gy4hT5bv4ACVWiuAvUMQEQVyDUFGrl
 0WnCZ51DYlpojmaB5f2e+eBCMWO+Ah52Ft8Wrewyr1JSMgQJJeMlPU47Bp2sXDcRwEoX
 fJpw==
In-Reply-To: <20220901220138.182896-1-vishal.moola@gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

Convert function to use folios. This is in preparation for the removal
of find_get_pages_range_tag(). Does NOT support large folios.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/f2fs/node.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index c2b54c58392a..cf8665f04c0d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1933,23 +1933,24 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 				bool do_balance, enum iostat_type io_type)
 {
 	pgoff_t index;
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	int step = 0;
 	int nwritten = 0;
 	int ret = 0;
-	int nr_pages, done = 0;
+	int nr_folios, done = 0;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
 next_step:
 	index = 0;
 
-	while (!done && (nr_pages = pagevec_lookup_tag(&pvec,
-			NODE_MAPPING(sbi), &index, PAGECACHE_TAG_DIRTY))) {
+	while (!done && (nr_folios = filemap_get_folios_tag(NODE_MAPPING(sbi),
+				&index, (pgoff_t)-1, PAGECACHE_TAG_DIRTY,
+				&fbatch))) {
 		int i;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct page *page = &fbatch.folios[i]->page;
 			bool submitted = false;
 
 			/* give a priority to WB_SYNC threads */
@@ -2024,7 +2025,7 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 			if (--wbc->nr_to_write == 0)
 				break;
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 
 		if (wbc->nr_to_write == 0) {
-- 
2.36.1
