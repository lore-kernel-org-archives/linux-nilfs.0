From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: fix incorrect block address termination in node concatenation
Date: Thu, 26 May 2011 00:22:41 +0900
Message-ID: <1306336962-14030-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1306336962-14030-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1306336962-14030-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_btree_delete function wrongly terminates virtual block address
of the btree node held by its parent at index 0.  When concatenating
the index-0 node with its right sibling node, nilfs_btree_delete
terminates the block address of index-0 node instead of the right
sibling node which should be deleted.

This bug not only wears disk space in the long run, but also causes
file system corruption.  This will fix it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 7eafe46..fd4f05b 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1356,20 +1356,19 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 	struct buffer_head *bh;
 	struct nilfs_btree_node *node, *parent, *sib;
 	__u64 sibptr;
-	int pindex, level, ncmin, ncmax, ncblk, ret;
+	int pindex, dindex, level, ncmin, ncmax, ncblk, ret;
 
 	ret = 0;
 	stats->bs_nblocks = 0;
 	ncmin = NILFS_BTREE_NODE_NCHILDREN_MIN(nilfs_btree_node_size(btree));
 	ncblk = nilfs_btree_nchildren_per_block(btree);
 
-	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
+	for (level = NILFS_BTREE_LEVEL_NODE_MIN, dindex = path[level].bp_index;
 	     level < nilfs_btree_height(btree) - 1;
 	     level++) {
 		node = nilfs_btree_get_nonroot_node(path, level);
 		path[level].bp_oldreq.bpr_ptr =
-			nilfs_btree_node_get_ptr(node, path[level].bp_index,
-						 ncblk);
+			nilfs_btree_node_get_ptr(node, dindex, ncblk);
 		ret = nilfs_bmap_prepare_end_ptr(btree,
 						 &path[level].bp_oldreq, dat);
 		if (ret < 0)
@@ -1383,6 +1382,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 
 		parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
 		pindex = path[level + 1].bp_index;
+		dindex = pindex;
 
 		if (pindex > 0) {
 			/* left sibling */
@@ -1421,6 +1421,14 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 				path[level].bp_sib_bh = bh;
 				path[level].bp_op = nilfs_btree_concat_right;
 				stats->bs_nblocks++;
+				/*
+				 * When merging right sibling node
+				 * into the current node, pointer to
+				 * the right sibling node must be
+				 * terminated instead.  The adjustment
+				 * below is required for that.
+				 */
+				dindex = pindex + 1;
 				/* continue; */
 			}
 		} else {
@@ -1443,7 +1451,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 
 	node = nilfs_btree_get_root(btree);
 	path[level].bp_oldreq.bpr_ptr =
-		nilfs_btree_node_get_ptr(node, path[level].bp_index,
+		nilfs_btree_node_get_ptr(node, dindex,
 					 NILFS_BTREE_ROOT_NCHILDREN_MAX);
 
 	ret = nilfs_bmap_prepare_end_ptr(btree, &path[level].bp_oldreq, dat);
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
