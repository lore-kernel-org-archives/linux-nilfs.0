From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/6] nilfs2: add iterator for segment buffers
Date: Mon, 30 Nov 2009 22:30:44 +0900
Message-ID: <1259587845-3436-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1259587845-3436-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1259587845-3436-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds a few iterator functions for segment buffers to make it easy
to handle multiple series of logs.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c  |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/segbuf.h  |   18 ++++++++++--------
 fs/nilfs2/segment.c |   51 ++++++++++++---------------------------------------
 3 files changed, 66 insertions(+), 48 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 636590c..d856d62 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -234,7 +234,7 @@ void nilfs_segbuf_fill_in_data_crc(struct nilfs_segment_buffer *segbuf,
 	raw_sum->ss_datasum = cpu_to_le32(crc);
 }
 
-void nilfs_release_buffers(struct list_head *list)
+static void nilfs_release_buffers(struct list_head *list)
 {
 	struct buffer_head *bh, *n;
 
@@ -256,6 +256,49 @@ void nilfs_release_buffers(struct list_head *list)
 	}
 }
 
+static void nilfs_segbuf_clear(struct nilfs_segment_buffer *segbuf)
+{
+	nilfs_release_buffers(&segbuf->sb_segsum_buffers);
+	nilfs_release_buffers(&segbuf->sb_payload_buffers);
+}
+
+/*
+ * Iterators for segment buffers
+ */
+void nilfs_clear_logs(struct list_head *logs)
+{
+	struct nilfs_segment_buffer *segbuf;
+
+	list_for_each_entry(segbuf, logs, sb_list)
+		nilfs_segbuf_clear(segbuf);
+}
+
+void nilfs_truncate_logs(struct list_head *logs,
+			 struct nilfs_segment_buffer *last)
+{
+	struct nilfs_segment_buffer *n, *segbuf;
+
+	segbuf = list_prepare_entry(last, logs, sb_list);
+	list_for_each_entry_safe_continue(segbuf, n, logs, sb_list) {
+		list_del_init(&segbuf->sb_list);
+		nilfs_segbuf_clear(segbuf);
+		nilfs_segbuf_free(segbuf);
+	}
+}
+
+int nilfs_wait_on_logs(struct list_head *logs)
+{
+	struct nilfs_segment_buffer *segbuf;
+	int err;
+
+	list_for_each_entry(segbuf, logs, sb_list) {
+		err = nilfs_segbuf_wait(segbuf);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 /*
  * BIO operations
  */
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index 241a00d..7fbaf5e 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -164,16 +164,18 @@ nilfs_segbuf_add_file_buffer(struct nilfs_segment_buffer *segbuf,
 	segbuf->sb_sum.nfileblk++;
 }
 
-void nilfs_release_buffers(struct list_head *);
-
-static inline void nilfs_segbuf_clear(struct nilfs_segment_buffer *segbuf)
-{
-	nilfs_release_buffers(&segbuf->sb_segsum_buffers);
-	nilfs_release_buffers(&segbuf->sb_payload_buffers);
-}
-
 int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 		       struct the_nilfs *nilfs);
 int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf);
 
