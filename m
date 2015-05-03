From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 3/5] nilfs-utils: add support for tracking live blocks
Date: Sun,  3 May 2015 12:07:05 +0200
Message-ID: <1430647627-18902-3-git-send-email-andreas.rohner@gmx.net>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430647522-14304-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This patch adds a new feature flag NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS,
which allows the user to enable and disable the tracking of live
blocks. The flag can be set at file system creation time with mkfs or
at any later time with nilfs-tune.

Additionally a new option NILFS_OPT_TRACK_LIVE_BLKS is added to be
used by the GC. It is set to the same value as
NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS at startup. It is mainly used to
easily and efficiently check for the feature at runtime and to disable
it if the kernel doesn't support it.

It is fully backwards compatible, because
NILFS_FEATURE_COMPAT_SUFILE_EXTENSION also is backwards compatible and
it basically only tells the kernel to update a counter for every
segment in the SUFILE. If the kernel doesn't support it, the counter
won't be updated and the GC policies depending on that information
will work less efficiently, but they would still work.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs.h              | 23 ++++++++++++++++------
 include/nilfs2_fs.h          |  4 +++-
 lib/feature.c                |  2 ++
 lib/nilfs.c                  | 45 +++++++++++++++++++-------------------------
 man/mkfs.nilfs2.8            |  6 ++++++
 sbin/mkfs/mkfs.c             |  3 ++-
 sbin/nilfs-tune/nilfs-tune.c |  4 ++--
 7 files changed, 51 insertions(+), 36 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index f695f48..dbcb76e 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -130,6 +130,7 @@ struct nilfs {
 
 #define NILFS_OPT_MMAP		0x01
 #define NILFS_OPT_SET_SUINFO	0x02
+#define NILFS_OPT_TRACK_LIVE_BLKS	0x04
 
 
 struct nilfs *nilfs_open(const char *, const char *, int);
@@ -137,13 +138,14 @@ void nilfs_close(struct nilfs *);
 
 const char *nilfs_get_dev(const struct nilfs *);
 
-void nilfs_opt_clear_mmap(struct nilfs *);
-int nilfs_opt_set_mmap(struct nilfs *);
-int nilfs_opt_test_mmap(struct nilfs *);
+#define NILFS_DEF_OPT_FLAG(name)					\
+int nilfs_opt_set_##name(struct nilfs *nilfs);				\
+void nilfs_opt_clear_##name(struct nilfs *nilfs);			\
+int nilfs_opt_test_##name(const struct nilfs *nilfs);
 
-void nilfs_opt_clear_set_suinfo(struct nilfs *);
-int nilfs_opt_set_set_suinfo(struct nilfs *);
-int nilfs_opt_test_set_suinfo(struct nilfs *);
+NILFS_DEF_OPT_FLAG(mmap);
+NILFS_DEF_OPT_FLAG(set_suinfo);
+NILFS_DEF_OPT_FLAG(track_live_blks);
 
 nilfs_cno_t nilfs_get_oldest_cno(struct nilfs *);
 
@@ -326,4 +328,13 @@ static inline __u32 nilfs_get_blocks_per_segment(const struct nilfs *nilfs)
 	return le32_to_cpu(nilfs->n_sb->s_blocks_per_segment);
 }
 
+static inline int nilfs_feature_track_live_blks(const struct nilfs *nilfs)
+{
+	const __u64 required_bits = NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS |
+				    NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT;
+	__u64 fc = le64_to_cpu(nilfs->n_sb->s_feature_compat);
+
+	return ((fc & required_bits) == required_bits);
+}
+
 #endif	/* NILFS_H */
diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
index efa861c..a5dad2a 100644
--- a/include/nilfs2_fs.h
+++ b/include/nilfs2_fs.h
@@ -220,11 +220,13 @@ struct nilfs_super_block {
  * doesn't know about, it should refuse to mount the filesystem.
  */
 #define NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT	(1ULL << 0)
+#define NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS		(1ULL << 1)
 
 #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT		(1ULL << 0)
 
 #define NILFS_FEATURE_COMPAT_SUPP					\
-			(NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT)
+			(NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT |	\
+			 NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS)
 #define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
 #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
 
diff --git a/lib/feature.c b/lib/feature.c
index ea3cb3d..8154e16 100644
--- a/lib/feature.c
+++ b/lib/feature.c
@@ -57,6 +57,8 @@ static const struct nilfs_feature features[] = {
 	/* Compat features */
 	{ NILFS_FEATURE_TYPE_COMPAT,
 	  NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT, "sufile_live_blks_ext" },
+	{ NILFS_FEATURE_TYPE_COMPAT,
+	  NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS, "track_live_blks" },
 	/* Read-only compat features */
 	{ NILFS_FEATURE_TYPE_COMPAT_RO,
 	  NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT, "block_count" },
diff --git a/lib/nilfs.c b/lib/nilfs.c
index 1d18ffc..23ca381 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -285,38 +285,28 @@ void nilfs_opt_clear_mmap(struct nilfs *nilfs)
  * nilfs_opt_test_mmap - test whether mmap option is set or not
  * @nilfs: nilfs object
  */
-int nilfs_opt_test_mmap(struct nilfs *nilfs)
+int nilfs_opt_test_mmap(const struct nilfs *nilfs)
 {
 	return !!(nilfs->n_opts & NILFS_OPT_MMAP);
 }
 
-/**
- * nilfs_opt_set_set_suinfo - set set_suinfo option
- * @nilfs: nilfs object
- */
-int nilfs_opt_set_set_suinfo(struct nilfs *nilfs)
-{
-	nilfs->n_opts |= NILFS_OPT_SET_SUINFO;
-	return 0;
+#define NILFS_OPT_FLAG(flag, name)					\
+int nilfs_opt_set_##name(struct nilfs *nilfs)				\
+{									\
+	nilfs->n_opts |= NILFS_OPT_##flag;				\
+	return 0;							\
+}									\
+void nilfs_opt_clear_##name(struct nilfs *nilfs)			\
+{									\
+	nilfs->n_opts &= ~NILFS_OPT_##flag;				\
+}									\
+int nilfs_opt_test_##name(const struct nilfs *nilfs)			\
+{									\
+	return !!(nilfs->n_opts & NILFS_OPT_##flag);			\
 }
 
-/**
- * nilfs_opt_clear_set_suinfo - clear set_suinfo option
- * @nilfs: nilfs object
- */
-void nilfs_opt_clear_set_suinfo(struct nilfs *nilfs)
-{
-	nilfs->n_opts &= ~NILFS_OPT_SET_SUINFO;
-}
-
-/**
- * nilfs_opt_test_set_suinfo - test whether set_suinfo option is set or not
- * @nilfs: nilfs object
- */
-int nilfs_opt_test_set_suinfo(struct nilfs *nilfs)
-{
-	return !!(nilfs->n_opts & NILFS_OPT_SET_SUINFO);
-}
+NILFS_OPT_FLAG(SET_SUINFO, set_suinfo);
+NILFS_OPT_FLAG(TRACK_LIVE_BLKS, track_live_blks);
 
 static int nilfs_open_sem(struct nilfs *nilfs)
 {
@@ -406,6 +396,9 @@ struct nilfs *nilfs_open(const char *dev, const char *dir, int flags)
 			errno = ENOTSUP;
 			goto out_fd;
 		}
+
+		if (nilfs_feature_track_live_blks(nilfs))
+			nilfs_opt_set_track_live_blks(nilfs);
 	}
 
 	if (flags &
diff --git a/man/mkfs.nilfs2.8 b/man/mkfs.nilfs2.8
index f04d6be..e5a3976 100644
--- a/man/mkfs.nilfs2.8
+++ b/man/mkfs.nilfs2.8
@@ -175,6 +175,12 @@ track_live_blks features to work. Once enabled it cannot be disabled, because
 it changes the ondisk format. Nevertheless it is fully compatible with older
 versions of the file system. This feature is on by default, because it is fully
 backwards compatible and can only be set at file system creation time.
+.TP
+.B track_live_blks
+Enables the tracking of live blocks, which might improve the effectiveness of
+garbage collection, but entails a small runtime overhead. It is important to
+note, that this feature depends on sufile_live_blks_ext, which can only be set
+at file system creation time.
 .RE
 .TP
 .B \-q
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index 96b944c..bd6182c 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -1082,7 +1082,8 @@ static inline void check_ctime(time_t ctime)
 
 static const __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
-	NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT,
+	NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT |
+	NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS,
 	/* Read-only compat */
 	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
 	/* Incompat */
diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.c
index 60f1d39..7889310 100644
--- a/sbin/nilfs-tune/nilfs-tune.c
+++ b/sbin/nilfs-tune/nilfs-tune.c
@@ -84,7 +84,7 @@ static void nilfs_tune_usage(void)
 
 static const __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
-	0,
+	NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS,
 	/* Read-only compat */
 	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
 	/* Incompat */
@@ -93,7 +93,7 @@ static const __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
 
 static const __u64 clear_ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
-	0,
+	NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS,
 	/* Read-only compat */
 	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
 	/* Incompat */
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
