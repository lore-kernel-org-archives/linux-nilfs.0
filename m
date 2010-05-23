From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: fix style issue in nilfs_destroy_cachep
Date: Sun, 23 May 2010 21:27:54 +0900
Message-ID: <1274617675-13663-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This gets rid of unwanted space chars in front of conditional
sentences of nilfs_destroy_cachep().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 03b34b7..414ef68 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1130,13 +1130,13 @@ static void nilfs_segbuf_init_once(void *obj)
 
 static void nilfs_destroy_cachep(void)
 {
-	 if (nilfs_inode_cachep)
+	if (nilfs_inode_cachep)
 		kmem_cache_destroy(nilfs_inode_cachep);
-	 if (nilfs_transaction_cachep)
+	if (nilfs_transaction_cachep)
 		kmem_cache_destroy(nilfs_transaction_cachep);
-	 if (nilfs_segbuf_cachep)
+	if (nilfs_segbuf_cachep)
 		kmem_cache_destroy(nilfs_segbuf_cachep);
-	 if (nilfs_btree_path_cache)
+	if (nilfs_btree_path_cache)
 		kmem_cache_destroy(nilfs_btree_path_cache);
 }
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
