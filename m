From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 60/73] dax: Convert __dax_invalidate_mapping_entry to XArray
Date: Tue,  5 Dec 2017 16:41:46 -0800
Message-ID: <20171206004159.3755-61-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zrOkKO/fGEY1PBTy9hS+c1GQgcVpwJs7dXgHaC7Ba1k=; b=MGPWzB+S4VqpIErTlVE59uMEr
        Xe4DnMo4tY+cFt2GIZzMghYA6OKHJhXhUUFvJCMfHp+/Twdxs6d2IN7iyL0ETxwprjehB2UMarOBy
        897R0TrTQIbaqDvPcDNbgbceylslC8Kg5Ml50SIGK5t0YiZLU1tW6xZU0Yiajbi57xGoBxoXAAA53
        VcpQb2CAlM23zdo+8JL+RvEAKPCz2Ut1DvB5iwsF1udNjFFI7EOF4kVlQ+B4azlgx7n0pnyXLP92V
        KlaROPIwadN8WwNctmm31rSvdnk6gO8LlawX4ioJqROjEn0jnDfqXH/CTggrFDoHJj0aic/U9Es18
    
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Simple now that we already have an xa_state!

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index ad984dece12e..66f6c4ea18f7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -413,24 +413,24 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 	XA_STATE(xas, &mapping->pages, index);
 	int ret = 0;
 	void *entry;
-	struct radix_tree_root *pages = &mapping->pages;
 
 	xa_lock_irq(&mapping->pages);
 	entry = get_unlocked_mapping_entry(&xas);
 	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
 		goto out;
 	if (!trunc &&
-	    (radix_tree_tag_get(pages, index, PAGECACHE_TAG_DIRTY) ||
-	     radix_tree_tag_get(pages, index, PAGECACHE_TAG_TOWRITE)))
+	    (xas_get_tag(&xas, PAGECACHE_TAG_DIRTY) ||
+	     xas_get_tag(&xas, PAGECACHE_TAG_TOWRITE)))
 		goto out;
-	radix_tree_delete(pages, index);
+	xas_store(&xas, NULL);
 	mapping->nrexceptional--;
 	ret = 1;
 out:
 	put_unlocked_mapping_entry(&xas, entry);
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
 	return ret;
 }
+
 /*
  * Delete DAX data value entry at @index from @mapping. Wait for radix tree
  * entry to get unlocked before deleting it.
-- 
2.15.0

