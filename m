From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs-utils: use min_t() and max_t()
Date: Wed, 12 Feb 2014 01:23:09 +0900
Message-ID: <1392135789-5287-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1392135789-5287-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392135789-5287-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Simplify some calculations in lssu, lscp, lib/gc.c, lib/nilfs.c,
lib/cnoconv.c, and cleanerd with min_t() and max_t().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lscp.c               |    8 ++++----
 bin/lssu.c               |    3 ++-
 lib/cnoconv.c            |    5 +++--
 lib/gc.c                 |    3 +--
 lib/nilfs.c              |    8 +++++---
 sbin/cleanerd/cleanerd.c |    4 ++--
 6 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/bin/lscp.c b/bin/lscp.c
index f16f870..7c51e70 100644
--- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -48,6 +48,7 @@
 
 #include <errno.h>
 #include "nilfs.h"
+#include "util.h"
 
 #undef CONFIG_PRINT_CPSTAT
 
@@ -133,9 +134,8 @@ static void lscp_print_cpstat(const struct nilfs_cpstat *cpstat, int mode)
 static ssize_t lscp_get_cpinfo(struct nilfs *nilfs, nilfs_cno_t cno, int mode,
 			       size_t count)
 {
-	size_t req_count;
+	size_t req_count = min_t(size_t, count, LSCP_NCPINFO);
 
-	req_count = (count < LSCP_NCPINFO) ? count : LSCP_NCPINFO;
 	return nilfs_get_cpinfo(nilfs, cno, mode, cpinfos, req_count);
 }
 
@@ -184,8 +184,8 @@ static int lscp_backward_cpinfo(struct nilfs *nilfs,
 		cpstat->cs_cno;
 
 	for ( ; rest > 0 && eidx > NILFS_CNO_MIN; eidx = sidx) {
-		delta = (rest > LSCP_NCPINFO ? LSCP_NCPINFO :
-			 (rest < LSCP_MINDELTA ? LSCP_MINDELTA : rest));
+		delta = min_t(__u64, LSCP_NCPINFO,
+			      max_t(__u64, rest, LSCP_MINDELTA));
 		sidx = (eidx >= NILFS_CNO_MIN + delta) ? eidx - delta :
 			NILFS_CNO_MIN;
 
diff --git a/bin/lssu.c b/bin/lssu.c
index bef4749..e0cbd8d 100644
--- a/bin/lssu.c
+++ b/bin/lssu.c
@@ -51,6 +51,7 @@
 
 #include <errno.h>
 #include "nilfs.h"
+#include "util.h"
 #include "nilfs_gc.h"
 #include "cnoconv.h"
 #include "parser.h"
@@ -244,7 +245,7 @@ static int lssu_list_suinfo(struct nilfs *nilfs)
 		sustat.ss_nsegs;
 
 	for ( ; rest > 0 && segnum < sustat.ss_nsegs; rest -= n) {
-		count = (rest < LSSU_NSEGS) ? rest : LSSU_NSEGS;
+		count = min_t(__u64, rest, LSSU_NSEGS);
 		nsi = nilfs_get_suinfo(nilfs, segnum, suinfos, count);
 		if (nsi < 0)
 			return 1;
diff --git a/lib/cnoconv.c b/lib/cnoconv.c
index 5c79e5c..30f6322 100644
--- a/lib/cnoconv.c
+++ b/lib/cnoconv.c
@@ -17,6 +17,7 @@
 #include <stdlib.h>
 #endif	/* HAVE_STDLIB_H */
 
+#include "util.h"
 #include "cnoconv.h"
 
 /* Context of checkpoint number/time converter */
@@ -77,8 +78,8 @@ int nilfs_cnoconv_time2cno(struct nilfs_cnoconv *cnoconv, __u64 time,
 
 	cno = (cnoconv->prevcno == 0) ? NILFS_CNO_MIN : cnoconv->prevcno;
 	while (cno < cpstat.cs_cno) {
-		count = (cpstat.cs_cno - cno < NILFS_CNOCONV_NCPINFO) ?
-			cpstat.cs_cno - cno : NILFS_CNOCONV_NCPINFO;
+		count = min_t(nilfs_cno_t, cpstat.cs_cno - cno,
+			      NILFS_CNOCONV_NCPINFO);
 		n = nilfs_get_cpinfo(cnoconv->nilfs, cno, NILFS_CHECKPOINT,
 				     cpinfo, count);
 		if (n < 0)
diff --git a/lib/gc.c b/lib/gc.c
index ba90376..453acf2 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -559,8 +559,7 @@ static int nilfs_get_bdesc(struct nilfs *nilfs, struct nilfs_vector *bdescv)
 	bdescs = nilfs_vector_get_data(bdescv);
 	nbdescs = nilfs_vector_get_size(bdescv);
 	for (i = 0; i < nbdescs; i += n) {
-		count = (nbdescs - i < NILFS_GC_NBDESCS) ?
-			(nbdescs - i) : NILFS_GC_NBDESCS;
+		count = min_t(size_t, nbdescs - i, NILFS_GC_NBDESCS);
 		n = nilfs_get_bdescs(nilfs, bdescs + i, count);
 		if (n < 0)
 			return -1;
diff --git a/lib/nilfs.c b/lib/nilfs.c
index 7317205..60b51b0 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -73,6 +73,7 @@
 #include <errno.h>
 #include <assert.h>
 #include "nilfs.h"
+#include "util.h"
 #include "pathnames.h"
 #include "realpath.h"
 
@@ -126,10 +127,11 @@ static int has_mntopt(const char *opts, const char *opt)
 	while (p != NULL) {
 		q = strchr(p, MNTOPT_SEP);
 		if (q) {
-			n = (q - p < len) ? len : q - p;
+			n = max_t(size_t, q - p, len);
 			q++;
-		} else
-			n = (strlen(p) < len) ? len : strlen(p);
+		} else {
+			n = max_t(size_t, strlen(p), len);
+		}
 		if (strncmp(p, opt, n) == 0)
 			return 1;
 		p = q;
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index c20045d..6a0291c 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -607,8 +607,8 @@ nilfs_cleanerd_select_segments(struct nilfs_cleanerd *cleanerd,
 		sustat->ss_nongc_ctime;
 
 	for (segnum = 0; segnum < sustat->ss_nsegs; segnum += n) {
-		count = (sustat->ss_nsegs - segnum < NILFS_CLEANERD_NSUINFO) ?
-			sustat->ss_nsegs - segnum : NILFS_CLEANERD_NSUINFO;
+		count = min_t(__u64, sustat->ss_nsegs - segnum,
+			      NILFS_CLEANERD_NSUINFO);
 		n = nilfs_get_suinfo(nilfs, segnum, si, count);
 		if (n < 0) {
 			nssegs = n;
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
