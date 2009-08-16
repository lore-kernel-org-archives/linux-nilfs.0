From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 6/7] nilfs2: allow btree code to directly call
	dat operations
Date: Sun, 16 Aug 2009 15:51:09 +0900
Message-ID: <1250405470-23326-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1250405470-23326-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1250405470-23326-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

The current btree code is written so that btree functions call dat
operations via wrapper functions in bmap.c when they allocate, free,
or modify virtual block addresses.

This abstraction requires additional function calls and causes
frequent call of nilfs_bmap_get_dat() function since it is used in the
every wrapper function.

This removes the wrapper functions and makes them available from
btree.c and direct.c, which will increase the opportunity of
compiler optimization.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c   |   85 ---------------------------
 fs/nilfs2/bmap.h   |   69 ++++++++--------------
 fs/nilfs2/btree.c  |  151 +++++++++++++++++++++++++++----------------------
 fs/nilfs2/direct.c |  161 +++++++++++++++++++---------------------------------
 4 files changed, 167 insertions(+), 299 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 13e95a9..f98c5c4 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -469,91 +469,6 @@ __u64 nilfs_bmap_find_target_in_group(const struct nilfs_bmap *bmap)
 		(entries_per_group / NILFS_BMAP_GROUP_DIV);
 }
 
-int nilfs_bmap_prepare_alloc_v(struct nilfs_bmap *bmap,
-				 union nilfs_bmap_ptr_req *req)
-{
-	return nilfs_dat_prepare_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
-}
-
-void nilfs_bmap_commit_alloc_v(struct nilfs_bmap *bmap,
-				 union nilfs_bmap_ptr_req *req)
-{
-	nilfs_dat_commit_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
-}
-
-void nilfs_bmap_abort_alloc_v(struct nilfs_bmap *bmap,
-			      union nilfs_bmap_ptr_req *req)
-{
-	nilfs_dat_abort_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
-}
-
-int nilfs_bmap_start_v(struct nilfs_bmap *bmap, union nilfs_bmap_ptr_req *req,
-		       sector_t blocknr)
-{
-	struct inode *dat = nilfs_bmap_get_dat(bmap);
-	int ret;
-
-	ret = nilfs_dat_prepare_start(dat, &req->bpr_req);
-	if (likely(!ret))
-		nilfs_dat_commit_start(dat, &req->bpr_req, blocknr);
-	return ret;
-}
-
-int nilfs_bmap_prepare_end_v(struct nilfs_bmap *bmap,
-			     union nilfs_bmap_ptr_req *req)
-{
-	return nilfs_dat_prepare_end(nilfs_bmap_get_dat(bmap), &req->bpr_req);
-}
-
-void nilfs_bmap_commit_end_v(struct nilfs_bmap *bmap,
-			     union nilfs_bmap_ptr_req *req)
-{
-	nilfs_dat_commit_end(nilfs_bmap_get_dat(bmap), &req->bpr_req,
-			     bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
-}
-
-void nilfs_bmap_abort_end_v(struct nilfs_bmap *bmap,
-			    union nilfs_bmap_ptr_req *req)
-{
-	nilfs_dat_abort_end(nilfs_bmap_get_dat(bmap), &req->bpr_req);
-}
-
-int nilfs_bmap_move_v(const struct nilfs_bmap *bmap, __u64 vblocknr,
-		      sector_t blocknr)
-{
-	return nilfs_dat_move(nilfs_bmap_get_dat(bmap), vblocknr, blocknr);
-}
-
-int nilfs_bmap_mark_dirty(const struct nilfs_bmap *bmap, __u64 vblocknr)
-{
-	return nilfs_dat_mark_dirty(nilfs_bmap_get_dat(bmap), vblocknr);
-}
-
-int nilfs_bmap_prepare_update_v(struct nilfs_bmap *bmap,
-				union nilfs_bmap_ptr_req *oldreq,
-				union nilfs_bmap_ptr_req *newreq)
-{
-	return nilfs_dat_prepare_update(nilfs_bmap_get_dat(bmap),
-					&oldreq->bpr_req, &newreq->bpr_req);
-}
-
-void nilfs_bmap_commit_update_v(struct nilfs_bmap *bmap,
-				union nilfs_bmap_ptr_req *oldreq,
-				union nilfs_bmap_ptr_req *newreq)
-{
-	nilfs_dat_commit_update(nilfs_bmap_get_dat(bmap),
-				&oldreq->bpr_req, &newreq->bpr_req,
-				bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
-}
-
-void nilfs_bmap_abort_update_v(struct nilfs_bmap *bmap,
-			       union nilfs_bmap_ptr_req *oldreq,
-			       union nilfs_bmap_ptr_req *newreq)
-{
-	nilfs_dat_abort_update(nilfs_bmap_get_dat(bmap),
-			       &oldreq->bpr_req, &newreq->bpr_req);
-}
-
 static struct lock_class_key nilfs_bmap_dat_lock_key;
 static struct lock_class_key nilfs_bmap_mdt_lock_key;
 
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index b2890cd..a4f64e5 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -28,6 +28,7 @@
 #include <linux/buffer_head.h>
 #include <linux/nilfs2_fs.h>
 #include "alloc.h"
+#include "dat.h"
 
 #define NILFS_BMAP_INVALID_PTR	0
 
@@ -164,86 +165,66 @@ void nilfs_bmap_commit_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
  * Internal use only
  */
 struct inode *nilfs_bmap_get_dat(const struct nilfs_bmap *);
-int nilfs_bmap_prepare_alloc_v(struct nilfs_bmap *,
-			       union nilfs_bmap_ptr_req *);
-void nilfs_bmap_commit_alloc_v(struct nilfs_bmap *,
-			       union nilfs_bmap_ptr_req *);
-void nilfs_bmap_abort_alloc_v(struct nilfs_bmap *,
-			      union nilfs_bmap_ptr_req *);
 
 static inline int nilfs_bmap_prepare_alloc_ptr(struct nilfs_bmap *bmap,
-					       union nilfs_bmap_ptr_req *req)
+					       union nilfs_bmap_ptr_req *req,
+					       struct inode *dat)
 {
-	if (NILFS_BMAP_USE_VBN(bmap))
-		return nilfs_bmap_prepare_alloc_v(bmap, req);
+	if (dat)
+		return nilfs_dat_prepare_alloc(dat, &req->bpr_req);
 	/* ignore target ptr */
 	req->bpr_ptr = bmap->b_last_allocated_ptr++;
 	return 0;
 }
 
 static inline void nilfs_bmap_commit_alloc_ptr(struct nilfs_bmap *bmap,
-					       union nilfs_bmap_ptr_req *req)
+					       union nilfs_bmap_ptr_req *req,
+					       struct inode *dat)
 {
-	if (NILFS_BMAP_USE_VBN(bmap))
-		nilfs_bmap_commit_alloc_v(bmap, req);
+	if (dat)
+		nilfs_dat_commit_alloc(dat, &req->bpr_req);
 }
 
 static inline void nilfs_bmap_abort_alloc_ptr(struct nilfs_bmap *bmap,
-					      union nilfs_bmap_ptr_req *req)
+					      union nilfs_bmap_ptr_req *req,
+					      struct inode *dat)
 {
-	if (NILFS_BMAP_USE_VBN(bmap))
-		nilfs_bmap_abort_alloc_v(bmap, req);
+	if (dat)
+		nilfs_dat_abort_alloc(dat, &req->bpr_req);
 	else
 		bmap->b_last_allocated_ptr--;
 }
 
