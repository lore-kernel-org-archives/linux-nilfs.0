From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/6] nilfs2: support contiguous lookup of
	blocks
Date: Mon,  8 Jun 2009 15:07:18 +0900
Message-ID: <1244441239-20032-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1244441239-20032-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1244441239-20032-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

Although get_block() callback function can return extent of contiguous
blocks with bh->b_size, nilfs_get_block() function did not support
this feature.

This adds contiguous lookup feature to the block mapping codes of
nilfs, and allows the nilfs_get_blocks() function to return the extent
information by applying the feature.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c   |   12 +++++++-
 fs/nilfs2/bmap.h   |    4 ++
 fs/nilfs2/btree.c  |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/direct.c |   43 ++++++++++++++++++++++++++
 fs/nilfs2/inode.c  |   15 +++++----
 5 files changed, 150 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 51824c7..36df60b 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -31,7 +31,7 @@
 #include "dat.h"
 #include "alloc.h"
 
-static struct inode *nilfs_bmap_get_dat(const struct nilfs_bmap *bmap)
+struct inode *nilfs_bmap_get_dat(const struct nilfs_bmap *bmap)
 {
 	return nilfs_dat_inode(NILFS_I_NILFS(bmap->b_inode));
 }
@@ -58,6 +58,16 @@ int nilfs_bmap_lookup_at_level(struct nilfs_bmap *bmap, __u64 key, int level,
 	return ret;
 }
 
+int nilfs_bmap_lookup_contig(struct nilfs_bmap *bmap, __u64 key, __u64 *ptrp,
+			     unsigned maxblocks)
+{
+	int ret;
+
+	down_read(&bmap->b_sem);
+	ret = bmap->b_ops->bop_lookup_contig(bmap, key, ptrp, maxblocks);
+	up_read(&bmap->b_sem);
+	return ret;
+}
 
 /**
  * nilfs_bmap_lookup - find a record
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 47f5b74..b2890cd 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -64,6 +64,8 @@ struct nilfs_bmap_stats {
  */
 struct nilfs_bmap_operations {
 	int (*bop_lookup)(const struct nilfs_bmap *, __u64, int, __u64 *);
+	int (*bop_lookup_contig)(const struct nilfs_bmap *, __u64, __u64 *,
+				 unsigned);
 	int (*bop_insert)(struct nilfs_bmap *, __u64, __u64);
 	int (*bop_delete)(struct nilfs_bmap *, __u64);
 	void (*bop_clear)(struct nilfs_bmap *);
@@ -140,6 +142,7 @@ int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *);
 int nilfs_bmap_read(struct nilfs_bmap *, struct nilfs_inode *);
 void nilfs_bmap_write(struct nilfs_bmap *, struct nilfs_inode *);
 int nilfs_bmap_lookup(struct nilfs_bmap *, unsigned long, unsigned long *);
+int nilfs_bmap_lookup_contig(struct nilfs_bmap *, __u64, __u64 *, unsigned);
 int nilfs_bmap_insert(struct nilfs_bmap *, unsigned long, unsigned long);
 int nilfs_bmap_delete(struct nilfs_bmap *, unsigned long);
 int nilfs_bmap_last_key(struct nilfs_bmap *, unsigned long *);
@@ -160,6 +163,7 @@ void nilfs_bmap_commit_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
 /*
  * Internal use only
  */
