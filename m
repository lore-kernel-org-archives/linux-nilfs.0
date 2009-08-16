From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/7] nilfs2: remove unused btree argument from
	btree functions
Date: Sun, 16 Aug 2009 15:51:05 +0900
Message-ID: <1250405470-23326-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Even though many btree functions take a btree object as their first
argument, most of them are not used in their functions.

This sticky use of the btree argument is hurting code readability and
giving the possibility of inefficient code generation.

So, this removes unnecessary btree argments.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |  456 ++++++++++++++++++++++++-----------------------------
 1 files changed, 208 insertions(+), 248 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index aa41272..21ed8cc 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -71,21 +71,17 @@ void nilfs_btree_path_cache_destroy(void)
 	kmem_cache_destroy(nilfs_btree_path_cache);
 }
 
-static inline struct nilfs_btree_path *
-nilfs_btree_alloc_path(const struct nilfs_btree *btree)
+static inline struct nilfs_btree_path *nilfs_btree_alloc_path(void)
 {
-	return (struct nilfs_btree_path *)
-		kmem_cache_alloc(nilfs_btree_path_cache, GFP_NOFS);
+	return kmem_cache_alloc(nilfs_btree_path_cache, GFP_NOFS);
 }
 
-static inline void nilfs_btree_free_path(const struct nilfs_btree *btree,
-					 struct nilfs_btree_path *path)
+static inline void nilfs_btree_free_path(struct nilfs_btree_path *path)
 {
 	kmem_cache_free(nilfs_btree_path_cache, path);
 }
 
-static void nilfs_btree_init_path(const struct nilfs_btree *btree,
-				  struct nilfs_btree_path *path)
+static void nilfs_btree_init_path(struct nilfs_btree_path *path)
 {
 	int level;
 
@@ -101,8 +97,7 @@ static void nilfs_btree_init_path(const struct nilfs_btree *btree,
 	}
 }
 