-int nilfs_bmap_prepare_end_v(struct nilfs_bmap *, union nilfs_bmap_ptr_req *);
-void nilfs_bmap_commit_end_v(struct nilfs_bmap *, union nilfs_bmap_ptr_req *);
-void nilfs_bmap_abort_end_v(struct nilfs_bmap *, union nilfs_bmap_ptr_req *);
-
 static inline int nilfs_bmap_prepare_end_ptr(struct nilfs_bmap *bmap,
-					     union nilfs_bmap_ptr_req *req)
+					     union nilfs_bmap_ptr_req *req,
+					     struct inode *dat)
 {
-	return NILFS_BMAP_USE_VBN(bmap) ?
-		nilfs_bmap_prepare_end_v(bmap, req) : 0;
+	return dat ? nilfs_dat_prepare_end(dat, &req->bpr_req) : 0;
 }
 
 static inline void nilfs_bmap_commit_end_ptr(struct nilfs_bmap *bmap,
-					     union nilfs_bmap_ptr_req *req)
+					     union nilfs_bmap_ptr_req *req,
+					     struct inode *dat)
 {
-	if (NILFS_BMAP_USE_VBN(bmap))
-		nilfs_bmap_commit_end_v(bmap, req);
+	if (dat)
+		nilfs_dat_commit_end(dat, &req->bpr_req,
+				     bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
 }
 
 static inline void nilfs_bmap_abort_end_ptr(struct nilfs_bmap *bmap,
-					    union nilfs_bmap_ptr_req *req)
+					    union nilfs_bmap_ptr_req *req,
+					    struct inode *dat)
 {
-	if (NILFS_BMAP_USE_VBN(bmap))
-		nilfs_bmap_abort_end_v(bmap, req);
+	if (dat)
+		nilfs_dat_abort_end(dat, &req->bpr_req);
 }
 
-int nilfs_bmap_start_v(struct nilfs_bmap *, union nilfs_bmap_ptr_req *,
-		       sector_t);
-int nilfs_bmap_move_v(const struct nilfs_bmap *, __u64, sector_t);
-int nilfs_bmap_mark_dirty(const struct nilfs_bmap *, __u64);
-
-
 __u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *,
 			      const struct buffer_head *);
 
 __u64 nilfs_bmap_find_target_seq(const struct nilfs_bmap *, __u64);
 __u64 nilfs_bmap_find_target_in_group(const struct nilfs_bmap *);
 
