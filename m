From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 61/62] page cache: Finish XArray conversion
Date: Thu, 29 Mar 2018 20:42:44 -0700
Message-ID: <20180330034245.10462-62-willy@infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
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
 bh=toHEVkRiIh1J8Hqs/Ab1RoY3ap9JdhDp4scXHQ8Y0Ww=; b=mLK0hOUHXjbofRJEwCEwZU2H4t
 gLVsRPCZebyumBx75122+bqdjJ2idfgfj5rZfDkM2ZxjdMTwJB4W+pKOldwU5Q9Mb+thqOeo6NnMG
 XAp55CqKI0C7zYwwEH10qdHzB2Ne1YtOWY+/fZRV/Yebe8FBgJE8bQ9j7EdE2mIxeo6Y=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=toHEVkRiIh1J8Hqs/Ab1RoY3ap9JdhDp4scXHQ8Y0Ww=; b=Gu11DLSEXd32zXrMdtDjYc4dny
 KbSTk+fi73L7OQTq3/b0jDfmnBqgmTGblUTxquXgPTyMKPXyBVx9Nn0nIo0u0vkLqbZG9aPL9OvNJ
 D4F//YWXbWQsu/oze5LwMP0ArGq7sYcv9jsLKBJ7DDycc7KewutAOJgxJ1XVH/yKfB68=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=toHEVkRiIh1J8Hqs/Ab1RoY3ap9JdhDp4scXHQ8Y0Ww=; b=WKRLKsb4WjZeLEGr4qNTIMUTU
 02ixptb7hinYFetQr1Odrft6h9KvwVPpjD6jznaTdYzGIVrZxjbmmXJWbhe1RYPTDyR3rPwO3RX5h
 WN9ou7tMTbr3EiJf/E7buuor8CwYxWCmD5hOKUYePZuozaMfMogdVJyOi/zsme5saaV1KKixezNW2
 SNTGr+TfuDZIgJGiZhzkqUua1ScGWLpLYs+8zCT5YhjYvg8FBhw3DbBKTeBQLsXguRKFTwI1H/FdW
 VXgBPB9asz20V4ac+nHeckXQ26rl079FX84ylF591tnuMtCWCe1T8hw2ZwVWUUlTC/4Y1fupz52jr
 k/fRYPEnw==;
In-Reply-To: <20180330034245.10462-1-willy@infradead.org>
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

With no more radix tree API users left, we can drop the GFP flags
and use xa_init() instead of INIT_RADIX_TREE().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/inode.c      | 2 +-
 mm/swap_state.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 13ceb98c3bd3..d40c1c16febe 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -348,7 +348,7 @@ EXPORT_SYMBOL(inc_nlink);
 
 static void __address_space_init_once(struct address_space *mapping)
 {
-	INIT_RADIX_TREE(&mapping->i_pages, GFP_ATOMIC | __GFP_ACCOUNT);
+	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ);
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->private_list);
 	spin_lock_init(&mapping->private_lock);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index a0a562fbc65f..208a95ad00e6 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -599,7 +599,7 @@ int init_swap_address_space(unsigned int type, unsigned long nr_pages)
 		return -ENOMEM;
 	for (i = 0; i < nr; i++) {
 		space = spaces + i;
-		INIT_RADIX_TREE(&space->i_pages, GFP_ATOMIC|__GFP_NOWARN);
+		xa_init_flags(&space->i_pages, XA_FLAGS_LOCK_IRQ);
 		atomic_set(&space->i_mmap_writable, 0);
 		space->a_ops = &swap_aops;
 		/* swap cache doesn't use writeback related tags */
-- 
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
