From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v3 4/4] nilfs-utils: add optimized version of nilfs_reclaim_segments
Date: Mon, 27 Jan 2014 10:58:56 +0100
Message-ID: <3a8c070bf3acf549e79a799b1f5bd01c1ba4d1f5.1390813175.git.andreas.rohner@gmx.net>
References: <cover.1390813175.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1390813175.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1390813175.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1390813175.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch adds an optimized version of nilfs_reclaim_segments,
which has an additional parameter min_reclaimable. This parameter
specifies the minimum number of reclaimable blocks in a segment,
before it can be cleaned. If a segment is below this threshold, it
is considered to be not worth cleaning, because all the live blocks
would need to be moved to a new segment, which is expensive, and
the number of reclaimable blocks is too low. But it is still
necessary to update the segment usage information to turn the old
segment into a new one.

This is basically a shortcut to cleaning the segment. It is still
necessary to read the segment summary information, but the writing
of the live blocks can be skipped if it's not worth it.

This optimization can be enabled and disabled by the
use_set_suinfo switch in the configuration file. If the kernel
doesn't support the set_suinfo ioctl it returns the error
number ENOTTY, which also permanently disables the optimization.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs_gc.h       |   4 ++
 lib/gc.c                 | 112 +++++++++++++++++++++++++++++++++++++++--------
 sbin/cleanerd/cleanerd.c |   5 ++-
 3 files changed, 100 insertions(+), 21 deletions(-)

diff --git a/include/nilfs_gc.h b/include/nilfs_gc.h
index 72e9947..0ee797e 100644
--- a/include/nilfs_gc.h
+++ b/include/nilfs_gc.h
@@ -18,6 +18,10 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 			      __u64 *segnums, size_t nsegs,
 			      __u64 protseq, nilfs_cno_t protcno);
 
+ssize_t nilfs_reclaim_segment_with_threshold(struct nilfs *nilfs,
+				__u64 *segnums, size_t nsegs, __u64 protseq,
+				nilfs_cno_t protcno,
+				unsigned long min_reclaimable);
 
 static inline int nilfs_suinfo_reclaimable(const struct nilfs_suinfo *si)
 {
diff --git a/lib/gc.c b/lib/gc.c
index 1152299..91ce47d 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -29,6 +29,10 @@
 #include <syslog.h>
 #endif	/* HAVE_SYSLOG_H */
 
+#if HAVE_SYS_TIME_H
+#include <sys/time.h>
+#endif	/* HAVE_SYS_TIME */
+
 #include <errno.h>
 #include <assert.h>
 #include <stdarg.h>
@@ -601,20 +605,32 @@ static int nilfs_toss_bdescs(struct nilfs_vector *bdescv)
 }
 
 /**
- * nilfs_reclaim_segment - reclaim segments
+ * nilfs_reclaim_segment_with_threshold - reclaim segments with a threshold
  * @nilfs: nilfs object
  * @segnums: array of segment numbers storing selected segments
  * @nsegs: size of the @segnums array
  * @protseq: start of sequence number of protected segments
  * @protcno: start checkpoint number of protected period
+ * @min_reclaimable: minimal number of reclaimable blocks in a segment
+ *
+ * Description: Reclaim segments only if the number of reclaimable blocks
+ * is bigger than min_reclaimable. To reclaim all segments set
+ * min_reclaimable to 0.
+ *
+ * Return Value: On success, the number of reclaimed segments is returned.
+ * On error, the return value is < 0
  */
-ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
-			      __u64 *segnums, size_t nsegs,
-			      __u64 protseq, nilfs_cno_t protcno)
+ssize_t nilfs_reclaim_segment_with_threshold(struct nilfs *nilfs,
+				__u64 *segnums, size_t nsegs, __u64 protseq,
+				nilfs_cno_t protcno,
+				unsigned long min_reclaimable)
 {
 	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv;
 	sigset_t sigset, oldset, waitset;
-	ssize_t n, ret = -1;
+	ssize_t n, i, ret = -1;
+	__u32 reclaimable_blocks;
+	struct nilfs_suinfo_update *supv;
+	struct timeval tv;
 
 	if (nsegs == 0)
 		return 0;
@@ -677,21 +693,63 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 		goto out_lock;
 	}
 
