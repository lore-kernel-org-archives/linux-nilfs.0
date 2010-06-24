From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv4 2/2] nilfs2: sync super blocks in turns
Date: Fri, 25 Jun 2010 00:27:40 +0900
Message-ID: <1277393260-19835-3-git-send-email-jir@unicus.jp>
References: <1277393260-19835-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277393260-19835-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, ryusuke-sG5X7nlA6pw@public.gmane.org, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This will sync super blocks in turns instead of syncing duplicate
super blocks at the time.  This will help searching valid super root when
super block is written into disk before log is written, which is happen when
barrier-less block devices are unmounted uncleanly.
In the situation, old super block likely points to valid log.

This patch introduces ns_sbwcount member, which counts how many times super
blocks write back to the disk.  Newly introduced nilfs_sb_need_swap() function
decides whether flipping required or not based on the ns_sbwcount to sync
super blocks asymmetrically.

nilfs_prepare_super swaps super blocks according to the argument.
The argument is calculated by nilfs_sb_need_swap() function.

The patch also introduces new function nilfs_set_log_cursor to advance
log cursor for specified super block.  To update both of super block
information, caller of nilfs_commit_super must set the information on both
super blocks.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/nilfs.h     |   13 +++++-
 fs/nilfs2/segment.c   |   10 +++-
 fs/nilfs2/super.c     |  131 ++++++++++++++++++++++++++++++++-----------------
 fs/nilfs2/the_nilfs.c |   10 ++--
 fs/nilfs2/the_nilfs.h |   17 +++---
 5 files changed, 119 insertions(+), 62 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 649e079..63c8fd4 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -107,6 +107,14 @@ enum {
 };
 
 /*
+ * commit flags for nilfs_commit_super and nilfs_sync_super
+ */
+enum {
+	NILFS_SB_COMMIT = 0,	/* Commit a super block alternately */
+	NILFS_SB_COMMIT_ALL	/* Commit both super blocks */
+};
+
+/*
  * Macros to check inode numbers
  */
 #define NILFS_MDT_INO_BITS   \
@@ -270,7 +278,10 @@ extern struct nilfs_super_block *
 nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
 extern int nilfs_store_magic_and_option(struct super_block *,
 					struct nilfs_super_block *, char *);
