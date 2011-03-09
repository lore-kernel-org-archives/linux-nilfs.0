From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 7/8] nilfs2: use sb instance instead of nilfs_sb_info struct
Date: Wed,  9 Mar 2011 21:08:12 +0900
Message-ID: <1299672493-28544-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This replaces sbi uses with direct reference to sb instance.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/nilfs.h     |   10 ++--
 fs/nilfs2/recovery.c  |   32 +++++++-------
 fs/nilfs2/segment.c   |   90 +++++++++++++++++++-----------------------
 fs/nilfs2/segment.h   |   10 ++---
 fs/nilfs2/super.c     |  105 ++++++++++++++++++++++++-------------------------
 fs/nilfs2/the_nilfs.c |   22 +++++------
 fs/nilfs2/the_nilfs.h |    5 +-
 7 files changed, 129 insertions(+), 145 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 03ba4d8..eba1aaa 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -295,11 +295,11 @@ extern int nilfs_check_feature_compatibility(struct super_block *,
 					     struct nilfs_super_block *);
 extern void nilfs_set_log_cursor(struct nilfs_super_block *,
 				 struct the_nilfs *);
-extern struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *,
-						      int flip);
-extern int nilfs_commit_super(struct nilfs_sb_info *, int);
-extern int nilfs_cleanup_super(struct nilfs_sb_info *);
-int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
+struct nilfs_super_block **nilfs_prepare_super(struct super_block *sb,
+					       int flip);
+int nilfs_commit_super(struct super_block *sb, int flag);
+int nilfs_cleanup_super(struct super_block *sb);
+int nilfs_attach_checkpoint(struct super_block *sb, __u64 cno, int curr_mnt,
 			    struct nilfs_root **root);
 int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno);
 
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 3dfcd3b..ba4a645 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -425,7 +425,7 @@ void nilfs_dispose_segment_list(struct list_head *head)
 }
 
 static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
-					      struct nilfs_sb_info *sbi,
+					      struct super_block *sb,
 					      struct nilfs_recovery_info *ri)
 {
 	struct list_head *head = &ri->ri_used_segments;
@@ -501,7 +501,7 @@ static int nilfs_recovery_copy_block(struct the_nilfs *nilfs,
 }
 
 static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
-				      struct nilfs_sb_info *sbi,
+				      struct super_block *sb,
 				      struct nilfs_root *root,
 				      struct list_head *head,
 				      unsigned long *nr_salvaged_blocks)
@@ -514,7 +514,7 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 	int err = 0, err2 = 0;
 
 	list_for_each_entry_safe(rb, n, head, list) {
-		inode = nilfs_iget(sbi->s_super, root, rb->ino);
+		inode = nilfs_iget(sb, root, rb->ino);
 		if (IS_ERR(inode)) {
 			err = PTR_ERR(inode);
 			inode = NULL;
@@ -572,11 +572,11 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
  * nilfs_do_roll_forward - salvage logical segments newer than the latest
  * checkpoint
  * @nilfs: nilfs object
- * @sbi: nilfs_sb_info
+ * @sb: super block instance
  * @ri: pointer to a nilfs_recovery_info
  */
 static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
-				 struct nilfs_sb_info *sbi,
+				 struct super_block *sb,
 				 struct nilfs_root *root,
 				 struct nilfs_recovery_info *ri)
 {
@@ -648,7 +648,7 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 				goto failed;
 			if (flags & NILFS_SS_LOGEND) {
 				err = nilfs_recover_dsync_blocks(
-					nilfs, sbi, root, &dsync_blocks,
+					nilfs, sb, root, &dsync_blocks,
 					&nsalvaged_blocks);
 				if (unlikely(err))
 					goto failed;
@@ -681,7 +681,7 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 
 	if (nsalvaged_blocks) {
 		printk(KERN_INFO "NILFS (device %s): salvaged %lu blocks\n",
-		       sbi->s_super->s_id, nsalvaged_blocks);
+		       sb->s_id, nsalvaged_blocks);
 		ri->ri_need_recovery = NILFS_RECOVERY_ROLLFORWARD_DONE;
 	}
  out:
@@ -695,7 +695,7 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 	printk(KERN_ERR
 	       "NILFS (device %s): Error roll-forwarding "
 	       "(err=%d, pseg block=%llu). ",
-	       sbi->s_super->s_id, err, (unsigned long long)pseg_start);
+	       sb->s_id, err, (unsigned long long)pseg_start);
 	goto out;
 }
 
