From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 02/23] nilfs2: set pointer to root object in inodes
Date: Tue, 14 Sep 2010 00:37:03 +0900
Message-ID: <1284392244-27100-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

This puts a pointer to nilfs_root object in the private part of
on-memory inode, and makes nilfs_iget function pick up the inode with
the same root object.

Non-root inodes inherit its nilfs_root object from parent inode.  That
of the root inode is allocated through nilfs_attach_checkpoint()
function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/inode.c    |   27 ++++++++++++++++++++++-----
 fs/nilfs2/namei.c    |    5 +++--
 fs/nilfs2/nilfs.h    |    7 +++++--
 fs/nilfs2/recovery.c |   12 ++++++++----
 fs/nilfs2/super.c    |   37 ++++++++++++++++++++++++++++++-------
 5 files changed, 68 insertions(+), 20 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 82cfdbc..7306fc7 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -37,6 +37,7 @@
 struct nilfs_iget_args {
 	u64 ino;
 	__u64 cno;
+	struct nilfs_root *root;
 	int for_gc;
 };
 
@@ -284,6 +285,7 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
+	struct nilfs_root *root;
 	int err = -ENOMEM;
 	ino_t ino;
 
@@ -294,8 +296,10 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 	mapping_set_gfp_mask(inode->i_mapping,
 			     mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 
+	root = NILFS_I(dir)->i_root;
 	ii = NILFS_I(inode);
 	ii->i_state = 1 << NILFS_I_NEW;
+	ii->i_root = root;
 
 	err = nilfs_ifile_create_inode(sbi->s_ifile, &ino, &ii->i_bh);
 	if (unlikely(err))
@@ -484,7 +488,7 @@ static int nilfs_iget_test(struct inode *inode, void *opaque)
 	struct nilfs_iget_args *args = opaque;
 	struct nilfs_inode_info *ii;
 
-	if (args->ino != inode->i_ino)
+	if (args->ino != inode->i_ino || args->root != NILFS_I(inode)->i_root)
 		return 0;
 
 	ii = NILFS_I(inode);
@@ -502,13 +506,21 @@ static int nilfs_iget_set(struct inode *inode, void *opaque)
 	if (args->for_gc) {
 		NILFS_I(inode)->i_state = 1 << NILFS_I_GCINODE;
 		NILFS_I(inode)->i_cno = args->cno;
+		NILFS_I(inode)->i_root = NULL;
+	} else {
+		if (args->root && args->ino == NILFS_ROOT_INO)
+			nilfs_get_root(args->root);
+		NILFS_I(inode)->i_root = args->root;
 	}
 	return 0;
 }
 
-struct inode *nilfs_iget(struct super_block *sb, unsigned long ino)
+struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
+			 unsigned long ino)
 {
-	struct nilfs_iget_args args = { .ino = ino, .cno = 0, .for_gc = 0 };
+	struct nilfs_iget_args args = {
+		.ino = ino, .root = root, .cno = 0, .for_gc = 0
+	};
 	struct inode *inode;
 	int err;
 
@@ -530,7 +542,9 @@ struct inode *nilfs_iget(struct super_block *sb, unsigned long ino)
 struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
 				__u64 cno)
 {
-	struct nilfs_iget_args args = { .ino = ino, .cno = cno, .for_gc = 1 };
+	struct nilfs_iget_args args = {
+		.ino = ino, .root = NULL, .cno = cno, .for_gc = 1
+	};
 	struct inode *inode;
 	int err;
 
@@ -682,6 +696,9 @@ static void nilfs_clear_inode(struct inode *inode)
 		nilfs_bmap_clear(ii->i_bmap);
 
 	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
+
+	if (ii->i_root && inode->i_ino == NILFS_ROOT_INO)
+		nilfs_put_root(ii->i_root);
 }
 
 void nilfs_evict_inode(struct inode *inode)
@@ -690,7 +707,7 @@ void nilfs_evict_inode(struct inode *inode)
 	struct super_block *sb = inode->i_sb;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 
