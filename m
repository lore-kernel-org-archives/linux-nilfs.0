From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 01/23] nilfs2: add checkpoint tree to nilfs object
Date: Tue, 14 Sep 2010 00:37:02 +0900
Message-ID: <1284392244-27100-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

To hold multiple versions of a filesystem in one sb instance, a new
on-memory structure is necessary to handle one or more checkpoints.

This adds a red-black tree of checkpoints to nilfs object, and adds
lookup and create functions for them.

Each checkpoint is represented by "nilfs_root" structure, and this
structure has rb_node to configure the rb-tree.

The nilfs_root object is identified with a checkpoint number.  For
each snapshot, a nilfs_root object is allocated and the checkpoint
number of snapshot is assigned to it.  For a regular mount
(i.e. current mode mount), NILFS_CPTREE_CURRENT_CNO constant is
assigned to the corresponding nilfs_root object.

Each nilfs_root object has an ifile inode and some counters.  These
items will displace those of nilfs_sb_info structure in successive
patches.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/the_nilfs.h |   42 ++++++++++++++++++++++
 2 files changed, 134 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index ea28fa9..da4aa43 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -89,6 +89,8 @@ static struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	INIT_LIST_HEAD(&nilfs->ns_supers);
 	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
+	nilfs->ns_cptree = RB_ROOT;
+	spin_lock_init(&nilfs->ns_cptree_lock);
 	init_rwsem(&nilfs->ns_segctor_sem);
 
 	return nilfs;
@@ -809,6 +811,96 @@ int nilfs_near_disk_full(struct the_nilfs *nilfs)
 	return ncleansegs <= nilfs->ns_nrsvsegs + nincsegs;
 }
 
+struct nilfs_root *nilfs_lookup_root(struct the_nilfs *nilfs, __u64 cno)
+{
+	struct rb_node *n;
+	struct nilfs_root *root;
+
+	spin_lock(&nilfs->ns_cptree_lock);
+	n = nilfs->ns_cptree.rb_node;
+	while (n) {
+		root = rb_entry(n, struct nilfs_root, rb_node);
+
+		if (cno < root->cno) {
+			n = n->rb_left;
+		} else if (cno > root->cno) {
+			n = n->rb_right;
+		} else {
+			atomic_inc(&root->count);
+			spin_unlock(&nilfs->ns_cptree_lock);
+			return root;
+		}
+	}
+	spin_unlock(&nilfs->ns_cptree_lock);
+
+	return NULL;
+}
+
+struct nilfs_root *
+nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
+{
+	struct rb_node **p, *parent;
+	struct nilfs_root *root, *new;
+
+	root = nilfs_lookup_root(nilfs, cno);
+	if (root)
+		return root;
+
+	new = kmalloc(sizeof(*root), GFP_KERNEL);
+	if (!new)
+		return NULL;
+
+	spin_lock(&nilfs->ns_cptree_lock);
+
+	p = &nilfs->ns_cptree.rb_node;
+	parent = NULL;
+
+	while (*p) {
+		parent = *p;
+		root = rb_entry(parent, struct nilfs_root, rb_node);
+
+		if (cno < root->cno) {
+			p = &(*p)->rb_left;
+		} else if (cno > root->cno) {
+			p = &(*p)->rb_right;
+		} else {
+			atomic_inc(&root->count);
+			spin_unlock(&nilfs->ns_cptree_lock);
+			kfree(new);
+			return root;
+		}
+	}
+
+	new->cno = cno;
+	new->ifile = NULL;
+	new->nilfs = nilfs;
+	atomic_set(&new->count, 1);
+	atomic_set(&new->inodes_count, 0);
+	atomic_set(&new->blocks_count, 0);
+
+	rb_link_node(&new->rb_node, parent, p);
+	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
+
+	spin_unlock(&nilfs->ns_cptree_lock);
+
+	return new;
+}
+
+void nilfs_put_root(struct nilfs_root *root)
+{
+	if (atomic_dec_and_test(&root->count)) {
+		struct the_nilfs *nilfs = root->nilfs;
+
+		spin_lock(&nilfs->ns_cptree_lock);
+		rb_erase(&root->rb_node, &nilfs->ns_cptree);
+		spin_unlock(&nilfs->ns_cptree_lock);
+		if (root->ifile)
+			nilfs_mdt_destroy(root->ifile);
+
+		kfree(root);
+	}
+}
+
 /**
  * nilfs_find_sbinfo - find existing nilfs_sb_info structure
  * @nilfs: nilfs object
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index c7ecd0c..0afede6 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -26,6 +26,7 @@
 
 #include <linux/types.h>
 #include <linux/buffer_head.h>
+#include <linux/rbtree.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
@@ -80,6 +81,8 @@ enum {
  * @ns_cpfile: checkpoint file inode
  * @ns_sufile: segusage file inode
  * @ns_gc_dat: shadow inode of the DAT file inode for GC
+ * @ns_cptree: rb-tree of all mounted checkpoints (nilfs_root)
+ * @ns_cptree_lock: lock protecting @ns_cptree
  * @ns_gc_inodes: dummy inodes to keep live blocks
  * @ns_blocksize_bits: bit length of block size
  * @ns_blocksize: block size
@@ -164,6 +167,10 @@ struct the_nilfs {
 	struct inode	       *ns_sufile;
 	struct inode	       *ns_gc_dat;
 
+	/* Checkpoint tree */
+	struct rb_root		ns_cptree;
+	spinlock_t		ns_cptree_lock;
+
 	/* GC inode list */
 	struct list_head	ns_gc_inodes;
 