@@ -724,7 +724,7 @@ static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
 /**
  * nilfs_salvage_orphan_logs - salvage logs written after the latest checkpoint
  * @nilfs: nilfs object
- * @sbi: nilfs_sb_info
+ * @sb: super block instance
  * @ri: pointer to a nilfs_recovery_info struct to store search results.
  *
  * Return Value: On success, 0 is returned.  On error, one of the following
@@ -741,7 +741,7 @@ static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
  * %-ENOMEM - Insufficient memory available.
  */
 int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
-			      struct nilfs_sb_info *sbi,
+			      struct super_block *sb,
 			      struct nilfs_recovery_info *ri)
 {
 	struct nilfs_root *root;
@@ -750,32 +750,32 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 	if (ri->ri_lsegs_start == 0 || ri->ri_lsegs_end == 0)
 		return 0;
 
-	err = nilfs_attach_checkpoint(sbi, ri->ri_cno, true, &root);
+	err = nilfs_attach_checkpoint(sb, ri->ri_cno, true, &root);
 	if (unlikely(err)) {
 		printk(KERN_ERR
 		       "NILFS: error loading the latest checkpoint.\n");
 		return err;
 	}
 
-	err = nilfs_do_roll_forward(nilfs, sbi, root, ri);
+	err = nilfs_do_roll_forward(nilfs, sb, root, ri);
 	if (unlikely(err))
 		goto failed;
 
 	if (ri->ri_need_recovery == NILFS_RECOVERY_ROLLFORWARD_DONE) {
-		err = nilfs_prepare_segment_for_recovery(nilfs, sbi, ri);
+		err = nilfs_prepare_segment_for_recovery(nilfs, sb, ri);
 		if (unlikely(err)) {
 			printk(KERN_ERR "NILFS: Error preparing segments for "
 			       "recovery.\n");
 			goto failed;
 		}
 
-		err = nilfs_attach_segment_constructor(sbi, root);
+		err = nilfs_attach_log_writer(sb, root);
 		if (unlikely(err))
 			goto failed;
 
 		set_nilfs_discontinued(nilfs);
-		err = nilfs_construct_segment(sbi->s_super);
-		nilfs_detach_segment_constructor(sbi);
+		err = nilfs_construct_segment(sb);
+		nilfs_detach_log_writer(sb);
 
 		if (unlikely(err)) {
 			printk(KERN_ERR "NILFS: Oops! recovery failed. "
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index b14788e..90e3130 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -181,7 +181,6 @@ int nilfs_transaction_begin(struct super_block *sb,
 			    struct nilfs_transaction_info *ti,
 			    int vacancy_check)
 {
-	struct nilfs_sb_info *sbi;
 	struct the_nilfs *nilfs;
 	int ret = nilfs_prepare_segment_lock(ti);
 
@@ -192,8 +191,7 @@ int nilfs_transaction_begin(struct super_block *sb,
 
 	vfs_check_frozen(sb, SB_FREEZE_WRITE);
 
-	sbi = NILFS_SB(sb);
-	nilfs = sbi->s_nilfs;
+	nilfs = NILFS_SB(sb)->s_nilfs;
 	down_read(&nilfs->ns_segctor_sem);
 	if (vacancy_check && nilfs_near_disk_full(nilfs)) {
 		up_read(&nilfs->ns_segctor_sem);
@@ -290,12 +288,12 @@ void nilfs_relax_pressure_in_lock(struct super_block *sb)
 	downgrade_write(&nilfs->ns_segctor_sem);
 }
 
-static void nilfs_transaction_lock(struct nilfs_sb_info *sbi,
+static void nilfs_transaction_lock(struct super_block *sb,
 				   struct nilfs_transaction_info *ti,
 				   int gcflag)
 {
 	struct nilfs_transaction_info *cur_ti = current->journal_info;
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
 	WARN_ON(cur_ti);
@@ -313,17 +311,17 @@ static void nilfs_transaction_lock(struct nilfs_sb_info *sbi,
 
 		nilfs_segctor_do_immediate_flush(sci);
 
-		up_write(&sbi->s_nilfs->ns_segctor_sem);
+		up_write(&nilfs->ns_segctor_sem);
 		yield();
 	}
 	if (gcflag)
 		ti->ti_flags |= NILFS_TI_GC;
 }
 
-static void nilfs_transaction_unlock(struct nilfs_sb_info *sbi)
+static void nilfs_transaction_unlock(struct super_block *sb)
 {
 	struct nilfs_transaction_info *ti = current->journal_info;
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 
 	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
 	BUG_ON(ti->ti_count > 0);
@@ -2292,8 +2290,7 @@ int nilfs_construct_segment(struct super_block *sb)
 int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 				  loff_t start, loff_t end)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_inode_info *ii;
 	struct nilfs_transaction_info ti;
@@ -2302,14 +2299,14 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	if (!sci)
 		return -EROFS;
 
-	nilfs_transaction_lock(sbi, &ti, 0);
+	nilfs_transaction_lock(sb, &ti, 0);
 
 	ii = NILFS_I(inode);
 	if (test_bit(NILFS_I_INODE_DIRTY, &ii->i_state) ||
 	    nilfs_test_opt(nilfs, STRICT_ORDER) ||
 	    test_bit(NILFS_SC_UNCLOSED, &sci->sc_flags) ||
 	    nilfs_discontinued(nilfs)) {
-		nilfs_transaction_unlock(sbi);
+		nilfs_transaction_unlock(sb);
 		err = nilfs_segctor_sync(sci);
 		return err;
 	}
@@ -2318,7 +2315,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	if (!test_bit(NILFS_I_QUEUED, &ii->i_state) &&
 	    !test_bit(NILFS_I_BUSY, &ii->i_state)) {
 		spin_unlock(&nilfs->ns_inode_lock);
-		nilfs_transaction_unlock(sbi);
+		nilfs_transaction_unlock(sb);
 		return 0;
 	}
 	spin_unlock(&nilfs->ns_inode_lock);
@@ -2328,7 +2325,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 
 	err = nilfs_segctor_do_construct(sci, SC_LSEG_DSYNC);
 
-	nilfs_transaction_unlock(sbi);
+	nilfs_transaction_unlock(sb);
 	return err;
 }
 
@@ -2384,8 +2381,7 @@ static void nilfs_segctor_notify(struct nilfs_sc_info *sci, int mode, int err)
  */
 static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sci->sc_super);
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
 	struct nilfs_super_block **sbp;
 	int err = 0;
 
@@ -2403,11 +2399,12 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 		    nilfs_discontinued(nilfs)) {
 			down_write(&nilfs->ns_sem);
 			err = -EIO;
-			sbp = nilfs_prepare_super(sbi,
+			sbp = nilfs_prepare_super(sci->sc_super,
 						  nilfs_sb_will_flip(nilfs));
 			if (likely(sbp)) {
 				nilfs_set_log_cursor(sbp[0], nilfs);
-				err = nilfs_commit_super(sbi, NILFS_SB_COMMIT);
+				err = nilfs_commit_super(sci->sc_super,
+							 NILFS_SB_COMMIT);
 			}
 			up_write(&nilfs->ns_sem);
 		}
@@ -2439,8 +2436,7 @@ nilfs_remove_written_gcinodes(struct the_nilfs *nilfs, struct list_head *head)
 int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 			 void **kbufs)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info ti;
 	int err;
@@ -2448,7 +2444,7 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 	if (unlikely(!sci))
 		return -EROFS;
 
-	nilfs_transaction_lock(sbi, &ti, 1);
+	nilfs_transaction_lock(sb, &ti, 1);
 
 	err = nilfs_mdt_save_to_shadow_map(nilfs->ns_dat);
 	if (unlikely(err))
@@ -2491,16 +2487,15 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 	sci->sc_freesegs = NULL;
 	sci->sc_nfreesegs = 0;
 	nilfs_mdt_clear_shadow_map(nilfs->ns_dat);
-	nilfs_transaction_unlock(sbi);
+	nilfs_transaction_unlock(sb);
 	return err;
 }
 
 static void nilfs_segctor_thread_construct(struct nilfs_sc_info *sci, int mode)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sci->sc_super);
 	struct nilfs_transaction_info ti;
 
-	nilfs_transaction_lock(sbi, &ti, 0);
+	nilfs_transaction_lock(sci->sc_super, &ti, 0);
 	nilfs_segctor_construct(sci, mode);
 
 	/*
@@ -2511,7 +2506,7 @@ static void nilfs_segctor_thread_construct(struct nilfs_sc_info *sci, int mode)
 	if (test_bit(NILFS_SC_UNCLOSED, &sci->sc_flags))
 		nilfs_segctor_start_timer(sci);
 
-	nilfs_transaction_unlock(sbi);
+	nilfs_transaction_unlock(sci->sc_super);
 }
 
 static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *sci)
@@ -2668,17 +2663,17 @@ static void nilfs_segctor_kill_thread(struct nilfs_sc_info *sci)
 /*
  * Setup & clean-up functions
  */
-static struct nilfs_sc_info *nilfs_segctor_new(struct nilfs_sb_info *sbi,
+static struct nilfs_sc_info *nilfs_segctor_new(struct super_block *sb,
 					       struct nilfs_root *root)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct nilfs_sc_info *sci;
 
 	sci = kzalloc(sizeof(*sci), GFP_KERNEL);
 	if (!sci)
 		return NULL;
 
-	sci->sc_super = sbi->s_super;
+	sci->sc_super = sb;
 
 	nilfs_get_root(root);
 	sci->sc_root = root;
@@ -2712,12 +2707,11 @@ static void nilfs_segctor_write_out(struct nilfs_sc_info *sci)
 	/* The segctord thread was stopped and its timer was removed.
 	   But some tasks remain. */
 	do {
-		struct nilfs_sb_info *sbi = NILFS_SB(sci->sc_super);
 		struct nilfs_transaction_info ti;
 
-		nilfs_transaction_lock(sbi, &ti, 0);
+		nilfs_transaction_lock(sci->sc_super, &ti, 0);
 		ret = nilfs_segctor_construct(sci, SC_LSEG_SR);
-		nilfs_transaction_unlock(sbi);
+		nilfs_transaction_unlock(sci->sc_super);
 
 	} while (ret && retrycount-- > 0);
 }
@@ -2766,22 +2760,21 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 }
 
 /**
- * nilfs_attach_segment_constructor - attach a segment constructor
- * @sbi: nilfs_sb_info
+ * nilfs_attach_log_writer - attach log writer
+ * @sb: super block instance
  * @root: root object of the current filesystem tree
  *
- * nilfs_attach_segment_constructor() allocates a struct nilfs_sc_info,
- * initializes it, and starts the segment constructor.
+ * This allocates a log writer object, initializes it, and starts the
+ * log writer.
  *
  * Return Value: On success, 0 is returned. On error, one of the following
  * negative error code is returned.
  *
  * %-ENOMEM - Insufficient memory available.
  */
-int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi,
-				     struct nilfs_root *root)
+int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	int err;
 
 	if (nilfs->ns_writer) {
@@ -2790,10 +2783,10 @@ int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi,
 		 * read/write after nilfs_error degenerated it into a
 		 * read-only mount.
 		 */
-		nilfs_detach_segment_constructor(sbi);
+		nilfs_detach_log_writer(sb);
 	}
 
