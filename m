From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/5] nilfs2: get maximum number of child nodes from bmap object
Date: Tue, 13 Jul 2010 23:33:54 +0900
Message-ID: <1279031635-6717-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

The patch "reduce repetitive calculation of max number of child nodes"
gathered up the calculation of maximum number of child nodes into
nilfs_btree_nchildren_per_block() function.  This makes the function
get resultant value from a private variable in bmap object instead of
calculating it for each call.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.h  |    2 ++
 fs/nilfs2/btree.c |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index fae83cf..a20569b 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -105,6 +105,7 @@ static inline int nilfs_bmap_is_new_ptr(unsigned long ptr)
  * @b_last_allocated_ptr: last allocated ptr for data block
  * @b_ptr_type: pointer type
  * @b_state: state
+ * @b_nchildren_per_block: maximum number of child nodes for non-root nodes
  */
 struct nilfs_bmap {
 	union {
@@ -118,6 +119,7 @@ struct nilfs_bmap {
 	__u64 b_last_allocated_ptr;
 	int b_ptr_type;
 	int b_state;
+	__u16 b_nchildren_per_block;
 };
 
 /* pointer type */
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index fef84a6..68d2502 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -153,7 +153,7 @@ static inline int nilfs_btree_node_size(const struct nilfs_bmap *btree)
 
 static int nilfs_btree_nchildren_per_block(const struct nilfs_bmap *btree)
 {
-	return NILFS_BTREE_NODE_NCHILDREN_MAX(nilfs_btree_node_size(btree));
+	return btree->b_nchildren_per_block;
 }
 
 static inline __le64 *
@@ -2217,10 +2217,14 @@ static const struct nilfs_bmap_operations nilfs_btree_ops_gc = {
 int nilfs_btree_init(struct nilfs_bmap *bmap)
 {
 	bmap->b_ops = &nilfs_btree_ops;
+	bmap->b_nchildren_per_block =
+		NILFS_BTREE_NODE_NCHILDREN_MAX(nilfs_btree_node_size(bmap));
 	return 0;
 }
 
 void nilfs_btree_init_gc(struct nilfs_bmap *bmap)
 {
 	bmap->b_ops = &nilfs_btree_ops_gc;
+	bmap->b_nchildren_per_block =
+		NILFS_BTREE_NODE_NCHILDREN_MAX(nilfs_btree_node_size(bmap));
 }
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
