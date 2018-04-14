From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 40/63] shmem: Convert shmem_free_swap to
 XArray
Date: Sat, 14 Apr 2018 07:12:53 -0700
Message-ID: <20180414141316.7167-41-willy@infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
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
 bh=4VhSTaSjImgtvVf+AzfWoCbu56g+4VsvIXvq5qNUmPw=; b=En5TaMGo/+gsH/wtmqsOk+BXz8
 jvufykrTeYq7kRAbwssMgfrQDhAPJGjoYB0LHKkSArwB7BOJUd1n/PQNPMXnbzzLtikPYJobIRGf9
 Sum/lbeCQPY732DRSZhlO1FtjYxGjgAcwBeDpFWNlapTw5mX+dVa1GKd4XoW2MkEd+ts=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=4VhSTaSjImgtvVf+AzfWoCbu56g+4VsvIXvq5qNUmPw=; b=Nh4f/V8DPIEyMaBLvsQXHtDGmy
 b6nn1dsfIl/O20Iyi2p8H4BLC9mwzkyzhFPYR+dEqZRrpJFsLJ1LK72MDZrN9N7F8uPQ8QpdW8oiO
 eLU/hHk37ZZVheO4+Rin1ypKEKX59hitduyBUS+/BN7RftJXF5+dTF5O3Df3ufCzLQbw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=4VhSTaSjImgtvVf+AzfWoCbu56g+4VsvIXvq5qNUmPw=; b=LD++UJdxbKFQs6ogMpBuaMqeZ
 wtoBKAnzkAaOMMHt2pgHi5EINUytDM5wi2pb62CGGdBsJ8QhbVgOWyvgAT9cTO4gMTEdrj2nwLVIq
 fV4FlN87yGlzj1+qTaKLVwdVRIFsVv9BsYEVpQp5kpOTLNibM70cfSHFBH7IFEWRPxI7qiQhRPnZV
 +9/rpb76L7kTfZwQllCdL1Fxt3V8PuCnnoHPLDEpklehhZdQPboM+m8Lqj36Ja5S2b/Yqx9GMuKyF
 Tf0afubak8128TB7i3+haYmwtkEW2oyRNNkioAyYIBpWag+3q9G1Unu+IdGMx8kDTFL2L2v8kxykj
 4l/cYrY1Q==;
In-Reply-To: <20180414141316.7167-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

This is a perfect use for xa_cmpxchg().  Note the use of 0 for GFP
flags; we won't be allocating memory.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 985c5cdec7f7..0ead678725c4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -644,16 +644,13 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 }
 
 /*
- * Remove swap entry from radix tree, free the swap and its page cache.
+ * Remove swap entry from page cache, free the swap and its page cache.
  */
 static int shmem_free_swap(struct address_space *mapping,
 			   pgoff_t index, void *radswap)
 {
-	void *old;
+	void *old = xa_cmpxchg(&mapping->i_pages, index, radswap, NULL, 0);
 
-	xa_lock_irq(&mapping->i_pages);
-	old = radix_tree_delete_item(&mapping->i_pages, index, radswap);
-	xa_unlock_irq(&mapping->i_pages);
 	if (old != radswap)
 		return -ENOENT;
 	free_swap_and_cache(radix_to_swp_entry(radswap));
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
