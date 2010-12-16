From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix regression of garbage collection ioctl
Date: Thu, 16 Dec 2010 14:05:41 +0900
Message-ID: <1292475941-6328-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

On 2.6.37-rc1, garbage collection ioctl of nilfs was broken due to the
commit 263d90cefc7d82a0 ("nilfs2: remove own inode hash used for GC"),
and are leading to filesystem corruption.

The patch doesn't queue gc-inodes for log writer if they are reused
through the vfs inode cache.  Here, gc-inode is the inode which
buffers blocks to be relocated on GC.  That patch queues gc-inodes in
nilfs_init_gcinode() function, but this function is not called when
they don't have I_NEW flag.  Thus, some of live blocks are wrongly
overrode without being moved to new logs.

This resolves the problem by moving the gc-inode queueing to an outer
function to ensure it's done right.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/gcinode.c |    9 ---------
 fs/nilfs2/ioctl.c   |   12 ++++++++++++
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 33ad25d..caf9a6a 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -176,7 +176,6 @@ int nilfs_gccache_wait_and_mark_dirty(struct buffer_head *bh)
 int nilfs_init_gcinode(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
 
 	inode->i_mode = S_IFREG;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
@@ -186,14 +185,6 @@ int nilfs_init_gcinode(struct inode *inode)
 	ii->i_flags = 0;
 	nilfs_bmap_init_gc(ii->i_bmap);
 
-	/*
-	 * Add the inode to GC inode list. Garbage Collection
-	 * is serialized and no two processes manipulate the
-	 * list simultaneously.
-	 */
-	igrab(inode);
-	list_add(&NILFS_I(inode)->i_dirty, &nilfs->ns_gc_inodes);
-
 	return 0;
 }
 
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index e00d945..b185e93 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -337,6 +337,7 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
 				   struct nilfs_argv *argv, void *buf)
 {
 	size_t nmembs = argv->v_nmembs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct inode *inode;
 	struct nilfs_vdesc *vdesc;
 	struct buffer_head *bh, *n;
@@ -353,6 +354,17 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
 			ret = PTR_ERR(inode);
 			goto failed;
 		}
+		if (list_empty(&NILFS_I(inode)->i_dirty)) {
+			/*
+			 * Add the inode to GC inode list. Garbage Collection
+			 * is serialized and no two processes manipulate the
+			 * list simultaneously.
+			 */
+			igrab(inode);
+			list_add(&NILFS_I(inode)->i_dirty,
+				 &nilfs->ns_gc_inodes);
+		}
+
 		do {
 			ret = nilfs_ioctl_move_inode_block(inode, vdesc,
 							   &buffers);
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
