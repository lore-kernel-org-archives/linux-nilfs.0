From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v5 13/23] f2fs: Convert f2fs_sync_node_pages() to
 use filemap_get_folios_tag()
Date: Wed,  4 Jan 2023 13:14:38 -0800
Message-ID: <20230104211448.4804-14-vishal.moola@gmail.com>
References: <20230104211448.4804-1-vishal.moola@gmail.com>
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
 bh=x25JE3Kc6tv/CRPnK8Jr5HLS2sX0SCmIF/DAVcH2FqE=; b=Xp2AQfr7FaHABeZwDuBt8j9p8m
 pMouKFraGEgjYUGvTtQIlYjbrmFHAmZB8nq5c/t2BvDWJP9zioEm0AEhK6P0ZurwzdrdVtP4w2uPK
 XSRjPyZ60sE+Dn4afKlfSGSgzKEoMHN5jB6VbQ/GPm3PXgfEfGaeAKmSslX634sVHeCU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=x25JE3Kc6tv/CRPnK8Jr5HLS2sX0SCmIF/DAVcH2FqE=; b=cUXv470W9HK6tjG7mp64e2z3YL
 LXSod8FcGPYEy4TYp8PUmxcaU+8cOAD1UBLfGwHNV8tUbo7y8pA5gQmae3Ht6H3Z4sjxhygWaslu/
 Z9ZuXhdSonqeU1R4S3ktjsT42CAS/ADXcltRve67QmoswSnsRyt0d2Prt+mk0CM3hsic=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=x25JE3Kc6tv/CRPnK8Jr5HLS2sX0SCmIF/DAVcH2FqE=;
 b=GGaN80QXsh4J1YXL+CzIWsFbPtYnvqnUAuR7BlWM5cg7Fb96IUWkf9YKtYSUX4xJiv
 fdrgdThz8UL3P4MZ+eHMu/4K966siuQI6iAdHR2MVQjMjV6MN1GRnO6doH2uk5OhpsZO
 LY78o+yIQS4ow8RQaNkPfGCKMNJtGI3xD9tlc5jEE555TQyh8J94/Gr9HVriMtas67IH
 FB8OUwFz1Oy3rJJOCQeEa/ZHyPHJEdTE5f3SEzIDvxTL2bZ5bnEYjE/0AQom1yTmJR+y
 hcZ12FlAB2hAIMkIDGdKE9vHxFNU1VPWGBB3MfQllfkg7rnUYN+U0mQERs2+5ZkIr7zC
 Wx+Q==
In-Reply-To: <20230104211448.4804-1-vishal.moola@gmail.com>
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

Convert function to use a folio_batch instead of pagevec. This is in
preparation for the removal of find_get_pages_range_tag().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Chao Yu <chao@kernel.org>
---
 fs/f2fs/node.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 1c5dc7a3207e..51e9f286f53a 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1938,23 +1938,24 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
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
@@ -2029,7 +2030,7 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 			if (--wbc->nr_to_write == 0)
 				break;
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 
 		if (wbc->nr_to_write == 0) {
-- 
2.38.1
