From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v2 12/23] f2fs: Convert f2fs_flush_inline_data()
 to use filemap_get_folios_tag()
Date: Mon, 12 Sep 2022 11:22:13 -0700
Message-ID: <20220912182224.514561-13-vishal.moola@gmail.com>
References: <20220912182224.514561-1-vishal.moola@gmail.com>
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
 bh=VVDEDDCx2d1u9kTxOO3+HYn0Qu0jVDr1kjF69+koZKM=; b=idc5u7byAs+F9UXH76ZoGFTX20
 1QmRXq1/op4THFFmfYIAWGaTUuHyYxO7YKcdmeQGvRAj+2p21a7EXgSVIc07c98Fb4DdjShubT2Ew
 l3PSIttuJhdIRgN+h5eXPHNkg3DC3I8XQm4cQgEWkM81ppwb+ZQg24zxcqL7Sd8IERRc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=VVDEDDCx2d1u9kTxOO3+HYn0Qu0jVDr1kjF69+koZKM=; b=Wq+v5kvnt9ma/GVjeB8sJEe4gm
 QrAULO4I91HkV3t7UXui2YLbpVB7MIwhJnHGwp5shXX/DUIQHA81KMqXLlEe7yj5chLvaZYsYn3Io
 yKMOC2YQ9/iZGQ6UMxQkh6vRNbeeJ+5zlVANlmBLlqOIfGbyoQi4sj652rqgHGLZ9E18=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
 bh=VVDEDDCx2d1u9kTxOO3+HYn0Qu0jVDr1kjF69+koZKM=;
 b=mWsacKaljX8MUV8CQf+x9uPNXb4nwg1rqOzW988jKdDxldx2xBwpPizg4HUE3CpOyS
 CZXKfwZl7d7TRsEdibF4COy3CHTtCs9fDbuwKy/fifVJ1Wgwc7dTVk3A2qlzYF1+YqrM
 8u30URko72IeT67j4F37ylnRUZD/Skd/5ByQpr+0jX44vN/bWC2IRka7MCfENYbM9JYD
 72jwWqsS26F/r5BLgNzt2vuVnEfeh6py/P+5GlgXdd1rz/SFRFcCTDhHk5S6n46zAnHH
 K7NUMpASIWQTy8dJGAcYZr2Qd5aoXAfuyQB26U7wlP0wc30bz0T/it+tBSb7KpRupXtm
 b44g==
In-Reply-To: <20220912182224.514561-1-vishal.moola@gmail.com>
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
of find_get_pages_tag(). Does NOT support large folios.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/f2fs/node.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index a3c5eedfcf64..c2b54c58392a 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1885,17 +1885,18 @@ static bool flush_dirty_inode(struct page *page)
 void f2fs_flush_inline_data(struct f2fs_sb_info *sbi)
 {
 	pgoff_t index = 0;
-	struct pagevec pvec;
-	int nr_pages;
+	struct folio_batch fbatch;
+	int nr_folios;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
-	while ((nr_pages = pagevec_lookup_tag(&pvec,
-			NODE_MAPPING(sbi), &index, PAGECACHE_TAG_DIRTY))) {
+	while ((nr_folios = filemap_get_folios_tag(NODE_MAPPING(sbi), &index,
+					(pgoff_t)-1, PAGECACHE_TAG_DIRTY,
+					&fbatch))) {
 		int i;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct page *page = &fbatch.folios[i]->page;
 
 			if (!IS_DNODE(page))
 				continue;
@@ -1922,7 +1923,7 @@ void f2fs_flush_inline_data(struct f2fs_sb_info *sbi)
 			}
 			unlock_page(page);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 }
-- 
2.36.1
