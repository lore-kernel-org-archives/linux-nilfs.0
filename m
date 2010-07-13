From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/5] nilfs2: reduce repetitive calculation of max number of child nodes
Date: Tue, 13 Jul 2010 23:33:53 +0900
Message-ID: <1279031635-6717-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1279031635-6717-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279031635-6717-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The current btree implementation repeats the same calculation on the
maximum number of child nodes.  This is because a few low level
routines use the calculation for index addressing in a btree node
block.

This reduces the calculation by explicitly passing the maximum number
of child nodes (ncmax) through their argument.

This changes parameter passing of the following functions:

 - nilfs_btree_node_dptrs
 - nilfs_btree_node_get_ptr
 - nilfs_btree_node_set_ptr
 - nilfs_btree_node_init
 - nilfs_btree_node_move_left
 - nilfs_btree_node_move_right
 - nilfs_btree_node_insert
 - nilfs_btree_node_delete, and
 - nilfs_btree_get_node

The following functions are removed:

 - nilfs_btree_node_nchildren_min
 - nilfs_btree_node_nchildren_max

Most middle level btree operations are rewritten to pass a proper
ncmax value depending on whether each occurrence of node is "root" or
not.

A constant NILFS_BTREE_ROOT_NCHILDREN_MAX is used for the root node,
whereas nilfs_btree_nchildren_per_block() function is used for
non-root nodes.  If a node could be either root or a non-root node, an
output argument of nilfs_btree_get_node() is used to set up ncmax.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |  339 ++++++++++++++++++++++++++++-------------------------
 1 files changed, 182 insertions(+), 157 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 24d454c..fef84a6 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -151,22 +151,9 @@ static inline int nilfs_btree_node_size(const struct nilfs_bmap *btree)
 	return 1 << btree->b_inode->i_blkbits;
 }
 
-static inline int
-nilfs_btree_node_nchildren_min(const struct nilfs_btree_node *node,
-			       const struct nilfs_bmap *btree)
-{
-	return nilfs_btree_node_root(node) ?
-		NILFS_BTREE_ROOT_NCHILDREN_MIN :
-		NILFS_BTREE_NODE_NCHILDREN_MIN(nilfs_btree_node_size(btree));
-}
-
-static inline int
-nilfs_btree_node_nchildren_max(const struct nilfs_btree_node *node,
-			       const struct nilfs_bmap *btree)
+static int nilfs_btree_nchildren_per_block(const struct nilfs_bmap *btree)
 {
-	return nilfs_btree_node_root(node) ?
-		NILFS_BTREE_ROOT_NCHILDREN_MAX :
-		NILFS_BTREE_NODE_NCHILDREN_MAX(nilfs_btree_node_size(btree));
+	return NILFS_BTREE_NODE_NCHILDREN_MAX(nilfs_btree_node_size(btree));
 }
 
 static inline __le64 *
@@ -178,11 +165,9 @@ nilfs_btree_node_dkeys(const struct nilfs_btree_node *node)
 }
 
 static inline __le64 *
-nilfs_btree_node_dptrs(const struct nilfs_btree_node *node,
-		       const struct nilfs_bmap *btree)
+nilfs_btree_node_dptrs(const struct nilfs_btree_node *node, int ncmax)
 {
-	return (__le64 *)(nilfs_btree_node_dkeys(node) +
-			  nilfs_btree_node_nchildren_max(node, btree));
+	return (__le64 *)(nilfs_btree_node_dkeys(node) + ncmax);
 }
 
 static inline __u64
@@ -198,22 +183,21 @@ nilfs_btree_node_set_key(struct nilfs_btree_node *node, int index, __u64 key)
 }
 
 static inline __u64
-nilfs_btree_node_get_ptr(const struct nilfs_bmap *btree,
-			 const struct nilfs_btree_node *node, int index)
+nilfs_btree_node_get_ptr(const struct nilfs_btree_node *node, int index,
+			 int ncmax)
 {
-	return le64_to_cpu(*(nilfs_btree_node_dptrs(node, btree) + index));
+	return le64_to_cpu(*(nilfs_btree_node_dptrs(node, ncmax) + index));
 }
 
 static inline void
-nilfs_btree_node_set_ptr(struct nilfs_bmap *btree,
-			 struct nilfs_btree_node *node, int index, __u64 ptr)
+nilfs_btree_node_set_ptr(struct nilfs_btree_node *node, int index, __u64 ptr,
+			 int ncmax)
 {
-	*(nilfs_btree_node_dptrs(node, btree) + index) = cpu_to_le64(ptr);
+	*(nilfs_btree_node_dptrs(node, ncmax) + index) = cpu_to_le64(ptr);
 }
 
