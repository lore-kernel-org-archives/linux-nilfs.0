From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 04/23] nilfs2: use root object to get ifile
Date: Tue, 14 Sep 2010 00:37:05 +0900
Message-ID: <1284392244-27100-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This rewrites functions using ifile so that they get ifile from
nilfs_root object, and will remove sbi->s_ifile.  Some functions that
don't know the root object are extended to receive it from caller.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/inode.c    |   48 +++++++++++++++++++++---------------------------
 fs/nilfs2/nilfs.h    |    1 -
 fs/nilfs2/recovery.c |    3 +--
 fs/nilfs2/sb.h       |    3 ---
 fs/nilfs2/segment.c  |   43 ++++++++++++++++++++++++++-----------------
 fs/nilfs2/segment.h  |    7 ++++++-
 fs/nilfs2/super.c    |   42 +++++++++++++-----------------------------
 7 files changed, 67 insertions(+), 80 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7306fc7..7e883d5 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -301,7 +301,7 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 	ii->i_state = 1 << NILFS_I_NEW;
 	ii->i_root = root;
 
-	err = nilfs_ifile_create_inode(sbi->s_ifile, &ino, &ii->i_bh);
+	err = nilfs_ifile_create_inode(root->ifile, &ino, &ii->i_bh);
 	if (unlikely(err))
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
@@ -358,16 +358,6 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 	return ERR_PTR(err);
 }
 
-void nilfs_free_inode(struct inode *inode)
-{
-	struct super_block *sb = inode->i_sb;
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-
-	/* XXX: check error code? Is there any thing I can do? */
-	(void) nilfs_ifile_delete_inode(sbi->s_ifile, inode->i_ino);
-	atomic_dec(&sbi->s_inodes_count);
-}
-
 void nilfs_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = NILFS_I(inode)->i_flags;
@@ -431,7 +421,8 @@ int nilfs_read_inode_common(struct inode *inode,
 	return 0;
 }
 
