From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 36/78] mm: Convert __do_page_cache_readahead to XArray
Date: Fri, 15 Dec 2017 14:04:08 -0800
Message-ID: <20171215220450.7899-37-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
	Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=D8M3hOFBbLyULrl9YVFK8Bg7yKABGG8u8Da+4wV0B9U=; b=MDKFJp3HyYeXWWFjGAja8GeGO
	jTe14rhfGpNpNrCjTbOszcfa5jcgbvhy0d/+6ZITxvsEzPws6yh3n3zumPQEiPeAoUOdGSLEFofqF
	NRrlm0CPB/hGQ+lSdkc9hOR4IfPPpw2q6t7k8UiS7fFbuagSb0mhiTs4SreIdzclBt5sTyaKAVvEu
	41fwoknVPt3sYxMoaxZ0GiKsaWmmkptwZFrO18dpEcheEgm1X1T5xujkVDuGRDTYRC/zFlK1QAIHr
	XmIGULOEh8MEVFisE0M6szYekTPDqJ0ICo9MayWWOa1pSxsQCSLjHdX4f7ouAJBc7zQlYAIwKSIJs
	gpiSia+rQ==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This one is trivial.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/readahead.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index f64b31b3a84a..66bcaffd47f0 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -174,9 +174,7 @@ int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 		if (page_offset > end_index)
 			break;
 
-		rcu_read_lock();
-		page = radix_tree_lookup(&mapping->pages, page_offset);
-		rcu_read_unlock();
+		page = xa_load(&mapping->pages, page_offset);
 		if (page && !xa_is_value(page))
 			continue;
 
-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
