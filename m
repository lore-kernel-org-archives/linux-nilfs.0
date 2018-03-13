From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 60/61] page cache: Finish XArray conversion
Date: Tue, 13 Mar 2018 06:26:38 -0700
Message-ID: <20180313132639.17387-61-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KzTYBxjVRP5/cEfay4uXpkGsJ3YsY4GVKGNdxVEajyc=; b=emu7MPbLypAkIu602ToXiw7ta
        0Gzq9dZaUJ/XMcwWoxVxRI4y0kzBExU3m0P22Fi9nz5N3VnmB4FDRiJd6Ej7wmNH9q6NMC6YkotVP
        Hy0xQdHOGY+klAfel6NwRRDnen29Sfmwo/8i3oKsvDv8n27CmYYW86h1BmuDHQG2VAk6p6UU1eNOt
        heSAQFEI13VpVLHluR3tiIEfY62DcyXui0q8vxDi8CaoDftz7gpJeMGraegWuVdE1MkcRSAdufVeP
        CRNKLBOTl+Xg3ubp1tHc7jfkIBhu7HyWx0KtaXwkHMQ7OU2ImrK4Yk/2jlxGC4MFbrgGi3GBJct3J
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

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
2.16.1

