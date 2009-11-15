From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 02/23] nilfs2: remove buffer locking from
	btree code
Date: Sun, 15 Nov 2009 21:46:40 +0900
Message-ID: <1258289221-3827-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258289221-3827-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258289221-3827-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

lock_buffer() and unlock_buffer() uses in btree.c are eliminable
because btree functions gain buffer heads through nilfs_btnode_get(),
which never returns an on-the-fly buffer.

Although nilfs_clear_dirty_page() and nilfs_copy_back_pages() in
nilfs_commit_gcdat_inode() juggle btree node buffers of DAT, this is
safe because these operations are protected by a log writer lock or
the metadata file semaphore of DAT.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   60 -----------------------------------------------------
 1 files changed, 0 insertions(+), 60 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 420c9ec..c9aab29 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -652,13 +652,11 @@ static void nilfs_btree_promote_key(struct nilfs_btree *btree,
 {
 	if (level < nilfs_btree_height(btree) - 1) {
 		do {
-			lock_buffer(path[level].bp_bh);
 			nilfs_btree_node_set_key(
 				nilfs_btree_get_nonroot_node(path, level),
 				path[level].bp_index, key);
 			if (!buffer_dirty(path[level].bp_bh))
 				nilfs_btnode_mark_dirty(path[level].bp_bh);
-			unlock_buffer(path[level].bp_bh);
 		} while ((path[level].bp_index == 0) &&
 			 (++level < nilfs_btree_height(btree) - 1));
 	}
@@ -677,13 +675,11 @@ static void nilfs_btree_do_insert(struct nilfs_btree *btree,
 	struct nilfs_btree_node *node;
 
 	if (level < nilfs_btree_height(btree) - 1) {
-		lock_buffer(path[level].bp_bh);
 		node = nilfs_btree_get_nonroot_node(path, level);
 		nilfs_btree_node_insert(btree, node, *keyp, *ptrp,
 					path[level].bp_index);
 		if (!buffer_dirty(path[level].bp_bh))
 			nilfs_btnode_mark_dirty(path[level].bp_bh);
-		unlock_buffer(path[level].bp_bh);
 
 		if (path[level].bp_index == 0)
 			nilfs_btree_promote_key(btree, path, level + 1,
@@ -703,9 +699,6 @@ static void nilfs_btree_carry_left(struct nilfs_btree *btree,
 	struct nilfs_btree_node *node, *left;
 	int nchildren, lnchildren, n, move;
 
-	lock_buffer(path[level].bp_bh);
-	lock_buffer(path[level].bp_sib_bh);
-
 	node = nilfs_btree_get_nonroot_node(path, level);
 	left = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
@@ -726,9 +719,6 @@ static void nilfs_btree_carry_left(struct nilfs_btree *btree,
 	if (!buffer_dirty(path[level].bp_sib_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
 
-	unlock_buffer(path[level].bp_bh);
-	unlock_buffer(path[level].bp_sib_bh);
-
 	nilfs_btree_promote_key(btree, path, level + 1,
 				nilfs_btree_node_get_key(node, 0));
 
@@ -754,9 +744,6 @@ static void nilfs_btree_carry_right(struct nilfs_btree *btree,
 	struct nilfs_btree_node *node, *right;
 	int nchildren, rnchildren, n, move;
 
-	lock_buffer(path[level].bp_bh);
-	lock_buffer(path[level].bp_sib_bh);
-
 	node = nilfs_btree_get_nonroot_node(path, level);
 	right = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
@@ -777,9 +764,6 @@ static void nilfs_btree_carry_right(struct nilfs_btree *btree,
 	if (!buffer_dirty(path[level].bp_sib_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
 
-	unlock_buffer(path[level].bp_bh);
-	unlock_buffer(path[level].bp_sib_bh);
-
 	path[level + 1].bp_index++;
 	nilfs_btree_promote_key(btree, path, level + 1,
 				nilfs_btree_node_get_key(right, 0));
@@ -808,9 +792,6 @@ static void nilfs_btree_split(struct nilfs_btree *btree,
 	__u64 newptr;
 	int nchildren, n, move;
 
-	lock_buffer(path[level].bp_bh);
-	lock_buffer(path[level].bp_sib_bh);
-
 	node = nilfs_btree_get_nonroot_node(path, level);
 	right = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
@@ -829,9 +810,6 @@ static void nilfs_btree_split(struct nilfs_btree *btree,
 	if (!buffer_dirty(path[level].bp_sib_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
 
-	unlock_buffer(path[level].bp_bh);
-	unlock_buffer(path[level].bp_sib_bh);
-
 	newkey = nilfs_btree_node_get_key(right, 0);
 	newptr = path[level].bp_newreq.bpr_ptr;
 
@@ -866,8 +844,6 @@ static void nilfs_btree_grow(struct nilfs_btree *btree,
 	struct nilfs_btree_node *root, *child;
 	int n;
 
-	lock_buffer(path[level].bp_sib_bh);
-
 	root = nilfs_btree_get_root(btree);
 	child = nilfs_btree_get_sib_node(path, level);
 
@@ -879,8 +855,6 @@ static void nilfs_btree_grow(struct nilfs_btree *btree,
 	if (!buffer_dirty(path[level].bp_sib_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
 
-	unlock_buffer(path[level].bp_sib_bh);
-
 	path[level].bp_bh = path[level].bp_sib_bh;
 	path[level].bp_sib_bh = NULL;
 
@@ -1037,11 +1011,9 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 
 		stats->bs_nblocks++;
 
-		lock_buffer(bh);
 		nilfs_btree_node_init(btree,
 				      (struct nilfs_btree_node *)bh->b_data,
 				      0, level, 0, NULL, NULL);
-		unlock_buffer(bh);
 		path[level].bp_sib_bh = bh;
 		path[level].bp_op = nilfs_btree_split;
 	}
@@ -1066,10 +1038,8 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 	if (ret < 0)
 		goto err_out_curr_node;
 
-	lock_buffer(bh);
 	nilfs_btree_node_init(btree, (struct nilfs_btree_node *)bh->b_data,
 			      0, level, 0, NULL, NULL);
-	unlock_buffer(bh);
 	path[level].bp_sib_bh = bh;
 	path[level].bp_op = nilfs_btree_grow;
 
@@ -1168,13 +1138,11 @@ static void nilfs_btree_do_delete(struct nilfs_btree *btree,
 	struct nilfs_btree_node *node;
 
 	if (level < nilfs_btree_height(btree) - 1) {
-		lock_buffer(path[level].bp_bh);
 		node = nilfs_btree_get_nonroot_node(path, level);
 		nilfs_btree_node_delete(btree, node, keyp, ptrp,
 					path[level].bp_index);
 		if (!buffer_dirty(path[level].bp_bh))
 			nilfs_btnode_mark_dirty(path[level].bp_bh);
-		unlock_buffer(path[level].bp_bh);
 		if (path[level].bp_index == 0)
 			nilfs_btree_promote_key(btree, path, level + 1,
 				nilfs_btree_node_get_key(node, 0));
@@ -1194,9 +1162,6 @@ static void nilfs_btree_borrow_left(struct nilfs_btree *btree,
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
-	lock_buffer(path[level].bp_bh);
-	lock_buffer(path[level].bp_sib_bh);
-
 	node = nilfs_btree_get_nonroot_node(path, level);
 	left = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
@@ -1211,9 +1176,6 @@ static void nilfs_btree_borrow_left(struct nilfs_btree *btree,
 	if (!buffer_dirty(path[level].bp_sib_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
 
-	unlock_buffer(path[level].bp_bh);
-	unlock_buffer(path[level].bp_sib_bh);
-
 	nilfs_btree_promote_key(btree, path, level + 1,
 				nilfs_btree_node_get_key(node, 0));
 
@@ -1231,9 +1193,6 @@ static void nilfs_btree_borrow_right(struct nilfs_btree *btree,
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
-	lock_buffer(path[level].bp_bh);
-	lock_buffer(path[level].bp_sib_bh);
-
 	node = nilfs_btree_get_nonroot_node(path, level);
 	right = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
@@ -1248,9 +1207,6 @@ static void nilfs_btree_borrow_right(struct nilfs_btree *btree,
 	if (!buffer_dirty(path[level].bp_sib_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
 
-	unlock_buffer(path[level].bp_bh);
-	unlock_buffer(path[level].bp_sib_bh);
-
 	path[level + 1].bp_index++;
 	nilfs_btree_promote_key(btree, path, level + 1,
 				nilfs_btree_node_get_key(right, 0));
@@ -1269,9 +1225,6 @@ static void nilfs_btree_concat_left(struct nilfs_btree *btree,
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
-	lock_buffer(path[level].bp_bh);
-	lock_buffer(path[level].bp_sib_bh);
-
 	node = nilfs_btree_get_nonroot_node(path, level);
 	left = nilfs_btree_get_sib_node(path, level);
 
@@ -1282,9 +1235,6 @@ static void nilfs_btree_concat_left(struct nilfs_btree *btree,
 	if (!buffer_dirty(path[level].bp_sib_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
 
-	unlock_buffer(path[level].bp_bh);
-	unlock_buffer(path[level].bp_sib_bh);
-
 	nilfs_btnode_delete(path[level].bp_bh);
 	path[level].bp_bh = path[level].bp_sib_bh;
 	path[level].bp_sib_bh = NULL;
@@ -1300,9 +1250,6 @@ static void nilfs_btree_concat_right(struct nilfs_btree *btree,
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
-	lock_buffer(path[level].bp_bh);
-	lock_buffer(path[level].bp_sib_bh);
-
 	node = nilfs_btree_get_nonroot_node(path, level);
 	right = nilfs_btree_get_sib_node(path, level);
 
@@ -1313,9 +1260,6 @@ static void nilfs_btree_concat_right(struct nilfs_btree *btree,
 	if (!buffer_dirty(path[level].bp_bh))
 		nilfs_btnode_mark_dirty(path[level].bp_bh);
 
-	unlock_buffer(path[level].bp_bh);
-	unlock_buffer(path[level].bp_sib_bh);
-
 	nilfs_btnode_delete(path[level].bp_sib_bh);
 	path[level].bp_sib_bh = NULL;
 	path[level + 1].bp_index++;
@@ -1330,7 +1274,6 @@ static void nilfs_btree_shrink(struct nilfs_btree *btree,
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
-	lock_buffer(path[level].bp_bh);
 	root = nilfs_btree_get_root(btree);
 	child = nilfs_btree_get_nonroot_node(path, level);
 
@@ -1338,7 +1281,6 @@ static void nilfs_btree_shrink(struct nilfs_btree *btree,
 	nilfs_btree_node_set_level(root, level);
 	n = nilfs_btree_node_get_nchildren(child);
 	nilfs_btree_node_move_left(btree, root, child, n);
-	unlock_buffer(path[level].bp_bh);
 
 	nilfs_btnode_delete(path[level].bp_bh);
 	path[level].bp_bh = NULL;
@@ -1713,7 +1655,6 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 		nilfs_bmap_commit_alloc_ptr(bmap, nreq, dat);
 
 		/* create child node at level 1 */
-		lock_buffer(bh);
 		node = (struct nilfs_btree_node *)bh->b_data;
 		nilfs_btree_node_init(btree, node, 0, 1, n, keys, ptrs);
 		nilfs_btree_node_insert(btree, node,
@@ -1723,7 +1664,6 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 		if (!nilfs_bmap_dirty(bmap))
 			nilfs_bmap_set_dirty(bmap);
 
-		unlock_buffer(bh);
 		brelse(bh);
 
 		/* create root node at level 2 */
-- 
1.6.3.4
