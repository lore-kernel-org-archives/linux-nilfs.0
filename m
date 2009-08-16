From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/7] nilfs2: stop zero-fill of btree path just
	before free it
Date: Sun, 16 Aug 2009 15:51:06 +0900
Message-ID: <1250405470-23326-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

The btree path object is cleared just before it is freed.

This will remove the code doing the unnecessary clear operation.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   36 ++++++++++++------------------------
 1 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 21ed8cc..115b157 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -97,25 +97,13 @@ static void nilfs_btree_init_path(struct nilfs_btree_path *path)
 	}
 }
 
-static void nilfs_btree_clear_path(struct nilfs_btree_path *path)
+static void nilfs_btree_release_path(struct nilfs_btree_path *path)
 {
 	int level;
 
-	for (level = NILFS_BTREE_LEVEL_DATA;
-	     level < NILFS_BTREE_LEVEL_MAX;
-	     level++) {
-		if (path[level].bp_bh != NULL) {
-			brelse(path[level].bp_bh);
-			path[level].bp_bh = NULL;
-		}
-		/* sib_bh is released or deleted by prepare or commit
-		 * operations. */
-		path[level].bp_sib_bh = NULL;
-		path[level].bp_index = 0;
-		path[level].bp_oldreq.bpr_ptr = NILFS_BMAP_INVALID_PTR;
-		path[level].bp_newreq.bpr_ptr = NILFS_BMAP_INVALID_PTR;
-		path[level].bp_op = NULL;
-	}
+	for (level = NILFS_BTREE_LEVEL_DATA; level < NILFS_BTREE_LEVEL_MAX;
+	     level++)
+		brelse(path[level].bp_bh);
 }
 
 /*
@@ -557,7 +545,7 @@ static int nilfs_btree_lookup(const struct nilfs_bmap *bmap,
 	if (ptrp != NULL)
 		*ptrp = ptr;
 
-	nilfs_btree_clear_path(path);
+	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 
 	return ret;
@@ -639,7 +627,7 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
 	*ptrp = ptr;
 	ret = cnt;
  out:
-	nilfs_btree_clear_path(path);
+	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 	return ret;
 }
@@ -1146,7 +1134,7 @@ static int nilfs_btree_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 	nilfs_bmap_add_blocks(bmap, stats.bs_nblocks);
 
  out:
-	nilfs_btree_clear_path(path);
+	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 	return ret;
 }
@@ -1501,7 +1489,7 @@ static int nilfs_btree_delete(struct nilfs_bmap *bmap, __u64 key)
 	nilfs_bmap_sub_blocks(bmap, stats.bs_nblocks);
 
 out:
-	nilfs_btree_clear_path(path);
+	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 	return ret;
 }
@@ -1520,7 +1508,7 @@ static int nilfs_btree_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
 
 	ret = nilfs_btree_do_lookup_last(btree, path, keyp, NULL);
 
-	nilfs_btree_clear_path(path);
+	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 
 	return ret;
@@ -1975,7 +1963,7 @@ static int nilfs_btree_propagate(const struct nilfs_bmap *bmap,
 		nilfs_btree_propagate_p(btree, path, level, bh);
 
  out:
-	nilfs_btree_clear_path(path);
+	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 
 	return ret;
@@ -2156,7 +2144,7 @@ static int nilfs_btree_assign(struct nilfs_bmap *bmap,
 		nilfs_btree_assign_p(btree, path, level, bh, blocknr, binfo);
 
  out:
-	nilfs_btree_clear_path(path);
+	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 
 	return ret;
@@ -2222,7 +2210,7 @@ static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 		nilfs_bmap_set_dirty(&btree->bt_bmap);
 
  out:
-	nilfs_btree_clear_path(path);
+	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 	return ret;
 }
-- 
1.6.3.4
