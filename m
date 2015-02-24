From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 3/9] nilfs2: extend SUFILE on-disk format to enable counting of live blocks
Date: Tue, 24 Feb 2015 20:01:38 +0100
Message-ID: <1424804504-10914-4-git-send-email-andreas.rohner@gmx.net>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424804504-10914-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch extends the nilfs_segment_usage structure with two extra
fields. This changes the on-disk format of the SUFILE, but the nilfs2
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
blocks are subtracted from su_nlive_blks and are therefore considered to
be reclaimable by the kernel. But the GC additionally protects them with
the protection period. So while su_nilve_blks contains the number of
potentially reclaimable blocks, the actual number depends on the
protection period. To enable GC policies to effectively choose or prefer
segments with unprotected blocks, the timestamp in su_nlive_lastmod is
necessary.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/ioctl.c         |  4 ++--
 fs/nilfs2/sufile.c        | 38 +++++++++++++++++++++++++++++--
 fs/nilfs2/sufile.h        |  5 ++++
 include/linux/nilfs2_fs.h | 58 ++++++++++++++++++++++++++++++++++++++++-------
 4 files changed, 93 insertions(+), 12 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 9a20e51..f6ee54e 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1250,7 +1250,7 @@ static int nilfs_ioctl_set_suinfo(struct inode *inode, struct file *filp,
 		goto out;
 
 	ret = -EINVAL;
-	if (argv.v_size < sizeof(struct nilfs_suinfo_update))
+	if (argv.v_size < NILFS_MIN_SUINFO_UPDATE_SIZE)
 		goto out;
 
 	if (argv.v_nmembs > nilfs->ns_nsegments)
@@ -1316,7 +1316,7 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return nilfs_ioctl_get_cpstat(inode, filp, cmd, argp);
 	case NILFS_IOCTL_GET_SUINFO:
 		return nilfs_ioctl_get_info(inode, filp, cmd, argp,
-					    sizeof(struct nilfs_suinfo),
+					    NILFS_MIN_SEGMENT_USAGE_SIZE,
 					    nilfs_ioctl_do_get_suinfo);
 	case NILFS_IOCTL_SET_SUINFO:
 		return nilfs_ioctl_set_suinfo(inode, filp, cmd, argp);
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index a369c30..ae08050 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -466,6 +466,11 @@ void nilfs_sufile_do_scrap(struct inode *sufile, __u64 *data,
 	su->su_lastmod = cpu_to_le64(0);
 	su->su_nblocks = cpu_to_le32(0);
 	su->su_flags = cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY);
+	if (nilfs_sufile_ext_supported(sufile)) {
+		su->su_nlive_blks = cpu_to_le32(0);
+		su->su_pad = cpu_to_le32(0);
+		su->su_nlive_lastmod = cpu_to_le64(0);
+	}
 	kunmap_atomic(kaddr);
 
 	nilfs_sufile_mod_counter(header_bh, clean ? (u64)-1 : 0, dirty ? 0 : 1);
@@ -496,7 +501,7 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 *data,
 	WARN_ON(!nilfs_segment_usage_dirty(su));
 
 	sudirty = nilfs_segment_usage_dirty(su);
-	nilfs_segment_usage_set_clean(su);
+	nilfs_segment_usage_set_clean(su, NILFS_MDT(sufile)->mi_entry_size);
 	kunmap_atomic(kaddr);
 	mark_buffer_dirty(su_bh);
 
@@ -551,6 +556,9 @@ int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
 	if (modtime)
 		su->su_lastmod = cpu_to_le64(modtime);
 	su->su_nblocks = cpu_to_le32(nblocks);
+	if (nilfs_sufile_ext_supported(sufile) &&
+	    nblocks < le32_to_cpu(su->su_nlive_blks))
+		su->su_nlive_blks = su->su_nblocks;
 	kunmap_atomic(kaddr);
 
 	mark_buffer_dirty(bh);
@@ -713,7 +721,7 @@ static int nilfs_sufile_truncate_range(struct inode *sufile,
 		nc = 0;
 		for (su = su2, j = 0; j < n; j++, su = (void *)su + susz) {
 			if (nilfs_segment_usage_error(su)) {
-				nilfs_segment_usage_set_clean(su);
+				nilfs_segment_usage_set_clean(su, susz);
 				nc++;
 			}
 		}
@@ -836,6 +844,8 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
 	void *kaddr;
 	unsigned long nsegs, segusages_per_block;
+	__u64 lm = 0;
+	__u32 nlb = 0;
 	ssize_t n;
 	int ret, i, j;
 
@@ -873,6 +883,17 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 			if (nilfs_segment_is_active(nilfs, segnum + j))
 				si->sui_flags |=
 					(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
+
+			if (susz >= NILFS_EXT_SEGMENT_USAGE_SIZE) {
+				nlb = le32_to_cpu(su->su_nlive_blks);
+				lm = le64_to_cpu(su->su_nlive_lastmod);
+			}
+
+			if (sisz >= NILFS_EXT_SUINFO_SIZE) {
+				si->sui_nlive_blks = nlb;
+				si->sui_pad = 0;
+				si->sui_nlive_lastmod = lm;
+			}
 		}
 		kunmap_atomic(kaddr);
 		brelse(su_bh);
@@ -916,6 +937,8 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 	int cleansi, cleansu, dirtysi, dirtysu;
 	long ncleaned = 0, ndirtied = 0;
 	int ret = 0;
+	bool sup_ext = (supsz >= NILFS_EXT_SUINFO_UPDATE_SIZE);
+	bool su_ext = nilfs_sufile_ext_supported(sufile);
 
 	if (unlikely(nsup == 0))
 		return ret;
@@ -926,6 +949,9 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 				(~0UL << __NR_NILFS_SUINFO_UPDATE_FIELDS))
 			|| (nilfs_suinfo_update_nblocks(sup) &&
 				sup->sup_sui.sui_nblocks >
+				nilfs->ns_blocks_per_segment)
+			|| (nilfs_suinfo_update_nlive_blks(sup) && sup_ext &&
+				sup->sup_sui.sui_nlive_blks >
 				nilfs->ns_blocks_per_segment))
 			return -EINVAL;
 	}
