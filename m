From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/5] nilfs2: use mark_buffer_dirty to mark btnode or meta data dirty
Date: Thu,  5 May 2011 13:13:53 +0900
Message-ID: <1304568833-31021-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1304568833-31021-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304568833-31021-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This replaces nilfs_mdt_mark_buffer_dirty and nilfs_btnode_mark_dirty
macros with mark_buffer_dirty and gets rid of nilfs_mark_buffer_dirty,
an own mark buffer dirty function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c   |   12 ++++++------
 fs/nilfs2/btnode.c  |    4 ++--
 fs/nilfs2/btnode.h  |    3 ---
 fs/nilfs2/btree.c   |   38 +++++++++++++++++++-------------------
 fs/nilfs2/cpfile.c  |   24 ++++++++++++------------
 fs/nilfs2/dat.c     |    4 ++--
 fs/nilfs2/gcinode.c |   12 ++++--------
 fs/nilfs2/ifile.c   |    4 ++--
 fs/nilfs2/inode.c   |    2 +-
 fs/nilfs2/mdt.c     |    4 ++--
 fs/nilfs2/mdt.h     |    2 --
 fs/nilfs2/page.c    |   13 -------------
 fs/nilfs2/page.h    |    1 -
 fs/nilfs2/segment.c |    4 ++--
 fs/nilfs2/sufile.c  |   22 +++++++++++-----------
 15 files changed, 63 insertions(+), 86 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 0a0a66d..7392d8a 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -489,8 +489,8 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 void nilfs_palloc_commit_alloc_entry(struct inode *inode,
 				     struct nilfs_palloc_req *req)
 {
-	nilfs_mdt_mark_buffer_dirty(req->pr_bitmap_bh);
-	nilfs_mdt_mark_buffer_dirty(req->pr_desc_bh);
+	mark_buffer_dirty(req->pr_bitmap_bh);
+	mark_buffer_dirty(req->pr_desc_bh);
 	nilfs_mdt_mark_dirty(inode);
 
 	brelse(req->pr_bitmap_bh);
@@ -527,8 +527,8 @@ void nilfs_palloc_commit_free_entry(struct inode *inode,
 	kunmap(req->pr_bitmap_bh->b_page);
 	kunmap(req->pr_desc_bh->b_page);
 
-	nilfs_mdt_mark_buffer_dirty(req->pr_desc_bh);
-	nilfs_mdt_mark_buffer_dirty(req->pr_bitmap_bh);
+	mark_buffer_dirty(req->pr_desc_bh);
+	mark_buffer_dirty(req->pr_bitmap_bh);
 	nilfs_mdt_mark_dirty(inode);
 
 	brelse(req->pr_bitmap_bh);
@@ -683,8 +683,8 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 		kunmap(bitmap_bh->b_page);
 		kunmap(desc_bh->b_page);
 
-		nilfs_mdt_mark_buffer_dirty(desc_bh);
-		nilfs_mdt_mark_buffer_dirty(bitmap_bh);
+		mark_buffer_dirty(desc_bh);
+		mark_buffer_dirty(bitmap_bh);
 		nilfs_mdt_mark_dirty(inode);
 
 		brelse(bitmap_bh);
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index c353e4f..a35ae35 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -254,7 +254,7 @@ void nilfs_btnode_commit_change_key(struct address_space *btnc,
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
-		nilfs_btnode_mark_dirty(obh);
+		mark_buffer_dirty(obh);
 
 		spin_lock_irq(&btnc->tree_lock);
 		radix_tree_delete(&btnc->page_tree, oldkey);
@@ -266,7 +266,7 @@ void nilfs_btnode_commit_change_key(struct address_space *btnc,
 		unlock_page(opage);
 	} else {
 		nilfs_copy_buffer(nbh, obh);
-		nilfs_btnode_mark_dirty(nbh);
+		mark_buffer_dirty(nbh);
 
 		nbh->b_blocknr = newkey;
 		ctxt->bh = nbh;
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 7de449c..3a4dd2d 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -50,7 +50,4 @@ void nilfs_btnode_commit_change_key(struct address_space *,
 void nilfs_btnode_abort_change_key(struct address_space *,
 				   struct nilfs_btnode_chkey_ctxt *);
 
-#define nilfs_btnode_mark_dirty(bh)	nilfs_mark_buffer_dirty(bh)
-
-
 #endif	/* _NILFS_BTNODE_H */
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index d451ae0..7eafe46 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -714,7 +714,7 @@ static void nilfs_btree_promote_key(struct nilfs_bmap *btree,
 				nilfs_btree_get_nonroot_node(path, level),
 				path[level].bp_index, key);
 			if (!buffer_dirty(path[level].bp_bh))
-				nilfs_btnode_mark_dirty(path[level].bp_bh);
+				mark_buffer_dirty(path[level].bp_bh);
 		} while ((path[level].bp_index == 0) &&
 			 (++level < nilfs_btree_height(btree) - 1));
 	}
@@ -739,7 +739,7 @@ static void nilfs_btree_do_insert(struct nilfs_bmap *btree,
 		nilfs_btree_node_insert(node, path[level].bp_index,
 					*keyp, *ptrp, ncblk);
 		if (!buffer_dirty(path[level].bp_bh))
-			nilfs_btnode_mark_dirty(path[level].bp_bh);
+			mark_buffer_dirty(path[level].bp_bh);
 
 		if (path[level].bp_index == 0)
 			nilfs_btree_promote_key(btree, path, level + 1,
@@ -777,9 +777,9 @@ static void nilfs_btree_carry_left(struct nilfs_bmap *btree,
 	nilfs_btree_node_move_left(left, node, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_bh);
+		mark_buffer_dirty(path[level].bp_bh);
 	if (!buffer_dirty(path[level].bp_sib_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+		mark_buffer_dirty(path[level].bp_sib_bh);
 
 	nilfs_btree_promote_key(btree, path, level + 1,
 				nilfs_btree_node_get_key(node, 0));
@@ -823,9 +823,9 @@ static void nilfs_btree_carry_right(struct nilfs_bmap *btree,
 	nilfs_btree_node_move_right(node, right, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_bh);
+		mark_buffer_dirty(path[level].bp_bh);
 	if (!buffer_dirty(path[level].bp_sib_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+		mark_buffer_dirty(path[level].bp_sib_bh);
 
 	path[level + 1].bp_index++;
 	nilfs_btree_promote_key(btree, path, level + 1,
@@ -870,9 +870,9 @@ static void nilfs_btree_split(struct nilfs_bmap *btree,
 	nilfs_btree_node_move_right(node, right, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_bh);
+		mark_buffer_dirty(path[level].bp_bh);
 	if (!buffer_dirty(path[level].bp_sib_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+		mark_buffer_dirty(path[level].bp_sib_bh);
 
 	newkey = nilfs_btree_node_get_key(right, 0);
 	newptr = path[level].bp_newreq.bpr_ptr;
@@ -919,7 +919,7 @@ static void nilfs_btree_grow(struct nilfs_bmap *btree,
 	nilfs_btree_node_set_level(root, level + 1);
 
 	if (!buffer_dirty(path[level].bp_sib_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+		mark_buffer_dirty(path[level].bp_sib_bh);
 
 	path[level].bp_bh = path[level].bp_sib_bh;
 	path[level].bp_sib_bh = NULL;
@@ -1194,7 +1194,7 @@ static void nilfs_btree_do_delete(struct nilfs_bmap *btree,
 		nilfs_btree_node_delete(node, path[level].bp_index,
 					keyp, ptrp, ncblk);
 		if (!buffer_dirty(path[level].bp_bh))
-			nilfs_btnode_mark_dirty(path[level].bp_bh);
+			mark_buffer_dirty(path[level].bp_bh);
 		if (path[level].bp_index == 0)
 			nilfs_btree_promote_key(btree, path, level + 1,
 				nilfs_btree_node_get_key(node, 0));
@@ -1226,9 +1226,9 @@ static void nilfs_btree_borrow_left(struct nilfs_bmap *btree,
 	nilfs_btree_node_move_right(left, node, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_bh);
+		mark_buffer_dirty(path[level].bp_bh);
 	if (!buffer_dirty(path[level].bp_sib_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+		mark_buffer_dirty(path[level].bp_sib_bh);
 
 	nilfs_btree_promote_key(btree, path, level + 1,
 				nilfs_btree_node_get_key(node, 0));
@@ -1258,9 +1258,9 @@ static void nilfs_btree_borrow_right(struct nilfs_bmap *btree,
 	nilfs_btree_node_move_left(node, right, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_bh);
+		mark_buffer_dirty(path[level].bp_bh);
 	if (!buffer_dirty(path[level].bp_sib_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+		mark_buffer_dirty(path[level].bp_sib_bh);
 
 	path[level + 1].bp_index++;
 	nilfs_btree_promote_key(btree, path, level + 1,
@@ -1289,7 +1289,7 @@ static void nilfs_btree_concat_left(struct nilfs_bmap *btree,
 	nilfs_btree_node_move_left(left, node, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_sib_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+		mark_buffer_dirty(path[level].bp_sib_bh);
 
 	nilfs_btnode_delete(path[level].bp_bh);
 	path[level].bp_bh = path[level].bp_sib_bh;
@@ -1315,7 +1315,7 @@ static void nilfs_btree_concat_right(struct nilfs_bmap *btree,
 	nilfs_btree_node_move_left(node, right, n, ncblk, ncblk);
 
 	if (!buffer_dirty(path[level].bp_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_bh);
+		mark_buffer_dirty(path[level].bp_bh);
 
 	nilfs_btnode_delete(path[level].bp_sib_bh);
 	path[level].bp_sib_bh = NULL;
@@ -1709,7 +1709,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *btree,
 		nilfs_btree_node_init(node, 0, 1, n, ncblk, keys, ptrs);
 		nilfs_btree_node_insert(node, n, key, dreq->bpr_ptr, ncblk);
 		if (!buffer_dirty(bh))
-			nilfs_btnode_mark_dirty(bh);
+			mark_buffer_dirty(bh);
 		if (!nilfs_bmap_dirty(btree))
 			nilfs_bmap_set_dirty(btree);
 
@@ -1787,7 +1787,7 @@ static int nilfs_btree_propagate_p(struct nilfs_bmap *btree,
 {
 	while ((++level < nilfs_btree_height(btree) - 1) &&
 	       !buffer_dirty(path[level].bp_bh))
-		nilfs_btnode_mark_dirty(path[level].bp_bh);
+		mark_buffer_dirty(path[level].bp_bh);
 
 	return 0;
 }
@@ -2229,7 +2229,7 @@ static int nilfs_btree_mark(struct nilfs_bmap *btree, __u64 key, int level)
 	}
 
 	if (!buffer_dirty(bh))
-		nilfs_btnode_mark_dirty(bh);
+		mark_buffer_dirty(bh);
 	brelse(bh);
 	if (!nilfs_bmap_dirty(btree))
 		nilfs_bmap_set_dirty(btree);
diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 5ff15a8..c9b342c 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -216,14 +216,14 @@ int nilfs_cpfile_get_checkpoint(struct inode *cpfile,
 		if (!nilfs_cpfile_is_in_first(cpfile, cno))
 			nilfs_cpfile_block_add_valid_checkpoints(cpfile, cp_bh,
 								 kaddr, 1);
-		nilfs_mdt_mark_buffer_dirty(cp_bh);
+		mark_buffer_dirty(cp_bh);
 
 		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
 		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
 						       kaddr);
 		le64_add_cpu(&header->ch_ncheckpoints, 1);
 		kunmap_atomic(kaddr, KM_USER0);
-		nilfs_mdt_mark_buffer_dirty(header_bh);
+		mark_buffer_dirty(header_bh);
 		nilfs_mdt_mark_dirty(cpfile);
 	}
 
@@ -326,7 +326,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 		}
 		if (nicps > 0) {
 			tnicps += nicps;
-			nilfs_mdt_mark_buffer_dirty(cp_bh);
+			mark_buffer_dirty(cp_bh);
 			nilfs_mdt_mark_dirty(cpfile);
 			if (!nilfs_cpfile_is_in_first(cpfile, cno)) {
 				count =
@@ -358,7 +358,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
 						       kaddr);
 		le64_add_cpu(&header->ch_ncheckpoints, -(u64)tnicps);
-		nilfs_mdt_mark_buffer_dirty(header_bh);
+		mark_buffer_dirty(header_bh);
 		nilfs_mdt_mark_dirty(cpfile);
 		kunmap_atomic(kaddr, KM_USER0);
 	}
@@ -671,10 +671,10 @@ static int nilfs_cpfile_set_snapshot(struct inode *cpfile, __u64 cno)
 	le64_add_cpu(&header->ch_nsnapshots, 1);
 	kunmap_atomic(kaddr, KM_USER0);
 
-	nilfs_mdt_mark_buffer_dirty(prev_bh);
-	nilfs_mdt_mark_buffer_dirty(curr_bh);
-	nilfs_mdt_mark_buffer_dirty(cp_bh);
-	nilfs_mdt_mark_buffer_dirty(header_bh);
+	mark_buffer_dirty(prev_bh);
+	mark_buffer_dirty(curr_bh);
+	mark_buffer_dirty(cp_bh);
+	mark_buffer_dirty(header_bh);
 	nilfs_mdt_mark_dirty(cpfile);
 
 	brelse(prev_bh);
@@ -774,10 +774,10 @@ static int nilfs_cpfile_clear_snapshot(struct inode *cpfile, __u64 cno)
 	le64_add_cpu(&header->ch_nsnapshots, -1);
 	kunmap_atomic(kaddr, KM_USER0);
 
-	nilfs_mdt_mark_buffer_dirty(next_bh);
-	nilfs_mdt_mark_buffer_dirty(prev_bh);
-	nilfs_mdt_mark_buffer_dirty(cp_bh);
-	nilfs_mdt_mark_buffer_dirty(header_bh);
+	mark_buffer_dirty(next_bh);
+	mark_buffer_dirty(prev_bh);
+	mark_buffer_dirty(cp_bh);
+	mark_buffer_dirty(header_bh);
 	nilfs_mdt_mark_dirty(cpfile);
 
 	brelse(prev_bh);
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 59e5fe7..fcc2f86 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -54,7 +54,7 @@ static int nilfs_dat_prepare_entry(struct inode *dat,
 static void nilfs_dat_commit_entry(struct inode *dat,
 				   struct nilfs_palloc_req *req)
 {
-	nilfs_mdt_mark_buffer_dirty(req->pr_entry_bh);
+	mark_buffer_dirty(req->pr_entry_bh);
 	nilfs_mdt_mark_dirty(dat);
 	brelse(req->pr_entry_bh);
 }
@@ -361,7 +361,7 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
 	entry->de_blocknr = cpu_to_le64(blocknr);
 	kunmap_atomic(kaddr, KM_USER0);
 
-	nilfs_mdt_mark_buffer_dirty(entry_bh);
+	mark_buffer_dirty(entry_bh);
 	nilfs_mdt_mark_dirty(dat);
 
 	brelse(entry_bh);
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 6e79ac0..08a07a2 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -157,15 +157,11 @@ int nilfs_gccache_wait_and_mark_dirty(struct buffer_head *bh)
 	if (buffer_dirty(bh))
 		return -EEXIST;
 
-	if (buffer_nilfs_node(bh)) {
-		if (nilfs_btree_broken_node_block(bh)) {
-			clear_buffer_uptodate(bh);
-			return -EIO;
-		}
-		nilfs_btnode_mark_dirty(bh);
-	} else {
-		nilfs_mark_buffer_dirty(bh);
+	if (buffer_nilfs_node(bh) && nilfs_btree_broken_node_block(bh)) {
+		clear_buffer_uptodate(bh);
+		return -EIO;
 	}
+	mark_buffer_dirty(bh);
 	return 0;
 }
 
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index bfc73d3..684d763 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -80,7 +80,7 @@ int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
 		return ret;
 	}
 	nilfs_palloc_commit_alloc_entry(ifile, &req);
-	nilfs_mdt_mark_buffer_dirty(req.pr_entry_bh);
+	mark_buffer_dirty(req.pr_entry_bh);
 	nilfs_mdt_mark_dirty(ifile);
 	*out_ino = (ino_t)req.pr_entry_nr;
 	*out_bh = req.pr_entry_bh;
@@ -128,7 +128,7 @@ int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
 	raw_inode->i_flags = 0;
 	kunmap_atomic(kaddr, KM_USER0);
 
-	nilfs_mdt_mark_buffer_dirty(req.pr_entry_bh);
+	mark_buffer_dirty(req.pr_entry_bh);
 	brelse(req.pr_entry_bh);
 
 	nilfs_palloc_commit_free_entry(ifile, &req);
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 34ded2c..587f184 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -901,7 +901,7 @@ int nilfs_mark_inode_dirty(struct inode *inode)
 		return err;
 	}
 	nilfs_update_inode(inode, ibh);
-	nilfs_mdt_mark_buffer_dirty(ibh);
+	mark_buffer_dirty(ibh);
 	nilfs_mdt_mark_dirty(NILFS_I(inode)->i_root->ifile);
 	brelse(ibh);
 	return 0;
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 6790ca6..800e8d7 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -66,7 +66,7 @@ nilfs_mdt_insert_new_block(struct inode *inode, unsigned long block,
 	kunmap_atomic(kaddr, KM_USER0);
 
 	set_buffer_uptodate(bh);
-	nilfs_mark_buffer_dirty(bh);
+	mark_buffer_dirty(bh);
 	nilfs_mdt_mark_dirty(inode);
 	return 0;
 }
@@ -355,7 +355,7 @@ int nilfs_mdt_mark_block_dirty(struct inode *inode, unsigned long block)
 	err = nilfs_mdt_read_block(inode, block, 0, &bh);
 	if (unlikely(err))
 		return err;
-	nilfs_mark_buffer_dirty(bh);
+	mark_buffer_dirty(bh);
 	nilfs_mdt_mark_dirty(inode);
 	brelse(bh);
 	return 0;
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index baea036..ab20a4b 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -88,8 +88,6 @@ int nilfs_mdt_freeze_buffer(struct inode *inode, struct buffer_head *bh);
 struct buffer_head *nilfs_mdt_get_frozen_buffer(struct inode *inode,
 						struct buffer_head *bh);
 
-#define nilfs_mdt_mark_buffer_dirty(bh)	nilfs_mark_buffer_dirty(bh)
-
 static inline void nilfs_mdt_mark_dirty(struct inode *inode)
 {
 	if (!test_bit(NILFS_I_DIRTY, &NILFS_I(inode)->i_state))
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 3f18f5c..65221a0 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -58,19 +58,6 @@ __nilfs_get_page_block(struct page *page, unsigned long block, pgoff_t index,
 	return bh;
 }
 
-/*
- * Since the page cache of B-tree node pages or data page cache of pseudo
- * inodes does not have a valid mapping->host pointer, calling
- * mark_buffer_dirty() for their buffers causes a NULL pointer dereference;
- * it calls __mark_inode_dirty(NULL) through __set_page_dirty().
- * To avoid this problem, the old style mark_buffer_dirty() is used instead.
- */
-void nilfs_mark_buffer_dirty(struct buffer_head *bh)
-{
-	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
-		__set_page_dirty_nobuffers(bh->b_page);
-}
-
 struct buffer_head *nilfs_grab_buffer(struct inode *inode,
 				      struct address_space *mapping,
 				      unsigned long blkoff,
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index e301e56..fb7de71 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -44,7 +44,6 @@ BUFFER_FNS(NILFS_Checked, nilfs_checked)	/* buffer is verified */
 BUFFER_FNS(NILFS_Redirected, nilfs_redirected)	/* redirected to a copy */
 
 
-void nilfs_mark_buffer_dirty(struct buffer_head *bh);
 int __nilfs_clear_page_dirty(struct page *);
 
 struct buffer_head *nilfs_grab_buffer(struct inode *, struct address_space *,
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index eeb1bc2..141646e 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -806,7 +806,7 @@ static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
 		/* The following code is duplicated with cpfile.  But, it is
 		   needed to collect the checkpoint even if it was not newly
 		   created */
-		nilfs_mdt_mark_buffer_dirty(bh_cp);
+		mark_buffer_dirty(bh_cp);
 		nilfs_mdt_mark_dirty(nilfs->ns_cpfile);
 		nilfs_cpfile_put_checkpoint(
 			nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
@@ -1865,7 +1865,7 @@ static int nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci,
 					      "failed to get inode block.\n");
 				return err;
 			}
-			nilfs_mdt_mark_buffer_dirty(ibh);
+			mark_buffer_dirty(ibh);
 			nilfs_mdt_mark_dirty(ifile);
 			spin_lock(&nilfs->ns_inode_lock);
 			if (likely(!ii->i_bh))
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index ce679cf..0a0aba6 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -117,7 +117,7 @@ static void nilfs_sufile_mod_counter(struct buffer_head *header_bh,
 	le64_add_cpu(&header->sh_ndirtysegs, ndirtyadd);
 	kunmap_atomic(kaddr, KM_USER0);
 
-	nilfs_mdt_mark_buffer_dirty(header_bh);
+	mark_buffer_dirty(header_bh);
 }
 
 /**
@@ -377,8 +377,8 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 			kunmap_atomic(kaddr, KM_USER0);
 
 			sui->ncleansegs--;
-			nilfs_mdt_mark_buffer_dirty(header_bh);
-			nilfs_mdt_mark_buffer_dirty(su_bh);
+			mark_buffer_dirty(header_bh);
+			mark_buffer_dirty(su_bh);
 			nilfs_mdt_mark_dirty(sufile);
 			brelse(su_bh);
 			*segnump = segnum;
@@ -421,7 +421,7 @@ void nilfs_sufile_do_cancel_free(struct inode *sufile, __u64 segnum,
 	nilfs_sufile_mod_counter(header_bh, -1, 1);
 	NILFS_SUI(sufile)->ncleansegs--;
 
-	nilfs_mdt_mark_buffer_dirty(su_bh);
+	mark_buffer_dirty(su_bh);
 	nilfs_mdt_mark_dirty(sufile);
 }
 
@@ -452,7 +452,7 @@ void nilfs_sufile_do_scrap(struct inode *sufile, __u64 segnum,
 	nilfs_sufile_mod_counter(header_bh, clean ? (u64)-1 : 0, dirty ? 0 : 1);
 	NILFS_SUI(sufile)->ncleansegs -= clean;
 
-	nilfs_mdt_mark_buffer_dirty(su_bh);
+	mark_buffer_dirty(su_bh);
 	nilfs_mdt_mark_dirty(sufile);
 }
 
@@ -478,7 +478,7 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 	sudirty = nilfs_segment_usage_dirty(su);
 	nilfs_segment_usage_set_clean(su);
 	kunmap_atomic(kaddr, KM_USER0);
-	nilfs_mdt_mark_buffer_dirty(su_bh);
+	mark_buffer_dirty(su_bh);
 
 	nilfs_sufile_mod_counter(header_bh, 1, sudirty ? (u64)-1 : 0);
 	NILFS_SUI(sufile)->ncleansegs++;
@@ -498,7 +498,7 @@ int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
 
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
 	if (!ret) {
-		nilfs_mdt_mark_buffer_dirty(bh);
+		mark_buffer_dirty(bh);
 		nilfs_mdt_mark_dirty(sufile);
 		brelse(bh);
 	}
@@ -533,7 +533,7 @@ int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
 	su->su_nblocks = cpu_to_le32(nblocks);
 	kunmap_atomic(kaddr, KM_USER0);
 
-	nilfs_mdt_mark_buffer_dirty(bh);
+	mark_buffer_dirty(bh);
 	nilfs_mdt_mark_dirty(sufile);
 	brelse(bh);
 
@@ -612,7 +612,7 @@ void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
 		nilfs_sufile_mod_counter(header_bh, -1, 0);
 		NILFS_SUI(sufile)->ncleansegs--;
 	}
-	nilfs_mdt_mark_buffer_dirty(su_bh);
+	mark_buffer_dirty(su_bh);
 	nilfs_mdt_mark_dirty(sufile);
 }
 
@@ -698,7 +698,7 @@ static int nilfs_sufile_truncate_range(struct inode *sufile,
 		}
 		kunmap_atomic(kaddr, KM_USER0);
 		if (nc > 0) {
-			nilfs_mdt_mark_buffer_dirty(su_bh);
+			mark_buffer_dirty(su_bh);
 			ncleaned += nc;
 		}
 		brelse(su_bh);
@@ -777,7 +777,7 @@ int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs)
 	header->sh_ncleansegs = cpu_to_le64(sui->ncleansegs);
 	kunmap_atomic(kaddr, KM_USER0);
 
-	nilfs_mdt_mark_buffer_dirty(header_bh);
+	mark_buffer_dirty(header_bh);
 	nilfs_mdt_mark_dirty(sufile);
 	nilfs_set_nsegments(nilfs, newnsegs);
 
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
