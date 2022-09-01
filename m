From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 01/23] pagemap: Add filemap_grab_folio()
Date: Thu,  1 Sep 2022 15:01:16 -0700
Message-ID: <20220901220138.182896-2-vishal.moola@gmail.com>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=+d28bepiquHWlxilFueNkEADr0o+je+NLAZFPUKTbIY=;
        b=ghwmH7OBtODEG3q6T97VdwhOtKpgroD8O6/eJME6RxcE0RCt6y1f0k8Z+Nf438szjC
         f1Tz2jCtqotWMYX7jAfk8pOks8r2uw1MbNfVxQq0DoggwzPzqUI1rjL/zYCVH96CDWOv
         6N+BySbmSBpBiAynr3+ZISEA0FDbCfqFR2qcMY0YXtQvpxu9mYXWpYrIjN0m8121kRUK
         taJIkqf7L0HTr7GIXny4HPFg0cC9mjsMx0m7GnMMBPB1n6WD1zCiOVAj8NMqjbSN/CwY
         UiWg2L5Utibhg+ppDHvNeQZKqE6Q7TMiSRDWsRr05n+F5Hbq6n90JrOCXpSrF4pvJHUr
         61YA==
In-Reply-To: <20220901220138.182896-1-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>

Add function filemap_grab_folio() to grab a folio from the page cache.
This function is meant to serve as a folio replacement for
grab_cache_page, and is used to facilitate the removal of
find_get_pages_range_tag().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/pagemap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0178b2040ea3..4d3092d6b2c0 100644
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
2.36.1

