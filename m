From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 02/23] filemap: Added filemap_get_folios_tag()
Date: Thu,  1 Sep 2022 15:01:17 -0700
Message-ID: <20220901220138.182896-3-vishal.moola@gmail.com>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=CVjZRQRXjU7sjBLr6rHvAQKfUIl2rAWam+cMUVwdi8E=;
        b=bv0LlXMBz1E57HLrV0PxYhOttdXPLA9G/hmytg6Pe0rd+F6zlztjWzFwbENyiMaQWR
         F0y9cniRQ6tVYw7gWA96HxH7uvhLa7fAV6j9jf6hJKnH+nqTOa6IuccLgG2jeB4wnKbN
         dXNbKHhDCRc0KcSaeocdSfxm7jfTTYEBJlJdkL7KuMup4EyoA3sh9A1lYrEFkmC6fktZ
         zYtzraSEWM+6VBSfJSxJZMDmzsg1bohGoHF4buE8zyNN/Y+ges7udin1m1Ip09ANb1qi
         yx9Dumn8NExq4UnKeww1kfiOzJo2ul+62vzxa7uoxr+6j09KzXtjhQLvasVG7qC/0CUb
         sXvQ==
In-Reply-To: <20220901220138.182896-1-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>

This is the equivalent of find_get_pages_range_tag(), except for folios
instead of pages.

One noteable difference is filemap_get_folios_tag() does not take in a
maximum pages argument. It instead tries to fill a folio batch and stops
either once full (15 folios) or reaching the end of the search range.

The new function supports large folios, the initial function did not
since all callers don't use large folios.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 53 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 4d3092d6b2c0..85cc96c82c2c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -740,6 +740,8 @@ unsigned filemap_get_folios(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch);
 unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
 			       unsigned int nr_pages, struct page **pages);
+unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
+		pgoff_t end, xa_mark_t tag, struct folio_batch *fbatch);
 unsigned find_get_pages_range_tag(struct address_space *mapping, pgoff_t *index,
 			pgoff_t end, xa_mark_t tag, unsigned int nr_pages,
 			struct page **pages);
diff --git a/mm/filemap.c b/mm/filemap.c
index 15800334147b..3ded72a65668 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2254,6 +2254,59 @@ unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t index,
 }
 EXPORT_SYMBOL(find_get_pages_contig);
 
+/**
+ * filemap_get_folios_tag - Get a batch of folios matching @tag.
+ * @mapping:    The address_space to search
+ * @start:      The starting page index
+ * @end:        The final page index (inclusive)
+ * @tag:        The tag index
+ * @fbatch:     The batch to fill
+ *
+ * Same as filemap_get_folios, but only returning folios tagged with @tag
+ *
+ * Return: The number of folios found
+ * Also update @start to index the next folio for traversal
+ */
+unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
+			pgoff_t end, xa_mark_t tag, struct folio_batch *fbatch)
+{
+	XA_STATE(xas, &mapping->i_pages, *start);
+	struct folio *folio;
+
+	rcu_read_lock();
+	while ((folio = find_get_entry(&xas, end, tag)) != NULL) {
+		/* Shadow entries should never be tagged, but this iteration
+		 * is lockless so there is a window for page reclaim to evict
+		 * a page we saw tagged. Skip over it.
+		 */
+		if (xa_is_value(folio))
+			continue;
+		if (!folio_batch_add(fbatch, folio)) {
+			unsigned long nr = folio_nr_pages(folio);
+
+			if (folio_test_hugetlb(folio))
+				nr = 1;
+			*start = folio->index + nr;
+			goto out;
+		}
+	}
+	/*
+	 * We come here when there is no page beyond @end. We take care to not
+	 * overflow the index @start as it confuses some of the callers. This
+	 * breaks the iteration when there is a page at index -1 but that is
+	 * already broke anyway.
+	 */
+	if (end == (pgoff_t)-1)
+		*start = (pgoff_t)-1;
+	else
+		*start = end + 1;
+out:
+	rcu_read_unlock();
+
+	return folio_batch_count(fbatch);
+}
+EXPORT_SYMBOL(filemap_get_folios_tag);
+
 /**
  * find_get_pages_range_tag - Find and return head pages matching @tag.
  * @mapping:	the address_space to search
-- 
2.36.1

