From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 08/17] nilfs2: remove nilfs_bmap_delete_block
Date: Mon, 25 May 2009 19:18:12 +0900
Message-ID: <1243246701-5193-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

nilfs_bmap_delete_block() is a wrapper function calling
nilfs_btnode_delete().  This removes it for simplicity.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c  |    6 ------
 fs/nilfs2/bmap.h  |    1 -
 fs/nilfs2/btree.c |    8 ++++----
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index ee9914a..d7dbedf 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -437,12 +437,6 @@ int nilfs_bmap_get_new_block(const struct nilfs_bmap *bmap, __u64 ptr,
 	return 0;
 }
 
-void nilfs_bmap_delete_block(const struct nilfs_bmap *bmap,
-			     struct buffer_head *bh)
-{
-	nilfs_btnode_delete(bh);
-}
-
 __u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *bmap,
 			      const struct buffer_head *bh)
 {
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 5b580b8..0af3190 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -206,7 +206,6 @@ int nilfs_bmap_get_block(const struct nilfs_bmap *, __u64,
 			 struct buffer_head **);
 int nilfs_bmap_get_new_block(const struct nilfs_bmap *, __u64,
 			     struct buffer_head **);
-void nilfs_bmap_delete_block(const struct nilfs_bmap *, struct buffer_head *);
 
 
 /* Assume that bmap semaphore is locked. */
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 102e218..61e70d7 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1026,7 +1026,7 @@ static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
 						    &path[level].bp_newreq);
  err_out_child_node:
 	for (level--; level > NILFS_BTREE_LEVEL_DATA; level--) {
-		nilfs_bmap_delete_block(&btree->bt_bmap, path[level].bp_sib_bh);
+		nilfs_btnode_delete(path[level].bp_sib_bh);
 		btree->bt_bmap.b_pops->bpop_abort_alloc_ptr(
 			&btree->bt_bmap, &path[level].bp_newreq);
 
@@ -1220,7 +1220,7 @@ static void nilfs_btree_concat_left(struct nilfs_btree *btree,
 	unlock_buffer(path[level].bp_bh);
 	unlock_buffer(path[level].bp_sib_bh);
 
-	nilfs_bmap_delete_block(&btree->bt_bmap, path[level].bp_bh);
+	nilfs_btnode_delete(path[level].bp_bh);
 	path[level].bp_bh = path[level].bp_sib_bh;
 	path[level].bp_sib_bh = NULL;
 	path[level].bp_index += nilfs_btree_node_get_nchildren(btree, left);
@@ -1251,7 +1251,7 @@ static void nilfs_btree_concat_right(struct nilfs_btree *btree,
 	unlock_buffer(path[level].bp_bh);
 	unlock_buffer(path[level].bp_sib_bh);
 
-	nilfs_bmap_delete_block(&btree->bt_bmap, path[level].bp_sib_bh);
+	nilfs_btnode_delete(path[level].bp_sib_bh);
 	path[level].bp_sib_bh = NULL;
 	path[level + 1].bp_index++;
 }
@@ -1275,7 +1275,7 @@ static void nilfs_btree_shrink(struct nilfs_btree *btree,
 	nilfs_btree_node_move_left(btree, root, child, n);
 	unlock_buffer(path[level].bp_bh);
 
-	nilfs_bmap_delete_block(&btree->bt_bmap, path[level].bp_bh);
+	nilfs_btnode_delete(path[level].bp_bh);
 	path[level].bp_bh = NULL;
 }
 
-- 
1.6.2
