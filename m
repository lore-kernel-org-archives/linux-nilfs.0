From: "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/7] filemap: Remove find_get_pages_contig()
Date: Mon, 15 Aug 2022 11:54:52 -0700
Message-ID: <20220815185452.37447-8-vishal.moola@gmail.com>
References: <20220815185452.37447-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=1TWw7ByCFm6NhkDCyy6ya2eZRdPaW0G32WpVpASX5vg=;
        b=iFemGX/6S2CEM0vc5Q7ZhA97VMtcnCohjPo5wTK/HWHqxK8N8QD+bkVVv0eRbEzJzH
         HqNnewi3fYbCRLFexc2OOX6LZPISwiwwClyISPUI5KMeUWOZeNZVhgrVNoTh/Ef21AvD
         inPVaZs72ziOBxRoTzzTlm+NfVEF+4Feqy2/CddIRYZtl8QSJ13XwO818UEDaiCRUVwz
         nb4QhvVObgxonTmLBTxLoJJ/T2W7q5OkqOs2FzS77LEHAbNCL5hJhBuhcB2oBU5Jz7is
         ge8YPVEk2wRZ+hVtTUqI862Ct1zgWNCA3b3a8uO8nl7FIulVV3gjzC6wH7UdYYgrFJGP
         GdQA==
In-Reply-To: <20220815185452.37447-1-vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

All callers of find_get_pages_contig() have been removed, so it is no
longer needed.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/pagemap.h |  2 --
 mm/filemap.c            | 60 -----------------------------------------
 2 files changed, 62 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 8689c32d628b..09de43e36a64 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -720,8 +720,6 @@ unsigned filemap_get_folios(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch);
 unsigned filemap_get_folios_contig(struct address_space *mapping,
 		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch);
-unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
-			       unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_range_tag(struct address_space *mapping, pgoff_t *index,
 			pgoff_t end, xa_mark_t tag, unsigned int nr_pages,
 			struct page **pages);
diff --git a/mm/filemap.c b/mm/filemap.c
index 3a497e178fde..100f36c9247c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2267,66 +2267,6 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 }
 EXPORT_SYMBOL(filemap_get_folios_contig);
 
-/**
- * find_get_pages_contig - gang contiguous pagecache lookup
- * @mapping:	The address_space to search
- * @index:	The starting page index
- * @nr_pages:	The maximum number of pages
- * @pages:	Where the resulting pages are placed
- *
- * find_get_pages_contig() works exactly like find_get_pages_range(),
- * except that the returned number of pages are guaranteed to be
- * contiguous.
- *
- * Return: the number of pages which were found.
- */
-unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t index,
-			       unsigned int nr_pages, struct page **pages)
-{
-	XA_STATE(xas, &mapping->i_pages, index);
-	struct folio *folio;
-	unsigned int ret = 0;
-
-	if (unlikely(!nr_pages))
-		return 0;
-
-	rcu_read_lock();
-	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
-		if (xas_retry(&xas, folio))
-			continue;
-		/*
-		 * If the entry has been swapped out, we can stop looking.
-		 * No current caller is looking for DAX entries.
-		 */
-		if (xa_is_value(folio))
-			break;
-
-		if (!folio_try_get_rcu(folio))
-			goto retry;
-
-		if (unlikely(folio != xas_reload(&xas)))
-			goto put_page;
-
-again:
-		pages[ret] = folio_file_page(folio, xas.xa_index);
-		if (++ret == nr_pages)
-			break;
-		if (folio_more_pages(folio, xas.xa_index, ULONG_MAX)) {
-			xas.xa_index++;
-			folio_ref_inc(folio);
-			goto again;
-		}
-		continue;
-put_page:
-		folio_put(folio);
-retry:
-		xas_reset(&xas);
-	}
-	rcu_read_unlock();
-	return ret;
-}
-EXPORT_SYMBOL(find_get_pages_contig);
-
 /**
  * find_get_pages_range_tag - Find and return head pages matching @tag.
  * @mapping:	the address_space to search
-- 
2.36.1

