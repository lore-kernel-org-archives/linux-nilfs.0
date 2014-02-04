From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] cleanerd: use nilfs_xreclaim_segment()
Date: Wed,  5 Feb 2014 03:37:26 +0900
Message-ID: <1391539046-13046-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1391539046-13046-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391539046-13046-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Refactor nilfs_cleanerd_clean_segments() with nilfs_xreclaim_segment()
function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/cleanerd/cleanerd.c |   57 +++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 742ab98..1d09b5b 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -1338,31 +1338,49 @@ static void nilfs_cleanerd_progress(struct nilfs_cleanerd *cleanerd, int nsegs)
 	}
 }
 
-static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
-					     __u64 *segnums, size_t nsegs,
-					     __u64 protseq, __u64 prottime)
+static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
+					 __u64 *segnums, size_t nsegs,
+					 __u64 protseq, __u64 prottime,
+					 size_t *ncleaned)
 {
-	nilfs_cno_t protcno;
+	struct nilfs_reclaim_params params;
+	struct nilfs_reclaim_stat stat;
 	int ret, i;
 
-	ret = nilfs_cnoconv_time2cno(cleanerd->cnoconv, prottime, &protcno);
+	params.flags =
+		NILFS_RECLAIM_PARAM_PROTSEQ | NILFS_RECLAIM_PARAM_PROTCNO;
+	params.reserved = 0;
+	params.protseq = protseq;
+
+	ret = nilfs_cnoconv_time2cno(cleanerd->cnoconv, prottime,
+				     &params.protcno);
 	if (ret < 0) {
 		syslog(LOG_ERR, "cannot convert protection time to checkpoint "
 		       "number: %m");
 		goto out;
 	}
 
-	ret = nilfs_reclaim_segment(cleanerd->nilfs, segnums, nsegs,
-				    protseq, protcno);
-	if (ret > 0) {
-		for (i = 0; i < ret; i++)
+	memset(&stat, 0, sizeof(stat));
+	ret = nilfs_xreclaim_segment(cleanerd->nilfs, segnums, nsegs, 0,
+				     &params, &stat);
+	if (ret < 0) {
+		if (errno == ENOMEM) {
+			nilfs_cleanerd_reduce_ncleansegs_for_retry(cleanerd);
+			cleanerd->fallback = 1;
+			*ncleaned = 0;
+			ret = 0;
+		}
+		goto out;
+	}
+
+	if (stat.cleaned_segs > 0) {
+		for (i = 0; i < stat.cleaned_segs; i++)
 			syslog(LOG_DEBUG, "segment %llu cleaned",
 			       (unsigned long long)segnums[i]);
-		nilfs_cleanerd_progress(cleanerd, ret);
+		nilfs_cleanerd_progress(cleanerd, stat.cleaned_segs);
 		cleanerd->fallback = 0;
 		cleanerd->retry_cleaning = 0;
-
-	} else if (ret == 0) {
+	} else {
 		syslog(LOG_DEBUG, "no segments cleaned");
 
 		if (!cleanerd->retry_cleaning &&
@@ -1375,12 +1393,8 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 		} else {
 			cleanerd->retry_cleaning = 0;
 		}
-
-	} else if (ret < 0 && errno == ENOMEM) {
-		nilfs_cleanerd_reduce_ncleansegs_for_retry(cleanerd);
-		cleanerd->fallback = 1;
-		ret = 0;
 	}
+	*ncleaned = stat.cleaned_segs;
 out:
 	return ret;
 }
@@ -1395,7 +1409,8 @@ static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
 	__u64 prottime = 0, oldest = 0;
 	__u64 segnums[NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX];
 	sigset_t sigset;
-	int ns, ndone, ret;
+	size_t ndone;
+	int ns, ret;
 
 	sigemptyset(&sigset);
 	if (sigprocmask(SIG_SETMASK, &sigset, NULL) < 0) {
@@ -1466,10 +1481,10 @@ static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
 		       ns, (ns <= 1) ? "" : "s");
 		ndone = 0;
 		if (ns > 0) {
-			ndone = nilfs_cleanerd_clean_segments(
+			ret = nilfs_cleanerd_clean_segments(
 				cleanerd, segnums, ns, sustat.ss_prot_seq,
-				prottime);
-			if (ndone < 0)
+				prottime, &ndone);
+			if (ret < 0)
 				return -1;
 		} else {
 			cleanerd->retry_cleaning = 0;
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
