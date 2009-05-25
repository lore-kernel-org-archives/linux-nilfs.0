From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 03/17] nilfs2: unify bmap operations starting
	use of indirect block address
Date: Mon, 25 May 2009 19:18:07 +0900
Message-ID: <1243246701-5193-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This simplifies some low level functions of bmap.

Three bmap pointer operations, nilfs_bmap_start_v(),
nilfs_bmap_commit_v(), and nilfs_bmap_abort_v(), are unified into one
nilfs_bmap_start_v() function. And the related indirect function calls
are replaced with it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c   |   36 ++++++++----------------------------
 fs/nilfs2/bmap.h   |    9 ++-------
 fs/nilfs2/btree.c  |    7 ++-----
 fs/nilfs2/direct.c |    7 ++-----
 4 files changed, 14 insertions(+), 45 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 064279e..4f2523f 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -511,24 +511,16 @@ static void nilfs_bmap_abort_alloc_v(struct nilfs_bmap *bmap,
 	nilfs_dat_abort_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
 }
 
-static int nilfs_bmap_prepare_start_v(struct nilfs_bmap *bmap,
-				      union nilfs_bmap_ptr_req *req)
+int nilfs_bmap_start_v(struct nilfs_bmap *bmap, union nilfs_bmap_ptr_req *req,
+		       sector_t blocknr)
 {
-	return nilfs_dat_prepare_start(nilfs_bmap_get_dat(bmap), &req->bpr_req);
-}
-
-static void nilfs_bmap_commit_start_v(struct nilfs_bmap *bmap,
-				      union nilfs_bmap_ptr_req *req,
-				      sector_t blocknr)
-{
-	nilfs_dat_commit_start(nilfs_bmap_get_dat(bmap), &req->bpr_req,
-			       blocknr);
-}
+	struct inode *dat = nilfs_bmap_get_dat(bmap);
+	int ret;
 
