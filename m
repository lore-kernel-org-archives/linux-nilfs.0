From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 31/61] page cache: Convert filemap_range_has_page to XArray
Date: Tue, 13 Mar 2018 06:26:09 -0700
Message-ID: <20180313132639.17387-32-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TUtEh0M91EPdkADjFqpMeEIRJ3g2LkGH+aLO+Cd7bW8=; b=BPq+i0sH4X8mQQ3hYKfgA4pB6
        lMf3JutbTRpYlzl7vOVMlWV9Am8sMC6At5bhiG+aa1rQUsC6nkTzaMknlz0/yPTn3/f5uydzF7RAd
        gi/yoZClIFwQR9i0pyxfw1RpaB4JMqByS9/HUQyJg0+8z9eH1F9Gz7B/6qrO9n9U3LvhyyluKB6ti
        JYXYfcfGVMoh+Lpe5PwpkCW8DtoRuhcPcAj2lfSMAfOeItyhpEpCjz90gRJEEwucaY9H+ftBvihH5
        +3QYvK4Q97sYgGZQLRYj35Q4kah1BdparUIqtOAI6x+M7uMV2u0L5Gc6TQFmUsd7Pyk9rMPyMvHFB
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Instead of calling find_get_pages_range() and putting any reference,
use xas_find() to iterate over any entries in the range, skipping the
shadow/swap entries.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 86c83014c909..9bc417913269 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -458,20 +458,30 @@ EXPORT_SYMBOL(filemap_flush);
 bool filemap_range_has_page(struct address_space *mapping,
 			   loff_t start_byte, loff_t end_byte)
 {
-	pgoff_t index = start_byte >> PAGE_SHIFT;
-	pgoff_t end = end_byte >> PAGE_SHIFT;
 	struct page *page;
+	XA_STATE(xas, &mapping->i_pages, start_byte >> PAGE_SHIFT);
+	pgoff_t max = end_byte >> PAGE_SHIFT;
 
 	if (end_byte < start_byte)
 		return false;
 
-	if (mapping->nrpages == 0)
-		return false;
+	rcu_read_lock();
+	do {
+		page = xas_find(&xas, max);
+		if (xas_retry(&xas, page))
+			continue;
+		/* Shadow entries don't count */
+		if (xa_is_value(page))
+			continue;
+		/*
+		 * We don't need to try to pin this page; we're about to
+		 * release the RCU lock anyway.  It is enough to know that
+		 * there was a page here recently.
+		 */
+	} while (0);
+	rcu_read_unlock();
 
-	if (!find_get_pages_range(mapping, &index, end, 1, &page))
-		return false;
-	put_page(page);
-	return true;
+	return page != NULL;
 }
 EXPORT_SYMBOL(filemap_range_has_page);
 
-- 
2.16.1

