From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 6/6] nilfs-utils: add su_nsnapshot_blks field to indicate starvation
Date: Tue, 24 Feb 2015 20:04:19 +0100
Message-ID: <1424804659-10986-6-git-send-email-andreas.rohner@gmx.net>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
 <1424804659-10986-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424804659-10986-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch adds support for the field su_nsnapshot_blks and includes the
necessary flags to update it from the GC.

The GC already has the necessary information about which block belongs
to a snapshot and which doesn't. So these blocks are counted up and
passed to the caller.

The number of snapshot blocks will then be updated with
NILFS_IOCTL_SET_SUINFO ioctl.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs.h              |  9 +++++++++
 include/nilfs2_fs.h          | 12 ++++++++----
 lib/feature.c                |  2 ++
 lib/gc.c                     | 19 ++++++++++++++-----
 lib/nilfs.c                  |  2 ++
 man/mkfs.nilfs2.8            |  6 ++++++
 sbin/mkfs/mkfs.c             |  3 ++-
 sbin/nilfs-tune/nilfs-tune.c |  6 ++++--
 8 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index 8511163..e84656b 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -131,6 +131,7 @@ struct nilfs {
 #define NILFS_OPT_MMAP		0x01
 #define NILFS_OPT_SET_SUINFO	0x02
 #define NILFS_OPT_TRACK_LIVE_BLKS	0x04
+#define NILFS_OPT_TRACK_SNAPSHOTS	0x08
 
 
 struct nilfs *nilfs_open(const char *, const char *, int);
@@ -161,6 +162,7 @@ nilfs_opt_test_##name(const struct nilfs *nilfs)			\
 
 NILFS_OPT_FLAG(SET_SUINFO, set_suinfo);
 NILFS_OPT_FLAG(TRACK_LIVE_BLKS, track_live_blks);
+NILFS_OPT_FLAG(TRACK_SNAPSHOTS, track_snapshots);
 
 nilfs_cno_t nilfs_get_oldest_cno(struct nilfs *);
 
@@ -356,4 +358,11 @@ static inline int nilfs_feature_track_live_blks(const struct nilfs *nilfs)
 		(fc & NILFS_FEATURE_COMPAT_SUFILE_EXTENSION);
 }
 
+static inline int nilfs_feature_track_snapshots(const struct nilfs *nilfs)
+{
+	__u64 fc = le64_to_cpu(nilfs->n_sb->s_feature_compat);
+	return (fc & NILFS_FEATURE_COMPAT_TRACK_SNAPSHOTS) &&
+		nilfs_feature_track_live_blks(nilfs);
+}
+
 #endif	/* NILFS_H */
diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
index 427ca53..f1f315c 100644
--- a/include/nilfs2_fs.h
+++ b/include/nilfs2_fs.h
@@ -221,11 +221,13 @@ struct nilfs_super_block {
  */
 #define NILFS_FEATURE_COMPAT_SUFILE_EXTENSION		(1ULL << 0)
 #define NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS		(1ULL << 1)
+#define NILFS_FEATURE_COMPAT_TRACK_SNAPSHOTS		(1ULL << 2)
 
 #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT		(1ULL << 0)
 
 #define NILFS_FEATURE_COMPAT_SUPP	(NILFS_FEATURE_COMPAT_SUFILE_EXTENSION \
-				| NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS)
+				| NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS \
+				| NILFS_FEATURE_COMPAT_TRACK_SNAPSHOTS)
 #define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
 #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
 
@@ -630,7 +632,7 @@ struct nilfs_segment_usage {
 	__le32 su_nblocks;
 	__le32 su_flags;
 	__le32 su_nlive_blks;
-	__le32 su_pad;
+	__le32 su_nsnapshot_blks;
 	__le64 su_nlive_lastmod;
 };
 
@@ -682,7 +684,7 @@ nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su, size_t susz)
 	su->su_flags = cpu_to_le32(0);
 	if (susz >= NILFS_EXT_SEGMENT_USAGE_SIZE) {
 		su->su_nlive_blks = cpu_to_le32(0);
-		su->su_pad = cpu_to_le32(0);
+		su->su_nsnapshot_blks = cpu_to_le32(0);
 		su->su_nlive_lastmod = cpu_to_le64(0);
 	}
 }
@@ -723,7 +725,7 @@ struct nilfs_suinfo {
 	__u32 sui_nblocks;
 	__u32 sui_flags;
 	__u32 sui_nlive_blks;
-	__u32 sui_pad;
+	__u32 sui_nsnapshot_blks;
 	__u64 sui_nlive_lastmod;
 };
 
@@ -764,6 +766,7 @@ enum {
 	NILFS_SUINFO_UPDATE_FLAGS,
 	NILFS_SUINFO_UPDATE_NLIVE_BLKS,
 	NILFS_SUINFO_UPDATE_NLIVE_LASTMOD,
+	NILFS_SUINFO_UPDATE_NSNAPSHOT_BLKS,
 	__NR_NILFS_SUINFO_UPDATE_FIELDS,
 };
 
@@ -788,6 +791,7 @@ NILFS_SUINFO_UPDATE_FNS(LASTMOD, lastmod)
 NILFS_SUINFO_UPDATE_FNS(NBLOCKS, nblocks)
 NILFS_SUINFO_UPDATE_FNS(FLAGS, flags)
 NILFS_SUINFO_UPDATE_FNS(NLIVE_BLKS, nlive_blks)
