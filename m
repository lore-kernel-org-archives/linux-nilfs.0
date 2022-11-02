From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v4 01/23] pagemap: Add filemap_grab_folio()
Date: Wed,  2 Nov 2022 09:10:09 -0700
Message-ID: <20221102161031.5820-2-vishal.moola@gmail.com>
References: <20221102161031.5820-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lbrAaY6idpkhBtxaaJGwUptujZ0EZql70PDCszR9xSI=;
        b=b22oyujJhcmEnIoOWyXlmdwFsWtvDDEbrYWi+tTl/IKQZadCXIum/ufaWsfiuhgQWs
         P0ejMWAXsFFxmUJWgjcqRWL6iDvmTJOBHMdvrWNuXSDSGhujg7k49tnS+xBECZ0DDC1D
         QEeKOjhkuj2U1fYHa3KM1TSvYvE4FrIPOrf/CN/DjK2k7Ii76jHakZpfzft8GgAI2TOi
         3dtL4HfeEfRRNgP7Mp0GAgu1ZDeKvnGqK9CY4nsrmEB3lEEy5PFMtwvBwHVV7JaSQ4Oc
         JqTTGwFIB+4o1Aa2ylRSznqsjRcz5BF5gANEbFRauGWLvr7/47QbInfDSn9b5QQsOYI/
         8XPQ==
In-Reply-To: <20221102161031.5820-1-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, Matthew Wilcox <willy@infradead.org>

Add function filemap_grab_folio() to grab a folio from the page cache.
This function is meant to serve as a folio replacement for
grab_cache_page, and is used to facilitate the removal of
find_get_pages_range_tag().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index bbccb4044222..74d87e37a142 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -547,6 +547,26 @@ static inline struct folio *filemap_lock_folio(struct address_space *mapping,
 	return __filemap_get_folio(mapping, index, FGP_LOCK, 0);
 }
 
+/**
+ * filemap_grab_folio - grab a folio from the page cache
+ * @mapping: The address space to search
+ * @index: The page index
+ *
+ * Looks up the page cache entry at @mapping & @index. If no folio is found,
+ * a new folio is created. The folio is locked, marked as accessed, and
+ * returned.
+ *
+ * Return: A found or created folio. NULL if no folio is found and failed to
+ * create a folio.
+ */
+static inline struct folio *filemap_grab_folio(struct address_space *mapping,
+					pgoff_t index)
+{
+	return __filemap_get_folio(mapping, index,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+			mapping_gfp_mask(mapping));
+}
+
 /**
  * find_get_page - find and get a page reference
  * @mapping: the address_space to search
-- 
2.38.1

