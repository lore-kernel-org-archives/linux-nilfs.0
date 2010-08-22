From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 3/6] nilfs2: keep zero value in i_cno except for gc-inodes
Date: Sun, 22 Aug 2010 19:05:03 +0900
Message-ID: <1282471506-29618-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On-memory inode structures of nilfs have a member "i_cno" which stores
a checkpoint number related to the inode.  For gc-inodes, this field
indicates version of data each gc-inode caches for GC.  Log writer
temporarily uses "i_cno" to transfer the latest checkpoint number.

This stops the latter use and lets only gc-inodes use it.

The purpose of this patch is to allow the successive change use
"i_cno" for inode lookup.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/segment.c       |   29 ++++++++++++++---------------
 fs/nilfs2/segment.h       |    3 ++-
 include/linux/nilfs2_fs.h |    8 ++++++++
 3 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9fd051a..eee4b22 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -366,8 +366,7 @@ static int nilfs_segctor_reset_segment_buffer(struct nilfs_sc_info *sci)
 
 	if (nilfs_doing_gc())
 		flags = NILFS_SS_GC;
-	err = nilfs_segbuf_reset(segbuf, flags, sci->sc_seg_ctime,
-				 sci->sc_sbi->s_nilfs->ns_cno);
+	err = nilfs_segbuf_reset(segbuf, flags, sci->sc_seg_ctime, sci->sc_cno);
 	if (unlikely(err))
 		return err;
 
@@ -440,17 +439,26 @@ static void nilfs_segctor_end_finfo(struct nilfs_sc_info *sci,
 	struct nilfs_finfo *finfo;
 	struct nilfs_inode_info *ii;
 	struct nilfs_segment_buffer *segbuf;
+	__u64 cno;
 
 	if (sci->sc_blk_cnt == 0)
 		return;
 
 	ii = NILFS_I(inode);
+
+	if (test_bit(NILFS_I_GCINODE, &ii->i_state))
+		cno = ii->i_cno;
+	else if (NILFS_ROOT_METADATA_FILE(inode->i_ino))
+		cno = 0;
+	else
+		cno = sci->sc_cno;
+
 	finfo = nilfs_segctor_map_segsum_entry(sci, &sci->sc_finfo_ptr,
 						 sizeof(*finfo));
 	finfo->fi_ino = cpu_to_le64(inode->i_ino);
 	finfo->fi_nblocks = cpu_to_le32(sci->sc_blk_cnt);
 	finfo->fi_ndatablk = cpu_to_le32(sci->sc_datablk_cnt);
-	finfo->fi_cno = cpu_to_le64(ii->i_cno);
+	finfo->fi_cno = cpu_to_le64(cno);
 
 	segbuf = sci->sc_curseg;
 	segbuf->sb_sum.sumbytes = sci->sc_binfo_ptr.offset +
@@ -1976,7 +1984,6 @@ static int nilfs_segctor_check_in_files(struct nilfs_sc_info *sci,
 					struct nilfs_sb_info *sbi)
 {
 	struct nilfs_inode_info *ii, *n;
-	__u64 cno = sbi->s_nilfs->ns_cno;
 
 	spin_lock(&sbi->s_inode_lock);
  retry:
@@ -2002,7 +2009,6 @@ static int nilfs_segctor_check_in_files(struct nilfs_sc_info *sci,
 				brelse(ibh);
 			goto retry;
 		}
-		ii->i_cno = cno;
 
 		clear_bit(NILFS_I_QUEUED, &ii->i_state);
 		set_bit(NILFS_I_BUSY, &ii->i_state);
@@ -2011,8 +2017,6 @@ static int nilfs_segctor_check_in_files(struct nilfs_sc_info *sci,
 	}
 	spin_unlock(&sbi->s_inode_lock);
 
-	NILFS_I(sbi->s_ifile)->i_cno = cno;
-
 	return 0;
 }
 
@@ -2021,19 +2025,13 @@ static void nilfs_segctor_check_out_files(struct nilfs_sc_info *sci,
 {
 	struct nilfs_transaction_info *ti = current->journal_info;
 	struct nilfs_inode_info *ii, *n;
-	__u64 cno = sbi->s_nilfs->ns_cno;
 
 	spin_lock(&sbi->s_inode_lock);
 	list_for_each_entry_safe(ii, n, &sci->sc_dirty_files, i_dirty) {
 		if (!test_and_clear_bit(NILFS_I_UPDATED, &ii->i_state) ||
-		    test_bit(NILFS_I_DIRTY, &ii->i_state)) {
-			/* The current checkpoint number (=nilfs->ns_cno) is
-			   changed between check-in and check-out only if the
-			   super root is written out.  So, we can update i_cno
-			   for the inodes that remain in the dirty list. */
-			ii->i_cno = cno;
+		    test_bit(NILFS_I_DIRTY, &ii->i_state))
 			continue;
-		}
+
 		clear_bit(NILFS_I_BUSY, &ii->i_state);
 		brelse(ii->i_bh);
 		ii->i_bh = NULL;
@@ -2054,6 +2052,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 	int err;
 
 	sci->sc_stage.scnt = NILFS_ST_INIT;
+	sci->sc_cno = nilfs->ns_cno;
 
 	err = nilfs_segctor_check_in_files(sci, sbi);
 	if (unlikely(err))
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 17c487b..675d932 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -107,6 +107,7 @@ struct nilfs_segsum_pointer {
  * @sc_datablk_cnt: Data block count of a file
  * @sc_nblk_this_inc: Number of blocks included in the current logical segment
  * @sc_seg_ctime: Creation time
+ * @sc_cno: checkpoint number of current log
  * @sc_flags: Internal flags
  * @sc_state_lock: spinlock for sc_state and so on
  * @sc_state: Segctord state flags
@@ -156,7 +157,7 @@ struct nilfs_sc_info {
 	unsigned long		sc_datablk_cnt;
 	unsigned long		sc_nblk_this_inc;
 	time_t			sc_seg_ctime;
-
+	__u64			sc_cno;
 	unsigned long		sc_flags;
 
 	spinlock_t		sc_state_lock;
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index f5487b6..e30bde6 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -270,6 +270,14 @@ struct nilfs_super_block {
 					   segments */
 
 /*
+ * We call DAT, cpfile, and sufile root metadata files.  Inodes of
+ * these files are written in super root block instead of ifile, and
+ * garbage collector doesn't keep any past versions of these files.
+ */
+#define NILFS_ROOT_METADATA_FILE(ino) \
+	((ino) >= NILFS_DAT_INO && (ino) <= NILFS_SUFILE_INO)
+
+/*
  * bytes offset of secondary super block
  */
 #define NILFS_SB2_OFFSET_BYTES(devsize)	((((devsize) >> 12) - 1) << 12)
-- 
1.6.6.2

