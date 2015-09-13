From: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Subject: [PATCH 02/39] nilfs2: drop null test before destroy functions
Date: Sun, 13 Sep 2015 14:14:55 +0200
Message-ID: <1442146532-9100-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442146532-9100-1-git-send-email-Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Remove unneeded NULL test.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ expression x; @@
-if (x != NULL)
  \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>

---
 fs/nilfs2/super.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f47585b..c69455a 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1405,14 +1405,10 @@ static void nilfs_destroy_cachep(void)
 	 */
 	rcu_barrier();
 
-	if (nilfs_inode_cachep)
-		kmem_cache_destroy(nilfs_inode_cachep);
-	if (nilfs_transaction_cachep)
-		kmem_cache_destroy(nilfs_transaction_cachep);
-	if (nilfs_segbuf_cachep)
-		kmem_cache_destroy(nilfs_segbuf_cachep);
-	if (nilfs_btree_path_cache)
-		kmem_cache_destroy(nilfs_btree_path_cache);
+	kmem_cache_destroy(nilfs_inode_cachep);
+	kmem_cache_destroy(nilfs_transaction_cachep);
+	kmem_cache_destroy(nilfs_segbuf_cachep);
+	kmem_cache_destroy(nilfs_btree_path_cache);
 }
 
 static int __init nilfs_init_cachep(void)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