-static int __nilfs_read_inode(struct super_block *sb, unsigned long ino,
+static int __nilfs_read_inode(struct super_block *sb,
+			      struct nilfs_root *root, unsigned long ino,
 			      struct inode *inode)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
@@ -441,11 +432,11 @@ static int __nilfs_read_inode(struct super_block *sb, unsigned long ino,
 	int err;
 
 	down_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
-	err = nilfs_ifile_get_inode_block(sbi->s_ifile, ino, &bh);
+	err = nilfs_ifile_get_inode_block(root->ifile, ino, &bh);
 	if (unlikely(err))
 		goto bad_inode;
 
-	raw_inode = nilfs_ifile_map_inode(sbi->s_ifile, ino, bh);
+	raw_inode = nilfs_ifile_map_inode(root->ifile, ino, bh);
 
 	err = nilfs_read_inode_common(inode, raw_inode);
 	if (err)
@@ -468,14 +459,14 @@ static int __nilfs_read_inode(struct super_block *sb, unsigned long ino,
 			inode, inode->i_mode,
 			huge_decode_dev(le64_to_cpu(raw_inode->i_device_code)));
 	}
-	nilfs_ifile_unmap_inode(sbi->s_ifile, ino, bh);
+	nilfs_ifile_unmap_inode(root->ifile, ino, bh);
 	brelse(bh);
 	up_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
 	nilfs_set_inode_flags(inode);
 	return 0;
 
  failed_unmap:
-	nilfs_ifile_unmap_inode(sbi->s_ifile, ino, bh);
+	nilfs_ifile_unmap_inode(root->ifile, ino, bh);
 	brelse(bh);
 
  bad_inode:
@@ -530,7 +521,7 @@ struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
 	if (!(inode->i_state & I_NEW))
 		return inode;
 
-	err = __nilfs_read_inode(sb, ino, inode);
+	err = __nilfs_read_inode(sb, root, ino, inode);
 	if (unlikely(err)) {
 		iget_failed(inode);
 		return ERR_PTR(err);
@@ -595,21 +586,20 @@ void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh)
 {
 	ino_t ino = inode->i_ino;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	struct super_block *sb = inode->i_sb;
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct inode *ifile = ii->i_root->ifile;
 	struct nilfs_inode *raw_inode;
 
-	raw_inode = nilfs_ifile_map_inode(sbi->s_ifile, ino, ibh);
+	raw_inode = nilfs_ifile_map_inode(ifile, ino, ibh);
 
 	if (test_and_clear_bit(NILFS_I_NEW, &ii->i_state))
-		memset(raw_inode, 0, NILFS_MDT(sbi->s_ifile)->mi_entry_size);
+		memset(raw_inode, 0, NILFS_MDT(ifile)->mi_entry_size);
 	set_bit(NILFS_I_INODE_DIRTY, &ii->i_state);
 
 	nilfs_write_inode_common(inode, raw_inode, 0);
 		/* XXX: call with has_bmap = 0 is a workaround to avoid
 		   deadlock of bmap. This delays update of i_bmap to just
 		   before writing */
-	nilfs_ifile_unmap_inode(sbi->s_ifile, ino, ibh);
+	nilfs_ifile_unmap_inode(ifile, ino, ibh);
 }
 
 #define NILFS_MAX_TRUNCATE_BLOCKS	16384  /* 64MB for 4KB block */
@@ -719,12 +709,16 @@ void nilfs_evict_inode(struct inode *inode)
 	if (inode->i_data.nrpages)
 		truncate_inode_pages(&inode->i_data, 0);
 
+	/* TODO: some of the following operations may fail.  */
 	nilfs_truncate_bmap(ii, 0);
 	nilfs_mark_inode_dirty(inode);
 	end_writeback(inode);
+
+	nilfs_ifile_delete_inode(ii->i_root->ifile, inode->i_ino);
+	atomic_dec(&NILFS_SB(sb)->s_inodes_count);
+
 	nilfs_clear_inode(inode);
-	nilfs_free_inode(inode);
-	/* nilfs_free_inode() marks inode buffer dirty */
+
 	if (IS_SYNC(inode))
 		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 	nilfs_transaction_commit(sb);
@@ -779,8 +773,8 @@ int nilfs_load_inode_block(struct nilfs_sb_info *sbi, struct inode *inode,
 	spin_lock(&sbi->s_inode_lock);
 	if (ii->i_bh == NULL) {
 		spin_unlock(&sbi->s_inode_lock);
-		err = nilfs_ifile_get_inode_block(sbi->s_ifile, inode->i_ino,
-						  pbh);
+		err = nilfs_ifile_get_inode_block(ii->i_root->ifile,
+						  inode->i_ino, pbh);
 		if (unlikely(err))
 			return err;
 		spin_lock(&sbi->s_inode_lock);
@@ -860,7 +854,7 @@ int nilfs_mark_inode_dirty(struct inode *inode)
 	}
 	nilfs_update_inode(inode, ibh);
 	nilfs_mdt_mark_buffer_dirty(ibh);
-	nilfs_mdt_mark_dirty(sbi->s_ifile);
+	nilfs_mdt_mark_dirty(NILFS_I(inode)->i_root->ifile);
 	brelse(ibh);
 	return 0;
 }
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index aa7940f..3870c10 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -286,7 +286,6 @@ extern int nilfs_commit_super(struct nilfs_sb_info *, int);
 extern int nilfs_cleanup_super(struct nilfs_sb_info *);
 int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
 			    struct nilfs_root **root);
-extern void nilfs_detach_checkpoint(struct nilfs_sb_info *);
 
 /* gcinode.c */
 int nilfs_gccache_submit_read_data(struct inode *, sector_t, sector_t, __u64,
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index a9a5ba8..dcb5a98 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -773,7 +773,7 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 			goto failed;
 		}
 
-		err = nilfs_attach_segment_constructor(sbi);
+		err = nilfs_attach_segment_constructor(sbi, root);
 		if (unlikely(err))
 			goto failed;
 
@@ -791,7 +791,6 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 	}
 
  failed:
-	nilfs_detach_checkpoint(sbi);
 	nilfs_put_root(root);
 	return err;
 }
diff --git a/fs/nilfs2/sb.h b/fs/nilfs2/sb.h
index 0776ccc..50c418e 100644
--- a/fs/nilfs2/sb.h
+++ b/fs/nilfs2/sb.h
@@ -68,9 +68,6 @@ struct nilfs_sb_info {
 	spinlock_t s_inode_lock;	/* Lock for the nilfs inode.
 					   It covers s_dirty_files list */
 
-	/* Metadata files */
-	struct inode *s_ifile;		/* index file inode */
-
 	/* Inode allocator */
 	spinlock_t s_next_gen_lock;
 	u32 s_next_generation;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9cf7138..2a6b74e 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -763,12 +763,12 @@ static void nilfs_dispose_list(struct nilfs_sb_info *sbi,
 	}
 }
 
