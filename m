From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 03/10] ext4: Convert mpage_release_unused_pages() to use filemap_get_folios()
Date: Sun,  5 Jun 2022 20:38:47 +0100
Message-ID: <20220605193854.2371230-4-willy@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7zHJFf7s+ZSx87nHg6Bs72jjNt/zTHbg4PZc0KhFNBI=; b=EYXV63i9/CEOzD0nHMe1OQHYDc
        mVCuEz0iq05DzWOTfwUUXon7lLclyJcGJZDFVFf36KaefdWNV0pHzAWE/juTBOh3LmOa6/GHAbwsA
        j9SKPw7wOEy++DynzZkxdw6cKJT5aOgxtQMtWaAQNIKZNtcW6JUvraw6AebVxfjYl0uWLN4Tnkrf1
        g5r1qFvxh5lUydZ/EqFXJtmm4X6GU4Pvr6z+zZzlpoy3rKdSu3dVWHKmxHNTzyLs4u7zgx7YRImNZ
        s12tQFfwrO2lznSTczeoD//K1wj12QguV4NYS7DRw7Y1XFPPUFJTnVvqq+s0OPozePCioZdM8Nwv2
        JJEs8DoA==;
In-Reply-To: <20220605193854.2371230-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

If the folio is large, it may overlap the beginning or end of the
unused range.  If it does, we need to avoid invalidating it.

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 fs/ext4/inode.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3dce7d058985..32a7f5e024d6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1554,9 +1554,9 @@ struct mpage_da_data {
 static void mpage_release_unused_pages(struct mpage_da_data *mpd,
 				       bool invalidate)
 {
-	int nr_pages, i;
+	unsigned nr, i;
 	pgoff_t index, end;
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	struct inode *inode = mpd->inode;
 	struct address_space *mapping = inode->i_mapping;
 
@@ -1574,15 +1574,18 @@ static void mpage_release_unused_pages(struct mpage_da_data *mpd,
 		ext4_es_remove_extent(inode, start, last - start + 1);
 	}
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	while (index <= end) {
-		nr_pages = pagevec_lookup_range(&pvec, mapping, &index, end);
-		if (nr_pages == 0)
+		nr = filemap_get_folios(mapping, &index, end, &fbatch);
+		if (nr == 0)
 			break;
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
-			struct folio *folio = page_folio(page);
+		for (i = 0; i < nr; i++) {
+			struct folio *folio = fbatch.folios[i];
 
+			if (folio->index < mpd->first_page)
+				continue;
+			if (folio->index + folio_nr_pages(folio) - 1 > end)
+				continue;
 			BUG_ON(!folio_test_locked(folio));
 			BUG_ON(folio_test_writeback(folio));
 			if (invalidate) {
@@ -1594,7 +1597,7 @@ static void mpage_release_unused_pages(struct mpage_da_data *mpd,
 			}
 			folio_unlock(folio);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 	}
 }
 
-- 
2.35.1

