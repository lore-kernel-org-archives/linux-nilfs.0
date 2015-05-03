From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 1/5] nilfs-utils: extend SUFILE on-disk format to enable track live blocks
Date: Sun,  3 May 2015 12:07:03 +0200
Message-ID: <1430647627-18902-1-git-send-email-andreas.rohner@gmx.net>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430647522-14304-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This patch extends the nilfs_segment_usage structure with two extra
fields. This changes the on-disk format of the SUFILE, but the NILFS2
metadata files are flexible enough, so that there are no compatibility
issues. The extension is fully backwards compatible. Nevertheless a
feature compatibility flag was added to indicate the on-disk format
change.

The new field su_nlive_blks is used to track the number of live blocks
in the corresponding segment. Its value should always be smaller than
su_nblocks, which contains the total number of blocks in the segment.

The field su_nlive_lastmod is necessary because of the protection period
used by the GC. It is a timestamp, which contains the last time
su_nlive_blks was modified. For example if a file is deleted, its
blocks are subtracted from su_nlive_blks and are therefore
considered to be reclaimable by the kernel. But the GC additionally
protects them with the protection period. So while su_nilve_blks
contains the number of potentially reclaimable blocks, the actual number
depends on the protection period. To enable GC policies to
effectively choose or prefer segments with unprotected blocks, the
timestamp in su_nlive_lastmod is necessary.

Since the changes to the disk layout are fully backwards compatible and
the feature flag cannot be set after file system creation time,
NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT is set by default. It can
however be disabled by mkfs.nilfs2 -O ^sufile_live_blks_ext

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 bin/lssu.c          | 14 +++++++----
 include/nilfs2_fs.h | 52 ++++++++++++++++++++++++++++++++++------
 lib/feature.c       |  2 ++
 man/mkfs.nilfs2.8   |  7 ++++++
 sbin/mkfs/mkfs.c    | 69 +++++++++++++++++++++++++++++++++++++++--------------
 5 files changed, 114 insertions(+), 30 deletions(-)

diff --git a/bin/lssu.c b/bin/lssu.c
index 09ed973..e50e628 100644
--- a/bin/lssu.c
+++ b/bin/lssu.c
@@ -104,8 +104,8 @@ static const struct lssu_format lssu_format[] = {
 	},
 	{
 		"           SEGNUM        DATE     TIME STAT     NBLOCKS" \
-		"       NLIVEBLOCKS",
-		"%17llu  %s %c%c%c%c  %10u %10u (%3u%%)\n"
+		"       NLIVEBLOCKS   NPREDLIVEBLOCKS",
+		"%17llu  %s %c%c%c%c  %10u %10u (%3u%%) %10u (%3u%%)\n"
 	}
 };
 
