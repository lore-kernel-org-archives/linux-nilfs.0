From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 21/23] nilfs2: Convert nilfs_copy_dirty_pages()
 to use filemap_get_folios_tag()
Date: Thu,  1 Sep 2022 15:01:36 -0700
Message-ID: <20220901220138.182896-22-vishal.moola@gmail.com>
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
 bh=wOJt0d5525/vdydCfZOLqeQx20ust1GIMaCJJ+sLeoU=; b=cam3/uan9fwGG2Zbp8oIg0hDmZ
 1SxNBx62WMvRNM5RR5vtGbdSjBDVauDIrY/lgHE4WKSUdgLiGgmSWavTMBkT9+2X4dagJYYlsdl4/
 hatlDmutNauzRfGgAg1+cplE9ITjiTjEG36LZxE95uvwxZNcD64AG5eGfhKBsyEJUWrY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=wOJt0d5525/vdydCfZOLqeQx20ust1GIMaCJJ+sLeoU=; b=NNpcKIpJd8BfUhDlcJq5p/fc6Y
 CuvxWL8WY1AWGILuP/SWOnrxqbFsv+qIc54waUNdHUS3AUqK6uErKG7x68F93j4HFR4vCDFkL26yd
 vOlOi0YBipYNvSClW14Ejmy10pKK6GkoeHa8D7HCEGOsCfL6FDw9G/AmiZhXw1Wjvp7c=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
 bh=wOJt0d5525/vdydCfZOLqeQx20ust1GIMaCJJ+sLeoU=;
 b=diBwxyvKEf6JI6u957lZlRjBGUqMPUv/DOTu7USfBuUCPzlXtneLcNkT0wHfsvIjgR
 RtFF5KdI3PUaclSG4E8jhu3HF/vGooJNXm0wgBU68eptXErnpIrgJIK7grK3lg2BeI6L
 gnzmKoFOzWTOhjK7j7BejIXQ7JSWJrnbFx0Oc6zaDOnzxuaDir2i3tvuwfF1UzG2jYEP
 Cytu/wxg4A0FNem7xkUQzwOJicEG0m8Lou+wbr97B040g23ggq7N5kdhn0ywWQ13/Za/
 fq1WOxoWKPbol+s7gwJKowNnVI90ccXLoGBZIPqrz2b0PYJIIzBsCuxtrhYjXdSRoOEL
 ZZig==
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

Convert function to use folios throughout. This is in preparation for
the removal of find_get_pages_range_tag().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/nilfs2/page.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 3267e96c256c..5c96084e829f 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -240,42 +240,43 @@ static void nilfs_copy_page(struct page *dst, struct page *src, int copy_dirty)
 int nilfs_copy_dirty_pages(struct address_space *dmap,
 			   struct address_space *smap)
 {
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	unsigned int i;
 	pgoff_t index = 0;
 	int err = 0;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 repeat:
-	if (!pagevec_lookup_tag(&pvec, smap, &index, PAGECACHE_TAG_DIRTY))
+	if (!filemap_get_folios_tag(smap, &index, (pgoff_t)-1,
+				PAGECACHE_TAG_DIRTY, &fbatch))
 		return 0;
 
-	for (i = 0; i < pagevec_count(&pvec); i++) {
-		struct page *page = pvec.pages[i], *dpage;
+	for (i = 0; i < folio_batch_count(&fbatch); i++) {
+		struct folio *folio = fbatch.folios[i], *dfolio;
 
-		lock_page(page);
-		if (unlikely(!PageDirty(page)))
-			NILFS_PAGE_BUG(page, "inconsistent dirty state");
+		folio_lock(folio);
+		if (unlikely(!folio_test_dirty(folio)))
+			NILFS_PAGE_BUG(&folio->page, "inconsistent dirty state");
 
-		dpage = grab_cache_page(dmap, page->index);
-		if (unlikely(!dpage)) {
+		dfolio = filemap_grab_folio(dmap, folio->index);
+		if (unlikely(!dfolio)) {
 			/* No empty page is added to the page cache */
 			err = -ENOMEM;
-			unlock_page(page);
+			folio_unlock(folio);
 			break;
 		}
-		if (unlikely(!page_has_buffers(page)))
-			NILFS_PAGE_BUG(page,
+		if (unlikely(!folio_buffers(folio)))
+			NILFS_PAGE_BUG(&folio->page,
 				       "found empty page in dat page cache");
 
-		nilfs_copy_page(dpage, page, 1);
-		__set_page_dirty_nobuffers(dpage);
+		nilfs_copy_page(&dfolio->page, &folio->page, 1);
+		filemap_dirty_folio(folio_mapping(dfolio), dfolio);
 
-		unlock_page(dpage);
-		put_page(dpage);
-		unlock_page(page);
+		folio_unlock(dfolio);
+		folio_put(dfolio);
+		folio_unlock(folio);
 	}
-	pagevec_release(&pvec);
+	folio_batch_release(&fbatch);
 	cond_resched();
 
 	if (likely(!err))
-- 
2.36.1
