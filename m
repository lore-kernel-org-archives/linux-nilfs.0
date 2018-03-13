From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 48/61] shmem: Convert shmem_free_swap to XArray
Date: Tue, 13 Mar 2018 06:26:26 -0700
Message-ID: <20180313132639.17387-49-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=s45HmMDP7/Lh87o/Az3eaE9LOfvR4oj5fV0qPSxpKec=; b=erigPmuOigWy/x3GbDyXMBYoF
        xWKGuCm4S0R4csWw7C9o913Cg2uGgmTGbraYeNEQ+sqTBOahln8utBUPjv4PvsvqS/1M2XtYntw/y
        g2Difg8l9J6yw7Dpr75PzOUffP3Y41fK2f+goGmg0gj4NrKDKW1wjVi/vo0/QkBk2eOW4AmoAy+m+
        9qdo4dx/m63cG/F3PzzSF1lRNDNVmjYwS1bJB10gaNu7kNmLpU9N8x+TwbRGrVhqdgSzpP0fHfMBo
        rkXR8s9pviSsvHOwK3+ljmxixQ5GKc87XbTBzHvA4kMuV4duewYX0x5yNBLHjIA1+/HOQmF/MeiFa
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This is a perfect use for xa_cmpxchg().  Note the use of 0 for GFP
flags; we won't be allocating memory.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index a0a354a87f3b..cfbffb4b47a2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -635,16 +635,13 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
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
2.16.1

