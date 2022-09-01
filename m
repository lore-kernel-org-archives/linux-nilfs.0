From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 16/23] f2fs: Convert f2fs_sync_meta_pages() to
 use filemap_get_folios_tag()
Date: Thu,  1 Sep 2022 15:01:31 -0700
Message-ID: <20220901220138.182896-17-vishal.moola@gmail.com>
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
 bh=vLd5VxDvs/Hufc5GkPRPWmylC7gs4hvMBc2dqzKoD6A=; b=ZbaMs52KfKX6wQwid+AbX2sg3U
 Z+ZHDXKLFfzmpYYxkW7ZsDT+DhjHXd+QdwHLcC3kCHkWgpMS1o/1VDkTcbLxrVXF/iU33AqdxxoqI
 jupk5LNf6u8P/mo2tBGHp/WxTNXCIgZtNNqR7u0SLy01Hh4uyZxAnTCYf8g19NHPxFT4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=vLd5VxDvs/Hufc5GkPRPWmylC7gs4hvMBc2dqzKoD6A=; b=cgpWKBaKBaUKBLRxr3Y2k8jIDj
 SsGAKH0TZ510tMoHggSZbPyhJW8HdL7SNQcdVhIwtbbtLU6HrkcwBPZDHVgcal5Q5j2uTd6RdH6rb
 tazwVFj6q2Oj1wvm5uj+0VG//bkDCu9d3wT6sFkPO+HIRHlPdfTntC25JrAwN0uGfCU8=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
 bh=vLd5VxDvs/Hufc5GkPRPWmylC7gs4hvMBc2dqzKoD6A=;
 b=p+JLiL+0TTGlTunPHVFUf8hhPxVUM5krHr3xZ/nRtJsCNup/c9/1/FoZkcqQlbTuqR
 7yIQkEI22HWTHAw3e/uBkXqiAtCxV72rvCMVQDK2rhTKLvByKuPPHpK3PCQQNtMmUlsZ
 x6ryoAy3iv+hjbY7odiJzZWYPcNHrRagmhRM0AsEu+7Rf7kbkLslvL/Ovm8ovRJNa83a
 fCdcJzV6GQj/13aqFF2TaCcDLkESTf7VN0HdaG6gurPXivZxibbBjD2PdNa+QzjUnHs8
 ZSaXOBn0t7311FPL7y8pLBASVORDuHdIUh5dZBe944rGxmavfQqKXZbN9HU3xa8g1J3R
 pIuw==
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
of find_get_pages_range_tag().

Initially the function was checking if the previous page index is truly the
previous page i.e. 1 index behind the current page. To convert to folios and
maintain this check we need to make the check
folio->index != prev + folio_nr_pages(previous folio) since we don't know
how many pages are in a folio.

At index i == 0 the check is guaranteed to succeed, so to workaround indexing
bounds we can simply ignore the check for that specific index. This makes the
initial assignment of prev trivial, so I removed that as well.

Also modified a comment in commit_checkpoint for consistency.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/f2fs/checkpoint.c | 49 +++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 8259e0fa97e1..9f6694f7d723 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -377,59 +377,62 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 {
 	struct address_space *mapping = META_MAPPING(sbi);
 	pgoff_t index = 0, prev = ULONG_MAX;
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	long nwritten = 0;
-	int nr_pages;
+	int nr_folios;
 	struct writeback_control wbc = {
 		.for_reclaim = 0,
 	};
 	struct blk_plug plug;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
 	blk_start_plug(&plug);
 
-	while ((nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-				PAGECACHE_TAG_DIRTY))) {
+	while ((nr_folios = filemap_get_folios_tag(mapping, &index,
+					(pgoff_t)-1,
+					PAGECACHE_TAG_DIRTY, &fbatch))) {
 		int i;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct folio *folio = fbatch.folios[i];
 
-			if (prev == ULONG_MAX)
-				prev = page->index - 1;
-			if (nr_to_write != LONG_MAX && page->index != prev + 1) {
-				pagevec_release(&pvec);
+			if (nr_to_write != LONG_MAX && i != 0 &&
+					folio->index != prev +
+					folio_nr_pages(fbatch.folios[i-1])) {
+				folio_batch_release(&fbatch);
 				goto stop;
 			}
 
-			lock_page(page);
+			folio_lock(folio);
 
-			if (unlikely(page->mapping != mapping)) {
+			if (unlikely(folio->mapping != mapping)) {
 continue_unlock:
-				unlock_page(page);
+				folio_unlock(folio);
 				continue;
 			}
-			if (!PageDirty(page)) {
+			if (!folio_test_dirty(folio)) {
 				/* someone wrote it for us */
 				goto continue_unlock;
 			}
 
-			f2fs_wait_on_page_writeback(page, META, true, true);
+			f2fs_wait_on_page_writeback(&folio->page, META,
+					true, true);
 
-			if (!clear_page_dirty_for_io(page))
+			if (!folio_clear_dirty_for_io(folio))
 				goto continue_unlock;
 
-			if (__f2fs_write_meta_page(page, &wbc, io_type)) {
-				unlock_page(page);
+			if (__f2fs_write_meta_page(&folio->page, &wbc,
+						io_type)) {
+				folio_unlock(folio);
 				break;
 			}
-			nwritten++;
-			prev = page->index;
+			nwritten += folio_nr_pages(folio);
+			prev = folio->index;
 			if (unlikely(nwritten >= nr_to_write))
 				break;
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 stop:
@@ -1381,7 +1384,7 @@ static void commit_checkpoint(struct f2fs_sb_info *sbi,
 	};
 
 	/*
-	 * pagevec_lookup_tag and lock_page again will take
+	 * filemap_get_folios_tag and lock_page again will take
 	 * some extra time. Therefore, f2fs_update_meta_pages and
 	 * f2fs_sync_meta_pages are combined in this function.
 	 */
-- 
2.36.1