@@ -164,9 +164,9 @@ static ssize_t lssu_print_suinfo(struct nilfs *nilfs, __u64 segnum,
 	time_t t;
 	char timebuf[LSSU_BUFSIZE];
 	ssize_t i, n = 0, ret;
-	int ratio;
+	int ratio, predratio;
 	int protected;
-	size_t nliveblks;
+	size_t nliveblks, npredliveblks;
 
 	for (i = 0; i < nsi; i++, segnum++) {
 		if (!all && nilfs_suinfo_clean(&suinfos[i]))
@@ -192,7 +192,10 @@ static ssize_t lssu_print_suinfo(struct nilfs *nilfs, __u64 segnum,
 			break;
 		case LSSU_MODE_LATEST_USAGE:
 			nliveblks = 0;
+			npredliveblks = suinfos[i].sui_nlive_blks;
 			ratio = 0;
+			predratio = (npredliveblks * 100 + 99) /
+					blocks_per_segment;
 			protected = suinfos[i].sui_lastmod >= prottime;
 
 			if (!nilfs_suinfo_dirty(&suinfos[i]) ||
@@ -223,7 +226,8 @@ skip_scan:
 			       nilfs_suinfo_dirty(&suinfos[i]) ? 'd' : '-',
 			       nilfs_suinfo_error(&suinfos[i]) ? 'e' : '-',
 			       protected ? 'p' : '-',
-			       suinfos[i].sui_nblocks, nliveblks, ratio);
+			       suinfos[i].sui_nblocks, nliveblks, ratio,
+			       npredliveblks, predratio);
 			break;
 		}
 		n++;
diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
index a16ad4c..6f0a27e 100644
--- a/include/nilfs2_fs.h
+++ b/include/nilfs2_fs.h
@@ -219,9 +219,12 @@ struct nilfs_super_block {
  * If there is a bit set in the incompatible feature set that the kernel
  * doesn't know about, it should refuse to mount the filesystem.
  */
-#define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT	0x00000001ULL
+#define NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT	(1ULL << 0)
 
-#define NILFS_FEATURE_COMPAT_SUPP	0ULL
+#define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT		(1ULL << 0)
+
+#define NILFS_FEATURE_COMPAT_SUPP					\
+			(NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT)
 #define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
 #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
 
@@ -607,18 +610,38 @@ struct nilfs_cpfile_header {
 	  sizeof(struct nilfs_checkpoint) - 1) /			\
 			sizeof(struct nilfs_checkpoint))
 
+#undef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+
+#ifndef offsetofend
+#define offsetofend(TYPE, MEMBER) \
+		(offsetof(TYPE, MEMBER) + sizeof(((TYPE *)0)->MEMBER))
+#endif
+
 /**
  * struct nilfs_segment_usage - segment usage
  * @su_lastmod: last modified timestamp
  * @su_nblocks: number of blocks in segment
  * @su_flags: flags
+ * @su_nlive_blks: number of live blocks in the segment
+ * @su_nsnapshot_blks: number of blocks belonging to a snapshot in the segment
+ * @su_nlive_lastmod: timestamp nlive_blks was last modified
  */
 struct nilfs_segment_usage {
 	__le64 su_lastmod;
 	__le32 su_nblocks;
 	__le32 su_flags;
+	__le32 su_nlive_blks;
+	__le32 su_nsnapshot_blks;
+	__le64 su_nlive_lastmod;
 };
 
+#define NILFS_MIN_SEGMENT_USAGE_SIZE	\
+	offsetofend(struct nilfs_segment_usage, su_flags)
+
+#define NILFS_LIVE_BLKS_EXT_SEGMENT_USAGE_SIZE	\
+	offsetofend(struct nilfs_segment_usage, su_nlive_lastmod)
+
 /* segment usage flag */
 enum {
 	NILFS_SEGMENT_USAGE_ACTIVE,
@@ -654,11 +677,16 @@ NILFS_SEGMENT_USAGE_FNS(DIRTY, dirty)
 NILFS_SEGMENT_USAGE_FNS(ERROR, error)
 
 static inline void
-nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su)
+nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su, size_t susz)
 {
 	su->su_lastmod = cpu_to_le64(0);
 	su->su_nblocks = cpu_to_le32(0);
 	su->su_flags = cpu_to_le32(0);
+	if (susz >= NILFS_LIVE_BLKS_EXT_SEGMENT_USAGE_SIZE) {
+		su->su_nlive_blks = cpu_to_le32(0);
+		su->su_nsnapshot_blks = cpu_to_le32(0);
+		su->su_nlive_lastmod = cpu_to_le64(0);
+	}
 }
 
 static inline int
@@ -680,21 +708,25 @@ struct nilfs_sufile_header {
 	/* ... */
 };
 
-#define NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET	\
-	((sizeof(struct nilfs_sufile_header) +				\
-	  sizeof(struct nilfs_segment_usage) - 1) /			\
-			 sizeof(struct nilfs_segment_usage))
+#define NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET(susz)	\
+	((sizeof(struct nilfs_sufile_header) + (susz) - 1) / (susz))
 
 /**
  * nilfs_suinfo - segment usage information
  * @sui_lastmod: timestamp of last modification
  * @sui_nblocks: number of written blocks in segment
  * @sui_flags: segment usage flags
+ * @sui_nlive_blks: number of live blocks in the segment
+ * @sui_nsnapshot_blks: number of blocks belonging to a snapshot in the segment
+ * @sui_nlive_lastmod: timestamp nlive_blks was last modified
  */
 struct nilfs_suinfo {
 	__u64 sui_lastmod;
 	__u32 sui_nblocks;
 	__u32 sui_flags;
+	__u32 sui_nlive_blks;
+	__u32 sui_nsnapshot_blks;
+	__u64 sui_nlive_lastmod;
 };
 
 #define NILFS_SUINFO_FNS(flag, name)					\
