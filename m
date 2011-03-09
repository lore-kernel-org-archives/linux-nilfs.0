From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/8] nilfs2: move mount options to nilfs object
Date: Wed,  9 Mar 2011 21:08:06 +0900
Message-ID: <1299672493-28544-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This moves mount_opt local variable to nilfs object from nilfs_sb_info
struct.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sb.h        |   16 --------------
 fs/nilfs2/segment.c   |    9 ++++---
 fs/nilfs2/super.c     |   56 +++++++++++++++++++++++++-----------------------
 fs/nilfs2/the_nilfs.c |    4 +-
 fs/nilfs2/the_nilfs.h |   18 +++++++++++++++
 5 files changed, 54 insertions(+), 49 deletions(-)

diff --git a/fs/nilfs2/sb.h b/fs/nilfs2/sb.h
index 7a17715..d7346c9 100644
--- a/fs/nilfs2/sb.h
+++ b/fs/nilfs2/sb.h
@@ -34,8 +34,6 @@ struct nilfs_sc_info;
  * NILFS super-block data in memory
  */
 struct nilfs_sb_info {
-	/* Mount options */
-	unsigned long s_mount_opt;
 	uid_t s_resuid;
 	gid_t s_resgid;
 
@@ -68,18 +66,4 @@ static inline struct nilfs_sc_info *NILFS_SC(struct nilfs_sb_info *sbi)
 	return sbi->s_sc_info;
 }
 
