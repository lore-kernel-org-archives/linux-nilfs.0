From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/8] nilfs2: move log writer onto nilfs object
Date: Wed,  9 Mar 2011 21:08:10 +0900
Message-ID: <1299672493-28544-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Log writer is held by the nilfs_sb_info structure.  This moves it into
nilfs object and replaces all uses of NILFS_SC() accessor.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sb.h        |    9 -------
 fs/nilfs2/segment.c   |   58 ++++++++++++++++++++++++------------------------
 fs/nilfs2/the_nilfs.h |    6 ++++-
 3 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/fs/nilfs2/sb.h b/fs/nilfs2/sb.h
index 6f190df..44553f4 100644
--- a/fs/nilfs2/sb.h
+++ b/fs/nilfs2/sb.h
@@ -28,7 +28,6 @@
 #include <linux/fs.h>
 
 struct the_nilfs;
-struct nilfs_sc_info;
 
 /*
  * NILFS super-block data in memory
@@ -37,9 +36,6 @@ struct nilfs_sb_info {
 	/* Fundamental members */
 	struct super_block *s_super;	/* reverse pointer to super_block */
 	struct the_nilfs *s_nilfs;
-
-	/* Segment constructor */
-	struct nilfs_sc_info *s_sc_info; /* segment constructor info */
 };
 
 static inline struct nilfs_sb_info *NILFS_SB(struct super_block *sb)
@@ -47,9 +43,4 @@ static inline struct nilfs_sb_info *NILFS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
-static inline struct nilfs_sc_info *NILFS_SC(struct nilfs_sb_info *sbi)
-{
-	return sbi->s_sc_info;
-}
-
 #endif /* _NILFS_SB */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 6ac50d8..e3d1785 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -224,8 +224,7 @@ int nilfs_transaction_begin(struct super_block *sb,
 int nilfs_transaction_commit(struct super_block *sb)
 {
 	struct nilfs_transaction_info *ti = current->journal_info;
-	struct nilfs_sb_info *sbi;
-	struct nilfs_sc_info *sci;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	int err = 0;
 
 	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
@@ -234,16 +233,15 @@ int nilfs_transaction_commit(struct super_block *sb)
 		ti->ti_count--;
 		return 0;
 	}