+NILFS_SUINFO_UPDATE_FNS(NSNAPSHOT_BLKS, nsnapshot_blks)
 NILFS_SUINFO_UPDATE_FNS(NLIVE_LASTMOD, nlive_lastmod)
 
 enum {
diff --git a/lib/feature.c b/lib/feature.c
index ebe8c3f..376fa53 100644
--- a/lib/feature.c
+++ b/lib/feature.c
@@ -59,6 +59,8 @@ static const struct nilfs_feature features[] = {
 	  NILFS_FEATURE_COMPAT_SUFILE_EXTENSION, "sufile_ext" },
 	{ NILFS_FEATURE_TYPE_COMPAT,
 	  NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS, "track_live_blks" },
+	{ NILFS_FEATURE_TYPE_COMPAT,
+	  NILFS_FEATURE_COMPAT_TRACK_SNAPSHOTS, "track_snapshots" },
 	/* Read-only compat features */
 	{ NILFS_FEATURE_TYPE_COMPAT_RO,
 	  NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT, "block_count" },
diff --git a/lib/gc.c b/lib/gc.c
index a2461b9..f1b8b85 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -629,12 +629,13 @@ static int nilfs_toss_bdescs(struct nilfs_vector *bdescv)
 static size_t nilfs_count_nlive_blks(const struct nilfs *nilfs,
 				     __u64 segnum,
 				     struct nilfs_vector *vdescv,
-				     struct nilfs_vector *bdescv)
+				     struct nilfs_vector *bdescv,
+				     size_t *pnss)
 {
 	struct nilfs_vdesc *vdesc;
 	struct nilfs_bdesc *bdesc;
 	int i;
-	size_t res = 0;
+	size_t res = 0, nss = 0;
 
 	for (i = 0; i < nilfs_vector_get_size(bdescv); i++) {
 		bdesc = nilfs_vector_get_element(bdescv, i);
@@ -651,10 +652,16 @@ static size_t nilfs_count_nlive_blks(const struct nilfs *nilfs,
 
 		if (nilfs_get_segnum_of_block(nilfs, vdesc->vd_blocknr) ==
 		    segnum && (nilfs_vdesc_snapshot(vdesc) ||
-		    !nilfs_vdesc_protection_period(vdesc)))
+		    !nilfs_vdesc_protection_period(vdesc))) {
 			++res;
+			if (nilfs_vdesc_snapshot(vdesc))
+				++nss;
+		}
 	}
 
+	if (pnss)
+		*pnss = nss;
+
 	return res;
 }
 
@@ -685,7 +692,7 @@ static int nilfs_try_set_suinfo(struct nilfs *nilfs, __u64 *segnums,
 	struct nilfs_suinfo_update *sup;
 	struct timeval tv;
 	int ret = -1;
-	size_t i, nblocks;
+	size_t i, nblocks, nss;
 
 	supv = nilfs_vector_create(sizeof(struct nilfs_suinfo_update));
 	if (!supv)
@@ -709,10 +716,12 @@ static int nilfs_try_set_suinfo(struct nilfs *nilfs, __u64 *segnums,
 
 		if (nilfs_opt_test_track_live_blks(nilfs)) {
 			nilfs_suinfo_update_set_nlive_blks(sup);
+			nilfs_suinfo_update_set_nsnapshot_blks(sup);
 
 			nblocks = nilfs_count_nlive_blks(nilfs,
-					segnums[i], vdescv, bdescv);
+					segnums[i], vdescv, bdescv, &nss);
 			sup->sup_sui.sui_nlive_blks = nblocks;
+			sup->sup_sui.sui_nsnapshot_blks = nss;
 		}
 	}
 
diff --git a/lib/nilfs.c b/lib/nilfs.c
index 2067fc0..c453d5b 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -381,6 +381,8 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
 
 		if (nilfs_feature_track_live_blks(nilfs))
 			nilfs_opt_set_track_live_blks(nilfs);
+		if (nilfs_feature_track_snapshots(nilfs))
+			nilfs_opt_set_track_snapshots(nilfs);
 	}
 
 	if (flags &
diff --git a/man/mkfs.nilfs2.8 b/man/mkfs.nilfs2.8
index 2431ac9..c784883 100644
--- a/man/mkfs.nilfs2.8
+++ b/man/mkfs.nilfs2.8
@@ -182,6 +182,12 @@ Enables the tracking of live blocks, which might improve the effectiveness of
 garbage collection, but entails a small runtime overhead. It is important to
 note, that this feature depends on sufile_ext, which can only be set
 at file system creation time.
+.TP
+.B track_snapshots
+Enables an efficient heuristic tracking of the number of snapshot blocks in a
+segment. This prevents starvation of segments and improves the overall
+performance. It is important to note, that this feature depends on sufile_ext,
+which can only be set at file system creation time.
 .RE
 .TP
 .B \-q
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index 680311c..e69abc8 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -1083,7 +1083,8 @@ static inline void check_ctime(time_t ctime)
 static const __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
 	NILFS_FEATURE_COMPAT_SUFILE_EXTENSION |
-	NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS,
+	NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS |
+	NILFS_FEATURE_COMPAT_TRACK_SNAPSHOTS,
 	/* Read-only compat */
 	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
 	/* Incompat */
diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.c
index 7889310..d595366 100644
--- a/sbin/nilfs-tune/nilfs-tune.c
+++ b/sbin/nilfs-tune/nilfs-tune.c
@@ -84,7 +84,8 @@ static void nilfs_tune_usage(void)
 
 static const __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
-	NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS,
+	NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS |
+	NILFS_FEATURE_COMPAT_TRACK_SNAPSHOTS,
 	/* Read-only compat */
 	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
 	/* Incompat */
@@ -93,7 +94,8 @@ static const __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
 
 static const __u64 clear_ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
-	NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS,
+	NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS |
+	NILFS_FEATURE_COMPAT_TRACK_SNAPSHOTS,
 	/* Read-only compat */
 	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
 	/* Incompat */
-- 
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
