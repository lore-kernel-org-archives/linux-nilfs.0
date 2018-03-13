From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 37/61] mm: Convert __do_page_cache_readahead to XArray
Date: Tue, 13 Mar 2018 06:26:15 -0700
Message-ID: <20180313132639.17387-38-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Dnse6NpPcxn4uwM47SH2ODqvDBOEEd/I1UOPFvRSo1Q=; b=jp9oe7whrexJcmXbOQw0tnU43
        q/fYHvCEOMh/0BWOXzQQKRcDEaVKWODRmmFZVCUOUpgUh8tMcg4p9ukBc3r9fZWjpv/0pdIa97kfE
        s6oNO4ZblTg6Q7ZX+x3QxwpV1AMf21V/hjbtqohN+j0ID2nBim0SWgSUVW4nlNIbnpckLyrE/MM09
        DasUr4NPwIaW4Kdm/JeuzmDOwLTREM72fRkNG7WkkYx40YpHGDpjHNxVpbgSkj3MFyy2XjjRJ70L9
        Nd+lTP1ch2SE3XX9AxtjkiF9qybkRyoNs3sM0ftMtjLlP5SWV4W8/ZZoE92PzCdnUvXlRvz5J+QH9
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This one is trivial.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/readahead.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 3ff9763b0461..5f528d649d5e 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -174,9 +174,7 @@ int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 		if (page_offset > end_index)
 			break;
 
-		rcu_read_lock();
-		page = radix_tree_lookup(&mapping->i_pages, page_offset);
-		rcu_read_unlock();
+		page = xa_load(&mapping->i_pages, page_offset);
 		if (page && !xa_is_value(page))
 			continue;
 
-- 
2.16.1

