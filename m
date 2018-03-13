From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 04/61] unicore32: Turn flush_dcache_mmap_lock into a no-op
Date: Tue, 13 Mar 2018 06:25:42 -0700
Message-ID: <20180313132639.17387-5-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LNdl9xwnGce9andWyEPDDsS6Pi2hPfcZinV72VWZDgg=; b=ult0rLA8mmT2Q0/LZOlalJd70
        MMuaadqCzMjmczmozVt9WVXnsogKgrJdN4a3jnvemAY+lQxm2BuJpAcZxr55sEa59KSdZhYsNMygM
        aDC2HyfzKC1WtvPCaISqjicJ/R9vCje1wo+TinOLYV1JkAB7j0sEoqWNWwgUUTpJcm9d5aGY+4GXP
        1kNPPASJ89/7kjjtq1qiGpSWm8eDQ/MV3FpNUF3AV66e50qc5Uvn/o5yRjyh9RgM8RPXupWDW41oH
        kY7Q/zvI44f5PwZ8ZFBwzi8nIXIBUAb8Ojycx0YA7976uEnLBm5OUJr1QeTcO5OvNiYMv7bmHKTZq
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

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

