From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: move out checksum routines to segment buffer code
Date: Sat,  3 Apr 2010 00:48:25 +0900
Message-ID: <1270223305-30416-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1270223305-30416-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1270223305-30416-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ryusuke-sG5X7nlA6pw@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This moves out checksum routines in log writer to segbuf.c for
cleanup.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c  |   39 +++++++++++++++++++++++++++++++++++----
 fs/nilfs2/segbuf.h  |    3 +--
 fs/nilfs2/segment.c |   33 +++------------------------------
 3 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index cb6459d..666fec3 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -201,8 +201,8 @@ void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *segbuf)
 /*
  * CRC calculation routines
  */
-void nilfs_segbuf_fill_in_segsum_crc(struct nilfs_segment_buffer *segbuf,
-				     u32 seed)
+static void
+nilfs_segbuf_fill_in_segsum_crc(struct nilfs_segment_buffer *segbuf, u32 seed)
 {
 	struct buffer_head *bh;
 	struct nilfs_segment_summary *raw_sum;
@@ -229,8 +229,8 @@ void nilfs_segbuf_fill_in_segsum_crc(struct nilfs_segment_buffer *segbuf,
 	raw_sum->ss_sumsum = cpu_to_le32(crc);
 }
 
-void nilfs_segbuf_fill_in_data_crc(struct nilfs_segment_buffer *segbuf,
-				   u32 seed)
+static void nilfs_segbuf_fill_in_data_crc(struct nilfs_segment_buffer *segbuf,
+					  u32 seed)
 {
 	struct buffer_head *bh;
 	struct nilfs_segment_summary *raw_sum;
@@ -256,6 +256,20 @@ void nilfs_segbuf_fill_in_data_crc(struct nilfs_segment_buffer *segbuf,
 	raw_sum->ss_datasum = cpu_to_le32(crc);
 }
 
+static void
+nilfs_segbuf_fill_in_super_root_crc(struct nilfs_segment_buffer *segbuf,
+				    u32 seed)
+{
+	struct nilfs_super_root *raw_sr;
+	u32 crc;
+
+	raw_sr = (struct nilfs_super_root *)segbuf->sb_super_root->b_data;
+	crc = crc32_le(seed,
+		       (unsigned char *)raw_sr + sizeof(raw_sr->sr_sum),
+		       NILFS_SR_BYTES - sizeof(raw_sr->sr_sum));
+	raw_sr->sr_sum = cpu_to_le32(crc);
+}
+
 static void nilfs_release_buffers(struct list_head *list)
 {
 	struct buffer_head *bh, *n;
@@ -335,6 +349,23 @@ int nilfs_wait_on_logs(struct list_head *logs)
 	return ret;
 }
 
+/**
+ * nilfs_add_checksums_on_logs - add checksums on the logs
+ * @logs: list of segment buffers storing target logs
+ * @seed: checksum seed value
+ */
+void nilfs_add_checksums_on_logs(struct list_head *logs, u32 seed)
+{
+	struct nilfs_segment_buffer *segbuf;
+
+	list_for_each_entry(segbuf, logs, sb_list) {
+		if (segbuf->sb_super_root)
+			nilfs_segbuf_fill_in_super_root_crc(segbuf, seed);
+		nilfs_segbuf_fill_in_segsum_crc(segbuf, seed);
+		nilfs_segbuf_fill_in_data_crc(segbuf, seed);
+	}
+}
+
 /*
  * BIO operations
  */
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index a1a0af6..ae12c2c 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -139,8 +139,6 @@ int nilfs_segbuf_extend_segsum(struct nilfs_segment_buffer *);
 int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *,
 				struct buffer_head **);
 void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *);
-void nilfs_segbuf_fill_in_segsum_crc(struct nilfs_segment_buffer *, u32);
-void nilfs_segbuf_fill_in_data_crc(struct nilfs_segment_buffer *, u32);
 
 static inline void
 nilfs_segbuf_add_segsum_buffer(struct nilfs_segment_buffer *segbuf,
@@ -173,6 +171,7 @@ void nilfs_truncate_logs(struct list_head *logs,
 			 struct nilfs_segment_buffer *last);
 int nilfs_write_logs(struct list_head *logs, struct the_nilfs *nilfs);
 int nilfs_wait_on_logs(struct list_head *logs);
+void nilfs_add_checksums_on_logs(struct list_head *logs, u32 seed);
 
 static inline void nilfs_destroy_logs(struct list_head *logs)
 {
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 39c94b7..177e897 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -931,35 +931,6 @@ static void nilfs_segctor_fill_in_file_bmap(struct nilfs_sc_info *sci,
 	}
 }
 
-/*
- * CRC calculation routines
- */
-static void nilfs_fill_in_super_root_crc(struct buffer_head *bh_sr, u32 seed)
-{
-	struct nilfs_super_root *raw_sr =
-		(struct nilfs_super_root *)bh_sr->b_data;
-	u32 crc;
-
-	crc = crc32_le(seed,
-		       (unsigned char *)raw_sr + sizeof(raw_sr->sr_sum),
-		       NILFS_SR_BYTES - sizeof(raw_sr->sr_sum));
-	raw_sr->sr_sum = cpu_to_le32(crc);
-}
-
-static void nilfs_segctor_fill_in_checksums(struct nilfs_sc_info *sci,
-					    u32 seed)
-{
-	struct nilfs_segment_buffer *segbuf;
-
-	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
-		if (segbuf->sb_super_root)
-			nilfs_fill_in_super_root_crc(segbuf->sb_super_root,
-						     seed);
-		nilfs_segbuf_fill_in_segsum_crc(segbuf, seed);
-		nilfs_segbuf_fill_in_data_crc(segbuf, seed);
-	}
-}
-
 static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
 					     struct the_nilfs *nilfs)
 {
@@ -2173,7 +2144,9 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 			nilfs_abort_logs(&sci->sc_segbufs, failed_page, err);
 			goto failed_to_write;
 		}
-		nilfs_segctor_fill_in_checksums(sci, nilfs->ns_crc_seed);
+
+		nilfs_add_checksums_on_logs(&sci->sc_segbufs,
+					    nilfs->ns_crc_seed);
 
 		err = nilfs_segctor_write(sci, nilfs);
 		if (unlikely(err))
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
