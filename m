From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 10/17] nilfs2: remove pointless NULL check of
	bpop_commit_alloc_ptr function
Date: Mon, 25 May 2009 19:18:14 +0900
Message-ID: <1243246701-5193-11-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This indirect function is set to NULL only for gc cache inodes, but
the gc cache inodes never call this function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c  |   15 +++++----------
 fs/nilfs2/direct.c |    4 +---
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 63ee350..5b2606a 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1067,10 +1067,8 @@ static void nilfs_btree_commit_insert(struct nilfs_btree *btree,
 		btree->bt_ops->btop_set_target(btree, key, ptr);
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
-		if (btree->bt_bmap.b_pops->bpop_commit_alloc_ptr != NULL) {
-			btree->bt_bmap.b_pops->bpop_commit_alloc_ptr(
-				&btree->bt_bmap, &path[level - 1].bp_newreq);
-		}
+		btree->bt_bmap.b_pops->bpop_commit_alloc_ptr(
+			&btree->bt_bmap, &path[level - 1].bp_newreq);
 		path[level].bp_op(btree, path, level, &key, &ptr);
 	}
 
@@ -1656,10 +1654,8 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 	btree = (struct nilfs_btree *)bmap;
 	nilfs_btree_init(bmap, low, high);
 	if (nreq != NULL) {
-		if (bmap->b_pops->bpop_commit_alloc_ptr != NULL) {
-			bmap->b_pops->bpop_commit_alloc_ptr(bmap, dreq);
-			bmap->b_pops->bpop_commit_alloc_ptr(bmap, nreq);
-		}
+		bmap->b_pops->bpop_commit_alloc_ptr(bmap, dreq);
+		bmap->b_pops->bpop_commit_alloc_ptr(bmap, nreq);
 
 		/* create child node at level 1 */
 		lock_buffer(bh);
@@ -1681,8 +1677,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 		nilfs_btree_node_init(btree, node, NILFS_BTREE_NODE_ROOT,
 				      2, 1, &keys[0], &tmpptr);
 	} else {
-		if (bmap->b_pops->bpop_commit_alloc_ptr != NULL)
-			bmap->b_pops->bpop_commit_alloc_ptr(bmap, dreq);
+		bmap->b_pops->bpop_commit_alloc_ptr(bmap, dreq);
 
 		/* create root node at level 1 */
 		node = nilfs_btree_get_root(btree);
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 5cbba82..eaeccb0 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -111,9 +111,7 @@ static void nilfs_direct_commit_insert(struct nilfs_direct *direct,
 	bh = (struct buffer_head *)((unsigned long)ptr);
 	set_buffer_nilfs_volatile(bh);
 
-	if (direct->d_bmap.b_pops->bpop_commit_alloc_ptr != NULL)
-		direct->d_bmap.b_pops->bpop_commit_alloc_ptr(
-			&direct->d_bmap, req);
+	direct->d_bmap.b_pops->bpop_commit_alloc_ptr(&direct->d_bmap, req);
 	nilfs_direct_set_ptr(direct, key, req->bpr_ptr);
 
 	if (!nilfs_bmap_dirty(&direct->d_bmap))
-- 
1.6.2
