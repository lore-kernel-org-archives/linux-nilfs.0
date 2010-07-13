From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/5] nilfs2: optimize calculation of min/max number of btree node children
Date: Tue, 13 Jul 2010 23:33:52 +0900
Message-ID: <1279031635-6717-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

nilfs_btree_node_nchildren_max() and nilfs_btree_node_nchildren_min()
functions switch return value depending on whether target node is the
root or a node block.  In most uses of these functions, however, the
node type is fixed, and moreover the same calculation is repeatedly
performed in loop.

This unfold these functions depending on context and move them outside
loops wherever possible.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index c05586a..24d454c 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -472,7 +472,7 @@ static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 {
 	struct nilfs_btree_node *node;
 	__u64 ptr;
-	int level, index, found, ret;
+	int level, index, found, ncmax, ret;
 
 	node = nilfs_btree_get_root(btree);
 	level = nilfs_btree_node_get_level(node);
@@ -484,6 +484,8 @@ static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 	path[level].bp_bh = NULL;
 	path[level].bp_index = index;
 
+	ncmax = NILFS_BTREE_NODE_NCHILDREN_MAX(nilfs_btree_node_size(btree));
+
 	for (level--; level >= minlevel; level--) {
 		ret = nilfs_btree_get_block(btree, ptr, &path[level].bp_bh);
 		if (ret < 0)
@@ -495,9 +497,9 @@ static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 			found = nilfs_btree_node_lookup(node, key, &index);
 		else
 			index = 0;
-		if (index < nilfs_btree_node_nchildren_max(node, btree))
+		if (index < ncmax) {
 			ptr = nilfs_btree_node_get_ptr(btree, node, index);
-		else {
+		} else {
 			WARN_ON(found || level != NILFS_BTREE_LEVEL_NODE_MIN);
 			/* insert */
 			ptr = NILFS_BMAP_INVALID_PTR;
@@ -920,7 +922,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 	struct buffer_head *bh;
 	struct nilfs_btree_node *node, *parent, *sib;
 	__u64 sibptr;
-	int pindex, level, ret;
+	int pindex, level, ncmax, ret;
 	struct inode *dat = NULL;
 
 	stats->bs_nblocks = 0;
@@ -937,12 +939,13 @@ static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 	if (ret < 0)
 		goto err_out_data;
 
+	ncmax = NILFS_BTREE_NODE_NCHILDREN_MAX(nilfs_btree_node_size(btree));
+
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
 	     level < nilfs_btree_height(btree) - 1;
 	     level++) {
 		node = nilfs_btree_get_nonroot_node(path, level);
-		if (nilfs_btree_node_get_nchildren(node) <
-		    nilfs_btree_node_nchildren_max(node, btree)) {
+		if (nilfs_btree_node_get_nchildren(node) < ncmax) {
 			path[level].bp_op = nilfs_btree_do_insert;
 			stats->bs_nblocks++;
 			goto out;
@@ -959,8 +962,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 			if (ret < 0)
 				goto err_out_child_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
-			if (nilfs_btree_node_get_nchildren(sib) <
-			    nilfs_btree_node_nchildren_max(sib, btree)) {
+			if (nilfs_btree_node_get_nchildren(sib) < ncmax) {
 				path[level].bp_sib_bh = bh;
 				path[level].bp_op = nilfs_btree_carry_left;
 				stats->bs_nblocks++;
@@ -978,8 +980,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 			if (ret < 0)
 				goto err_out_child_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
-			if (nilfs_btree_node_get_nchildren(sib) <
-			    nilfs_btree_node_nchildren_max(sib, btree)) {
+			if (nilfs_btree_node_get_nchildren(sib) < ncmax) {
 				path[level].bp_sib_bh = bh;
 				path[level].bp_op = nilfs_btree_carry_right;
 				stats->bs_nblocks++;
@@ -1013,7 +1014,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 	/* root */
 	node = nilfs_btree_get_root(btree);
 	if (nilfs_btree_node_get_nchildren(node) <
-	    nilfs_btree_node_nchildren_max(node, btree)) {
+	    NILFS_BTREE_ROOT_NCHILDREN_MAX) {
 		path[level].bp_op = nilfs_btree_do_insert;
 		stats->bs_nblocks++;
 		goto out;
@@ -1280,10 +1281,12 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 	struct buffer_head *bh;
 	struct nilfs_btree_node *node, *parent, *sib;
 	__u64 sibptr;
-	int pindex, level, ret;
+	int pindex, level, ncmin, ret;
 
 	ret = 0;
 	stats->bs_nblocks = 0;
+	ncmin = NILFS_BTREE_NODE_NCHILDREN_MIN(nilfs_btree_node_size(btree));
+
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
 	     level < nilfs_btree_height(btree) - 1;
 	     level++) {
@@ -1296,8 +1299,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 		if (ret < 0)
 			goto err_out_child_node;
 
-		if (nilfs_btree_node_get_nchildren(node) >
-		    nilfs_btree_node_nchildren_min(node, btree)) {
+		if (nilfs_btree_node_get_nchildren(node) > ncmin) {
 			path[level].bp_op = nilfs_btree_do_delete;
 			stats->bs_nblocks++;
 			goto out;
@@ -1314,8 +1316,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 			if (ret < 0)
 				goto err_out_curr_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
-			if (nilfs_btree_node_get_nchildren(sib) >
-			    nilfs_btree_node_nchildren_min(sib, btree)) {
+			if (nilfs_btree_node_get_nchildren(sib) > ncmin) {
 				path[level].bp_sib_bh = bh;
 				path[level].bp_op = nilfs_btree_borrow_left;
 				stats->bs_nblocks++;
@@ -1335,8 +1336,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 			if (ret < 0)
 				goto err_out_curr_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
-			if (nilfs_btree_node_get_nchildren(sib) >
-			    nilfs_btree_node_nchildren_min(sib, btree)) {
+			if (nilfs_btree_node_get_nchildren(sib) > ncmin) {
 				path[level].bp_sib_bh = bh;
 				path[level].bp_op = nilfs_btree_borrow_right;
 				stats->bs_nblocks++;
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
