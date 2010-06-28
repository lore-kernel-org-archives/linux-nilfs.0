From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv5 5/5] nilfs2: sync super blocks in turns
Date: Mon, 28 Jun 2010 17:49:33 +0900
Message-ID: <1277714973-12136-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1277714973-12136-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277714973-12136-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This will sync super blocks in turns instead of syncing duplicate
super blocks at the time.  This will help searching valid super root
when super block is written into disk before log is written, which is
happen when barrier-less block devices are unmounted uncleanly.  In
the situation, old super block likely points to valid log.

This patch introduces ns_sbwcount member to the nilfs object and adds
nilfs_sb_will_flip() function; ns_sbwcount counts how many times super
blocks write back to the disk.  And, nilfs_sb_will_flip() decides
whether flipping required or not based on the count of ns_sbwcount to
sync super blocks asymmetrically.

The following functions are also changed:

 - nilfs_prepare_super(): flips super blocks according to the
   argument.  The argument is calculated by nilfs_sb_will_flip()
   function.

 - nilfs_cleanup_super(): sets "clean" flag to both super blocks if
   they point to the same checkpoint.

To update both of super block information, caller of
nilfs_commit_super must set the information on both super blocks.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/nilfs.h     |   11 +++++-
 fs/nilfs2/segment.c   |   10 +++--
 fs/nilfs2/super.c     |   95 +++++++++++++++++++++++++++++++++---------------
 fs/nilfs2/the_nilfs.c |    4 +-
 fs/nilfs2/the_nilfs.h |   17 ++++-----
 5 files changed, 91 insertions(+), 46 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 4626510..36998ea 100644
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
@@ -272,7 +280,8 @@ extern int nilfs_store_magic_and_option(struct super_block *,
 					struct nilfs_super_block *, char *);
 extern void nilfs_set_log_cursor(struct nilfs_super_block *,
 				 struct the_nilfs *);
-extern struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *);
+extern struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *,
+						      int flip);
 extern int nilfs_commit_super(struct nilfs_sb_info *, int);
 extern int nilfs_cleanup_super(struct nilfs_sb_info *);
 extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9e680a9..04e0485 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2425,10 +2425,12 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 		    nilfs_discontinued(nilfs)) {
 			down_write(&nilfs->ns_sem);
 			err = -EIO;
-			sbp = nilfs_prepare_super(sbi);
-			if (likely(sbp))
-				err = nilfs_commit_super(
-					sbi, nilfs_altsb_need_update(nilfs));
+			sbp = nilfs_prepare_super(sbi,
+						  nilfs_sb_will_flip(nilfs));
+			if (likely(sbp)) {
+				nilfs_set_log_cursor(sbp[0], nilfs);
+				err = nilfs_commit_super(sbi, NILFS_SB_COMMIT);
+			}
 			up_write(&nilfs->ns_sem);
 		}
 	}
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index eb7de40..f2cfbba 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -82,10 +82,12 @@ static void nilfs_set_error(struct nilfs_sb_info *sbi)
 	down_write(&nilfs->ns_sem);
 	if (!(nilfs->ns_mount_state & NILFS_ERROR_FS)) {
 		nilfs->ns_mount_state |= NILFS_ERROR_FS;
-		sbp = nilfs_prepare_super(sbi);
+		sbp = nilfs_prepare_super(sbi, 0);
 		if (likely(sbp)) {
 			sbp[0]->s_state |= cpu_to_le16(NILFS_ERROR_FS);
-			nilfs_commit_super(sbi, 1);
+			if (sbp[1])
+				sbp[1]->s_state |= cpu_to_le16(NILFS_ERROR_FS);
+			nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
 		}
 	}
 	up_write(&nilfs->ns_sem);
@@ -184,7 +186,7 @@ static void nilfs_clear_inode(struct inode *inode)
 	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
 }
 
-static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
+static int nilfs_sync_super(struct nilfs_sb_info *sbi, int flag)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	int err;
@@ -210,12 +212,20 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
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
@@ -224,20 +234,21 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
 
 		/* update GC protection for recent segments */
 		if (nilfs->ns_sbh[1]) {
-			sbp = NULL;
-			if (dupsb) {
+			if (flag == NILFS_SB_COMMIT_ALL) {
 				set_buffer_dirty(nilfs->ns_sbh[1]);
-				if (!sync_dirty_buffer(nilfs->ns_sbh[1]))
-					sbp = nilfs->ns_sbp[1];
+				if (sync_dirty_buffer(nilfs->ns_sbh[1]) < 0)
+					goto out;
 			}
+			if (le64_to_cpu(nilfs->ns_sbp[1]->s_last_cno) <
+			    le64_to_cpu(nilfs->ns_sbp[0]->s_last_cno))
+				sbp = nilfs->ns_sbp[1];
 		}
-		if (sbp) {
-			spin_lock(&nilfs->ns_last_segment_lock);
-			nilfs->ns_prot_seq = le64_to_cpu(sbp->s_last_seq);
-			spin_unlock(&nilfs->ns_last_segment_lock);
-		}
-	}
 
