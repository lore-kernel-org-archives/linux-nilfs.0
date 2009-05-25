From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 13/17] nilfs2: remove nilfs_direct_operations
	from direct mapping
Date: Mon, 25 May 2009 19:18:17 +0900
Message-ID: <1243246701-5193-14-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

will remove indirect function calls using nilfs_direct_operations
table.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/direct.c |   46 ++++++++++------------------------------------
 fs/nilfs2/direct.h |   16 ----------------
 2 files changed, 10 insertions(+), 52 deletions(-)

diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 2a546c8..33467ad 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -90,8 +90,8 @@ static int nilfs_direct_prepare_insert(struct nilfs_direct *direct,
 {
 	int ret;
 
-	if (direct->d_ops->dop_find_target != NULL)
-		req->bpr_ptr = direct->d_ops->dop_find_target(direct, key);
+	if (NILFS_BMAP_USE_VBN(&direct->d_bmap))
+		req->bpr_ptr = nilfs_direct_find_target_v(direct, key);
 	ret = nilfs_bmap_prepare_alloc_ptr(&direct->d_bmap, req);
 	if (ret < 0)
 		return ret;
@@ -116,8 +116,8 @@ static void nilfs_direct_commit_insert(struct nilfs_direct *direct,
 	if (!nilfs_bmap_dirty(&direct->d_bmap))
 		nilfs_bmap_set_dirty(&direct->d_bmap);
 
-	if (direct->d_ops->dop_set_target != NULL)
-		direct->d_ops->dop_set_target(direct, key, req->bpr_ptr);
+	if (NILFS_BMAP_USE_VBN(&direct->d_bmap))
+		nilfs_direct_set_target_v(direct, key, req->bpr_ptr);
 }
 
 static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
@@ -297,12 +297,10 @@ static int nilfs_direct_propagate_v(struct nilfs_direct *direct,
 static int nilfs_direct_propagate(const struct nilfs_bmap *bmap,
 				  struct buffer_head *bh)
 {
-	struct nilfs_direct *direct;
+	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
 
-	direct = (struct nilfs_direct *)bmap;
-	return (direct->d_ops->dop_propagate != NULL) ?
-		direct->d_ops->dop_propagate(direct, bh) :
-		0;
+	return NILFS_BMAP_USE_VBN(bmap) ?
+		nilfs_direct_propagate_v(direct, bh) : 0;
 }
 
 static int nilfs_direct_assign_v(struct nilfs_direct *direct,
@@ -362,8 +360,9 @@ static int nilfs_direct_assign(struct nilfs_bmap *bmap,
 		return -EINVAL;
 	}
 
-	return direct->d_ops->dop_assign(direct, key, ptr, bh,
-					 blocknr, binfo);
+	return NILFS_BMAP_USE_VBN(bmap) ?
+		nilfs_direct_assign_v(direct, key, ptr, bh, blocknr, binfo) :
+		nilfs_direct_assign_p(direct, key, ptr, bh, blocknr, binfo);
 }
 
 static const struct nilfs_bmap_operations nilfs_direct_ops = {
@@ -386,33 +385,8 @@ static const struct nilfs_bmap_operations nilfs_direct_ops = {
 };
 
 
-static const struct nilfs_direct_operations nilfs_direct_ops_v = {
-	.dop_find_target	=	nilfs_direct_find_target_v,
-	.dop_set_target		=	nilfs_direct_set_target_v,
-	.dop_propagate		=	nilfs_direct_propagate_v,
-	.dop_assign		=	nilfs_direct_assign_v,
-};
-
-static const struct nilfs_direct_operations nilfs_direct_ops_p = {
-	.dop_find_target	=	NULL,
-	.dop_set_target		=	NULL,
-	.dop_propagate		=	NULL,
-	.dop_assign		=	nilfs_direct_assign_p,
-};
-
 int nilfs_direct_init(struct nilfs_bmap *bmap)
 {
-	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
-
 	bmap->b_ops = &nilfs_direct_ops;
-	switch (bmap->b_inode->i_ino) {
-	case NILFS_DAT_INO:
-		direct->d_ops = &nilfs_direct_ops_p;
-		break;
-	default:
-		direct->d_ops = &nilfs_direct_ops_v;
-		break;
-	}
-
 	return 0;
 }
diff --git a/fs/nilfs2/direct.h b/fs/nilfs2/direct.h
index d645f13..a5ffd66 100644
--- a/fs/nilfs2/direct.h
+++ b/fs/nilfs2/direct.h
@@ -31,18 +31,6 @@
 struct nilfs_direct;
 
 /**
- * struct nilfs_direct_operations - direct mapping operation table
- */
-struct nilfs_direct_operations {
-	__u64 (*dop_find_target)(const struct nilfs_direct *, __u64);
-	void (*dop_set_target)(struct nilfs_direct *, __u64, __u64);
-	int (*dop_propagate)(struct nilfs_direct *, struct buffer_head *);
-	int (*dop_assign)(struct nilfs_direct *, __u64, __u64,
-			  struct buffer_head **, sector_t,
-			  union nilfs_binfo *);
-};
-
-/**
  * struct nilfs_direct_node - direct node
  * @dn_flags: flags
  * @dn_pad: padding
@@ -55,13 +43,9 @@ struct nilfs_direct_node {
 /**
  * struct nilfs_direct - direct mapping
  * @d_bmap: bmap structure
- * @d_ops: direct mapping operation table
  */
 struct nilfs_direct {
 	struct nilfs_bmap d_bmap;
-
-	/* direct-mapping-specific members */
-	const struct nilfs_direct_operations *d_ops;
 };
 
 
-- 
1.6.2
