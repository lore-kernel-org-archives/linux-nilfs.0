From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/4] nilfs2: apply read-ahead for nilfs_btree_lookup_contig
Date: Sun, 18 Jul 2010 10:42:26 +0900
Message-ID: <1279417346-9688-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1279417346-9688-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279417346-9688-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This applies read-ahead to nilfs_btree_do_lookup and
nilfs_btree_lookup_contig functions and extends them to read ahead
siblings of level 1 btree nodes that hold data blocks.

At present, the read-ahead is not applied to most btree operations;
only get_block() callback function, which is used during read of
regular files or directories, receives the benefit.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   50 +++++++++++++++++++++++++++++++++-----------------
 1 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index d3faa0b..300c2bc 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -504,9 +504,11 @@ static int nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 
 static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 				 struct nilfs_btree_path *path,
-				 __u64 key, __u64 *ptrp, int minlevel)
+				 __u64 key, __u64 *ptrp, int minlevel,
+				 int readahead)
 {
 	struct nilfs_btree_node *node;
+	struct nilfs_btree_readahead_info p, *ra;
 	__u64 ptr;
 	int level, index, found, ncmax, ret;
 
@@ -523,10 +525,20 @@ static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 
 	ncmax = nilfs_btree_nchildren_per_block(btree);
 
-	for (level--; level >= minlevel; level--) {
-		ret = nilfs_btree_get_block(btree, ptr, &path[level].bp_bh);
+	while (--level >= minlevel) {
+		ra = NULL;
+		if (level == NILFS_BTREE_LEVEL_NODE_MIN && readahead) {
+			p.node = nilfs_btree_get_node(btree, path, level + 1,
+						      &p.ncmax);
+			p.index = index;
+			p.max_ra_blocks = 7;
+			ra = &p;
+		}
+		ret = __nilfs_btree_get_block(btree, ptr, &path[level].bp_bh,
+					      ra);
 		if (ret < 0)
 			return ret;
+
 		node = nilfs_btree_get_nonroot_node(path, level);
 		if (nilfs_btree_bad_node(node, level))
 			return -EINVAL;
@@ -601,7 +613,7 @@ static int nilfs_btree_lookup(const struct nilfs_bmap *btree,
 	if (path == NULL)
 		return -ENOMEM;
 
-	ret = nilfs_btree_do_lookup(btree, path, key, ptrp, level);
+	ret = nilfs_btree_do_lookup(btree, path, key, ptrp, level, 0);
 
 	nilfs_btree_free_path(path);
 
@@ -618,12 +630,13 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 	sector_t blocknr;
 	int level = NILFS_BTREE_LEVEL_NODE_MIN;
 	int ret, cnt, index, maxlevel, ncmax;
+	struct nilfs_btree_readahead_info p;
 
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
 
-	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level);
+	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level, 1);
 	if (ret < 0)
 		goto out;
 
@@ -662,17 +675,20 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 			break;
 
 		/* look-up right sibling node */
-		node = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
-		index = path[level + 1].bp_index + 1;
-		if (index >= nilfs_btree_node_get_nchildren(node) ||
-		    nilfs_btree_node_get_key(node, index) != key + cnt)
+		p.node = nilfs_btree_get_node(btree, path, level + 1, &p.ncmax);
+		p.index = path[level + 1].bp_index + 1;
+		p.max_ra_blocks = 7;
+		if (p.index >= nilfs_btree_node_get_nchildren(p.node) ||
+		    nilfs_btree_node_get_key(p.node, p.index) != key + cnt)
 			break;
-		ptr2 = nilfs_btree_node_get_ptr(node, index, ncmax);
-		path[level + 1].bp_index = index;
+		ptr2 = nilfs_btree_node_get_ptr(p.node, p.index, p.ncmax);
+		path[level + 1].bp_index = p.index;
 
 		brelse(path[level].bp_bh);
 		path[level].bp_bh = NULL;
-		ret = nilfs_btree_get_block(btree, ptr2, &path[level].bp_bh);
+
+		ret = __nilfs_btree_get_block(btree, ptr2, &path[level].bp_bh,
+					      &p);
 		if (ret < 0)
 			goto out;
 		node = nilfs_btree_get_nonroot_node(path, level);
@@ -1147,7 +1163,7 @@ static int nilfs_btree_insert(struct nilfs_bmap *btree, __u64 key, __u64 ptr)
 		return -ENOMEM;
 
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL,
-				    NILFS_BTREE_LEVEL_NODE_MIN);
+				    NILFS_BTREE_LEVEL_NODE_MIN, 0);
 	if (ret != -ENOENT) {
 		if (ret == 0)
 			ret = -EEXIST;
@@ -1484,7 +1500,7 @@ static int nilfs_btree_delete(struct nilfs_bmap *btree, __u64 key)
 		return -ENOMEM;
 
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL,
-				    NILFS_BTREE_LEVEL_NODE_MIN);
+				    NILFS_BTREE_LEVEL_NODE_MIN, 0);
 	if (ret < 0)
 		goto out;
 
@@ -1955,7 +1971,7 @@ static int nilfs_btree_propagate(struct nilfs_bmap *btree,
 		level = NILFS_BTREE_LEVEL_DATA;
 	}
 
-	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1);
+	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1, 0);
 	if (ret < 0) {
 		if (unlikely(ret == -ENOENT))
 			printk(KERN_CRIT "%s: key = %llu, level == %d\n",
@@ -2147,7 +2163,7 @@ static int nilfs_btree_assign(struct nilfs_bmap *btree,
 		level = NILFS_BTREE_LEVEL_DATA;
 	}
 
-	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1);
+	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1, 0);
 	if (ret < 0) {
 		WARN_ON(ret == -ENOENT);
 		goto out;
@@ -2201,7 +2217,7 @@ static int nilfs_btree_mark(struct nilfs_bmap *btree, __u64 key, int level)
 	if (path == NULL)
 		return -ENOMEM;
 
-	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level + 1);
+	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level + 1, 0);
 	if (ret < 0) {
 		WARN_ON(ret == -ENOENT);
 		goto out;
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
