From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v5 16/23] f2fs: Convert f2fs_sync_meta_pages() to
 use filemap_get_folios_tag()
Date: Wed,  4 Jan 2023 13:14:41 -0800
Message-ID: <20230104211448.4804-17-vishal.moola@gmail.com>
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
 bh=95X87nsP2uu1g0tSzKPuV0qHzijMRAuzyWHPCNhVLfk=; b=C3dZuyi0mPnFhQ30rqbK1k53hl
 HIMacHVY5tzvT803ED1RXAFV1VOkdvkhJIf3mnyD/edNku/x0vf+J5aFj4vYnkm/jU5+5eONhm/BZ
 qf9Jgpq82ntkgTg+TC4oh6OtuQiiUGlC5otYNz3134y4oclmJZyS9Dk9VVHwgMXxb5Tg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=95X87nsP2uu1g0tSzKPuV0qHzijMRAuzyWHPCNhVLfk=; b=m7hho+70GHkJaPuAq/xooV9YTH
 4lnTmqTNDdC03V3vwaKTUQboyqRsWUgKZ16SJbCV9CbyQ02PGe8AE/9Vx2sjoGPlXQVYhDKL9wiZX
 EvHQKIbQB09NCo86BQPRQPqBQWEwe+RqKQjYTSL3+3HFPVc2THcWByzW8C6CB2YopUCk=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=95X87nsP2uu1g0tSzKPuV0qHzijMRAuzyWHPCNhVLfk=;
 b=JCPoNtFnRO14zsnrzATg9kL0JDP6tVcnKx3JUX6/3ncoBKAJOrdzAnqcJfisGtVG+1
 dpzq+dUPXHOKZJgfHr44JpBFeOtfbWmIahDTecFP0YCOZ21+b2HqR4qxtZ3cxCJVSUO4
 8VpfGyEp5nVdeztFirVOET5gBHXuwsM9pBvFeES2ux3EMo1g2WrhlgBtDP1DDvcKoyo9
 3cT+mvBMCWl/wiVX2MJDZxNZQbsgenI1tEgLnjzakrMYONEHe9y2YdlGpG40iclkX2Tz
 iSga8vy8hS5O8VIUTkiKp/uJ+L9iOcKcIjs79iMUkx4gTW6zOE9upSWw0xbISSOb+PNN
 TSvg==
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

Convert function to use folios throughout. This is in preparation for the
removal of find_get_pages_range_tag(). This change removes 5 calls to
compound_head().

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
Acked-by: Chao Yu <chao@kernel.org>
---
 fs/f2fs/checkpoint.c | 49 +++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 56f7d0d6a8b2..5a5515d83a1b 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -395,59 +395,62 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
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
@@ -1403,7 +1406,7 @@ static void commit_checkpoint(struct f2fs_sb_info *sbi,
 	};
 
 	/*
-	 * pagevec_lookup_tag and lock_page again will take
+	 * filemap_get_folios_tag and lock_page again will take
 	 * some extra time. Therefore, f2fs_update_meta_pages and
 	 * f2fs_sync_meta_pages are combined in this function.
 	 */
-- 
2.38.1
