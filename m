From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v6 6/6] nilfs-utils: add a no_timeout flag to enable faster loop
Date: Fri,  7 Feb 2014 13:16:21 +0100
Message-ID: <f4bfa84b28082f291de505c4da0f04bd9fac49fb.1391774956.git.andreas.rohner@gmx.net>
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
 sbin/cleanerd/cleanerd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index b8f2152..39cb65c 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -141,6 +141,7 @@ const static struct option long_option[] = {
  * @running: running state
  * @fallback: fallback state
  * @retry_cleaning: retrying reclamation for protected segments
+ * @no_timeout: the next timeout will be 0 seconds
  * @ncleansegs: number of semgents cleaned per cycle
  * @cleaning_interval: cleaning interval
  * @target: target time for sleeping
@@ -169,6 +170,7 @@ struct nilfs_cleanerd {
 	int running;
 	int fallback;
 	int retry_cleaning;
+	int no_timeout;
 	int shutdown;
 	long ncleansegs;
 	struct timeval cleaning_interval;
@@ -896,7 +898,7 @@ static int nilfs_cleanerd_recalc_interval(struct nilfs_cleanerd *cleanerd,
 	interval = nilfs_cleanerd_cleaning_interval(cleanerd);
 	/* timercmp() does not work for '>=' or '<='. */
 	/* curr >= target */
-	if (!timercmp(&curr, &cleanerd->target, <)) {
+	if (!timercmp(&curr, &cleanerd->target, <) || cleanerd->no_timeout) {
 		cleanerd->timeout.tv_sec = 0;
 		cleanerd->timeout.tv_usec = 0;
 		timeradd(&curr, interval, &cleanerd->target);
@@ -1450,6 +1452,9 @@ static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 		cleanerd->fallback = 0;
 		cleanerd->retry_cleaning = 0;
 
+		if (!stat.cleaned_segs)
+			cleanerd->no_timeout = 1;
+
 		*ndone += stat.deferred_segs;
 	}
 
@@ -1523,6 +1528,8 @@ static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
 		nilfs_cleanerd_clean_check_pause(cleanerd);
 
 	while (!cleanerd->shutdown) {
+		cleanerd->no_timeout = 0;
+
 		if (sigprocmask(SIG_BLOCK, &sigset, NULL) < 0) {
 			syslog(LOG_ERR, "cannot set signal mask: %m");
 			return -1;
-- 
1.8.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
