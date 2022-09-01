From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 07/23] btrfs: Convert extent_write_cache_pages()
 to use filemap_get_folios_tag()
Date: Thu,  1 Sep 2022 15:01:22 -0700
Message-ID: <20220901220138.182896-8-vishal.moola@gmail.com>
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
 bh=H1ZMVMBgfrZYGu2QZ+223evW3CSAsjQgLD9a3FFT7h8=; b=FW7D7EnoKi9fn/SGmhzkE0AujB
 RZc19O/sWF5prytjEHITzTLmGIpzfRVI3FFADEFlc81l+qvkbCrFN2oje7fX0rlD1axKBxDYhEzb4
 biVaS2gbDxK6Uj3PYhEYkhPKC4OftZPAjUlZLyM/D0QVkcoWaKDXcCWMihfeemCKcUZk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=H1ZMVMBgfrZYGu2QZ+223evW3CSAsjQgLD9a3FFT7h8=; b=ZWNhN/wUPEMFTvIGV5WUrDVj9H
 s9s1jMscC2Wu9g/xVyBuoKaZmYzcs44bjE+IuhgKtiB4gdEs0OQnA0vuvxJzHBrwtWGRlOw+7l8Sl
 mhoHk8ou5RwbpvZznLayqPms59wQId32HIJz/mqZniEfO1XBiwH5chyKD8fCFQuT4/Y0=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
 bh=H1ZMVMBgfrZYGu2QZ+223evW3CSAsjQgLD9a3FFT7h8=;
 b=igWgWaj0aHyNZf5XNZM5uDc0n5BV1AEK0E8cDeZNmauvOVLadH3WVQNodqCzZr8D8R
 hzujhG+S4PCrAuPukcXuRC5mwOFIxxwc0GiMx0cdVcwx5Wb6+iBFORlAPVoNjlIQX23W
 bEswqyuy8EmNrId6zlGtKLGA8gtyv55Rw1AH2+FmpfoXovpJpdtYKd501mfmlL+x16b6
 RnroUj9UCaRa413Bl0N2xC2vydY5iSJtBjMDD5AAH5twN0K4mRxdAqlQAPIoPZ5lM8/Y
 gtqAG5Yqwp/Rp7ZQwJrAj53rl2ta1L0rfXCTZ6LkGMVa7YXGDBshaZeshZvIj3BPWRPL
 PsFg==
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

Converted function to use folios throughout. This is in preparation for
the removal of find_get_pages_range_tag(). Now also supports large
folios.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/btrfs/extent_io.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d1fa072bfdd0..80fe313f8461 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4972,8 +4972,8 @@ static int extent_write_cache_pages(struct address_space *mapping,
 	int ret = 0;
 	int done = 0;
 	int nr_to_write_done = 0;
-	struct pagevec pvec;
-	int nr_pages;
+	struct folio_batch fbatch;
+	unsigned int nr_folios;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
@@ -4993,7 +4993,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 	if (!igrab(inode))
 		return 0;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
@@ -5031,14 +5031,14 @@ static int extent_write_cache_pages(struct address_space *mapping,
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && !nr_to_write_done && (index <= end) &&
-			(nr_pages = pagevec_lookup_range_tag(&pvec, mapping,
-						&index, end, tag))) {
+			(nr_folios = filemap_get_folios_tag(mapping, &index,
+							end, tag, &fbatch))) {
 		unsigned i;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct folio *folio = fbatch.folios[i];
 
-			done_index = page->index + 1;
+			done_index = folio->index + folio_nr_pages(folio);
 			/*
 			 * At this point we hold neither the i_pages lock nor
 			 * the page lock: the page may be truncated or
@@ -5046,29 +5046,29 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			 * or even swizzled back from swapper_space to
 			 * tmpfs file mapping
 			 */
-			if (!trylock_page(page)) {
+			if (!folio_trylock(folio)) {
 				submit_write_bio(epd, 0);
-				lock_page(page);
+				folio_lock(folio);
 			}
 
-			if (unlikely(page->mapping != mapping)) {
-				unlock_page(page);
+			if (unlikely(folio->mapping != mapping)) {
+				folio_unlock(folio);
 				continue;
 			}
 
 			if (wbc->sync_mode != WB_SYNC_NONE) {
-				if (PageWriteback(page))
+				if (folio_test_writeback(folio))
 					submit_write_bio(epd, 0);
-				wait_on_page_writeback(page);
+				folio_wait_writeback(folio);
 			}
 
-			if (PageWriteback(page) ||
-			    !clear_page_dirty_for_io(page)) {
-				unlock_page(page);
+			if (folio_test_writeback(folio) ||
+			    !folio_clear_dirty_for_io(folio)) {
+				folio_unlock(folio);
 				continue;
 			}
 
-			ret = __extent_writepage(page, wbc, epd);
+			ret = __extent_writepage(&folio->page, wbc, epd);
 			if (ret < 0) {
 				done = 1;
 				break;
@@ -5081,7 +5081,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			 */
 			nr_to_write_done = wbc->nr_to_write <= 0;
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 	if (!scanned && !done) {
-- 
2.36.1