+		spin_lock(&nilfs->ns_last_segment_lock);
+		nilfs->ns_prot_seq = le64_to_cpu(sbp->s_last_seq);
+		spin_unlock(&nilfs->ns_last_segment_lock);
+	}
+ out:
 	return err;
 }
 
@@ -257,7 +268,8 @@ void nilfs_set_log_cursor(struct nilfs_super_block *sbp,
 	spin_unlock(&nilfs->ns_last_segment_lock);
 }
 
-struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *sbi)
+struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *sbi,
+					       int flip)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
@@ -266,38 +278,46 @@ struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *sbi)
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
+int nilfs_commit_super(struct nilfs_sb_info *sbi, int flag)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	time_t t;
 
 	/* nilfs->ns_sem must be locked by the caller. */
-	nilfs_set_log_cursor(sbp[0], nilfs);
-
 	t = get_seconds();
-	nilfs->ns_sbwtime[0] = t;
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
 
 /**
@@ -311,12 +331,23 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
 int nilfs_cleanup_super(struct nilfs_sb_info *sbi)
 {
 	struct nilfs_super_block **sbp;
+	int flag = NILFS_SB_COMMIT;
 	int ret = -EIO;
 
-	sbp = nilfs_prepare_super(sbi);
+	sbp = nilfs_prepare_super(sbi, 0);
 	if (sbp) {
 		sbp[0]->s_state = cpu_to_le16(sbi->s_nilfs->ns_mount_state);
-		ret = nilfs_commit_super(sbi, 1);
+		nilfs_set_log_cursor(sbp[0], sbi->s_nilfs);
+		if (sbp[1] && sbp[0]->s_last_cno == sbp[1]->s_last_cno) {
+			/*
+			 * make the "clean" flag also to the opposite
+			 * super block if both super blocks point to
+			 * the same checkpoint.
+			 */
+			sbp[1]->s_state = sbp[0]->s_state;
+			flag = NILFS_SB_COMMIT_ALL;
+		}
+		ret = nilfs_commit_super(sbi, flag);
 	}
 	return ret;
 }
@@ -362,9 +393,11 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 
 	down_write(&nilfs->ns_sem);
 	if (nilfs_sb_dirty(nilfs)) {
-		sbp = nilfs_prepare_super(sbi);
-		if (likely(sbp))
-			nilfs_commit_super(sbi, 1);
+		sbp = nilfs_prepare_super(sbi, nilfs_sb_will_flip(nilfs));
+		if (likely(sbp)) {
+			nilfs_set_log_cursor(sbp[0], nilfs);
+			nilfs_commit_super(sbi, NILFS_SB_COMMIT);
+		}
 	}
 	up_write(&nilfs->ns_sem);
 
@@ -664,7 +697,7 @@ static int nilfs_setup_super(struct nilfs_sb_info *sbi)
 	int mnt_count;
 
 	/* nilfs->ns_sem must be locked by the caller. */
-	sbp = nilfs_prepare_super(sbi);
+	sbp = nilfs_prepare_super(sbi, 0);
 	if (!sbp)
 		return -EIO;
 
@@ -687,7 +720,9 @@ static int nilfs_setup_super(struct nilfs_sb_info *sbi)
 	sbp[0]->s_state =
 		cpu_to_le16(le16_to_cpu(sbp[0]->s_state) & ~NILFS_VALID_FS);
 	sbp[0]->s_mtime = cpu_to_le64(get_seconds());
-	return nilfs_commit_super(sbi, 1);
+	/* synchronize sbp[1] with sbp[0] */
+	memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
+	return nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
 }
 
 struct nilfs_super_block *nilfs_read_super_block(struct super_block *sb,
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index ed58053..530d277 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -513,8 +513,8 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
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
index 191560e..32b4983 100644
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
@@ -119,7 +120,8 @@ struct the_nilfs {
 	 */
 	struct buffer_head     *ns_sbh[2];
 	struct nilfs_super_block *ns_sbp[2];
-	time_t			ns_sbwtime[2];
+	time_t			ns_sbwtime;
+	unsigned		ns_sbwcount;
 	unsigned		ns_sbsize;
 	unsigned		ns_mount_state;
 
@@ -203,20 +205,17 @@ THE_NILFS_FNS(SB_DIRTY, sb_dirty)
 
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
+static inline int nilfs_sb_will_flip(struct the_nilfs *nilfs)
 {
-	u64 t = get_seconds();
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	return sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
+	int flip_bits = nilfs->ns_sbwcount & 0x0FL;
+	return (flip_bits != 0x08 && flip_bits != 0x0F);
 }
 
 void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