-static int nilfs_test_metadata_dirty(struct nilfs_sb_info *sbi)
+static int nilfs_test_metadata_dirty(struct the_nilfs *nilfs,
+				     struct nilfs_root *root)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
 	int ret = 0;
 
-	if (nilfs_mdt_fetch_dirty(sbi->s_ifile))
+	if (nilfs_mdt_fetch_dirty(root->ifile))
 		ret++;
 	if (nilfs_mdt_fetch_dirty(nilfs->ns_cpfile))
 		ret++;
@@ -793,7 +793,7 @@ static int nilfs_segctor_confirm(struct nilfs_sc_info *sci)
 	struct nilfs_sb_info *sbi = sci->sc_sbi;
 	int ret = 0;
 
-	if (nilfs_test_metadata_dirty(sbi))
+	if (nilfs_test_metadata_dirty(sbi->s_nilfs, sci->sc_root))
 		set_bit(NILFS_SC_DIRTY, &sci->sc_flags);
 
 	spin_lock(&sbi->s_inode_lock);
@@ -809,7 +809,7 @@ static void nilfs_segctor_clear_metadata_dirty(struct nilfs_sc_info *sci)
 	struct nilfs_sb_info *sbi = sci->sc_sbi;
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 
-	nilfs_mdt_clear_dirty(sbi->s_ifile);
+	nilfs_mdt_clear_dirty(sci->sc_root->ifile);
 	nilfs_mdt_clear_dirty(nilfs->ns_cpfile);
 	nilfs_mdt_clear_dirty(nilfs->ns_sufile);
 	nilfs_mdt_clear_dirty(nilfs_dat_inode(nilfs));
@@ -869,7 +869,8 @@ static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 	else
 		nilfs_checkpoint_set_minor(raw_cp);
 
-	nilfs_write_inode_common(sbi->s_ifile, &raw_cp->cp_ifile_inode, 1);
+	nilfs_write_inode_common(sci->sc_root->ifile,
+				 &raw_cp->cp_ifile_inode, 1);
 	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
 	return 0;
 
@@ -894,13 +895,12 @@ static void nilfs_fill_in_file_bmap(struct inode *ifile,
 	}
 }
 
-static void nilfs_segctor_fill_in_file_bmap(struct nilfs_sc_info *sci,
-					    struct inode *ifile)
+static void nilfs_segctor_fill_in_file_bmap(struct nilfs_sc_info *sci)
 {
 	struct nilfs_inode_info *ii;
 
 	list_for_each_entry(ii, &sci->sc_dirty_files, i_dirty) {
-		nilfs_fill_in_file_bmap(ifile, ii);
+		nilfs_fill_in_file_bmap(sci->sc_root->ifile, ii);
 		set_bit(NILFS_I_COLLECTED, &ii->i_state);
 	}
 }
@@ -1143,7 +1143,7 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 		sci->sc_stage.flags |= NILFS_CF_IFILE_STARTED;
 		/* Fall through */
 	case NILFS_ST_IFILE:
