From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 4/4] nilfs-utils: add support for and define some nilfs_argv flags
Date: Sun, 19 Jan 2014 15:01:42 +0100
Message-ID: <7c2cbb0606ebb80d74adf1d57301dc3670846112.1390139797.git.andreas.rohner@gmx.net>
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

By using the v_flags field of the nilfs_argv struct, it is possible to
communicate additional information to the kernel. This patch defines
two new flags, which are to be used with the nilfs_clean_segments
function.

NILFS_CLEAN_SEGMENTS_DEFAULT: Normal GC operation

NILFS_CLEAN_SEGMENTS_UPDATE_SEGUSG: Do not move any blocks, just update
	the segment usage metadata

Additionally this patch implements a simple check in
nilfs_reclaim_segment. If the number of free blocks that can be gained
by cleaning the segments is below the threshold of minblocks, it sets
the NILFS_CLEAN_SEGMENTS_UPDATE_SEGUSG flag. This causes the kernel to
leave the segment alone, not move any blocks, and only update the
SUFILE.

This is useful, because if the gain of cleaning a segment is very low,
it is better to leave it alone and try cleaning a different segment.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs.h     |  2 +-
 include/nilfs2_fs.h |  6 ++++++
 lib/gc.c            | 16 ++++++++++++++--
 lib/nilfs.c         |  3 ++-
 4 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index 56286a9..5ca8bec 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -304,7 +304,7 @@ ssize_t nilfs_get_vinfo(const struct nilfs *, struct nilfs_vinfo *, size_t);
 ssize_t nilfs_get_bdescs(const struct nilfs *, struct nilfs_bdesc *, size_t);
 int nilfs_clean_segments(struct nilfs *, struct nilfs_vdesc *, size_t,
 			 struct nilfs_period *, size_t, __u64 *, size_t,
-			 struct nilfs_bdesc *, size_t, __u64 *, size_t);
+			 struct nilfs_bdesc *, size_t, __u64 *, size_t, int);
 int nilfs_sync(const struct nilfs *, nilfs_cno_t *);
 int nilfs_resize(struct nilfs *nilfs, off_t size);
 int nilfs_set_alloc_range(struct nilfs *nilfs, off_t start, off_t end);
diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
index e674f44..1ac558f 100644
--- a/include/nilfs2_fs.h
+++ b/include/nilfs2_fs.h
@@ -731,6 +731,12 @@ struct nilfs_cpmode {
 	__u32 cm_pad;
 };
 
+/* values for v_flags */
+enum {
+	NILFS_CLEAN_SEGMENTS_DEFAULT,
+	NILFS_CLEAN_SEGMENTS_UPDATE_SEGUSG,
+};
+
 /**
  * struct nilfs_argv - argument vector
  * @v_base: pointer on data array from userspace
diff --git a/lib/gc.c b/lib/gc.c
index 0b0e2d6..cbae0f3 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -616,6 +616,8 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv;
 	sigset_t sigset, oldset, waitset;
 	ssize_t n, ret = -1;
+	__u32 freeblocks;
+	int cleaning_flags = NILFS_CLEAN_SEGMENTS_DEFAULT;
 
 	if (nsegs == 0)
 		return 0;
@@ -678,6 +680,13 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 		goto out_lock;
 	}
 
+	freeblocks = (nilfs_get_blocks_per_segment(nilfs) * n)
+				- (nilfs_vector_get_size(vdescv)
+				+ nilfs_vector_get_size(bdescv));
+
+	if (freeblocks < minblocks * n)
+		cleaning_flags = NILFS_CLEAN_SEGMENTS_UPDATE_SEGUSG;
+
 	ret = nilfs_clean_segments(nilfs,
 				   nilfs_vector_get_data(vdescv),
 				   nilfs_vector_get_size(vdescv),
@@ -687,12 +696,15 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 				   nilfs_vector_get_size(vblocknrv),
 				   nilfs_vector_get_data(bdescv),
 				   nilfs_vector_get_size(bdescv),
-				   segnums, n);
+				   segnums, n, cleaning_flags);
 	if (ret < 0) {
 		nilfs_gc_logger(LOG_ERR, "cannot clean segments: %s",
 				strerror(errno));
 	} else {
-		ret = n;
+		if (cleaning_flags == NILFS_CLEAN_SEGMENTS_UPDATE_SEGUSG)
+			ret = -EGCTRYAGAIN;
+		else
+			ret = n;
 	}
 
 out_lock:
diff --git a/lib/nilfs.c b/lib/nilfs.c
index ebe50b8..50eed5e 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -627,7 +627,7 @@ int nilfs_clean_segments(struct nilfs *nilfs,
 			 struct nilfs_period *periods, size_t nperiods,
 			 __u64 *vblocknrs, size_t nvblocknrs,
 			 struct nilfs_bdesc *bdescs, size_t nbdescs,
-			 __u64 *segnums, size_t nsegs)
+			 __u64 *segnums, size_t nsegs, int flags)
 {
 	struct nilfs_argv argv[5];
 
@@ -639,6 +639,7 @@ int nilfs_clean_segments(struct nilfs *nilfs,
 	argv[0].v_base = (unsigned long)vdescs;
 	argv[0].v_nmembs = nvdescs;
 	argv[0].v_size = sizeof(struct nilfs_vdesc);
+	argv[0].v_flags = flags;
 	argv[1].v_base = (unsigned long)periods;
 	argv[1].v_nmembs = nperiods;
 	argv[1].v_size = sizeof(struct nilfs_period);
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