@@ -953,6 +979,14 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 		if (nilfs_suinfo_update_nblocks(sup))
 			su->su_nblocks = cpu_to_le32(sup->sup_sui.sui_nblocks);
 
+		if (nilfs_suinfo_update_nlive_blks(sup) && sup_ext && su_ext)
+			su->su_nlive_blks =
+				cpu_to_le32(sup->sup_sui.sui_nlive_blks);
+
+		if (nilfs_suinfo_update_nlive_lastmod(sup) && sup_ext && su_ext)
+			su->su_nlive_lastmod =
+				cpu_to_le64(sup->sup_sui.sui_nlive_lastmod);
+
 		if (nilfs_suinfo_update_flags(sup)) {
 			/*
 			 * Active flag is a virtual flag projected by running
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index c446325..d56498b 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -28,6 +28,11 @@
 #include <linux/nilfs2_fs.h>
 #include "mdt.h"
 
+static inline int
+nilfs_sufile_ext_supported(const struct inode *sufile)
+{
+	return NILFS_MDT(sufile)->mi_entry_size >= NILFS_EXT_SEGMENT_USAGE_SIZE;
+}
 
 static inline unsigned long nilfs_sufile_get_nsegments(struct inode *sufile)
 {
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index ff3fea3..5d83c55 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -220,9 +220,11 @@ struct nilfs_super_block {
  * If there is a bit set in the incompatible feature set that the kernel
  * doesn't know about, it should refuse to mount the filesystem.
  */
-#define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT	0x00000001ULL
+#define NILFS_FEATURE_COMPAT_SUFILE_EXTENSION		(1ULL << 0)
 
-#define NILFS_FEATURE_COMPAT_SUPP	0ULL
+#define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT		(1ULL << 0)
+
+#define NILFS_FEATURE_COMPAT_SUPP	NILFS_FEATURE_COMPAT_SUFILE_EXTENSION
 #define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
 #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
 
@@ -609,19 +611,32 @@ struct nilfs_cpfile_header {
 	  sizeof(struct nilfs_checkpoint) - 1) /			\
 			sizeof(struct nilfs_checkpoint))
 
