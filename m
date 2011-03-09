From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/8] nilfs2: move s_inode_lock and s_dirty_files into nilfs object
Date: Wed,  9 Mar 2011 21:08:08 +0900
Message-ID: <1299672493-28544-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1299672493-28544-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299672493-28544-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Moves s_inode_lock spinlock and s_dirty_files list to nilfs object
from nilfs_sb_info structure.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c     |   30 +++++++++---------
 fs/nilfs2/sb.h        |    3 --
 fs/nilfs2/segment.c   |   80 ++++++++++++++++++++++++------------------------
 fs/nilfs2/super.c     |    3 --
 fs/nilfs2/the_nilfs.c |    2 +
 fs/nilfs2/the_nilfs.h |    6 ++++
 6 files changed, 63 insertions(+), 61 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 22a816b..dd5d6d6 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -807,18 +807,18 @@ int nilfs_permission(struct inode *inode, int mask, unsigned int flags)
 
 int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
+	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	int err;
 
-	spin_lock(&sbi->s_inode_lock);
+	spin_lock(&nilfs->ns_inode_lock);
 	if (ii->i_bh == NULL) {
-		spin_unlock(&sbi->s_inode_lock);
+		spin_unlock(&nilfs->ns_inode_lock);
 		err = nilfs_ifile_get_inode_block(ii->i_root->ifile,
 						  inode->i_ino, pbh);
 		if (unlikely(err))
 			return err;
-		spin_lock(&sbi->s_inode_lock);
+		spin_lock(&nilfs->ns_inode_lock);
 		if (ii->i_bh == NULL)
 			ii->i_bh = *pbh;
 		else {
@@ -829,36 +829,36 @@ int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh)
 		*pbh = ii->i_bh;
 
 	get_bh(*pbh);
-	spin_unlock(&sbi->s_inode_lock);
+	spin_unlock(&nilfs->ns_inode_lock);
 	return 0;
 }
 
 int nilfs_inode_dirty(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
+	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
 	int ret = 0;
 
 	if (!list_empty(&ii->i_dirty)) {
-		spin_lock(&sbi->s_inode_lock);
+		spin_lock(&nilfs->ns_inode_lock);
 		ret = test_bit(NILFS_I_DIRTY, &ii->i_state) ||
 			test_bit(NILFS_I_BUSY, &ii->i_state);
-		spin_unlock(&sbi->s_inode_lock);
+		spin_unlock(&nilfs->ns_inode_lock);
 	}
 	return ret;
 }
 
 int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
 	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
 
-	atomic_add(nr_dirty, &sbi->s_nilfs->ns_ndirtyblks);
+	atomic_add(nr_dirty, &nilfs->ns_ndirtyblks);
 
 	if (test_and_set_bit(NILFS_I_DIRTY, &ii->i_state))
 		return 0;
 
-	spin_lock(&sbi->s_inode_lock);
+	spin_lock(&nilfs->ns_inode_lock);
 	if (!test_bit(NILFS_I_QUEUED, &ii->i_state) &&
 	    !test_bit(NILFS_I_BUSY, &ii->i_state)) {
 		/* Because this routine may race with nilfs_dispose_list(),
@@ -866,18 +866,18 @@ int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty)
 		if (list_empty(&ii->i_dirty) && igrab(inode) == NULL) {
 			/* This will happen when somebody is freeing
 			   this inode. */
-			nilfs_warning(sbi->s_super, __func__,
+			nilfs_warning(inode->i_sb, __func__,
 				      "cannot get inode (ino=%lu)\n",
 				      inode->i_ino);
-			spin_unlock(&sbi->s_inode_lock);
+			spin_unlock(&nilfs->ns_inode_lock);
 			return -EINVAL; /* NILFS_I_DIRTY may remain for
 					   freeing inode */
 		}
 		list_del(&ii->i_dirty);
-		list_add_tail(&ii->i_dirty, &sbi->s_dirty_files);
+		list_add_tail(&ii->i_dirty, &nilfs->ns_dirty_files);
 		set_bit(NILFS_I_QUEUED, &ii->i_state);
 	}
-	spin_unlock(&sbi->s_inode_lock);
+	spin_unlock(&nilfs->ns_inode_lock);
 	return 0;
 }
 
