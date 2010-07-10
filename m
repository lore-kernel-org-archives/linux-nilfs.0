From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/6] nilfs2: get rid of nilfs_btree uses
Date: Sun, 11 Jul 2010 00:01:52 +0900
Message-ID: <1278774114-17917-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1278774114-17917-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1278774114-17917-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This replaces all uses of nilfs_btree struct in implementation of
btree mapping with nilfs_bmap struct.

Name of local variable "btree" is kept not to bloat amount of change.
And, a part of local variables "bmap" is renamed to "btree" to uniform
naming rule.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |  316 +++++++++++++++++++++++-----------------------------
 fs/nilfs2/btree.h |    2 +-
 2 files changed, 141 insertions(+), 177 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 6dddfe9..8c425d8 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -66,11 +66,10 @@ static void nilfs_btree_free_path(struct nilfs_btree_path *path)
 /*
  * B-tree node operations
  */
-static int nilfs_btree_get_block(const struct nilfs_btree *btree, __u64 ptr,
+static int nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 				 struct buffer_head **bhp)
 {
-	struct address_space *btnc =
-		&NILFS_BMAP_I((struct nilfs_bmap *)btree)->i_btnode_cache;
+	struct address_space *btnc = &NILFS_BMAP_I(btree)->i_btnode_cache;
 	struct buffer_head *bh;
 	int err;
 
@@ -91,11 +90,10 @@ static int nilfs_btree_get_block(const struct nilfs_btree *btree, __u64 ptr,
 	return 0;
 }
 
-static int nilfs_btree_get_new_block(const struct nilfs_btree *btree,
+static int nilfs_btree_get_new_block(const struct nilfs_bmap *btree,
 				     __u64 ptr, struct buffer_head **bhp)
 {
-	struct address_space *btnc =
-		&NILFS_BMAP_I((struct nilfs_bmap *)btree)->i_btnode_cache;
+	struct address_space *btnc = &NILFS_BMAP_I(btree)->i_btnode_cache;
 	struct buffer_head *bh;
 
 	bh = nilfs_btnode_create_block(btnc, ptr);
@@ -148,14 +146,14 @@ nilfs_btree_node_set_nchildren(struct nilfs_btree_node *node, int nchildren)
 	node->bn_nchildren = cpu_to_le16(nchildren);
 }
 
-static inline int nilfs_btree_node_size(const struct nilfs_btree *btree)
+static inline int nilfs_btree_node_size(const struct nilfs_bmap *btree)
 {
-	return 1 << btree->bt_bmap.b_inode->i_blkbits;
+	return 1 << btree->b_inode->i_blkbits;
 }
 
 static inline int
 nilfs_btree_node_nchildren_min(const struct nilfs_btree_node *node,
-			       const struct nilfs_btree *btree)
+			       const struct nilfs_bmap *btree)
 {
 	return nilfs_btree_node_root(node) ?
 		NILFS_BTREE_ROOT_NCHILDREN_MIN :
@@ -164,7 +162,7 @@ nilfs_btree_node_nchildren_min(const struct nilfs_btree_node *node,
 
 static inline int
 nilfs_btree_node_nchildren_max(const struct nilfs_btree_node *node,
-			       const struct nilfs_btree *btree)
+			       const struct nilfs_bmap *btree)
 {
 	return nilfs_btree_node_root(node) ?
 		NILFS_BTREE_ROOT_NCHILDREN_MAX :
@@ -181,7 +179,7 @@ nilfs_btree_node_dkeys(const struct nilfs_btree_node *node)
 
 static inline __le64 *
 nilfs_btree_node_dptrs(const struct nilfs_btree_node *node,
-		       const struct nilfs_btree *btree)
+		       const struct nilfs_bmap *btree)
 {
 	return (__le64 *)(nilfs_btree_node_dkeys(node) +
 			  nilfs_btree_node_nchildren_max(node, btree));
@@ -200,20 +198,20 @@ nilfs_btree_node_set_key(struct nilfs_btree_node *node, int index, __u64 key)
 }
 
 static inline __u64
-nilfs_btree_node_get_ptr(const struct nilfs_btree *btree,
+nilfs_btree_node_get_ptr(const struct nilfs_bmap *btree,
 			 const struct nilfs_btree_node *node, int index)
 {
 	return le64_to_cpu(*(nilfs_btree_node_dptrs(node, btree) + index));
 }
 
 static inline void
-nilfs_btree_node_set_ptr(struct nilfs_btree *btree,
+nilfs_btree_node_set_ptr(struct nilfs_bmap *btree,
 			 struct nilfs_btree_node *node, int index, __u64 ptr)
 {
 	*(nilfs_btree_node_dptrs(node, btree) + index) = cpu_to_le64(ptr);
 }
 
-static void nilfs_btree_node_init(struct nilfs_btree *btree,
+static void nilfs_btree_node_init(struct nilfs_bmap *btree,
 				  struct nilfs_btree_node *node,
 				  int flags, int level, int nchildren,
 				  const __u64 *keys, const __u64 *ptrs)
@@ -235,7 +233,7 @@ static void nilfs_btree_node_init(struct nilfs_btree *btree,
 }
 
 /* Assume the buffer heads corresponding to left and right are locked. */
-static void nilfs_btree_node_move_left(struct nilfs_btree *btree,
+static void nilfs_btree_node_move_left(struct nilfs_bmap *btree,
 				       struct nilfs_btree_node *left,
 				       struct nilfs_btree_node *right,
 				       int n)
@@ -264,7 +262,7 @@ static void nilfs_btree_node_move_left(struct nilfs_btree *btree,
 }
 
 /* Assume that the buffer heads corresponding to left and right are locked. */
-static void nilfs_btree_node_move_right(struct nilfs_btree *btree,
+static void nilfs_btree_node_move_right(struct nilfs_bmap *btree,
 					struct nilfs_btree_node *left,
 					struct nilfs_btree_node *right,
 					int n)
@@ -293,7 +291,7 @@ static void nilfs_btree_node_move_right(struct nilfs_btree *btree,
 }
 
 /* Assume that the buffer head corresponding to node is locked. */
-static void nilfs_btree_node_insert(struct nilfs_btree *btree,
+static void nilfs_btree_node_insert(struct nilfs_bmap *btree,
 				    struct nilfs_btree_node *node,
 				    __u64 key, __u64 ptr, int index)
 {
@@ -317,7 +315,7 @@ static void nilfs_btree_node_insert(struct nilfs_btree *btree,
 }
 
 /* Assume that the buffer head corresponding to node is locked. */
-static void nilfs_btree_node_delete(struct nilfs_btree *btree,
+static void nilfs_btree_node_delete(struct nilfs_bmap *btree,
 				    struct nilfs_btree_node *node,
 				    __u64 *keyp, __u64 *ptrp, int index)
 {
@@ -424,9 +422,9 @@ int nilfs_btree_broken_node_block(struct buffer_head *bh)
 }
 
 static inline struct nilfs_btree_node *
-nilfs_btree_get_root(const struct nilfs_btree *btree)
+nilfs_btree_get_root(const struct nilfs_bmap *btree)
 {
-	return (struct nilfs_btree_node *)btree->bt_bmap.b_u.u_data;
+	return (struct nilfs_btree_node *)btree->b_u.u_data;
 }
 
 static inline struct nilfs_btree_node *
@@ -441,13 +439,13 @@ nilfs_btree_get_sib_node(const struct nilfs_btree_path *path, int level)
 	return (struct nilfs_btree_node *)path[level].bp_sib_bh->b_data;
 }
 
-static inline int nilfs_btree_height(const struct nilfs_btree *btree)
+static inline int nilfs_btree_height(const struct nilfs_bmap *btree)
 {
 	return nilfs_btree_node_get_level(nilfs_btree_get_root(btree)) + 1;
 }
 
 static inline struct nilfs_btree_node *
-nilfs_btree_get_node(const struct nilfs_btree *btree,
+nilfs_btree_get_node(const struct nilfs_bmap *btree,
 		     const struct nilfs_btree_path *path,
 		     int level)
 {
@@ -468,7 +466,7 @@ nilfs_btree_bad_node(struct nilfs_btree_node *node, int level)
 	return 0;
 }
 
-static int nilfs_btree_do_lookup(const struct nilfs_btree *btree,
+static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 				 struct nilfs_btree_path *path,
 				 __u64 key, __u64 *ptrp, int minlevel)
 {
@@ -515,7 +513,7 @@ static int nilfs_btree_do_lookup(const struct nilfs_btree *btree,
 	return 0;
 }
 
-static int nilfs_btree_do_lookup_last(const struct nilfs_btree *btree,
+static int nilfs_btree_do_lookup_last(const struct nilfs_bmap *btree,
 				      struct nilfs_btree_path *path,
 				      __u64 *keyp, __u64 *ptrp)
 {
@@ -552,15 +550,13 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_btree *btree,
 	return 0;
 }
 
-static int nilfs_btree_lookup(const struct nilfs_bmap *bmap,
+static int nilfs_btree_lookup(const struct nilfs_bmap *btree,
 			      __u64 key, int level, __u64 *ptrp)
 {
-	struct nilfs_btree *btree;
 	struct nilfs_btree_path *path;
 	__u64 ptr;
 	int ret;
 
-	btree = (struct nilfs_btree *)bmap;
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -575,10 +571,9 @@ static int nilfs_btree_lookup(const struct nilfs_bmap *bmap,
 	return ret;
 }
 
-static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
+static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 				     __u64 key, __u64 *ptrp, unsigned maxblocks)
 {
-	struct nilfs_btree *btree = (struct nilfs_btree *)bmap;
 	struct nilfs_btree_path *path;
 	struct nilfs_btree_node *node;
 	struct inode *dat = NULL;
@@ -595,8 +590,8 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
 	if (ret < 0)
 		goto out;
 
-	if (NILFS_BMAP_USE_VBN(bmap)) {
-		dat = nilfs_bmap_get_dat(bmap);
+	if (NILFS_BMAP_USE_VBN(btree)) {
+		dat = nilfs_bmap_get_dat(btree);
 		ret = nilfs_dat_translate(dat, ptr, &blocknr);
 		if (ret < 0)
 			goto out;
@@ -655,7 +650,7 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
 	return ret;
 }
 
-static void nilfs_btree_promote_key(struct nilfs_btree *btree,
+static void nilfs_btree_promote_key(struct nilfs_bmap *btree,
 				    struct nilfs_btree_path *path,
 				    int level, __u64 key)
 {
@@ -677,7 +672,7 @@ static void nilfs_btree_promote_key(struct nilfs_btree *btree,
 	}
 }
 
-static void nilfs_btree_do_insert(struct nilfs_btree *btree,
+static void nilfs_btree_do_insert(struct nilfs_bmap *btree,
 				  struct nilfs_btree_path *path,
 				  int level, __u64 *keyp, __u64 *ptrp)
 {
@@ -701,7 +696,7 @@ static void nilfs_btree_do_insert(struct nilfs_btree *btree,
 	}
 }
 
-static void nilfs_btree_carry_left(struct nilfs_btree *btree,
+static void nilfs_btree_carry_left(struct nilfs_bmap *btree,
 				   struct nilfs_btree_path *path,
 				   int level, __u64 *keyp, __u64 *ptrp)
 {
@@ -746,7 +741,7 @@ static void nilfs_btree_carry_left(struct nilfs_btree *btree,
 	nilfs_btree_do_insert(btree, path, level, keyp, ptrp);
 }
 
-static void nilfs_btree_carry_right(struct nilfs_btree *btree,
+static void nilfs_btree_carry_right(struct nilfs_bmap *btree,
 				    struct nilfs_btree_path *path,
 				    int level, __u64 *keyp, __u64 *ptrp)
 {
@@ -792,7 +787,7 @@ static void nilfs_btree_carry_right(struct nilfs_btree *btree,
 	nilfs_btree_do_insert(btree, path, level, keyp, ptrp);
 }
 
-static void nilfs_btree_split(struct nilfs_btree *btree,
+static void nilfs_btree_split(struct nilfs_bmap *btree,
 			      struct nilfs_btree_path *path,
 			      int level, __u64 *keyp, __u64 *ptrp)
 {
@@ -846,7 +841,7 @@ static void nilfs_btree_split(struct nilfs_btree *btree,
 	path[level + 1].bp_index++;
 }
 
-static void nilfs_btree_grow(struct nilfs_btree *btree,
+static void nilfs_btree_grow(struct nilfs_bmap *btree,
 			     struct nilfs_btree_path *path,
 			     int level, __u64 *keyp, __u64 *ptrp)
 {
@@ -873,7 +868,7 @@ static void nilfs_btree_grow(struct nilfs_btree *btree,
 	*ptrp = path[level].bp_newreq.bpr_ptr;
 }
 
-static __u64 nilfs_btree_find_near(const struct nilfs_btree *btree,
+static __u64 nilfs_btree_find_near(const struct nilfs_bmap *btree,
 				   const struct nilfs_btree_path *path)
 {
 	struct nilfs_btree_node *node;
@@ -901,13 +896,13 @@ static __u64 nilfs_btree_find_near(const struct nilfs_btree *btree,
 	return NILFS_BMAP_INVALID_PTR;
 }
 
-static __u64 nilfs_btree_find_target_v(const struct nilfs_btree *btree,
+static __u64 nilfs_btree_find_target_v(const struct nilfs_bmap *btree,
 				       const struct nilfs_btree_path *path,
 				       __u64 key)
 {
 	__u64 ptr;
 
-	ptr = nilfs_bmap_find_target_seq(&btree->bt_bmap, key);
+	ptr = nilfs_bmap_find_target_seq(btree, key);
 	if (ptr != NILFS_BMAP_INVALID_PTR)
 		/* sequential access */
 		return ptr;
@@ -918,17 +913,17 @@ static __u64 nilfs_btree_find_target_v(const struct nilfs_btree *btree,
 			return ptr;
 	}
 	/* block group */
-	return nilfs_bmap_find_target_in_group(&btree->bt_bmap);
+	return nilfs_bmap_find_target_in_group(btree);
 }
 
-static void nilfs_btree_set_target_v(struct nilfs_btree *btree, __u64 key,
+static void nilfs_btree_set_target_v(struct nilfs_bmap *btree, __u64 key,
 				     __u64 ptr)
 {
-	btree->bt_bmap.b_last_allocated_key = key;
-	btree->bt_bmap.b_last_allocated_ptr = ptr;
+	btree->b_last_allocated_key = key;
+	btree->b_last_allocated_ptr = ptr;
 }
 
-static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
+static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 				      struct nilfs_btree_path *path,
 				      int *levelp, __u64 key, __u64 ptr,
 				      struct nilfs_bmap_stats *stats)
@@ -943,14 +938,13 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 	level = NILFS_BTREE_LEVEL_DATA;
 
 	/* allocate a new ptr for data block */
-	if (NILFS_BMAP_USE_VBN(&btree->bt_bmap)) {
+	if (NILFS_BMAP_USE_VBN(btree)) {
 		path[level].bp_newreq.bpr_ptr =
 			nilfs_btree_find_target_v(btree, path, key);
-		dat = nilfs_bmap_get_dat(&btree->bt_bmap);
+		dat = nilfs_bmap_get_dat(btree);
 	}
 
-	ret = nilfs_bmap_prepare_alloc_ptr(&btree->bt_bmap,
-					   &path[level].bp_newreq, dat);
+	ret = nilfs_bmap_prepare_alloc_ptr(btree, &path[level].bp_newreq, dat);
 	if (ret < 0)
 		goto err_out_data;
 
@@ -1008,7 +1002,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 		/* split */
 		path[level].bp_newreq.bpr_ptr =
 			path[level - 1].bp_newreq.bpr_ptr + 1;
-		ret = nilfs_bmap_prepare_alloc_ptr(&btree->bt_bmap,
+		ret = nilfs_bmap_prepare_alloc_ptr(btree,
 						   &path[level].bp_newreq, dat);
 		if (ret < 0)
 			goto err_out_child_node;
@@ -1038,8 +1032,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 
 	/* grow */
 	path[level].bp_newreq.bpr_ptr = path[level - 1].bp_newreq.bpr_ptr + 1;
-	ret = nilfs_bmap_prepare_alloc_ptr(&btree->bt_bmap,
-					   &path[level].bp_newreq, dat);
+	ret = nilfs_bmap_prepare_alloc_ptr(btree, &path[level].bp_newreq, dat);
 	if (ret < 0)
 		goto err_out_child_node;
 	ret = nilfs_btree_get_new_block(btree, path[level].bp_newreq.bpr_ptr,
@@ -1065,25 +1058,22 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 
 	/* error */
  err_out_curr_node:
-	nilfs_bmap_abort_alloc_ptr(&btree->bt_bmap, &path[level].bp_newreq,
-				   dat);
+	nilfs_bmap_abort_alloc_ptr(btree, &path[level].bp_newreq, dat);
  err_out_child_node:
 	for (level--; level > NILFS_BTREE_LEVEL_DATA; level--) {
 		nilfs_btnode_delete(path[level].bp_sib_bh);
-		nilfs_bmap_abort_alloc_ptr(&btree->bt_bmap,
-					   &path[level].bp_newreq, dat);
+		nilfs_bmap_abort_alloc_ptr(btree, &path[level].bp_newreq, dat);
 
 	}
 
-	nilfs_bmap_abort_alloc_ptr(&btree->bt_bmap, &path[level].bp_newreq,
-				   dat);
+	nilfs_bmap_abort_alloc_ptr(btree, &path[level].bp_newreq, dat);
  err_out_data:
 	*levelp = level;
 	stats->bs_nblocks = 0;
 	return ret;
 }
 
-static void nilfs_btree_commit_insert(struct nilfs_btree *btree,
+static void nilfs_btree_commit_insert(struct nilfs_bmap *btree,
 				      struct nilfs_btree_path *path,
 				      int maxlevel, __u64 key, __u64 ptr)
 {
@@ -1092,29 +1082,27 @@ static void nilfs_btree_commit_insert(struct nilfs_btree *btree,
 
 	set_buffer_nilfs_volatile((struct buffer_head *)((unsigned long)ptr));
 	ptr = path[NILFS_BTREE_LEVEL_DATA].bp_newreq.bpr_ptr;
-	if (NILFS_BMAP_USE_VBN(&btree->bt_bmap)) {
+	if (NILFS_BMAP_USE_VBN(btree)) {
 		nilfs_btree_set_target_v(btree, key, ptr);
-		dat = nilfs_bmap_get_dat(&btree->bt_bmap);
+		dat = nilfs_bmap_get_dat(btree);
 	}
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
-		nilfs_bmap_commit_alloc_ptr(&btree->bt_bmap,
+		nilfs_bmap_commit_alloc_ptr(btree,
 					    &path[level - 1].bp_newreq, dat);
 		path[level].bp_op(btree, path, level, &key, &ptr);
 	}
 
-	if (!nilfs_bmap_dirty(&btree->bt_bmap))
-		nilfs_bmap_set_dirty(&btree->bt_bmap);
+	if (!nilfs_bmap_dirty(btree))
+		nilfs_bmap_set_dirty(btree);
 }
 
-static int nilfs_btree_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
+static int nilfs_btree_insert(struct nilfs_bmap *btree, __u64 key, __u64 ptr)
 {
-	struct nilfs_btree *btree;
 	struct nilfs_btree_path *path;
 	struct nilfs_bmap_stats stats;
 	int level, ret;
 
-	btree = (struct nilfs_btree *)bmap;
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -1131,14 +1119,14 @@ static int nilfs_btree_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 	if (ret < 0)
 		goto out;
 	nilfs_btree_commit_insert(btree, path, level, key, ptr);
-	nilfs_bmap_add_blocks(bmap, stats.bs_nblocks);
+	nilfs_bmap_add_blocks(btree, stats.bs_nblocks);
 
  out:
 	nilfs_btree_free_path(path);
 	return ret;
 }
 
-static void nilfs_btree_do_delete(struct nilfs_btree *btree,
+static void nilfs_btree_do_delete(struct nilfs_bmap *btree,
 				  struct nilfs_btree_path *path,
 				  int level, __u64 *keyp, __u64 *ptrp)
 {
@@ -1160,7 +1148,7 @@ static void nilfs_btree_do_delete(struct nilfs_btree *btree,
 	}
 }
 
-static void nilfs_btree_borrow_left(struct nilfs_btree *btree,
+static void nilfs_btree_borrow_left(struct nilfs_bmap *btree,
 				    struct nilfs_btree_path *path,
 				    int level, __u64 *keyp, __u64 *ptrp)
 {
@@ -1191,7 +1179,7 @@ static void nilfs_btree_borrow_left(struct nilfs_btree *btree,
 	path[level].bp_index += n;
 }
 
-static void nilfs_btree_borrow_right(struct nilfs_btree *btree,
+static void nilfs_btree_borrow_right(struct nilfs_bmap *btree,
 				     struct nilfs_btree_path *path,
 				     int level, __u64 *keyp, __u64 *ptrp)
 {
@@ -1223,7 +1211,7 @@ static void nilfs_btree_borrow_right(struct nilfs_btree *btree,
 	path[level].bp_sib_bh = NULL;
 }
 
-static void nilfs_btree_concat_left(struct nilfs_btree *btree,
+static void nilfs_btree_concat_left(struct nilfs_bmap *btree,
 				    struct nilfs_btree_path *path,
 				    int level, __u64 *keyp, __u64 *ptrp)
 {
@@ -1248,7 +1236,7 @@ static void nilfs_btree_concat_left(struct nilfs_btree *btree,
 	path[level].bp_index += nilfs_btree_node_get_nchildren(left);
 }
 
-static void nilfs_btree_concat_right(struct nilfs_btree *btree,
+static void nilfs_btree_concat_right(struct nilfs_bmap *btree,
 				     struct nilfs_btree_path *path,
 				     int level, __u64 *keyp, __u64 *ptrp)
 {
@@ -1272,7 +1260,7 @@ static void nilfs_btree_concat_right(struct nilfs_btree *btree,
 	path[level + 1].bp_index++;
 }
 
-static void nilfs_btree_shrink(struct nilfs_btree *btree,
+static void nilfs_btree_shrink(struct nilfs_bmap *btree,
 			       struct nilfs_btree_path *path,
 			       int level, __u64 *keyp, __u64 *ptrp)
 {
@@ -1294,7 +1282,7 @@ static void nilfs_btree_shrink(struct nilfs_btree *btree,
 }
 
 
-static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
+static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 				      struct nilfs_btree_path *path,
 				      int *levelp,
 				      struct nilfs_bmap_stats *stats,
@@ -1314,7 +1302,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 		path[level].bp_oldreq.bpr_ptr =
 			nilfs_btree_node_get_ptr(btree, node,
 						 path[level].bp_index);
-		ret = nilfs_bmap_prepare_end_ptr(&btree->bt_bmap,
+		ret = nilfs_bmap_prepare_end_ptr(btree,
 						 &path[level].bp_oldreq, dat);
 		if (ret < 0)
 			goto err_out_child_node;
@@ -1392,8 +1380,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 	path[level].bp_oldreq.bpr_ptr =
 		nilfs_btree_node_get_ptr(btree, node, path[level].bp_index);
 
-	ret = nilfs_bmap_prepare_end_ptr(&btree->bt_bmap,
-					 &path[level].bp_oldreq, dat);
+	ret = nilfs_bmap_prepare_end_ptr(btree, &path[level].bp_oldreq, dat);
 	if (ret < 0)
 		goto err_out_child_node;
 
@@ -1408,44 +1395,40 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 
 	/* error */
  err_out_curr_node:
-	nilfs_bmap_abort_end_ptr(&btree->bt_bmap, &path[level].bp_oldreq, dat);
+	nilfs_bmap_abort_end_ptr(btree, &path[level].bp_oldreq, dat);
  err_out_child_node:
 	for (level--; level >= NILFS_BTREE_LEVEL_NODE_MIN; level--) {
 		brelse(path[level].bp_sib_bh);
-		nilfs_bmap_abort_end_ptr(&btree->bt_bmap,
-					 &path[level].bp_oldreq, dat);
+		nilfs_bmap_abort_end_ptr(btree, &path[level].bp_oldreq, dat);
 	}
 	*levelp = level;
 	stats->bs_nblocks = 0;
 	return ret;
 }
 
-static void nilfs_btree_commit_delete(struct nilfs_btree *btree,
+static void nilfs_btree_commit_delete(struct nilfs_bmap *btree,
 				      struct nilfs_btree_path *path,
 				      int maxlevel, struct inode *dat)
 {
 	int level;
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
-		nilfs_bmap_commit_end_ptr(&btree->bt_bmap,
-					  &path[level].bp_oldreq, dat);
+		nilfs_bmap_commit_end_ptr(btree, &path[level].bp_oldreq, dat);
 		path[level].bp_op(btree, path, level, NULL, NULL);
 	}
 
-	if (!nilfs_bmap_dirty(&btree->bt_bmap))
-		nilfs_bmap_set_dirty(&btree->bt_bmap);
+	if (!nilfs_bmap_dirty(btree))
+		nilfs_bmap_set_dirty(btree);
 }
 
-static int nilfs_btree_delete(struct nilfs_bmap *bmap, __u64 key)
+static int nilfs_btree_delete(struct nilfs_bmap *btree, __u64 key)
 
 {
-	struct nilfs_btree *btree;
 	struct nilfs_btree_path *path;
 	struct nilfs_bmap_stats stats;
 	struct inode *dat;
 	int level, ret;
 
-	btree = (struct nilfs_btree *)bmap;
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -1456,27 +1439,24 @@ static int nilfs_btree_delete(struct nilfs_bmap *bmap, __u64 key)
 		goto out;
 
 
-	dat = NILFS_BMAP_USE_VBN(&btree->bt_bmap) ?
-		nilfs_bmap_get_dat(&btree->bt_bmap) : NULL;
+	dat = NILFS_BMAP_USE_VBN(btree) ? nilfs_bmap_get_dat(btree) : NULL;
 
 	ret = nilfs_btree_prepare_delete(btree, path, &level, &stats, dat);
 	if (ret < 0)
 		goto out;
 	nilfs_btree_commit_delete(btree, path, level, dat);
-	nilfs_bmap_sub_blocks(bmap, stats.bs_nblocks);
+	nilfs_bmap_sub_blocks(btree, stats.bs_nblocks);
 
 out:
 	nilfs_btree_free_path(path);
 	return ret;
 }
 
-static int nilfs_btree_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
+static int nilfs_btree_last_key(const struct nilfs_bmap *btree, __u64 *keyp)
 {
-	struct nilfs_btree *btree;
 	struct nilfs_btree_path *path;
 	int ret;
 
-	btree = (struct nilfs_btree *)bmap;
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -1488,16 +1468,14 @@ static int nilfs_btree_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
 	return ret;
 }
 
-static int nilfs_btree_check_delete(struct nilfs_bmap *bmap, __u64 key)
+static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
 {
 	struct buffer_head *bh;
-	struct nilfs_btree *btree;
 	struct nilfs_btree_node *root, *node;
 	__u64 maxkey, nextmaxkey;
 	__u64 ptr;
 	int nchildren, ret;
 
-	btree = (struct nilfs_btree *)bmap;
 	root = nilfs_btree_get_root(btree);
 	switch (nilfs_btree_height(btree)) {
 	case 2:
@@ -1528,18 +1506,16 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *bmap, __u64 key)
 	return (maxkey == key) && (nextmaxkey < NILFS_BMAP_LARGE_LOW);
 }
 
-static int nilfs_btree_gather_data(struct nilfs_bmap *bmap,
+static int nilfs_btree_gather_data(struct nilfs_bmap *btree,
 				   __u64 *keys, __u64 *ptrs, int nitems)
 {
 	struct buffer_head *bh;
-	struct nilfs_btree *btree;
 	struct nilfs_btree_node *node, *root;
 	__le64 *dkeys;
 	__le64 *dptrs;
 	__u64 ptr;
 	int nchildren, i, ret;
 
-	btree = (struct nilfs_btree *)bmap;
 	root = nilfs_btree_get_root(btree);
 	switch (nilfs_btree_height(btree)) {
 	case 2:
@@ -1577,14 +1553,13 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *bmap,
 }
 
 static int
-nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
+nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *btree, __u64 key,
 				       union nilfs_bmap_ptr_req *dreq,
 				       union nilfs_bmap_ptr_req *nreq,
 				       struct buffer_head **bhp,
 				       struct nilfs_bmap_stats *stats)
 {
 	struct buffer_head *bh;
-	struct nilfs_btree *btree = (struct nilfs_btree *)bmap;
 	struct inode *dat = NULL;
 	int ret;
 
@@ -1592,12 +1567,12 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
 
 	/* for data */
 	/* cannot find near ptr */
-	if (NILFS_BMAP_USE_VBN(bmap)) {
+	if (NILFS_BMAP_USE_VBN(btree)) {
 		dreq->bpr_ptr = nilfs_btree_find_target_v(btree, NULL, key);
-		dat = nilfs_bmap_get_dat(bmap);
+		dat = nilfs_bmap_get_dat(btree);
 	}
 
-	ret = nilfs_bmap_prepare_alloc_ptr(bmap, dreq, dat);
+	ret = nilfs_bmap_prepare_alloc_ptr(btree, dreq, dat);
 	if (ret < 0)
 		return ret;
 
@@ -1605,7 +1580,7 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
 	stats->bs_nblocks++;
 	if (nreq != NULL) {
 		nreq->bpr_ptr = dreq->bpr_ptr + 1;
-		ret = nilfs_bmap_prepare_alloc_ptr(bmap, nreq, dat);
+		ret = nilfs_bmap_prepare_alloc_ptr(btree, nreq, dat);
 		if (ret < 0)
 			goto err_out_dreq;
 
@@ -1622,16 +1597,16 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
 
 	/* error */
  err_out_nreq:
-	nilfs_bmap_abort_alloc_ptr(bmap, nreq, dat);
+	nilfs_bmap_abort_alloc_ptr(btree, nreq, dat);
  err_out_dreq:
-	nilfs_bmap_abort_alloc_ptr(bmap, dreq, dat);
+	nilfs_bmap_abort_alloc_ptr(btree, dreq, dat);
 	stats->bs_nblocks = 0;
 	return ret;
 
 }
 
 static void
-nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
+nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *btree,
 				      __u64 key, __u64 ptr,
 				      const __u64 *keys, const __u64 *ptrs,
 				      int n,
@@ -1639,34 +1614,32 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 				      union nilfs_bmap_ptr_req *nreq,
 				      struct buffer_head *bh)
 {
-	struct nilfs_btree *btree = (struct nilfs_btree *)bmap;
 	struct nilfs_btree_node *node;
 	struct inode *dat;
 	__u64 tmpptr;
 
 	/* free resources */
-	if (bmap->b_ops->bop_clear != NULL)
-		bmap->b_ops->bop_clear(bmap);
+	if (btree->b_ops->bop_clear != NULL)
+		btree->b_ops->bop_clear(btree);
 
 	/* ptr must be a pointer to a buffer head. */
 	set_buffer_nilfs_volatile((struct buffer_head *)((unsigned long)ptr));
 
 	/* convert and insert */
-	dat = NILFS_BMAP_USE_VBN(bmap) ? nilfs_bmap_get_dat(bmap) : NULL;
-	nilfs_btree_init(bmap);
+	dat = NILFS_BMAP_USE_VBN(btree) ? nilfs_bmap_get_dat(btree) : NULL;
+	nilfs_btree_init(btree);
 	if (nreq != NULL) {
-		nilfs_bmap_commit_alloc_ptr(bmap, dreq, dat);
-		nilfs_bmap_commit_alloc_ptr(bmap, nreq, dat);
+		nilfs_bmap_commit_alloc_ptr(btree, dreq, dat);
+		nilfs_bmap_commit_alloc_ptr(btree, nreq, dat);
 
 		/* create child node at level 1 */
 		node = (struct nilfs_btree_node *)bh->b_data;
 		nilfs_btree_node_init(btree, node, 0, 1, n, keys, ptrs);
-		nilfs_btree_node_insert(btree, node,
-					key, dreq->bpr_ptr, n);
+		nilfs_btree_node_insert(btree, node, key, dreq->bpr_ptr, n);
 		if (!buffer_dirty(bh))
 			nilfs_btnode_mark_dirty(bh);
-		if (!nilfs_bmap_dirty(bmap))
-			nilfs_bmap_set_dirty(bmap);
+		if (!nilfs_bmap_dirty(btree))
+			nilfs_bmap_set_dirty(btree);
 
 		brelse(bh);
 
@@ -1676,19 +1649,18 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 		nilfs_btree_node_init(btree, node, NILFS_BTREE_NODE_ROOT,
 				      2, 1, &keys[0], &tmpptr);
 	} else {
-		nilfs_bmap_commit_alloc_ptr(bmap, dreq, dat);
+		nilfs_bmap_commit_alloc_ptr(btree, dreq, dat);
 
 		/* create root node at level 1 */
 		node = nilfs_btree_get_root(btree);
 		nilfs_btree_node_init(btree, node, NILFS_BTREE_NODE_ROOT,
 				      1, n, keys, ptrs);
-		nilfs_btree_node_insert(btree, node,
-					key, dreq->bpr_ptr, n);
-		if (!nilfs_bmap_dirty(bmap))
-			nilfs_bmap_set_dirty(bmap);
+		nilfs_btree_node_insert(btree, node, key, dreq->bpr_ptr, n);
+		if (!nilfs_bmap_dirty(btree))
+			nilfs_bmap_set_dirty(btree);
 	}
 
-	if (NILFS_BMAP_USE_VBN(bmap))
+	if (NILFS_BMAP_USE_VBN(btree))
 		nilfs_btree_set_target_v(btree, key, dreq->bpr_ptr);
 }
 
@@ -1701,7 +1673,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
  * @ptrs:
  * @n:
  */
-int nilfs_btree_convert_and_insert(struct nilfs_bmap *bmap,
+int nilfs_btree_convert_and_insert(struct nilfs_bmap *btree,
 				   __u64 key, __u64 ptr,
 				   const __u64 *keys, const __u64 *ptrs, int n)
 {
@@ -1714,7 +1686,7 @@ int nilfs_btree_convert_and_insert(struct nilfs_bmap *bmap,
 		di = &dreq;
 		ni = NULL;
 	} else if ((n + 1) <= NILFS_BTREE_NODE_NCHILDREN_MAX(
-			   1 << bmap->b_inode->i_blkbits)) {
+			   1 << btree->b_inode->i_blkbits)) {
 		di = &dreq;
 		ni = &nreq;
 	} else {
@@ -1723,17 +1695,17 @@ int nilfs_btree_convert_and_insert(struct nilfs_bmap *bmap,
 		BUG();
 	}
 
-	ret = nilfs_btree_prepare_convert_and_insert(bmap, key, di, ni, &bh,
+	ret = nilfs_btree_prepare_convert_and_insert(btree, key, di, ni, &bh,
 						     &stats);
 	if (ret < 0)
 		return ret;
-	nilfs_btree_commit_convert_and_insert(bmap, key, ptr, keys, ptrs, n,
+	nilfs_btree_commit_convert_and_insert(btree, key, ptr, keys, ptrs, n,
 					      di, ni, bh);
-	nilfs_bmap_add_blocks(bmap, stats.bs_nblocks);
+	nilfs_bmap_add_blocks(btree, stats.bs_nblocks);
 	return 0;
 }
 
-static int nilfs_btree_propagate_p(struct nilfs_btree *btree,
+static int nilfs_btree_propagate_p(struct nilfs_bmap *btree,
 				   struct nilfs_btree_path *path,
 				   int level,
 				   struct buffer_head *bh)
@@ -1745,7 +1717,7 @@ static int nilfs_btree_propagate_p(struct nilfs_btree *btree,
 	return 0;
 }
 
-static int nilfs_btree_prepare_update_v(struct nilfs_btree *btree,
+static int nilfs_btree_prepare_update_v(struct nilfs_bmap *btree,
 					struct nilfs_btree_path *path,
 					int level, struct inode *dat)
 {
@@ -1767,7 +1739,7 @@ static int nilfs_btree_prepare_update_v(struct nilfs_btree *btree,
 		path[level].bp_ctxt.newkey = path[level].bp_newreq.bpr_ptr;
 		path[level].bp_ctxt.bh = path[level].bp_bh;
 		ret = nilfs_btnode_prepare_change_key(
-			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
+			&NILFS_BMAP_I(btree)->i_btnode_cache,
 			&path[level].bp_ctxt);
 		if (ret < 0) {
 			nilfs_dat_abort_update(dat,
@@ -1780,7 +1752,7 @@ static int nilfs_btree_prepare_update_v(struct nilfs_btree *btree,
 	return 0;
 }
 
-static void nilfs_btree_commit_update_v(struct nilfs_btree *btree,
+static void nilfs_btree_commit_update_v(struct nilfs_bmap *btree,
 					struct nilfs_btree_path *path,
 					int level, struct inode *dat)
 {
@@ -1788,11 +1760,11 @@ static void nilfs_btree_commit_update_v(struct nilfs_btree *btree,
 
 	nilfs_dat_commit_update(dat, &path[level].bp_oldreq.bpr_req,
 				&path[level].bp_newreq.bpr_req,
-				btree->bt_bmap.b_ptr_type == NILFS_BMAP_PTR_VS);
+				btree->b_ptr_type == NILFS_BMAP_PTR_VS);
 
 	if (buffer_nilfs_node(path[level].bp_bh)) {
 		nilfs_btnode_commit_change_key(
-			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
+			&NILFS_BMAP_I(btree)->i_btnode_cache,
 			&path[level].bp_ctxt);
 		path[level].bp_bh = path[level].bp_ctxt.bh;
 	}
@@ -1803,7 +1775,7 @@ static void nilfs_btree_commit_update_v(struct nilfs_btree *btree,
 				 path[level].bp_newreq.bpr_ptr);
 }
 
-static void nilfs_btree_abort_update_v(struct nilfs_btree *btree,
+static void nilfs_btree_abort_update_v(struct nilfs_bmap *btree,
 				       struct nilfs_btree_path *path,
 				       int level, struct inode *dat)
 {
@@ -1811,11 +1783,11 @@ static void nilfs_btree_abort_update_v(struct nilfs_btree *btree,
 			       &path[level].bp_newreq.bpr_req);
 	if (buffer_nilfs_node(path[level].bp_bh))
 		nilfs_btnode_abort_change_key(
-			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
+			&NILFS_BMAP_I(btree)->i_btnode_cache,
 			&path[level].bp_ctxt);
 }
 
-static int nilfs_btree_prepare_propagate_v(struct nilfs_btree *btree,
+static int nilfs_btree_prepare_propagate_v(struct nilfs_bmap *btree,
 					   struct nilfs_btree_path *path,
 					   int minlevel, int *maxlevelp,
 					   struct inode *dat)
@@ -1850,7 +1822,7 @@ static int nilfs_btree_prepare_propagate_v(struct nilfs_btree *btree,
 	return ret;
 }
 
-static void nilfs_btree_commit_propagate_v(struct nilfs_btree *btree,
+static void nilfs_btree_commit_propagate_v(struct nilfs_bmap *btree,
 					   struct nilfs_btree_path *path,
 					   int minlevel, int maxlevel,
 					   struct buffer_head *bh,
@@ -1865,13 +1837,13 @@ static void nilfs_btree_commit_propagate_v(struct nilfs_btree *btree,
 		nilfs_btree_commit_update_v(btree, path, level, dat);
 }
 
-static int nilfs_btree_propagate_v(struct nilfs_btree *btree,
+static int nilfs_btree_propagate_v(struct nilfs_bmap *btree,
 				   struct nilfs_btree_path *path,
 				   int level, struct buffer_head *bh)
 {
 	int maxlevel = 0, ret;
 	struct nilfs_btree_node *parent;
-	struct inode *dat = nilfs_bmap_get_dat(&btree->bt_bmap);
+	struct inode *dat = nilfs_bmap_get_dat(btree);
 	__u64 ptr;
 
 	get_bh(bh);
@@ -1898,10 +1870,9 @@ static int nilfs_btree_propagate_v(struct nilfs_btree *btree,
 	return ret;
 }
 
-static int nilfs_btree_propagate(struct nilfs_bmap *bmap,
+static int nilfs_btree_propagate(struct nilfs_bmap *btree,
 				 struct buffer_head *bh)
 {
-	struct nilfs_btree *btree;
 	struct nilfs_btree_path *path;
 	struct nilfs_btree_node *node;
 	__u64 key;
@@ -1909,7 +1880,6 @@ static int nilfs_btree_propagate(struct nilfs_bmap *bmap,
 
 	WARN_ON(!buffer_dirty(bh));
 
-	btree = (struct nilfs_btree *)bmap;
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -1919,7 +1889,7 @@ static int nilfs_btree_propagate(struct nilfs_bmap *bmap,
 		key = nilfs_btree_node_get_key(node, 0);
 		level = nilfs_btree_node_get_level(node);
 	} else {
-		key = nilfs_bmap_data_get_key(bmap, bh);
+		key = nilfs_bmap_data_get_key(btree, bh);
 		level = NILFS_BTREE_LEVEL_DATA;
 	}
 
@@ -1931,7 +1901,7 @@ static int nilfs_btree_propagate(struct nilfs_bmap *bmap,
 		goto out;
 	}
 
-	ret = NILFS_BMAP_USE_VBN(bmap) ?
+	ret = NILFS_BMAP_USE_VBN(btree) ?
 		nilfs_btree_propagate_v(btree, path, level, bh) :
 		nilfs_btree_propagate_p(btree, path, level, bh);
 
@@ -1941,13 +1911,13 @@ static int nilfs_btree_propagate(struct nilfs_bmap *bmap,
 	return ret;
 }
 
-static int nilfs_btree_propagate_gc(struct nilfs_bmap *bmap,
+static int nilfs_btree_propagate_gc(struct nilfs_bmap *btree,
 				    struct buffer_head *bh)
 {
-	return nilfs_dat_mark_dirty(nilfs_bmap_get_dat(bmap), bh->b_blocknr);
+	return nilfs_dat_mark_dirty(nilfs_bmap_get_dat(btree), bh->b_blocknr);
 }
 
-static void nilfs_btree_add_dirty_buffer(struct nilfs_btree *btree,
+static void nilfs_btree_add_dirty_buffer(struct nilfs_bmap *btree,
 					 struct list_head *lists,
 					 struct buffer_head *bh)
 {
@@ -1968,7 +1938,7 @@ static void nilfs_btree_add_dirty_buffer(struct nilfs_btree *btree,
 		       "%s: invalid btree level: %d (key=%llu, ino=%lu, "
 		       "blocknr=%llu)\n",
 		       __func__, level, (unsigned long long)key,
-		       NILFS_BMAP_I(&btree->bt_bmap)->vfs_inode.i_ino,
+		       NILFS_BMAP_I(btree)->vfs_inode.i_ino,
 		       (unsigned long long)bh->b_blocknr);
 		return;
 	}
@@ -1983,11 +1953,10 @@ static void nilfs_btree_add_dirty_buffer(struct nilfs_btree *btree,
 	list_add_tail(&bh->b_assoc_buffers, head);
 }
 
-static void nilfs_btree_lookup_dirty_buffers(struct nilfs_bmap *bmap,
+static void nilfs_btree_lookup_dirty_buffers(struct nilfs_bmap *btree,
 					     struct list_head *listp)
 {
-	struct nilfs_btree *btree = (struct nilfs_btree *)bmap;
-	struct address_space *btcache = &NILFS_BMAP_I(bmap)->i_btnode_cache;
+	struct address_space *btcache = &NILFS_BMAP_I(btree)->i_btnode_cache;
 	struct list_head lists[NILFS_BTREE_LEVEL_MAX];
 	struct pagevec pvec;
 	struct buffer_head *bh, *head;
@@ -2021,7 +1990,7 @@ static void nilfs_btree_lookup_dirty_buffers(struct nilfs_bmap *bmap,
 		list_splice_tail(&lists[level], listp);
 }
 
-static int nilfs_btree_assign_p(struct nilfs_btree *btree,
+static int nilfs_btree_assign_p(struct nilfs_bmap *btree,
 				struct nilfs_btree_path *path,
 				int level,
 				struct buffer_head **bh,
@@ -2041,12 +2010,12 @@ static int nilfs_btree_assign_p(struct nilfs_btree *btree,
 		path[level].bp_ctxt.newkey = blocknr;
 		path[level].bp_ctxt.bh = *bh;
 		ret = nilfs_btnode_prepare_change_key(
-			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
+			&NILFS_BMAP_I(btree)->i_btnode_cache,
 			&path[level].bp_ctxt);
 		if (ret < 0)
 			return ret;
 		nilfs_btnode_commit_change_key(
-			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
+			&NILFS_BMAP_I(btree)->i_btnode_cache,
 			&path[level].bp_ctxt);
 		*bh = path[level].bp_ctxt.bh;
 	}
@@ -2062,7 +2031,7 @@ static int nilfs_btree_assign_p(struct nilfs_btree *btree,
 	return 0;
 }
 
-static int nilfs_btree_assign_v(struct nilfs_btree *btree,
+static int nilfs_btree_assign_v(struct nilfs_bmap *btree,
 				struct nilfs_btree_path *path,
 				int level,
 				struct buffer_head **bh,
@@ -2070,15 +2039,14 @@ static int nilfs_btree_assign_v(struct nilfs_btree *btree,
 				union nilfs_binfo *binfo)
 {
 	struct nilfs_btree_node *parent;
-	struct inode *dat = nilfs_bmap_get_dat(&btree->bt_bmap);
+	struct inode *dat = nilfs_bmap_get_dat(btree);
 	__u64 key;
 	__u64 ptr;
 	union nilfs_bmap_ptr_req req;
 	int ret;
 
 	parent = nilfs_btree_get_node(btree, path, level + 1);
-	ptr = nilfs_btree_node_get_ptr(btree, parent,
-				       path[level + 1].bp_index);
+	ptr = nilfs_btree_node_get_ptr(btree, parent, path[level + 1].bp_index);
 	req.bpr_ptr = ptr;
 	ret = nilfs_dat_prepare_start(dat, &req.bpr_req);
 	if (ret < 0)
@@ -2093,18 +2061,16 @@ static int nilfs_btree_assign_v(struct nilfs_btree *btree,
 	return 0;
 }
 
-static int nilfs_btree_assign(struct nilfs_bmap *bmap,
+static int nilfs_btree_assign(struct nilfs_bmap *btree,
 			      struct buffer_head **bh,
 			      sector_t blocknr,
 			      union nilfs_binfo *binfo)
 {
-	struct nilfs_btree *btree;
 	struct nilfs_btree_path *path;
 	struct nilfs_btree_node *node;
 	__u64 key;
 	int level, ret;
 
-	btree = (struct nilfs_btree *)bmap;
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -2114,7 +2080,7 @@ static int nilfs_btree_assign(struct nilfs_bmap *bmap,
 		key = nilfs_btree_node_get_key(node, 0);
 		level = nilfs_btree_node_get_level(node);
 	} else {
-		key = nilfs_bmap_data_get_key(bmap, *bh);
+		key = nilfs_bmap_data_get_key(btree, *bh);
 		level = NILFS_BTREE_LEVEL_DATA;
 	}
 
@@ -2124,7 +2090,7 @@ static int nilfs_btree_assign(struct nilfs_bmap *bmap,
 		goto out;
 	}
 
-	ret = NILFS_BMAP_USE_VBN(bmap) ?
+	ret = NILFS_BMAP_USE_VBN(btree) ?
 		nilfs_btree_assign_v(btree, path, level, bh, blocknr, binfo) :
 		nilfs_btree_assign_p(btree, path, level, bh, blocknr, binfo);
 
@@ -2134,7 +2100,7 @@ static int nilfs_btree_assign(struct nilfs_bmap *bmap,
 	return ret;
 }
 
-static int nilfs_btree_assign_gc(struct nilfs_bmap *bmap,
+static int nilfs_btree_assign_gc(struct nilfs_bmap *btree,
 				 struct buffer_head **bh,
 				 sector_t blocknr,
 				 union nilfs_binfo *binfo)
@@ -2143,7 +2109,7 @@ static int nilfs_btree_assign_gc(struct nilfs_bmap *bmap,
 	__u64 key;
 	int ret;
 
-	ret = nilfs_dat_move(nilfs_bmap_get_dat(bmap), (*bh)->b_blocknr,
+	ret = nilfs_dat_move(nilfs_bmap_get_dat(btree), (*bh)->b_blocknr,
 			     blocknr);
 	if (ret < 0)
 		return ret;
@@ -2152,7 +2118,7 @@ static int nilfs_btree_assign_gc(struct nilfs_bmap *bmap,
 		node = (struct nilfs_btree_node *)(*bh)->b_data;
 		key = nilfs_btree_node_get_key(node, 0);
 	} else
-		key = nilfs_bmap_data_get_key(bmap, *bh);
+		key = nilfs_bmap_data_get_key(btree, *bh);
 
 	/* on-disk format */
 	binfo->bi_v.bi_vblocknr = cpu_to_le64((*bh)->b_blocknr);
@@ -2161,15 +2127,13 @@ static int nilfs_btree_assign_gc(struct nilfs_bmap *bmap,
 	return 0;
 }
 
-static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
+static int nilfs_btree_mark(struct nilfs_bmap *btree, __u64 key, int level)
 {
 	struct buffer_head *bh;
-	struct nilfs_btree *btree;
 	struct nilfs_btree_path *path;
 	__u64 ptr;
 	int ret;
 
-	btree = (struct nilfs_btree *)bmap;
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -2188,8 +2152,8 @@ static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 	if (!buffer_dirty(bh))
 		nilfs_btnode_mark_dirty(bh);
 	brelse(bh);
-	if (!nilfs_bmap_dirty(&btree->bt_bmap))
-		nilfs_bmap_set_dirty(&btree->bt_bmap);
+	if (!nilfs_bmap_dirty(btree))
+		nilfs_bmap_set_dirty(btree);
 
  out:
 	nilfs_btree_free_path(path);
diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index 980e1e8..cffbfba 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -54,7 +54,7 @@ struct nilfs_btree_path {
 	union nilfs_bmap_ptr_req bp_oldreq;
 	union nilfs_bmap_ptr_req bp_newreq;
 	struct nilfs_btnode_chkey_ctxt bp_ctxt;
-	void (*bp_op)(struct nilfs_btree *, struct nilfs_btree_path *,
+	void (*bp_op)(struct nilfs_bmap *, struct nilfs_btree_path *,
 		      int, __u64 *, __u64 *);
 };
 
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
