From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 09/17] nilfs2: move get block functions in
	bmap.c into btree codes
Date: Mon, 25 May 2009 19:18:13 +0900
Message-ID: <1243246701-5193-10-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Two get block function for btree nodes, nilfs_bmap_get_block() and
nilfs_bmap_get_new_block(), are called only from the btree codes.
This relocation will increase opportunities of compiler optimization.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c  |   20 ------------------
 fs/nilfs2/bmap.h  |    6 -----
 fs/nilfs2/btree.c |   57 ++++++++++++++++++++++++++++++++--------------------
 3 files changed, 35 insertions(+), 48 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index d7dbedf..cf5c5d2 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -417,26 +417,6 @@ void nilfs_bmap_sub_blocks(const struct nilfs_bmap *bmap, int n)
 		mark_inode_dirty(bmap->b_inode);
 }
 
-int nilfs_bmap_get_block(const struct nilfs_bmap *bmap, __u64 ptr,
-			 struct buffer_head **bhp)
-{
-	return nilfs_btnode_get(&NILFS_BMAP_I(bmap)->i_btnode_cache,
-				ptr, 0, bhp, 0);
-}
-
-int nilfs_bmap_get_new_block(const struct nilfs_bmap *bmap, __u64 ptr,
-			     struct buffer_head **bhp)
-{
-	int ret;
-
-	ret = nilfs_btnode_get(&NILFS_BMAP_I(bmap)->i_btnode_cache,
-			       ptr, 0, bhp, 1);
-	if (ret < 0)
-		return ret;
-	set_buffer_nilfs_volatile(*bhp);
-	return 0;
-}
-
 __u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *bmap,
 			      const struct buffer_head *bh)
 {
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 0af3190..978073b 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -202,12 +202,6 @@ void nilfs_bmap_add_blocks(const struct nilfs_bmap *, int);
 void nilfs_bmap_sub_blocks(const struct nilfs_bmap *, int);
 
 
-int nilfs_bmap_get_block(const struct nilfs_bmap *, __u64,
-			 struct buffer_head **);
-int nilfs_bmap_get_new_block(const struct nilfs_bmap *, __u64,
-			     struct buffer_head **);
-
-
 /* Assume that bmap semaphore is locked. */
 static inline int nilfs_bmap_dirty(const struct nilfs_bmap *bmap)
 {
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 61e70d7..63ee350 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -122,10 +122,29 @@ static void nilfs_btree_clear_path(const struct nilfs_btree *btree,
 	}
 }
 
-
 /*
  * B-tree node operations
  */
+static int nilfs_btree_get_block(const struct nilfs_btree *btree, __u64 ptr,
+				 struct buffer_head **bhp)
+{
+	struct address_space *btnc =
+		&NILFS_BMAP_I((struct nilfs_bmap *)btree)->i_btnode_cache;
+	return nilfs_btnode_get(btnc, ptr, 0, bhp, 0);
+}
+
+static int nilfs_btree_get_new_block(const struct nilfs_btree *btree,
+				     __u64 ptr, struct buffer_head **bhp)
+{
+	struct address_space *btnc =
+		&NILFS_BMAP_I((struct nilfs_bmap *)btree)->i_btnode_cache;
+	int ret;
+
+	ret = nilfs_btnode_get(btnc, ptr, 0, bhp, 1);
+	if (!ret)
+		set_buffer_nilfs_volatile(*bhp);
+	return ret;
+}
 
 static inline int
 nilfs_btree_node_get_flags(const struct nilfs_btree *btree,
@@ -487,8 +506,7 @@ static int nilfs_btree_do_lookup(const struct nilfs_btree *btree,
 	path[level].bp_index = index;
 
 	for (level--; level >= minlevel; level--) {
-		ret = nilfs_bmap_get_block(&btree->bt_bmap, ptr,
-					   &path[level].bp_bh);
+		ret = nilfs_btree_get_block(btree, ptr, &path[level].bp_bh);
 		if (ret < 0)
 			return ret;
 		node = nilfs_btree_get_nonroot_node(btree, path, level);
@@ -534,8 +552,7 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_btree *btree,
 	path[level].bp_index = index;
 
 	for (level--; level > 0; level--) {
-		ret = nilfs_bmap_get_block(&btree->bt_bmap, ptr,
-					   &path[level].bp_bh);
+		ret = nilfs_btree_get_block(btree, ptr, &path[level].bp_bh);
 		if (ret < 0)
 			return ret;
 		node = nilfs_btree_get_nonroot_node(btree, path, level);
@@ -923,8 +940,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 		if (pindex > 0) {
 			sibptr = nilfs_btree_node_get_ptr(btree, parent,
 							  pindex - 1);
-			ret = nilfs_bmap_get_block(&btree->bt_bmap, sibptr,
-						   &bh);
+			ret = nilfs_btree_get_block(btree, sibptr, &bh);
 			if (ret < 0)
 				goto err_out_child_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
@@ -943,8 +959,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 		    nilfs_btree_node_get_nchildren(btree, parent) - 1) {
 			sibptr = nilfs_btree_node_get_ptr(btree, parent,
 							  pindex + 1);
-			ret = nilfs_bmap_get_block(&btree->bt_bmap, sibptr,
-						   &bh);
+			ret = nilfs_btree_get_block(btree, sibptr, &bh);
 			if (ret < 0)
 				goto err_out_child_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
@@ -965,9 +980,9 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 			&btree->bt_bmap, &path[level].bp_newreq);
 		if (ret < 0)
 			goto err_out_child_node;
-		ret = nilfs_bmap_get_new_block(&btree->bt_bmap,
-					       path[level].bp_newreq.bpr_ptr,
-					       &bh);
+		ret = nilfs_btree_get_new_block(btree,
+						path[level].bp_newreq.bpr_ptr,
+						&bh);
 		if (ret < 0)
 			goto err_out_curr_node;
 
@@ -997,8 +1012,8 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 		&btree->bt_bmap, &path[level].bp_newreq);
 	if (ret < 0)
 		goto err_out_child_node;
-	ret = nilfs_bmap_get_new_block(&btree->bt_bmap,
-				       path[level].bp_newreq.bpr_ptr, &bh);
+	ret = nilfs_btree_get_new_block(btree, path[level].bp_newreq.bpr_ptr,
+					&bh);
 	if (ret < 0)
 		goto err_out_curr_node;
 
@@ -1320,8 +1335,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 			/* left sibling */
 			sibptr = nilfs_btree_node_get_ptr(btree, parent,
 							  pindex - 1);
-			ret = nilfs_bmap_get_block(&btree->bt_bmap, sibptr,
-						   &bh);
+			ret = nilfs_btree_get_block(btree, sibptr, &bh);
 			if (ret < 0)
 				goto err_out_curr_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
@@ -1342,8 +1356,7 @@ static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
 			/* right sibling */
 			sibptr = nilfs_btree_node_get_ptr(btree, parent,
 							  pindex + 1);
-			ret = nilfs_bmap_get_block(&btree->bt_bmap, sibptr,
-						   &bh);
+			ret = nilfs_btree_get_block(btree, sibptr, &bh);
 			if (ret < 0)
 				goto err_out_curr_node;
 			sib = (struct nilfs_btree_node *)bh->b_data;
@@ -1500,7 +1513,7 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *bmap, __u64 key)
 		if (nchildren > 1)
 			return 0;
 		ptr = nilfs_btree_node_get_ptr(btree, root, nchildren - 1);
-		ret = nilfs_bmap_get_block(bmap, ptr, &bh);
+		ret = nilfs_btree_get_block(btree, ptr, &bh);
 		if (ret < 0)
 			return ret;
 		node = (struct nilfs_btree_node *)bh->b_data;
@@ -1541,7 +1554,7 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *bmap,
 		nchildren = nilfs_btree_node_get_nchildren(btree, root);
 		WARN_ON(nchildren > 1);
 		ptr = nilfs_btree_node_get_ptr(btree, root, nchildren - 1);
-		ret = nilfs_bmap_get_block(bmap, ptr, &bh);
+		ret = nilfs_btree_get_block(btree, ptr, &bh);
 		if (ret < 0)
 			return ret;
 		node = (struct nilfs_btree_node *)bh->b_data;
@@ -1598,7 +1611,7 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
 		if (ret < 0)
 			goto err_out_dreq;
 
-		ret = nilfs_bmap_get_new_block(bmap, nreq->bpr_ptr, &bh);
+		ret = nilfs_btree_get_new_block(btree, nreq->bpr_ptr, &bh);
 		if (ret < 0)
 			goto err_out_nreq;
 
@@ -2167,7 +2180,7 @@ static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 		WARN_ON(ret == -ENOENT);
 		goto out;
 	}
-	ret = nilfs_bmap_get_block(&btree->bt_bmap, ptr, &bh);
+	ret = nilfs_btree_get_block(btree, ptr, &bh);
 	if (ret < 0) {
 		WARN_ON(ret == -ENOENT);
 		goto out;
-- 
1.6.2
