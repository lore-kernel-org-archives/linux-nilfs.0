From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/9] nilfs2: add separable lookup routines to direct/btree mappings
Date: Mon, 16 May 2011 18:05:14 +0900
Message-ID: <1305536722-1311-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1305536722-1311-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305536722-1311-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds three lookup methods (bmap->bop_find(),
bmap->bop_find_next(), and bmap->bop_find_close()) to direct block
mapping and btree block mapping.  These will help to implement the
successive comparison routine of two bmap objects.

The bop_find() method looks up a valid key and pointer pair which
first appears later a given key, and return a context object of the
lookup.  The bop_find_next() method continues search of the next key
and pointer pair with the context object. And, the bop_find_close()
method free the context object.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.h   |    5 ++
 fs/nilfs2/btree.c  |  134 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/direct.c |   49 +++++++++++++++++++
 3 files changed, 188 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 40d9f45..cff22c2 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -81,6 +81,11 @@ struct nilfs_bmap_operations {
 	int (*bop_check_insert)(const struct nilfs_bmap *, __u64);
 	int (*bop_check_delete)(struct nilfs_bmap *, __u64);
 	int (*bop_gather_data)(struct nilfs_bmap *, __u64 *, __u64 *, int);
+	int (*bop_find)(struct nilfs_bmap *bmap, __u64 *keyp, __u64 *ptrp,
+			void **context);
+	int (*bop_find_next)(struct nilfs_bmap *bmap, __u64 *keyp, __u64 *ptrp,
+			     void *context);
+	void (*bop_find_close)(struct nilfs_bmap *bmap, void *context);
 };
 
 
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 7eafe46..ad35a7a 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -603,6 +603,88 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_bmap *btree,
 	return 0;
 }
 
+/**
+ * nilfs_btree_do_lookup_next - look up next key and pointer
+ * @btree: bmap object
+ * @path: btree lookup path
+ * @keyp: pointer to the key [in, out]
+ * @ptrp: buffer to store resultant pointer [out]
+ */
+static int nilfs_btree_do_lookup_next(struct nilfs_bmap *btree,
+				      struct nilfs_btree_path *path,
+				      __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *node;
+	__u64 key;
+	__u64 ptr;
+	int level, index, ncmax;
+	int ret;
+
+	level = NILFS_BTREE_LEVEL_NODE_MIN;
+	node = nilfs_btree_get_node(btree, path, level, &ncmax);
+	index = path[level].bp_index;
+	if (index < nilfs_btree_node_get_nchildren(node)) {
+		key = nilfs_btree_node_get_key(node, index);
+		if (key > *keyp) {
+			/*
+			 * The previous lookup did not hit, and we
+			 * already point to a valid next item.
+			 */
+			ptr = nilfs_btree_node_get_ptr(node, index, ncmax);
+			goto out;
+		}
+		/* The previous lookup hit */
+		index++;
+		if (index < nilfs_btree_node_get_nchildren(node)) {
+			path[level].bp_index = index;
+			key = nilfs_btree_node_get_key(node, index);
+			ptr = nilfs_btree_node_get_ptr(node, index, ncmax);
+			goto out;
+		}
+	}
+	/*
+	 * The previous lookup did not hit, and the node was over.
+	 * Try to find a next valid node.
+	 */
+
+	/* ascend the tree */
+	do {
+		if (level == nilfs_btree_height(btree) - 1)
+			return -ENOENT; /* We are now at the root node */
+
+		brelse(path[level].bp_bh);
+		path[level].bp_bh = NULL;
+
+		level++;
+		node = nilfs_btree_get_node(btree, path, level, &ncmax);
+		index = path[level].bp_index + 1;
+	} while (index >= nilfs_btree_node_get_nchildren(node));
+
+	ptr = nilfs_btree_node_get_ptr(node, index, ncmax);
+	path[level].bp_index = index;
+
+	/* descend the tree */
+	ncmax = nilfs_btree_nchildren_per_block(btree);
+	do {
+		level--;
+		ret = nilfs_btree_get_block(btree, ptr, &path[level].bp_bh);
+		if (ret < 0)
+			return ret;
+		node = nilfs_btree_get_nonroot_node(path, level);
+		if (nilfs_btree_bad_node(node, level))
+			return -EINVAL;
+
+		ptr = nilfs_btree_node_get_ptr(node, 0, ncmax);
+		path[level].bp_index = 0;
+	} while (level > NILFS_BTREE_LEVEL_NODE_MIN);
+
+	key = nilfs_btree_node_get_key(node, 0);
+out:
+	*keyp = key;
+	*ptrp = ptr;
+	return 0;
+}
+
 static int nilfs_btree_lookup(const struct nilfs_bmap *btree,
 			      __u64 key, int level, __u64 *ptrp)
 {
@@ -2239,6 +2321,52 @@ static int nilfs_btree_mark(struct nilfs_bmap *btree, __u64 key, int level)
 	return ret;
 }
 
