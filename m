From: "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 5/7] nilfs2: Convert nilfs_find_uncommited_extent() to use filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 17:40:21 -0700
Message-ID: <20220824004023.77310-6-vishal.moola@gmail.com>
References: <20220824004023.77310-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=KyMLiEXuqe6oMgJlOPUNT684cH6jPO08N05OJyEa5MI=;
        b=JXzLL8UAMMTyqxQPGNwR9rod7kTLexta+9ZdxunA7mrxp0SsVejkQaJC5Bmil85eaD
         jH1a6u8Qw8HCxqsOCfUc6dXwabaWbL1o3EKqezvzeM4nqchYD0Zj+Nmw3zXtu6Ivc5f1
         EmVyKyYwbbK3AEFq5jQHeUtGYTArf4JfFOUDCmZx6nsXZ5aoClbLow/COO51EDjyteN0
         Z5h2uy3b6bEdUihA/HT+I9Z7cRXmvPNXWmft999iQHIXvE2GFKctDA5u/QCN3Gs/WtGS
         mygT/DoUY6gHw3/Bu1+ryrseK5gWZjTBlO4ZKmPq4oIHx6urSYB5Io7e8qe2QSPRV7El
         NI5Q==
In-Reply-To: <20220824004023.77310-1-vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Converted function to use folios throughout. This is in preparation for
the removal of find_get_pages_contig(). Now also supports large folios.

Also cleaned up an unnecessary if statement - pvec.pages[0]->index > index
will always evaluate to false, and filemap_get_folios_contig() returns 0 if
there is no folio found at index.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/page.c | 45 ++++++++++++++++++---------------------------
 1 file changed, 18 insertions(+), 27 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 3267e96c256c..39b7eea2642a 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -480,41 +480,36 @@ unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 					    sector_t start_blk,
 					    sector_t *blkoff)
 {
-	unsigned int i;
+	unsigned int i, nr_folios;
 	pgoff_t index;
-	unsigned int nblocks_in_page;
 	unsigned long length = 0;
-	sector_t b;
-	struct pagevec pvec;
-	struct page *page;
+	struct folio_batch fbatch;
+	struct folio *folio;
 
 	if (inode->i_mapping->nrpages == 0)
 		return 0;
 
 	index = start_blk >> (PAGE_SHIFT - inode->i_blkbits);
-	nblocks_in_page = 1U << (PAGE_SHIFT - inode->i_blkbits);
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
 repeat:
-	pvec.nr = find_get_pages_contig(inode->i_mapping, index, PAGEVEC_SIZE,
-					pvec.pages);
-	if (pvec.nr == 0)
+	nr_folios = filemap_get_folios_contig(inode->i_mapping, &index, ULONG_MAX,
+			&fbatch);
+	if (nr_folios == 0)
 		return length;
 
-	if (length > 0 && pvec.pages[0]->index > index)
-		goto out;
-
-	b = pvec.pages[0]->index << (PAGE_SHIFT - inode->i_blkbits);
 	i = 0;
 	do {
-		page = pvec.pages[i];
+		folio = fbatch.folios[i];
 
-		lock_page(page);
-		if (page_has_buffers(page)) {
+		folio_lock(folio);
+		if (folio_buffers(folio)) {
 			struct buffer_head *bh, *head;
+			sector_t b;
 
-			bh = head = page_buffers(page);
+			b = folio->index << (PAGE_SHIFT - inode->i_blkbits);
+			bh = head = folio_buffers(folio);
 			do {
 				if (b < start_blk)
 					continue;
@@ -529,21 +524,17 @@ unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 		} else {
 			if (length > 0)
 				goto out_locked;
-
-			b += nblocks_in_page;
 		}
-		unlock_page(page);
+		folio_unlock(folio);
 
-	} while (++i < pagevec_count(&pvec));
+	} while (++i < nr_folios);
 
-	index = page->index + 1;
-	pagevec_release(&pvec);
+	folio_batch_release(&fbatch);
 	cond_resched();
 	goto repeat;
 
 out_locked:
-	unlock_page(page);
-out:
-	pagevec_release(&pvec);
+	folio_unlock(folio);
+	folio_batch_release(&fbatch);
 	return length;
 }
-- 
2.36.1

