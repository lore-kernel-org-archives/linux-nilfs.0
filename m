From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/3] nilfs2: move routine marking segment
	usage dirty into sufile
Date: Wed, 18 Nov 2009 19:12:49 +0900
Message-ID: <1258539171-30188-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258539171-30188-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258539171-30188-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This adds nilfs_sufile_mark_dirty() function in sufile to replace
nilfs_touch_segusage() function in log writer code.  This is a
preparation for the further cleanup which will move out low level
sufile operations in the log writer.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c |   19 ++-----------------
 fs/nilfs2/sufile.c  |   19 +++++++++++++++++++
 fs/nilfs2/sufile.h  |    1 +
 3 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index d21179b..3ae4a38 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1273,21 +1273,6 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 	return err;
 }
 
-static int nilfs_touch_segusage(struct inode *sufile, __u64 segnum)
-{
-	struct buffer_head *bh_su;
-	struct nilfs_segment_usage *raw_su;
-	int err;
-
-	err = nilfs_sufile_get_segment_usage(sufile, segnum, &raw_su, &bh_su);
-	if (unlikely(err))
-		return err;
-	nilfs_mdt_mark_buffer_dirty(bh_su);
-	nilfs_mdt_mark_dirty(sufile);
-	nilfs_sufile_put_segment_usage(sufile, segnum, bh_su);
-	return 0;
-}
-
 static int nilfs_segctor_begin_construction(struct nilfs_sc_info *sci,
 					    struct the_nilfs *nilfs)
 {
@@ -1312,7 +1297,7 @@ static int nilfs_segctor_begin_construction(struct nilfs_sc_info *sci,
 	}
 	sci->sc_segbuf_nblocks = segbuf->sb_rest_blocks;
 
-	err = nilfs_touch_segusage(nilfs->ns_sufile, segbuf->sb_segnum);
+	err = nilfs_sufile_mark_dirty(nilfs->ns_sufile, segbuf->sb_segnum);
 	if (unlikely(err))
 		return err;
 
@@ -1352,7 +1337,7 @@ static int nilfs_segctor_extend_segments(struct nilfs_sc_info *sci,
 	 * not be dirty.  The following call ensures that the buffer is dirty
 	 * and will pin the buffer on memory until the sufile is written.
 	 */
-	err = nilfs_touch_segusage(sufile, prev->sb_nextnum);
+	err = nilfs_sufile_mark_dirty(sufile, prev->sb_nextnum);
 	if (unlikely(err))
 		return err;
 
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 5f18aca..d560f88 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -502,6 +502,25 @@ void nilfs_sufile_put_segment_usage(struct inode *sufile, __u64 segnum,
 }
 
 /**
+ * nilfs_sufile_mark_dirty - mark the buffer having a segment usage dirty
+ * @sufile: inode of segment usage file
+ * @segnum: segment number
+ */
+int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
+{
+	struct buffer_head *bh;
+	int ret;
+
+	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
+	if (!ret) {
+		nilfs_mdt_mark_buffer_dirty(bh);
+		nilfs_mdt_mark_dirty(sufile);
+		brelse(bh);
+	}
+	return ret;
+}
+
+/**
  * nilfs_sufile_get_stat - get segment usage statistics
  * @sufile: inode of segment usage file
  * @stat: pointer to a structure of segment usage statistics
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index c339ad5..4146a65 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -42,6 +42,7 @@ int nilfs_sufile_get_segment_usage(struct inode *, __u64,
 				   struct buffer_head **);
 void nilfs_sufile_put_segment_usage(struct inode *, __u64,
 				    struct buffer_head *);
+int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum);
 int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
 ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
 				size_t);
-- 
1.6.3.4
