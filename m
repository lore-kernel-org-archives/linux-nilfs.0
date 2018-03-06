From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 46/63] shmem: Convert shmem_confirm_swap to XArray
Date: Tue,  6 Mar 2018 11:23:56 -0800
Message-ID: <20180306192413.5499-47-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=03pTud/1qACkCUUsdo0GFSxlZtWKgSD/sjY7c1IOHPA=; b=PynNqF5d3h4cJ/6zxY0nOnM+R
        KM0rIimbunb0M2z8uvq7OLVke/lamYdDVB68TKw+6Gq2JCSrMnseUvm82SLOXLMQqz+44QISy3/ky
        R54xqftqaUCOawMKEiVyjC72fIXziS+83FOVpHJe9SJn8ZIakhdSDZR4P729kt+gfhInP1Sfz7HGj
        0GO4jdWn25tbmpL+rxU2ezg2u63pF1VH1+B1QsIS/EwPJxmC6x2rxhN3xHv7YqJAxRsuWnJifxuuQ
        zjJFeQtbkDUaEzlzgxFdNqD904BEqNTF1VrzaWnBAjRzLEwG4cUmaRi8qSRjVuMAj612IFx4kJlzM
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

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