-	nilfs->ns_writer = nilfs_segctor_new(sbi, root);
+	nilfs->ns_writer = nilfs_segctor_new(sb, root);
 	if (!nilfs->ns_writer)
 		return -ENOMEM;
 
@@ -2806,15 +2799,15 @@ int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi,
 }
 
 /**
- * nilfs_detach_segment_constructor - destroy the segment constructor
- * @sbi: nilfs_sb_info
+ * nilfs_detach_log_writer - destroy log writer
+ * @sb: super block instance
  *
- * nilfs_detach_segment_constructor() kills the segment constructor daemon,
- * frees the struct nilfs_sc_info, and destroy the dirty file list.
+ * This kills log writer daemon, frees the log writer object, and
+ * destroys list of dirty files.
  */
-void nilfs_detach_segment_constructor(struct nilfs_sb_info *sbi)
+void nilfs_detach_log_writer(struct super_block *sb)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	LIST_HEAD(garbage_list);
 
 	down_write(&nilfs->ns_segctor_sem);
@@ -2827,9 +2820,8 @@ void nilfs_detach_segment_constructor(struct nilfs_sb_info *sbi)
 	spin_lock(&nilfs->ns_inode_lock);
 	if (!list_empty(&nilfs->ns_dirty_files)) {
 		list_splice_init(&nilfs->ns_dirty_files, &garbage_list);
-		nilfs_warning(sbi->s_super, __func__,
-			      "Non empty dirty list after the last "
-			      "segment construction\n");
+		nilfs_warning(sb, __func__,
+			      "Hit dirty file after stopped log writer\n");
 	}
 	spin_unlock(&nilfs->ns_inode_lock);
 	up_write(&nilfs->ns_segctor_sem);
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 9544aa9..e01998e 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -233,18 +233,16 @@ extern void nilfs_flush_segment(struct super_block *, ino_t);
 extern int nilfs_clean_segments(struct super_block *, struct nilfs_argv *,
 				void **);
 