-		err = nilfs_segctor_scan_file(sci, sbi->s_ifile,
+		err = nilfs_segctor_scan_file(sci, sci->sc_root->ifile,
 					      &nilfs_sc_file_ops);
 		if (unlikely(err))
 			break;
@@ -1984,6 +1984,7 @@ static int nilfs_segctor_check_in_files(struct nilfs_sc_info *sci,
 					struct nilfs_sb_info *sbi)
 {
 	struct nilfs_inode_info *ii, *n;
+	struct inode *ifile = sci->sc_root->ifile;
 
 	spin_lock(&sbi->s_inode_lock);
  retry:
@@ -1994,14 +1995,14 @@ static int nilfs_segctor_check_in_files(struct nilfs_sc_info *sci,
 
 			spin_unlock(&sbi->s_inode_lock);
 			err = nilfs_ifile_get_inode_block(
-				sbi->s_ifile, ii->vfs_inode.i_ino, &ibh);
+				ifile, ii->vfs_inode.i_ino, &ibh);
 			if (unlikely(err)) {
 				nilfs_warning(sbi->s_super, __func__,
 					      "failed to get inode block.\n");
 				return err;
 			}
 			nilfs_mdt_mark_buffer_dirty(ibh);
-			nilfs_mdt_mark_dirty(sbi->s_ifile);
+			nilfs_mdt_mark_dirty(ifile);
 			spin_lock(&sbi->s_inode_lock);
 			if (likely(!ii->i_bh))
 				ii->i_bh = ibh;
@@ -2058,7 +2059,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 	if (unlikely(err))
 		goto out;
 
-	if (nilfs_test_metadata_dirty(sbi))
+	if (nilfs_test_metadata_dirty(nilfs, sci->sc_root))
 		set_bit(NILFS_SC_DIRTY, &sci->sc_flags);
 
 	if (nilfs_segctor_clean(sci))
@@ -2090,7 +2091,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 			goto failed;
 
 		if (sci->sc_stage.flags & NILFS_CF_IFILE_STARTED)
-			nilfs_segctor_fill_in_file_bmap(sci, sbi->s_ifile);
+			nilfs_segctor_fill_in_file_bmap(sci);
 
 		if (mode == SC_LSEG_SR &&
 		    sci->sc_stage.scnt >= NILFS_ST_CPFILE) {
@@ -2684,7 +2685,8 @@ static void nilfs_segctor_kill_thread(struct nilfs_sc_info *sci)
 /*
  * Setup & clean-up functions
  */
-static struct nilfs_sc_info *nilfs_segctor_new(struct nilfs_sb_info *sbi)
+static struct nilfs_sc_info *nilfs_segctor_new(struct nilfs_sb_info *sbi,
+					       struct nilfs_root *root)
 {
 	struct nilfs_sc_info *sci;
 
@@ -2695,6 +2697,9 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct nilfs_sb_info *sbi)
 	sci->sc_sbi = sbi;
 	sci->sc_super = sbi->s_super;
 
+	nilfs_get_root(root);
+	sci->sc_root = root;
+
 	init_waitqueue_head(&sci->sc_wait_request);
 	init_waitqueue_head(&sci->sc_wait_daemon);
 	init_waitqueue_head(&sci->sc_wait_task);
@@ -2769,6 +2774,8 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 	WARN_ON(!list_empty(&sci->sc_segbufs));
 	WARN_ON(!list_empty(&sci->sc_write_logs));
 
+	nilfs_put_root(sci->sc_root);
+
 	down_write(&sbi->s_nilfs->ns_segctor_sem);
 
 	del_timer_sync(&sci->sc_timer);
@@ -2778,6 +2785,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 /**
  * nilfs_attach_segment_constructor - attach a segment constructor
  * @sbi: nilfs_sb_info
+ * @root: root object of the current filesystem tree
  *
  * nilfs_attach_segment_constructor() allocates a struct nilfs_sc_info,
  * initializes it, and starts the segment constructor.
@@ -2787,7 +2795,8 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
  *
  * %-ENOMEM - Insufficient memory available.
  */
-int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi)
+int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi,
+				     struct nilfs_root *root)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	int err;
@@ -2801,7 +2810,7 @@ int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi)
 		nilfs_detach_segment_constructor(sbi);
 	}
 
-	sbi->s_sc_info = nilfs_segctor_new(sbi);
+	sbi->s_sc_info = nilfs_segctor_new(sbi, root);
 	if (!sbi->s_sc_info)
 		return -ENOMEM;
 
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 675d932..cd8056e 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -29,6 +29,8 @@
 #include <linux/nilfs2_fs.h>
 #include "sb.h"
 
+struct nilfs_root;
+
 /**
  * struct nilfs_recovery_info - Recovery information
  * @ri_need_recovery: Recovery status
@@ -87,6 +89,7 @@ struct nilfs_segsum_pointer {
  * struct nilfs_sc_info - Segment constructor information
  * @sc_super: Back pointer to super_block struct
  * @sc_sbi: Back pointer to nilfs_sb_info struct
+ * @sc_root: root object of the current filesystem tree
  * @sc_nblk_inc: Block count of current generation
  * @sc_dirty_files: List of files to be written
  * @sc_gc_inodes: List of GC inodes having blocks to be written
@@ -129,6 +132,7 @@ struct nilfs_segsum_pointer {
 struct nilfs_sc_info {
 	struct super_block     *sc_super;
 	struct nilfs_sb_info   *sc_sbi;
+	struct nilfs_root      *sc_root;
 
 	unsigned long		sc_nblk_inc;
 
@@ -231,7 +235,8 @@ extern void nilfs_flush_segment(struct super_block *, ino_t);
 extern int nilfs_clean_segments(struct super_block *, struct nilfs_argv *,
 				void **);
 
-extern int nilfs_attach_segment_constructor(struct nilfs_sb_info *);
+int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi,
+				     struct nilfs_root *root);
 extern void nilfs_detach_segment_constructor(struct nilfs_sb_info *);
 
 /* recovery.c */
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8c71f97..fafb724 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -361,9 +361,9 @@ static void nilfs_put_super(struct super_block *sb)
 	down_write(&nilfs->ns_super_sem);
 	if (nilfs->ns_current == sbi)
 		nilfs->ns_current = NULL;
