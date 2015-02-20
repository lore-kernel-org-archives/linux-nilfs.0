From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/1] nilfs2: fix potential memory overrun on inode
Date: Fri, 20 Feb 2015 22:46:35 +0900
Message-ID: <1424439995-613-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1424439995-613-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=5qWan5o0Sspe6REtdKIvQXHjOxvyAxLlyE8bWo8g5XA=;
        b=jZOkNmO1VDpJNtBpZAQRdAtdIRaexIVnfpRRkI29dMpgX/tQg04C3/MkxL2Ka9phHV
         U7VKIGC7Eomb5EcxXrlYedMEBQWdLbnnbOldD49V7xZx18dPHO9KWqbTY5eZQcXFS3La
         O5JN+88BJVF9o2A6ZWDpZjliQJ5BTzjbPeNp0aivgXSqiz6pcGbWQZQ7JePu9h37EmG4
         TadCzF6byvHGNow53iVM+2mkN7qXBNLr3pFebj+HJKq74X+udU1hkRHkhGBkrxsrGdqC
         /p8SSXSNk7V3+dAlNYQczTloD7ntWjBgfnNFRvt1yiu3MS4qMGbS4G/UK2Nj8pEth5ek
         TBPQ==
In-Reply-To: <1424439995-613-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Each inode of nilfs2 stores a root node of a b-tree, and it turned out
to have a memory overrun issue:

Each b-tree node of nilfs2 stores a set of key-value pairs and the
number of them (in "bn_nchildren" member of nilfs_btree_node struct),
as well as a few other "bn_*" members.

Since the value of "bn_nchildren" is used for operations on the
key-values within the b-tree node, it can cause memory access overrun
if a large number is incorrectly set to "bn_nchildren".

For instance, nilfs_btree_node_lookup() function determines the range
of binary search with it, and too large "bn_nchildren" leads
nilfs_btree_node_get_key() in that function to overrun.

As for intermediate b-tree nodes, this is prevented by a sanity check
performed when each node is read from a drive, however, no sanity
check has been done for root nodes stored in inodes.

This patch fixes the issue by adding missing sanity check against
b-tree root nodes so that it's called when on-memory inodes are read
from ifile, inode metadata file.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/btree.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index b2e3ff3..c645d7c 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -31,6 +31,8 @@
 #include "alloc.h"
 #include "dat.h"
 
+static void __nilfs_btree_init(struct nilfs_bmap *bmap);
+
 static struct nilfs_btree_path *nilfs_btree_alloc_path(void)
 {
 	struct nilfs_btree_path *path;
@@ -368,6 +370,34 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
 	return ret;
 }
 
+/**
+ * nilfs_btree_root_broken - verify consistency of btree root node
+ * @node: btree root node to be examined
+ * @ino: inode number
+ *
+ * Return Value: If node is broken, 1 is returned. Otherwise, 0 is returned.
+ */
+static int nilfs_btree_root_broken(const struct nilfs_btree_node *node,
+				   ino_t ino)
+{
+	int level, flags, nchildren;
+	int ret = 0;
+
+	level = nilfs_btree_node_get_level(node);
+	flags = nilfs_btree_node_get_flags(node);
+	nchildren = nilfs_btree_node_get_nchildren(node);
+
+	if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
+		     level > NILFS_BTREE_LEVEL_MAX ||
+		     nchildren < 0 ||
+		     nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX)) {
+		pr_crit("NILFS: bad btree root (inode number=%lu): level = %d, flags = 0x%x, nchildren = %d\n",
+			ino, level, flags, nchildren);
+		ret = 1;
+	}
+	return ret;
+}
+
 int nilfs_btree_broken_node_block(struct buffer_head *bh)
 {
 	int ret;
@@ -1713,7 +1743,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *btree,
 
 	/* convert and insert */
 	dat = NILFS_BMAP_USE_VBN(btree) ? nilfs_bmap_get_dat(btree) : NULL;
-	nilfs_btree_init(btree);
+	__nilfs_btree_init(btree);
 	if (nreq != NULL) {
 		nilfs_bmap_commit_alloc_ptr(btree, dreq, dat);
 		nilfs_bmap_commit_alloc_ptr(btree, nreq, dat);
@@ -2294,12 +2324,23 @@ static const struct nilfs_bmap_operations nilfs_btree_ops_gc = {
 	.bop_gather_data	=	NULL,
 };
 
-int nilfs_btree_init(struct nilfs_bmap *bmap)
+static void __nilfs_btree_init(struct nilfs_bmap *bmap)
 {
 	bmap->b_ops = &nilfs_btree_ops;
 	bmap->b_nchildren_per_block =
 		NILFS_BTREE_NODE_NCHILDREN_MAX(nilfs_btree_node_size(bmap));
-	return 0;
+}
+
+int nilfs_btree_init(struct nilfs_bmap *bmap)
+{
+	int ret = 0;
+
+	__nilfs_btree_init(bmap);
+
+	if (nilfs_btree_root_broken(nilfs_btree_get_root(bmap),
+				    bmap->b_inode->i_ino))
+		ret = -EIO;
+	return ret;
 }
 
 void nilfs_btree_init_gc(struct nilfs_bmap *bmap)
-- 
1.8.3.1
