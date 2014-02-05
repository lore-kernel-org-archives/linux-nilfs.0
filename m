From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v4 5/6] nilfs-utils: add optimized version of nilfs_xreclaim_segments
Date: Wed,  5 Feb 2014 03:16:38 +0100
Message-ID: <f5be23fa1b72d7e7e2d1403bdd043ebeafd4407d.1391566347.git.andreas.rohner@gmx.net>
References: <20140205.034242.281476472.konishi.ryusuke@lab.ntt.co.jp>
 <cover.1391566347.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1391566347.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1391566347.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1391566347.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch adds an additional parameter min_reclaimable_blks to
the nilfs_reclaim_params structure. This parameter specifies the
minimum number of reclaimable blocks in a segment, before it can be
cleaned. If a segment is below this threshold, it is considered to
be not worth cleaning, because all the live blocks would need to be
moved to a new segment, which is expensive, and the number of
reclaimable blocks is too low. But it is still necessary to update
the segment usage information to turn the old segment into a new
one.

This is basically a shortcut to cleaning the segment. It is still
necessary to read the segment summary information, but the writing
of the live blocks can be skipped if it's not worth it.

This optimization can be enabled and disabled by the
use_set_suinfo switch in the configuration file. If the kernel
doesn't support the set_suinfo ioctl it returns the error
number ENOTTY, which also permanently disables the optimization.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs_gc.h       |  7 +++---
 lib/gc.c                 | 63 +++++++++++++++++++++++++++++++++++++++++++++---
 sbin/cleanerd/cleanerd.c | 18 +++++++++++---
 3 files changed, 77 insertions(+), 11 deletions(-)

diff --git a/include/nilfs_gc.h b/include/nilfs_gc.h
index e49cbf4..1196c55 100644
--- a/include/nilfs_gc.h
+++ b/include/nilfs_gc.h
@@ -17,18 +17,19 @@
 /* flags for nilfs_reclaim_params struct */
 #define NILFS_RECLAIM_PARAM_PROTSEQ	(1UL << 0)
 #define NILFS_RECLAIM_PARAM_PROTCNO	(1UL << 1)
-#define __NR_NILFS_RECLAIM_PARAMS	2
+#define NILFS_RECLAIM_PARAM_DEFERRABLE	(1UL << 2)
+#define __NR_NILFS_RECLAIM_PARAMS	3
 
 /**
  * struct nilfs_reclaim_params - structure to specify GC parameters
  * @flags: flags of valid fields
- * @reserved: padding bytes
+ * @min_reclaimable_blks: minimum number of reclaimable blocks
  * @protseq: start of sequence number of protected segments
  * @protcno: start number of checkpoint to be protected
  */
 struct nilfs_reclaim_params {
 	unsigned long flags;
-	unsigned long reserved;
+	unsigned long min_reclaimable_blks;
 	__u64 protseq;
 	nilfs_cno_t protcno;
 };
