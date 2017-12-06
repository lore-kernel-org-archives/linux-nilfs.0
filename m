From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 42/73] shmem: Convert shmem_confirm_swap to XArray
Date: Tue,  5 Dec 2017 16:41:28 -0800
Message-ID: <20171206004159.3755-43-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9zH+nRyVzTTh7t9wL6AH6uddurzk3DzHsjvNGpwVmLg=; b=fKzQtgr1vbuj+q31onnB7vHa/
        RfjXW0TlX5HM2q4Rr0t/WVL6kn2XNxeLH1JSOO5LJH8X+abAjowAKIGf97NYeFhUY44gBwRHJKuy8
        2+9KappijsIpYjdwAVFOQFyOZasblozChfXxC1jeyVebrhVRhA3/rySPARzDTC3m3LkT8+Uwrch/x
        x2AHlgF3xzXJ7uKP2RJhH1xLsaJl65NDU9d1O7CC1G2Eb9HUVmAMiNW1cKRvNm0B+u+Uuk4HGvPZR
        bbP9UIkk6L+KXYHnk8UP+WhSwWIV3iyHkT9wwIMRiyvLfYi0G+W7ccbrWs3Wy0vg7GaCpek/HrnRr
    
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

xa_load has its own RCU locking, so we can eliminate it here.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fad6c9e7402e..654f367aca90 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -348,12 +348,7 @@ static int shmem_xa_replace(struct address_space *mapping,
 static bool shmem_confirm_swap(struct address_space *mapping,
 			       pgoff_t index, swp_entry_t swap)
 {
-	void *item;
-
-	rcu_read_lock();
-	item = radix_tree_lookup(&mapping->pages, index);
-	rcu_read_unlock();
-	return item == swp_to_radix_entry(swap);
+	return xa_load(&mapping->pages, index) == swp_to_radix_entry(swap);
 }
 
 /*
-- 
2.15.0

