From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 6/6] nilfs2: get rid of macros for segment summary information
Date: Tue, 25 May 2010 01:39:09 +0900
Message-ID: <1274719149-24371-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1274719149-24371-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1274719149-24371-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This removes macros to test segment summary flags and redefines a few
relevant macros with inline functions.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.h  |   24 +++++++++++++-----------
 fs/nilfs2/segment.c |    8 ++++----
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index fdf1c3b..dabd37f 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -54,17 +54,6 @@ struct nilfs_segsum_info {
 	sector_t		next;
 };
 
-/* macro for the flags */
-#define NILFS_SEG_HAS_SR(sum)    ((sum)->flags & NILFS_SS_SR)
-#define NILFS_SEG_LOGBGN(sum)    ((sum)->flags & NILFS_SS_LOGBGN)
-#define NILFS_SEG_LOGEND(sum)    ((sum)->flags & NILFS_SS_LOGEND)
-#define NILFS_SEG_DSYNC(sum)     ((sum)->flags & NILFS_SS_SYNDT)
-#define NILFS_SEG_SIMPLEX(sum) \
-	(((sum)->flags & (NILFS_SS_LOGBGN | NILFS_SS_LOGEND)) == \
-	 (NILFS_SS_LOGBGN | NILFS_SS_LOGEND))
-
-#define NILFS_SEG_EMPTY(sum)	((sum)->nblocks == (sum)->nsumblk)
-
 /**
  * struct nilfs_segment_buffer - Segment buffer
  * @sb_super: back pointer to a superblock struct
@@ -143,6 +132,19 @@ int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *,
 				struct buffer_head **);
 void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *);
 
+static inline int nilfs_segbuf_simplex(struct nilfs_segment_buffer *segbuf)
+{
+	unsigned int flags = segbuf->sb_sum.flags;
+
+	return (flags & (NILFS_SS_LOGBGN | NILFS_SS_LOGEND)) ==
+		(NILFS_SS_LOGBGN | NILFS_SS_LOGEND);
+}
+
+static inline int nilfs_segbuf_empty(struct nilfs_segment_buffer *segbuf)
+{
+	return segbuf->sb_sum.nblocks == segbuf->sb_sum.nsumblk;
+}
+
 static inline void
 nilfs_segbuf_add_segsum_buffer(struct nilfs_segment_buffer *segbuf,
 			       struct buffer_head *bh)
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index c920164..1f7881c 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1914,12 +1914,12 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 			}
 		}
 
-		if (!NILFS_SEG_SIMPLEX(&segbuf->sb_sum)) {
-			if (NILFS_SEG_LOGBGN(&segbuf->sb_sum)) {
+		if (!nilfs_segbuf_simplex(segbuf)) {
+			if (segbuf->sb_sum.flags & NILFS_SS_LOGBGN) {
 				set_bit(NILFS_SC_UNCLOSED, &sci->sc_flags);
 				sci->sc_lseg_stime = jiffies;
 			}
-			if (NILFS_SEG_LOGEND(&segbuf->sb_sum))
+			if (segbuf->sb_sum.flags & NILFS_SS_LOGEND)
 				clear_bit(NILFS_SC_UNCLOSED, &sci->sc_flags);
 		}
 	}
@@ -2082,7 +2082,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 
 		/* Avoid empty segment */
 		if (sci->sc_stage.scnt == NILFS_ST_DONE &&
-		    NILFS_SEG_EMPTY(&sci->sc_curseg->sb_sum)) {
+		    nilfs_segbuf_empty(sci->sc_curseg)) {
 			nilfs_segctor_abort_construction(sci, nilfs, 1);
 			goto out;
 		}
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