-static void nilfs_btree_clear_path(const struct nilfs_btree *btree,
-				   struct nilfs_btree_path *path)
+static void nilfs_btree_clear_path(struct nilfs_btree_path *path)
 {
 	int level;
 
@@ -148,129 +143,110 @@ static int nilfs_btree_get_new_block(const struct nilfs_btree *btree,
 }
 
 static inline int
-nilfs_btree_node_get_flags(const struct nilfs_btree *btree,
-			   const struct nilfs_btree_node *node)
+nilfs_btree_node_get_flags(const struct nilfs_btree_node *node)
 {
 	return node->bn_flags;
 }
 
 static inline void
-nilfs_btree_node_set_flags(struct nilfs_btree *btree,
-			   struct nilfs_btree_node *node,
-			   int flags)
+nilfs_btree_node_set_flags(struct nilfs_btree_node *node, int flags)
 {
 	node->bn_flags = flags;
 }
 
-static inline int nilfs_btree_node_root(const struct nilfs_btree *btree,
-					const struct nilfs_btree_node *node)
+static inline int nilfs_btree_node_root(const struct nilfs_btree_node *node)
 {
-	return nilfs_btree_node_get_flags(btree, node) & NILFS_BTREE_NODE_ROOT;
+	return nilfs_btree_node_get_flags(node) & NILFS_BTREE_NODE_ROOT;
 }
 
 static inline int
-nilfs_btree_node_get_level(const struct nilfs_btree *btree,
-			   const struct nilfs_btree_node *node)
+nilfs_btree_node_get_level(const struct nilfs_btree_node *node)
 {
 	return node->bn_level;
 }
 
 static inline void
-nilfs_btree_node_set_level(struct nilfs_btree *btree,
-			   struct nilfs_btree_node *node,
-			   int level)
+nilfs_btree_node_set_level(struct nilfs_btree_node *node, int level)
 {
 	node->bn_level = level;
 }
 
 static inline int
-nilfs_btree_node_get_nchildren(const struct nilfs_btree *btree,
-			       const struct nilfs_btree_node *node)
+nilfs_btree_node_get_nchildren(const struct nilfs_btree_node *node)
 {
 	return le16_to_cpu(node->bn_nchildren);
 }
 
 static inline void
-nilfs_btree_node_set_nchildren(struct nilfs_btree *btree,
-			       struct nilfs_btree_node *node,
-			       int nchildren)
+nilfs_btree_node_set_nchildren(struct nilfs_btree_node *node, int nchildren)
 {
 	node->bn_nchildren = cpu_to_le16(nchildren);
 }
 
-static inline int
-nilfs_btree_node_size(const struct nilfs_btree *btree)
+static inline int nilfs_btree_node_size(const struct nilfs_btree *btree)
 {
 	return 1 << btree->bt_bmap.b_inode->i_blkbits;
 }
 
 static inline int
-nilfs_btree_node_nchildren_min(const struct nilfs_btree *btree,
-			       const struct nilfs_btree_node *node)
+nilfs_btree_node_nchildren_min(const struct nilfs_btree_node *node,
+			       const struct nilfs_btree *btree)
 {
-	return nilfs_btree_node_root(btree, node) ?
+	return nilfs_btree_node_root(node) ?
 		NILFS_BTREE_ROOT_NCHILDREN_MIN :
 		NILFS_BTREE_NODE_NCHILDREN_MIN(nilfs_btree_node_size(btree));
 }
 
 static inline int
-nilfs_btree_node_nchildren_max(const struct nilfs_btree *btree,
-			       const struct nilfs_btree_node *node)
+nilfs_btree_node_nchildren_max(const struct nilfs_btree_node *node,
+			       const struct nilfs_btree *btree)
 {
-	return nilfs_btree_node_root(btree, node) ?
+	return nilfs_btree_node_root(node) ?
 		NILFS_BTREE_ROOT_NCHILDREN_MAX :
 		NILFS_BTREE_NODE_NCHILDREN_MAX(nilfs_btree_node_size(btree));
 }
 
 static inline __le64 *
-nilfs_btree_node_dkeys(const struct nilfs_btree *btree,
-		       const struct nilfs_btree_node *node)
+nilfs_btree_node_dkeys(const struct nilfs_btree_node *node)
 {
 	return (__le64 *)((char *)(node + 1) +
-			  (nilfs_btree_node_root(btree, node) ?
+			  (nilfs_btree_node_root(node) ?
 			   0 : NILFS_BTREE_NODE_EXTRA_PAD_SIZE));
 }
 
 static inline __le64 *
-nilfs_btree_node_dptrs(const struct nilfs_btree *btree,
-		       const struct nilfs_btree_node *node)
+nilfs_btree_node_dptrs(const struct nilfs_btree_node *node,
+		       const struct nilfs_btree *btree)
 {
-	return (__le64 *)(nilfs_btree_node_dkeys(btree, node) +
-			  nilfs_btree_node_nchildren_max(btree, node));
+	return (__le64 *)(nilfs_btree_node_dkeys(node) +
+			  nilfs_btree_node_nchildren_max(node, btree));
 }
 
 static inline __u64
-nilfs_btree_node_get_key(const struct nilfs_btree *btree,
-			 const struct nilfs_btree_node *node, int index)
+nilfs_btree_node_get_key(const struct nilfs_btree_node *node, int index)
 {
-	return nilfs_bmap_dkey_to_key(*(nilfs_btree_node_dkeys(btree, node) +
-					index));
+	return nilfs_bmap_dkey_to_key(*(nilfs_btree_node_dkeys(node) + index));
 }
 
 static inline void
-nilfs_btree_node_set_key(struct nilfs_btree *btree,
-			 struct nilfs_btree_node *node, int index, __u64 key)
+nilfs_btree_node_set_key(struct nilfs_btree_node *node, int index, __u64 key)
 {
-	*(nilfs_btree_node_dkeys(btree, node) + index) =
-		nilfs_bmap_key_to_dkey(key);
+	*(nilfs_btree_node_dkeys(node) + index) = nilfs_bmap_key_to_dkey(key);
 }
 
 static inline __u64
 nilfs_btree_node_get_ptr(const struct nilfs_btree *btree,
-			 const struct nilfs_btree_node *node,
-			 int index)
+			 const struct nilfs_btree_node *node, int index)
 {
-	return nilfs_bmap_dptr_to_ptr(*(nilfs_btree_node_dptrs(btree, node) +
+	return nilfs_bmap_dptr_to_ptr(*(nilfs_btree_node_dptrs(node, btree) +
 					index));
 }
 
 static inline void
 nilfs_btree_node_set_ptr(struct nilfs_btree *btree,
-			 struct nilfs_btree_node *node,
-			 int index,
-			 __u64 ptr)
+			 struct nilfs_btree_node *node, int index, __u64 ptr)
 {
-	*(nilfs_btree_node_dptrs(btree, node) + index) =
+	*(nilfs_btree_node_dptrs(node, btree) + index) =
 		nilfs_bmap_ptr_to_dptr(ptr);
 }
 
@@ -283,12 +259,12 @@ static void nilfs_btree_node_init(struct nilfs_btree *btree,
 	__le64 *dptrs;
 	int i;
 
-	nilfs_btree_node_set_flags(btree, node, flags);
-	nilfs_btree_node_set_level(btree, node, level);
-	nilfs_btree_node_set_nchildren(btree, node, nchildren);
+	nilfs_btree_node_set_flags(node, flags);
+	nilfs_btree_node_set_level(node, level);
+	nilfs_btree_node_set_nchildren(node, nchildren);
 
-	dkeys = nilfs_btree_node_dkeys(btree, node);
-	dptrs = nilfs_btree_node_dptrs(btree, node);
+	dkeys = nilfs_btree_node_dkeys(node);
+	dptrs = nilfs_btree_node_dptrs(node, btree);
 	for (i = 0; i < nchildren; i++) {
 		dkeys[i] = nilfs_bmap_key_to_dkey(keys[i]);
 		dptrs[i] = nilfs_bmap_ptr_to_dptr(ptrs[i]);
@@ -305,13 +281,13 @@ static void nilfs_btree_node_move_left(struct nilfs_btree *btree,
 	__le64 *ldptrs, *rdptrs;
 	int lnchildren, rnchildren;
 
-	ldkeys = nilfs_btree_node_dkeys(btree, left);
-	ldptrs = nilfs_btree_node_dptrs(btree, left);
-	lnchildren = nilfs_btree_node_get_nchildren(btree, left);
+	ldkeys = nilfs_btree_node_dkeys(left);
+	ldptrs = nilfs_btree_node_dptrs(left, btree);
+	lnchildren = nilfs_btree_node_get_nchildren(left);
 
-	rdkeys = nilfs_btree_node_dkeys(btree, right);
-	rdptrs = nilfs_btree_node_dptrs(btree, right);
-	rnchildren = nilfs_btree_node_get_nchildren(btree, right);
+	rdkeys = nilfs_btree_node_dkeys(right);
+	rdptrs = nilfs_btree_node_dptrs(right, btree);
+	rnchildren = nilfs_btree_node_get_nchildren(right);
 
 	memcpy(ldkeys + lnchildren, rdkeys, n * sizeof(*rdkeys));
 	memcpy(ldptrs + lnchildren, rdptrs, n * sizeof(*rdptrs));
@@ -320,8 +296,8 @@ static void nilfs_btree_node_move_left(struct nilfs_btree *btree,
 
 	lnchildren += n;
 	rnchildren -= n;
-	nilfs_btree_node_set_nchildren(btree, left, lnchildren);
-	nilfs_btree_node_set_nchildren(btree, right, rnchildren);
+	nilfs_btree_node_set_nchildren(left, lnchildren);
+	nilfs_btree_node_set_nchildren(right, rnchildren);
 }
 
 /* Assume that the buffer heads corresponding to left and right are locked. */
@@ -334,13 +310,13 @@ static void nilfs_btree_node_move_right(struct nilfs_btree *btree,
 	__le64 *ldptrs, *rdptrs;
 	int lnchildren, rnchildren;
 
-	ldkeys = nilfs_btree_node_dkeys(btree, left);
-	ldptrs = nilfs_btree_node_dptrs(btree, left);
-	lnchildren = nilfs_btree_node_get_nchildren(btree, left);
+	ldkeys = nilfs_btree_node_dkeys(left);
+	ldptrs = nilfs_btree_node_dptrs(left, btree);
+	lnchildren = nilfs_btree_node_get_nchildren(left);
 
-	rdkeys = nilfs_btree_node_dkeys(btree, right);
-	rdptrs = nilfs_btree_node_dptrs(btree, right);
-	rnchildren = nilfs_btree_node_get_nchildren(btree, right);
+	rdkeys = nilfs_btree_node_dkeys(right);
+	rdptrs = nilfs_btree_node_dptrs(right, btree);
+	rnchildren = nilfs_btree_node_get_nchildren(right);
 
 	memmove(rdkeys + n, rdkeys, rnchildren * sizeof(*rdkeys));
 	memmove(rdptrs + n, rdptrs, rnchildren * sizeof(*rdptrs));
@@ -349,8 +325,8 @@ static void nilfs_btree_node_move_right(struct nilfs_btree *btree,
 
 	lnchildren -= n;
 	rnchildren += n;
-	nilfs_btree_node_set_nchildren(btree, left, lnchildren);
-	nilfs_btree_node_set_nchildren(btree, right, rnchildren);
+	nilfs_btree_node_set_nchildren(left, lnchildren);
+	nilfs_btree_node_set_nchildren(right, rnchildren);
 }
 
 /* Assume that the buffer head corresponding to node is locked. */
@@ -362,9 +338,9 @@ static void nilfs_btree_node_insert(struct nilfs_btree *btree,
 	__le64 *dptrs;
 	int nchildren;
 
-	dkeys = nilfs_btree_node_dkeys(btree, node);
-	dptrs = nilfs_btree_node_dptrs(btree, node);
-	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	dkeys = nilfs_btree_node_dkeys(node);
+	dptrs = nilfs_btree_node_dptrs(node, btree);
+	nchildren = nilfs_btree_node_get_nchildren(node);
 	if (index < nchildren) {
 		memmove(dkeys + index + 1, dkeys + index,
 			(nchildren - index) * sizeof(*dkeys));
@@ -374,7 +350,7 @@ static void nilfs_btree_node_insert(struct nilfs_btree *btree,
 	dkeys[index] = nilfs_bmap_key_to_dkey(key);
 	dptrs[index] = nilfs_bmap_ptr_to_dptr(ptr);
 	nchildren++;
-	nilfs_btree_node_set_nchildren(btree, node, nchildren);
+	nilfs_btree_node_set_nchildren(node, nchildren);
 }
 
 /* Assume that the buffer head corresponding to node is locked. */
@@ -388,11 +364,11 @@ static void nilfs_btree_node_delete(struct nilfs_btree *btree,
 	__le64 *dptrs;
 	int nchildren;
 
-	dkeys = nilfs_btree_node_dkeys(btree, node);
-	dptrs = nilfs_btree_node_dptrs(btree, node);
+	dkeys = nilfs_btree_node_dkeys(node);
+	dptrs = nilfs_btree_node_dptrs(node, btree);
 	key = nilfs_bmap_dkey_to_key(dkeys[index]);
 	ptr = nilfs_bmap_dptr_to_ptr(dptrs[index]);
-	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	nchildren = nilfs_btree_node_get_nchildren(node);
 	if (keyp != NULL)
 		*keyp = key;
 	if (ptrp != NULL)
@@ -405,11 +381,10 @@ static void nilfs_btree_node_delete(struct nilfs_btree *btree,
 			(nchildren - index - 1) * sizeof(*dptrs));
 	}
 	nchildren--;
-	nilfs_btree_node_set_nchildren(btree, node, nchildren);
+	nilfs_btree_node_set_nchildren(node, nchildren);
 }
 
-static int nilfs_btree_node_lookup(const struct nilfs_btree *btree,
-				   const struct nilfs_btree_node *node,
+static int nilfs_btree_node_lookup(const struct nilfs_btree_node *node,
 				   __u64 key, int *indexp)
 {
 	__u64 nkey;
@@ -417,12 +392,12 @@ static int nilfs_btree_node_lookup(const struct nilfs_btree *btree,
 
 	/* binary search */
 	low = 0;
-	high = nilfs_btree_node_get_nchildren(btree, node) - 1;
+	high = nilfs_btree_node_get_nchildren(node) - 1;
 	index = 0;
 	s = 0;
 	while (low <= high) {
 		index = (low + high) / 2;
-		nkey = nilfs_btree_node_get_key(btree, node, index);
+		nkey = nilfs_btree_node_get_key(node, index);
 		if (nkey == key) {
 			s = 0;
 			goto out;
@@ -436,9 +411,8 @@ static int nilfs_btree_node_lookup(const struct nilfs_btree *btree,
 	}
 
 	/* adjust index */
-	if (nilfs_btree_node_get_level(btree, node) >
-	    NILFS_BTREE_LEVEL_NODE_MIN) {
-		if ((s > 0) && (index > 0))
+	if (nilfs_btree_node_get_level(node) > NILFS_BTREE_LEVEL_NODE_MIN) {
+		if (s > 0 && index > 0)
 			index--;
 	} else if (s < 0)
 		index++;
@@ -456,25 +430,20 @@ nilfs_btree_get_root(const struct nilfs_btree *btree)
 }
 
 static inline struct nilfs_btree_node *
-nilfs_btree_get_nonroot_node(const struct nilfs_btree *btree,
-			     const struct nilfs_btree_path *path,
-			     int level)
+nilfs_btree_get_nonroot_node(const struct nilfs_btree_path *path, int level)
 {
 	return (struct nilfs_btree_node *)path[level].bp_bh->b_data;
 }
 
 static inline struct nilfs_btree_node *
-nilfs_btree_get_sib_node(const struct nilfs_btree *btree,
-			 const struct nilfs_btree_path *path,
-			 int level)
+nilfs_btree_get_sib_node(const struct nilfs_btree_path *path, int level)
 {
 	return (struct nilfs_btree_node *)path[level].bp_sib_bh->b_data;
 }
 
 static inline int nilfs_btree_height(const struct nilfs_btree *btree)
 {
-	return nilfs_btree_node_get_level(btree, nilfs_btree_get_root(btree))
-		+ 1;
+	return nilfs_btree_node_get_level(nilfs_btree_get_root(btree)) + 1;
 }
 
 static inline struct nilfs_btree_node *
@@ -484,7 +453,7 @@ nilfs_btree_get_node(const struct nilfs_btree *btree,
 {
 	return (level == nilfs_btree_height(btree) - 1) ?
 		nilfs_btree_get_root(btree) :
-		nilfs_btree_get_nonroot_node(btree, path, level);
+		nilfs_btree_get_nonroot_node(path, level);
 }
 
 static int nilfs_btree_do_lookup(const struct nilfs_btree *btree,
@@ -496,12 +465,11 @@ static int nilfs_btree_do_lookup(const struct nilfs_btree *btree,
 	int level, index, found, ret;
 
 	node = nilfs_btree_get_root(btree);
-	level = nilfs_btree_node_get_level(btree, node);
-	if ((level < minlevel) ||
-	    (nilfs_btree_node_get_nchildren(btree, node) <= 0))
+	level = nilfs_btree_node_get_level(node);
+	if (level < minlevel || nilfs_btree_node_get_nchildren(node) <= 0)
 		return -ENOENT;
 
-	found = nilfs_btree_node_lookup(btree, node, key, &index);
+	found = nilfs_btree_node_lookup(node, key, &index);
 	ptr = nilfs_btree_node_get_ptr(btree, node, index);
 	path[level].bp_bh = NULL;
 	path[level].bp_index = index;
@@ -510,14 +478,13 @@ static int nilfs_btree_do_lookup(const struct nilfs_btree *btree,
 		ret = nilfs_btree_get_block(btree, ptr, &path[level].bp_bh);
 		if (ret < 0)
 			return ret;
-		node = nilfs_btree_get_nonroot_node(btree, path, level);
-		BUG_ON(level != nilfs_btree_node_get_level(btree, node));
+		node = nilfs_btree_get_nonroot_node(path, level);
+		BUG_ON(level != nilfs_btree_node_get_level(node));
 		if (!found)
-			found = nilfs_btree_node_lookup(btree, node, key,
-							&index);
+			found = nilfs_btree_node_lookup(node, key, &index);
 		else
 			index = 0;
-		if (index < nilfs_btree_node_nchildren_max(btree, node))
+		if (index < nilfs_btree_node_nchildren_max(node, btree))
 			ptr = nilfs_btree_node_get_ptr(btree, node, index);
 		else {
 			WARN_ON(found || level != NILFS_BTREE_LEVEL_NODE_MIN);
@@ -544,10 +511,10 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_btree *btree,
 	int index, level, ret;
 
 	node = nilfs_btree_get_root(btree);
-	index = nilfs_btree_node_get_nchildren(btree, node) - 1;
+	index = nilfs_btree_node_get_nchildren(node) - 1;
 	if (index < 0)
 		return -ENOENT;
-	level = nilfs_btree_node_get_level(btree, node);
+	level = nilfs_btree_node_get_level(node);
 	ptr = nilfs_btree_node_get_ptr(btree, node, index);
 	path[level].bp_bh = NULL;
 	path[level].bp_index = index;
@@ -556,15 +523,15 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_btree *btree,
 		ret = nilfs_btree_get_block(btree, ptr, &path[level].bp_bh);
 		if (ret < 0)
 			return ret;
-		node = nilfs_btree_get_nonroot_node(btree, path, level);
-		BUG_ON(level != nilfs_btree_node_get_level(btree, node));
-		index = nilfs_btree_node_get_nchildren(btree, node) - 1;
+		node = nilfs_btree_get_nonroot_node(path, level);
+		BUG_ON(level != nilfs_btree_node_get_level(node));
+		index = nilfs_btree_node_get_nchildren(node) - 1;
 		ptr = nilfs_btree_node_get_ptr(btree, node, index);
 		path[level].bp_index = index;
 	}
 
 	if (keyp != NULL)
-		*keyp = nilfs_btree_node_get_key(btree, node, index);
+		*keyp = nilfs_btree_node_get_key(node, index);
 	if (ptrp != NULL)
 		*ptrp = ptr;
 
@@ -580,18 +547,18 @@ static int nilfs_btree_lookup(const struct nilfs_bmap *bmap,
 	int ret;
 
 	btree = (struct nilfs_btree *)bmap;
-	path = nilfs_btree_alloc_path(btree);
+	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(btree, path);
+	nilfs_btree_init_path(path);
 
 	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level);
 
 	if (ptrp != NULL)
 		*ptrp = ptr;
 
-	nilfs_btree_clear_path(btree, path);
-	nilfs_btree_free_path(btree, path);
+	nilfs_btree_clear_path(path);
+	nilfs_btree_free_path(path);
 
 	return ret;
 }
@@ -608,10 +575,10 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
 	int level = NILFS_BTREE_LEVEL_NODE_MIN;
 	int ret, cnt, index, maxlevel;
 
-	path = nilfs_btree_alloc_path(btree);
+	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(btree, path);
+	nilfs_btree_init_path(path);
 	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level);
 	if (ret < 0)
 		goto out;
@@ -631,8 +598,8 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
 	node = nilfs_btree_get_node(btree, path, level);
 	index = path[level].bp_index + 1;
 	for (;;) {
-		while (index < nilfs_btree_node_get_nchildren(btree, node)) {
-			if (nilfs_btree_node_get_key(btree, node, index) !=
+		while (index < nilfs_btree_node_get_nchildren(node)) {
+			if (nilfs_btree_node_get_key(node, index) !=
 			    key + cnt)
 				goto end;
 			ptr2 = nilfs_btree_node_get_ptr(btree, node, index);
@@ -653,8 +620,8 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
 		/* look-up right sibling node */
 		node = nilfs_btree_get_node(btree, path, level + 1);
 		index = path[level + 1].bp_index + 1;
-		if (index >= nilfs_btree_node_get_nchildren(btree, node) ||
-		    nilfs_btree_node_get_key(btree, node, index) != key + cnt)
+		if (index >= nilfs_btree_node_get_nchildren(node) ||
+		    nilfs_btree_node_get_key(node, index) != key + cnt)
 			break;
 		ptr2 = nilfs_btree_node_get_ptr(btree, node, index);
 		path[level + 1].bp_index = index;
@@ -664,7 +631,7 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
 		ret = nilfs_btree_get_block(btree, ptr2, &path[level].bp_bh);
 		if (ret < 0)
 			goto out;
-		node = nilfs_btree_get_nonroot_node(btree, path, level);
+		node = nilfs_btree_get_nonroot_node(path, level);
 		index = 0;
 		path[level].bp_index = index;
 	}
@@ -672,8 +639,8 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
 	*ptrp = ptr;
 	ret = cnt;
  out:
-	nilfs_btree_clear_path(btree, path);
-	nilfs_btree_free_path(btree, path);
+	nilfs_btree_clear_path(path);
+	nilfs_btree_free_path(path);
 	return ret;
 }
 
@@ -685,9 +652,7 @@ static void nilfs_btree_promote_key(struct nilfs_btree *btree,
 		do {
 			lock_buffer(path[level].bp_bh);
 			nilfs_btree_node_set_key(
-				btree,
-				nilfs_btree_get_nonroot_node(
-					btree, path, level),
+				nilfs_btree_get_nonroot_node(path, level),
 				path[level].bp_index, key);
 			if (!buffer_dirty(path[level].bp_bh))
 				nilfs_btnode_mark_dirty(path[level].bp_bh);
@@ -698,8 +663,7 @@ static void nilfs_btree_promote_key(struct nilfs_btree *btree,
 
 	/* root */
 	if (level == nilfs_btree_height(btree) - 1) {
-		nilfs_btree_node_set_key(btree,
-					 nilfs_btree_get_root(btree),
+		nilfs_btree_node_set_key(nilfs_btree_get_root(btree),
 					 path[level].bp_index, key);
 	}
 }
@@ -712,7 +676,7 @@ static void nilfs_btree_do_insert(struct nilfs_btree *btree,
 
 	if (level < nilfs_btree_height(btree) - 1) {
 		lock_buffer(path[level].bp_bh);
-		node = nilfs_btree_get_nonroot_node(btree, path, level);
+		node = nilfs_btree_get_nonroot_node(path, level);
 		nilfs_btree_node_insert(btree, node, *keyp, *ptrp,
 					path[level].bp_index);
 		if (!buffer_dirty(path[level].bp_bh))
@@ -721,8 +685,8 @@ static void nilfs_btree_do_insert(struct nilfs_btree *btree,
 
 		if (path[level].bp_index == 0)
 			nilfs_btree_promote_key(btree, path, level + 1,
-						nilfs_btree_node_get_key(
-							btree, node, 0));
+						nilfs_btree_node_get_key(node,
+									 0));
 	} else {
 		node = nilfs_btree_get_root(btree);
 		nilfs_btree_node_insert(btree, node, *keyp, *ptrp,
@@ -740,10 +704,10 @@ static void nilfs_btree_carry_left(struct nilfs_btree *btree,
 	lock_buffer(path[level].bp_bh);
 	lock_buffer(path[level].bp_sib_bh);
 
-	node = nilfs_btree_get_nonroot_node(btree, path, level);
-	left = nilfs_btree_get_sib_node(btree, path, level);
-	nchildren = nilfs_btree_node_get_nchildren(btree, node);
-	lnchildren = nilfs_btree_node_get_nchildren(btree, left);
+	node = nilfs_btree_get_nonroot_node(path, level);
+	left = nilfs_btree_get_sib_node(path, level);
+	nchildren = nilfs_btree_node_get_nchildren(node);
+	lnchildren = nilfs_btree_node_get_nchildren(left);
 	move = 0;
 
 	n = (nchildren + lnchildren + 1) / 2 - lnchildren;
@@ -764,7 +728,7 @@ static void nilfs_btree_carry_left(struct nilfs_btree *btree,
 	unlock_buffer(path[level].bp_sib_bh);
 
 	nilfs_btree_promote_key(btree, path, level + 1,
-				nilfs_btree_node_get_key(btree, node, 0));
+				nilfs_btree_node_get_key(node, 0));
 
 	if (move) {
 		brelse(path[level].bp_bh);
@@ -791,10 +755,10 @@ static void nilfs_btree_carry_right(struct nilfs_btree *btree,
 	lock_buffer(path[level].bp_bh);
 	lock_buffer(path[level].bp_sib_bh);
 
-	node = nilfs_btree_get_nonroot_node(btree, path, level);
-	right = nilfs_btree_get_sib_node(btree, path, level);
-	nchildren = nilfs_btree_node_get_nchildren(btree, node);
-	rnchildren = nilfs_btree_node_get_nchildren(btree, right);
+	node = nilfs_btree_get_nonroot_node(path, level);
+	right = nilfs_btree_get_sib_node(path, level);
+	nchildren = nilfs_btree_node_get_nchildren(node);
+	rnchildren = nilfs_btree_node_get_nchildren(right);
 	move = 0;
 
 	n = (nchildren + rnchildren + 1) / 2 - rnchildren;
@@ -816,15 +780,14 @@ static void nilfs_btree_carry_right(struct nilfs_btree *btree,
 
 	path[level + 1].bp_index++;
 	nilfs_btree_promote_key(btree, path, level + 1,
-				nilfs_btree_node_get_key(btree, right, 0));
+				nilfs_btree_node_get_key(right, 0));
 	path[level + 1].bp_index--;
 
 	if (move) {
 		brelse(path[level].bp_bh);
 		path[level].bp_bh = path[level].bp_sib_bh;
 		path[level].bp_sib_bh = NULL;
-		path[level].bp_index -=
-			nilfs_btree_node_get_nchildren(btree, node);
+		path[level].bp_index -= nilfs_btree_node_get_nchildren(node);
 		path[level + 1].bp_index++;
 	} else {
 		brelse(path[level].bp_sib_bh);
@@ -846,9 +809,9 @@ static void nilfs_btree_split(struct nilfs_btree *btree,
 	lock_buffer(path[level].bp_bh);
 	lock_buffer(path[level].bp_sib_bh);
 
-	node = nilfs_btree_get_nonroot_node(btree, path, level);
-	right = nilfs_btree_get_sib_node(btree, path, level);
-	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	node = nilfs_btree_get_nonroot_node(path, level);
+	right = nilfs_btree_get_sib_node(path, level);
+	nchildren = nilfs_btree_node_get_nchildren(node);
 	move = 0;
 
 	n = (nchildren + 1) / 2;
@@ -867,16 +830,15 @@ static void nilfs_btree_split(struct nilfs_btree *btree,
 	unlock_buffer(path[level].bp_bh);
 	unlock_buffer(path[level].bp_sib_bh);
 
-	newkey = nilfs_btree_node_get_key(btree, right, 0);
+	newkey = nilfs_btree_node_get_key(right, 0);
 	newptr = path[level].bp_newreq.bpr_ptr;
 
 	if (move) {
-		path[level].bp_index -=
-			nilfs_btree_node_get_nchildren(btree, node);
+		path[level].bp_index -= nilfs_btree_node_get_nchildren(node);
 		nilfs_btree_node_insert(btree, right, *keyp, *ptrp,
 					path[level].bp_index);
 
-		*keyp = nilfs_btree_node_get_key(btree, right, 0);
+		*keyp = nilfs_btree_node_get_key(right, 0);
 		*ptrp = path[level].bp_newreq.bpr_ptr;
 
 		brelse(path[level].bp_bh);
@@ -885,7 +847,7 @@ static void nilfs_btree_split(struct nilfs_btree *btree,
 	} else {
 		nilfs_btree_do_insert(btree, path, level, keyp, ptrp);
 
-		*keyp = nilfs_btree_node_get_key(btree, right, 0);
+		*keyp = nilfs_btree_node_get_key(right, 0);
 		*ptrp = path[level].bp_newreq.bpr_ptr;
 
 		brelse(path[level].bp_sib_bh);
@@ -905,12 +867,12 @@ static void nilfs_btree_grow(struct nilfs_btree *btree,
 	lock_buffer(path[level].bp_sib_bh);
 
 	root = nilfs_btree_get_root(btree);
-	child = nilfs_btree_get_sib_node(btree, path, level);
+	child = nilfs_btree_get_sib_node(path, level);
 
-	n = nilfs_btree_node_get_nchildren(btree, root);
+	n = nilfs_btree_node_get_nchildren(root);
 
 	nilfs_btree_node_move_right(btree, root, child, n);
-	nilfs_btree_node_set_level(btree, root, level + 1);
+	nilfs_btree_node_set_level(root, level + 1);
 
 	if (!buffer_dirty(path[level].bp_sib_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
@@ -922,7 +884,7 @@ static void nilfs_btree_grow(struct nilfs_btree *btree,
 
 	nilfs_btree_do_insert(btree, path, level, keyp, ptrp);
 
-	*keyp = nilfs_btree_node_get_key(btree, child, 0);
+	*keyp = nilfs_btree_node_get_key(child, 0);
 	*ptrp = path[level].bp_newreq.bpr_ptr;
 }
 
@@ -1007,9 +969,9 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
 	     level < nilfs_btree_height(btree) - 1;
 	     level++) {
-		node = nilfs_btree_get_nonroot_node(btree, path, level);
-		if (nilfs_btree_node_get_nchildren(btree, node) <
-		    nilfs_btree_node_nchildren_max(btree, node)) {
+		node = nilfs_btree_get_nonroot_node(path, level);
+		if (nilfs_btree_node_get_nchildren(node) <
+		    nilfs_btree_node_nchildren_max(node, btree)) {
 			path[level].bp_op = nilfs_btree_do_insert;
 			stats->bs_nblocks++;
 			goto out;
@@ -1026,8 +988,8 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 			if (ret < 0)
 				goto err_out_child_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
-			if (nilfs_btree_node_get_nchildren(btree, sib) <
-			    nilfs_btree_node_nchildren_max(btree, sib)) {
+			if (nilfs_btree_node_get_nchildren(sib) <
+			    nilfs_btree_node_nchildren_max(sib, btree)) {
 				path[level].bp_sib_bh = bh;
 				path[level].bp_op = nilfs_btree_carry_left;
 				stats->bs_nblocks++;
@@ -1038,15 +1000,15 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 
 		/* right sibling */
 		if (pindex <
-		    nilfs_btree_node_get_nchildren(btree, parent) - 1) {
+		    nilfs_btree_node_get_nchildren(parent) - 1) {
 			sibptr = nilfs_btree_node_get_ptr(btree, parent,
 							  pindex + 1);
 			ret = nilfs_btree_get_block(btree, sibptr, &bh);
 			if (ret < 0)
 				goto err_out_child_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
-			if (nilfs_btree_node_get_nchildren(btree, sib) <
-			    nilfs_btree_node_nchildren_max(btree, sib)) {
+			if (nilfs_btree_node_get_nchildren(sib) <
+			    nilfs_btree_node_nchildren_max(sib, btree)) {
 				path[level].bp_sib_bh = bh;
 				path[level].bp_op = nilfs_btree_carry_right;
 				stats->bs_nblocks++;
@@ -1081,8 +1043,8 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 
 	/* root */
 	node = nilfs_btree_get_root(btree);
-	if (nilfs_btree_node_get_nchildren(btree, node) <
-	    nilfs_btree_node_nchildren_max(btree, node)) {
+	if (nilfs_btree_node_get_nchildren(node) <
+	    nilfs_btree_node_nchildren_max(node, btree)) {
 		path[level].bp_op = nilfs_btree_do_insert;
 		stats->bs_nblocks++;
 		goto out;
@@ -1164,10 +1126,10 @@ static int nilfs_btree_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 	int level, ret;
 
 	btree = (struct nilfs_btree *)bmap;
-	path = nilfs_btree_alloc_path(btree);
+	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(btree, path);
+	nilfs_btree_init_path(path);
 
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL,
 				    NILFS_BTREE_LEVEL_NODE_MIN);
@@ -1184,8 +1146,8 @@ static int nilfs_btree_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 	nilfs_bmap_add_blocks(bmap, stats.bs_nblocks);
 
  out:
-	nilfs_btree_clear_path(btree, path);
-	nilfs_btree_free_path(btree, path);
+	nilfs_btree_clear_path(path);
+	nilfs_btree_free_path(path);
 	return ret;
 }
 
@@ -1197,7 +1159,7 @@ static void nilfs_btree_do_delete(struct nilfs_btree *btree,
 
 	if (level < nilfs_btree_height(btree) - 1) {
 		lock_buffer(path[level].bp_bh);
-		node = nilfs_btree_get_nonroot_node(btree, path, level);
+		node = nilfs_btree_get_nonroot_node(path, level);
 		nilfs_btree_node_delete(btree, node, keyp, ptrp,
 					path[level].bp_index);
 		if (!buffer_dirty(path[level].bp_bh))
@@ -1205,7 +1167,7 @@ static void nilfs_btree_do_delete(struct nilfs_btree *btree,
 		unlock_buffer(path[level].bp_bh);
 		if (path[level].bp_index == 0)
 			nilfs_btree_promote_key(btree, path, level + 1,
-				nilfs_btree_node_get_key(btree, node, 0));
+				nilfs_btree_node_get_key(node, 0));
 	} else {
 		node = nilfs_btree_get_root(btree);
 		nilfs_btree_node_delete(btree, node, keyp, ptrp,
@@ -1225,10 +1187,10 @@ static void nilfs_btree_borrow_left(struct nilfs_btree *btree,
 	lock_buffer(path[level].bp_bh);
 	lock_buffer(path[level].bp_sib_bh);
 
-	node = nilfs_btree_get_nonroot_node(btree, path, level);
-	left = nilfs_btree_get_sib_node(btree, path, level);
-	nchildren = nilfs_btree_node_get_nchildren(btree, node);
-	lnchildren = nilfs_btree_node_get_nchildren(btree, left);
+	node = nilfs_btree_get_nonroot_node(path, level);
+	left = nilfs_btree_get_sib_node(path, level);
+	nchildren = nilfs_btree_node_get_nchildren(node);
+	lnchildren = nilfs_btree_node_get_nchildren(left);
 
 	n = (nchildren + lnchildren) / 2 - nchildren;
 
@@ -1243,7 +1205,7 @@ static void nilfs_btree_borrow_left(struct nilfs_btree *btree,
 	unlock_buffer(path[level].bp_sib_bh);
 
 	nilfs_btree_promote_key(btree, path, level + 1,
-				nilfs_btree_node_get_key(btree, node, 0));
+				nilfs_btree_node_get_key(node, 0));
 
 	brelse(path[level].bp_sib_bh);
 	path[level].bp_sib_bh = NULL;
@@ -1262,10 +1224,10 @@ static void nilfs_btree_borrow_right(struct nilfs_btree *btree,
 	lock_buffer(path[level].bp_bh);
 	lock_buffer(path[level].bp_sib_bh);
 
-	node = nilfs_btree_get_nonroot_node(btree, path, level);
-	right = nilfs_btree_get_sib_node(btree, path, level);
-	nchildren = nilfs_btree_node_get_nchildren(btree, node);
-	rnchildren = nilfs_btree_node_get_nchildren(btree, right);
+	node = nilfs_btree_get_nonroot_node(path, level);
+	right = nilfs_btree_get_sib_node(path, level);
+	nchildren = nilfs_btree_node_get_nchildren(node);
+	rnchildren = nilfs_btree_node_get_nchildren(right);
 
 	n = (nchildren + rnchildren) / 2 - nchildren;
 
@@ -1281,7 +1243,7 @@ static void nilfs_btree_borrow_right(struct nilfs_btree *btree,
 
 	path[level + 1].bp_index++;
 	nilfs_btree_promote_key(btree, path, level + 1,
-				nilfs_btree_node_get_key(btree, right, 0));
+				nilfs_btree_node_get_key(right, 0));
 	path[level + 1].bp_index--;
 
 	brelse(path[level].bp_sib_bh);
@@ -1300,10 +1262,10 @@ static void nilfs_btree_concat_left(struct nilfs_btree *btree,
 	lock_buffer(path[level].bp_bh);
 	lock_buffer(path[level].bp_sib_bh);
 
-	node = nilfs_btree_get_nonroot_node(btree, path, level);
-	left = nilfs_btree_get_sib_node(btree, path, level);
+	node = nilfs_btree_get_nonroot_node(path, level);
+	left = nilfs_btree_get_sib_node(path, level);
 
-	n = nilfs_btree_node_get_nchildren(btree, node);
+	n = nilfs_btree_node_get_nchildren(node);
 
 	nilfs_btree_node_move_left(btree, left, node, n);
 
@@ -1316,7 +1278,7 @@ static void nilfs_btree_concat_left(struct nilfs_btree *btree,
 	nilfs_btnode_delete(path[level].bp_bh);
 	path[level].bp_bh = path[level].bp_sib_bh;
 	path[level].bp_sib_bh = NULL;
-	path[level].bp_index += nilfs_btree_node_get_nchildren(btree, left);
+	path[level].bp_index += nilfs_btree_node_get_nchildren(left);
 }
 
 static void nilfs_btree_concat_right(struct nilfs_btree *btree,
@@ -1331,10 +1293,10 @@ static void nilfs_btree_concat_right(struct nilfs_btree *btree,
 	lock_buffer(path[level].bp_bh);
 	lock_buffer(path[level].bp_sib_bh);
 
-	node = nilfs_btree_get_nonroot_node(btree, path, level);
-	right = nilfs_btree_get_sib_node(btree, path, level);
+	node = nilfs_btree_get_nonroot_node(path, level);
+	right = nilfs_btree_get_sib_node(path, level);
 
-	n = nilfs_btree_node_get_nchildren(btree, right);
+	n = nilfs_btree_node_get_nchildren(right);
 
 	nilfs_btree_node_move_left(btree, node, right, n);
 
@@ -1360,11 +1322,11 @@ static void nilfs_btree_shrink(struct nilfs_btree *btree,
 
 	lock_buffer(path[level].bp_bh);
 	root = nilfs_btree_get_root(btree);
-	child = nilfs_btree_get_nonroot_node(btree, path, level);
+	child = nilfs_btree_get_nonroot_node(path, level);
 
 	nilfs_btree_node_delete(btree, root, NULL, NULL, 0);
-	nilfs_btree_node_set_level(btree, root, level);
-	n = nilfs_btree_node_get_nchildren(btree, child);
+	nilfs_btree_node_set_level(root, level);
+	n = nilfs_btree_node_get_nchildren(child);
 	nilfs_btree_node_move_left(btree, root, child, n);
 	unlock_buffer(path[level].bp_bh);
 
@@ -1388,7 +1350,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
 	     level < nilfs_btree_height(btree) - 1;
 	     level++) {
-		node = nilfs_btree_get_nonroot_node(btree, path, level);
+		node = nilfs_btree_get_nonroot_node(path, level);
 		path[level].bp_oldreq.bpr_ptr =
 			nilfs_btree_node_get_ptr(btree, node,
 						 path[level].bp_index);
@@ -1397,8 +1359,8 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 		if (ret < 0)
 			goto err_out_child_node;
 
-		if (nilfs_btree_node_get_nchildren(btree, node) >
-		    nilfs_btree_node_nchildren_min(btree, node)) {
+		if (nilfs_btree_node_get_nchildren(node) >
+		    nilfs_btree_node_nchildren_min(node, btree)) {
 			path[level].bp_op = nilfs_btree_do_delete;
 			stats->bs_nblocks++;
 			goto out;
@@ -1415,8 +1377,8 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 			if (ret < 0)
 				goto err_out_curr_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
-			if (nilfs_btree_node_get_nchildren(btree, sib) >
-			    nilfs_btree_node_nchildren_min(btree, sib)) {
+			if (nilfs_btree_node_get_nchildren(sib) >
+			    nilfs_btree_node_nchildren_min(sib, btree)) {
 				path[level].bp_sib_bh = bh;
 				path[level].bp_op = nilfs_btree_borrow_left;
 				stats->bs_nblocks++;
@@ -1428,7 +1390,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 				/* continue; */
 			}
 		} else if (pindex <
-			   nilfs_btree_node_get_nchildren(btree, parent) - 1) {
+			   nilfs_btree_node_get_nchildren(parent) - 1) {
 			/* right sibling */
 			sibptr = nilfs_btree_node_get_ptr(btree, parent,
 							  pindex + 1);
@@ -1436,8 +1398,8 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 			if (ret < 0)
 				goto err_out_curr_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
-			if (nilfs_btree_node_get_nchildren(btree, sib) >
-			    nilfs_btree_node_nchildren_min(btree, sib)) {
+			if (nilfs_btree_node_get_nchildren(sib) >
+			    nilfs_btree_node_nchildren_min(sib, btree)) {
 				path[level].bp_sib_bh = bh;
 				path[level].bp_op = nilfs_btree_borrow_right;
 				stats->bs_nblocks++;
@@ -1452,7 +1414,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 			/* no siblings */
 			/* the only child of the root node */
 			WARN_ON(level != nilfs_btree_height(btree) - 2);
-			if (nilfs_btree_node_get_nchildren(btree, node) - 1 <=
+			if (nilfs_btree_node_get_nchildren(node) - 1 <=
 			    NILFS_BTREE_ROOT_NCHILDREN_MAX) {
 				path[level].bp_op = nilfs_btree_shrink;
 				stats->bs_nblocks += 2;
@@ -1523,10 +1485,10 @@ static int nilfs_btree_delete(struct nilfs_bmap *bmap, __u64 key)
 	int level, ret;
 
 	btree = (struct nilfs_btree *)bmap;
-	path = nilfs_btree_alloc_path(btree);
+	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(btree, path);
+	nilfs_btree_init_path(path);
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL,
 				    NILFS_BTREE_LEVEL_NODE_MIN);
 	if (ret < 0)
@@ -1539,8 +1501,8 @@ static int nilfs_btree_delete(struct nilfs_bmap *bmap, __u64 key)
 	nilfs_bmap_sub_blocks(bmap, stats.bs_nblocks);
 
 out:
-	nilfs_btree_clear_path(btree, path);
-	nilfs_btree_free_path(btree, path);
+	nilfs_btree_clear_path(path);
+	nilfs_btree_free_path(path);
 	return ret;
 }
 
@@ -1551,15 +1513,15 @@ static int nilfs_btree_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
 	int ret;
 
 	btree = (struct nilfs_btree *)bmap;
-	path = nilfs_btree_alloc_path(btree);
+	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(btree, path);
+	nilfs_btree_init_path(path);
 
 	ret = nilfs_btree_do_lookup_last(btree, path, keyp, NULL);
 
-	nilfs_btree_clear_path(btree, path);
-	nilfs_btree_free_path(btree, path);
+	nilfs_btree_clear_path(path);
+	nilfs_btree_free_path(path);
 
 	return ret;
 }
@@ -1581,7 +1543,7 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *bmap, __u64 key)
 		node = root;
 		break;
 	case 3:
-		nchildren = nilfs_btree_node_get_nchildren(btree, root);
+		nchildren = nilfs_btree_node_get_nchildren(root);
 		if (nchildren > 1)
 			return 0;
 		ptr = nilfs_btree_node_get_ptr(btree, root, nchildren - 1);
@@ -1594,10 +1556,10 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *bmap, __u64 key)
 		return 0;
 	}
 
-	nchildren = nilfs_btree_node_get_nchildren(btree, node);
-	maxkey = nilfs_btree_node_get_key(btree, node, nchildren - 1);
+	nchildren = nilfs_btree_node_get_nchildren(node);
+	maxkey = nilfs_btree_node_get_key(node, nchildren - 1);
 	nextmaxkey = (nchildren > 1) ?
-		nilfs_btree_node_get_key(btree, node, nchildren - 2) : 0;
+		nilfs_btree_node_get_key(node, nchildren - 2) : 0;
 	if (bh != NULL)
 		brelse(bh);
 
@@ -1623,7 +1585,7 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *bmap,
 		node = root;
 		break;
 	case 3:
-		nchildren = nilfs_btree_node_get_nchildren(btree, root);
+		nchildren = nilfs_btree_node_get_nchildren(root);
 		WARN_ON(nchildren > 1);
 		ptr = nilfs_btree_node_get_ptr(btree, root, nchildren - 1);
 		ret = nilfs_btree_get_block(btree, ptr, &bh);
@@ -1636,11 +1598,11 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *bmap,
 		return -EINVAL;
 	}
 
-	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	nchildren = nilfs_btree_node_get_nchildren(node);
 	if (nchildren < nitems)
 		nitems = nchildren;
-	dkeys = nilfs_btree_node_dkeys(btree, node);
-	dptrs = nilfs_btree_node_dptrs(btree, node);
+	dkeys = nilfs_btree_node_dkeys(node);
+	dptrs = nilfs_btree_node_dptrs(node, btree);
 	for (i = 0; i < nitems; i++) {
 		keys[i] = nilfs_bmap_dkey_to_key(dkeys[i]);
 		ptrs[i] = nilfs_bmap_dptr_to_ptr(dptrs[i]);
@@ -1986,15 +1948,15 @@ static int nilfs_btree_propagate(const struct nilfs_bmap *bmap,
 	WARN_ON(!buffer_dirty(bh));
 
 	btree = (struct nilfs_btree *)bmap;
-	path = nilfs_btree_alloc_path(btree);
+	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(btree, path);
+	nilfs_btree_init_path(path);
 
 	if (buffer_nilfs_node(bh)) {
 		node = (struct nilfs_btree_node *)bh->b_data;
-		key = nilfs_btree_node_get_key(btree, node, 0);
-		level = nilfs_btree_node_get_level(btree, node);
+		key = nilfs_btree_node_get_key(node, 0);
+		level = nilfs_btree_node_get_level(node);
 	} else {
 		key = nilfs_bmap_data_get_key(bmap, bh);
 		level = NILFS_BTREE_LEVEL_DATA;
@@ -2013,8 +1975,8 @@ static int nilfs_btree_propagate(const struct nilfs_bmap *bmap,
 		nilfs_btree_propagate_p(btree, path, level, bh);
 
  out:
-	nilfs_btree_clear_path(btree, path);
-	nilfs_btree_free_path(btree, path);
+	nilfs_btree_clear_path(path);
+	nilfs_btree_free_path(path);
 
 	return ret;
 }
@@ -2037,12 +1999,12 @@ static void nilfs_btree_add_dirty_buffer(struct nilfs_btree *btree,
 
 	get_bh(bh);
 	node = (struct nilfs_btree_node *)bh->b_data;
-	key = nilfs_btree_node_get_key(btree, node, 0);
-	level = nilfs_btree_node_get_level(btree, node);
+	key = nilfs_btree_node_get_key(node, 0);
+	level = nilfs_btree_node_get_level(node);
 	list_for_each(head, &lists[level]) {
 		cbh = list_entry(head, struct buffer_head, b_assoc_buffers);
 		cnode = (struct nilfs_btree_node *)cbh->b_data;
-		ckey = nilfs_btree_node_get_key(btree, cnode, 0);
+		ckey = nilfs_btree_node_get_key(cnode, 0);
 		if (key < ckey)
 			break;
 	}
@@ -2120,8 +2082,7 @@ static int nilfs_btree_assign_p(struct nilfs_btree *btree,
 	nilfs_btree_node_set_ptr(btree, parent,
 				 path[level + 1].bp_index, blocknr);
 
-	key = nilfs_btree_node_get_key(btree, parent,
-				       path[level + 1].bp_index);
+	key = nilfs_btree_node_get_key(parent, path[level + 1].bp_index);
 	/* on-disk format */
 	binfo->bi_dat.bi_blkoff = nilfs_bmap_key_to_dkey(key);
 	binfo->bi_dat.bi_level = level;
@@ -2150,8 +2111,7 @@ static int nilfs_btree_assign_v(struct nilfs_btree *btree,
 	if (unlikely(ret < 0))
 		return ret;
 
-	key = nilfs_btree_node_get_key(btree, parent,
-				       path[level + 1].bp_index);
+	key = nilfs_btree_node_get_key(parent, path[level + 1].bp_index);
 	/* on-disk format */
 	binfo->bi_v.bi_vblocknr = nilfs_bmap_ptr_to_dptr(ptr);
 	binfo->bi_v.bi_blkoff = nilfs_bmap_key_to_dkey(key);
@@ -2171,15 +2131,15 @@ static int nilfs_btree_assign(struct nilfs_bmap *bmap,
 	int level, ret;
 
 	btree = (struct nilfs_btree *)bmap;
-	path = nilfs_btree_alloc_path(btree);
+	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(btree, path);
+	nilfs_btree_init_path(path);
 
 	if (buffer_nilfs_node(*bh)) {
 		node = (struct nilfs_btree_node *)(*bh)->b_data;
-		key = nilfs_btree_node_get_key(btree, node, 0);
-		level = nilfs_btree_node_get_level(btree, node);
+		key = nilfs_btree_node_get_key(node, 0);
+		level = nilfs_btree_node_get_level(node);
 	} else {
 		key = nilfs_bmap_data_get_key(bmap, *bh);
 		level = NILFS_BTREE_LEVEL_DATA;
@@ -2196,8 +2156,8 @@ static int nilfs_btree_assign(struct nilfs_bmap *bmap,
 		nilfs_btree_assign_p(btree, path, level, bh, blocknr, binfo);
 
  out:
-	nilfs_btree_clear_path(btree, path);
-	nilfs_btree_free_path(btree, path);
+	nilfs_btree_clear_path(path);
+	nilfs_btree_free_path(path);
 
 	return ret;
 }
@@ -2219,7 +2179,7 @@ static int nilfs_btree_assign_gc(struct nilfs_bmap *bmap,
 
 	if (buffer_nilfs_node(*bh)) {
 		node = (struct nilfs_btree_node *)(*bh)->b_data;
-		key = nilfs_btree_node_get_key(btree, node, 0);
+		key = nilfs_btree_node_get_key(node, 0);
 	} else
 		key = nilfs_bmap_data_get_key(bmap, *bh);
 
@@ -2239,10 +2199,10 @@ static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 	int ret;
 
 	btree = (struct nilfs_btree *)bmap;
-	path = nilfs_btree_alloc_path(btree);
+	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(btree, path);
+	nilfs_btree_init_path(path);
 
 	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level + 1);
 	if (ret < 0) {
@@ -2262,8 +2222,8 @@ static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 		nilfs_bmap_set_dirty(&btree->bt_bmap);
 
  out:
-	nilfs_btree_clear_path(btree, path);
-	nilfs_btree_free_path(btree, path);
+	nilfs_btree_clear_path(path);
+	nilfs_btree_free_path(path);
 	return ret;
 }
 
-- 
1.6.3.4