diff --git a/lib/gc.c b/lib/gc.c
index 71c7307..4aa6a2c 100644
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
@@ -617,8 +621,11 @@ int nilfs_xreclaim_segment(struct nilfs *nilfs,
 	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv;
 	sigset_t sigset, oldset, waitset;
 	nilfs_cno_t protcno;
-	ssize_t n, ret = -1;
+	ssize_t n, i, ret = -1;
 	size_t nblocks;
+	__u32 reclaimable_blocks;
+	struct nilfs_suinfo_update *supv;
+	struct timeval tv;
 
 	if (!(params->flags & NILFS_RECLAIM_PARAM_PROTSEQ) ||
 	    (params->flags & (~0UL << __NR_NILFS_RECLAIM_PARAMS))) {
@@ -703,13 +710,16 @@ int nilfs_xreclaim_segment(struct nilfs *nilfs,
 	if (ret < 0)
 		goto out_lock;
 
+	reclaimable_blocks = (nilfs_get_blocks_per_segment(nilfs) * n) -
+			(nilfs_vector_get_size(vdescv) +
+			nilfs_vector_get_size(bdescv));
+
 	if (stat) {
 		stat->live_pblks = nilfs_vector_get_size(bdescv);
 		stat->defunct_pblks = nblocks - stat->live_pblks;
 
 		stat->live_blks = stat->live_vblks + stat->live_pblks;
-		stat->defunct_blks = n * nilfs_get_blocks_per_segment(nilfs) -
-			stat->live_blks;
+		stat->defunct_blks = reclaimable_blocks;
 	}
 	if (dryrun)
 		goto out_lock;
@@ -725,6 +735,51 @@ int nilfs_xreclaim_segment(struct nilfs *nilfs,
 		goto out_lock;
 	}
 
+	/* if there are less reclaimable blocks than the
+	 * minimal threshold try to update suinfo
+	 * instead of cleaning */
+	if ((params->flags & NILFS_RECLAIM_PARAM_DEFERRABLE) &&
+			reclaimable_blocks < params->min_reclaimable_blks * n) {
+		if (stat)
+			stat->deferred_segs = n;
+
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
+		free(supv);
+
+		if (ret == 0)
+			goto out_lock;
+
+		if (ret < 0 && errno != ENOTTY) {
+			nilfs_gc_logger(LOG_ERR, "cannot set suinfo: %s",
+					strerror(errno));
+			goto out_lock;
+		}
+
+		/* errno == ENOTTY */
+		nilfs_gc_logger(LOG_WARNING,
+				"set_suinfo ioctl is not supported");
+		if (stat)
+			stat->deferred_segs = 0;
+		/* Try nilfs_clean_segments */
+	}
+
 	ret = nilfs_clean_segments(nilfs,
 				   nilfs_vector_get_data(vdescv),
 				   nilfs_vector_get_size(vdescv),
@@ -783,7 +838,7 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 
 	params.flags =
 		NILFS_RECLAIM_PARAM_PROTSEQ | NILFS_RECLAIM_PARAM_PROTCNO;
-	params.reserved = 0;
+	params.min_reclaimable_blks = 0;
 	params.protseq = protseq;
 	params.protcno = protcno;
 	memset(&stat, 0, sizeof(stat));
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index a3f62b0..1374e38 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -1381,7 +1381,11 @@ static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 
 	params.flags =
 		NILFS_RECLAIM_PARAM_PROTSEQ | NILFS_RECLAIM_PARAM_PROTCNO;
-	params.reserved = 0;
+	if (nilfs_opt_test_set_suinfo(cleanerd->nilfs))
+		params.flags |= NILFS_RECLAIM_PARAM_DEFERRABLE;
+
+	params.min_reclaimable_blks =
+			nilfs_cleanerd_min_reclaimable_blocks(cleanerd);
 	params.protseq = protseq;
 
 	ret = nilfs_cnoconv_time2cno(cleanerd->cnoconv, prottime,
@@ -1406,9 +1410,15 @@ static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 	}
 
 	if (stat.cleaned_segs > 0) {
-		for (i = 0; i < stat.cleaned_segs; i++)
-			syslog(LOG_DEBUG, "segment %llu cleaned",
-			       (unsigned long long)segnums[i]);
+		if (stat.deferred_segs > 0) {
+			for (i = 0; i < stat.cleaned_segs; i++)
+				syslog(LOG_DEBUG, "segment %llu deferred",
+				       (unsigned long long)segnums[i]);
+		} else {
+			for (i = 0; i < stat.cleaned_segs; i++)
+				syslog(LOG_DEBUG, "segment %llu cleaned",
+				       (unsigned long long)segnums[i]);
+		}
 		nilfs_cleanerd_progress(cleanerd, stat.cleaned_segs);
 		cleanerd->fallback = 0;
 		cleanerd->retry_cleaning = 0;
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
