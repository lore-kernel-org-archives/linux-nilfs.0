From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v4 6/6] nilfs-utils: add a no_timeout flag to enable faster loop
Date: Wed,  5 Feb 2014 03:16:39 +0100
Message-ID: <43f9673512b7a2e95d3036f2e829aa80fb2cca03.1391566347.git.andreas.rohner@gmx.net>
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

This patch adds a flag, that enables the GC to skip the timeout in
certain situations. For example if the cleaning of some segments
was deferred to a later time, then no real progress has been
made. Apart from reading a few summary blocks, no data was read or
written to disk. In this situation it makes sense to skip the
normal timeout once and immediately try to clean the next set of
segments.

Unfortunately it is not possible, to directly continue the cleaning
loop, because this would lead to an unresponsive GC process.
Therefore the timeout is simply set to 0 seconds.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 sbin/cleanerd/cleanerd.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 1374e38..e1bd558 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -167,6 +167,7 @@ struct nilfs_cleanerd {
 	int running;
 	int fallback;
 	int retry_cleaning;
+	int no_timeout;
 	int shutdown;
 	long ncleansegs;
 	struct timeval cleaning_interval;
@@ -894,7 +895,7 @@ static int nilfs_cleanerd_recalc_interval(struct nilfs_cleanerd *cleanerd,
 	interval = nilfs_cleanerd_cleaning_interval(cleanerd);
 	/* timercmp() does not work for '>=' or '<='. */
 	/* curr >= target */
-	if (!timercmp(&curr, &cleanerd->target, <)) {
+	if (!timercmp(&curr, &cleanerd->target, <) || cleanerd->no_timeout) {
 		cleanerd->timeout.tv_sec = 0;
 		cleanerd->timeout.tv_usec = 0;
 		timeradd(&curr, interval, &cleanerd->target);
@@ -1395,6 +1396,7 @@ static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 		       "number: %m");
 		goto out;
 	}
+	cleanerd->no_timeout = 0;
 
 	memset(&stat, 0, sizeof(stat));
 	ret = nilfs_xreclaim_segment(cleanerd->nilfs, segnums, nsegs, 0,
@@ -1409,16 +1411,18 @@ static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 		goto out;
 	}
 
-	if (stat.cleaned_segs > 0) {
-		if (stat.deferred_segs > 0) {
-			for (i = 0; i < stat.cleaned_segs; i++)
-				syslog(LOG_DEBUG, "segment %llu deferred",
-				       (unsigned long long)segnums[i]);
-		} else {
-			for (i = 0; i < stat.cleaned_segs; i++)
-				syslog(LOG_DEBUG, "segment %llu cleaned",
-				       (unsigned long long)segnums[i]);
-		}
+	if (stat.deferred_segs > 0) {
+		for (i = 0; i < stat.cleaned_segs; i++)
+			syslog(LOG_DEBUG, "segment %llu deferred",
+			       (unsigned long long)segnums[i]);
+		nilfs_cleanerd_progress(cleanerd, stat.cleaned_segs);
+		cleanerd->fallback = 0;
+		cleanerd->retry_cleaning = 0;
+		cleanerd->no_timeout = 1;
+	} else if (stat.cleaned_segs > 0) {
+		for (i = 0; i < stat.cleaned_segs; i++)
+			syslog(LOG_DEBUG, "segment %llu cleaned",
+			       (unsigned long long)segnums[i]);
 		nilfs_cleanerd_progress(cleanerd, stat.cleaned_segs);
 		cleanerd->fallback = 0;
 		cleanerd->retry_cleaning = 0;
@@ -1475,6 +1479,7 @@ static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
 	cleanerd->running = 1;
 	cleanerd->fallback = 0;
 	cleanerd->retry_cleaning = 0;
+	cleanerd->no_timeout = 0;
 	nilfs_cnoconv_reset(cleanerd->cnoconv);
 	nilfs_gc_logger = syslog;
 
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
