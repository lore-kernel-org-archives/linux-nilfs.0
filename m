From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 51/63] shmem: Convert shmem_partial_swap_usage to XArray
Date: Tue,  6 Mar 2018 11:24:01 -0800
Message-ID: <20180306192413.5499-52-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ilG1gJosbTyyuNQT1Kd+mdCYou0B9zfa+ME2Qhkq8Tw=; b=R7+6Q0NFM5G/O7qhKU1uiccms
        J7aG9DDyd3IDZiSH5qaoB7/GaZ5wz8um44hEogw5y2smJskpY5vZDE/W7EWRnBwAwrHUGfKe1GuQn
        awiCKRw0Y6JXsaJyitRRnjSQMuwTow3D0bjrPJceh18ZDVq2xX7tBnfCGDoUn+gv5YdWgWBoAZc9u
        K2wkD0pm7Xm2mvTjJmKAIiITyNGZTW7xTabYhtvUA/I+e2dco54HIWazb5yw8BW73Jzig/Zks7Rrd
        rRltG8RP5sA6uM4kjeUvqYMaPNT4N1uLG00fu0DlIeHuyPpdodowUEPeVyulNALRdxa+9NgkYJTvo
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Simpler code because the xarray takes care of things like the limit and
dereferencing the slot.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index cfbffb4b47a2..707430003ec7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -658,29 +658,17 @@ static int shmem_free_swap(struct address_space *mapping,
 unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 						pgoff_t start, pgoff_t end)
 {
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
 	unsigned long swapped = 0;
 
 	rcu_read_lock();
-
-	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
-		if (iter.index >= end)
-			break;
-
-		page = radix_tree_deref_slot(slot);
-
-		if (radix_tree_deref_retry(page)) {
-			slot = radix_tree_iter_retry(&iter);
-			continue;
-		}
-
+	xas_for_each(&xas, page, end - 1) {
 		if (xa_is_value(page))
 			swapped++;
 
 		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
+			xas_pause(&xas);
 			cond_resched_rcu();
 		}
 	}
-- 
2.16.1

