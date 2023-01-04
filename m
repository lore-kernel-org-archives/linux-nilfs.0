From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v5 10/23] ext4: Convert
 mpage_prepare_extent_to_map() to use filemap_get_folios_tag()
Date: Wed,  4 Jan 2023 13:14:35 -0800
Message-ID: <20230104211448.4804-11-vishal.moola@gmail.com>
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
 bh=bHssniIq+RlTj6I0G4i7GbLR9EaGoRL5pu7+dnl0w2w=; b=EI7xWos+vGJy1tLShgLep71XoD
 HQB73cHoCAgPZsM+/pz8+/R05FqJ8lJ5stJZpnSmrtXxljFePdAFND9QuOHXzHVFGCrH1srvgamHC
 CVsENmfLbxaymmVnjWw0fl3PcHhPn6z565XDgRthatVGuya60TrvpJqZaDSDdH82bUs4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=bHssniIq+RlTj6I0G4i7GbLR9EaGoRL5pu7+dnl0w2w=; b=T9FCLgYb6fMdqZi5Fv4IqGABma
 F8uePNEWu/D46b2FARGJihwMrp8R4fqBLqgLMyVMGgl6w5EYRGW6My8UwzqONmSTCMCeUwYkeQczF
 T0nPyyM4TYnoSXkhM205iXxJmKI5rKwIAIswHURvewj1/HMFgXuYz87I1v1/AbURaWTY=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=bHssniIq+RlTj6I0G4i7GbLR9EaGoRL5pu7+dnl0w2w=;
 b=O/D+NyPTy4M1sTh+3k/lC1rj/VKJWtCGwMlhTfn6qpBhtlxCb9k3sWDk9Z0oOhWhza
 3YwunlQmpmQxHIwc3slP5cWFOfArgatFhNuDOerJW0qUBaI5Zgn5t2tO2YQmHBKWt0/g
 MFSh/uQIxzlLLmgNa+OoXc3BzfvnfBPdtpNgXKui16mDPVeraZQtRKVUTS73rT71TPkz
 aIA4qX4NfhLb32N2QF9lXy9drDX9/rkV28NsYpAoVy0G5yfIgIIv+sWh1wOSNzvEDIG6
 wJ4oTDHW5KSfgFq7up1/6mIHSjyF7qj/i6841phIxUGWM6AsJ76lWkCXX+vMLrxxAo9V
 fPYQ==
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

Converted the function to use folios throughout. This is in preparation
for the removal of find_get_pages_range_tag(). Now supports large
folios. This change removes 11 calls to compound_head().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/ext4/inode.c | 65 ++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9d9f414f99fe..fb6cd994e59a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2595,8 +2595,8 @@ static bool ext4_page_nomap_can_writeout(struct page *page)
 static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 {
 	struct address_space *mapping = mpd->inode->i_mapping;
-	struct pagevec pvec;
-	unsigned int nr_pages;
+	struct folio_batch fbatch;
+	unsigned int nr_folios;
 	long left = mpd->wbc->nr_to_write;
 	pgoff_t index = mpd->first_page;
 	pgoff_t end = mpd->last_page;
@@ -2610,18 +2610,17 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
-
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	mpd->map.m_len = 0;
 	mpd->next_page = index;
 	while (index <= end) {
-		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
-				tag);
-		if (nr_pages == 0)
+		nr_folios = filemap_get_folios_tag(mapping, &index, end,
+				tag, &fbatch);
+		if (nr_folios == 0)
 			break;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct folio *folio = fbatch.folios[i];
 
 			/*
 			 * Accumulated enough dirty pages? This doesn't apply
@@ -2635,10 +2634,10 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 				goto out;
 
 			/* If we can't merge this page, we are done. */
-			if (mpd->map.m_len > 0 && mpd->next_page != page->index)
+			if (mpd->map.m_len > 0 && mpd->next_page != folio->index)
 				goto out;
 
-			lock_page(page);
+			folio_lock(folio);
 			/*
 			 * If the page is no longer dirty, or its mapping no
 			 * longer corresponds to inode we are writing (which
@@ -2646,16 +2645,16 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			 * page is already under writeback and we are not doing
 			 * a data integrity writeback, skip the page
 			 */
-			if (!PageDirty(page) ||
-			    (PageWriteback(page) &&
+			if (!folio_test_dirty(folio) ||
+			    (folio_test_writeback(folio) &&
 			     (mpd->wbc->sync_mode == WB_SYNC_NONE)) ||
-			    unlikely(page->mapping != mapping)) {
-				unlock_page(page);
+			    unlikely(folio->mapping != mapping)) {
+				folio_unlock(folio);
 				continue;
 			}
 
-			wait_on_page_writeback(page);
-			BUG_ON(PageWriteback(page));
+			folio_wait_writeback(folio);
+			BUG_ON(folio_test_writeback(folio));
 
 			/*
 			 * Should never happen but for buggy code in
@@ -2666,49 +2665,49 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			 *
 			 * [1] https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz
 			 */
-			if (!page_has_buffers(page)) {
-				ext4_warning_inode(mpd->inode, "page %lu does not have buffers attached", page->index);
-				ClearPageDirty(page);
-				unlock_page(page);
+			if (!folio_buffers(folio)) {
+				ext4_warning_inode(mpd->inode, "page %lu does not have buffers attached", folio->index);
+				folio_clear_dirty(folio);
+				folio_unlock(folio);
 				continue;
 			}
 
 			if (mpd->map.m_len == 0)
-				mpd->first_page = page->index;
-			mpd->next_page = page->index + 1;
+				mpd->first_page = folio->index;
+			mpd->next_page = folio->index + folio_nr_pages(folio);
 			/*
 			 * Writeout for transaction commit where we cannot
 			 * modify metadata is simple. Just submit the page.
 			 */
 			if (!mpd->can_map) {
-				if (ext4_page_nomap_can_writeout(page)) {
-					err = mpage_submit_page(mpd, page);
+				if (ext4_page_nomap_can_writeout(&folio->page)) {
+					err = mpage_submit_page(mpd, &folio->page);
 					if (err < 0)
 						goto out;
 				} else {
-					unlock_page(page);
-					mpd->first_page++;
+					folio_unlock(folio);
+					mpd->first_page += folio_nr_pages(folio);
 				}
 			} else {
 				/* Add all dirty buffers to mpd */
-				lblk = ((ext4_lblk_t)page->index) <<
+				lblk = ((ext4_lblk_t)folio->index) <<
 					(PAGE_SHIFT - blkbits);
-				head = page_buffers(page);
+				head = folio_buffers(folio);
 				err = mpage_process_page_bufs(mpd, head, head,
-							      lblk);
+						lblk);
 				if (err <= 0)
 					goto out;
 				err = 0;
 			}
-			left--;
+			left -= folio_nr_pages(folio);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 	mpd->scanned_until_end = 1;
 	return 0;
 out:
-	pagevec_release(&pvec);
+	folio_batch_release(&fbatch);
 	return err;
 }
 
-- 
2.38.1
