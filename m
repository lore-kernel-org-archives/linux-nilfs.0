From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/4] nilfs2: add btree get block function with readahead option
Date: Sun, 18 Jul 2010 10:42:24 +0900
Message-ID: <1279417346-9688-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1279417346-9688-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279417346-9688-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds __nilfs_btree_get_block() function that can issue a series
of read-ahead requests for sibling btree nodes.

This read-ahead needs parent node block, so nilfs_btree_readahead_info
structure is added to pass the information that
__nilfs_btree_get_block() needs.

This also replaces the previous nilfs_btree_get_block() implementation
with a wrapper function of __nilfs_btree_get_block().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   94 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 68 insertions(+), 26 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 4669389..1b5321c 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -66,32 +66,6 @@ static void nilfs_btree_free_path(struct nilfs_btree_path *path)
 /*
  * B-tree node operations
  */
-static int nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
-				 struct buffer_head **bhp)
-{
-	struct address_space *btnc = &NILFS_BMAP_I(btree)->i_btnode_cache;
-	struct buffer_head *bh;
-	sector_t pbn = 0;
-	int err;
-
-	err = nilfs_btnode_submit_block(btnc, ptr, pbn, READ, bhp, &pbn);
-	if (err)
-		return err == -EEXIST ? 0 : err;
-
-	bh = *bhp;
-	wait_on_buffer(bh);
-	if (!buffer_uptodate(bh)) {
-		brelse(bh);
-		return -EIO;
-	}
-	if (nilfs_btree_broken_node_block(bh)) {
-		clear_buffer_uptodate(bh);
-		brelse(bh);
-		return -EINVAL;
-	}
-	return 0;
-}
-
 static int nilfs_btree_get_new_block(const struct nilfs_bmap *btree,
 				     __u64 ptr, struct buffer_head **bhp)
 {
@@ -452,6 +426,74 @@ nilfs_btree_bad_node(struct nilfs_btree_node *node, int level)
 	return 0;
 }
 
+struct nilfs_btree_readahead_info {
+	struct nilfs_btree_node *node;	/* parent node */
+	int max_ra_blocks;		/* max nof blocks to read ahead */
+	int index;			/* current index on the parent node */
+	int ncmax;			/* nof children in the parent node */
+};
+
+static int __nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
+				   struct buffer_head **bhp,
+				   const struct nilfs_btree_readahead_info *ra)
+{
+	struct address_space *btnc = &NILFS_BMAP_I(btree)->i_btnode_cache;
+	struct buffer_head *bh, *ra_bh;
+	sector_t submit_ptr = 0;
+	int ret;
+
+	ret = nilfs_btnode_submit_block(btnc, ptr, 0, READ, &bh, &submit_ptr);
+	if (ret) {
+		if (ret != -EEXIST)
+			return ret;
+		goto out_check;
+	}
+
+	if (ra) {
+		int i, n;
+		__u64 ptr2;
+
+		/* read ahead sibling nodes */
+		for (n = ra->max_ra_blocks, i = ra->index + 1;
+		     n > 0 && i < ra->ncmax; n--, i++) {
+			ptr2 = nilfs_btree_node_get_ptr(ra->node, i, ra->ncmax);
+
+			ret = nilfs_btnode_submit_block(btnc, ptr2, 0, READA,
+							&ra_bh, &submit_ptr);
+			if (likely(!ret || ret == -EEXIST))
+				brelse(ra_bh);
+			else if (ret != -EBUSY)
+				break;
+			if (!buffer_locked(bh))
+				goto out_no_wait;
+		}
+	}
+
+	wait_on_buffer(bh);
+
+ out_no_wait:
+	if (!buffer_uptodate(bh)) {
+		brelse(bh);
+		return -EIO;
+	}
+
+ out_check:
+	if (nilfs_btree_broken_node_block(bh)) {
+		clear_buffer_uptodate(bh);
+		brelse(bh);
+		return -EINVAL;
+	}
+
+	*bhp = bh;
+	return 0;
+}
+
+static int nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
+				   struct buffer_head **bhp)
+{
+	return __nilfs_btree_get_block(btree, ptr, bhp, NULL);
+}
+
 static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 				 struct nilfs_btree_path *path,
 				 __u64 key, __u64 *ptrp, int minlevel)
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
