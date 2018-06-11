From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 47/72] shmem: Convert shmem_confirm_swap to
 XArray
Date: Mon, 11 Jun 2018 07:06:14 -0700
Message-ID: <20180611140639.17215-48-willy@infradead.org>
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
 bh=0csFvUP++HIsjyS093eVt+iU23F6aEPdiKSGAjZkOUY=; b=jajZOnQcpkSp8S8dcPaGWrQdbv
 hvtScU4RxxrWbMoLRasBVRRMscE1MiKXiwMLy3JklraaOimcFaa6cJkjHoAxM5EpNyILvl79DP+NV
 vj9y7ks3WO3qNIkE+cdT6u6en4xbsttCVCUcbB7uNK1I05d+7WBPgde7+NI+1MGelPMI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=0csFvUP++HIsjyS093eVt+iU23F6aEPdiKSGAjZkOUY=; b=ZBYk8gy7t1H5/JvfjUY2AA6Vc8
 OoMy5NjvwCEpBkTbQzy+dqIsz3p9LoklfPqPW7J35Emoh6Jzaqg/39PNKwdeVLDZU1NnSf7v52vLb
 Rh6LlYtR+H8VMsClmAt7CguRqLAtG/Y2eyAbLdf6cafeXKmmP488PMYbpLhc8nX33M1w=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=0csFvUP++HIsjyS093eVt+iU23F6aEPdiKSGAjZkOUY=; b=P6SXzgnIPyKH0In6/65wJy+BI
 s045Y6AKyw0/S44kF49VUZiNW+U3TZ60CGj1gs279C8eRh5m4Y3G47QZWxH0Clzvp41zpqBHHkwvU
 sorI37jMVLQBywKZ+wSnZegKPigORWPP1nsv/xCqAaQK3NBX9Bg0f/fqlfucpXV6F9fvC+SdWkC+o
 OrlRG0O5McB7n5KX8AXugk+v1uhG+2LRtmMYFoRTp+/ay1NI07kqx8NEw6AUx5LbHBwAgRqcVxGXu
 7XgykXDdpJaMGaXZRb4xHTR/tO4muxutNLTWWsZ4TxjgYi24I71+DbDm72DmHa23uWIhorDEJTfs/
 TYVuGxYvA==;
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

xa_load has its own RCU locking, so we can eliminate it here.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 2b8720d32e7a..479e4a8e6d68 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -348,12 +348,7 @@ static int shmem_replace_entry(struct address_space *mapping,
 static bool shmem_confirm_swap(struct address_space *mapping,
 			       pgoff_t index, swp_entry_t swap)
 {
-	void *item;
-
-	rcu_read_lock();
-	item = radix_tree_lookup(&mapping->i_pages, index);
-	rcu_read_unlock();
-	return item == swp_to_radix_entry(swap);
+	return xa_load(&mapping->i_pages, index) == swp_to_radix_entry(swap);
 }
 
 /*
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
