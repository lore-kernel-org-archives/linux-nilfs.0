From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 44/72] mm: Convert is_page_cache_freeable to
 XArray
Date: Mon, 11 Jun 2018 07:06:11 -0700
Message-ID: <20180611140639.17215-45-willy@infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=cp1noagiBNyq9HAsILQXj5VlZgjwOoF7k27YeP6vh0Y=; b=hy63ELMsB+XnAVaFWs5RmY0M+K
 qnLinS5tAywebbHne1ihpjbsDQMsYNmKYuaH3EfW45qM8yAK0Z83NTLZvC9Y9MtikovpIt+bxZSqH
 EkAAbxDKthjrkZzbyH0Gr4sqhlphMkFUwCF0//ebcQiiRTwyOEUsnpYzy7g1bfYMUEL0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=cp1noagiBNyq9HAsILQXj5VlZgjwOoF7k27YeP6vh0Y=; b=SKLA75ZOWS2q5Rw4dQ4JD9PJYx
 Pdq9258uhl6+EFZTnd096LFf5CKXa2qW0zrJkzQpPL9ZrTtftm9QRRp1/qPlNOg7pCmqPRWOhyYeP
 R4qucPjj5lcwkBQZIpTHc3aCaeKlN6Vje2VRwEsmpdEjgMKgerB82CAJKR9xpiSPqDDg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=cp1noagiBNyq9HAsILQXj5VlZgjwOoF7k27YeP6vh0Y=; b=SxnE1mBapiL1y28hZwNeGhwJ/
 09GiEhWbiib7/g4Cf75aq6Mmb1CR7cHxMapWj7kfybfOHAnN4e8Z/pRh0APfHIQ8UORSfvNeE4yAT
 OgRbmoYJ5MsXrO7CXw1orPGIwM61vo6P8lAv+KtPFjAZF4KsMOU0C6rHaXJG7/QUHP67Xst6/T1j3
 kKeGvrj03NUAd30r20e6DEpV3rYn/8f6mNT07W8BPtRbJFcJjBA2wsF31eiThUGDptumCq90fytF8
 99wUYAh4T4zj5KSBLms74ym6yGsbRfaL2G7ODSleL9hApFG3JeXlnoD35k2xeeOQ45RfrFk3M1t2Y
 zPgRHySzA==;
In-Reply-To: <20180611140639.17215-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

This is just a variable rename and comment change.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/vmscan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0448b1b366d9..575747728ee6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -572,12 +572,12 @@ static inline int is_page_cache_freeable(struct page *page)
 {
 	/*
 	 * A freeable page cache page is referenced only by the caller
-	 * that isolated the page, the page cache radix tree and
-	 * optional buffer heads at page->private.
+	 * that isolated the page, the page cache and optional buffer
+	 * heads at page->private.
 	 */
-	int radix_pins = PageTransHuge(page) && PageSwapCache(page) ?
+	int page_cache_pins = PageTransHuge(page) && PageSwapCache(page) ?
 		HPAGE_PMD_NR : 1;
-	return page_count(page) - page_has_private(page) == 1 + radix_pins;
+	return page_count(page) - page_has_private(page) == 1 + page_cache_pins;
 }
 
 static int may_write_to_inode(struct inode *inode, struct scan_control *sc)
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
