From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 43/73] shmem: Convert find_swap_entry to XArray
Date: Tue,  5 Dec 2017 16:41:29 -0800
Message-ID: <20171206004159.3755-44-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NsF3Q07wK7sqwJlZdc6Jj2LkQ/fit6eDQPiulV2NoKI=; b=u5cvo1YT/aXRHniXUN4HuYern
        Un4Ls3jO1YkJ+VtVTnb3dxYPNFp+TkbXYRT8fuZhvJnn3+VC6cz2+OZM45qzr4FPN8aHgyKfGFht4
        FkR2xjLuNuRtwrh0l9aJvxaMJiAYGaoQ2+EVi3YzCEvNpoi66cptKcK5+56LPuR2jo6/M9uWUFkNP
        jGy6ezgaB6V9AsK/J8qgMa4tWdPSy2VBy4uXDANk3QNSkN8sE4vJVj4qHH+cp4VeqZAX/rIYAqOJy
        XEO7rD1Ch/rflZiKgIq+YXwgzMtqdg154EZl8IzwYbHFMvKfJgovHGQj1eR+5DRoZT8mqmM8rPcel
    
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This is a 1:1 conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 654f367aca90..ce285ae635ea 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1076,28 +1076,27 @@ static void shmem_evict_inode(struct inode *inode)
 	clear_inode(inode);
 }
 
-static unsigned long find_swap_entry(struct radix_tree_root *root, void *item)
+static unsigned long find_swap_entry(struct xarray *xa, void *item)
 {
-	struct radix_tree_iter iter;
-	void **slot;
-	unsigned long found = -1;
+	XA_STATE(xas, xa, 0);
 	unsigned int checked = 0;
+	void *entry;
 
 	rcu_read_lock();
-	radix_tree_for_each_slot(slot, root, &iter, 0) {
-		if (*slot == item) {
-			found = iter.index;
+	xas_for_each(&xas, entry, ULONG_MAX) {
+		if (xas_retry(&xas, entry))
+			continue;
+		if (entry == item)
 			break;
-		}
 		checked++;
-		if ((checked % 4096) != 0)
+		if ((checked % XA_CHECK_SCHED) != 0)
 			continue;
-		slot = radix_tree_iter_resume(slot, &iter);
+		xas_pause(&xas);
 		cond_resched_rcu();
 	}
-
 	rcu_read_unlock();
-	return found;
+
+	return xas_invalid(&xas) ? -1 : xas.xa_index;
 }
 
 /*
-- 
2.15.0

