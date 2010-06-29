From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: do not update log cursor for small change
Date: Tue, 29 Jun 2010 14:42:13 +0900
Message-ID: <1277790133-20475-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Super blocks of nilfs are periodically overwritten in order to record
the recent log position.  This shortens recovery time after unclean
unmount, but the current implementation performs the update even for a
few blocks of change.  If the filesystem gets small changes slowly and
continually, super blocks may be updated excessively.

This moderates the issue by skipping update of log cursor if it does
not cross a segment boundary.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c   |    1 -
 fs/nilfs2/the_nilfs.c |   11 +++++++++++
 fs/nilfs2/the_nilfs.h |    2 ++
 3 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 04e0485..9fd051a 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1951,7 +1951,6 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	if (update_sr) {
 		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
 				       segbuf->sb_sum.seg_seq, nilfs->ns_cno++);
-		set_nilfs_sb_dirty(nilfs);
 
 		clear_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 		clear_bit(NILFS_SC_DIRTY, &sci->sc_flags);
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 88c8976..f2efc8c 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -47,6 +47,16 @@ void nilfs_set_last_segment(struct the_nilfs *nilfs,
 	nilfs->ns_last_pseg = start_blocknr;
 	nilfs->ns_last_seq = seq;
 	nilfs->ns_last_cno = cno;
+
+	if (!nilfs_sb_dirty(nilfs)) {
+		if (nilfs->ns_prev_seq == nilfs->ns_last_seq)
+			goto stay_cursor;
+
+		set_nilfs_sb_dirty(nilfs);
+	}
+	nilfs->ns_prev_seq = nilfs->ns_last_seq;
+
+ stay_cursor:
 	spin_unlock(&nilfs->ns_last_segment_lock);
 }
 
@@ -267,6 +277,7 @@ static int nilfs_store_log_cursor(struct the_nilfs *nilfs,
 	nilfs->ns_last_cno = le64_to_cpu(sbp->s_last_cno);
 	nilfs->ns_last_seq = le64_to_cpu(sbp->s_last_seq);
 
+	nilfs->ns_prev_seq = nilfs->ns_last_seq;
 	nilfs->ns_seg_seq = nilfs->ns_last_seq;
 	nilfs->ns_segnum =
 		nilfs_get_segnum_of_block(nilfs, nilfs->ns_last_pseg);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 32b4983..f785a7b 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -74,6 +74,7 @@ enum {
  * @ns_last_seq: sequence value of the latest segment
  * @ns_last_cno: checkpoint number of the latest segment
  * @ns_prot_seq: least sequence number of segments which must not be reclaimed
+ * @ns_prev_seq: base sequence number used to decide if advance log cursor
  * @ns_segctor_sem: segment constructor semaphore
  * @ns_dat: DAT file inode
  * @ns_cpfile: checkpoint file inode
@@ -151,6 +152,7 @@ struct the_nilfs {
 	u64			ns_last_seq;
 	__u64			ns_last_cno;
 	u64			ns_prot_seq;
+	u64			ns_prev_seq;
 
 	struct rw_semaphore	ns_segctor_sem;
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
