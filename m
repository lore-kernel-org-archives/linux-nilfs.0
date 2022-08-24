From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v3 1/7] filemap: Add filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 17:40:17 -0700
Message-ID: <20220824004023.77310-2-vishal.moola@gmail.com>
References: <20220824004023.77310-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=roEOVbMBkZrS+KI85Bv7B/f0yshSydvUYCZY5utraVI=;
        b=axPR5zKGK6FMyTGxARPaldWKtH7yyljRt5bxFzpIGOUfrlF7+RCqumQ03cEhG8/mnR
         J4GdPGyiCvAQhoAR+VLKPErEwrHdTZsicE16ytnlwYQC02ac3i+UQjMzYcmQIFuv/BMe
         VgRpVk3yOG3Oy3AZRKq/NOkyFrGYzVAkxud7JOndBVhOysDfedJ46ou8jKoLkOzWVSgf
         pDQocPOwVQwzE8SHXCGvsWfYeASm9P85dA+4okdbCpu5deeBfX1oQrUBBZ9l1pzTJVYb
         pkqTdg7JukSeYz9o6engmowTMsgXeGTtX4InuI3CCb2A33IllR6xneDSV1xMPMPp4lfn
         iWgg==
In-Reply-To: <20220824004023.77310-1-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>

This function is meant to replace find_get_pages_contig().

Unlike find_get_pages_contig(), filemap_get_folios_contig() no
longer takes in a target number of pages to find - It returns up to 15
contiguous folios.

To be more consistent with filemap_get_folios(), filemap_get_folios_contig()
now also updates the start index passed in, and takes an end index.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 73 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index cc9adbaddb59..951936a2be1d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -720,6 +720,8 @@ static inline struct page *find_subpage(struct page *head, pgoff_t index)
 
 unsigned filemap_get_folios(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch);
+unsigned filemap_get_folios_contig(struct address_space *mapping,
+		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch);
 unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
 			       unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_range_tag(struct address_space *mapping, pgoff_t *index,
diff --git a/mm/filemap.c b/mm/filemap.c
index 8ccb868c3d95..8167bcc96e37 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2196,6 +2196,79 @@ bool folio_more_pages(struct folio *folio, pgoff_t index, pgoff_t max)
 	return index < folio->index + folio_nr_pages(folio) - 1;
 }
 
+/**
+ * filemap_get_folios_contig - Get a batch of contiguous folios
+ * @mapping:	The address_space to search
+ * @start:	The starting page index
+ * @end:	The final page index (inclusive)
+ * @fbatch:	The batch to fill
+ *
+ * filemap_get_folios_contig() works exactly like filemap_get_folios(),
+ * except the returned folios are guaranteed to be contiguous. This may
+ * not return all contiguous folios if the batch gets filled up.
+ *
+ * Return: The number of folios found.
+ * Also update @start to be positioned for traversal of the next folio.
+ */
+
+unsigned filemap_get_folios_contig(struct address_space *mapping,
+		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch)
+{
+	XA_STATE(xas, &mapping->i_pages, *start);
+	unsigned long nr;
+	struct folio *folio;
+
+	rcu_read_lock();
+
+	for (folio = xas_load(&xas); folio && xas.xa_index <= end;
+			folio = xas_next(&xas)) {
+		if (xas_retry(&xas, folio))
+			continue;
+		/*
+		 * If the entry has been swapped out, we can stop looking.
+		 * No current caller is looking for DAX entries.
+		 */
+		if (xa_is_value(folio))
+			goto update_start;
+
+		if (!folio_try_get_rcu(folio))
+			goto retry;
+
+		if (unlikely(folio != xas_reload(&xas)))
+			goto put_folio;
+
+		if (!folio_batch_add(fbatch, folio)) {
+			nr = folio_nr_pages(folio);
+
+			if (folio_test_hugetlb(folio))
+				nr = 1;
+			*start = folio->index + nr;
+			goto out;
+		}
+		continue;
+put_folio:
+		folio_put(folio);
+
+retry:
+		xas_reset(&xas);
+	}
+
+update_start:
+	nr = folio_batch_count(fbatch);
+
+	if (nr) {
+		folio = fbatch->folios[nr - 1];
+		if (folio_test_hugetlb(folio))
+			*start = folio->index + 1;
+		else
+			*start = folio->index + folio_nr_pages(folio);
+	}
+out:
+	rcu_read_unlock();
+	return folio_batch_count(fbatch);
+}
+EXPORT_SYMBOL(filemap_get_folios_contig);
+
 /**
  * find_get_pages_contig - gang contiguous pagecache lookup
  * @mapping:	The address_space to search
-- 
2.36.1