-static void nilfs_btree_node_init(struct nilfs_bmap *btree,
-				  struct nilfs_btree_node *node,
-				  int flags, int level, int nchildren,
+static void nilfs_btree_node_init(struct nilfs_btree_node *node, int flags,
+				  int level, int nchildren, int ncmax,
 				  const __u64 *keys, const __u64 *ptrs)
 {
 	__le64 *dkeys;
@@ -225,7 +209,7 @@ static void nilfs_btree_node_init(struct nilfs_bmap *btree,
 	nilfs_btree_node_set_nchildren(node, nchildren);
 
 	dkeys = nilfs_btree_node_dkeys(node);
-	dptrs = nilfs_btree_node_dptrs(node, btree);
+	dptrs = nilfs_btree_node_dptrs(node, ncmax);
 	for (i = 0; i < nchildren; i++) {
 		dkeys[i] = cpu_to_le64(keys[i]);
 		dptrs[i] = cpu_to_le64(ptrs[i]);
@@ -233,21 +217,20 @@ static void nilfs_btree_node_init(struct nilfs_bmap *btree,
 }
 
 /* Assume the buffer heads corresponding to left and right are locked. */
-static void nilfs_btree_node_move_left(struct nilfs_bmap *btree,
-				       struct nilfs_btree_node *left,
+static void nilfs_btree_node_move_left(struct nilfs_btree_node *left,
 				       struct nilfs_btree_node *right,
-				       int n)
+				       int n, int lncmax, int rncmax)
 {
 	__le64 *ldkeys, *rdkeys;
 	__le64 *ldptrs, *rdptrs;
 	int lnchildren, rnchildren;
 
 	ldkeys = nilfs_btree_node_dkeys(left);
-	ldptrs = nilfs_btree_node_dptrs(left, btree);
+	ldptrs = nilfs_btree_node_dptrs(left, lncmax);
 	lnchildren = nilfs_btree_node_get_nchildren(left);
 
 	rdkeys = nilfs_btree_node_dkeys(right);
-	rdptrs = nilfs_btree_node_dptrs(right, btree);
+	rdptrs = nilfs_btree_node_dptrs(right, rncmax);
 	rnchildren = nilfs_btree_node_get_nchildren(right);
 
 	memcpy(ldkeys + lnchildren, rdkeys, n * sizeof(*rdkeys));
@@ -262,21 +245,20 @@ static void nilfs_btree_node_move_left(struct nilfs_bmap *btree,
 }
 
 /* Assume that the buffer heads corresponding to left and right are locked. */
-static void nilfs_btree_node_move_right(struct nilfs_bmap *btree,
-					struct nilfs_btree_node *left,
+static void nilfs_btree_node_move_right(struct nilfs_btree_node *left,
 					struct nilfs_btree_node *right,
-					int n)
+					int n, int lncmax, int rncmax)
 {
 	__le64 *ldkeys, *rdkeys;
 	__le64 *ldptrs, *rdptrs;
 	int lnchildren, rnchildren;
 
 	ldkeys = nilfs_btree_node_dkeys(left);
-	ldptrs = nilfs_btree_node_dptrs(left, btree);
+	ldptrs = nilfs_btree_node_dptrs(left, lncmax);
 	lnchildren = nilfs_btree_node_get_nchildren(left);
 
 	rdkeys = nilfs_btree_node_dkeys(right);
-	rdptrs = nilfs_btree_node_dptrs(right, btree);
+	rdptrs = nilfs_btree_node_dptrs(right, rncmax);
 	rnchildren = nilfs_btree_node_get_nchildren(right);
 
 	memmove(rdkeys + n, rdkeys, rnchildren * sizeof(*rdkeys));
@@ -291,16 +273,15 @@ static void nilfs_btree_node_move_right(struct nilfs_bmap *btree,
 }
 
 /* Assume that the buffer head corresponding to node is locked. */
-static void nilfs_btree_node_insert(struct nilfs_bmap *btree,
-				    struct nilfs_btree_node *node,
-				    __u64 key, __u64 ptr, int index)
+static void nilfs_btree_node_insert(struct nilfs_btree_node *node, int index,
+				    __u64 key, __u64 ptr, int ncmax)
 {
 	__le64 *dkeys;
 	__le64 *dptrs;
 	int nchildren;
 
 	dkeys = nilfs_btree_node_dkeys(node);
-	dptrs = nilfs_btree_node_dptrs(node, btree);
+	dptrs = nilfs_btree_node_dptrs(node, ncmax);
 	nchildren = nilfs_btree_node_get_nchildren(node);
 	if (index < nchildren) {
 		memmove(dkeys + index + 1, dkeys + index,
@@ -315,9 +296,8 @@ static void nilfs_btree_node_insert(struct nilfs_bmap *btree,
 }
 
 /* Assume that the buffer head corresponding to node is locked. */
-static void nilfs_btree_node_delete(struct nilfs_bmap *btree,
-				    struct nilfs_btree_node *node,
-				    __u64 *keyp, __u64 *ptrp, int index)
+static void nilfs_btree_node_delete(struct nilfs_btree_node *node, int index,
+				    __u64 *keyp, __u64 *ptrp, int ncmax)
 {
 	__u64 key;
 	__u64 ptr;
@@ -326,7 +306,7 @@ static void nilfs_btree_node_delete(struct nilfs_bmap *btree,
 	int nchildren;
 
 	dkeys = nilfs_btree_node_dkeys(node);
-	dptrs = nilfs_btree_node_dptrs(node, btree);
+	dptrs = nilfs_btree_node_dptrs(node, ncmax);
 	key = le64_to_cpu(dkeys[index]);
 	ptr = le64_to_cpu(dptrs[index]);
 	nchildren = nilfs_btree_node_get_nchildren(node);
@@ -444,14 +424,21 @@ static inline int nilfs_btree_height(const struct nilfs_bmap *btree)
 	return nilfs_btree_node_get_level(nilfs_btree_get_root(btree)) + 1;
 }
 
-static inline struct nilfs_btree_node *
+static struct nilfs_btree_node *
 nilfs_btree_get_node(const struct nilfs_bmap *btree,
 		     const struct nilfs_btree_path *path,
-		     int level)
+		     int level, int *ncmaxp)
 {
-	return (level == nilfs_btree_height(btree) - 1) ?
-		nilfs_btree_get_root(btree) :
-		nilfs_btree_get_nonroot_node(path, level);
+	struct nilfs_btree_node *node;
+
+	if (level == nilfs_btree_height(btree) - 1) {
+		node = nilfs_btree_get_root(btree);
+		*ncmaxp = NILFS_BTREE_ROOT_NCHILDREN_MAX;
+	} else {
+		node = nilfs_btree_get_nonroot_node(path, level);
+		*ncmaxp = nilfs_btree_nchildren_per_block(btree);
+	}
+	return node;
 }
 
 static inline int
@@ -480,11 +467,12 @@ static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 		return -ENOENT;
 
 	found = nilfs_btree_node_lookup(node, key, &index);
-	ptr = nilfs_btree_node_get_ptr(btree, node, index);
+	ptr = nilfs_btree_node_get_ptr(node, index,
+				       NILFS_BTREE_ROOT_NCHILDREN_MAX);
 	path[level].bp_bh = NULL;
 	path[level].bp_index = index;
 
-	ncmax = NILFS_BTREE_NODE_NCHILDREN_MAX(nilfs_btree_node_size(btree));
+	ncmax = nilfs_btree_nchildren_per_block(btree);
 
 	for (level--; level >= minlevel; level--) {
 		ret = nilfs_btree_get_block(btree, ptr, &path[level].bp_bh);
@@ -498,7 +486,7 @@ static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 		else
 			index = 0;
 		if (index < ncmax) {
-			ptr = nilfs_btree_node_get_ptr(btree, node, index);
+			ptr = nilfs_btree_node_get_ptr(node, index, ncmax);
 		} else {
 			WARN_ON(found || level != NILFS_BTREE_LEVEL_NODE_MIN);
 			/* insert */
@@ -521,16 +509,18 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_bmap *btree,
 {
 	struct nilfs_btree_node *node;
 	__u64 ptr;
-	int index, level, ret;
+	int index, level, ncmax, ret;
 
 	node = nilfs_btree_get_root(btree);
 	index = nilfs_btree_node_get_nchildren(node) - 1;
 	if (index < 0)
 		return -ENOENT;
 	level = nilfs_btree_node_get_level(node);
-	ptr = nilfs_btree_node_get_ptr(btree, node, index);
+	ptr = nilfs_btree_node_get_ptr(node, index,
+				       NILFS_BTREE_ROOT_NCHILDREN_MAX);
 	path[level].bp_bh = NULL;
 	path[level].bp_index = index;
+	ncmax = nilfs_btree_nchildren_per_block(btree);
 
 	for (level--; level > 0; level--) {
 		ret = nilfs_btree_get_block(btree, ptr, &path[level].bp_bh);
@@ -540,7 +530,7 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_bmap *btree,
 		if (nilfs_btree_bad_node(node, level))
 			return -EINVAL;
 		index = nilfs_btree_node_get_nchildren(node) - 1;
-		ptr = nilfs_btree_node_get_ptr(btree, node, index);
+		ptr = nilfs_btree_node_get_ptr(node, index, ncmax);
 		path[level].bp_index = index;
 	}
 
@@ -578,7 +568,7 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 	__u64 ptr, ptr2;
 	sector_t blocknr;
 	int level = NILFS_BTREE_LEVEL_NODE_MIN;
-	int ret, cnt, index, maxlevel;
+	int ret, cnt, index, maxlevel, ncmax;
 
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
@@ -600,14 +590,14 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 		goto end;
 
 	maxlevel = nilfs_btree_height(btree) - 1;
-	node = nilfs_btree_get_node(btree, path, level);
+	node = nilfs_btree_get_node(btree, path, level, &ncmax);
 	index = path[level].bp_index + 1;
 	for (;;) {
 		while (index < nilfs_btree_node_get_nchildren(node)) {
 			if (nilfs_btree_node_get_key(node, index) !=
 			    key + cnt)
 				goto end;
-			ptr2 = nilfs_btree_node_get_ptr(btree, node, index);
+			ptr2 = nilfs_btree_node_get_ptr(node, index, ncmax);
 			if (dat) {
 				ret = nilfs_dat_translate(dat, ptr2, &blocknr);
 				if (ret < 0)
@@ -623,12 +613,12 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 			break;
 
 		/* look-up right sibling node */
-		node = nilfs_btree_get_node(btree, path, level + 1);
+		node = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
 		index = path[level + 1].bp_index + 1;
 		if (index >= nilfs_btree_node_get_nchildren(node) ||
 		    nilfs_btree_node_get_key(node, index) != key + cnt)
 			break;
-		ptr2 = nilfs_btree_node_get_ptr(btree, node, index);
+		ptr2 = nilfs_btree_node_get_ptr(node, index, ncmax);
 		path[level + 1].bp_index = index;
 
 		brelse(path[level].bp_bh);
@@ -637,6 +627,7 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 		if (ret < 0)
 			goto out;
 		node = nilfs_btree_get_nonroot_node(path, level);
+		ncmax = nilfs_btree_nchildren_per_block(btree);
 		index = 0;
 		path[level].bp_index = index;
 	}
@@ -675,11 +666,13 @@ static void nilfs_btree_do_insert(struct nilfs_bmap *btree,
 				  int level, __u64 *keyp, __u64 *ptrp)
 {
 	struct nilfs_btree_node *node;
+	int ncblk;
 
 	if (level < nilfs_btree_height(btree) - 1) {
 		node = nilfs_btree_get_nonroot_node(path, level);
-		nilfs_btree_node_insert(btree, node, *keyp, *ptrp,
-					path[level].bp_index);
+		ncblk = nilfs_btree_nchildren_per_block(btree);
+		nilfs_btree_node_insert(node, path[level].bp_index,
+					*keyp, *ptrp, ncblk);
 		if (!buffer_dirty(path[level].bp_bh))
 			nilfs_btnode_mark_dirty(path[level].bp_bh);
 
@@ -689,8 +682,9 @@ static void nilfs_btree_do_insert(struct nilfs_bmap *btree,
 									 0));
 	} else {
 		node = nilfs_btree_get_root(btree);
-		nilfs_btree_node_insert(btree, node, *keyp, *ptrp,
-					path[level].bp_index);
+		nilfs_btree_node_insert(node, path[level].bp_index,
+					*keyp, *ptrp,
+					NILFS_BTREE_ROOT_NCHILDREN_MAX);
 	}
 }
 
@@ -699,12 +693,13 @@ static void nilfs_btree_carry_left(struct nilfs_bmap *btree,
 				   int level, __u64 *keyp, __u64 *ptrp)
 {
 	struct nilfs_btree_node *node, *left;
-	int nchildren, lnchildren, n, move;
+	int nchildren, lnchildren, n, move, ncblk;
 
 	node = nilfs_btree_get_nonroot_node(path, level);
 	left = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
 	lnchildren = nilfs_btree_node_get_nchildren(left);
+	ncblk = nilfs_btree_nchildren_per_block(btree);
 	move = 0;
 
 	n = (nchildren + lnchildren + 1) / 2 - lnchildren;
@@ -714,7 +709,7 @@ static void nilfs_btree_carry_left(struct nilfs_bmap *btree,
 		move = 1;
 	}
 
-	nilfs_btree_node_move_left(btree, left, node, n);
+	nilfs_btree_node_move_left(left, node, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_bh);
@@ -744,12 +739,13 @@ static void nilfs_btree_carry_right(struct nilfs_bmap *btree,
 				    int level, __u64 *keyp, __u64 *ptrp)
 {
 	struct nilfs_btree_node *node, *right;
-	int nchildren, rnchildren, n, move;
+	int nchildren, rnchildren, n, move, ncblk;
 
 	node = nilfs_btree_get_nonroot_node(path, level);
 	right = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
 	rnchildren = nilfs_btree_node_get_nchildren(right);
+	ncblk = nilfs_btree_nchildren_per_block(btree);
 	move = 0;
 
 	n = (nchildren + rnchildren + 1) / 2 - rnchildren;
@@ -759,7 +755,7 @@ static void nilfs_btree_carry_right(struct nilfs_bmap *btree,
 		move = 1;
 	}
 
-	nilfs_btree_node_move_right(btree, node, right, n);
+	nilfs_btree_node_move_right(node, right, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_bh);
@@ -792,11 +788,12 @@ static void nilfs_btree_split(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *node, *right;
 	__u64 newkey;
 	__u64 newptr;
-	int nchildren, n, move;
+	int nchildren, n, move, ncblk;
 
 	node = nilfs_btree_get_nonroot_node(path, level);
 	right = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
+	ncblk = nilfs_btree_nchildren_per_block(btree);
 	move = 0;
 
 	n = (nchildren + 1) / 2;
@@ -805,7 +802,7 @@ static void nilfs_btree_split(struct nilfs_bmap *btree,
 		move = 1;
 	}
 
-	nilfs_btree_node_move_right(btree, node, right, n);
+	nilfs_btree_node_move_right(node, right, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_bh);
@@ -817,8 +814,8 @@ static void nilfs_btree_split(struct nilfs_bmap *btree,
 
 	if (move) {
 		path[level].bp_index -= nilfs_btree_node_get_nchildren(node);
-		nilfs_btree_node_insert(btree, right, *keyp, *ptrp,
-					path[level].bp_index);
+		nilfs_btree_node_insert(right, path[level].bp_index,
+					*keyp, *ptrp, ncblk);
 
 		*keyp = nilfs_btree_node_get_key(right, 0);
 		*ptrp = path[level].bp_newreq.bpr_ptr;
@@ -844,14 +841,16 @@ static void nilfs_btree_grow(struct nilfs_bmap *btree,
 			     int level, __u64 *keyp, __u64 *ptrp)
 {
 	struct nilfs_btree_node *root, *child;
-	int n;
+	int n, ncblk;
 
 	root = nilfs_btree_get_root(btree);
 	child = nilfs_btree_get_sib_node(path, level);
+	ncblk = nilfs_btree_nchildren_per_block(btree);
 
 	n = nilfs_btree_node_get_nchildren(root);
 
-	nilfs_btree_node_move_right(btree, root, child, n);
+	nilfs_btree_node_move_right(root, child, n,
+				    NILFS_BTREE_ROOT_NCHILDREN_MAX, ncblk);
 	nilfs_btree_node_set_level(root, level + 1);
 
 	if (!buffer_dirty(path[level].bp_sib_bh))
@@ -870,7 +869,7 @@ static __u64 nilfs_btree_find_near(const struct nilfs_bmap *btree,
 				   const struct nilfs_btree_path *path)
 {
 	struct nilfs_btree_node *node;
-	int level;
+	int level, ncmax;
 
 	if (path == NULL)
 		return NILFS_BMAP_INVALID_PTR;
@@ -878,17 +877,18 @@ static __u64 nilfs_btree_find_near(const struct nilfs_bmap *btree,
 	/* left sibling */
 	level = NILFS_BTREE_LEVEL_NODE_MIN;
 	if (path[level].bp_index > 0) {
-		node = nilfs_btree_get_node(btree, path, level);
-		return nilfs_btree_node_get_ptr(btree, node,
-						path[level].bp_index - 1);
+		node = nilfs_btree_get_node(btree, path, level, &ncmax);
+		return nilfs_btree_node_get_ptr(node,
+						path[level].bp_index - 1,
+						ncmax);
 	}
 
 	/* parent */
 	level = NILFS_BTREE_LEVEL_NODE_MIN + 1;
 	if (level <= nilfs_btree_height(btree) - 1) {
-		node = nilfs_btree_get_node(btree, path, level);
-		return nilfs_btree_node_get_ptr(btree, node,
-						path[level].bp_index);
+		node = nilfs_btree_get_node(btree, path, level, &ncmax);
+		return nilfs_btree_node_get_ptr(node, path[level].bp_index,
+						ncmax);
 	}
 
 	return NILFS_BMAP_INVALID_PTR;
@@ -922,7 +922,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 	struct buffer_head *bh;
 	struct nilfs_btree_node *node, *parent, *sib;
 	__u64 sibptr;
-	int pindex, level, ncmax, ret;
+	int pindex, level, ncmax, ncblk, ret;
 	struct inode *dat = NULL;
 
 	stats->bs_nblocks = 0;
@@ -939,54 +939,55 @@ static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 	if (ret < 0)
 		goto err_out_data;
 
-	ncmax = NILFS_BTREE_NODE_NCHILDREN_MAX(nilfs_btree_node_size(btree));
+	ncblk = nilfs_btree_nchildren_per_block(btree);
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
 	     level < nilfs_btree_height(btree) - 1;
 	     level++) {
 		node = nilfs_btree_get_nonroot_node(path, level);
-		if (nilfs_btree_node_get_nchildren(node) < ncmax) {
+		if (nilfs_btree_node_get_nchildren(node) < ncblk) {
 			path[level].bp_op = nilfs_btree_do_insert;
 			stats->bs_nblocks++;
 			goto out;
 		}
 
-		parent = nilfs_btree_get_node(btree, path, level + 1);
+		parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
 		pindex = path[level + 1].bp_index;
 
 		/* left sibling */
 		if (pindex > 0) {
-			sibptr = nilfs_btree_node_get_ptr(btree, parent,
-							  pindex - 1);
+			sibptr = nilfs_btree_node_get_ptr(parent, pindex - 1,
+							  ncmax);
 			ret = nilfs_btree_get_block(btree, sibptr, &bh);
 			if (ret < 0)
 				goto err_out_child_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
-			if (nilfs_btree_node_get_nchildren(sib) < ncmax) {
+			if (nilfs_btree_node_get_nchildren(sib) < ncblk) {
 				path[level].bp_sib_bh = bh;
 				path[level].bp_op = nilfs_btree_carry_left;
 				stats->bs_nblocks++;
 				goto out;
-			} else
+			} else {
 				brelse(bh);
+			}
 		}
 
 		/* right sibling */
-		if (pindex <
-		    nilfs_btree_node_get_nchildren(parent) - 1) {
-			sibptr = nilfs_btree_node_get_ptr(btree, parent,
-							  pindex + 1);
+		if (pindex < nilfs_btree_node_get_nchildren(parent) - 1) {
+			sibptr = nilfs_btree_node_get_ptr(parent, pindex + 1,
+							  ncmax);
 			ret = nilfs_btree_get_block(btree, sibptr, &bh);
 			if (ret < 0)
 				goto err_out_child_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
-			if (nilfs_btree_node_get_nchildren(sib) < ncmax) {
+			if (nilfs_btree_node_get_nchildren(sib) < ncblk) {
 				path[level].bp_sib_bh = bh;
 				path[level].bp_op = nilfs_btree_carry_right;
 				stats->bs_nblocks++;
 				goto out;
-			} else
+			} else {
 				brelse(bh);
+			}
 		}
 
 		/* split */
@@ -1004,9 +1005,8 @@ static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 
 		stats->bs_nblocks++;
 
-		nilfs_btree_node_init(btree,
-				      (struct nilfs_btree_node *)bh->b_data,
-				      0, level, 0, NULL, NULL);
+		sib = (struct nilfs_btree_node *)bh->b_data;
+		nilfs_btree_node_init(sib, 0, level, 0, ncblk, NULL, NULL);
 		path[level].bp_sib_bh = bh;
 		path[level].bp_op = nilfs_btree_split;
 	}
@@ -1030,8 +1030,8 @@ static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 	if (ret < 0)
 		goto err_out_curr_node;
 
-	nilfs_btree_node_init(btree, (struct nilfs_btree_node *)bh->b_data,
-			      0, level, 0, NULL, NULL);
+	nilfs_btree_node_init((struct nilfs_btree_node *)bh->b_data,
+			      0, level, 0, ncblk, NULL, NULL);
 	path[level].bp_sib_bh = bh;
 	path[level].bp_op = nilfs_btree_grow;
 
@@ -1121,11 +1121,13 @@ static void nilfs_btree_do_delete(struct nilfs_bmap *btree,
 				  int level, __u64 *keyp, __u64 *ptrp)
 {
 	struct nilfs_btree_node *node;
+	int ncblk;
 
 	if (level < nilfs_btree_height(btree) - 1) {
 		node = nilfs_btree_get_nonroot_node(path, level);
-		nilfs_btree_node_delete(btree, node, keyp, ptrp,
-					path[level].bp_index);
+		ncblk = nilfs_btree_nchildren_per_block(btree);
+		nilfs_btree_node_delete(node, path[level].bp_index,
+					keyp, ptrp, ncblk);
 		if (!buffer_dirty(path[level].bp_bh))
 			nilfs_btnode_mark_dirty(path[level].bp_bh);
 		if (path[level].bp_index == 0)
@@ -1133,8 +1135,9 @@ static void nilfs_btree_do_delete(struct nilfs_bmap *btree,
 				nilfs_btree_node_get_key(node, 0));
 	} else {
 		node = nilfs_btree_get_root(btree);
-		nilfs_btree_node_delete(btree, node, keyp, ptrp,
-					path[level].bp_index);
+		nilfs_btree_node_delete(node, path[level].bp_index,
+					keyp, ptrp,
+					NILFS_BTREE_ROOT_NCHILDREN_MAX);
 	}
 }
 
@@ -1143,7 +1146,7 @@ static void nilfs_btree_borrow_left(struct nilfs_bmap *btree,
 				    int level, __u64 *keyp, __u64 *ptrp)
 {
 	struct nilfs_btree_node *node, *left;
-	int nchildren, lnchildren, n;
+	int nchildren, lnchildren, n, ncblk;
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
@@ -1151,10 +1154,11 @@ static void nilfs_btree_borrow_left(struct nilfs_bmap *btree,
 	left = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
 	lnchildren = nilfs_btree_node_get_nchildren(left);
+	ncblk = nilfs_btree_nchildren_per_block(btree);
 
 	n = (nchildren + lnchildren) / 2 - nchildren;
 
-	nilfs_btree_node_move_right(btree, left, node, n);
+	nilfs_btree_node_move_right(left, node, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_bh);
@@ -1174,7 +1178,7 @@ static void nilfs_btree_borrow_right(struct nilfs_bmap *btree,
 				     int level, __u64 *keyp, __u64 *ptrp)
 {
 	struct nilfs_btree_node *node, *right;
-	int nchildren, rnchildren, n;
+	int nchildren, rnchildren, n, ncblk;
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
@@ -1182,10 +1186,11 @@ static void nilfs_btree_borrow_right(struct nilfs_bmap *btree,
 	right = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
 	rnchildren = nilfs_btree_node_get_nchildren(right);
+	ncblk = nilfs_btree_nchildren_per_block(btree);
 
 	n = (nchildren + rnchildren) / 2 - nchildren;
 
-	nilfs_btree_node_move_left(btree, node, right, n);
+	nilfs_btree_node_move_left(node, right, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_bh);
@@ -1206,16 +1211,17 @@ static void nilfs_btree_concat_left(struct nilfs_bmap *btree,
 				    int level, __u64 *keyp, __u64 *ptrp)
 {
 	struct nilfs_btree_node *node, *left;
-	int n;
+	int n, ncblk;
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
 	node = nilfs_btree_get_nonroot_node(path, level);
 	left = nilfs_btree_get_sib_node(path, level);
+	ncblk = nilfs_btree_nchildren_per_block(btree);
 
 	n = nilfs_btree_node_get_nchildren(node);
 
-	nilfs_btree_node_move_left(btree, left, node, n);
+	nilfs_btree_node_move_left(left, node, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_sib_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
@@ -1231,16 +1237,17 @@ static void nilfs_btree_concat_right(struct nilfs_bmap *btree,
 				     int level, __u64 *keyp, __u64 *ptrp)
 {
 	struct nilfs_btree_node *node, *right;
-	int n;
+	int n, ncblk;
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
 	node = nilfs_btree_get_nonroot_node(path, level);
 	right = nilfs_btree_get_sib_node(path, level);
+	ncblk = nilfs_btree_nchildren_per_block(btree);
 
 	n = nilfs_btree_node_get_nchildren(right);
 
-	nilfs_btree_node_move_left(btree, node, right, n);
+	nilfs_btree_node_move_left(node, right, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_bh);
@@ -1255,17 +1262,20 @@ static void nilfs_btree_shrink(struct nilfs_bmap *btree,
 			       int level, __u64 *keyp, __u64 *ptrp)
 {
 	struct nilfs_btree_node *root, *child;
-	int n;
+	int n, ncblk;
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
 	root = nilfs_btree_get_root(btree);
 	child = nilfs_btree_get_nonroot_node(path, level);
+	ncblk = nilfs_btree_nchildren_per_block(btree);
 
-	nilfs_btree_node_delete(btree, root, NULL, NULL, 0);
+	nilfs_btree_node_delete(root, 0, NULL, NULL,
+				NILFS_BTREE_ROOT_NCHILDREN_MAX);
 	nilfs_btree_node_set_level(root, level);
 	n = nilfs_btree_node_get_nchildren(child);
-	nilfs_btree_node_move_left(btree, root, child, n);
+	nilfs_btree_node_move_left(root, child, n,
+				   NILFS_BTREE_ROOT_NCHILDREN_MAX, ncblk);
 
 	nilfs_btnode_delete(path[level].bp_bh);
 	path[level].bp_bh = NULL;
@@ -1281,19 +1291,20 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 	struct buffer_head *bh;
 	struct nilfs_btree_node *node, *parent, *sib;
 	__u64 sibptr;
-	int pindex, level, ncmin, ret;
+	int pindex, level, ncmin, ncmax, ncblk, ret;
 
 	ret = 0;
 	stats->bs_nblocks = 0;
 	ncmin = NILFS_BTREE_NODE_NCHILDREN_MIN(nilfs_btree_node_size(btree));
+	ncblk = nilfs_btree_nchildren_per_block(btree);
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
 	     level < nilfs_btree_height(btree) - 1;
 	     level++) {
 		node = nilfs_btree_get_nonroot_node(path, level);
 		path[level].bp_oldreq.bpr_ptr =
-			nilfs_btree_node_get_ptr(btree, node,
-						 path[level].bp_index);
+			nilfs_btree_node_get_ptr(node, path[level].bp_index,
+						 ncblk);
 		ret = nilfs_bmap_prepare_end_ptr(btree,
 						 &path[level].bp_oldreq, dat);
 		if (ret < 0)
@@ -1305,13 +1316,13 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 			goto out;
 		}
 
-		parent = nilfs_btree_get_node(btree, path, level + 1);
+		parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
 		pindex = path[level + 1].bp_index;
 
 		if (pindex > 0) {
 			/* left sibling */
-			sibptr = nilfs_btree_node_get_ptr(btree, parent,
-							  pindex - 1);
+			sibptr = nilfs_btree_node_get_ptr(parent, pindex - 1,
+							  ncmax);
 			ret = nilfs_btree_get_block(btree, sibptr, &bh);
 			if (ret < 0)
 				goto err_out_curr_node;
@@ -1330,8 +1341,8 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 		} else if (pindex <
 			   nilfs_btree_node_get_nchildren(parent) - 1) {
 			/* right sibling */
-			sibptr = nilfs_btree_node_get_ptr(btree, parent,
-							  pindex + 1);
+			sibptr = nilfs_btree_node_get_ptr(parent, pindex + 1,
+							  ncmax);
 			ret = nilfs_btree_get_block(btree, sibptr, &bh);
 			if (ret < 0)
 				goto err_out_curr_node;
@@ -1367,7 +1378,8 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 
 	node = nilfs_btree_get_root(btree);
 	path[level].bp_oldreq.bpr_ptr =
-		nilfs_btree_node_get_ptr(btree, node, path[level].bp_index);
+		nilfs_btree_node_get_ptr(node, path[level].bp_index,
+					 NILFS_BTREE_ROOT_NCHILDREN_MAX);
 
 	ret = nilfs_bmap_prepare_end_ptr(btree, &path[level].bp_oldreq, dat);
 	if (ret < 0)
@@ -1475,7 +1487,8 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
 		nchildren = nilfs_btree_node_get_nchildren(root);
 		if (nchildren > 1)
 			return 0;
-		ptr = nilfs_btree_node_get_ptr(btree, root, nchildren - 1);
+		ptr = nilfs_btree_node_get_ptr(root, nchildren - 1,
+					       NILFS_BTREE_ROOT_NCHILDREN_MAX);
 		ret = nilfs_btree_get_block(btree, ptr, &bh);
 		if (ret < 0)
 			return ret;
@@ -1503,22 +1516,25 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *btree,
 	__le64 *dkeys;
 	__le64 *dptrs;
 	__u64 ptr;
-	int nchildren, i, ret;
+	int nchildren, ncmax, i, ret;
 
 	root = nilfs_btree_get_root(btree);
 	switch (nilfs_btree_height(btree)) {
 	case 2:
 		bh = NULL;
 		node = root;
+		ncmax = NILFS_BTREE_ROOT_NCHILDREN_MAX;
 		break;
 	case 3:
 		nchildren = nilfs_btree_node_get_nchildren(root);
 		WARN_ON(nchildren > 1);
-		ptr = nilfs_btree_node_get_ptr(btree, root, nchildren - 1);
+		ptr = nilfs_btree_node_get_ptr(root, nchildren - 1,
+					       NILFS_BTREE_ROOT_NCHILDREN_MAX);
 		ret = nilfs_btree_get_block(btree, ptr, &bh);
 		if (ret < 0)
 			return ret;
 		node = (struct nilfs_btree_node *)bh->b_data;
+		ncmax = nilfs_btree_nchildren_per_block(btree);
 		break;
 	default:
 		node = NULL;
@@ -1529,7 +1545,7 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *btree,
 	if (nchildren < nitems)
 		nitems = nchildren;
 	dkeys = nilfs_btree_node_dkeys(node);
-	dptrs = nilfs_btree_node_dptrs(node, btree);
+	dptrs = nilfs_btree_node_dptrs(node, ncmax);
 	for (i = 0; i < nitems; i++) {
 		keys[i] = le64_to_cpu(dkeys[i]);
 		ptrs[i] = le64_to_cpu(dptrs[i]);
@@ -1606,6 +1622,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *node;
 	struct inode *dat;
 	__u64 tmpptr;
+	int ncblk;
 
 	/* free resources */
 	if (btree->b_ops->bop_clear != NULL)
@@ -1623,8 +1640,9 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *btree,
 
 		/* create child node at level 1 */
 		node = (struct nilfs_btree_node *)bh->b_data;
-		nilfs_btree_node_init(btree, node, 0, 1, n, keys, ptrs);
-		nilfs_btree_node_insert(btree, node, key, dreq->bpr_ptr, n);
+		ncblk = nilfs_btree_nchildren_per_block(btree);
+		nilfs_btree_node_init(node, 0, 1, n, ncblk, keys, ptrs);
+		nilfs_btree_node_insert(node, n, key, dreq->bpr_ptr, ncblk);
 		if (!buffer_dirty(bh))
 			nilfs_btnode_mark_dirty(bh);
 		if (!nilfs_bmap_dirty(btree))
@@ -1635,16 +1653,19 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *btree,
 		/* create root node at level 2 */
 		node = nilfs_btree_get_root(btree);
 		tmpptr = nreq->bpr_ptr;
-		nilfs_btree_node_init(btree, node, NILFS_BTREE_NODE_ROOT,
-				      2, 1, &keys[0], &tmpptr);
+		nilfs_btree_node_init(node, NILFS_BTREE_NODE_ROOT, 2, 1,
+				      NILFS_BTREE_ROOT_NCHILDREN_MAX,
+				      &keys[0], &tmpptr);
 	} else {
 		nilfs_bmap_commit_alloc_ptr(btree, dreq, dat);
 
 		/* create root node at level 1 */
 		node = nilfs_btree_get_root(btree);
-		nilfs_btree_node_init(btree, node, NILFS_BTREE_NODE_ROOT,
-				      1, n, keys, ptrs);
-		nilfs_btree_node_insert(btree, node, key, dreq->bpr_ptr, n);
+		nilfs_btree_node_init(node, NILFS_BTREE_NODE_ROOT, 1, n,
+				      NILFS_BTREE_ROOT_NCHILDREN_MAX,
+				      keys, ptrs);
+		nilfs_btree_node_insert(node, n, key, dreq->bpr_ptr,
+					NILFS_BTREE_ROOT_NCHILDREN_MAX);
 		if (!nilfs_bmap_dirty(btree))
 			nilfs_bmap_set_dirty(btree);
 	}
@@ -1711,12 +1732,12 @@ static int nilfs_btree_prepare_update_v(struct nilfs_bmap *btree,
 					int level, struct inode *dat)
 {
 	struct nilfs_btree_node *parent;
-	int ret;
+	int ncmax, ret;
 
-	parent = nilfs_btree_get_node(btree, path, level + 1);
+	parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
 	path[level].bp_oldreq.bpr_ptr =
-		nilfs_btree_node_get_ptr(btree, parent,
-					 path[level + 1].bp_index);
+		nilfs_btree_node_get_ptr(parent, path[level + 1].bp_index,
+					 ncmax);
 	path[level].bp_newreq.bpr_ptr = path[level].bp_oldreq.bpr_ptr + 1;
 	ret = nilfs_dat_prepare_update(dat, &path[level].bp_oldreq.bpr_req,
 				       &path[level].bp_newreq.bpr_req);
@@ -1746,6 +1767,7 @@ static void nilfs_btree_commit_update_v(struct nilfs_bmap *btree,
 					int level, struct inode *dat)
 {
 	struct nilfs_btree_node *parent;
+	int ncmax;
 
 	nilfs_dat_commit_update(dat, &path[level].bp_oldreq.bpr_req,
 				&path[level].bp_newreq.bpr_req,
@@ -1759,9 +1781,9 @@ static void nilfs_btree_commit_update_v(struct nilfs_bmap *btree,
 	}
 	set_buffer_nilfs_volatile(path[level].bp_bh);
 
-	parent = nilfs_btree_get_node(btree, path, level + 1);
-	nilfs_btree_node_set_ptr(btree, parent, path[level + 1].bp_index,
-				 path[level].bp_newreq.bpr_ptr);
+	parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
+	nilfs_btree_node_set_ptr(parent, path[level + 1].bp_index,
+				 path[level].bp_newreq.bpr_ptr, ncmax);
 }
 
 static void nilfs_btree_abort_update_v(struct nilfs_bmap *btree,
@@ -1834,6 +1856,7 @@ static int nilfs_btree_propagate_v(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *parent;
 	struct inode *dat = nilfs_bmap_get_dat(btree);
 	__u64 ptr;
+	int ncmax;
 
 	get_bh(bh);
 	path[level].bp_bh = bh;
@@ -1843,9 +1866,10 @@ static int nilfs_btree_propagate_v(struct nilfs_bmap *btree,
 		goto out;
 
 	if (buffer_nilfs_volatile(path[level].bp_bh)) {
-		parent = nilfs_btree_get_node(btree, path, level + 1);
-		ptr = nilfs_btree_node_get_ptr(btree, parent,
-					       path[level + 1].bp_index);
+		parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
+		ptr = nilfs_btree_node_get_ptr(parent,
+					       path[level + 1].bp_index,
+					       ncmax);
 		ret = nilfs_dat_mark_dirty(dat, ptr);
 		if (ret < 0)
 			goto out;
@@ -1989,11 +2013,11 @@ static int nilfs_btree_assign_p(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *parent;
 	__u64 key;
 	__u64 ptr;
-	int ret;
+	int ncmax, ret;
 
-	parent = nilfs_btree_get_node(btree, path, level + 1);
-	ptr = nilfs_btree_node_get_ptr(btree, parent,
-				       path[level + 1].bp_index);
+	parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
+	ptr = nilfs_btree_node_get_ptr(parent, path[level + 1].bp_index,
+				       ncmax);
 	if (buffer_nilfs_node(*bh)) {
 		path[level].bp_ctxt.oldkey = ptr;
 		path[level].bp_ctxt.newkey = blocknr;
@@ -2009,8 +2033,8 @@ static int nilfs_btree_assign_p(struct nilfs_bmap *btree,
 		*bh = path[level].bp_ctxt.bh;
 	}
 
-	nilfs_btree_node_set_ptr(btree, parent,
-				 path[level + 1].bp_index, blocknr);
+	nilfs_btree_node_set_ptr(parent, path[level + 1].bp_index, blocknr,
+				 ncmax);
 
 	key = nilfs_btree_node_get_key(parent, path[level + 1].bp_index);
 	/* on-disk format */
@@ -2032,10 +2056,11 @@ static int nilfs_btree_assign_v(struct nilfs_bmap *btree,
 	__u64 key;
 	__u64 ptr;
 	union nilfs_bmap_ptr_req req;
-	int ret;
+	int ncmax, ret;
 
-	parent = nilfs_btree_get_node(btree, path, level + 1);
-	ptr = nilfs_btree_node_get_ptr(btree, parent, path[level + 1].bp_index);
+	parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
+	ptr = nilfs_btree_node_get_ptr(parent, path[level + 1].bp_index,
+				       ncmax);
 	req.bpr_ptr = ptr;
 	ret = nilfs_dat_prepare_start(dat, &req.bpr_req);
 	if (ret < 0)
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