-extern struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *);
+extern void nilfs_set_log_cursor(struct nilfs_super_block *,
+				 struct the_nilfs *);
+extern struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *,
+						      int flip);
 extern int nilfs_commit_super(struct nilfs_sb_info *, int);
 extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
 extern void nilfs_detach_checkpoint(struct nilfs_sb_info *);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 075d7b0..844743e 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2408,6 +2408,7 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 {
 	struct nilfs_sb_info *sbi = sci->sc_sbi;
 	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_super_block **sbp;
 	int err = 0;
 
 	nilfs_segctor_accept(sci);
@@ -2424,9 +2425,12 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 		    nilfs_discontinued(nilfs)) {
 			down_write(&nilfs->ns_sem);
 			err = -EIO;
-			if (likely(nilfs_prepare_super(sbi)))
-				err = nilfs_commit_super(
-					sbi, nilfs_altsb_need_update(nilfs));
+			sbp = nilfs_prepare_super(sbi,
+						  nilfs_sb_need_swap(nilfs));
+			if (likely(sbp)) {
+				nilfs_set_log_cursor(sbp[0], nilfs);
+				err = nilfs_commit_super(sbi, NILFS_SB_COMMIT);
+			}
 			up_write(&nilfs->ns_sem);
 		}
 	}
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 045b8d7..cd35f73 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -74,6 +74,25 @@ struct kmem_cache *nilfs_btree_path_cache;
 
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 
+static void nilfs_set_error(struct nilfs_sb_info *sbi)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_super_block **sbp;
+
+	down_write(&nilfs->ns_sem);
+	if (!(nilfs->ns_mount_state & NILFS_ERROR_FS)) {
+		nilfs->ns_mount_state |= NILFS_ERROR_FS;
+		sbp = nilfs_prepare_super(sbi, 0);
+		if (likely(sbp)) {
+			sbp[0]->s_state |= cpu_to_le16(NILFS_ERROR_FS);
+			if (sbp[1])
+				sbp[1]->s_state |= cpu_to_le16(NILFS_ERROR_FS);
+			nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
+		}
+	}
+	up_write(&nilfs->ns_sem);
+}
+
 /**
  * nilfs_error() - report failure condition on a filesystem
  *
@@ -90,7 +109,6 @@ void nilfs_error(struct super_block *sb, const char *function,
 		 const char *fmt, ...)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct nilfs_super_block **sbp;
 	va_list args;
 
 	va_start(args, fmt);
@@ -100,18 +118,7 @@ void nilfs_error(struct super_block *sb, const char *function,
 	va_end(args);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		struct the_nilfs *nilfs = sbi->s_nilfs;
-
-		down_write(&nilfs->ns_sem);
-		if (!(nilfs->ns_mount_state & NILFS_ERROR_FS)) {
-			nilfs->ns_mount_state |= NILFS_ERROR_FS;
-			sbp = nilfs_prepare_super(sbi);
-			if (likely(sbp)) {
-				sbp[0]->s_state |= cpu_to_le16(NILFS_ERROR_FS);
-				nilfs_commit_super(sbi, 1);
-			}
-		}
-		up_write(&nilfs->ns_sem);
+		nilfs_set_error(sbi);
 
 		if (nilfs_test_opt(sbi, ERRORS_RO)) {
 			printk(KERN_CRIT "Remounting filesystem read-only\n");
@@ -179,7 +186,7 @@ static void nilfs_clear_inode(struct inode *inode)
 	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
 }
 
-static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
+static int nilfs_sync_super(struct nilfs_sb_info *sbi, int flag)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	int err;
@@ -205,12 +212,20 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
 		printk(KERN_ERR
 		       "NILFS: unable to write superblock (err=%d)\n", err);
 		if (err == -EIO && nilfs->ns_sbh[1]) {
+			/*
+			 * sbp[0] points to newer log than sbp[1],
+			 * so copy sbp[0] to sbp[1] to take over sbp[0].
+			 */
+			memcpy(nilfs->ns_sbp[1], nilfs->ns_sbp[0],
+			       nilfs->ns_sbsize);
 			nilfs_fall_back_super_block(nilfs);
 			goto retry;
 		}
 	} else {
 		struct nilfs_super_block *sbp = nilfs->ns_sbp[0];
 
+		nilfs->ns_sbwcount++;
+
 		/*
 		 * The latest segment becomes trailable from the position
 		 * written in superblock.
@@ -220,11 +235,14 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
 		/* update GC protection for recent segments */
 		if (nilfs->ns_sbh[1]) {
 			sbp = NULL;
-			if (dupsb) {
+			if (flag == NILFS_SB_COMMIT_ALL) {
 				set_buffer_dirty(nilfs->ns_sbh[1]);
 				if (!sync_dirty_buffer(nilfs->ns_sbh[1]))
 					sbp = nilfs->ns_sbp[1];
 			}
+			if (sbp &&
+			    nilfs->ns_sbp[0]->s_last_cno < sbp->s_last_cno)
+				sbp = nilfs->ns_sbp[0];
 		}
 		if (sbp) {
 			spin_lock(&nilfs->ns_last_segment_lock);
@@ -236,7 +254,8 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
 	return err;
 }
 
-struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *sbi)
+struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *sbi,
+					       int flip)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
@@ -245,50 +264,62 @@ struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *sbi)
 	if (sbp[0]->s_magic != cpu_to_le16(NILFS_SUPER_MAGIC)) {
 		if (sbp[1] &&
 		    sbp[1]->s_magic == cpu_to_le16(NILFS_SUPER_MAGIC)) {
-			nilfs_swap_super_block(nilfs);
+			memcpy(sbp[0], sbp[1], nilfs->ns_sbsize);
 		} else {
 			printk(KERN_CRIT "NILFS: superblock broke on dev %s\n",
 			       sbi->s_super->s_id);
 			return NULL;
 		}
+	} else if (sbp[1] &&
+		   sbp[1]->s_magic != cpu_to_le16(NILFS_SUPER_MAGIC)) {
+			memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
 	}
+
+	if (flip && sbp[1])
+		nilfs_swap_super_block(nilfs);
+
 	return sbp;
 }
 
-int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
+void nilfs_set_log_cursor(struct nilfs_super_block *sbp,
+			  struct the_nilfs *nilfs)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	sector_t nfreeblocks;
-	time_t t;
-	int err;
 
 	/* nilfs->ns_sem must be locked by the caller. */
-	err = nilfs_count_free_blocks(nilfs, &nfreeblocks);
-	if (unlikely(err)) {
-		printk(KERN_ERR "NILFS: failed to count free blocks\n");
-		return err;
-	}
+	nilfs_count_free_blocks(nilfs, &nfreeblocks);
+	sbp->s_free_blocks_count = cpu_to_le64(nfreeblocks);
+
 	spin_lock(&nilfs->ns_last_segment_lock);
