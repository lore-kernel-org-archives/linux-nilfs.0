From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 6/6] nilfs2: remove own inode hash used for GC
Date: Sun, 22 Aug 2010 19:05:06 +0900
Message-ID: <1282471506-29618-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282471506-29618-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This uses inode hash function that vfs provides instead of the own
hash table for caching gc inodes.  This finally removes the own inode
hash from nilfs.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/gcinode.c   |  140 +++++++++----------------------------------------
 fs/nilfs2/inode.c     |   22 ++++++++
 fs/nilfs2/ioctl.c     |   17 ++++---
 fs/nilfs2/nilfs.h     |    9 ++--
 fs/nilfs2/segment.c   |    3 +-
 fs/nilfs2/the_nilfs.c |    8 +---
 fs/nilfs2/the_nilfs.h |    7 +--
 7 files changed, 64 insertions(+), 142 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index cd19a37..34f8f84 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -28,13 +28,6 @@
  * gcinodes), and this file provides lookup function of the dummy
  * inodes and their buffer read function.
  *
- * Since NILFS2 keeps up multiple checkpoints/snapshots across GC, it
- * has to treat blocks that belong to a same file but have different
- * checkpoint numbers.  To avoid interference among generations, dummy
- * inodes are managed separately from actual inodes, and their lookup
- * function (nilfs_gc_iget) is designed to be specified with a
- * checkpoint number argument as well as an inode number.
- *
  * Buffers and pages held by the dummy inodes will be released each
  * time after they are copied to a new log.  Dirty blocks made on the
  * current generation and the blocks to be moved by GC never overlap
@@ -180,124 +173,41 @@ int nilfs_gccache_wait_and_mark_dirty(struct buffer_head *bh)
 	return 0;
 }
 
-/*
- * nilfs_init_gccache() - allocate and initialize gc_inode hash table
- * @nilfs - the_nilfs
- *
- * Return Value: On success, 0.
- * On error, a negative error code is returned.
- */
-int nilfs_init_gccache(struct the_nilfs *nilfs)
-{
-	int loop;
-
-	BUG_ON(nilfs->ns_gc_inodes_h);
-
-	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
-
-	nilfs->ns_gc_inodes_h =
-		kmalloc(sizeof(struct hlist_head) * NILFS_GCINODE_HASH_SIZE,
-			GFP_NOFS);
-	if (nilfs->ns_gc_inodes_h == NULL)
-		return -ENOMEM;
-
-	for (loop = 0; loop < NILFS_GCINODE_HASH_SIZE; loop++)
-		INIT_HLIST_HEAD(&nilfs->ns_gc_inodes_h[loop]);
-	return 0;
-}
-
-/*
- * nilfs_destroy_gccache() - free gc_inode hash table
- * @nilfs - the nilfs
- */
-void nilfs_destroy_gccache(struct the_nilfs *nilfs)
+int nilfs_init_gcinode(struct inode *inode)
 {
-	if (nilfs->ns_gc_inodes_h) {
-		nilfs_remove_all_gcinode(nilfs);
-		kfree(nilfs->ns_gc_inodes_h);
-		nilfs->ns_gc_inodes_h = NULL;
-	}
-}
-
-static struct inode *alloc_gcinode(struct the_nilfs *nilfs, ino_t ino,
-				   __u64 cno)
-{
-	struct inode *inode;
-	struct nilfs_inode_info *ii;
-
-	inode = nilfs_mdt_new_common(nilfs, NULL, ino);
-	if (!inode)
-		return NULL;
-
-	if (nilfs_mdt_init(inode, nilfs, GFP_NOFS, 0) < 0) {
-		nilfs_destroy_inode(inode);
-		return NULL;
-	}
-	inode->i_op = NULL;
-	inode->i_fop = NULL;
-	inode->i_mapping->a_ops = &def_gcinode_aops;
-
-	ii = NILFS_I(inode);
-	ii->i_cno = cno;
-	ii->i_flags = 0;
-	ii->i_state = 1 << NILFS_I_GCINODE;
-	ii->i_bh = NULL;
-	nilfs_bmap_init_gc(ii->i_bmap);
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	int ret;
 
-	return inode;
-}
+	ret = nilfs_mdt_init(inode, nilfs, GFP_NOFS, 0);
+	if (!ret) {
+		inode->i_mapping->a_ops = &def_gcinode_aops;
 
-static unsigned long ihash(ino_t ino, __u64 cno)
-{
-	return hash_long((unsigned long)((ino << 2) + cno),
-			 NILFS_GCINODE_HASH_BITS);
-}
+		ii->i_flags = 0;
+		nilfs_bmap_init_gc(ii->i_bmap);
 
-/*
- * nilfs_gc_iget() - find or create gc inode with specified (ino,cno)
- */
-struct inode *nilfs_gc_iget(struct the_nilfs *nilfs, ino_t ino, __u64 cno)
-{
-	struct hlist_head *head = nilfs->ns_gc_inodes_h + ihash(ino, cno);
-	struct hlist_node *node;
-	struct inode *inode;
-
-	hlist_for_each_entry(inode, node, head, i_hash) {
-		if (inode->i_ino == ino && NILFS_I(inode)->i_cno == cno)
-			return inode;
-	}
-
-	inode = alloc_gcinode(nilfs, ino, cno);
-	if (likely(inode)) {
-		hlist_add_head(&inode->i_hash, head);
+		/*
+		 * Add the inode to GC inode list. Garbage Collection
+		 * is serialized and no two processes manipulate the
+		 * list simultaneously.
+		 */
+		igrab(inode);
 		list_add(&NILFS_I(inode)->i_dirty, &nilfs->ns_gc_inodes);
 	}
-	return inode;
-}
-
-/*
- * nilfs_clear_gcinode() - clear and free a gc inode
- */
-void nilfs_clear_gcinode(struct inode *inode)
-{
-	nilfs_mdt_destroy(inode);
+	return ret;
 }
 
-/*
- * nilfs_remove_all_gcinode() - remove all inodes from the_nilfs
+/**
+ * nilfs_remove_all_gcinodes() - remove all unprocessed gc inodes
  */
-void nilfs_remove_all_gcinode(struct the_nilfs *nilfs)
+void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs)
 {
-	struct hlist_head *head = nilfs->ns_gc_inodes_h;
-	struct hlist_node *node, *n;
-	struct inode *inode;
-	int loop;
+	struct list_head *head = &nilfs->ns_gc_inodes;
+	struct nilfs_inode_info *ii;
 
-	for (loop = 0; loop < NILFS_GCINODE_HASH_SIZE; loop++, head++) {
-		hlist_for_each_entry_safe(inode, node, n, head, i_hash) {
-			hlist_del_init(&inode->i_hash);
-			list_del_init(&NILFS_I(inode)->i_dirty);
-			nilfs_clear_gcinode(inode); /* might sleep */
-		}
+	while (!list_empty(head)) {
+		ii = list_first_entry(head, struct nilfs_inode_info, i_dirty);
+		list_del_init(&ii->i_dirty);
+		iput(&ii->vfs_inode);
 	}
 }
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6e9df85..82cfdbc 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -527,6 +527,28 @@ struct inode *nilfs_iget(struct super_block *sb, unsigned long ino)
 	return inode;
 }
 
+struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
+				__u64 cno)
+{
+	struct nilfs_iget_args args = { .ino = ino, .cno = cno, .for_gc = 1 };
+	struct inode *inode;
+	int err;
+
+	inode = iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
+	if (unlikely(!inode))
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	err = nilfs_init_gcinode(inode);
+	if (unlikely(err)) {
+		iget_failed(inode);
+		return ERR_PTR(err);
+	}
+	unlock_new_inode(inode);
+	return inode;
+}
+
 void nilfs_write_inode_common(struct inode *inode,
 			      struct nilfs_inode *raw_inode, int has_bmap)
 {
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index f90a33d..f0a99bd 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -334,7 +334,7 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
 	return 0;
 }
 
-static int nilfs_ioctl_move_blocks(struct the_nilfs *nilfs,
+static int nilfs_ioctl_move_blocks(struct super_block *sb,
 				   struct nilfs_argv *argv, void *buf)
 {
 	size_t nmembs = argv->v_nmembs;
@@ -349,7 +349,7 @@ static int nilfs_ioctl_move_blocks(struct the_nilfs *nilfs,
 	for (i = 0, vdesc = buf; i < nmembs; ) {
 		ino = vdesc->vd_ino;
 		cno = vdesc->vd_cno;
-		inode = nilfs_gc_iget(nilfs, ino, cno);
+		inode = nilfs_iget_for_gc(sb, ino, cno);
 		if (unlikely(inode == NULL)) {
 			ret = -ENOMEM;
 			goto failed;
@@ -357,11 +357,15 @@ static int nilfs_ioctl_move_blocks(struct the_nilfs *nilfs,
 		do {
 			ret = nilfs_ioctl_move_inode_block(inode, vdesc,
 							   &buffers);
-			if (unlikely(ret < 0))
+			if (unlikely(ret < 0)) {
+				iput(inode);
 				goto failed;
+			}
 			vdesc++;
 		} while (++i < nmembs &&
 			 vdesc->vd_ino == ino && vdesc->vd_cno == cno);
+
+		iput(inode); /* The inode still remains in GC inode list */
 	}
 
 	list_for_each_entry_safe(bh, n, &buffers, b_assoc_buffers) {
@@ -567,7 +571,7 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	}
 
 	/*
-	 * nilfs_ioctl_move_blocks() will call nilfs_gc_iget(),
+	 * nilfs_ioctl_move_blocks() will call nilfs_iget_for_gc(),
 	 * which will operates an inode list without blocking.
 	 * To protect the list from concurrent operations,
 	 * nilfs_ioctl_move_blocks should be atomic operation.
@@ -577,15 +581,14 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 		goto out_free;
 	}
 
-	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], kbufs[0]);
+	ret = nilfs_ioctl_move_blocks(inode->i_sb, &argv[0], kbufs[0]);
 	if (ret < 0)
 		printk(KERN_ERR "NILFS: GC failed during preparation: "
 			"cannot read source blocks: err=%d\n", ret);
 	else
 		ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
 
-	if (ret < 0)
-		nilfs_remove_all_gcinode(nilfs);
+	nilfs_remove_all_gcinodes(nilfs);
 	clear_nilfs_gc_running(nilfs);
 
 out_free:
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index d3d5404..797cd43 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -248,6 +248,8 @@ extern void nilfs_set_inode_flags(struct inode *);
 extern int nilfs_read_inode_common(struct inode *, struct nilfs_inode *);
 extern void nilfs_write_inode_common(struct inode *, struct nilfs_inode *, int);
 extern struct inode *nilfs_iget(struct super_block *, unsigned long);
+extern struct inode *nilfs_iget_for_gc(struct super_block *sb,
+				       unsigned long ino, __u64 cno);
 extern void nilfs_update_inode(struct inode *, struct buffer_head *);
 extern void nilfs_truncate(struct inode *);
 extern void nilfs_evict_inode(struct inode *);
@@ -292,11 +294,8 @@ int nilfs_gccache_submit_read_data(struct inode *, sector_t, sector_t, __u64,
 int nilfs_gccache_submit_read_node(struct inode *, sector_t, __u64,
 				   struct buffer_head **);
 int nilfs_gccache_wait_and_mark_dirty(struct buffer_head *);
-int nilfs_init_gccache(struct the_nilfs *);
-void nilfs_destroy_gccache(struct the_nilfs *);
-void nilfs_clear_gcinode(struct inode *);
-struct inode *nilfs_gc_iget(struct the_nilfs *, ino_t, __u64);
-void nilfs_remove_all_gcinode(struct the_nilfs *);
+int nilfs_init_gcinode(struct inode *inode);
+void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs);
 
 /* gcdat.c */
 int nilfs_init_gcdat_inode(struct the_nilfs *);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index eee4b22..9cf7138 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2451,9 +2451,8 @@ nilfs_remove_written_gcinodes(struct the_nilfs *nilfs, struct list_head *head)
 	list_for_each_entry_safe(ii, n, head, i_dirty) {
 		if (!test_bit(NILFS_I_UPDATED, &ii->i_state))
 			continue;
-		hlist_del_init(&ii->vfs_inode.i_hash);
 		list_del_init(&ii->i_dirty);
-		nilfs_clear_gcinode(&ii->vfs_inode);
+		iput(&ii->vfs_inode);
 	}
 }
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 6af1c00..fa33ad1 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -87,8 +87,8 @@ static struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	init_rwsem(&nilfs->ns_writer_sem);
 	INIT_LIST_HEAD(&nilfs->ns_list);
 	INIT_LIST_HEAD(&nilfs->ns_supers);
+	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
-	nilfs->ns_gc_inodes_h = NULL;
 	init_rwsem(&nilfs->ns_segctor_sem);
 
 	return nilfs;
@@ -164,7 +164,6 @@ void put_nilfs(struct the_nilfs *nilfs)
 		nilfs_mdt_destroy(nilfs->ns_gc_dat);
 	}
 	if (nilfs_init(nilfs)) {
-		nilfs_destroy_gccache(nilfs);
 		brelse(nilfs->ns_sbh[0]);
 		brelse(nilfs->ns_sbh[1]);
 	}
@@ -735,11 +734,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 	if (err)
 		goto failed_sbh;
 
-	/* Initialize gcinode cache */
-	err = nilfs_init_gccache(nilfs);
-	if (err)
-		goto failed_sbh;
-
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index f785a7b..c7ecd0c 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -81,7 +81,6 @@ enum {
  * @ns_sufile: segusage file inode
  * @ns_gc_dat: shadow inode of the DAT file inode for GC
  * @ns_gc_inodes: dummy inodes to keep live blocks
- * @ns_gc_inodes_h: hash list to keep dummy inode holding live blocks
  * @ns_blocksize_bits: bit length of block size
  * @ns_blocksize: block size
  * @ns_nsegments: number of segments in filesystem
@@ -165,9 +164,8 @@ struct the_nilfs {
 	struct inode	       *ns_sufile;
 	struct inode	       *ns_gc_dat;
 
-	/* GC inode list and hash table head */
+	/* GC inode list */
 	struct list_head	ns_gc_inodes;
-	struct hlist_head      *ns_gc_inodes_h;
 
 	/* Disk layout information (static) */
 	unsigned int		ns_blocksize_bits;
@@ -182,9 +180,6 @@ struct the_nilfs {
 	u32			ns_crc_seed;
 };
 
-#define NILFS_GCINODE_HASH_BITS		8
-#define NILFS_GCINODE_HASH_SIZE		(1<<NILFS_GCINODE_HASH_BITS)
-
 #define THE_NILFS_FNS(bit, name)					\
 static inline void set_nilfs_##name(struct the_nilfs *nilfs)		\
 {									\
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
