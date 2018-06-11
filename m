From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 51/72] shmem: Convert shmem_free_swap to
 XArray
Date: Mon, 11 Jun 2018 07:06:18 -0700
Message-ID: <20180611140639.17215-52-willy@infradead.org>
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
 bh=sMEe5HP+nzzouXdOXrYTxqJXjywXPmaQ9Qzg2IJzEoQ=; b=el2PCC1N2gR0iJqjNiYsSn+vpE
 YfkiJ5YjHiTouAJv78Ejl0B/0aiPB2Bviae6zWImsUWeDwCvFGDk4Ycfzy9b2kiZvVaiKy8fYEcoY
 WjoYLTI3OG/GV2XBskwgArVfSvxb0Z70h6DFbimB3XYsZdMH4ny2mZkZyihJBDkd16RY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=sMEe5HP+nzzouXdOXrYTxqJXjywXPmaQ9Qzg2IJzEoQ=; b=mymxiSOIdWnMGhszxoVacS7mYd
 a86V3h8J6xjMKEr4I7ccfH8QgW6fXGJQbyKSBRBUfsyN3EOW55A0leIa38KonKyFPGuOlry0+nk/w
 Qmv5n48easAiCWwocXdoLKsyWRpa5bO52kWpT+o9OK1+aEtxbROA/4lDbkxrZenPZnI8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=sMEe5HP+nzzouXdOXrYTxqJXjywXPmaQ9Qzg2IJzEoQ=; b=BAdkMUBWwoPl4SbrSwOFcauPR
 1k5+zQNA7G3io1pMKMht6mSNi23R8hpLQWPacMuNGi+mTu0n0/g5nYmpSULVJdqkYSgHwTLWp0f6n
 R2C28uyfYVJhC3V8wL43WAGOs4HXaMAMb5Tc4jLRtkGAhFiVDYNFJRq/0NS6bX+zMzjQj7X3XH8uK
 GMBDBaiWA7wuQissHUEVQxz16XpY/BMNXOY3Vf9sdjg8UcKlWHf1zKWWxpsSDPuVHq/511migTF2o
 qVrcrSLJYGQORjoGMkt5vQM1TlPATNpZ+j1OwLx8e97jC0kzfUbBfFOO2jqQI2MK9DSzT/YFSEmCi
 1fnn6nOpQ==;
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

Since we are conditionally storing NULL in the XArray, we do not need
to allocate memory and the GFP flags will be unused.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 09452ca79220..9dbbdd5dee30 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -653,7 +653,7 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 }
 
 /*
- * Remove swap entry from radix tree, free the swap and its page cache.
+ * Remove swap entry from page cache, free the swap and its page cache.
  */
 static int shmem_free_swap(struct address_space *mapping,
 			   pgoff_t index, void *radswap)
@@ -661,7 +661,7 @@ static int shmem_free_swap(struct address_space *mapping,
 	void *old;
 
 	xa_lock_irq(&mapping->i_pages);
-	old = radix_tree_delete_item(&mapping->i_pages, index, radswap);
+	old = __xa_cmpxchg(&mapping->i_pages, index, radswap, NULL, 0);
 	xa_unlock_irq(&mapping->i_pages);
 	if (old != radswap)
 		return -ENOENT;
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