@@ -732,6 +764,9 @@ enum {
 	NILFS_SUINFO_UPDATE_LASTMOD,
 	NILFS_SUINFO_UPDATE_NBLOCKS,
 	NILFS_SUINFO_UPDATE_FLAGS,
+	NILFS_SUINFO_UPDATE_NLIVE_BLKS,
+	NILFS_SUINFO_UPDATE_NLIVE_LASTMOD,
+	NILFS_SUINFO_UPDATE_NSNAPSHOT_BLKS,
 	__NR_NILFS_SUINFO_UPDATE_FIELDS,
 };
 
@@ -755,6 +790,9 @@ nilfs_suinfo_update_##name(const struct nilfs_suinfo_update *sup)	\
 NILFS_SUINFO_UPDATE_FNS(LASTMOD, lastmod)
 NILFS_SUINFO_UPDATE_FNS(NBLOCKS, nblocks)
 NILFS_SUINFO_UPDATE_FNS(FLAGS, flags)
+NILFS_SUINFO_UPDATE_FNS(NLIVE_BLKS, nlive_blks)
+NILFS_SUINFO_UPDATE_FNS(NSNAPSHOT_BLKS, nsnapshot_blks)
+NILFS_SUINFO_UPDATE_FNS(NLIVE_LASTMOD, nlive_lastmod)
 
 enum {
 	NILFS_CHECKPOINT,
diff --git a/lib/feature.c b/lib/feature.c
index b3317b7..ea3cb3d 100644
--- a/lib/feature.c
+++ b/lib/feature.c
@@ -55,6 +55,8 @@ struct nilfs_feature {
 
 static const struct nilfs_feature features[] = {
 	/* Compat features */
+	{ NILFS_FEATURE_TYPE_COMPAT,
+	  NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT, "sufile_live_blks_ext" },
 	/* Read-only compat features */
 	{ NILFS_FEATURE_TYPE_COMPAT_RO,
 	  NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT, "block_count" },
diff --git a/man/mkfs.nilfs2.8 b/man/mkfs.nilfs2.8
index 0ff2fbe..f04d6be 100644
--- a/man/mkfs.nilfs2.8
+++ b/man/mkfs.nilfs2.8
@@ -168,6 +168,13 @@ pseudo-filesystem feature "none" will clear all filesystem features.
 .TP
 .B block_count
 Enable block count per checkpoint.
+.TP
+.B sufile_live_blks_ext
+Enable SUFILE extension with extra fields. This is necessary for the
+track_live_blks features to work. Once enabled it cannot be disabled, because
+it changes the ondisk format. Nevertheless it is fully compatible with older
+versions of the file system. This feature is on by default, because it is fully
+backwards compatible and can only be set at file system creation time.
 .RE
 .TP
 .B \-q
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index f5f7dbb..96b944c 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -116,7 +116,12 @@ static time_t creation_time;
 static char volume_label[80];
 static __u64 compat_array[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
-	0,
+	/*
+	 * SUFILE_EXTENSION is set by default, because
+	 * it is fully compatible with previous versions and it
+	 * cannot be enabled later with nilfs-tune
+	 */
+	NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT,
 	/* Read-only compat */
 	0,
 	/* Incompat */
@@ -375,12 +380,33 @@ static unsigned count_ifile_blocks(void)
 	return nblocks;
 }
 
+static inline int sufile_live_blks_ext_enabled(void)
+{
+	return compat_array[NILFS_FEATURE_TYPE_COMPAT] &
+			NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT;
+}
+
+static unsigned get_sufile_entry_size(void)
+{
+	if (sufile_live_blks_ext_enabled())
+		return NILFS_LIVE_BLKS_EXT_SEGMENT_USAGE_SIZE;
+	else
+		return NILFS_MIN_SEGMENT_USAGE_SIZE;
+}
+
+static unsigned get_sufile_first_entry_offset(void)
+{
+	unsigned susz = get_sufile_entry_size();
+
+	return NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET(susz);
+}
+
 static unsigned count_sufile_blocks(void)
 {
 	unsigned long sufile_segment_usages_per_block
-		= blocksize / sizeof(struct nilfs_segment_usage);
+		= blocksize / get_sufile_entry_size();
 	return DIV_ROUND_UP(nr_initial_segments +
-			   NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET,
+			   get_sufile_first_entry_offset(),
 			   sufile_segment_usages_per_block);
 }
 
@@ -1056,7 +1082,7 @@ static inline void check_ctime(time_t ctime)
 
 static const __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
-	0,
+	NILFS_FEATURE_COMPAT_SUFILE_LIVE_BLKS_EXT,
 	/* Read-only compat */
 	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
 	/* Incompat */
@@ -1499,8 +1525,8 @@ static void commit_cpfile(void)
 static void prepare_sufile(void)
 {
 	struct nilfs_file_info *fi = nilfs.files[NILFS_SUFILE_INO];
-	const unsigned entries_per_block
-		= blocksize / sizeof(struct nilfs_segment_usage);
+	const size_t susz = get_sufile_entry_size();
+	const unsigned entries_per_block = blocksize / susz;
 	blocknr_t blocknr = fi->start;
 	blocknr_t entry_block = blocknr;
 	struct nilfs_sufile_header *header;
@@ -1516,10 +1542,10 @@ static void prepare_sufile(void)
 	for (entry_block = blocknr;
 	     entry_block < blocknr + fi->nblocks; entry_block++) {
 		i = (entry_block == blocknr) ?
-			NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET : 0;
-		su = (struct nilfs_segment_usage *)
-			map_disk_buffer(entry_block, 1) + i;
-		for (; i < entries_per_block; i++, su++, segnum++) {
+			get_sufile_first_entry_offset() : 0;
+		su = map_disk_buffer(entry_block, 1) + i * susz;
+		for (; i < entries_per_block; i++, su = (void *)su + susz,
+		     segnum++) {
 #if 0 /* these fields are cleared when mapped first */
 			su->su_lastmod = 0;
 			su->su_nblocks = 0;
@@ -1529,7 +1555,7 @@ static void prepare_sufile(void)
 				nilfs_segment_usage_set_active(su);
 				nilfs_segment_usage_set_dirty(su);
 			} else
-				nilfs_segment_usage_set_clean(su);
+				nilfs_segment_usage_set_clean(su, susz);
 		}
 	}
 	init_inode(NILFS_SUFILE_INO, DT_REG, 0, 0);
@@ -1538,19 +1564,26 @@ static void prepare_sufile(void)
 static void commit_sufile(void)
 {
 	struct nilfs_file_info *fi = nilfs.files[NILFS_SUFILE_INO];
-	const unsigned entries_per_block
-		= blocksize / sizeof(struct nilfs_segment_usage);
+	const size_t susz = get_sufile_entry_size();
+	const unsigned entries_per_block = blocksize / susz;
 	struct nilfs_segment_usage *su;
 	unsigned segnum = fi->start / nilfs.diskinfo->blocks_per_segment;
 	blocknr_t blocknr = fi->start +
-		(segnum + NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET) /
+		(segnum + get_sufile_first_entry_offset()) /
 		entries_per_block;
-
-	su = map_disk_buffer(blocknr, 1);
-	su += (segnum + NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET) %
+	size_t entry_off = (segnum + get_sufile_first_entry_offset()) %
 		entries_per_block;
+
+	su = map_disk_buffer(blocknr, 1) + entry_off * susz;
+
 	su->su_lastmod = cpu_to_le64(nilfs.diskinfo->ctime);
 	su->su_nblocks = cpu_to_le32(nilfs.current_segment->nblocks);
+	if (sufile_live_blks_ext_enabled()) {
+		/* nlive_blks = nblocks - (nsummary_blks + nsuperroot_blks) */
+		su->su_nlive_blks = cpu_to_le32(nilfs.current_segment->nblocks -
+				(nilfs.current_segment->nblk_sum + 1));
+		su->su_nlive_lastmod = su->su_lastmod;
+	}
 }
 
 static void prepare_dat(void)
@@ -1756,7 +1789,7 @@ static void prepare_super_block(struct nilfs_disk_info *di)
 	raw_sb->s_checkpoint_size =
 		cpu_to_le16(sizeof(struct nilfs_checkpoint));
 	raw_sb->s_segment_usage_size =
-		cpu_to_le16(sizeof(struct nilfs_segment_usage));
+		cpu_to_le16(get_sufile_entry_size());
 
 	raw_sb->s_feature_compat =
 		cpu_to_le64(compat_array[NILFS_FEATURE_TYPE_COMPAT]);
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
