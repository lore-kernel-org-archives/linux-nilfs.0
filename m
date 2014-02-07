From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v6 5/6] nilfs-utils: add optimized version of nilfs_xreclaim_segments
Date: Fri,  7 Feb 2014 13:16:20 +0100
Message-ID: <cf592c1b5700d82e3763f1deaa97e7cf779bc793.1391774956.git.andreas.rohner@gmx.net>
References: <cover.1391774956.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1391774956.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1391774956.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1391774956.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
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
 include/nilfs_gc.h       | 11 +++----
 lib/gc.c                 | 74 ++++++++++++++++++++++++++++++++++++++++++++----
 sbin/cleanerd/cleanerd.c | 38 +++++++++++++++++++------
 3 files changed, 104 insertions(+), 19 deletions(-)

diff --git a/include/nilfs_gc.h b/include/nilfs_gc.h
index e49cbf4..8bd83d7 100644
--- a/include/nilfs_gc.h
+++ b/include/nilfs_gc.h
@@ -15,20 +15,21 @@
 #include "nilfs.h"
 
 /* flags for nilfs_reclaim_params struct */
-#define NILFS_RECLAIM_PARAM_PROTSEQ	(1UL << 0)
-#define NILFS_RECLAIM_PARAM_PROTCNO	(1UL << 1)
-#define __NR_NILFS_RECLAIM_PARAMS	2
+#define NILFS_RECLAIM_PARAM_PROTSEQ			(1UL << 0)
+#define NILFS_RECLAIM_PARAM_PROTCNO			(1UL << 1)
+#define NILFS_RECLAIM_PARAM_MIN_RECLAIMABLE_BLKS	(1UL << 2)
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
index 71c7307..cd540ad 100644
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
@@ -614,11 +618,14 @@ int nilfs_xreclaim_segment(struct nilfs *nilfs,
 			   const struct nilfs_reclaim_params *params,
 			   struct nilfs_reclaim_stat *stat)
 {
-	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv;
+	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv, *supv;
 	sigset_t sigset, oldset, waitset;
 	nilfs_cno_t protcno;
-	ssize_t n, ret = -1;
+	ssize_t n, i, ret = -1;
 	size_t nblocks;
+	__u32 reclaimable_blocks;
+	struct nilfs_suinfo_update *sup;
+	struct timeval tv;
 
 	if (!(params->flags & NILFS_RECLAIM_PARAM_PROTSEQ) ||
 	    (params->flags & (~0UL << __NR_NILFS_RECLAIM_PARAMS))) {
@@ -637,7 +644,8 @@ int nilfs_xreclaim_segment(struct nilfs *nilfs,
 	bdescv = nilfs_vector_create(sizeof(struct nilfs_bdesc));
 	periodv = nilfs_vector_create(sizeof(struct nilfs_period));
 	vblocknrv = nilfs_vector_create(sizeof(__u64));
-	if (!vdescv || !bdescv || !periodv || !vblocknrv)
+	supv = nilfs_vector_create(sizeof(struct nilfs_suinfo_update));
+	if (!vdescv || !bdescv || !periodv || !vblocknrv || !supv)
 		goto out_vec;
 
 	sigemptyset(&sigset);
@@ -703,13 +711,16 @@ int nilfs_xreclaim_segment(struct nilfs *nilfs,
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
@@ -725,6 +736,55 @@ int nilfs_xreclaim_segment(struct nilfs *nilfs,
 		goto out_lock;
 	}
 
+	/*
+	 * if there are less reclaimable blocks than the minimal
+	 * threshold try to update suinfo instead of cleaning
+	 */
+	if ((params->flags & NILFS_RECLAIM_PARAM_MIN_RECLAIMABLE_BLKS) &&
+			nilfs_opt_test_set_suinfo(nilfs) &&
+			reclaimable_blocks < params->min_reclaimable_blks * n) {
+		if (stat) {
+			stat->deferred_segs = n;
+			stat->cleaned_segs = 0;
+		}
+
+		ret = gettimeofday(&tv, NULL);
+		if (ret < 0)
+			goto out_lock;
+
+		for (i = 0; i < n; ++i) {
+			sup = nilfs_vector_get_new_element(supv);
+			if (!sup)
+				goto out_lock;
+
+			sup->sup_segnum = segnums[i];
+			sup->sup_flags = 0;
+			nilfs_suinfo_update_set_lastmod(sup);
+			sup->sup_sui.sui_lastmod = tv.tv_sec;
+		}
+
+		ret = nilfs_set_suinfo(nilfs, nilfs_vector_get_data(supv), n);
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
+		nilfs_opt_clear_set_suinfo(nilfs);
+		if (stat) {
+			stat->deferred_segs = 0;
+			stat->cleaned_segs = n;
+		}
+		/* Try nilfs_clean_segments */
+	}
+
 	ret = nilfs_clean_segments(nilfs,
 				   nilfs_vector_get_data(vdescv),
 				   nilfs_vector_get_size(vdescv),
@@ -759,6 +819,8 @@ out_vec:
 		nilfs_vector_destroy(periodv);
 	if (vblocknrv != NULL)
 		nilfs_vector_destroy(vblocknrv);
+	if (supv != NULL)
+		nilfs_vector_destroy(supv);
 	/*
 	 * Flags of valid fields in stat->exflags must be unset.
 	 */
@@ -783,7 +845,7 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 
 	params.flags =
 		NILFS_RECLAIM_PARAM_PROTSEQ | NILFS_RECLAIM_PARAM_PROTCNO;
-	params.reserved = 0;
+	params.min_reclaimable_blks = 0;
 	params.protseq = protseq;
 	params.protcno = protcno;
 	memset(&stat, 0, sizeof(stat));
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index cc303bb..b8f2152 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -1392,15 +1392,17 @@ static void nilfs_cleanerd_progress(struct nilfs_cleanerd *cleanerd, int nsegs)
 static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 					 __u64 *segnums, size_t nsegs,
 					 __u64 protseq, __u64 prottime,
-					 size_t *ncleaned)
+					 size_t *ndone)
 {
 	struct nilfs_reclaim_params params;
 	struct nilfs_reclaim_stat stat;
-	int ret, i;
+	int ret, i, sumsegs;
 
-	params.flags =
-		NILFS_RECLAIM_PARAM_PROTSEQ | NILFS_RECLAIM_PARAM_PROTCNO;
-	params.reserved = 0;
+	params.flags = NILFS_RECLAIM_PARAM_PROTSEQ |
+		       NILFS_RECLAIM_PARAM_PROTCNO |
+		       NILFS_RECLAIM_PARAM_MIN_RECLAIMABLE_BLKS;
+	params.min_reclaimable_blks =
+			nilfs_cleanerd_min_reclaimable_blocks(cleanerd);
 	params.protseq = protseq;
 
 	ret = nilfs_cnoconv_time2cno(cleanerd->cnoconv, prottime,
@@ -1418,20 +1420,40 @@ static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 		if (errno == ENOMEM) {
 			nilfs_cleanerd_reduce_ncleansegs_for_retry(cleanerd);
 			cleanerd->fallback = 1;
-			*ncleaned = 0;
+			*ndone = 0;
 			ret = 0;
 		}
 		goto out;
 	}
 
+	*ndone = 0;
+
 	if (stat.cleaned_segs > 0) {
 		for (i = 0; i < stat.cleaned_segs; i++)
 			syslog(LOG_DEBUG, "segment %llu cleaned",
 			       (unsigned long long)segnums[i]);
+
 		nilfs_cleanerd_progress(cleanerd, stat.cleaned_segs);
 		cleanerd->fallback = 0;
 		cleanerd->retry_cleaning = 0;
-	} else {
+
+		*ndone += stat.cleaned_segs;
+	}
+
+	if (stat.deferred_segs > 0) {
+		sumsegs = stat.cleaned_segs + stat.deferred_segs;
+		for (i = stat.cleaned_segs; i < sumsegs; i++)
+			syslog(LOG_DEBUG, "segment %llu deferred",
+			       (unsigned long long)segnums[i]);
+
+		nilfs_cleanerd_progress(cleanerd, stat.deferred_segs);
+		cleanerd->fallback = 0;
+		cleanerd->retry_cleaning = 0;
+
+		*ndone += stat.deferred_segs;
+	}
+
+	if (*ndone == 0) {
 		syslog(LOG_DEBUG, "no segments cleaned");
 
 		if (!cleanerd->retry_cleaning &&
@@ -1445,7 +1467,7 @@ static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 			cleanerd->retry_cleaning = 0;
 		}
 	}
-	*ncleaned = stat.cleaned_segs;
+
 out:
 	return ret;
 }
-- 
1.8.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