+struct inode *nilfs_bmap_get_dat(const struct nilfs_bmap *);
 int nilfs_bmap_prepare_alloc_v(struct nilfs_bmap *,
 			       union nilfs_bmap_ptr_req *);
 void nilfs_bmap_commit_alloc_v(struct nilfs_bmap *,
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 24395e6..aa41272 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -29,6 +29,7 @@
 #include "btnode.h"
 #include "btree.h"
 #include "alloc.h"
+#include "dat.h"
 
 /**
  * struct nilfs_btree_path - A path on which B-tree operations are executed
@@ -595,6 +596,87 @@ static int nilfs_btree_lookup(const struct nilfs_bmap *bmap,
 	return ret;
 }
 
+static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
+				     __u64 key, __u64 *ptrp, unsigned maxblocks)
+{
+	struct nilfs_btree *btree = (struct nilfs_btree *)bmap;
+	struct nilfs_btree_path *path;
+	struct nilfs_btree_node *node;
+	struct inode *dat = NULL;
+	__u64 ptr, ptr2;
+	sector_t blocknr;
+	int level = NILFS_BTREE_LEVEL_NODE_MIN;
+	int ret, cnt, index, maxlevel;
+
+	path = nilfs_btree_alloc_path(btree);
+	if (path == NULL)
+		return -ENOMEM;
+	nilfs_btree_init_path(btree, path);
+	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level);
+	if (ret < 0)
+		goto out;
+
+	if (NILFS_BMAP_USE_VBN(bmap)) {
+		dat = nilfs_bmap_get_dat(bmap);
+		ret = nilfs_dat_translate(dat, ptr, &blocknr);
+		if (ret < 0)
+			goto out;
+		ptr = blocknr;
+	}
+	cnt = 1;
+	if (cnt == maxblocks)
+		goto end;
+
+	maxlevel = nilfs_btree_height(btree) - 1;
+	node = nilfs_btree_get_node(btree, path, level);
+	index = path[level].bp_index + 1;
+	for (;;) {
+		while (index < nilfs_btree_node_get_nchildren(btree, node)) {
+			if (nilfs_btree_node_get_key(btree, node, index) !=
+			    key + cnt)
+				goto end;
+			ptr2 = nilfs_btree_node_get_ptr(btree, node, index);
+			if (dat) {
+				ret = nilfs_dat_translate(dat, ptr2, &blocknr);
+				if (ret < 0)
+					goto out;
+				ptr2 = blocknr;
+			}
+			if (ptr2 != ptr + cnt || ++cnt == maxblocks)
+				goto end;
+			index++;
+			continue;
+		}
+		if (level == maxlevel)
+			break;
+
+		/* look-up right sibling node */
+		node = nilfs_btree_get_node(btree, path, level + 1);
+		index = path[level + 1].bp_index + 1;
+		if (index >= nilfs_btree_node_get_nchildren(btree, node) ||
+		    nilfs_btree_node_get_key(btree, node, index) != key + cnt)
+			break;
+		ptr2 = nilfs_btree_node_get_ptr(btree, node, index);
+		path[level + 1].bp_index = index;
+
+		brelse(path[level].bp_bh);
+		path[level].bp_bh = NULL;
+		ret = nilfs_btree_get_block(btree, ptr2, &path[level].bp_bh);
+		if (ret < 0)
+			goto out;
+		node = nilfs_btree_get_nonroot_node(btree, path, level);
+		index = 0;
+		path[level].bp_index = index;
+	}
+ end:
+	*ptrp = ptr;
+	ret = cnt;
+ out:
+	nilfs_btree_clear_path(btree, path);
+	nilfs_btree_free_path(btree, path);
+	return ret;
+}
+
 static void nilfs_btree_promote_key(struct nilfs_btree *btree,
 				    struct nilfs_btree_path *path,
 				    int level, __u64 key)
