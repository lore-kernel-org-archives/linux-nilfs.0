From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/3] nilfs2: move routine to set segment usage
	into sufile
Date: Wed, 18 Nov 2009 19:12:50 +0900
Message-ID: <1258539171-30188-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This adds nilfs_sufile_set_segment_usage() function in sufile to
replace direct access to the sufile metadata in log writer code.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c |   32 ++++++++++----------------------
 fs/nilfs2/sufile.c  |   37 +++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h  |    2 ++
 3 files changed, 49 insertions(+), 22 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 3ae4a38..097f9c4 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1457,21 +1457,16 @@ static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
 					  struct inode *sufile)
 {
 	struct nilfs_segment_buffer *segbuf;
-	struct buffer_head *bh_su;
-	struct nilfs_segment_usage *raw_su;
 	unsigned long live_blocks;
 	int ret;
 
 	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
-		ret = nilfs_sufile_get_segment_usage(sufile, segbuf->sb_segnum,
-						     &raw_su, &bh_su);
-		WARN_ON(ret); /* always succeed because bh_su is dirty */
 		live_blocks = segbuf->sb_sum.nblocks +
 			(segbuf->sb_pseg_start - segbuf->sb_fseg_start);
-		raw_su->su_lastmod = cpu_to_le64(sci->sc_seg_ctime);
-		raw_su->su_nblocks = cpu_to_le32(live_blocks);
-		nilfs_sufile_put_segment_usage(sufile, segbuf->sb_segnum,
-					       bh_su);
+		ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
+						     live_blocks,
+						     sci->sc_seg_ctime);
+		WARN_ON(ret); /* always succeed because the segusage is dirty */
 	}
 }
 
@@ -1479,25 +1474,18 @@ static void nilfs_segctor_cancel_segusage(struct nilfs_sc_info *sci,
 					  struct inode *sufile)
 {
 	struct nilfs_segment_buffer *segbuf;
-	struct buffer_head *bh_su;
-	struct nilfs_segment_usage *raw_su;
 	int ret;
 
 	segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
-	ret = nilfs_sufile_get_segment_usage(sufile, segbuf->sb_segnum,
-					     &raw_su, &bh_su);
-	WARN_ON(ret); /* always succeed because bh_su is dirty */
-	raw_su->su_nblocks = cpu_to_le32(segbuf->sb_pseg_start -
-					 segbuf->sb_fseg_start);
-	nilfs_sufile_put_segment_usage(sufile, segbuf->sb_segnum, bh_su);
+	ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
+					     segbuf->sb_pseg_start -
+					     segbuf->sb_fseg_start, 0);
+	WARN_ON(ret); /* always succeed because the segusage is dirty */
 
 	list_for_each_entry_continue(segbuf, &sci->sc_segbufs, sb_list) {
-		ret = nilfs_sufile_get_segment_usage(sufile, segbuf->sb_segnum,
-						     &raw_su, &bh_su);
+		ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
+						     0, 0);
 		WARN_ON(ret); /* always succeed */
-		raw_su->su_nblocks = 0;
-		nilfs_sufile_put_segment_usage(sufile, segbuf->sb_segnum,
-					       bh_su);
 	}
 }
 
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index d560f88..3eed998 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -521,6 +521,43 @@ int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
 }
 
 /**
+ * nilfs_sufile_set_segment_usage - set usage of a segment
+ * @sufile: inode of segment usage file
+ * @segnum: segment number
+ * @nblocks: number of live blocks in the segment
+ * @modtime: modification time (option)
+ */
+int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
+				   unsigned long nblocks, time_t modtime)
+{
+	struct buffer_head *bh;
+	struct nilfs_segment_usage *su;
+	void *kaddr;
+	int ret;
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
+	if (ret < 0)
+		goto out_sem;
+
+	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
+	WARN_ON(nilfs_segment_usage_error(su));
+	if (modtime)
+		su->su_lastmod = cpu_to_le64(modtime);
+	su->su_nblocks = cpu_to_le32(nblocks);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	nilfs_mdt_mark_buffer_dirty(bh);
+	nilfs_mdt_mark_dirty(sufile);
+	brelse(bh);
+
+ out_sem:
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
+/**
  * nilfs_sufile_get_stat - get segment usage statistics
  * @sufile: inode of segment usage file
  * @stat: pointer to a structure of segment usage statistics
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 4146a65..e1186bf 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -43,6 +43,8 @@ int nilfs_sufile_get_segment_usage(struct inode *, __u64,
 void nilfs_sufile_put_segment_usage(struct inode *, __u64,
 				    struct buffer_head *);
 int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum);
+int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
+				   unsigned long nblocks, time_t modtime);
 int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
 ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
 				size_t);
-- 
1.6.3.4