-int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi,
-				     struct nilfs_root *root);
-extern void nilfs_detach_segment_constructor(struct nilfs_sb_info *);
+int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root);
+void nilfs_detach_log_writer(struct super_block *sb);
 
 /* recovery.c */
 extern int nilfs_read_super_root_block(struct the_nilfs *, sector_t,
 				       struct buffer_head **, int);
 extern int nilfs_search_super_root(struct the_nilfs *,
 				   struct nilfs_recovery_info *);
-extern int nilfs_salvage_orphan_logs(struct the_nilfs *,
-				     struct nilfs_sb_info *,
-				     struct nilfs_recovery_info *);
+int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs, struct super_block *sb,
+			      struct nilfs_recovery_info *ri);
 extern void nilfs_dispose_segment_list(struct list_head *);
 
 #endif /* _NILFS_SEGMENT_H */
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1368c42..a8cbd69 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -71,23 +71,23 @@ struct kmem_cache *nilfs_transaction_cachep;
 struct kmem_cache *nilfs_segbuf_cachep;
 struct kmem_cache *nilfs_btree_path_cache;
 
-static int nilfs_setup_super(struct nilfs_sb_info *sbi, int is_mount);
+static int nilfs_setup_super(struct super_block *sb, int is_mount);
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 
-static void nilfs_set_error(struct nilfs_sb_info *sbi)
+static void nilfs_set_error(struct super_block *sb)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct nilfs_super_block **sbp;
 
 	down_write(&nilfs->ns_sem);
 	if (!(nilfs->ns_mount_state & NILFS_ERROR_FS)) {
 		nilfs->ns_mount_state |= NILFS_ERROR_FS;
-		sbp = nilfs_prepare_super(sbi, 0);
+		sbp = nilfs_prepare_super(sb, 0);
 		if (likely(sbp)) {
 			sbp[0]->s_state |= cpu_to_le16(NILFS_ERROR_FS);
 			if (sbp[1])
 				sbp[1]->s_state |= cpu_to_le16(NILFS_ERROR_FS);
-			nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
+			nilfs_commit_super(sb, NILFS_SB_COMMIT_ALL);
 		}
 	}
 	up_write(&nilfs->ns_sem);