-int nilfs_bmap_prepare_update_v(struct nilfs_bmap *,
-				union nilfs_bmap_ptr_req *,
-				union nilfs_bmap_ptr_req *);
-void nilfs_bmap_commit_update_v(struct nilfs_bmap *,
-				union nilfs_bmap_ptr_req *,
-				union nilfs_bmap_ptr_req *);
-void nilfs_bmap_abort_update_v(struct nilfs_bmap *,
-			       union nilfs_bmap_ptr_req *,
-			       union nilfs_bmap_ptr_req *);
-
 void nilfs_bmap_add_blocks(const struct nilfs_bmap *, int);
 void nilfs_bmap_sub_blocks(const struct nilfs_bmap *, int);
 
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 115b157..e25b507 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -940,17 +940,20 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 	struct nilfs_btree_node *node, *parent, *sib;
 	__u64 sibptr;
 	int pindex, level, ret;
+	struct inode *dat = NULL;
 
 	stats->bs_nblocks = 0;
 	level = NILFS_BTREE_LEVEL_DATA;
 
 	/* allocate a new ptr for data block */
-	if (NILFS_BMAP_USE_VBN(&btree->bt_bmap))
+	if (NILFS_BMAP_USE_VBN(&btree->bt_bmap)) {
 		path[level].bp_newreq.bpr_ptr =
 			nilfs_btree_find_target_v(btree, path, key);
+		dat = nilfs_bmap_get_dat(&btree->bt_bmap);
+	}
 
 	ret = nilfs_bmap_prepare_alloc_ptr(&btree->bt_bmap,
-					   &path[level].bp_newreq);
+					   &path[level].bp_newreq, dat);
 	if (ret < 0)
 		goto err_out_data;
 
@@ -1009,7 +1012,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 		path[level].bp_newreq.bpr_ptr =
 			path[level - 1].bp_newreq.bpr_ptr + 1;
 		ret = nilfs_bmap_prepare_alloc_ptr(&btree->bt_bmap,
-						   &path[level].bp_newreq);
+						   &path[level].bp_newreq, dat);
 		if (ret < 0)
 			goto err_out_child_node;
 		ret = nilfs_btree_get_new_block(btree,
@@ -1041,7 +1044,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 	/* grow */
 	path[level].bp_newreq.bpr_ptr = path[level - 1].bp_newreq.bpr_ptr + 1;
 	ret = nilfs_bmap_prepare_alloc_ptr(&btree->bt_bmap,
-					   &path[level].bp_newreq);
+					   &path[level].bp_newreq, dat);
 	if (ret < 0)
 		goto err_out_child_node;
 	ret = nilfs_btree_get_new_block(btree, path[level].bp_newreq.bpr_ptr,
@@ -1069,16 +1072,18 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 
 	/* error */
  err_out_curr_node:
-	nilfs_bmap_abort_alloc_ptr(&btree->bt_bmap, &path[level].bp_newreq);
+	nilfs_bmap_abort_alloc_ptr(&btree->bt_bmap, &path[level].bp_newreq,
+				   dat);
  err_out_child_node:
 	for (level--; level > NILFS_BTREE_LEVEL_DATA; level--) {
 		nilfs_btnode_delete(path[level].bp_sib_bh);
 		nilfs_bmap_abort_alloc_ptr(&btree->bt_bmap,
-					   &path[level].bp_newreq);
+					   &path[level].bp_newreq, dat);
 
 	}
 
-	nilfs_bmap_abort_alloc_ptr(&btree->bt_bmap, &path[level].bp_newreq);
+	nilfs_bmap_abort_alloc_ptr(&btree->bt_bmap, &path[level].bp_newreq,
+				   dat);
  err_out_data:
 	*levelp = level;
 	stats->bs_nblocks = 0;
@@ -1089,16 +1094,19 @@ static void nilfs_btree_commit_insert(struct nilfs_btree *btree,
 				      struct nilfs_btree_path *path,
 				      int maxlevel, __u64 key, __u64 ptr)
 {
+	struct inode *dat = NULL;
 	int level;
 
 	set_buffer_nilfs_volatile((struct buffer_head *)((unsigned long)ptr));
 	ptr = path[NILFS_BTREE_LEVEL_DATA].bp_newreq.bpr_ptr;
-	if (NILFS_BMAP_USE_VBN(&btree->bt_bmap))
+	if (NILFS_BMAP_USE_VBN(&btree->bt_bmap)) {
 		nilfs_btree_set_target_v(btree, key, ptr);
+		dat = nilfs_bmap_get_dat(&btree->bt_bmap);
+	}
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
 		nilfs_bmap_commit_alloc_ptr(&btree->bt_bmap,
-					    &path[level - 1].bp_newreq);
+					    &path[level - 1].bp_newreq, dat);
 		path[level].bp_op(btree, path, level, &key, &ptr);
 	}
 
@@ -1326,7 +1334,8 @@ static void nilfs_btree_shrink(struct nilfs_btree *btree,
 static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 				      struct nilfs_btree_path *path,
 				      int *levelp,
-				      struct nilfs_bmap_stats *stats)
+				      struct nilfs_bmap_stats *stats,
+				      struct inode *dat)
 {
 	struct buffer_head *bh;
 	struct nilfs_btree_node *node, *parent, *sib;
@@ -1343,7 +1352,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 			nilfs_btree_node_get_ptr(btree, node,
 						 path[level].bp_index);
 		ret = nilfs_bmap_prepare_end_ptr(&btree->bt_bmap,
-						 &path[level].bp_oldreq);
+						 &path[level].bp_oldreq, dat);
 		if (ret < 0)
 			goto err_out_child_node;
 