+/**
+ * nilfs_btree_find - find the next key and pointer
+ * @btree: bmap object
+ * @keyp: pointer to the key
+ * @ptrp: buffer to store resultant pointer
+ * @context: buffer to store search context (btree path)
+ */
+static int nilfs_btree_find(struct nilfs_bmap *btree, __u64 *keyp,
+			    __u64 *ptrp, void **context)
+{
+	struct nilfs_btree_path *path;
+	int level = NILFS_BTREE_LEVEL_NODE_MIN;
+	int ret;
+
+	path = nilfs_btree_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = nilfs_btree_do_lookup(btree, path, *keyp, ptrp, level, 1);
+	if (ret < 0) {
+		if (ret != -ENOENT)
+			goto failed;
+		/* did not hit a valid item at key -- look up next key */
+		ret = nilfs_btree_do_lookup_next(btree, path, keyp, ptrp);
+		if (ret < 0)
+			goto failed;
+	}
+	*context = path;
+	return 0;
+failed:
+	nilfs_btree_free_path(path);
+	return ret;
+}
+
+static int nilfs_btree_find_next(struct nilfs_bmap *btree, __u64 *keyp,
+				 __u64 *ptrp, void *context)
+{
+	return nilfs_btree_do_lookup_next(btree, context, keyp, ptrp);
+}
+
+static void nilfs_btree_find_close(struct nilfs_bmap *btree, void *context)
+{
+	if (context)
+		nilfs_btree_free_path(context);
+}
+
 static const struct nilfs_bmap_operations nilfs_btree_ops = {
 	.bop_lookup		=	nilfs_btree_lookup,
 	.bop_lookup_contig	=	nilfs_btree_lookup_contig,
@@ -2257,6 +2385,9 @@ static const struct nilfs_bmap_operations nilfs_btree_ops = {
 	.bop_check_insert	=	NULL,
 	.bop_check_delete	=	nilfs_btree_check_delete,
 	.bop_gather_data	=	nilfs_btree_gather_data,
+	.bop_find		=	nilfs_btree_find,
+	.bop_find_next		=	nilfs_btree_find_next,
+	.bop_find_close		=	nilfs_btree_find_close,
 };
 
 static const struct nilfs_bmap_operations nilfs_btree_ops_gc = {
@@ -2277,6 +2408,9 @@ static const struct nilfs_bmap_operations nilfs_btree_ops_gc = {
 	.bop_check_insert	=	NULL,
 	.bop_check_delete	=	NULL,
 	.bop_gather_data	=	NULL,
+	.bop_find		=	NULL,
+	.bop_find_next		=	NULL,
+	.bop_find_close		=	NULL,
 };
 
 int nilfs_btree_init(struct nilfs_bmap *bmap)
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 82f4865..297390c 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -60,6 +60,31 @@ static int nilfs_direct_lookup(const struct nilfs_bmap *direct,
 	return 0;
 }
 
+/**
+ * nilfs_direct_lookup_next - get next key and pointer
+ * @direct: bmap object
+ * @keyp: pointer to the current key [in, out]
+ * @ptrp: buffer to store resultant pointer [out]
+ */
+static int nilfs_direct_lookup_next(struct nilfs_bmap *direct, __u64 *keyp,
+				    __u64 *ptrp)
+{
+	__u64 key;
+	__u64 ptr;
+	int ret = -ENOENT; /* internal code */
+
+	for (key = *keyp + 1; key <= NILFS_DIRECT_KEY_MAX; key++) {
+		ptr = nilfs_direct_get_ptr(direct, key);
+		if (ptr != NILFS_BMAP_INVALID_PTR) {
+			*keyp = key;
+			*ptrp = ptr;
+			ret = 0;
+			break;
+		}
+	}
+	return ret;
+}
+
 static int nilfs_direct_lookup_contig(const struct nilfs_bmap *direct,
 				      __u64 key, __u64 *ptrp,
 				      unsigned maxblocks)
@@ -341,6 +366,27 @@ static int nilfs_direct_assign(struct nilfs_bmap *bmap,
 		nilfs_direct_assign_p(bmap, key, ptr, bh, blocknr, binfo);
 }
 
+static int nilfs_direct_find(struct nilfs_bmap *direct, __u64 *keyp,
+			     __u64 *ptrp, void **context)
+{
+	int ret;
+	*context = NULL;
+	ret = nilfs_direct_lookup(direct, *keyp, 1, ptrp);
+	if (ret == -ENOENT)
+		ret = nilfs_direct_lookup_next(direct, keyp, ptrp);
+	return  ret;
+}
+
+static int nilfs_direct_find_next(struct nilfs_bmap *direct, __u64 *keyp,
+				  __u64 *ptrp, void *context)
+{
+	return nilfs_direct_lookup_next(direct, keyp, ptrp);
+}
+
+static void nilfs_direct_find_close(struct nilfs_bmap *direct, void *context)
+{
+}
+
 static const struct nilfs_bmap_operations nilfs_direct_ops = {
 	.bop_lookup		=	nilfs_direct_lookup,
 	.bop_lookup_contig	=	nilfs_direct_lookup_contig,
@@ -359,6 +405,9 @@ static const struct nilfs_bmap_operations nilfs_direct_ops = {
 	.bop_check_insert	=	nilfs_direct_check_insert,
 	.bop_check_delete	=	NULL,
 	.bop_gather_data	=	nilfs_direct_gather_data,
+	.bop_find		=	nilfs_direct_find,
+	.bop_find_next		=	nilfs_direct_find_next,
+	.bop_find_close		=	nilfs_direct_find_close,
 };
 
 
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
