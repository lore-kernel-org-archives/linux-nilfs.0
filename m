From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: insert checkpoint number in segment summary header
Date: Sat, 10 Apr 2010 20:07:31 +0900 (JST)
Message-ID: <20100410.200731.57444134.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

This patch extends the format of segment summary so that it stores a
checkpoint number in the header.  This is normally not used, but I
think this would help recovery from critcal situation in which the
filesystem has lost its pointer to the latest log.

I'm planning to send this to the next release unless problem occurs.

Thanks,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds a field to record the latest checkpoint number in the
nilfs_segment_summary structure.  This will help to recover the latest
checkpoint number from logs on disk.  This field is intended for
crucial cases in which super blocks have lost pointer to the latest
log.

Even though this will change the disk format, both backward and
forward compatibility is preserved by a size field prepared in the
segment summary header.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/recovery.c      |    2 ++
 fs/nilfs2/segbuf.c        |    4 +++-
 fs/nilfs2/segbuf.h        |    4 +++-
 fs/nilfs2/segment.c       |    3 ++-
 include/linux/nilfs2_fs.h |    2 ++
 5 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 017bedc..8ad2088 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -104,6 +104,8 @@ static void store_segsum_info(struct nilfs_segsum_info *ssi,
 
 	ssi->nsumblk = DIV_ROUND_UP(ssi->sumbytes, blocksize);
 	ssi->nfileblk = ssi->nblocks - ssi->nsumblk - !!NILFS_SEG_HAS_SR(ssi);
+
+	/* need to verify ->ss_bytes field if read ->ss_cno */
 }
 
 /**
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 35e24ec..0d0a2af 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -133,7 +133,7 @@ int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *segbuf,
 }
 
 int nilfs_segbuf_reset(struct nilfs_segment_buffer *segbuf, unsigned flags,
-		       time_t ctime)
+		       time_t ctime, __u64 cno)
 {
 	int err;
 
@@ -146,6 +146,7 @@ int nilfs_segbuf_reset(struct nilfs_segment_buffer *segbuf, unsigned flags,
 	segbuf->sb_sum.sumbytes = sizeof(struct nilfs_segment_summary);
 	segbuf->sb_sum.nfinfo = segbuf->sb_sum.nfileblk = 0;
 	segbuf->sb_sum.ctime = ctime;
+	segbuf->sb_sum.cno = cno;
 	return 0;
 }
 
@@ -171,6 +172,7 @@ void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *segbuf)
 	raw_sum->ss_nfinfo   = cpu_to_le32(segbuf->sb_sum.nfinfo);
 	raw_sum->ss_sumbytes = cpu_to_le32(segbuf->sb_sum.sumbytes);
 	raw_sum->ss_pad      = 0;
+	raw_sum->ss_cno      = cpu_to_le64(segbuf->sb_sum.cno);
 }
 
 /*
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index e21497f..fdf1c3b 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -37,6 +37,7 @@
  * @sumbytes: Byte count of segment summary
  * @nfileblk: Total number of file blocks
  * @seg_seq: Segment sequence number
+ * @cno: Checkpoint number
  * @ctime: Creation time
  * @next: Block number of the next full segment
  */
@@ -48,6 +49,7 @@ struct nilfs_segsum_info {
 	unsigned long		sumbytes;
 	unsigned long		nfileblk;
 	u64			seg_seq;
+	__u64			cno;
 	time_t			ctime;
 	sector_t		next;
 };
@@ -135,7 +137,7 @@ void nilfs_segbuf_map_cont(struct nilfs_segment_buffer *segbuf,
 			   struct nilfs_segment_buffer *prev);
 void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *, __u64,
 				  struct the_nilfs *);
-int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned, time_t);
+int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned, time_t, __u64);
 int nilfs_segbuf_extend_segsum(struct nilfs_segment_buffer *);
 int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *,
 				struct buffer_head **);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index d7a0d51..f235fc0 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -365,7 +365,8 @@ static int nilfs_segctor_reset_segment_buffer(struct nilfs_sc_info *sci)
 
 	if (nilfs_doing_gc())
 		flags = NILFS_SS_GC;
-	err = nilfs_segbuf_reset(segbuf, flags, sci->sc_seg_ctime);
+	err = nilfs_segbuf_reset(segbuf, flags, sci->sc_seg_ctime,
+				 sci->sc_sbi->s_nilfs->ns_cno);
 	if (unlikely(err))
 		return err;
 
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 640702e..f642e8a 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -377,6 +377,7 @@ union nilfs_binfo {
  * @ss_nfinfo: number of finfo structures
  * @ss_sumbytes: total size of segment summary in bytes
  * @ss_pad: padding
+ * @ss_cno: checkpoint number
  */
 struct nilfs_segment_summary {
 	__le32 ss_datasum;
@@ -391,6 +392,7 @@ struct nilfs_segment_summary {
 	__le32 ss_nfinfo;
 	__le32 ss_sumbytes;
 	__le32 ss_pad;
+	__le64 ss_cno;
 	/* array of finfo structures */
 };
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
