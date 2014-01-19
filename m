From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 3/4] nilfs-utils: refactoring of nilfs_reclaim_segment to add minblocks param
Date: Sun, 19 Jan 2014 15:01:41 +0100
Message-ID: <88cbf029797323c4975b83654f2241a34acfd2a7.1390139797.git.andreas.rohner@gmx.net>
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

nilfs_reclaim_segment gathers all the necessary information to decide,
how many reclaimable blocks there are in the segments that are to be
cleaned.

By enabling the passing of the threshold value
minblocks, nilfs_reclaim_segment can check the actual value against the
threshold.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs_gc.h               | 4 ++--
 lib/gc.c                         | 5 +++--
 sbin/cleanerd/cleanerd.c         | 5 +++--
 sbin/nilfs-resize/nilfs-resize.c | 2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/nilfs_gc.h b/include/nilfs_gc.h
index 7628ce1..f9fbde4 100644
--- a/include/nilfs_gc.h
+++ b/include/nilfs_gc.h
@@ -15,8 +15,8 @@
 #include "nilfs.h"
 
 ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
-			      __u64 *segnums, size_t nsegs,
-			      __u64 protseq, nilfs_cno_t protcno);
+			      __u64 *segnums, size_t nsegs, __u64 protseq,
+			      nilfs_cno_t protcno, unsigned long minblocks);
 
 
 static inline int nilfs_suinfo_reclaimable(const struct nilfs_suinfo *si)
diff --git a/lib/gc.c b/lib/gc.c
index 1152299..0b0e2d6 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -607,10 +607,11 @@ static int nilfs_toss_bdescs(struct nilfs_vector *bdescv)
  * @nsegs: size of the @segnums array
  * @protseq: start of sequence number of protected segments
  * @protcno: start checkpoint number of protected period
+ * @minblocks: minimal number of free blocks in a segment
  */
 ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
-			      __u64 *segnums, size_t nsegs,
-			      __u64 protseq, nilfs_cno_t protcno)
+			      __u64 *segnums, size_t nsegs, __u64 protseq,
+			      nilfs_cno_t protcno, unsigned long minblocks)
 {
 	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv;
 	sigset_t sigset, oldset, waitset;
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index ab8124f..76a79de 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -1351,8 +1351,9 @@ static ssize_t nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
 	}
 	cleanerd->no_timeout = 0;
 
-	ret = nilfs_reclaim_segment(cleanerd->nilfs, segnums, nsegs,
-				    protseq, protcno);
+	ret = nilfs_reclaim_segment(cleanerd->nilfs, segnums,
+			nsegs, protseq, protcno,
+			cleanerd->config.cf_min_free_blocks_for_cleaning);
 	if (ret > 0) {
 		for (i = 0; i < ret; i++)
 			syslog(LOG_DEBUG, "segment %llu cleaned",
diff --git a/sbin/nilfs-resize/nilfs-resize.c b/sbin/nilfs-resize/nilfs-resize.c
index c8b0868..2850268 100644
--- a/sbin/nilfs-resize/nilfs-resize.c
+++ b/sbin/nilfs-resize/nilfs-resize.c
@@ -595,7 +595,7 @@ static ssize_t nilfs_resize_move_segments(struct nilfs *nilfs,
 			return -1;
 
 		ret = nilfs_reclaim_segment(nilfs, snp, nc,
-					    sustat.ss_prot_seq, 0);
+					    sustat.ss_prot_seq, 0, 0);
 		if (ret < 0)
 			return -1;
 
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
