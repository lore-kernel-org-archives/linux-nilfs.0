From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 03/63] arm64: Turn flush_dcache_mmap_lock into a no-op
Date: Tue,  6 Mar 2018 11:23:13 -0800
Message-ID: <20180306192413.5499-4-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8IO0rnKL1zknuNXws7LiWNSdEUpJKHZeYfIMYABSFKs=; b=ivDmVZNr+BwoYU9QcNLpxLGpf
        37g8Tid4KtA8TyArmZzktJnwlkRuP3qHNP9+kz/FD362sCX25Qm74dTdSAt650jSW3PnjJKsU3JSL
        C23fb31cNgx6mOGsAT0xWbjjCkZPyJc+z38gUojExMqPZUjSwNx80Hb1o/f1erQBKkxfe8F5mI70X
        Ih+eRixwacN1x3H9HQ6lMaS7wTDYpxflmN5e3nabO2k6Jkf8Sxg/NFADbSngPb/oju+TUOCGXHMZD
        eUvO3qK7ctXtYqMdcxfwDCO631jR7DdJD6jKdPboABcpZ/yy65gIjWCMl1qiYsC+IPEhDxZnTqZS8
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

ARM64 doesn't walk the VMA tree in its flush_dcache_page()
implementation, so has no need to take the tree_lock.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/cacheflush.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index bef9f418f089..550b0abea953 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -137,10 +137,8 @@ static inline void __flush_icache_all(void)
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

