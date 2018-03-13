From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 44/61] shmem: Convert shmem_confirm_swap to XArray
Date: Tue, 13 Mar 2018 06:26:22 -0700
Message-ID: <20180313132639.17387-45-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=03pTud/1qACkCUUsdo0GFSxlZtWKgSD/sjY7c1IOHPA=; b=sHr7uXYbThmlFhexIx73g/oi6
        Dpjkwp+glUvIhcOoH1ZvMW++LR/k523sCTLNi3RpfGV2rCAF1YeDm6TTzkWFm8XIqM7MeOTCSDCce
        Ce5brOwcqNEp1mC6aikdpxtgRMV4OZOGsgucNbQLwb8MRbDNRWOwxYiAuN9yFpAfw+gq8sSARS6Ng
        /apnc4kkjYjLEsBjl5rX0ZqBM338jKs8PhRbQ3GJcjfW/prKQf1Bb3jtkwLDJkCQ1Vz7IhAeB+Ol8
        cZwZLXzyUtlb6RPE4MqCEudLoX5R6UvJi4EgWO3DCGwY/2hjgSABrza7WwVBDFHcp1WW9B/Tqluix
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

xa_load has its own RCU locking, so we can eliminate it here.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5813808965cd..0af8a439dfad 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -348,12 +348,7 @@ static int shmem_xa_replace(struct address_space *mapping,
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
2.16.1