@@ -108,7 +108,7 @@ static void nilfs_set_error(struct nilfs_sb_info *sbi)
 void nilfs_error(struct super_block *sb, const char *function,
 		 const char *fmt, ...)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct va_format vaf;
 	va_list args;
 
@@ -123,7 +123,7 @@ void nilfs_error(struct super_block *sb, const char *function,
 	va_end(args);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		nilfs_set_error(sbi);
+		nilfs_set_error(sb);
 
 		if (nilfs_test_opt(nilfs, ERRORS_RO)) {
 			printk(KERN_CRIT "Remounting filesystem read-only\n");
@@ -188,9 +188,9 @@ void nilfs_destroy_inode(struct inode *inode)
 	call_rcu(&inode->i_rcu, nilfs_i_callback);
 }
 
-static int nilfs_sync_super(struct nilfs_sb_info *sbi, int flag)
+static int nilfs_sync_super(struct super_block *sb, int flag)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	int err;
 
  retry:
@@ -262,10 +262,10 @@ void nilfs_set_log_cursor(struct nilfs_super_block *sbp,
 	spin_unlock(&nilfs->ns_last_segment_lock);
 }
 
-struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *sbi,
+struct nilfs_super_block **nilfs_prepare_super(struct super_block *sb,
 					       int flip)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 
 	/* nilfs->ns_sem must be locked by the caller. */
@@ -275,7 +275,7 @@ struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *sbi,
 			memcpy(sbp[0], sbp[1], nilfs->ns_sbsize);
 		} else {
 			printk(KERN_CRIT "NILFS: superblock broke on dev %s\n",
-			       sbi->s_super->s_id);
+			       sb->s_id);
 			return NULL;
 		}
 	} else if (sbp[1] &&
@@ -289,9 +289,9 @@ struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *sbi,
 	return sbp;
 }
 
-int nilfs_commit_super(struct nilfs_sb_info *sbi, int flag)
+int nilfs_commit_super(struct super_block *sb, int flag)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	time_t t;
 
@@ -311,27 +311,28 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int flag)
 					    nilfs->ns_sbsize));
 	}
 	clear_nilfs_sb_dirty(nilfs);
