From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: verify btree node after reading
Date: Fri,  9 Jul 2010 20:18:20 +0900
Message-ID: <1278674300-8943-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This inserts sanity checks soon after read btree node from disk.  This
allows early detection of broken btree nodes, and helps to narrow down
problems due to file system corruption.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c   |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/nilfs2/btree.h   |    2 ++
 fs/nilfs2/gcinode.c |    9 +++++++--
 3 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 3863567..d210a8a 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -71,17 +71,23 @@ static int nilfs_btree_get_block(const struct nilfs_btree *btree, __u64 ptr,
 {
 	struct address_space *btnc =
 		&NILFS_BMAP_I((struct nilfs_bmap *)btree)->i_btnode_cache;
+	struct buffer_head *bh;
 	int err;
 
 	err = nilfs_btnode_submit_block(btnc, ptr, 0, bhp);
 	if (err)
 		return err == -EEXIST ? 0 : err;
 
-	wait_on_buffer(*bhp);
-	if (!buffer_uptodate(*bhp)) {
-		brelse(*bhp);
+	bh = *bhp;
+	wait_on_buffer(bh);
+	if (!buffer_uptodate(bh)) {
+		brelse(bh);
 		return -EIO;
 	}
+	if (nilfs_btree_broken_node_block(bh)) {
+		clear_buffer_uptodate(bh);
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -382,6 +388,43 @@ static int nilfs_btree_node_lookup(const struct nilfs_btree_node *node,
 	return s == 0;
 }
 
+/**
+ * nilfs_btree_node_broken - verify consistency of btree node
+ * @node: btree node block to be examined
+ * @size: node size (in bytes)
+ * @blocknr: block number
+ *
+ * Return Value: If node is broken, 1 is returned. Otherwise, 0 is returned.
+ */
+static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
+				   size_t size, sector_t blocknr)
+{
+	int level, flags, nchildren;
+	int ret = 0;
+
+	level = nilfs_btree_node_get_level(node);
+	flags = nilfs_btree_node_get_flags(node);
+	nchildren = nilfs_btree_node_get_nchildren(node);
+
+	if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
+		     level >= NILFS_BTREE_LEVEL_MAX ||
+		     (flags & NILFS_BTREE_NODE_ROOT) ||
+		     nchildren < 0 ||
+		     nchildren > NILFS_BTREE_NODE_NCHILDREN_MAX(size))) {
+		printk(KERN_CRIT "NILFS: bad btree node (blocknr=%llu): "
+		       "level = %d, flags = 0x%x, nchildren = %d\n",
+		       (unsigned long long)blocknr, level, flags, nchildren);
+		ret = 1;
+	}
+	return ret;
+}
+
+int nilfs_btree_broken_node_block(struct buffer_head *bh)
+{
+	return nilfs_btree_node_broken((struct nilfs_btree_node *)bh->b_data,
+				       bh->b_size, bh->b_blocknr);
+}
+
 static inline struct nilfs_btree_node *
 nilfs_btree_get_root(const struct nilfs_btree *btree)
 {
diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index 43c8c5b..980e1e8 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -80,4 +80,6 @@ int nilfs_btree_convert_and_insert(struct nilfs_bmap *, __u64, __u64,
 				   const __u64 *, const __u64 *, int);
 void nilfs_btree_init_gc(struct nilfs_bmap *);
 
+int nilfs_btree_broken_node_block(struct buffer_head *bh);
+
 #endif	/* _NILFS_BTREE_H */
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 145f03c..edb53fc 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -164,10 +164,15 @@ int nilfs_gccache_wait_and_mark_dirty(struct buffer_head *bh)
 	if (buffer_dirty(bh))
 		return -EEXIST;
 
-	if (buffer_nilfs_node(bh))
+	if (buffer_nilfs_node(bh)) {
+		if (nilfs_btree_broken_node_block(bh)) {
+			clear_buffer_uptodate(bh);
+			return -EIO;
+		}
 		nilfs_btnode_mark_dirty(bh);
-	else
+	} else {
 		nilfs_mdt_mark_buffer_dirty(bh);
+	}
 	return 0;
 }
 
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
