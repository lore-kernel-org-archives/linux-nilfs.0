From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 2/4] nilfs-utils: cleanerd: add custom error value to enable fast retry
Date: Sun, 19 Jan 2014 15:01:40 +0100
Message-ID: <a203a9d8105dc1b449e469158fb07fbffbf2da18.1390139797.git.andreas.rohner@gmx.net>
References: <cover.1390139797.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1390139797.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1390139797.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1390139797.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch adds the custom error value EGCTRYAGAIN, which signals to
cleanerd to retry the gc process as soon as possible with no timeout.

If the GC decides not to do any real work and only changes a few
metadata bytes, there is no need for a timeout. Furthermore if the GC is
running, there is probably not enough free space on the device and it is
crucial to retry quickly.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs_gc.h       |  2 ++
 sbin/cleanerd/cleanerd.c | 10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/nilfs_gc.h b/include/nilfs_gc.h
index 72e9947..7628ce1 100644
--- a/include/nilfs_gc.h
+++ b/include/nilfs_gc.h
@@ -27,4 +27,6 @@ static inline int nilfs_suinfo_reclaimable(const struct nilfs_suinfo *si)
 
 extern void (*nilfs_gc_logger)(int priority, const char *fmt, ...);
 
+#define EGCTRYAGAIN 513
+
 #endif /* NILFS_GC_H */
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 86dfcf7..ab8124f 100644
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
@@ -873,7 +874,7 @@ static int nilfs_cleanerd_recalc_interval(struct nilfs_cleanerd *cleanerd,
 	interval = nilfs_cleanerd_cleaning_interval(cleanerd);
 	/* timercmp() does not work for '>=' or '<='. */
 	/* curr >= target */
-	if (!timercmp(&curr, &cleanerd->target, <)) {
+	if (!timercmp(&curr, &cleanerd->target, <) || cleanerd->no_timeout) {
 		cleanerd->timeout.tv_sec = 0;
 		cleanerd->timeout.tv_usec = 0;
 		timeradd(&curr, interval, &cleanerd->target);
@@ -1348,6 +1349,7 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 		       "number: %m");
 		goto out;
 	}
+	cleanerd->no_timeout = 0;
 
 	ret = nilfs_reclaim_segment(cleanerd->nilfs, segnums, nsegs,
 				    protseq, protcno);
@@ -1373,6 +1375,11 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 			cleanerd->retry_cleaning = 0;
 		}
 
+	} else if (ret == -EGCTRYAGAIN) {
+		cleanerd->fallback = 0;
+		cleanerd->retry_cleaning = 1;
+		cleanerd->no_timeout = 1;
+		ret = 0;
 	} else if (ret < 0 && errno == ENOMEM) {
 		nilfs_cleanerd_reduce_ncleansegs_for_retry(cleanerd);
 		cleanerd->fallback = 1;
@@ -1415,6 +1422,7 @@ static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
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