-	sbp[0]->s_last_seq = cpu_to_le64(nilfs->ns_last_seq);
-	sbp[0]->s_last_pseg = cpu_to_le64(nilfs->ns_last_pseg);
-	sbp[0]->s_last_cno = cpu_to_le64(nilfs->ns_last_cno);
+	sbp->s_last_seq = cpu_to_le64(nilfs->ns_last_seq);
+	sbp->s_last_pseg = cpu_to_le64(nilfs->ns_last_pseg);
+	sbp->s_last_cno = cpu_to_le64(nilfs->ns_last_cno);
 	spin_unlock(&nilfs->ns_last_segment_lock);
+}
+
+int nilfs_commit_super(struct nilfs_sb_info *sbi, int flag)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	time_t t;
 
+	/* nilfs->ns_sem must be locked by the caller. */
 	t = get_seconds();
-	nilfs->ns_sbwtime[0] = t;
-	sbp[0]->s_free_blocks_count = cpu_to_le64(nfreeblocks);
+	nilfs->ns_sbwtime = t;
 	sbp[0]->s_wtime = cpu_to_le64(t);
 	sbp[0]->s_sum = 0;
 	sbp[0]->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
 					     (unsigned char *)sbp[0],
 					     nilfs->ns_sbsize));
-	if (dupsb && sbp[1]) {
-		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
-		nilfs->ns_sbwtime[1] = t;
+	if (flag == NILFS_SB_COMMIT_ALL && sbp[1]) {
+		sbp[1]->s_wtime = sbp[0]->s_wtime;
+		sbp[1]->s_sum = 0;
+		sbp[1]->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
+					    (unsigned char *)sbp[1],
+					    nilfs->ns_sbsize));
 	}
 	clear_nilfs_sb_dirty(nilfs);
-	return nilfs_sync_super(sbi, dupsb);
+	return nilfs_sync_super(sbi, flag);
 }
 
 static void nilfs_put_super(struct super_block *sb)
@@ -303,10 +334,12 @@ static void nilfs_put_super(struct super_block *sb)
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_write(&nilfs->ns_sem);
-		sbp = nilfs_prepare_super(sbi);
+		sbp = nilfs_prepare_super(sbi, 0);
 		if (likely(sbp)) {
+			/* set state only for newer super block */
 			sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
-			nilfs_commit_super(sbi, 1);
+			nilfs_set_log_cursor(sbp[0], nilfs);
+			nilfs_commit_super(sbi, NILFS_SB_COMMIT);
 		}
 		up_write(&nilfs->ns_sem);
 	}
@@ -328,6 +361,7 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_super_block **sbp;
 	int err = 0;
 
 	/* This function is called when super block should be written back */
@@ -335,8 +369,13 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 		err = nilfs_construct_segment(sb);
 
 	down_write(&nilfs->ns_sem);
-	if (nilfs_sb_dirty(nilfs) && nilfs_prepare_super(sbi))
-		nilfs_commit_super(sbi, 1);
+	if (nilfs_sb_dirty(nilfs)) {
+		sbp = nilfs_prepare_super(sbi, nilfs_sb_need_swap(nilfs));
+		if (likely(sbp)) {
+			nilfs_set_log_cursor(sbp[0], nilfs);
+			nilfs_commit_super(sbi, NILFS_SB_COMMIT);
+		}
+	}
 	up_write(&nilfs->ns_sem);
 
 	return err;
@@ -635,14 +674,13 @@ static int nilfs_setup_super(struct nilfs_sb_info *sbi)
 	int mnt_count;
 
 	/* nilfs->ns_sem must be locked by the caller. */
-	sbp = nilfs_prepare_super(sbi);
+	sbp = nilfs_prepare_super(sbi, 0);
 	if (!sbp)
 		return -EIO;
 
 	max_mnt_count = le16_to_cpu(sbp[0]->s_max_mnt_count);
 	mnt_count = le16_to_cpu(sbp[0]->s_mnt_count);
 
-	/* nilfs->ns_sem must be locked by the caller. */
 	if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
 		printk(KERN_WARNING
 		       "NILFS warning: mounting fs with errors\n");
@@ -659,7 +697,9 @@ static int nilfs_setup_super(struct nilfs_sb_info *sbi)
 	sbp[0]->s_state =
 		cpu_to_le16(le16_to_cpu(sbp[0]->s_state) & ~NILFS_VALID_FS);
 	sbp[0]->s_mtime = cpu_to_le64(get_seconds());