-	ret = nilfs_clean_segments(nilfs,
-				   nilfs_vector_get_data(vdescv),
-				   nilfs_vector_get_size(vdescv),
-				   nilfs_vector_get_data(periodv),
-				   nilfs_vector_get_size(periodv),
-				   nilfs_vector_get_data(vblocknrv),
-				   nilfs_vector_get_size(vblocknrv),
-				   nilfs_vector_get_data(bdescv),
-				   nilfs_vector_get_size(bdescv),
-				   segnums, n);
-	if (ret < 0) {
-		nilfs_gc_logger(LOG_ERR, "cannot clean segments: %s",
-				strerror(errno));
+	reclaimable_blocks = (nilfs_get_blocks_per_segment(nilfs) * n)
+				- (nilfs_vector_get_size(vdescv)
+				+ nilfs_vector_get_size(bdescv));
+
+	/* if there are less reclaimable blocks than the
+	 * minimal threshold try to update suinfo
+	 * instead of cleaning */
+	if (nilfs_opt_test_set_suinfo(nilfs)
+			&& reclaimable_blocks < min_reclaimable * n) {
+		ret = gettimeofday(&tv, NULL);
+		if (ret < 0)
+			goto out_lock;
+
+		supv = malloc(sizeof(struct nilfs_suinfo_update) * n);
+		if (supv == NULL) {
+			ret = -1;
+			goto out_lock;
+		}
+
+		for (i = 0; i < n; ++i) {
+			supv[i].sup_segnum = segnums[i];
+			supv[i].sup_flags = 0;
+			nilfs_suinfo_update_set_lastmod(&supv[i]);
+			supv[i].sup_sui.sui_lastmod = tv.tv_sec;
+		}
+
+		ret = nilfs_set_suinfo(nilfs, supv, n);
+		if (ret == 0) {
+			ret = n;
+		} else if (ret < 0 && errno == ENOTTY) {
+			nilfs_gc_logger(LOG_WARNING,
+					"set_suinfo ioctl is not supported");
+			nilfs_opt_clear_set_suinfo(nilfs);
+			ret = 0;
+		} else {
+			nilfs_gc_logger(LOG_ERR, "cannot set suinfo: %s",
+					strerror(errno));
+		}
+
+		free(supv);
 	} else {
-		ret = n;
+		ret = nilfs_clean_segments(nilfs,
+					   nilfs_vector_get_data(vdescv),
+					   nilfs_vector_get_size(vdescv),
+					   nilfs_vector_get_data(periodv),
+					   nilfs_vector_get_size(periodv),
+					   nilfs_vector_get_data(vblocknrv),
+					   nilfs_vector_get_size(vblocknrv),
+					   nilfs_vector_get_data(bdescv),
+					   nilfs_vector_get_size(bdescv),
+					   segnums, n);
+		if (ret < 0) {
+			nilfs_gc_logger(LOG_ERR, "cannot clean segments: %s",
+					strerror(errno));
+		} else {
+			ret = n;
+		}
 	}
 
 out_lock:
@@ -713,3 +771,19 @@ out_vec:
 
 	return ret;
 }
+
+/**
+ * nilfs_reclaim_segment - reclaim segments
+ * @nilfs: nilfs object
+ * @segnums: array of segment numbers storing selected segments
+ * @nsegs: size of the @segnums array
+ * @protseq: start of sequence number of protected segments
+ * @protcno: start checkpoint number of protected period
+ */
+ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
+			      __u64 *segnums, size_t nsegs,
+			      __u64 protseq, nilfs_cno_t protcno)
+{
+	return nilfs_reclaim_segment_with_threshold(nilfs, segnums, nsegs,
+			protseq, protcno, 0);
+}
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 13018b2..b225283 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -1384,8 +1384,9 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 		goto out;
 	}
 
-	ret = nilfs_reclaim_segment(cleanerd->nilfs, segnums, nsegs,
-				    protseq, protcno);
+	ret = nilfs_reclaim_segment_with_threshold(cleanerd->nilfs, segnums,
+			nsegs, protseq, protcno,
+			nilfs_cleanerd_min_reclaimable_blocks(cleanerd));
 	if (ret > 0) {
 		for (i = 0; i < ret; i++)
 			syslog(LOG_DEBUG, "segment %llu cleaned",
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