-	return nilfs_sync_super(sbi, flag);
+	return nilfs_sync_super(sb, flag);
 }
 
 /**
  * nilfs_cleanup_super() - write filesystem state for cleanup
- * @sbi: nilfs_sb_info to be unmounted or degraded to read-only
+ * @sb: super block instance to be unmounted or degraded to read-only
  *
  * This function restores state flags in the on-disk super block.
  * This will set "clean" flag (i.e. NILFS_VALID_FS) unless the
  * filesystem was not clean previously.
  */
-int nilfs_cleanup_super(struct nilfs_sb_info *sbi)
+int nilfs_cleanup_super(struct super_block *sb)
 {
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct nilfs_super_block **sbp;
 	int flag = NILFS_SB_COMMIT;
 	int ret = -EIO;
 
-	sbp = nilfs_prepare_super(sbi, 0);
+	sbp = nilfs_prepare_super(sb, 0);
 	if (sbp) {
-		sbp[0]->s_state = cpu_to_le16(sbi->s_nilfs->ns_mount_state);
-		nilfs_set_log_cursor(sbp[0], sbi->s_nilfs);
+		sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
+		nilfs_set_log_cursor(sbp[0], nilfs);
 		if (sbp[1] && sbp[0]->s_last_cno == sbp[1]->s_last_cno) {
 			/*
 			 * make the "clean" flag also to the opposite
@@ -341,7 +342,7 @@ int nilfs_cleanup_super(struct nilfs_sb_info *sbi)
 			sbp[1]->s_state = sbp[0]->s_state;
 			flag = NILFS_SB_COMMIT_ALL;
 		}
-		ret = nilfs_commit_super(sbi, flag);
+		ret = nilfs_commit_super(sb, flag);
 	}
 	return ret;
 }
@@ -351,11 +352,11 @@ static void nilfs_put_super(struct super_block *sb)
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 
-	nilfs_detach_segment_constructor(sbi);
+	nilfs_detach_log_writer(sb);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_write(&nilfs->ns_sem);
-		nilfs_cleanup_super(sbi);
+		nilfs_cleanup_super(sb);
 		up_write(&nilfs->ns_sem);
 	}
 
@@ -371,8 +372,7 @@ static void nilfs_put_super(struct super_block *sb)
 
 static int nilfs_sync_fs(struct super_block *sb, int wait)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct nilfs_super_block **sbp;
 	int err = 0;
 
@@ -382,10 +382,10 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 
 	down_write(&nilfs->ns_sem);
 	if (nilfs_sb_dirty(nilfs)) {
-		sbp = nilfs_prepare_super(sbi, nilfs_sb_will_flip(nilfs));
+		sbp = nilfs_prepare_super(sb, nilfs_sb_will_flip(nilfs));
 		if (likely(sbp)) {
 			nilfs_set_log_cursor(sbp[0], nilfs);
-			nilfs_commit_super(sbi, NILFS_SB_COMMIT);
+			nilfs_commit_super(sb, NILFS_SB_COMMIT);
 		}
 	}
 	up_write(&nilfs->ns_sem);
@@ -393,10 +393,10 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 	return err;
 }
 
-int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
+int nilfs_attach_checkpoint(struct super_block *sb, __u64 cno, int curr_mnt,
 			    struct nilfs_root **rootp)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct nilfs_root *root;
 	struct nilfs_checkpoint *raw_cp;
 	struct buffer_head *bh_cp;
@@ -425,7 +425,7 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
 		goto failed;
 	}
 
-	err = nilfs_ifile_read(sbi->s_super, root, nilfs->ns_inode_size,
+	err = nilfs_ifile_read(sb, root, nilfs->ns_inode_size,
 			       &raw_cp->cp_ifile_inode, &root->ifile);
 	if (err)
 		goto failed_bh;
@@ -449,8 +449,7 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
 
 static int nilfs_freeze(struct super_block *sb)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	int err;
 
 	if (sb->s_flags & MS_RDONLY)
@@ -458,21 +457,20 @@ static int nilfs_freeze(struct super_block *sb)
 
 	/* Mark super block clean */
 	down_write(&nilfs->ns_sem);
-	err = nilfs_cleanup_super(sbi);
+	err = nilfs_cleanup_super(sb);
 	up_write(&nilfs->ns_sem);
 	return err;
 }
 
 static int nilfs_unfreeze(struct super_block *sb)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
 	down_write(&nilfs->ns_sem);
-	nilfs_setup_super(sbi, false);
+	nilfs_setup_super(sb, false);
 	up_write(&nilfs->ns_sem);
 	return 0;
 }
@@ -668,15 +666,15 @@ nilfs_set_default_options(struct super_block *sb,
 		NILFS_MOUNT_ERRORS_RO | NILFS_MOUNT_BARRIER;
 }
 
-static int nilfs_setup_super(struct nilfs_sb_info *sbi, int is_mount)
+static int nilfs_setup_super(struct super_block *sb, int is_mount)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct nilfs_super_block **sbp;
 	int max_mnt_count;
 	int mnt_count;
 
 	/* nilfs->ns_sem must be locked by the caller. */
-	sbp = nilfs_prepare_super(sbi, 0);
+	sbp = nilfs_prepare_super(sb, 0);
 	if (!sbp)
 		return -EIO;
 
@@ -707,7 +705,7 @@ skip_mount_setup:
 	/* synchronize sbp[1] with sbp[0] */
 	if (sbp[1])
 		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
-	return nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
+	return nilfs_commit_super(sb, NILFS_SB_COMMIT_ALL);
 }
 
 struct nilfs_super_block *nilfs_read_super_block(struct super_block *sb,
@@ -841,7 +839,7 @@ static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
 		goto out;
 	}
 
