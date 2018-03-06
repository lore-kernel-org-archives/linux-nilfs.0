From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 62/63] page cache: Finish XArray conversion
Date: Tue,  6 Mar 2018 11:24:12 -0800
Message-ID: <20180306192413.5499-63-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4ef3ULN8vqN/jL+gDysrRTeOdOMCgny0ObqrINpLEro=; b=BA2iZ3osC7rXlt6Mj7CwXck7T
        qgULD8l4h3GvMusZ2vuIg8eOko6/lNH7GOlTxq/z7VUJJkM03DiwMgP/EmfWuXQ4srPHoAlqzTX/M
        LYizJKeBXsohG3cSxgy/RKjBnax4+EVTARwlry/LMx58ytVtuaWKXAC88SrU68BU60AY3YKwrqF6F
        n/mc3b1+eHkJgSgEdynFEVO+YHCMGSJ7tV4OKUQCdlfCPyTBCQCycVLPhXWaphUTLa17bhFqej1be
        x/LnIKWNuYiY7yN2bPPERzy14aPX/mDE6eETjPChykVhsww4DCoiL5Ithgx70GsTUvlb8e0I+dCTS
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

With no more radix tree API users left, we can drop the GFP flags
and use xa_init() instead of INIT_RADIX_TREE().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/inode.c      | 2 +-
 mm/swap_state.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 14d938e2c9a2..6dcbb1b47fb7 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -349,7 +349,7 @@ EXPORT_SYMBOL(inc_nlink);
 void address_space_init_once(struct address_space *mapping)
 {
 	memset(mapping, 0, sizeof(*mapping));
-	INIT_RADIX_TREE(&mapping->i_pages, GFP_ATOMIC | __GFP_ACCOUNT);
+	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ);
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->private_list);
 	spin_lock_init(&mapping->private_lock);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 21218f6e438b..ebf837d13d2d 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -595,7 +595,7 @@ int init_swap_address_space(unsigned int type, unsigned long nr_pages)
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

