From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: fix missing block address termination in btree node shrinking
Date: Thu, 26 May 2011 00:22:42 +0900
Message-ID: <1306336962-14030-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

nilfs_btree_delete function does not terminate part of virtual block
addresses when shrinking the last remaining child node into the root
node.  The missing address termination causes that dead btree node
blocks persist and chip away free disk space.

This fixes the leak bug on the btree node deletion.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index fd4f05b..b2e3ff3 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1346,6 +1346,11 @@ static void nilfs_btree_shrink(struct nilfs_bmap *btree,
 	path[level].bp_bh = NULL;
 }
 
+static void nilfs_btree_nop(struct nilfs_bmap *btree,
+			    struct nilfs_btree_path *path,
+			    int level, __u64 *keyp, __u64 *ptrp)
+{
+}
 
 static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 				      struct nilfs_btree_path *path,
@@ -1439,16 +1444,22 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 			    NILFS_BTREE_ROOT_NCHILDREN_MAX) {
 				path[level].bp_op = nilfs_btree_shrink;
 				stats->bs_nblocks += 2;
+				level++;
+				path[level].bp_op = nilfs_btree_nop;
+				goto shrink_root_child;
 			} else {
 				path[level].bp_op = nilfs_btree_do_delete;
 				stats->bs_nblocks++;
+				goto out;
 			}
-
-			goto out;
-
 		}
 	}
 
+	/* child of the root node is deleted */
+	path[level].bp_op = nilfs_btree_do_delete;
+	stats->bs_nblocks++;
+
+shrink_root_child:
 	node = nilfs_btree_get_root(btree);
 	path[level].bp_oldreq.bpr_ptr =
 		nilfs_btree_node_get_ptr(node, dindex,
@@ -1458,10 +1469,6 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 	if (ret < 0)
 		goto err_out_child_node;
 
-	/* child of the root node is deleted */
-	path[level].bp_op = nilfs_btree_do_delete;
-	stats->bs_nblocks++;
-
 	/* success */
  out:
 	*levelp = level;
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