-/*
- * Bit operations for the mount option
- */
-#define nilfs_clear_opt(sbi, opt)  \
-	do { (sbi)->s_mount_opt &= ~NILFS_MOUNT_##opt; } while (0)
-#define nilfs_set_opt(sbi, opt)  \
-	do { (sbi)->s_mount_opt |= NILFS_MOUNT_##opt; } while (0)
-#define nilfs_test_opt(sbi, opt)   ((sbi)->s_mount_opt & NILFS_MOUNT_##opt)
-#define nilfs_write_opt(sbi, mask, opt)					\
-	do { (sbi)->s_mount_opt =					\
-		(((sbi)->s_mount_opt & ~NILFS_MOUNT_##mask) |		\
-		 NILFS_MOUNT_##opt);					\
-	} while (0)
-
 #endif /* _NILFS_SB */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 2de9f63..851bcd3 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2298,6 +2298,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 				  loff_t start, loff_t end)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct nilfs_sc_info *sci = NILFS_SC(sbi);
 	struct nilfs_inode_info *ii;
 	struct nilfs_transaction_info ti;
@@ -2310,9 +2311,9 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 
 	ii = NILFS_I(inode);
 	if (test_bit(NILFS_I_INODE_DIRTY, &ii->i_state) ||
-	    nilfs_test_opt(sbi, STRICT_ORDER) ||
+	    nilfs_test_opt(nilfs, STRICT_ORDER) ||
 	    test_bit(NILFS_SC_UNCLOSED, &sci->sc_flags) ||
-	    nilfs_discontinued(sbi->s_nilfs)) {
+	    nilfs_discontinued(nilfs)) {
 		nilfs_transaction_unlock(sbi);
 		err = nilfs_segctor_sync(sci);
 		return err;
@@ -2480,14 +2481,14 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(sci->sc_interval);
 	}
-	if (nilfs_test_opt(sbi, DISCARD)) {
+	if (nilfs_test_opt(nilfs, DISCARD)) {
 		int ret = nilfs_discard_segments(nilfs, sci->sc_freesegs,
 						 sci->sc_nfreesegs);
 		if (ret) {
 			printk(KERN_WARNING
 			       "NILFS warning: error %d on discard request, "
 			       "turning discards off for the device\n", ret);
-			nilfs_clear_opt(sbi, DISCARD);
+			nilfs_clear_opt(nilfs, DISCARD);
 		}
 	}
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1673b3d..0576cb2 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -109,7 +109,7 @@ static void nilfs_set_error(struct nilfs_sb_info *sbi)
 void nilfs_error(struct super_block *sb, const char *function,
 		 const char *fmt, ...)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct va_format vaf;
 	va_list args;
 
@@ -126,13 +126,13 @@ void nilfs_error(struct super_block *sb, const char *function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		nilfs_set_error(sbi);
 
-		if (nilfs_test_opt(sbi, ERRORS_RO)) {
+		if (nilfs_test_opt(nilfs, ERRORS_RO)) {
 			printk(KERN_CRIT "Remounting filesystem read-only\n");
 			sb->s_flags |= MS_RDONLY;
 		}
 	}
 
-	if (nilfs_test_opt(sbi, ERRORS_PANIC))
+	if (nilfs_test_opt(nilfs, ERRORS_PANIC))
 		panic("NILFS (device %s): panic forced after error\n",
 		      sb->s_id);
 }
@@ -196,7 +196,7 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int flag)
 
  retry:
 	set_buffer_dirty(nilfs->ns_sbh[0]);
-	if (nilfs_test_opt(sbi, BARRIER)) {
+	if (nilfs_test_opt(nilfs, BARRIER)) {
 		err = __sync_dirty_buffer(nilfs->ns_sbh[0],
 					  WRITE_SYNC | WRITE_FLUSH_FUA);
 	} else {
@@ -530,22 +530,22 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 static int nilfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
 	struct super_block *sb = vfs->mnt_sb;
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct nilfs_root *root = NILFS_I(vfs->mnt_root->d_inode)->i_root;
 
-	if (!nilfs_test_opt(sbi, BARRIER))
+	if (!nilfs_test_opt(nilfs, BARRIER))
 		seq_puts(seq, ",nobarrier");
 	if (root->cno != NILFS_CPTREE_CURRENT_CNO)
 		seq_printf(seq, ",cp=%llu", (unsigned long long)root->cno);
-	if (nilfs_test_opt(sbi, ERRORS_PANIC))
+	if (nilfs_test_opt(nilfs, ERRORS_PANIC))
 		seq_puts(seq, ",errors=panic");
-	if (nilfs_test_opt(sbi, ERRORS_CONT))
+	if (nilfs_test_opt(nilfs, ERRORS_CONT))
 		seq_puts(seq, ",errors=continue");
-	if (nilfs_test_opt(sbi, STRICT_ORDER))
+	if (nilfs_test_opt(nilfs, STRICT_ORDER))
 		seq_puts(seq, ",order=strict");
-	if (nilfs_test_opt(sbi, NORECOVERY))
+	if (nilfs_test_opt(nilfs, NORECOVERY))
 		seq_puts(seq, ",norecovery");
-	if (nilfs_test_opt(sbi, DISCARD))
+	if (nilfs_test_opt(nilfs, DISCARD))
 		seq_puts(seq, ",discard");
 
 	return 0;
@@ -594,7 +594,7 @@ static match_table_t tokens = {
 
 static int parse_options(char *options, struct super_block *sb, int is_remount)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 
@@ -609,29 +609,29 @@ static int parse_options(char *options, struct super_block *sb, int is_remount)
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_barrier:
-			nilfs_set_opt(sbi, BARRIER);
+			nilfs_set_opt(nilfs, BARRIER);
 			break;
 		case Opt_nobarrier:
-			nilfs_clear_opt(sbi, BARRIER);
+			nilfs_clear_opt(nilfs, BARRIER);
 			break;
 		case Opt_order:
 			if (strcmp(args[0].from, "relaxed") == 0)
 				/* Ordered data semantics */
-				nilfs_clear_opt(sbi, STRICT_ORDER);
+				nilfs_clear_opt(nilfs, STRICT_ORDER);
 			else if (strcmp(args[0].from, "strict") == 0)
 				/* Strict in-order semantics */
-				nilfs_set_opt(sbi, STRICT_ORDER);
+				nilfs_set_opt(nilfs, STRICT_ORDER);
 			else
 				return 0;
 			break;
 		case Opt_err_panic:
-			nilfs_write_opt(sbi, ERROR_MODE, ERRORS_PANIC);
+			nilfs_write_opt(nilfs, ERROR_MODE, ERRORS_PANIC);
 			break;
 		case Opt_err_ro:
-			nilfs_write_opt(sbi, ERROR_MODE, ERRORS_RO);
+			nilfs_write_opt(nilfs, ERROR_MODE, ERRORS_RO);
 			break;
 		case Opt_err_cont:
-			nilfs_write_opt(sbi, ERROR_MODE, ERRORS_CONT);
+			nilfs_write_opt(nilfs, ERROR_MODE, ERRORS_CONT);
 			break;
 		case Opt_snapshot:
 			if (is_remount) {
@@ -642,13 +642,13 @@ static int parse_options(char *options, struct super_block *sb, int is_remount)
 			}
 			break;
 		case Opt_norecovery:
-			nilfs_set_opt(sbi, NORECOVERY);
+			nilfs_set_opt(nilfs, NORECOVERY);
 			break;
 		case Opt_discard:
-			nilfs_set_opt(sbi, DISCARD);
+			nilfs_set_opt(nilfs, DISCARD);
 			break;
 		case Opt_nodiscard:
-			nilfs_clear_opt(sbi, DISCARD);
+			nilfs_clear_opt(nilfs, DISCARD);
 			break;
 		default:
 			printk(KERN_ERR
@@ -660,10 +660,12 @@ static int parse_options(char *options, struct super_block *sb, int is_remount)
 }
 
 static inline void
-nilfs_set_default_options(struct nilfs_sb_info *sbi,
+nilfs_set_default_options(struct super_block *sb,
 			  struct nilfs_super_block *sbp)
 {
-	sbi->s_mount_opt =
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+
+	nilfs->ns_mount_opt =
 		NILFS_MOUNT_ERRORS_RO | NILFS_MOUNT_BARRIER;
 }
 
@@ -736,7 +738,7 @@ int nilfs_store_magic_and_option(struct super_block *sb,
 	sb->s_flags |= MS_NOATIME;
 #endif
 
-	nilfs_set_default_options(sbi, sbp);
+	nilfs_set_default_options(sb, sbp);
 
 	sbi->s_resuid = le16_to_cpu(sbp->s_def_resuid);
 	sbi->s_resgid = le16_to_cpu(sbp->s_def_resgid);
@@ -1023,7 +1025,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	int err;
 
 	old_sb_flags = sb->s_flags;
-	old_mount_opt = sbi->s_mount_opt;
+	old_mount_opt = nilfs->ns_mount_opt;
 
 	if (!parse_options(data, sb, 1)) {
 		err = -EINVAL;
@@ -1092,7 +1094,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 
  restore_opts:
 	sb->s_flags = old_sb_flags;
-	sbi->s_mount_opt = old_mount_opt;
+	nilfs->ns_mount_opt = old_mount_opt;
 	return err;
 }
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 9098909..d377533 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -283,7 +283,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	if (s_flags & MS_RDONLY) {
 		__u64 features;
 
-		if (nilfs_test_opt(sbi, NORECOVERY)) {
+		if (nilfs_test_opt(nilfs, NORECOVERY)) {
 			printk(KERN_INFO "NILFS: norecovery option specified. "
 			       "skipping roll-forward recovery\n");
 			goto skip_recovery;
@@ -305,7 +305,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 			goto failed_unload;
 		}
 		sbi->s_super->s_flags &= ~MS_RDONLY;
-	} else if (nilfs_test_opt(sbi, NORECOVERY)) {
+	} else if (nilfs_test_opt(nilfs, NORECOVERY)) {
 		printk(KERN_ERR "NILFS: recovery cancelled because norecovery "
 		       "option was specified for a read/write mount\n");
 		err = -EINVAL;
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index fd85e4c..4382780 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -72,6 +72,7 @@ enum {
  * @ns_cptree: rb-tree of all mounted checkpoints (nilfs_root)
  * @ns_cptree_lock: lock protecting @ns_cptree
  * @ns_gc_inodes: dummy inodes to keep live blocks
+ * @ns_mount_opt: mount options
  * @ns_blocksize_bits: bit length of block size
  * @ns_blocksize: block size
  * @ns_nsegments: number of segments in filesystem
@@ -148,6 +149,9 @@ struct the_nilfs {
 	/* GC inode list */
 	struct list_head	ns_gc_inodes;
 
+	/* Mount options */
+	unsigned long		ns_mount_opt;
+
 	/* Disk layout information (static) */
 	unsigned int		ns_blocksize_bits;
 	unsigned int		ns_blocksize;
@@ -180,6 +184,20 @@ THE_NILFS_FNS(DISCONTINUED, discontinued)
 THE_NILFS_FNS(GC_RUNNING, gc_running)
 THE_NILFS_FNS(SB_DIRTY, sb_dirty)
 
+/*
+ * Mount option operations
+ */
+#define nilfs_clear_opt(nilfs, opt)  \
+	do { (nilfs)->ns_mount_opt &= ~NILFS_MOUNT_##opt; } while (0)
+#define nilfs_set_opt(nilfs, opt)  \
+	do { (nilfs)->ns_mount_opt |= NILFS_MOUNT_##opt; } while (0)
+#define nilfs_test_opt(nilfs, opt) ((nilfs)->ns_mount_opt & NILFS_MOUNT_##opt)
+#define nilfs_write_opt(nilfs, mask, opt)				\
+	do { (nilfs)->ns_mount_opt =					\
+		(((nilfs)->ns_mount_opt & ~NILFS_MOUNT_##mask) |	\
+		 NILFS_MOUNT_##opt);					\
+	} while (0)
+
 /**
  * struct nilfs_root - nilfs root object
  * @cno: checkpoint number
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
