From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 05/10] f2fs: Convert
 f2fs_invalidate_compress_pages() to use filemap_get_folios()
Date: Sun,  5 Jun 2022 20:38:49 +0100
Message-ID: <20220605193854.2371230-6-willy@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
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
 bh=4+VTXobun92H06BwkM9sboSswxKOXWma+MeYkEepBgA=; b=bpRTQRgt1bj+yWok8AnwA/my+8
 oThKV6RN+O+M/y8vveTJR7d0e2/RYBxaZ8l8KD3yRe0SUfjyYQxxTQ/0MJWQR3Cw/i9Mccha5TiGC
 wu6VJEkJRhBrBLjQyS6jIlUwWFA77nb6y9bvkGzr3yCfGtHyUqM1LOW30OgJP48F2Q6w=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=4+VTXobun92H06BwkM9sboSswxKOXWma+MeYkEepBgA=; b=SjX9l6aM9NH6n+smcCa9JYEZf7
 ojR0CGoMkdkOz2SrhhOuFMecgH2a3LrXrRxqLy5pVwFaR1n2Cf//sS8C+cd9hiqETPvR0vDE0EBJ3
 PPctQQ5BinOIwO1/cdkMgXUuTqu9ijnDAyt/5xg2+HiLEKs5Z1FqgvI0whRAkSkWHp4c=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=4+VTXobun92H06BwkM9sboSswxKOXWma+MeYkEepBgA=; b=RQCVcbFFYG/IwPkZ92IOtlvbMm
 az7RIzZuEXd7sNL2U7G8LPCRngD4SynAZcKmm6Z95io0HrbGL0vnB7fjGo7Cxu4ZBw1ODBrU0UG2e
 HxKcshRvctwxq6I6s6/MK32FsYRAC2G0u/Hip2HcdGDzdI618anISANI/MA2khqP9eLitiytzdMDB
 ct6KPLFs4aDjPFKc8Pkgohr+9RyESHl2CJp7vIumKABXwMvMmL913gy1dYEy+Y+5rn3L6A6SydWN3
 3u72ARdSAix5xot7Gj5q+zC981acWBZoknB7PiY9jRjVbOJiq7giOgLEaPV78mOWST9iLtfFjKdrU
 TBXjCXKw==;
In-Reply-To: <20220605193854.2371230-1-willy@infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-ext4@vger.kernel.org

Convert this function to use folios throughout.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/f2fs/compress.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 24824cd96f36..009e6c519e98 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1832,45 +1832,40 @@ bool f2fs_load_compressed_page(struct f2fs_sb_info *sbi, struct page *page,
 void f2fs_invalidate_compress_pages(struct f2fs_sb_info *sbi, nid_t ino)
 {
 	struct address_space *mapping = sbi->compress_inode->i_mapping;
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	pgoff_t index = 0;
 	pgoff_t end = MAX_BLKADDR(sbi);
 
 	if (!mapping->nrpages)
 		return;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
 	do {
-		unsigned int nr_pages;
-		int i;
+		unsigned int nr, i;
 
-		nr_pages = pagevec_lookup_range(&pvec, mapping,
-						&index, end - 1);
-		if (!nr_pages)
+		nr = filemap_get_folios(mapping, &index, end - 1, &fbatch);
+		if (!nr)
 			break;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
-
-			if (page->index > end)
-				break;
+		for (i = 0; i < nr; i++) {
+			struct folio *folio = fbatch.folios[i];
 
-			lock_page(page);
-			if (page->mapping != mapping) {
-				unlock_page(page);
+			folio_lock(folio);
+			if (folio->mapping != mapping) {
+				folio_unlock(folio);
 				continue;
 			}
 
-			if (ino != get_page_private_data(page)) {
-				unlock_page(page);
+			if (ino != get_page_private_data(&folio->page)) {
+				folio_unlock(folio);
 				continue;
 			}
 
-			generic_error_remove_page(mapping, page);
-			unlock_page(page);
+			generic_error_remove_page(mapping, &folio->page);
+			folio_unlock(folio);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	} while (index < end);
 }
-- 
2.35.1
