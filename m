From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 7/9] nilfs2: ensure that all dirty blocks are written out
Date: Sun,  3 May 2015 12:05:20 +0200
Message-ID: <1430647522-14304-8-git-send-email-andreas.rohner@gmx.net>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430647522-14304-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This patch ensures, that all dirty blocks are written out if the segment
construction mode is SC_LSEG_SR. The scanning of the DAT file can cause
blocks in the SUFILE to be dirtied and newly dirtied blocks in the
SUFILE can in turn dirty more blocks in the DAT file. Since one of
these stages has to happen before the other during segment
construction, we end up with unwritten dirty blocks, that are lost
in case of a file system unmount.

This patch introduces a new set of file scanning operations that
only propagate the changes to the bmap and do not add anything to the
segment buffer. The DAT file and SUFILE are scanned with these
operations. The function nilfs_sufile_flush_cache() is called in between
these scans with the parameter only_mark set. That way it can be called
repeatedly without actually writing anything to the SUFILE. If there are
no new blocks dirtied in the flush, the normal segment construction
stages can safely continue.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/segment.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/segment.h |  3 ++-
 2 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 14e76c3..ab8df33 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -579,6 +579,12 @@ static int nilfs_collect_dat_data(struct nilfs_sc_info *sci,
 	return err;
 }
 
+static int nilfs_collect_prop_data(struct nilfs_sc_info *sci,
+				  struct buffer_head *bh, struct inode *inode)
+{
+	return nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
+}
+
 static int nilfs_collect_dat_bmap(struct nilfs_sc_info *sci,
 				  struct buffer_head *bh, struct inode *inode)
 {
@@ -613,6 +619,14 @@ static struct nilfs_sc_operations nilfs_sc_dat_ops = {
 	.write_node_binfo = nilfs_write_dat_node_binfo,
 };
 
+static struct nilfs_sc_operations nilfs_sc_prop_ops = {
+	.collect_data = nilfs_collect_prop_data,
+	.collect_node = nilfs_collect_file_node,
+	.collect_bmap = NULL,
+	.write_data_binfo = NULL,
+	.write_node_binfo = NULL,
+};
+
 static struct nilfs_sc_operations nilfs_sc_dsync_ops = {
 	.collect_data = nilfs_collect_file_data,
 	.collect_node = NULL,
@@ -998,7 +1012,8 @@ static int nilfs_segctor_scan_file(struct nilfs_sc_info *sci,
 			err = nilfs_segctor_apply_buffers(
 				sci, inode, &data_buffers,
 				sc_ops->collect_data);
-			BUG_ON(!err); /* always receive -E2BIG or true error */
+			/* always receive -E2BIG or true error (NOT ANYMORE?)*/
+			/* BUG_ON(!err); */
 			goto break_or_fail;
 		}
 	}
@@ -1055,6 +1070,55 @@ static int nilfs_segctor_scan_file_dsync(struct nilfs_sc_info *sci,
 	return err;
 }
 
+/**
+ * nilfs_segctor_propagate_sufile - dirties all needed SUFILE blocks
+ * @sci: nilfs_sc_info
+ *
+ * Description: Dirties and propagates all SUFILE blocks that need to be
+ * available later in the segment construction process, when the SUFILE cache
+ * is flushed. Here the SUFILE cache is not actually flushed, but the blocks
+ * that are needed for a later flush are marked as dirty. Since the propagation
+ * of the SUFILE can dirty DAT entries and vice versa, the functions
+ * are executed in a loop until no new blocks are dirtied.
+ *
+ * Return Value: On success, 0 is returned on error, one of the following
+ * negative error codes is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-EROFS - Read only filesystem (for create mode)
+ */
+static int nilfs_segctor_propagate_sufile(struct nilfs_sc_info *sci)
+{
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
+	unsigned long ndirty_blks;
+	int ret, retrycount = NILFS_SC_SUFILE_PROP_RETRY;
+
+	do {
+		/* count changes to DAT file before flush */
+		ret = nilfs_segctor_scan_file(sci, nilfs->ns_dat,
+					      &nilfs_sc_prop_ops);
+		if (unlikely(ret))
+			return ret;
+
+		ret = nilfs_sufile_flush_cache(nilfs->ns_sufile, 1,
+					       &ndirty_blks);
+		if (unlikely(ret))
+			return ret;
+		if (!ndirty_blks)
+			break;
+
+		ret = nilfs_segctor_scan_file(sci, nilfs->ns_sufile,
+					      &nilfs_sc_prop_ops);
+		if (unlikely(ret))
+			return ret;
+	} while (ndirty_blks && retrycount-- > 0);
+
+	return 0;
+}
+
 static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 {
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
@@ -1160,6 +1224,13 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 		}
 		sci->sc_stage.flags |= NILFS_CF_SUFREED;
 
+		if (mode == SC_LSEG_SR &&
+		    nilfs_feature_track_live_blks(nilfs)) {
+			err = nilfs_segctor_propagate_sufile(sci);
+			if (unlikely(err))
+				break;
+		}
+
 		err = nilfs_segctor_scan_file(sci, nilfs->ns_sufile,
 					      &nilfs_sc_file_ops);
 		if (unlikely(err))
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index a48d6de..5aa7f91 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -208,7 +208,8 @@ enum {
  */
 #define NILFS_SC_CLEANUP_RETRY	    3  /* Retry count of construction when
 					  destroying segctord */
-
+#define NILFS_SC_SUFILE_PROP_RETRY  10 /* Retry count of the propagate
+					  sufile loop */
 /*
  * Default values of timeout, in seconds.
  */
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
