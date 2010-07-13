From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/5] nilfs2: eliminate inline keywords in btree implementation
Date: Tue, 13 Jul 2010 23:33:55 +0900
Message-ID: <1279031635-6717-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1279031635-6717-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279031635-6717-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This removes all inline uses from btree.c.  Gcc now agressively apply
inline expansion even for the functions declared without the keyword;
the inline use in btree.c looks excessive.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c |   41 +++++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 68d2502..2733105 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -105,48 +105,45 @@ static int nilfs_btree_get_new_block(const struct nilfs_bmap *btree,
 	return 0;
 }
 
-static inline int
-nilfs_btree_node_get_flags(const struct nilfs_btree_node *node)
+static int nilfs_btree_node_get_flags(const struct nilfs_btree_node *node)
 {
 	return node->bn_flags;
 }
 
-static inline void
+static void
 nilfs_btree_node_set_flags(struct nilfs_btree_node *node, int flags)
 {
 	node->bn_flags = flags;
 }
 
-static inline int nilfs_btree_node_root(const struct nilfs_btree_node *node)
+static int nilfs_btree_node_root(const struct nilfs_btree_node *node)
 {
 	return nilfs_btree_node_get_flags(node) & NILFS_BTREE_NODE_ROOT;
 }
 
-static inline int
-nilfs_btree_node_get_level(const struct nilfs_btree_node *node)
+static int nilfs_btree_node_get_level(const struct nilfs_btree_node *node)
 {
 	return node->bn_level;
 }
 
-static inline void
+static void
 nilfs_btree_node_set_level(struct nilfs_btree_node *node, int level)
 {
 	node->bn_level = level;
 }
 
-static inline int
-nilfs_btree_node_get_nchildren(const struct nilfs_btree_node *node)
+static int nilfs_btree_node_get_nchildren(const struct nilfs_btree_node *node)
 {
 	return le16_to_cpu(node->bn_nchildren);
 }
 
-static inline void
+static void
 nilfs_btree_node_set_nchildren(struct nilfs_btree_node *node, int nchildren)
 {
 	node->bn_nchildren = cpu_to_le16(nchildren);
 }
 
-static inline int nilfs_btree_node_size(const struct nilfs_bmap *btree)
+static int nilfs_btree_node_size(const struct nilfs_bmap *btree)
 {
 	return 1 << btree->b_inode->i_blkbits;
 }
@@ -156,7 +153,7 @@ static int nilfs_btree_nchildren_per_block(const struct nilfs_bmap *btree)
 	return btree->b_nchildren_per_block;
 }
 
-static inline __le64 *
+static __le64 *
 nilfs_btree_node_dkeys(const struct nilfs_btree_node *node)
 {
 	return (__le64 *)((char *)(node + 1) +
@@ -164,32 +161,32 @@ nilfs_btree_node_dkeys(const struct nilfs_btree_node *node)
 			   0 : NILFS_BTREE_NODE_EXTRA_PAD_SIZE));
 }
 
-static inline __le64 *
+static __le64 *
 nilfs_btree_node_dptrs(const struct nilfs_btree_node *node, int ncmax)
 {
 	return (__le64 *)(nilfs_btree_node_dkeys(node) + ncmax);
 }
 
-static inline __u64
+static __u64
 nilfs_btree_node_get_key(const struct nilfs_btree_node *node, int index)
 {
 	return le64_to_cpu(*(nilfs_btree_node_dkeys(node) + index));
 }
 
-static inline void
+static void
 nilfs_btree_node_set_key(struct nilfs_btree_node *node, int index, __u64 key)
 {
 	*(nilfs_btree_node_dkeys(node) + index) = cpu_to_le64(key);
 }
 
-static inline __u64
+static __u64
 nilfs_btree_node_get_ptr(const struct nilfs_btree_node *node, int index,
 			 int ncmax)
 {
 	return le64_to_cpu(*(nilfs_btree_node_dptrs(node, ncmax) + index));
 }
 
-static inline void
+static void
 nilfs_btree_node_set_ptr(struct nilfs_btree_node *node, int index, __u64 ptr,
 			 int ncmax)
 {
@@ -401,25 +398,25 @@ int nilfs_btree_broken_node_block(struct buffer_head *bh)
 				       bh->b_size, bh->b_blocknr);
 }
 
-static inline struct nilfs_btree_node *
+static struct nilfs_btree_node *
 nilfs_btree_get_root(const struct nilfs_bmap *btree)
 {
 	return (struct nilfs_btree_node *)btree->b_u.u_data;
 }
 
-static inline struct nilfs_btree_node *
+static struct nilfs_btree_node *
 nilfs_btree_get_nonroot_node(const struct nilfs_btree_path *path, int level)
 {
 	return (struct nilfs_btree_node *)path[level].bp_bh->b_data;
 }
 
-static inline struct nilfs_btree_node *
+static struct nilfs_btree_node *
 nilfs_btree_get_sib_node(const struct nilfs_btree_path *path, int level)
 {
 	return (struct nilfs_btree_node *)path[level].bp_sib_bh->b_data;
 }
 
-static inline int nilfs_btree_height(const struct nilfs_bmap *btree)
+static int nilfs_btree_height(const struct nilfs_bmap *btree)
 {
 	return nilfs_btree_node_get_level(nilfs_btree_get_root(btree)) + 1;
 }
@@ -441,7 +438,7 @@ nilfs_btree_get_node(const struct nilfs_bmap *btree,
 	return node;
 }
 
-static inline int
+static int
 nilfs_btree_bad_node(struct nilfs_btree_node *node, int level)
 {
 	if (unlikely(nilfs_btree_node_get_level(node) != level)) {
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