@@ -1421,7 +1430,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 		nilfs_btree_node_get_ptr(btree, node, path[level].bp_index);
 
 	ret = nilfs_bmap_prepare_end_ptr(&btree->bt_bmap,
-					 &path[level].bp_oldreq);
+					 &path[level].bp_oldreq, dat);
 	if (ret < 0)
 		goto err_out_child_node;
 
@@ -1436,12 +1445,12 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 
 	/* error */
  err_out_curr_node:
-	nilfs_bmap_abort_end_ptr(&btree->bt_bmap, &path[level].bp_oldreq);
+	nilfs_bmap_abort_end_ptr(&btree->bt_bmap, &path[level].bp_oldreq, dat);
  err_out_child_node:
 	for (level--; level >= NILFS_BTREE_LEVEL_NODE_MIN; level--) {
 		brelse(path[level].bp_sib_bh);
 		nilfs_bmap_abort_end_ptr(&btree->bt_bmap,
-					 &path[level].bp_oldreq);
+					 &path[level].bp_oldreq, dat);
 	}
 	*levelp = level;
 	stats->bs_nblocks = 0;
@@ -1450,13 +1459,13 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 
 static void nilfs_btree_commit_delete(struct nilfs_btree *btree,
 				      struct nilfs_btree_path *path,
-				      int maxlevel)
+				      int maxlevel, struct inode *dat)
 {
 	int level;
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
 		nilfs_bmap_commit_end_ptr(&btree->bt_bmap,
-					  &path[level].bp_oldreq);
+					  &path[level].bp_oldreq, dat);
 		path[level].bp_op(btree, path, level, NULL, NULL);
 	}
 
@@ -1470,6 +1479,7 @@ static int nilfs_btree_delete(struct nilfs_bmap *bmap, __u64 key)
 	struct nilfs_btree *btree;
 	struct nilfs_btree_path *path;
 	struct nilfs_bmap_stats stats;
+	struct inode *dat;
 	int level, ret;
 
 	btree = (struct nilfs_btree *)bmap;
@@ -1482,10 +1492,14 @@ static int nilfs_btree_delete(struct nilfs_bmap *bmap, __u64 key)
 	if (ret < 0)
 		goto out;
 
-	ret = nilfs_btree_prepare_delete(btree, path, &level, &stats);
+
+	dat = NILFS_BMAP_USE_VBN(&btree->bt_bmap) ?
+		nilfs_bmap_get_dat(&btree->bt_bmap) : NULL;
+
+	ret = nilfs_btree_prepare_delete(btree, path, &level, &stats, dat);
 	if (ret < 0)
 		goto out;
-	nilfs_btree_commit_delete(btree, path, level);
+	nilfs_btree_commit_delete(btree, path, level, dat);
 	nilfs_bmap_sub_blocks(bmap, stats.bs_nblocks);
 
 out:
@@ -1610,18 +1624,20 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
 				       struct nilfs_bmap_stats *stats)
 {
 	struct buffer_head *bh;
-	struct nilfs_btree *btree;
+	struct nilfs_btree *btree = (struct nilfs_btree *)bmap;
+	struct inode *dat = NULL;
 	int ret;
 
-	btree = (struct nilfs_btree *)bmap;
 	stats->bs_nblocks = 0;
 
 	/* for data */
 	/* cannot find near ptr */
-	if (NILFS_BMAP_USE_VBN(bmap))
+	if (NILFS_BMAP_USE_VBN(bmap)) {
 		dreq->bpr_ptr = nilfs_btree_find_target_v(btree, NULL, key);
+		dat = nilfs_bmap_get_dat(bmap);
+	}
 
-	ret = nilfs_bmap_prepare_alloc_ptr(bmap, dreq);
+	ret = nilfs_bmap_prepare_alloc_ptr(bmap, dreq, dat);
 	if (ret < 0)
 		return ret;
 
@@ -1629,7 +1645,7 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
 	stats->bs_nblocks++;
 	if (nreq != NULL) {
 		nreq->bpr_ptr = dreq->bpr_ptr + 1;
-		ret = nilfs_bmap_prepare_alloc_ptr(bmap, nreq);
+		ret = nilfs_bmap_prepare_alloc_ptr(bmap, nreq, dat);
 		if (ret < 0)
 			goto err_out_dreq;
 
@@ -1646,9 +1662,9 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
 
 	/* error */
  err_out_nreq:
-	nilfs_bmap_abort_alloc_ptr(bmap, nreq);
+	nilfs_bmap_abort_alloc_ptr(bmap, nreq, dat);
  err_out_dreq:
-	nilfs_bmap_abort_alloc_ptr(bmap, dreq);
+	nilfs_bmap_abort_alloc_ptr(bmap, dreq, dat);
 	stats->bs_nblocks = 0;
 	return ret;
 
@@ -1663,8 +1679,9 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 				      union nilfs_bmap_ptr_req *nreq,
 				      struct buffer_head *bh)
 {
-	struct nilfs_btree *btree;
+	struct nilfs_btree *btree = (struct nilfs_btree *)bmap;
 	struct nilfs_btree_node *node;
+	struct inode *dat;
 	__u64 tmpptr;
 
 	/* free resources */
@@ -1675,11 +1692,11 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 	set_buffer_nilfs_volatile((struct buffer_head *)((unsigned long)ptr));
 
 	/* convert and insert */
-	btree = (struct nilfs_btree *)bmap;
+	dat = NILFS_BMAP_USE_VBN(bmap) ? nilfs_bmap_get_dat(bmap) : NULL;
 	nilfs_btree_init(bmap);
 	if (nreq != NULL) {
-		nilfs_bmap_commit_alloc_ptr(bmap, dreq);
-		nilfs_bmap_commit_alloc_ptr(bmap, nreq);
+		nilfs_bmap_commit_alloc_ptr(bmap, dreq, dat);
+		nilfs_bmap_commit_alloc_ptr(bmap, nreq, dat);
 
 		/* create child node at level 1 */
 		lock_buffer(bh);
@@ -1701,7 +1718,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 		nilfs_btree_node_init(btree, node, NILFS_BTREE_NODE_ROOT,
 				      2, 1, &keys[0], &tmpptr);
 	} else {
-		nilfs_bmap_commit_alloc_ptr(bmap, dreq);
+		nilfs_bmap_commit_alloc_ptr(bmap, dreq, dat);
 
 		/* create root node at level 1 */
 		node = nilfs_btree_get_root(btree);
@@ -1772,7 +1789,7 @@ static int nilfs_btree_propagate_p(struct nilfs_btree *btree,
 
 static int nilfs_btree_prepare_update_v(struct nilfs_btree *btree,
 					struct nilfs_btree_path *path,
-					int level)
+					int level, struct inode *dat)
 {
 	struct nilfs_btree_node *parent;
 	int ret;
@@ -1782,9 +1799,8 @@ static int nilfs_btree_prepare_update_v(struct nilfs_btree *btree,
 		nilfs_btree_node_get_ptr(btree, parent,
 					 path[level + 1].bp_index);
 	path[level].bp_newreq.bpr_ptr = path[level].bp_oldreq.bpr_ptr + 1;
-	ret = nilfs_bmap_prepare_update_v(&btree->bt_bmap,
-					  &path[level].bp_oldreq,
-					  &path[level].bp_newreq);
+	ret = nilfs_dat_prepare_update(dat, &path[level].bp_oldreq.bpr_req,
+				       &path[level].bp_newreq.bpr_req);
 	if (ret < 0)
 		return ret;
 
@@ -1796,9 +1812,9 @@ static int nilfs_btree_prepare_update_v(struct nilfs_btree *btree,
 			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
 			&path[level].bp_ctxt);
 		if (ret < 0) {
-			nilfs_bmap_abort_update_v(&btree->bt_bmap,
-						  &path[level].bp_oldreq,
-						  &path[level].bp_newreq);
+			nilfs_dat_abort_update(dat,
+					       &path[level].bp_oldreq.bpr_req,
+					       &path[level].bp_newreq.bpr_req);
 			return ret;
 		}
 	}
@@ -1808,13 +1824,13 @@ static int nilfs_btree_prepare_update_v(struct nilfs_btree *btree,
 
 static void nilfs_btree_commit_update_v(struct nilfs_btree *btree,
 					struct nilfs_btree_path *path,
-					int level)
+					int level, struct inode *dat)
 {
 	struct nilfs_btree_node *parent;
 
-	nilfs_bmap_commit_update_v(&btree->bt_bmap,
-				   &path[level].bp_oldreq,
-				   &path[level].bp_newreq);
+	nilfs_dat_commit_update(dat, &path[level].bp_oldreq.bpr_req,
+				&path[level].bp_newreq.bpr_req,
+				btree->bt_bmap.b_ptr_type == NILFS_BMAP_PTR_VS);
 
 	if (buffer_nilfs_node(path[level].bp_bh)) {
 		nilfs_btnode_commit_change_key(
@@ -1831,11 +1847,10 @@ static void nilfs_btree_commit_update_v(struct nilfs_btree *btree,
 
 static void nilfs_btree_abort_update_v(struct nilfs_btree *btree,
 				       struct nilfs_btree_path *path,
-				       int level)
+				       int level, struct inode *dat)
 {
-	nilfs_bmap_abort_update_v(&btree->bt_bmap,
-				  &path[level].bp_oldreq,
-				  &path[level].bp_newreq);
+	nilfs_dat_abort_update(dat, &path[level].bp_oldreq.bpr_req,
+			       &path[level].bp_newreq.bpr_req);
 	if (buffer_nilfs_node(path[level].bp_bh))
 		nilfs_btnode_abort_change_key(
 			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
@@ -1844,14 +1859,14 @@ static void nilfs_btree_abort_update_v(struct nilfs_btree *btree,
 
 static int nilfs_btree_prepare_propagate_v(struct nilfs_btree *btree,
 					   struct nilfs_btree_path *path,
-					   int minlevel,
-					   int *maxlevelp)
+					   int minlevel, int *maxlevelp,
+					   struct inode *dat)
 {
 	int level, ret;
 
 	level = minlevel;
 	if (!buffer_nilfs_volatile(path[level].bp_bh)) {
-		ret = nilfs_btree_prepare_update_v(btree, path, level);
+		ret = nilfs_btree_prepare_update_v(btree, path, level, dat);
 		if (ret < 0)
 			return ret;
 	}
@@ -1859,7 +1874,7 @@ static int nilfs_btree_prepare_propagate_v(struct nilfs_btree *btree,
 	       !buffer_dirty(path[level].bp_bh)) {
 
 		WARN_ON(buffer_nilfs_volatile(path[level].bp_bh));
-		ret = nilfs_btree_prepare_update_v(btree, path, level);
+		ret = nilfs_btree_prepare_update_v(btree, path, level, dat);
 		if (ret < 0)
 			goto out;
 	}
@@ -1871,39 +1886,40 @@ static int nilfs_btree_prepare_propagate_v(struct nilfs_btree *btree,
 	/* error */
  out:
 	while (--level > minlevel)
-		nilfs_btree_abort_update_v(btree, path, level);
+		nilfs_btree_abort_update_v(btree, path, level, dat);
 	if (!buffer_nilfs_volatile(path[level].bp_bh))
-		nilfs_btree_abort_update_v(btree, path, level);
+		nilfs_btree_abort_update_v(btree, path, level, dat);
 	return ret;
 }
 
 static void nilfs_btree_commit_propagate_v(struct nilfs_btree *btree,
 					   struct nilfs_btree_path *path,
-					   int minlevel,
-					   int maxlevel,
-					   struct buffer_head *bh)
+					   int minlevel, int maxlevel,
+					   struct buffer_head *bh,
+					   struct inode *dat)
 {
 	int level;
 
 	if (!buffer_nilfs_volatile(path[minlevel].bp_bh))
-		nilfs_btree_commit_update_v(btree, path, minlevel);
+		nilfs_btree_commit_update_v(btree, path, minlevel, dat);
 
 	for (level = minlevel + 1; level <= maxlevel; level++)
-		nilfs_btree_commit_update_v(btree, path, level);
+		nilfs_btree_commit_update_v(btree, path, level, dat);
 }
 
 static int nilfs_btree_propagate_v(struct nilfs_btree *btree,
 				   struct nilfs_btree_path *path,
-				   int level,
-				   struct buffer_head *bh)
+				   int level, struct buffer_head *bh)
 {
 	int maxlevel, ret;
 	struct nilfs_btree_node *parent;
+	struct inode *dat = nilfs_bmap_get_dat(&btree->bt_bmap);
 	__u64 ptr;
 
 	get_bh(bh);
 	path[level].bp_bh = bh;
-	ret = nilfs_btree_prepare_propagate_v(btree, path, level, &maxlevel);
+	ret = nilfs_btree_prepare_propagate_v(btree, path, level, &maxlevel,
+					      dat);
 	if (ret < 0)
 		goto out;
 
@@ -1911,12 +1927,12 @@ static int nilfs_btree_propagate_v(struct nilfs_btree *btree,
 		parent = nilfs_btree_get_node(btree, path, level + 1);
 		ptr = nilfs_btree_node_get_ptr(btree, parent,
 					       path[level + 1].bp_index);
-		ret = nilfs_bmap_mark_dirty(&btree->bt_bmap, ptr);
+		ret = nilfs_dat_mark_dirty(dat, ptr);
 		if (ret < 0)
 			goto out;
 	}
 
-	nilfs_btree_commit_propagate_v(btree, path, level, maxlevel, bh);
+	nilfs_btree_commit_propagate_v(btree, path, level, maxlevel, bh, dat);
 
  out:
 	brelse(path[level].bp_bh);
@@ -1972,7 +1988,7 @@ static int nilfs_btree_propagate(const struct nilfs_bmap *bmap,
 static int nilfs_btree_propagate_gc(const struct nilfs_bmap *bmap,
 				    struct buffer_head *bh)
 {
-	return nilfs_bmap_mark_dirty(bmap, bh->b_blocknr);
+	return nilfs_dat_mark_dirty(nilfs_bmap_get_dat(bmap), bh->b_blocknr);
 }
 
 static void nilfs_btree_add_dirty_buffer(struct nilfs_btree *btree,
@@ -2086,6 +2102,7 @@ static int nilfs_btree_assign_v(struct nilfs_btree *btree,
 				union nilfs_binfo *binfo)
 {
 	struct nilfs_btree_node *parent;
+	struct inode *dat = nilfs_bmap_get_dat(&btree->bt_bmap);
 	__u64 key;
 	__u64 ptr;
 	union nilfs_bmap_ptr_req req;
@@ -2095,9 +2112,10 @@ static int nilfs_btree_assign_v(struct nilfs_btree *btree,
 	ptr = nilfs_btree_node_get_ptr(btree, parent,
 				       path[level + 1].bp_index);
 	req.bpr_ptr = ptr;
-	ret = nilfs_bmap_start_v(&btree->bt_bmap, &req, blocknr);
-	if (unlikely(ret < 0))
+	ret = nilfs_dat_prepare_start(dat, &req.bpr_req);
+	if (ret < 0)
 		return ret;
+	nilfs_dat_commit_start(dat, &req.bpr_req, blocknr);
 
 	key = nilfs_btree_node_get_key(parent, path[level + 1].bp_index);
 	/* on-disk format */
@@ -2155,13 +2173,12 @@ static int nilfs_btree_assign_gc(struct nilfs_bmap *bmap,
 				 sector_t blocknr,
 				 union nilfs_binfo *binfo)
 {
-	struct nilfs_btree *btree;
 	struct nilfs_btree_node *node;
 	__u64 key;
 	int ret;
 
-	btree = (struct nilfs_btree *)bmap;
-	ret = nilfs_bmap_move_v(bmap, (*bh)->b_blocknr, blocknr);
+	ret = nilfs_dat_move(nilfs_bmap_get_dat(bmap), (*bh)->b_blocknr,
+			     blocknr);
 	if (ret < 0)
 		return ret;
 
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 342d976..d369ac7 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -125,106 +125,64 @@ static void nilfs_direct_set_target_v(struct nilfs_direct *direct,
 	direct->d_bmap.b_last_allocated_ptr = ptr;
 }
 
-static int nilfs_direct_prepare_insert(struct nilfs_direct *direct,
-				       __u64 key,
-				       union nilfs_bmap_ptr_req *req,
-				       struct nilfs_bmap_stats *stats)
-{
-	int ret;
-
-	if (NILFS_BMAP_USE_VBN(&direct->d_bmap))
-		req->bpr_ptr = nilfs_direct_find_target_v(direct, key);
-	ret = nilfs_bmap_prepare_alloc_ptr(&direct->d_bmap, req);
-	if (ret < 0)
-		return ret;
-
-	stats->bs_nblocks = 1;
-	return 0;
-}
-
-static void nilfs_direct_commit_insert(struct nilfs_direct *direct,
-				       union nilfs_bmap_ptr_req *req,
-				       __u64 key, __u64 ptr)
-{
-	struct buffer_head *bh;
-
-	/* ptr must be a pointer to a buffer head. */
-	bh = (struct buffer_head *)((unsigned long)ptr);
-	set_buffer_nilfs_volatile(bh);
-
-	nilfs_bmap_commit_alloc_ptr(&direct->d_bmap, req);
-	nilfs_direct_set_ptr(direct, key, req->bpr_ptr);
-
-	if (!nilfs_bmap_dirty(&direct->d_bmap))
-		nilfs_bmap_set_dirty(&direct->d_bmap);
-
-	if (NILFS_BMAP_USE_VBN(&direct->d_bmap))
-		nilfs_direct_set_target_v(direct, key, req->bpr_ptr);
-}
-
 static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 {
-	struct nilfs_direct *direct;
+	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
 	union nilfs_bmap_ptr_req req;
-	struct nilfs_bmap_stats stats;
+	struct inode *dat = NULL;
+	struct buffer_head *bh;
 	int ret;
 
-	direct = (struct nilfs_direct *)bmap;
 	if (key > NILFS_DIRECT_KEY_MAX)
 		return -ENOENT;
 	if (nilfs_direct_get_ptr(direct, key) != NILFS_BMAP_INVALID_PTR)
 		return -EEXIST;
 
-	ret = nilfs_direct_prepare_insert(direct, key, &req, &stats);
-	if (ret < 0)
-		return ret;
-	nilfs_direct_commit_insert(direct, &req, key, ptr);
-	nilfs_bmap_add_blocks(bmap, stats.bs_nblocks);
+	if (NILFS_BMAP_USE_VBN(bmap)) {
+		req.bpr_ptr = nilfs_direct_find_target_v(direct, key);
+		dat = nilfs_bmap_get_dat(bmap);
+	}
+	ret = nilfs_bmap_prepare_alloc_ptr(bmap, &req, dat);
+	if (!ret) {
+		/* ptr must be a pointer to a buffer head. */
+		bh = (struct buffer_head *)((unsigned long)ptr);
+		set_buffer_nilfs_volatile(bh);
 
-	return 0;
-}
+		nilfs_bmap_commit_alloc_ptr(bmap, &req, dat);
+		nilfs_direct_set_ptr(direct, key, req.bpr_ptr);
 
-static int nilfs_direct_prepare_delete(struct nilfs_direct *direct,
-				       union nilfs_bmap_ptr_req *req,
-				       __u64 key,
-				       struct nilfs_bmap_stats *stats)
-{
-	int ret;
+		if (!nilfs_bmap_dirty(bmap))
+			nilfs_bmap_set_dirty(bmap);
 
-	req->bpr_ptr = nilfs_direct_get_ptr(direct, key);
-	ret = nilfs_bmap_prepare_end_ptr(&direct->d_bmap, req);
-	if (!ret)
-		stats->bs_nblocks = 1;
-	return ret;
-}
+		if (NILFS_BMAP_USE_VBN(bmap))
+			nilfs_direct_set_target_v(direct, key, req.bpr_ptr);
 
-static void nilfs_direct_commit_delete(struct nilfs_direct *direct,
-				       union nilfs_bmap_ptr_req *req,
-				       __u64 key)
-{
-	nilfs_bmap_commit_end_ptr(&direct->d_bmap, req);
-	nilfs_direct_set_ptr(direct, key, NILFS_BMAP_INVALID_PTR);
+		nilfs_bmap_add_blocks(bmap, 1);
+	}
+	return ret;
 }
 
 static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key)
 {
-	struct nilfs_direct *direct;
+	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
 	union nilfs_bmap_ptr_req req;
-	struct nilfs_bmap_stats stats;
+	struct inode *dat;
 	int ret;
 
-	direct = (struct nilfs_direct *)bmap;
-	if ((key > NILFS_DIRECT_KEY_MAX) ||
+	if (key > NILFS_DIRECT_KEY_MAX ||
 	    nilfs_direct_get_ptr(direct, key) == NILFS_BMAP_INVALID_PTR)
 		return -ENOENT;
 
-	ret = nilfs_direct_prepare_delete(direct, &req, key, &stats);
-	if (ret < 0)
-		return ret;
-	nilfs_direct_commit_delete(direct, &req, key);
-	nilfs_bmap_sub_blocks(bmap, stats.bs_nblocks);
+	dat = NILFS_BMAP_USE_VBN(bmap) ? nilfs_bmap_get_dat(bmap) : NULL;
+	req.bpr_ptr = nilfs_direct_get_ptr(direct, key);
 
-	return 0;
+	ret = nilfs_bmap_prepare_end_ptr(bmap, &req, dat);
+	if (!ret) {
+		nilfs_bmap_commit_end_ptr(bmap, &req, dat);
+		nilfs_direct_set_ptr(direct, key, NILFS_BMAP_INVALID_PTR);
+		nilfs_bmap_sub_blocks(bmap, 1);
+	}
+	return ret;
 }
 
 static int nilfs_direct_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
@@ -310,59 +268,56 @@ int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
 	return 0;
 }
 
-static int nilfs_direct_propagate_v(struct nilfs_direct *direct,
-				    struct buffer_head *bh)
+static int nilfs_direct_propagate(const struct nilfs_bmap *bmap,
+				  struct buffer_head *bh)
 {
-	union nilfs_bmap_ptr_req oldreq, newreq;
+	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
+	struct nilfs_palloc_req oldreq, newreq;
+	struct inode *dat;
 	__u64 key;
 	__u64 ptr;
 	int ret;
 
-	key = nilfs_bmap_data_get_key(&direct->d_bmap, bh);
+	if (!NILFS_BMAP_USE_VBN(bmap))
+		return 0;
+
+	dat = nilfs_bmap_get_dat(bmap);
+	key = nilfs_bmap_data_get_key(bmap, bh);
 	ptr = nilfs_direct_get_ptr(direct, key);
 	if (!buffer_nilfs_volatile(bh)) {
-		oldreq.bpr_ptr = ptr;
-		newreq.bpr_ptr = ptr;
-		ret = nilfs_bmap_prepare_update_v(&direct->d_bmap, &oldreq,
-						  &newreq);
+		oldreq.pr_entry_nr = ptr;
+		newreq.pr_entry_nr = ptr;
+		ret = nilfs_dat_prepare_update(dat, &oldreq, &newreq);
 		if (ret < 0)
 			return ret;
-		nilfs_bmap_commit_update_v(&direct->d_bmap, &oldreq, &newreq);
+		nilfs_dat_commit_update(dat, &oldreq, &newreq,
+					bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
 		set_buffer_nilfs_volatile(bh);
-		nilfs_direct_set_ptr(direct, key, newreq.bpr_ptr);
+		nilfs_direct_set_ptr(direct, key, newreq.pr_entry_nr);
 	} else
-		ret = nilfs_bmap_mark_dirty(&direct->d_bmap, ptr);
+		ret = nilfs_dat_mark_dirty(dat, ptr);
 
 	return ret;
 }
 
-static int nilfs_direct_propagate(const struct nilfs_bmap *bmap,
-				  struct buffer_head *bh)
-{
-	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
-
-	return NILFS_BMAP_USE_VBN(bmap) ?
-		nilfs_direct_propagate_v(direct, bh) : 0;
-}
-
 static int nilfs_direct_assign_v(struct nilfs_direct *direct,
 				 __u64 key, __u64 ptr,
 				 struct buffer_head **bh,
 				 sector_t blocknr,
 				 union nilfs_binfo *binfo)
 {
+	struct inode *dat = nilfs_bmap_get_dat(&direct->d_bmap);
 	union nilfs_bmap_ptr_req req;
 	int ret;
 
 	req.bpr_ptr = ptr;
-	ret = nilfs_bmap_start_v(&direct->d_bmap, &req, blocknr);
-	if (unlikely(ret < 0))
-		return ret;
-
-	binfo->bi_v.bi_vblocknr = nilfs_bmap_ptr_to_dptr(ptr);
-	binfo->bi_v.bi_blkoff = nilfs_bmap_key_to_dkey(key);
-
-	return 0;
+	ret = nilfs_dat_prepare_start(dat, &req.bpr_req);
+	if (!ret) {
+		nilfs_dat_commit_start(dat, &req.bpr_req, blocknr);
+		binfo->bi_v.bi_vblocknr = nilfs_bmap_ptr_to_dptr(ptr);
+		binfo->bi_v.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+	}
+	return ret;
 }
 
 static int nilfs_direct_assign_p(struct nilfs_direct *direct,
-- 
1.6.3.4
