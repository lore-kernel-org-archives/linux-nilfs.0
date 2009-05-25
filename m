From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 14/17] nilfs2: remove nilfs_btree_operations
	from btree mapping
Date: Mon, 25 May 2009 19:18:18 +0900
Message-ID: <1243246701-5193-15-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

will remove indirect function calls using nilfs_btree_operations
table.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   52 +++++++++++++++-------------------------------------
 fs/nilfs2/btree.h |   26 --------------------------
 2 files changed, 15 insertions(+), 63 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 20e3fd0..24395e6 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -913,9 +913,9 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 	level = NILFS_BTREE_LEVEL_DATA;
 
 	/* allocate a new ptr for data block */
-	if (btree->bt_ops->btop_find_target != NULL)
+	if (NILFS_BMAP_USE_VBN(&btree->bt_bmap))
 		path[level].bp_newreq.bpr_ptr =
-			btree->bt_ops->btop_find_target(btree, path, key);
+			nilfs_btree_find_target_v(btree, path, key);
 
 	ret = nilfs_bmap_prepare_alloc_ptr(&btree->bt_bmap,
 					   &path[level].bp_newreq);
@@ -1061,8 +1061,8 @@ static void nilfs_btree_commit_insert(struct nilfs_btree *btree,
 
 	set_buffer_nilfs_volatile((struct buffer_head *)((unsigned long)ptr));
 	ptr = path[NILFS_BTREE_LEVEL_DATA].bp_newreq.bpr_ptr;
-	if (btree->bt_ops->btop_set_target != NULL)
-		btree->bt_ops->btop_set_target(btree, key, ptr);
+	if (NILFS_BMAP_USE_VBN(&btree->bt_bmap))
+		nilfs_btree_set_target_v(btree, key, ptr);
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
 		nilfs_bmap_commit_alloc_ptr(&btree->bt_bmap,
@@ -1586,9 +1586,9 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
 
 	/* for data */
 	/* cannot find near ptr */
-	if (btree->bt_ops->btop_find_target != NULL)
-		dreq->bpr_ptr
-			= btree->bt_ops->btop_find_target(btree, NULL, key);
+	if (NILFS_BMAP_USE_VBN(bmap))
+		dreq->bpr_ptr = nilfs_btree_find_target_v(btree, NULL, key);
+
 	ret = nilfs_bmap_prepare_alloc_ptr(bmap, dreq);
 	if (ret < 0)
 		return ret;
@@ -1681,8 +1681,8 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 			nilfs_bmap_set_dirty(bmap);
 	}
 
-	if (btree->bt_ops->btop_set_target != NULL)
-		btree->bt_ops->btop_set_target(btree, key, dreq->bpr_ptr);
+	if (NILFS_BMAP_USE_VBN(bmap))
+		nilfs_btree_set_target_v(btree, key, dreq->bpr_ptr);
 }
 
 /**
@@ -1926,7 +1926,9 @@ static int nilfs_btree_propagate(const struct nilfs_bmap *bmap,
 		goto out;
 	}
 
-	ret = btree->bt_ops->btop_propagate(btree, path, level, bh);
+	ret = NILFS_BMAP_USE_VBN(bmap) ?
+		nilfs_btree_propagate_v(btree, path, level, bh) :
+		nilfs_btree_propagate_p(btree, path, level, bh);
 
  out:
 	nilfs_btree_clear_path(btree, path);
@@ -2107,8 +2109,9 @@ static int nilfs_btree_assign(struct nilfs_bmap *bmap,
 		goto out;
 	}
 
-	ret = btree->bt_ops->btop_assign(btree, path, level, bh,
-					    blocknr, binfo);
+	ret = NILFS_BMAP_USE_VBN(bmap) ?
+		nilfs_btree_assign_v(btree, path, level, bh, blocknr, binfo) :
+		nilfs_btree_assign_p(btree, path, level, bh, blocknr, binfo);
 
  out:
 	nilfs_btree_clear_path(btree, path);
@@ -2220,34 +2223,9 @@ static const struct nilfs_bmap_operations nilfs_btree_ops_gc = {
 	.bop_gather_data	=	NULL,
 };
 
-static const struct nilfs_btree_operations nilfs_btree_ops_v = {
-	.btop_find_target	=	nilfs_btree_find_target_v,
-	.btop_set_target	=	nilfs_btree_set_target_v,
-	.btop_propagate		=	nilfs_btree_propagate_v,
-	.btop_assign		=	nilfs_btree_assign_v,
-};
-
-static const struct nilfs_btree_operations nilfs_btree_ops_p = {
-	.btop_find_target	=	NULL,
-	.btop_set_target	=	NULL,
-	.btop_propagate		=	nilfs_btree_propagate_p,
-	.btop_assign		=	nilfs_btree_assign_p,
-};
-
 int nilfs_btree_init(struct nilfs_bmap *bmap)
 {
-	struct nilfs_btree *btree = (struct nilfs_btree *)bmap;
-
 	bmap->b_ops = &nilfs_btree_ops;
-	switch (bmap->b_inode->i_ino) {
-	case NILFS_DAT_INO:
-		btree->bt_ops = &nilfs_btree_ops_p;
-		break;
-	default:
-		btree->bt_ops = &nilfs_btree_ops_v;
-		break;
-	}
-
 	return 0;
 }
 
diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index 48aad2a..0e72bbb 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -34,28 +34,6 @@ struct nilfs_btree;
 struct nilfs_btree_path;
 
 /**
- * struct nilfs_btree_operations - B-tree operation table
- */
-struct nilfs_btree_operations {
-	__u64 (*btop_find_target)(const struct nilfs_btree *,
-				  const struct nilfs_btree_path *, __u64);
-	void (*btop_set_target)(struct nilfs_btree *, __u64, __u64);
-
-	struct the_nilfs *(*btop_get_nilfs)(struct nilfs_btree *);
-
-	int (*btop_propagate)(struct nilfs_btree *,
-			      struct nilfs_btree_path *,
-			      int,
-			      struct buffer_head *);
-	int (*btop_assign)(struct nilfs_btree *,
-			   struct nilfs_btree_path *,
-			   int,
-			   struct buffer_head **,
-			   sector_t,
-			   union nilfs_binfo *);
-};
-
-/**
  * struct nilfs_btree_node - B-tree node
  * @bn_flags: flags
  * @bn_level: level
@@ -80,13 +58,9 @@ struct nilfs_btree_node {
 /**
  * struct nilfs_btree - B-tree structure
  * @bt_bmap: bmap base structure
- * @bt_ops: B-tree operation table
  */
 struct nilfs_btree {
 	struct nilfs_bmap bt_bmap;
-
-	/* B-tree-specific members */
-	const struct nilfs_btree_operations *bt_ops;
 };
 
 
-- 
1.6.2