-static void nilfs_bmap_abort_start_v(struct nilfs_bmap *bmap,
-				     union nilfs_bmap_ptr_req *req)
-{
-	nilfs_dat_abort_start(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+	ret = nilfs_dat_prepare_start(dat, &req->bpr_req);
+	if (likely(!ret))
+		nilfs_dat_commit_start(dat, &req->bpr_req, blocknr);
+	return ret;
 }
 
 static int nilfs_bmap_prepare_end_v(struct nilfs_bmap *bmap,
@@ -636,9 +628,6 @@ static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_v = {
 	.bpop_prepare_alloc_ptr	=	nilfs_bmap_prepare_alloc_v,
 	.bpop_commit_alloc_ptr	=	nilfs_bmap_commit_alloc_v,
 	.bpop_abort_alloc_ptr	=	nilfs_bmap_abort_alloc_v,
-	.bpop_prepare_start_ptr	=	nilfs_bmap_prepare_start_v,
-	.bpop_commit_start_ptr	=	nilfs_bmap_commit_start_v,
-	.bpop_abort_start_ptr	=	nilfs_bmap_abort_start_v,
 	.bpop_prepare_end_ptr	=	nilfs_bmap_prepare_end_v,
 	.bpop_commit_end_ptr	=	nilfs_bmap_commit_end_v,
 	.bpop_abort_end_ptr	=	nilfs_bmap_abort_end_v,
@@ -650,9 +639,6 @@ static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_vmdt = {
 	.bpop_prepare_alloc_ptr	=	nilfs_bmap_prepare_alloc_v,
 	.bpop_commit_alloc_ptr	=	nilfs_bmap_commit_alloc_v,
 	.bpop_abort_alloc_ptr	=	nilfs_bmap_abort_alloc_v,
-	.bpop_prepare_start_ptr	=	nilfs_bmap_prepare_start_v,
-	.bpop_commit_start_ptr	=	nilfs_bmap_commit_start_v,
-	.bpop_abort_start_ptr	=	nilfs_bmap_abort_start_v,
 	.bpop_prepare_end_ptr	=	nilfs_bmap_prepare_end_v,
 	.bpop_commit_end_ptr	=	nilfs_bmap_commit_end_vmdt,
 	.bpop_abort_end_ptr	=	nilfs_bmap_abort_end_v,
@@ -664,9 +650,6 @@ static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_p = {
 	.bpop_prepare_alloc_ptr	=	nilfs_bmap_prepare_alloc_p,
 	.bpop_commit_alloc_ptr	=	nilfs_bmap_commit_alloc_p,
 	.bpop_abort_alloc_ptr	=	nilfs_bmap_abort_alloc_p,
-	.bpop_prepare_start_ptr	=	NULL,
-	.bpop_commit_start_ptr	=	NULL,
-	.bpop_abort_start_ptr	=	NULL,
 	.bpop_prepare_end_ptr	=	NULL,
 	.bpop_commit_end_ptr	=	NULL,
 	.bpop_abort_end_ptr	=	NULL,
@@ -678,9 +661,6 @@ static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_gc = {
 	.bpop_prepare_alloc_ptr	=	NULL,
 	.bpop_commit_alloc_ptr	=	NULL,
 	.bpop_abort_alloc_ptr	=	NULL,
-	.bpop_prepare_start_ptr	=	NULL,
-	.bpop_commit_start_ptr	=	NULL,
-	.bpop_abort_start_ptr	=	NULL,
 	.bpop_prepare_end_ptr	=	NULL,
 	.bpop_commit_end_ptr	=	NULL,
 	.bpop_abort_end_ptr	=	NULL,
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 4f2708a..ad251d3 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -96,13 +96,6 @@ struct nilfs_bmap_ptr_operations {
 				      union nilfs_bmap_ptr_req *);
 	void (*bpop_abort_alloc_ptr)(struct nilfs_bmap *,
 				     union nilfs_bmap_ptr_req *);
-	int (*bpop_prepare_start_ptr)(struct nilfs_bmap *,
-				      union nilfs_bmap_ptr_req *);
-	void (*bpop_commit_start_ptr)(struct nilfs_bmap *,
-				      union nilfs_bmap_ptr_req *,
-				      sector_t);
-	void (*bpop_abort_start_ptr)(struct nilfs_bmap *,
-				     union nilfs_bmap_ptr_req *);
 	int (*bpop_prepare_end_ptr)(struct nilfs_bmap *,
 				    union nilfs_bmap_ptr_req *);
 	void (*bpop_commit_end_ptr)(struct nilfs_bmap *,
@@ -183,6 +176,8 @@ void nilfs_bmap_commit_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
  * Internal use only
  */
 
+int nilfs_bmap_start_v(struct nilfs_bmap *, union nilfs_bmap_ptr_req *,
+		       sector_t);
 int nilfs_bmap_move_v(const struct nilfs_bmap *, __u64, sector_t);
 int nilfs_bmap_mark_dirty(const struct nilfs_bmap *, __u64);
 
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 6b37a27..959e5a7 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -2066,12 +2066,9 @@ static int nilfs_btree_assign_v(struct nilfs_btree *btree,
 	ptr = nilfs_btree_node_get_ptr(btree, parent,
 				       path[level + 1].bp_index);
 	req.bpr_ptr = ptr;
-	ret = btree->bt_bmap.b_pops->bpop_prepare_start_ptr(&btree->bt_bmap,
-							       &req);
-	if (ret < 0)
+	ret = nilfs_bmap_start_v(&btree->bt_bmap, &req, blocknr);
+	if (unlikely(ret < 0))
 		return ret;
-	btree->bt_bmap.b_pops->bpop_commit_start_ptr(&btree->bt_bmap,
-							&req, blocknr);
 
 	key = nilfs_btree_node_get_key(btree, parent,
 				       path[level + 1].bp_index);
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index c6379e4..5cbba82 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -327,12 +327,9 @@ static int nilfs_direct_assign_v(struct nilfs_direct *direct,
 	int ret;
 
 	req.bpr_ptr = ptr;
-	ret = direct->d_bmap.b_pops->bpop_prepare_start_ptr(
-		&direct->d_bmap, &req);
-	if (ret < 0)
+	ret = nilfs_bmap_start_v(&direct->d_bmap, &req, blocknr);
+	if (unlikely(ret < 0))
 		return ret;
-	direct->d_bmap.b_pops->bpop_commit_start_ptr(&direct->d_bmap,
-						     &req, blocknr);
 
 	binfo->bi_v.bi_vblocknr = nilfs_bmap_ptr_to_dptr(ptr);
 	binfo->bi_v.bi_blkoff = nilfs_bmap_key_to_dkey(key);
-- 
1.6.2