diff --git a/fs/nilfs2/sb.h b/fs/nilfs2/sb.h
index 0512521..3232e75 100644
--- a/fs/nilfs2/sb.h
+++ b/fs/nilfs2/sb.h
@@ -39,10 +39,7 @@ struct nilfs_sb_info {
 	struct the_nilfs *s_nilfs;
 
 	/* Segment constructor */
-	struct list_head s_dirty_files;	/* dirty files list */
 	struct nilfs_sc_info *s_sc_info; /* segment constructor info */
-	spinlock_t s_inode_lock;	/* Lock for the nilfs inode.
-					   It covers s_dirty_files list */
 
 	/* Inode allocator */
 	spinlock_t s_next_gen_lock;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index a32d9cb..6ac50d8 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -104,8 +104,7 @@ struct nilfs_sc_operations {
 static void nilfs_segctor_start_timer(struct nilfs_sc_info *);
 static void nilfs_segctor_do_flush(struct nilfs_sc_info *, int);
 static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *);
-static void nilfs_dispose_list(struct nilfs_sb_info *, struct list_head *,
-			       int);
+static void nilfs_dispose_list(struct the_nilfs *, struct list_head *, int);
 
 #define nilfs_cnt32_gt(a, b)   \
 	(typecheck(__u32, a) && typecheck(__u32, b) && \
@@ -325,14 +324,15 @@ static void nilfs_transaction_lock(struct nilfs_sb_info *sbi,
 static void nilfs_transaction_unlock(struct nilfs_sb_info *sbi)
 {
 	struct nilfs_transaction_info *ti = current->journal_info;
+	struct the_nilfs *nilfs = sbi->s_nilfs;
 
 	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
 	BUG_ON(ti->ti_count > 0);
 
-	up_write(&sbi->s_nilfs->ns_segctor_sem);
+	up_write(&nilfs->ns_segctor_sem);
 	current->journal_info = ti->ti_save;
 	if (!list_empty(&ti->ti_garbage))
-		nilfs_dispose_list(sbi, &ti->ti_garbage, 0);
+		nilfs_dispose_list(nilfs, &ti->ti_garbage, 0);
 }
 
 static void *nilfs_segctor_map_segsum_entry(struct nilfs_sc_info *sci,
@@ -714,7 +714,7 @@ static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
 	}
 }
 
-static void nilfs_dispose_list(struct nilfs_sb_info *sbi,
+static void nilfs_dispose_list(struct the_nilfs *nilfs,
 			       struct list_head *head, int force)
 {
 	struct nilfs_inode_info *ii, *n;
@@ -722,7 +722,7 @@ static void nilfs_dispose_list(struct nilfs_sb_info *sbi,
 	unsigned nv = 0;
 
 	while (!list_empty(head)) {
-		spin_lock(&sbi->s_inode_lock);
+		spin_lock(&nilfs->ns_inode_lock);
 		list_for_each_entry_safe(ii, n, head, i_dirty) {
 			list_del_init(&ii->i_dirty);
 			if (force) {
@@ -733,14 +733,14 @@ static void nilfs_dispose_list(struct nilfs_sb_info *sbi,
 			} else if (test_bit(NILFS_I_DIRTY, &ii->i_state)) {
 				set_bit(NILFS_I_QUEUED, &ii->i_state);
 				list_add_tail(&ii->i_dirty,
-					      &sbi->s_dirty_files);
+					      &nilfs->ns_dirty_files);
 				continue;
 			}
 			ivec[nv++] = ii;
 			if (nv == SC_N_INODEVEC)
 				break;
 		}
-		spin_unlock(&sbi->s_inode_lock);
+		spin_unlock(&nilfs->ns_inode_lock);
 
 		for (pii = ivec; nv > 0; pii++, nv--)
 			iput(&(*pii)->vfs_inode);
@@ -773,17 +773,17 @@ static int nilfs_segctor_clean(struct nilfs_sc_info *sci)
 
 static int nilfs_segctor_confirm(struct nilfs_sc_info *sci)
 {
-	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
 	int ret = 0;
 
-	if (nilfs_test_metadata_dirty(sbi->s_nilfs, sci->sc_root))
+	if (nilfs_test_metadata_dirty(nilfs, sci->sc_root))
 		set_bit(NILFS_SC_DIRTY, &sci->sc_flags);
 
-	spin_lock(&sbi->s_inode_lock);
-	if (list_empty(&sbi->s_dirty_files) && nilfs_segctor_clean(sci))
+	spin_lock(&nilfs->ns_inode_lock);
+	if (list_empty(&nilfs->ns_dirty_files) && nilfs_segctor_clean(sci))
 		ret++;
 
-	spin_unlock(&sbi->s_inode_lock);
+	spin_unlock(&nilfs->ns_inode_lock);
 	return ret;
 }
 
@@ -1963,30 +1963,30 @@ static int nilfs_segctor_wait(struct nilfs_sc_info *sci)
 	return ret;
 }
 
-static int nilfs_segctor_check_in_files(struct nilfs_sc_info *sci,
-					struct nilfs_sb_info *sbi)
+static int nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci,
+					     struct the_nilfs *nilfs)
 {
 	struct nilfs_inode_info *ii, *n;
 	struct inode *ifile = sci->sc_root->ifile;
 
-	spin_lock(&sbi->s_inode_lock);
+	spin_lock(&nilfs->ns_inode_lock);
  retry:
-	list_for_each_entry_safe(ii, n, &sbi->s_dirty_files, i_dirty) {
+	list_for_each_entry_safe(ii, n, &nilfs->ns_dirty_files, i_dirty) {
 		if (!ii->i_bh) {
 			struct buffer_head *ibh;
 			int err;
 
-			spin_unlock(&sbi->s_inode_lock);
+			spin_unlock(&nilfs->ns_inode_lock);
 			err = nilfs_ifile_get_inode_block(
 				ifile, ii->vfs_inode.i_ino, &ibh);
 			if (unlikely(err)) {
-				nilfs_warning(sbi->s_super, __func__,
+				nilfs_warning(sci->sc_super, __func__,
 					      "failed to get inode block.\n");
 				return err;
 			}
 			nilfs_mdt_mark_buffer_dirty(ibh);
 			nilfs_mdt_mark_dirty(ifile);
-			spin_lock(&sbi->s_inode_lock);
+			spin_lock(&nilfs->ns_inode_lock);
 			if (likely(!ii->i_bh))
 				ii->i_bh = ibh;
 			else
@@ -1999,18 +1999,18 @@ static int nilfs_segctor_check_in_files(struct nilfs_sc_info *sci,
 		list_del(&ii->i_dirty);
 		list_add_tail(&ii->i_dirty, &sci->sc_dirty_files);
 	}
-	spin_unlock(&sbi->s_inode_lock);
+	spin_unlock(&nilfs->ns_inode_lock);
 
 	return 0;
 }
 
-static void nilfs_segctor_check_out_files(struct nilfs_sc_info *sci,
-					  struct nilfs_sb_info *sbi)
+static void nilfs_segctor_drop_written_files(struct nilfs_sc_info *sci,
+					     struct the_nilfs *nilfs)
 {
 	struct nilfs_transaction_info *ti = current->journal_info;
 	struct nilfs_inode_info *ii, *n;
 
-	spin_lock(&sbi->s_inode_lock);
+	spin_lock(&nilfs->ns_inode_lock);
 	list_for_each_entry_safe(ii, n, &sci->sc_dirty_files, i_dirty) {
 		if (!test_and_clear_bit(NILFS_I_UPDATED, &ii->i_state) ||
 		    test_bit(NILFS_I_DIRTY, &ii->i_state))
@@ -2022,7 +2022,7 @@ static void nilfs_segctor_check_out_files(struct nilfs_sc_info *sci,
 		list_del(&ii->i_dirty);
 		list_add_tail(&ii->i_dirty, &ti->ti_garbage);
 	}
-	spin_unlock(&sbi->s_inode_lock);
+	spin_unlock(&nilfs->ns_inode_lock);
 }
 
 /*
@@ -2038,7 +2038,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 	sci->sc_stage.scnt = NILFS_ST_INIT;
 	sci->sc_cno = nilfs->ns_cno;
 
-	err = nilfs_segctor_check_in_files(sci, sbi);
+	err = nilfs_segctor_collect_dirty_files(sci, nilfs);
 	if (unlikely(err))
 		goto out;
 
@@ -2116,7 +2116,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 	} while (sci->sc_stage.scnt != NILFS_ST_DONE);
 
  out:
-	nilfs_segctor_check_out_files(sci, sbi);
+	nilfs_segctor_drop_written_files(sci, nilfs);
 	return err;
 
  failed_to_write:
@@ -2319,14 +2319,14 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 		return err;
 	}
 
-	spin_lock(&sbi->s_inode_lock);
+	spin_lock(&nilfs->ns_inode_lock);
 	if (!test_bit(NILFS_I_QUEUED, &ii->i_state) &&
 	    !test_bit(NILFS_I_BUSY, &ii->i_state)) {
-		spin_unlock(&sbi->s_inode_lock);
+		spin_unlock(&nilfs->ns_inode_lock);
 		nilfs_transaction_unlock(sbi);
 		return 0;
 	}
-	spin_unlock(&sbi->s_inode_lock);
+	spin_unlock(&nilfs->ns_inode_lock);
 	sci->sc_dsync_inode = ii;
 	sci->sc_dsync_start = start;
 	sci->sc_dsync_end = end;
@@ -2738,10 +2738,10 @@ static void nilfs_segctor_write_out(struct nilfs_sc_info *sci)
  */
 static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 {
-	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
 	int flag;
 
-	up_write(&sbi->s_nilfs->ns_segctor_sem);
+	up_write(&nilfs->ns_segctor_sem);
 
 	spin_lock(&sci->sc_state_lock);
 	nilfs_segctor_kill_thread(sci);
@@ -2755,9 +2755,9 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 	WARN_ON(!list_empty(&sci->sc_copied_buffers));
 
 	if (!list_empty(&sci->sc_dirty_files)) {
-		nilfs_warning(sbi->s_super, __func__,
+		nilfs_warning(sci->sc_super, __func__,
 			      "dirty file(s) after the final construction\n");
-		nilfs_dispose_list(sbi, &sci->sc_dirty_files, 1);
+		nilfs_dispose_list(nilfs, &sci->sc_dirty_files, 1);
 	}
 
 	WARN_ON(!list_empty(&sci->sc_segbufs));
@@ -2765,7 +2765,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 
 	nilfs_put_root(sci->sc_root);
 
-	down_write(&sbi->s_nilfs->ns_segctor_sem);
+	down_write(&nilfs->ns_segctor_sem);
 
 	del_timer_sync(&sci->sc_timer);
 	kfree(sci);
@@ -2829,15 +2829,15 @@ void nilfs_detach_segment_constructor(struct nilfs_sb_info *sbi)
 	}
 
 	/* Force to free the list of dirty files */
-	spin_lock(&sbi->s_inode_lock);
-	if (!list_empty(&sbi->s_dirty_files)) {
-		list_splice_init(&sbi->s_dirty_files, &garbage_list);
+	spin_lock(&nilfs->ns_inode_lock);
+	if (!list_empty(&nilfs->ns_dirty_files)) {
+		list_splice_init(&nilfs->ns_dirty_files, &garbage_list);
 		nilfs_warning(sbi->s_super, __func__,
 			      "Non empty dirty list after the last "
 			      "segment construction\n");
 	}
-	spin_unlock(&sbi->s_inode_lock);
+	spin_unlock(&nilfs->ns_inode_lock);
 	up_write(&nilfs->ns_segctor_sem);
 
-	nilfs_dispose_list(sbi, &garbage_list, 1);
+	nilfs_dispose_list(nilfs, &garbage_list, 1);
 }
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 2f17a2f..6dc8b3c 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -943,9 +943,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (err)
 		goto failed_nilfs;
 
-	spin_lock_init(&sbi->s_inode_lock);
-	INIT_LIST_HEAD(&sbi->s_dirty_files);
-
 	/*
 	 * Following initialization is overlapped because
 	 * nilfs_sb_info structure has been cleared at the beginning.
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index d377533..40239a9 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -75,7 +75,9 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	nilfs->ns_bdev = bdev;
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
+	INIT_LIST_HEAD(&nilfs->ns_dirty_files);
 	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
+	spin_lock_init(&nilfs->ns_inode_lock);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_cptree = RB_ROOT;
 	spin_lock_init(&nilfs->ns_cptree_lock);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 4a9bf39..6106ec5 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -71,6 +71,8 @@ enum {
  * @ns_sufile: segusage file inode
  * @ns_cptree: rb-tree of all mounted checkpoints (nilfs_root)
  * @ns_cptree_lock: lock protecting @ns_cptree
+ * @ns_dirty_files: list of dirty files
+ * @ns_inode_lock: lock protecting @ns_dirty_files
  * @ns_gc_inodes: dummy inodes to keep live blocks
  * @ns_mount_opt: mount options
  * @ns_resuid: uid for reserved blocks
@@ -150,6 +152,10 @@ struct the_nilfs {
 	struct rb_root		ns_cptree;
 	spinlock_t		ns_cptree_lock;
 
+	/* Dirty inode list */
+	struct list_head	ns_dirty_files;
+	spinlock_t		ns_inode_lock;
+
 	/* GC inode list */
 	struct list_head	ns_gc_inodes;
 
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