-	sbi = NILFS_SB(sb);
-	sci = NILFS_SC(sbi);
-	if (sci != NULL) {
+	if (nilfs->ns_writer) {
+		struct nilfs_sc_info *sci = nilfs->ns_writer;
+
 		if (ti->ti_flags & NILFS_TI_COMMIT)
 			nilfs_segctor_start_timer(sci);
-		if (atomic_read(&sbi->s_nilfs->ns_ndirtyblks) >
-		    sci->sc_watermark)
+		if (atomic_read(&nilfs->ns_ndirtyblks) > sci->sc_watermark)
 			nilfs_segctor_do_flush(sci, 0);
 	}
-	up_read(&sbi->s_nilfs->ns_segctor_sem);
+	up_read(&nilfs->ns_segctor_sem);
 	current->journal_info = ti->ti_save;
 
 	if (ti->ti_flags & NILFS_TI_SYNC)
@@ -271,9 +269,8 @@ void nilfs_transaction_abort(struct super_block *sb)
 
 void nilfs_relax_pressure_in_lock(struct super_block *sb)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct nilfs_sc_info *sci = NILFS_SC(sbi);
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
 	if (!sci || !sci->sc_flush_request)
 		return;
@@ -298,6 +295,8 @@ static void nilfs_transaction_lock(struct nilfs_sb_info *sbi,
 				   int gcflag)
 {
 	struct nilfs_transaction_info *cur_ti = current->journal_info;
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
 	WARN_ON(cur_ti);
 	ti->ti_flags = NILFS_TI_WRITER;
@@ -308,11 +307,11 @@ static void nilfs_transaction_lock(struct nilfs_sb_info *sbi,
 	current->journal_info = ti;
 
 	for (;;) {
-		down_write(&sbi->s_nilfs->ns_segctor_sem);
-		if (!test_bit(NILFS_SC_PRIOR_FLUSH, &NILFS_SC(sbi)->sc_flags))
+		down_write(&nilfs->ns_segctor_sem);
+		if (!test_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags))
 			break;
 
-		nilfs_segctor_do_immediate_flush(NILFS_SC(sbi));
+		nilfs_segctor_do_immediate_flush(sci);
 
 		up_write(&sbi->s_nilfs->ns_segctor_sem);
 		yield();
@@ -2169,8 +2168,8 @@ static void nilfs_segctor_do_flush(struct nilfs_sc_info *sci, int bn)
  */
 void nilfs_flush_segment(struct super_block *sb, ino_t ino)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct nilfs_sc_info *sci = NILFS_SC(sbi);
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
 	if (!sci || nilfs_doing_construction())
 		return;
@@ -2259,8 +2258,8 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
  */
 int nilfs_construct_segment(struct super_block *sb)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct nilfs_sc_info *sci = NILFS_SC(sbi);
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info *ti;
 	int err;
 
@@ -2299,7 +2298,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
-	struct nilfs_sc_info *sci = NILFS_SC(sbi);
+	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_inode_info *ii;
 	struct nilfs_transaction_info ti;
 	int err = 0;
@@ -2445,8 +2444,8 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 			 void **kbufs)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct nilfs_sc_info *sci = NILFS_SC(sbi);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info ti;
 	int err;
 
@@ -2787,9 +2786,10 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi,
 				     struct nilfs_root *root)
 {
+	struct the_nilfs *nilfs = sbi->s_nilfs;
 	int err;
 
-	if (NILFS_SC(sbi)) {
+	if (nilfs->ns_writer) {
 		/*
 		 * This happens if the filesystem was remounted
 		 * read/write after nilfs_error degenerated it into a
@@ -2798,14 +2798,14 @@ int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi,
 		nilfs_detach_segment_constructor(sbi);
 	}
 
-	sbi->s_sc_info = nilfs_segctor_new(sbi, root);
-	if (!sbi->s_sc_info)
+	nilfs->ns_writer = nilfs_segctor_new(sbi, root);
+	if (!nilfs->ns_writer)
 		return -ENOMEM;
 
-	err = nilfs_segctor_start_thread(NILFS_SC(sbi));
+	err = nilfs_segctor_start_thread(nilfs->ns_writer);
 	if (err) {
-		kfree(sbi->s_sc_info);
-		sbi->s_sc_info = NULL;
+		kfree(nilfs->ns_writer);
+		nilfs->ns_writer = NULL;
 	}
 	return err;
 }
@@ -2823,9 +2823,9 @@ void nilfs_detach_segment_constructor(struct nilfs_sb_info *sbi)
 	LIST_HEAD(garbage_list);
 
 	down_write(&nilfs->ns_segctor_sem);
-	if (NILFS_SC(sbi)) {
-		nilfs_segctor_destroy(NILFS_SC(sbi));
-		sbi->s_sc_info = NULL;
+	if (nilfs->ns_writer) {
+		nilfs_segctor_destroy(nilfs->ns_writer);
+		nilfs->ns_writer = NULL;
 	}
 
 	/* Force to free the list of dirty files */
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 3ecc968f..10521b9 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -33,6 +33,8 @@
 #include <linux/slab.h>
 #include "sb.h"
 
+struct nilfs_sc_info;
+
 /* the_nilfs struct */
 enum {
 	THE_NILFS_INIT = 0,     /* Information from super_block is set */
@@ -65,7 +67,8 @@ enum {
  * @ns_last_cno: checkpoint number of the latest segment
  * @ns_prot_seq: least sequence number of segments which must not be reclaimed
  * @ns_prev_seq: base sequence number used to decide if advance log cursor
- * @ns_segctor_sem: segment constructor semaphore
+ * @ns_writer: log writer
+ * @ns_segctor_sem: semaphore protecting log write
  * @ns_dat: DAT file inode
  * @ns_cpfile: checkpoint file inode
  * @ns_sufile: segusage file inode
@@ -140,6 +143,7 @@ struct the_nilfs {
 	u64			ns_prot_seq;
 	u64			ns_prev_seq;
 
+	struct nilfs_sc_info   *ns_writer;
 	struct rw_semaphore	ns_segctor_sem;
 
 	/*
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
