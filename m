From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/6] nilfs2: allow nilfs_destroy_inode to destroy metadata file inodes
Date: Sun, 22 Aug 2010 19:05:01 +0900
Message-ID: <1282471506-29618-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282471506-29618-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The current nilfs_destroy_inode() doesn't handle metadata file inodes
including gc inodes (dummy inodes used for garbage collection).

This allows nilfs_destroy_inode() to destroy inodes of metadata files.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.c   |    2 --
 fs/nilfs2/super.c |    6 ++++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index d01aff4..ee943a3 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -577,7 +577,5 @@ void nilfs_mdt_destroy(struct inode *inode)
 		nilfs_palloc_destroy_cache(inode);
 	nilfs_mdt_clear(inode);
 
-	kfree(mdi->mi_bgl); /* kfree(NULL) is safe */
-	kfree(mdi);
 	nilfs_destroy_inode(inode);
 }
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 9222633..6febd32 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -168,6 +168,12 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
 
 void nilfs_destroy_inode(struct inode *inode)
 {
+	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
+
+	if (mdi) {
+		kfree(mdi->mi_bgl); /* kfree(NULL) is safe */
+		kfree(mdi);
+	}
 	kmem_cache_free(nilfs_inode_cachep, NILFS_I(inode));
 }
 
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