+	list_del_init(&sbi->s_list);
 	up_write(&nilfs->ns_super_sem);
 
-	nilfs_detach_checkpoint(sbi);
 	put_nilfs(sbi->s_nilfs);
 	sbi->s_super = NULL;
 	sb->s_fs_info = NULL;
@@ -410,13 +410,12 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
 	if (!root)
 		return err;
 
-	down_write(&nilfs->ns_super_sem);
-	list_add(&sbi->s_list, &nilfs->ns_supers);
-	up_write(&nilfs->ns_super_sem);
+	if (root->ifile)
+		goto reuse; /* already attached checkpoint */
 
-	sbi->s_ifile = nilfs_ifile_new(sbi, nilfs->ns_inode_size);
-	if (!sbi->s_ifile)
-		goto delist;
+	root->ifile = nilfs_ifile_new(sbi, nilfs->ns_inode_size);
+	if (!root->ifile)
+		goto failed;
 
 	down_read(&nilfs->ns_segctor_sem);
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, cno, 0, &raw_cp,
@@ -432,7 +431,7 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
 		}
 		goto failed;
 	}
-	err = nilfs_read_inode_common(sbi->s_ifile, &raw_cp->cp_ifile_inode);
+	err = nilfs_read_inode_common(root->ifile, &raw_cp->cp_ifile_inode);
 	if (unlikely(err))
 		goto failed_bh;
 	atomic_set(&sbi->s_inodes_count, le64_to_cpu(raw_cp->cp_inodes_count));
@@ -440,35 +439,18 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
 
 	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, cno, bh_cp);
 
+ reuse:
 	*rootp = root;
 	return 0;
 
  failed_bh:
 	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, cno, bh_cp);
  failed:
-	nilfs_mdt_destroy(sbi->s_ifile);
-	sbi->s_ifile = NULL;
-
- delist:
-	down_write(&nilfs->ns_super_sem);
-	list_del_init(&sbi->s_list);
-	up_write(&nilfs->ns_super_sem);
 	nilfs_put_root(root);
 
 	return err;
 }
 
-void nilfs_detach_checkpoint(struct nilfs_sb_info *sbi)
-{
-	struct the_nilfs *nilfs = sbi->s_nilfs;
-
-	nilfs_mdt_destroy(sbi->s_ifile);
-	sbi->s_ifile = NULL;
-	down_write(&nilfs->ns_super_sem);
-	list_del_init(&sbi->s_list);
-	up_write(&nilfs->ns_super_sem);
-}
-
 static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
@@ -867,7 +849,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	}
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		err = nilfs_attach_segment_constructor(sbi);
+		err = nilfs_attach_segment_constructor(sbi, fsroot);
 		if (err)
 			goto failed_checkpoint;
 	}
@@ -901,6 +883,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	}
 
 	down_write(&nilfs->ns_super_sem);
+	list_add(&sbi->s_list, &nilfs->ns_supers);
 	if (!nilfs_test_opt(sbi, SNAPSHOT))
 		nilfs->ns_current = sbi;
 	up_write(&nilfs->ns_super_sem);
@@ -911,7 +894,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	nilfs_detach_segment_constructor(sbi);
 
  failed_checkpoint:
-	nilfs_detach_checkpoint(sbi);
 	nilfs_put_root(fsroot);
 
  failed_sbi:
@@ -973,6 +955,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		up_write(&nilfs->ns_sem);
 	} else {
 		__u64 features;
+		struct nilfs_root *root;
 
 		/*
 		 * Mounting a RDONLY partition read-write, so reread and
@@ -994,7 +977,8 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 
 		sb->s_flags &= ~MS_RDONLY;
 
-		err = nilfs_attach_segment_constructor(sbi);
+		root = NILFS_I(sb->s_root->d_inode)->i_root;
+		err = nilfs_attach_segment_constructor(sbi, root);
 		if (err)
 			goto restore_opts;
 
-- 
1.6.6.2