-	return nilfs_commit_super(sbi, 1);
+	/* synchronize sbp[1] with sbp[0] */
+	memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
+	return nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
 }
 
 struct nilfs_super_block *nilfs_read_super_block(struct super_block *sb,
@@ -906,14 +946,15 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		 * the RDONLY flag and then mark the partition as valid again.
 		 */
 		down_write(&nilfs->ns_sem);
-		sbp = nilfs_prepare_super(sbi);
+		sbp = nilfs_prepare_super(sbi, 0);
 		if (likely(sbp)) {
 			if (!(sbp[0]->s_state & le16_to_cpu(NILFS_VALID_FS)) &&
 			    (nilfs->ns_mount_state & NILFS_VALID_FS))
 				sbp[0]->s_state =
 					cpu_to_le16(nilfs->ns_mount_state);
 			sbp[0]->s_mtime = cpu_to_le64(get_seconds());
-			nilfs_commit_super(sbi, 1);
+			nilfs_set_log_cursor(sbp[0], nilfs);
+			nilfs_commit_super(sbi, NILFS_SB_COMMIT);
 		}
 		up_write(&nilfs->ns_sem);
 	} else {
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 74b0480..7fdb780 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -326,11 +326,13 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 
 	down_write(&nilfs->ns_sem);
 	err = -EIO;
-	sbp = nilfs_prepare_super(sbi);
+	sbp = nilfs_prepare_super(sbi, 0);
 	if (likely(sbp)) {
 		nilfs->ns_mount_state |= NILFS_VALID_FS;
+		/* set the flag only for newer super block */
 		sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
-		err = nilfs_commit_super(sbi, 1);
+		nilfs_set_log_cursor(sbp[0], nilfs);
+		err = nilfs_commit_super(sbi, NILFS_SB_COMMIT);
 	}
 	up_write(&nilfs->ns_sem);
 
@@ -519,8 +521,8 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 		nilfs_swap_super_block(nilfs);
 	}
 
-	nilfs->ns_sbwtime[0] = le64_to_cpu(sbp[0]->s_wtime);
-	nilfs->ns_sbwtime[1] = valid[!swp] ? le64_to_cpu(sbp[1]->s_wtime) : 0;
+	nilfs->ns_sbwcount = 0;
+	nilfs->ns_sbwtime = le64_to_cpu(sbp[0]->s_wtime);
 	nilfs->ns_prot_seq = le64_to_cpu(sbp[valid[1] & !swp]->s_last_seq);
 	*sbpp = sbp[0];
 	return 0;
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 85df47f..0a44688 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -57,7 +57,8 @@ enum {
  * @ns_current: back pointer to current mount
  * @ns_sbh: buffer heads of on-disk super blocks
  * @ns_sbp: pointers to super block data
- * @ns_sbwtime: previous write time of super blocks
+ * @ns_sbwtime: previous write time of super block
+ * @ns_sbwcount: write count of super block
  * @ns_sbsize: size of valid data in super block
  * @ns_supers: list of nilfs super block structs
  * @ns_seg_seq: segment sequence counter
@@ -120,7 +121,8 @@ struct the_nilfs {
 	 */
 	struct buffer_head     *ns_sbh[2];
 	struct nilfs_super_block *ns_sbp[2];
-	time_t			ns_sbwtime[2];
+	time_t			ns_sbwtime;
+	unsigned		ns_sbwcount;
 	unsigned		ns_sbsize;
 	unsigned		ns_mount_state;
 
@@ -205,20 +207,17 @@ THE_NILFS_FNS(SB_DIRTY, sb_dirty)
 
 /* Minimum interval of periodical update of superblocks (in seconds) */
 #define NILFS_SB_FREQ		10
-#define NILFS_ALTSB_FREQ	60  /* spare superblock */
 
 static inline int nilfs_sb_need_update(struct the_nilfs *nilfs)
 {
 	u64 t = get_seconds();
-	return t < nilfs->ns_sbwtime[0] ||
-		 t > nilfs->ns_sbwtime[0] + NILFS_SB_FREQ;
+	return t < nilfs->ns_sbwtime || t > nilfs->ns_sbwtime + NILFS_SB_FREQ;
 }
 
-static inline int nilfs_altsb_need_update(struct the_nilfs *nilfs)
+static inline int nilfs_sb_need_swap(struct the_nilfs *nilfs)
 {
-	u64 t = get_seconds();
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	return sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
+	int flip_bits = nilfs->ns_sbwcount & 0x0FL;
+	return (flip_bits != 0x08 && flip_bits != 0x0F);
 }
 
 void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
-- 
1.5.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