-	if (inode->i_nlink || unlikely(is_bad_inode(inode))) {
+	if (inode->i_nlink || !ii->i_root || unlikely(is_bad_inode(inode))) {
 		if (inode->i_data.nrpages)
 			truncate_inode_pages(&inode->i_data, 0);
 		end_writeback(inode);
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index ad6ed2c..1110d56 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -70,7 +70,7 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	ino = nilfs_inode_by_name(dir, &dentry->d_name);
 	inode = NULL;
 	if (ino) {
-		inode = nilfs_iget(dir->i_sb, ino);
+		inode = nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino);
 		if (IS_ERR(inode))
 			return ERR_CAST(inode);
 	}
@@ -87,7 +87,8 @@ struct dentry *nilfs_get_parent(struct dentry *child)
 	if (!ino)
 		return ERR_PTR(-ENOENT);
 
-	inode = nilfs_iget(child->d_inode->i_sb, ino);
+	inode = nilfs_iget(child->d_inode->i_sb,
+			   NILFS_I(child->d_inode)->i_root, ino);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 	return d_obtain_alias(inode);
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 797cd43..21d90c4 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -59,6 +59,7 @@ struct nilfs_inode_info {
 #endif
 	struct buffer_head *i_bh;	/* i_bh contains a new or dirty
 					   disk inode */
+	struct nilfs_root *i_root;
 	struct inode vfs_inode;
 };
 
@@ -247,7 +248,8 @@ extern int nilfs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 extern void nilfs_set_inode_flags(struct inode *);
 extern int nilfs_read_inode_common(struct inode *, struct nilfs_inode *);
 extern void nilfs_write_inode_common(struct inode *, struct nilfs_inode *, int);
-extern struct inode *nilfs_iget(struct super_block *, unsigned long);
+struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
+			 unsigned long ino);
 extern struct inode *nilfs_iget_for_gc(struct super_block *sb,
 				       unsigned long ino, __u64 cno);
 extern void nilfs_update_inode(struct inode *, struct buffer_head *);
@@ -285,7 +287,8 @@ extern struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *,
 						      int flip);
 extern int nilfs_commit_super(struct nilfs_sb_info *, int);
 extern int nilfs_cleanup_super(struct nilfs_sb_info *);
-extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
+int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
+			    struct nilfs_root **root);
 extern void nilfs_detach_checkpoint(struct nilfs_sb_info *);
 
 /* gcinode.c */
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index d0c35ef..a9a5ba8 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -504,6 +504,7 @@ static int nilfs_recovery_copy_block(struct the_nilfs *nilfs,
 
 static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 				      struct nilfs_sb_info *sbi,
+				      struct nilfs_root *root,
 				      struct list_head *head,
 				      unsigned long *nr_salvaged_blocks)
 {
@@ -515,7 +516,7 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 	int err = 0, err2 = 0;
 
 	list_for_each_entry_safe(rb, n, head, list) {
-		inode = nilfs_iget(sbi->s_super, rb->ino);
+		inode = nilfs_iget(sbi->s_super, root, rb->ino);
 		if (IS_ERR(inode)) {
 			err = PTR_ERR(inode);
 			inode = NULL;
@@ -578,6 +579,7 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
  */
 static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 				 struct nilfs_sb_info *sbi,
+				 struct nilfs_root *root,
 				 struct nilfs_recovery_info *ri)
 {
 	struct buffer_head *bh_sum = NULL;
@@ -649,7 +651,7 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 				goto failed;
 			if (flags & NILFS_SS_LOGEND) {
 				err = nilfs_recover_dsync_blocks(
-					nilfs, sbi, &dsync_blocks,
+					nilfs, sbi, root, &dsync_blocks,
 					&nsalvaged_blocks);
 				if (unlikely(err))
 					goto failed;
@@ -746,19 +748,20 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 			      struct nilfs_sb_info *sbi,
 			      struct nilfs_recovery_info *ri)
 {
+	struct nilfs_root *root;
 	int err;
 
 	if (ri->ri_lsegs_start == 0 || ri->ri_lsegs_end == 0)
 		return 0;
 
-	err = nilfs_attach_checkpoint(sbi, ri->ri_cno);
+	err = nilfs_attach_checkpoint(sbi, ri->ri_cno, true, &root);
 	if (unlikely(err)) {
 		printk(KERN_ERR
 		       "NILFS: error loading the latest checkpoint.\n");
 		return err;
 	}
 
-	err = nilfs_do_roll_forward(nilfs, sbi, ri);
+	err = nilfs_do_roll_forward(nilfs, sbi, root, ri);
 	if (unlikely(err))
 		goto failed;
 
@@ -789,6 +792,7 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 
  failed:
 	nilfs_detach_checkpoint(sbi);
+	nilfs_put_root(root);
 	return err;
 }
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 452004b..0b82bdf 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -396,18 +396,24 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 	return err;
 }
 
-int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
+int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
+			    struct nilfs_root **rootp)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_root *root;
 	struct nilfs_checkpoint *raw_cp;
 	struct buffer_head *bh_cp;
-	int err;
+	int err = -ENOMEM;
+
+	root = nilfs_find_or_create_root(
+		nilfs, curr_mnt ? NILFS_CPTREE_CURRENT_CNO : cno);
+	if (!root)
+		return err;
 
 	down_write(&nilfs->ns_super_sem);
 	list_add(&sbi->s_list, &nilfs->ns_supers);
 	up_write(&nilfs->ns_super_sem);
 
-	err = -ENOMEM;
 	sbi->s_ifile = nilfs_ifile_new(sbi, nilfs->ns_inode_size);
 	if (!sbi->s_ifile)
 		goto delist;
@@ -433,6 +439,8 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
 	atomic_set(&sbi->s_blocks_count, le64_to_cpu(raw_cp->cp_blocks_count));
 
 	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, cno, bh_cp);