@@ -2187,6 +2269,7 @@ static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 
 static const struct nilfs_bmap_operations nilfs_btree_ops = {
 	.bop_lookup		=	nilfs_btree_lookup,
+	.bop_lookup_contig	=	nilfs_btree_lookup_contig,
 	.bop_insert		=	nilfs_btree_insert,
 	.bop_delete		=	nilfs_btree_delete,
 	.bop_clear		=	NULL,
@@ -2206,6 +2289,7 @@ static const struct nilfs_bmap_operations nilfs_btree_ops = {
 
 static const struct nilfs_bmap_operations nilfs_btree_ops_gc = {
 	.bop_lookup		=	NULL,
+	.bop_lookup_contig	=	NULL,
 	.bop_insert		=	NULL,
 	.bop_delete		=	NULL,
 	.bop_clear		=	NULL,
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 33467ad..342d976 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -25,6 +25,7 @@
 #include "page.h"
 #include "direct.h"
 #include "alloc.h"
+#include "dat.h"
 
 static inline __le64 *nilfs_direct_dptrs(const struct nilfs_direct *direct)
 {
@@ -62,6 +63,47 @@ static int nilfs_direct_lookup(const struct nilfs_bmap *bmap,
 	return 0;
 }
 
+static int nilfs_direct_lookup_contig(const struct nilfs_bmap *bmap,
+				      __u64 key, __u64 *ptrp,
+				      unsigned maxblocks)
+{
+	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
+	struct inode *dat = NULL;
+	__u64 ptr, ptr2;
+	sector_t blocknr;
+	int ret, cnt;
+
+	if (key > NILFS_DIRECT_KEY_MAX ||
+	    (ptr = nilfs_direct_get_ptr(direct, key)) ==
+	    NILFS_BMAP_INVALID_PTR)
+		return -ENOENT;
+
+	if (NILFS_BMAP_USE_VBN(bmap)) {
+		dat = nilfs_bmap_get_dat(bmap);
+		ret = nilfs_dat_translate(dat, ptr, &blocknr);
+		if (ret < 0)
+			return ret;
+		ptr = blocknr;
+	}
+
+	maxblocks = min_t(unsigned, maxblocks, NILFS_DIRECT_KEY_MAX - key + 1);
+	for (cnt = 1; cnt < maxblocks &&
+		     (ptr2 = nilfs_direct_get_ptr(direct, key + cnt)) !=
+		     NILFS_BMAP_INVALID_PTR;
+	     cnt++) {
+		if (dat) {
+			ret = nilfs_dat_translate(dat, ptr2, &blocknr);
+			if (ret < 0)
+				return ret;
+			ptr2 = blocknr;
+		}
+		if (ptr2 != ptr + cnt)
+			break;
+	}
+	*ptrp = ptr;
+	return cnt;
+}
+
 static __u64
 nilfs_direct_find_target_v(const struct nilfs_direct *direct, __u64 key)
 {
@@ -367,6 +409,7 @@ static int nilfs_direct_assign(struct nilfs_bmap *bmap,
 
 static const struct nilfs_bmap_operations nilfs_direct_ops = {
 	.bop_lookup		=	nilfs_direct_lookup,
+	.bop_lookup_contig	=	nilfs_direct_lookup_contig,
 	.bop_insert		=	nilfs_direct_insert,
 	.bop_delete		=	nilfs_direct_delete,
 	.bop_clear		=	NULL,
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index f25fd4b..2696d6b 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -43,22 +43,23 @@
  *
  * This function does not issue actual read request of the specified data
  * block. It is done by VFS.
- * Bulk read for direct-io is not supported yet. (should be supported)
  */
 int nilfs_get_block(struct inode *inode, sector_t blkoff,
 		    struct buffer_head *bh_result, int create)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	unsigned long blknum = 0;
+	__u64 blknum = 0;
 	int err = 0, ret;
 	struct inode *dat = nilfs_dat_inode(NILFS_I_NILFS(inode));
+	unsigned maxblocks = bh_result->b_size >> inode->i_blkbits;
 
-	/* This exclusion control is a workaround; should be revised */
-	down_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
-	ret = nilfs_bmap_lookup(ii->i_bmap, (unsigned long)blkoff, &blknum);
-	up_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
-	if (ret == 0) {	/* found */
+	down_read(&NILFS_MDT(dat)->mi_sem);
+	ret = nilfs_bmap_lookup_contig(ii->i_bmap, blkoff, &blknum, maxblocks);
+	up_read(&NILFS_MDT(dat)->mi_sem);
+	if (ret >= 0) {	/* found */
 		map_bh(bh_result, inode->i_sb, blknum);
+		if (ret > 0)
+			bh_result->b_size = (ret << inode->i_blkbits);
 		goto out;
 	}
 	/* data block was not found */
-- 
1.6.2
