From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 03/61] arm64: Turn flush_dcache_mmap_lock into a no-op
Date: Tue, 13 Mar 2018 06:25:41 -0700
Message-ID: <20180313132639.17387-4-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lRwqAg9yO1KXEjTm9Y3lyHOwtX2RN7vMIDvC03R853w=; b=IqbEQKR42pZu+6lqDPgMMc4/A
        ORS1bEqvia1v44eRDt/z/gXgGJkM8lbLBe/BCakzYBtLP1AueZBlojrBRnShc5eVtC/mTItqC/RRv
        KG7xN8QhLYsFMeYEfMLQHa0Iax8SPyGQEAB7EkdNuOQnmxMbwjpSwJ787VWMIvWf/rTpJ5Agpv7QP
        pTr/DvVkTuMqqxThI2M7v8qEX3leoNdmx/Y/P74pl24owxYPGMp/vi9kKlMmMqKtnKBbXq5xlHtje
        yETkXTV4vfvqKbEmpGuHObMm8qiwuR7sh0EU1eJ+Mds1ghEGaZJMJqy1GeMimjM8gEoI/quekLHry
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

ARM64 doesn't walk the VMA tree in its flush_dcache_page()
implementation, so has no need to take the tree_lock.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/cacheflush.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index 7dfcec4700fe..0094c6653b06 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -140,10 +140,8 @@ static inline void __flush_icache_all(void)
 	dsb(ish);
 }
 
-#define flush_dcache_mmap_lock(mapping) \
-	spin_lock_irq(&(mapping)->tree_lock)
-#define flush_dcache_mmap_unlock(mapping) \
-	spin_unlock_irq(&(mapping)->tree_lock)
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 
 /*
  * We don't appear to need to do anything here.  In fact, if we did, we'd
-- 
2.16.1