+
+	*rootp = root;
 	return 0;
 
  failed_bh:
@@ -445,6 +453,7 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
 	down_write(&nilfs->ns_super_sem);
 	list_del_init(&sbi->s_list);
 	up_write(&nilfs->ns_super_sem);
+	nilfs_put_root(root);
 
 	return err;
 }
@@ -556,12 +565,20 @@ static struct inode *
 nilfs_nfs_get_inode(struct super_block *sb, u64 ino, u32 generation)
 {
 	struct inode *inode;
+	struct nilfs_root *root;
 
 	if (ino < NILFS_FIRST_INO(sb) && ino != NILFS_ROOT_INO &&
 	    ino != NILFS_SKETCH_INO)
 		return ERR_PTR(-ESTALE);
 
-	inode = nilfs_iget(sb, ino);
+	root = nilfs_lookup_root(NILFS_SB(sb)->s_nilfs,
+				 NILFS_CPTREE_CURRENT_CNO);
+	if (!root)
+		return ERR_PTR(-ESTALE);
+
+	/* new file handle type is required to export snapshots */
+	inode = nilfs_iget(sb, root, ino);
+	nilfs_put_root(root);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 	if (generation && inode->i_generation != generation) {
@@ -820,9 +837,10 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 		 struct the_nilfs *nilfs)
 {
 	struct nilfs_sb_info *sbi;
+	struct nilfs_root *fsroot;
 	struct inode *root;
 	__u64 cno;
-	int err;
+	int err, curr_mnt;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -864,6 +882,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 		goto failed_sbi;
 
 	cno = nilfs_last_cno(nilfs);
+	curr_mnt = true;
 
 	if (sb->s_flags & MS_RDONLY) {
 		if (nilfs_test_opt(sbi, SNAPSHOT)) {
@@ -886,10 +905,11 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 				goto failed_sbi;
 			}
 			cno = sbi->s_snapshot_cno;
+			curr_mnt = false;
 		}
 	}
 
-	err = nilfs_attach_checkpoint(sbi, cno);
+	err = nilfs_attach_checkpoint(sbi, cno, curr_mnt, &fsroot);
 	if (err) {
 		printk(KERN_ERR "NILFS: error loading a checkpoint"
 		       " (checkpoint number=%llu).\n", (unsigned long long)cno);
@@ -902,7 +922,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 			goto failed_checkpoint;
 	}
 
-	root = nilfs_iget(sb, NILFS_ROOT_INO);
+	root = nilfs_iget(sb, fsroot, NILFS_ROOT_INO);
 	if (IS_ERR(root)) {
 		printk(KERN_ERR "NILFS: get root inode failed\n");
 		err = PTR_ERR(root);
@@ -922,6 +942,8 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 		goto failed_segctor;
 	}
 
+	nilfs_put_root(fsroot);
+
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_write(&nilfs->ns_sem);
 		nilfs_setup_super(sbi);
@@ -940,6 +962,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 
  failed_checkpoint:
 	nilfs_detach_checkpoint(sbi);
+	nilfs_put_root(fsroot);
 
  failed_sbi:
 	put_nilfs(nilfs);
-- 
1.6.6.2