-	ret = nilfs_attach_checkpoint(NILFS_SB(s), cno, false, &root);
+	ret = nilfs_attach_checkpoint(s, cno, false, &root);
 	if (ret) {
 		printk(KERN_ERR "NILFS: error loading snapshot "
 		       "(checkpoint number=%llu).\n",
@@ -938,7 +936,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	sbi->s_nilfs = nilfs;
 
-	err = init_nilfs(nilfs, sbi, (char *)data);
+	err = init_nilfs(nilfs, sb, (char *)data);
 	if (err)
 		goto failed_nilfs;
 
@@ -950,12 +948,12 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	bdi = sb->s_bdev->bd_inode->i_mapping->backing_dev_info;
 	sb->s_bdi = bdi ? : &default_backing_dev_info;
 
-	err = load_nilfs(nilfs, sbi);
+	err = load_nilfs(nilfs, sb);
 	if (err)
 		goto failed_nilfs;
 
 	cno = nilfs_last_cno(nilfs);
-	err = nilfs_attach_checkpoint(sbi, cno, true, &fsroot);
+	err = nilfs_attach_checkpoint(sb, cno, true, &fsroot);
 	if (err) {
 		printk(KERN_ERR "NILFS: error loading last checkpoint "
 		       "(checkpoint number=%llu).\n", (unsigned long long)cno);
@@ -963,7 +961,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		err = nilfs_attach_segment_constructor(sbi, fsroot);
+		err = nilfs_attach_log_writer(sb, fsroot);
 		if (err)
 			goto failed_checkpoint;
 	}
@@ -976,14 +974,14 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_write(&nilfs->ns_sem);
-		nilfs_setup_super(sbi, true);
+		nilfs_setup_super(sb, true);
 		up_write(&nilfs->ns_sem);
 	}
 
 	return 0;
 
  failed_segctor:
-	nilfs_detach_segment_constructor(sbi);
+	nilfs_detach_log_writer(sb);
 
  failed_checkpoint:
 	nilfs_put_root(fsroot);
@@ -1004,8 +1002,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 
 static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	unsigned long old_sb_flags;
 	unsigned long old_mount_opt;
 	int err;
@@ -1031,8 +1028,8 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		goto out;
 	if (*flags & MS_RDONLY) {
-		/* Shutting down the segment constructor */
-		nilfs_detach_segment_constructor(sbi);
+		/* Shutting down log writer */
+		nilfs_detach_log_writer(sb);
 		sb->s_flags |= MS_RDONLY;
 
 		/*
@@ -1040,7 +1037,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		 * the RDONLY flag and then mark the partition as valid again.
 		 */
 		down_write(&nilfs->ns_sem);
-		nilfs_cleanup_super(sbi);
+		nilfs_cleanup_super(sb);
 		up_write(&nilfs->ns_sem);
 	} else {
 		__u64 features;
@@ -1067,12 +1064,12 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		sb->s_flags &= ~MS_RDONLY;
 
 		root = NILFS_I(sb->s_root->d_inode)->i_root;
-		err = nilfs_attach_segment_constructor(sbi, root);
+		err = nilfs_attach_log_writer(sb, root);
 		if (err)
 			goto restore_opts;
 
 		down_write(&nilfs->ns_sem);
-		nilfs_setup_super(sbi, true);
+		nilfs_setup_super(sb, true);
 		up_write(&nilfs->ns_sem);
 	}
  out:
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 1bf695e..d2acd1a 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -201,16 +201,16 @@ static int nilfs_store_log_cursor(struct the_nilfs *nilfs,
 /**
  * load_nilfs - load and recover the nilfs
  * @nilfs: the_nilfs structure to be released
- * @sbi: nilfs_sb_info used to recover past segment
+ * @sb: super block isntance used to recover past segment
  *
  * load_nilfs() searches and load the latest super root,
  * attaches the last segment, and does recovery if needed.
  * The caller must call this exclusively for simultaneous mounts.
  */
-int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
+int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 {
 	struct nilfs_recovery_info ri;
-	unsigned int s_flags = sbi->s_super->s_flags;
+	unsigned int s_flags = sb->s_flags;
 	int really_read_only = bdev_read_only(nilfs->ns_bdev);
 	int valid_fs = nilfs_valid_fs(nilfs);
 	int err;
@@ -275,7 +275,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 			goto scan_error;
 	}
 
-	err = nilfs_load_super_root(nilfs, sbi->s_super, ri.ri_super_root);
+	err = nilfs_load_super_root(nilfs, sb, ri.ri_super_root);
 	if (unlikely(err)) {
 		printk(KERN_ERR "NILFS: error loading super root.\n");
 		goto failed;
@@ -308,7 +308,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 			err = -EROFS;
 			goto failed_unload;
 		}
-		sbi->s_super->s_flags &= ~MS_RDONLY;
+		sb->s_flags &= ~MS_RDONLY;
 	} else if (nilfs_test_opt(nilfs, NORECOVERY)) {
 		printk(KERN_ERR "NILFS: recovery cancelled because norecovery "
 		       "option was specified for a read/write mount\n");
@@ -316,13 +316,13 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 		goto failed_unload;
 	}
 
-	err = nilfs_salvage_orphan_logs(nilfs, sbi, &ri);
+	err = nilfs_salvage_orphan_logs(nilfs, sb, &ri);
 	if (err)
 		goto failed_unload;
 
 	down_write(&nilfs->ns_sem);
 	nilfs->ns_mount_state |= NILFS_VALID_FS; /* set "clean" flag */
-	err = nilfs_cleanup_super(sbi);
+	err = nilfs_cleanup_super(sb);
 	up_write(&nilfs->ns_sem);
 
 	if (err) {
@@ -334,7 +334,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 
  skip_recovery:
 	nilfs_clear_recovery_info(&ri);
-	sbi->s_super->s_flags = s_flags;
+	sb->s_flags = s_flags;
 	return 0;
 
  scan_error:
@@ -348,7 +348,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 
  failed:
 	nilfs_clear_recovery_info(&ri);
-	sbi->s_super->s_flags = s_flags;
+	sb->s_flags = s_flags;
 	return err;
 }
 
@@ -526,7 +526,6 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 /**
  * init_nilfs - initialize a NILFS instance.
  * @nilfs: the_nilfs structure
- * @sbi: nilfs_sb_info
  * @sb: super block
  * @data: mount options
  *
@@ -537,9 +536,8 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
  * Return Value: On success, 0 is returned. On error, a negative error
  * code is returned.
  */
-int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
+int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 {
-	struct super_block *sb = sbi->s_super;
 	struct nilfs_super_block *sbp;
 	int blocksize;
 	int err;
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 10521b9..793bd27 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -267,15 +267,14 @@ static inline int nilfs_sb_will_flip(struct the_nilfs *nilfs)
 void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
 struct the_nilfs *alloc_nilfs(struct block_device *bdev);
 void destroy_nilfs(struct the_nilfs *nilfs);
-int init_nilfs(struct the_nilfs *, struct nilfs_sb_info *, char *);
-int load_nilfs(struct the_nilfs *, struct nilfs_sb_info *);
+int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data);
+int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb);
 int nilfs_discard_segments(struct the_nilfs *, __u64 *, size_t);
 int nilfs_count_free_blocks(struct the_nilfs *, sector_t *);
 struct nilfs_root *nilfs_lookup_root(struct the_nilfs *nilfs, __u64 cno);
 struct nilfs_root *nilfs_find_or_create_root(struct the_nilfs *nilfs,
 					     __u64 cno);
 void nilfs_put_root(struct nilfs_root *root);
-struct nilfs_sb_info *nilfs_find_sbinfo(struct the_nilfs *, int, __u64);
 int nilfs_near_disk_full(struct the_nilfs *);
 void nilfs_fall_back_super_block(struct the_nilfs *);
 void nilfs_swap_super_block(struct the_nilfs *);
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
