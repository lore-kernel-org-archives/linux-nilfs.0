From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 07/17] nilfs2: remove nilfs_bmap_put_block
Date: Mon, 25 May 2009 19:18:11 +0900
Message-ID: <1243246701-5193-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1243246701-5193-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1243246701-5193-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_bmap_put_block() is a wrapper function calling brelse().  This
eliminates the wrapper for simplicity.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c  |    6 ------
 fs/nilfs2/bmap.h  |    1 -
 fs/nilfs2/btree.c |   33 ++++++++++++++++-----------------
 3 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 4f2523f..ee9914a 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -424,12 +424,6 @@ int nilfs_bmap_get_block(const struct nilfs_bmap *bmap, __u64 ptr,
 				ptr, 0, bhp, 0);
 }
 
-void nilfs_bmap_put_block(const struct nilfs_bmap *bmap,
-			  struct buffer_head *bh)
-{
-	brelse(bh);
-}
-
 int nilfs_bmap_get_new_block(const struct nilfs_bmap *bmap, __u64 ptr,
 			     struct buffer_head **bhp)
 {
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index ad251d3..5b580b8 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -204,7 +204,6 @@ void nilfs_bmap_sub_blocks(const struct nilfs_bmap *, int);
 
 int nilfs_bmap_get_block(const struct nilfs_bmap *, __u64,
 			 struct buffer_head **);
-void nilfs_bmap_put_block(const struct nilfs_bmap *, struct buffer_head *);
 int nilfs_bmap_get_new_block(const struct nilfs_bmap *, __u64,
 			     struct buffer_head **);
 void nilfs_bmap_delete_block(const struct nilfs_bmap *, struct buffer_head *);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 959e5a7..102e218 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -109,8 +109,7 @@ static void nilfs_btree_clear_path(const struct nilfs_btree *btree,
 	     level < NILFS_BTREE_LEVEL_MAX;
 	     level++) {
 		if (path[level].bp_bh != NULL) {
-			nilfs_bmap_put_block(&btree->bt_bmap,
-					     path[level].bp_bh);
+			brelse(path[level].bp_bh);
 			path[level].bp_bh = NULL;
 		}
 		/* sib_bh is released or deleted by prepare or commit
@@ -669,13 +668,13 @@ static void nilfs_btree_carry_left(struct nilfs_btree *btree,
 				nilfs_btree_node_get_key(btree, node, 0));
 
 	if (move) {
-		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_bh);
+		brelse(path[level].bp_bh);
 		path[level].bp_bh = path[level].bp_sib_bh;
 		path[level].bp_sib_bh = NULL;
 		path[level].bp_index += lnchildren;
 		path[level + 1].bp_index--;
 	} else {
-		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
+		brelse(path[level].bp_sib_bh);
 		path[level].bp_sib_bh = NULL;
 		path[level].bp_index -= n;
 	}
@@ -722,14 +721,14 @@ static void nilfs_btree_carry_right(struct nilfs_btree *btree,
 	path[level + 1].bp_index--;
 
 	if (move) {
-		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_bh);
+		brelse(path[level].bp_bh);
 		path[level].bp_bh = path[level].bp_sib_bh;
 		path[level].bp_sib_bh = NULL;
 		path[level].bp_index -=
 			nilfs_btree_node_get_nchildren(btree, node);
 		path[level + 1].bp_index++;
 	} else {
-		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
+		brelse(path[level].bp_sib_bh);
 		path[level].bp_sib_bh = NULL;
 	}
 
@@ -781,7 +780,7 @@ static void nilfs_btree_split(struct nilfs_btree *btree,
 		*keyp = nilfs_btree_node_get_key(btree, right, 0);
 		*ptrp = path[level].bp_newreq.bpr_ptr;
 
-		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_bh);
+		brelse(path[level].bp_bh);
 		path[level].bp_bh = path[level].bp_sib_bh;
 		path[level].bp_sib_bh = NULL;
 	} else {
@@ -790,7 +789,7 @@ static void nilfs_btree_split(struct nilfs_btree *btree,
 		*keyp = nilfs_btree_node_get_key(btree, right, 0);
 		*ptrp = path[level].bp_newreq.bpr_ptr;
 
-		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
+		brelse(path[level].bp_sib_bh);
 		path[level].bp_sib_bh = NULL;
 	}
 
@@ -936,7 +935,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 				stats->bs_nblocks++;
 				goto out;
 			} else
-				nilfs_bmap_put_block(&btree->bt_bmap, bh);
+				brelse(bh);
 		}
 
 		/* right sibling */
@@ -956,7 +955,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 				stats->bs_nblocks++;
 				goto out;
 			} else
-				nilfs_bmap_put_block(&btree->bt_bmap, bh);
+				brelse(bh);
 		}
 
 		/* split */
@@ -1153,7 +1152,7 @@ static void nilfs_btree_borrow_left(struct nilfs_btree *btree,
 	nilfs_btree_promote_key(btree, path, level + 1,
 				nilfs_btree_node_get_key(btree, node, 0));
 
-	nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
+	brelse(path[level].bp_sib_bh);
 	path[level].bp_sib_bh = NULL;
 	path[level].bp_index += n;
 }
@@ -1192,7 +1191,7 @@ static void nilfs_btree_borrow_right(struct nilfs_btree *btree,
 				nilfs_btree_node_get_key(btree, right, 0));
 	path[level + 1].bp_index--;
 
-	nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
+	brelse(path[level].bp_sib_bh);
 	path[level].bp_sib_bh = NULL;
 }
 
@@ -1403,7 +1402,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 			&btree->bt_bmap, &path[level].bp_oldreq);
  err_out_child_node:
 	for (level--; level >= NILFS_BTREE_LEVEL_NODE_MIN; level--) {
-		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
+		brelse(path[level].bp_sib_bh);
 		if (btree->bt_bmap.b_pops->bpop_abort_end_ptr != NULL)
 			btree->bt_bmap.b_pops->bpop_abort_end_ptr(
 				&btree->bt_bmap, &path[level].bp_oldreq);
@@ -1515,7 +1514,7 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *bmap, __u64 key)
 	nextmaxkey = (nchildren > 1) ?
 		nilfs_btree_node_get_key(btree, node, nchildren - 2) : 0;
 	if (bh != NULL)
-		nilfs_bmap_put_block(bmap, bh);
+		brelse(bh);
 
 	return (maxkey == key) && (nextmaxkey < bmap->b_low);
 }
@@ -1563,7 +1562,7 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *bmap,
 	}
 
 	if (bh != NULL)
-		nilfs_bmap_put_block(bmap, bh);
+		brelse(bh);
 
 	return nitems;
 }
@@ -1661,7 +1660,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 			nilfs_bmap_set_dirty(bmap);
 
 		unlock_buffer(bh);
-		nilfs_bmap_put_block(bmap, bh);
+		brelse(bh);
 
 		/* create root node at level 2 */
 		node = nilfs_btree_get_root(btree);
@@ -2176,7 +2175,7 @@ static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 
 	if (!buffer_dirty(bh))
 		nilfs_btnode_mark_dirty(bh);
-	nilfs_bmap_put_block(&btree->bt_bmap, bh);
+	brelse(bh);
 	if (!nilfs_bmap_dirty(&btree->bt_bmap))
 		nilfs_bmap_set_dirty(&btree->bt_bmap);
 
-- 
1.6.2
