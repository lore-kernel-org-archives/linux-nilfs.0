From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 04/63] unicore32: Turn flush_dcache_mmap_lock into a no-op
Date: Tue,  6 Mar 2018 11:23:14 -0800
Message-ID: <20180306192413.5499-5-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LNdl9xwnGce9andWyEPDDsS6Pi2hPfcZinV72VWZDgg=; b=VNv2AR7S9Ex2FQdW/XC+NVqVO
        7Rh1HC9Bx4ElemSnwTaaJm2juyLPI45IFurOSsEZ59/snKPASq9psP40+TL8a46LPoOBwUNNajwwG
        tuJn4t2Lhk+NnF5AjiQ/DVMkcFLY8//X9BSQV6U76wSZgc1i54QDMFrdLbOvH6VMHs6T5KhwjTpYP
        H2LLCfgWxs7cwktk1EovEaybGvM4BLuQXbK3NNoRbw1XSapC2zK4Y+HkjmH9J4nY6CA2PJV/m0qKJ
        34wXEEITG1kQZdM19A1BN53s67bM6fXLfCwF+xufNXYYbZYFWn4pr7lmIwq7g3A23mEiXUiT7W1Ob
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Unicore doesn't walk the VMA tree in its flush_dcache_page()
implementation, so has no need to take the tree_lock.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 arch/unicore32/include/asm/cacheflush.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/unicore32/include/asm/cacheflush.h b/arch/unicore32/include/asm/cacheflush.h
index a5e08e2d5d6d..1d9132b66039 100644
--- a/arch/unicore32/include/asm/cacheflush.h
+++ b/arch/unicore32/include/asm/cacheflush.h
@@ -170,10 +170,8 @@ extern void flush_cache_page(struct vm_area_struct *vma,
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *);
 
-#define flush_dcache_mmap_lock(mapping)			\
-	spin_lock_irq(&(mapping)->tree_lock)
-#define flush_dcache_mmap_unlock(mapping)		\
-	spin_unlock_irq(&(mapping)->tree_lock)
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 
 #define flush_icache_user_range(vma, page, addr, len)	\
 	flush_dcache_page(page)
-- 
2.16.1