+#define sub_sizeof(TYPE, MEMBER) (offsetof(TYPE, MEMBER) +		\
+					sizeof(((TYPE *)0)->MEMBER))
+
 /**
  * struct nilfs_segment_usage - segment usage
  * @su_lastmod: last modified timestamp
  * @su_nblocks: number of blocks in segment
  * @su_flags: flags
+ * @su_nlive_blks: number of live blocks in the segment
+ * @su_pad: padding bytes
+ * @su_nlive_lastmod: timestamp nlive_blks was last modified
  */
 struct nilfs_segment_usage {
 	__le64 su_lastmod;
 	__le32 su_nblocks;
 	__le32 su_flags;
+	__le32 su_nlive_blks;
+	__le32 su_pad;
+	__le64 su_nlive_lastmod;
 };
 
-#define NILFS_MIN_SEGMENT_USAGE_SIZE	16
+#define NILFS_MIN_SEGMENT_USAGE_SIZE	\
+	sub_sizeof(struct nilfs_segment_usage, su_flags)
+
+#define NILFS_EXT_SEGMENT_USAGE_SIZE	\
+	sub_sizeof(struct nilfs_segment_usage, su_nlive_lastmod)
 
 /* segment usage flag */
 enum {
@@ -658,11 +673,16 @@ NILFS_SEGMENT_USAGE_FNS(DIRTY, dirty)
 NILFS_SEGMENT_USAGE_FNS(ERROR, error)
 
 static inline void
-nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su)
+nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su, size_t susz)
 {
 	su->su_lastmod = cpu_to_le64(0);
 	su->su_nblocks = cpu_to_le32(0);
 	su->su_flags = cpu_to_le32(0);
+	if (susz >= NILFS_EXT_SEGMENT_USAGE_SIZE) {
+		su->su_nlive_blks = cpu_to_le32(0);
+		su->su_pad = cpu_to_le32(0);
+		su->su_nlive_lastmod = cpu_to_le64(0);
+	}
 }
 
 static inline int
@@ -684,23 +704,33 @@ struct nilfs_sufile_header {
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
+ * @sui_pad: padding bytes
+ * @sui_nlive_lastmod: timestamp nlive_blks was last modified
  */
 struct nilfs_suinfo {
 	__u64 sui_lastmod;
 	__u32 sui_nblocks;
 	__u32 sui_flags;
+	__u32 sui_nlive_blks;
+	__u32 sui_pad;
+	__u64 sui_nlive_lastmod;
 };
 
+#define NILFS_MIN_SUINFO_SIZE	\
+	sub_sizeof(struct nilfs_suinfo, sui_flags)
+
+#define NILFS_EXT_SUINFO_SIZE	\
+	sub_sizeof(struct nilfs_suinfo, sui_nlive_lastmod)
+
 #define NILFS_SUINFO_FNS(flag, name)					\
 static inline int							\
 nilfs_suinfo_##name(const struct nilfs_suinfo *si)			\
@@ -736,6 +766,8 @@ enum {
 	NILFS_SUINFO_UPDATE_LASTMOD,
 	NILFS_SUINFO_UPDATE_NBLOCKS,
 	NILFS_SUINFO_UPDATE_FLAGS,
+	NILFS_SUINFO_UPDATE_NLIVE_BLKS,
+	NILFS_SUINFO_UPDATE_NLIVE_LASTMOD,
 	__NR_NILFS_SUINFO_UPDATE_FIELDS,
 };
 
@@ -759,6 +791,16 @@ nilfs_suinfo_update_##name(const struct nilfs_suinfo_update *sup)	\
 NILFS_SUINFO_UPDATE_FNS(LASTMOD, lastmod)
 NILFS_SUINFO_UPDATE_FNS(NBLOCKS, nblocks)
 NILFS_SUINFO_UPDATE_FNS(FLAGS, flags)
+NILFS_SUINFO_UPDATE_FNS(NLIVE_BLKS, nlive_blks)
+NILFS_SUINFO_UPDATE_FNS(NLIVE_LASTMOD, nlive_lastmod)
+
+#define NILFS_MIN_SUINFO_UPDATE_SIZE	\
+	(sub_sizeof(struct nilfs_suinfo_update, sup_reserved) + \
+	NILFS_MIN_SUINFO_SIZE)
+
+#define NILFS_EXT_SUINFO_UPDATE_SIZE	\
+	(sub_sizeof(struct nilfs_suinfo_update, sup_reserved) + \
+	NILFS_EXT_SUINFO_SIZE)
 
 enum {
 	NILFS_CHECKPOINT,
-- 
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