+void nilfs_clear_logs(struct list_head *logs);
+void nilfs_truncate_logs(struct list_head *logs,
+			 struct nilfs_segment_buffer *last);
+int nilfs_wait_on_logs(struct list_head *logs);
+
+static inline void nilfs_destroy_logs(struct list_head *logs)
+{
+	nilfs_truncate_logs(logs, NULL);
+}
+
 #endif /* _NILFS_SEGBUF_H */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 4422cda..689deb9 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1276,7 +1276,7 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 static int nilfs_segctor_begin_construction(struct nilfs_sc_info *sci,
 					    struct the_nilfs *nilfs)
 {
-	struct nilfs_segment_buffer *segbuf, *n;
+	struct nilfs_segment_buffer *segbuf;
 	__u64 nextnum;
 	int err;
 
@@ -1313,18 +1313,14 @@ static int nilfs_segctor_begin_construction(struct nilfs_sc_info *sci,
 	nilfs_segbuf_set_next_segnum(segbuf, nextnum, nilfs);
 
 	/* truncating segment buffers */
-	list_for_each_entry_safe_continue(segbuf, n, &sci->sc_segbufs,
-					  sb_list) {
-		list_del_init(&segbuf->sb_list);
-		nilfs_segbuf_free(segbuf);
-	}
+	nilfs_truncate_logs(&sci->sc_segbufs, segbuf);
 	return 0;
 }
 
 static int nilfs_segctor_extend_segments(struct nilfs_sc_info *sci,
 					 struct the_nilfs *nilfs, int nadd)
 {
-	struct nilfs_segment_buffer *segbuf, *prev, *n;
+	struct nilfs_segment_buffer *segbuf, *prev;
 	struct inode *sufile = nilfs->ns_sufile;
 	__u64 nextnextnum;
 	LIST_HEAD(list);
@@ -1369,12 +1365,11 @@ static int nilfs_segctor_extend_segments(struct nilfs_sc_info *sci,
  failed_segbuf:
 	nilfs_segbuf_free(segbuf);
  failed:
-	list_for_each_entry_safe(segbuf, n, &list, sb_list) {
+	list_for_each_entry(segbuf, &list, sb_list) {
 		ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
 		WARN_ON(ret); /* never fails */
-		list_del_init(&segbuf->sb_list);
-		nilfs_segbuf_free(segbuf);
 	}
+	nilfs_destroy_logs(&list);
 	return err;
 }
 
@@ -1411,27 +1406,6 @@ static void nilfs_segctor_free_incomplete_segments(struct nilfs_sc_info *sci,
 	}
 }
 
-static void nilfs_segctor_clear_segment_buffers(struct nilfs_sc_info *sci)
-{
-	struct nilfs_segment_buffer *segbuf;
-
-	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list)
-		nilfs_segbuf_clear(segbuf);
-	sci->sc_super_root = NULL;
-}
-
-static void nilfs_segctor_destroy_segment_buffers(struct nilfs_sc_info *sci)
-{
-	struct nilfs_segment_buffer *segbuf;
-
-	while (!list_empty(&sci->sc_segbufs)) {
-		segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
-		list_del_init(&segbuf->sb_list);
-		nilfs_segbuf_free(segbuf);
-	}
-	/* sci->sc_curseg = NULL; */
-}
-
 static void nilfs_segctor_end_construction(struct nilfs_sc_info *sci,
 					   struct the_nilfs *nilfs, int err)
 {
@@ -1447,7 +1421,8 @@ static void nilfs_segctor_end_construction(struct nilfs_sc_info *sci,
 			WARN_ON(ret); /* do not happen */
 		}
 	}
-	nilfs_segctor_clear_segment_buffers(sci);
+	nilfs_clear_logs(&sci->sc_segbufs);
+	sci->sc_super_root = NULL;
 }
 
 static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
@@ -1490,17 +1465,15 @@ static void nilfs_segctor_truncate_segments(struct nilfs_sc_info *sci,
 					    struct nilfs_segment_buffer *last,
 					    struct inode *sufile)
 {
-	struct nilfs_segment_buffer *segbuf = last, *n;
+	struct nilfs_segment_buffer *segbuf = last;
 	int ret;
 
-	list_for_each_entry_safe_continue(segbuf, n, &sci->sc_segbufs,
-					  sb_list) {
-		list_del_init(&segbuf->sb_list);
+	list_for_each_entry_continue(segbuf, &sci->sc_segbufs, sb_list) {
 		sci->sc_segbuf_nblocks -= segbuf->sb_rest_blocks;
 		ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
 		WARN_ON(ret);
-		nilfs_segbuf_free(segbuf);
 	}
+	nilfs_truncate_logs(&sci->sc_segbufs, last);
 }
 
 
@@ -1539,7 +1512,7 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 							NULL);
 			WARN_ON(err); /* do not happen */
 		}
-		nilfs_segctor_clear_segment_buffers(sci);
+		nilfs_clear_logs(&sci->sc_segbufs);
 
 		err = nilfs_segctor_extend_segments(sci, nilfs, nadd);
 		if (unlikely(err))
@@ -2179,7 +2152,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 	} while (sci->sc_stage.scnt != NILFS_ST_DONE);
 
  out:
-	nilfs_segctor_destroy_segment_buffers(sci);
+	nilfs_destroy_logs(&sci->sc_segbufs);
 	nilfs_segctor_check_out_files(sci, sbi);
 	return err;
 
-- 
1.6.3.4
