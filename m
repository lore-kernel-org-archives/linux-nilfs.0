From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 47/61] shmem: Convert shmem_alloc_hugepage to XArray
Date: Tue, 13 Mar 2018 06:26:25 -0700
Message-ID: <20180313132639.17387-48-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rXzXhtVcMtSI73Tb4Vc4OGoMQ9ed2P7MXl58GYL2T3o=; b=S4uPXcxWlcwOHLLb5P5lqs3Ca
        h/+cLv4bBUfkg8bu3iqb2LT+aLFeAnANR+gdj+Wdem1TrvT0NmRQf0x7S6/ryxAo4SXblFw3d7ahz
        xSbkeqMppVXWHa58ukmB0eBF+M4pEXfnXshQQShwqD9rOguZGzHiyOVx7CySu4mEkBVwte8jncO+v
        6VNrBIMBxSEwsTRczBKEdgBmPSwsNlGYOgehKM8yhbeT2UHVUnh3mkPiede1N6BjRbN1sGK5iFSLa
        3PpARw0pu5r+aMinmRaoy8huLxC1+A9Urqfv3GsjOH1D7yYXDmVAaNM1PSxDFgFSnYhmFY6VFLhhV
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

xa_find() is a slightly easier API to use than
radix_tree_gang_lookup_slot() because it contains its own RCU locking.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fb06fb3e644a..a0a354a87f3b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1416,23 +1416,17 @@ static struct page *shmem_alloc_hugepage(gfp_t gfp,
 		struct shmem_inode_info *info, pgoff_t index)
 {
 	struct vm_area_struct pvma;
-	struct inode *inode = &info->vfs_inode;
-	struct address_space *mapping = inode->i_mapping;
-	pgoff_t idx, hindex;
-	void __rcu **results;
+	struct address_space *mapping = info->vfs_inode.i_mapping;
+	pgoff_t hindex;
 	struct page *page;
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
 		return NULL;
 
 	hindex = round_down(index, HPAGE_PMD_NR);
-	rcu_read_lock();
-	if (radix_tree_gang_lookup_slot(&mapping->i_pages, &results, &idx,
-				hindex, 1) && idx < hindex + HPAGE_PMD_NR) {
-		rcu_read_unlock();
+	if (xa_find(&mapping->i_pages, &hindex, hindex + HPAGE_PMD_NR - 1,
+								XA_PRESENT))
 		return NULL;
-	}
-	rcu_read_unlock();
 
 	shmem_pseudo_vma_init(&pvma, info, hindex);
 	page = alloc_pages_vma(gfp | __GFP_COMP | __GFP_NORETRY | __GFP_NOWARN,
-- 
2.16.1