@@ -200,6 +207,32 @@ THE_NILFS_FNS(DISCONTINUED, discontinued)
 THE_NILFS_FNS(GC_RUNNING, gc_running)
 THE_NILFS_FNS(SB_DIRTY, sb_dirty)
 
+/**
+ * struct nilfs_root - nilfs root object
+ * @cno: checkpoint number
+ * @rb_node: red-black tree node
+ * @count: refcount of this structure
+ * @nilfs: nilfs object
+ * @ifile: inode file
+ * @root: root inode
+ * @inodes_count: number of inodes
+ * @blocks_count: number of blocks (Reserved)
+ */
+struct nilfs_root {
+	__u64 cno;
+	struct rb_node rb_node;
+
+	atomic_t count;
+	struct the_nilfs *nilfs;
+	struct inode *ifile;
+
+	atomic_t inodes_count;
+	atomic_t blocks_count;
+};
+
+/* Special checkpoint number */
+#define NILFS_CPTREE_CURRENT_CNO	0
+
 /* Minimum interval of periodical update of superblocks (in seconds) */
 #define NILFS_SB_FREQ		10
 
@@ -222,6 +255,10 @@ int init_nilfs(struct the_nilfs *, struct nilfs_sb_info *, char *);
 int load_nilfs(struct the_nilfs *, struct nilfs_sb_info *);
 int nilfs_discard_segments(struct the_nilfs *, __u64 *, size_t);
 int nilfs_count_free_blocks(struct the_nilfs *, sector_t *);
+struct nilfs_root *nilfs_lookup_root(struct the_nilfs *nilfs, __u64 cno);
+struct nilfs_root *nilfs_find_or_create_root(struct the_nilfs *nilfs,
+					     __u64 cno);
+void nilfs_put_root(struct nilfs_root *root);
 struct nilfs_sb_info *nilfs_find_sbinfo(struct the_nilfs *, int, __u64);
 int nilfs_checkpoint_is_mounted(struct the_nilfs *, __u64, int);
 int nilfs_near_disk_full(struct the_nilfs *);
@@ -235,6 +272,11 @@ static inline void get_nilfs(struct the_nilfs *nilfs)
 	atomic_inc(&nilfs->ns_count);
 }
 
+static inline void nilfs_get_root(struct nilfs_root *root)
+{
+	atomic_inc(&root->count);
+}
+
 static inline void
 nilfs_attach_writer(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 {
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
