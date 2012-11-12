From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 06/15] nilfs-utils: fsck: NILFS superblock check
 implementation
Date: Mon, 12 Nov 2012 13:36:02 +0400
Message-ID: <1352712962.2555.41.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=DhQykaw+ABVUCQz03rlLS3IYdtnaDvWj7CZbrQSFl/4=;
	b=H2PK0vBZMjAQUnR62JR2pk6xKy9iPy9fAkHKWkuIiy5CF1XXraAcTiIOKAWei76g/kTinVlpqgMzA8eQM3Vf/UXddfz2y32lAM8STCwnGh81gKSEeFCo+e37ZHfO5fRC;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds nilfs_sb_read_unchecked() function for reading superblocks without checking. Moreover, it modifies nilfs_sb_is_valid() function with the purpose of making full superblock check.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 06/15] nilfs-utils: fsck: NILFS superblock check implementation

This patch adds nilfs_sb_read_unchecked() function for reading superblocks without checking. Moreover, it modifies nilfs_sb_is_valid() function with the purpose of making full superblock check.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 lib/sb.c | 1429 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 1419 insertions(+), 10 deletions(-)

diff --git a/lib/sb.c b/lib/sb.c
index 94bccaf..286def9 100644
--- a/lib/sb.c
+++ b/lib/sb.c
@@ -30,6 +30,8 @@
 #include <stdlib.h>
 #endif	/* HAVE_STDLIB_H */
 
+#include <stddef.h>
+
 #if HAVE_STRING_H
 #include <string.h>
 #endif	/* HAVE_STRING_H */
@@ -60,9 +62,15 @@
 #include <sys/ioctl.h>
 #endif	/* HAVE_SYS_IOCTL_H */
 
+#include <time.h>
+#include <pwd.h>
+#include <grp.h>
 #include <errno.h>
 #include <assert.h>
+
 #include "nilfs.h"
+#include "nilfs_messages.h"
+#include "fsck_nilfs2.h"
 
 #define NILFS_MAX_SB_SIZE	1024
 
@@ -81,26 +89,1374 @@ static __u32 nilfs_sb_check_sum(struct nilfs_super_block *sbp)
 	return crc;
 }
 
-static int nilfs_sb_is_valid(struct nilfs_super_block *sbp, int check_crc)
+/*
+ * sb_check_magic - Check magic signature of superblock.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-INVALID_NILFS_SIGNATURE - superblock signature is invalid.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_magic(struct nilfs_super_block *sbp,
+				__u64 *check_mask)
 {
-	__u32 crc;
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_MAGIC))
+		return NILFS_OK; /* nothing to be checked */
 
 	if (le16_to_cpu(sbp->s_magic) != NILFS_SUPER_MAGIC)
-		return 0;
-	if (le16_to_cpu(sbp->s_bytes) > NILFS_MAX_SB_SIZE)
-		return 0;
-	if (!check_crc)
-		return 1;
+		err = INVALID_NILFS_SIGNATURE;
+	else
+		*check_mask &= ~CHECK_SB_MAGIC;
+
+	internal_debug("s_magic %#x.",
+				le16_to_cpu(sbp->s_magic));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_size - Check size of superblock in bytes.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-UNSUPPORTED_SB_REV - detected unsupported superblock revision.
+ * %-INVALID_SB_SIZE - superblock contains incorrect size in bytes.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_size(struct nilfs_super_block *sbp,
+				__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u16 sb_size;
+
+	if (!(*check_mask & CHECK_SB_BYTES))
+		return NILFS_OK; /* nothing to be checked */
+
+	sb_size = le16_to_cpu(sbp->s_bytes);
+
+	if (sb_size > sizeof(struct nilfs_super_block))
+		err = INVALID_SB_SIZE;
+	else if (sb_size <
+			offsetof(struct nilfs_super_block, s_reserved))
+		err = INVALID_SB_SIZE;
+	else if (sb_size >
+			offsetof(struct nilfs_super_block, s_reserved)) {
+		err = UNSUPPORTED_SB_REV;
+		*check_mask &= ~CHECK_SB_BYTES;
+		*check_mask |= CHECK_SB_REV_LEVEL;
+	} else /* superblock size is correct */
+		*check_mask &= ~CHECK_SB_BYTES;
+
+	internal_debug("s_bytes %d.", sb_size);
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_crc32 - Check CRC32 of superblock.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-INVALID_CRC - calculated and keeped in superblock CRC32 are not identical.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_crc32(struct nilfs_super_block *sbp,
+				__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u32 crc;
+
+	if (!(*check_mask & CHECK_SB_CRC))
+		return NILFS_OK; /* nothing to be checked */
 
 	crc = nilfs_sb_check_sum(sbp);
 
-	return crc == le32_to_cpu(sbp->s_sum);
+	if (!(crc == le32_to_cpu(sbp->s_sum))) {
+		internal_debug("calculated CRC %d != on-disk CRC %d.",
+				crc, le32_to_cpu(sbp->s_sum));
+		err = INVALID_CRC;
+	} else
+		*check_mask &= ~CHECK_SB_CRC;
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_rev_level - Check revision level of superblock.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-UNSUPPORTED_SB_REV - detected unsupported superblock revision.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_rev_level(struct nilfs_super_block *sbp,
+				__u64 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_REV_LEVEL))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (NILFS_MIN_SUPP_REV < le32_to_cpu(sbp->s_rev_level) ||
+			NILFS_MINOR_REV < le16_to_cpu(sbp->s_minor_rev_level))
+		err = UNSUPPORTED_SB_REV;
+	else
+		*check_mask &= ~CHECK_SB_REV_LEVEL;
+
+	internal_debug("s_rev_level %d.",
+			le32_to_cpu(sbp->s_rev_level));
+	internal_debug("s_minor_rev_level %d.",
+			le16_to_cpu(sbp->s_minor_rev_level));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_feature_set - Check compatible, RO and incompatible feature set.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-UNSUPPORTED_SB_REV - detected unsupported superblock revision.
+ * %-UNSUPPORTED_SB_RO_FEATURE - detected unsupported RO feature flags.
+ * %-INVALID_SB_FEATURE - detected invalid set of feature flags.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_feature_set(struct nilfs_super_block *sbp,
+				__u64 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_FEATURE))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le64_to_cpu(sbp->s_feature_incompat) &
+			~NILFS_FEATURE_INCOMPAT_SUPP) {
+		err = UNSUPPORTED_SB_REV;
+		*check_mask &= ~CHECK_SB_FEATURE;
+		*check_mask |= CHECK_SB_REV_LEVEL;
+	} else
+		*check_mask &= ~CHECK_SB_FEATURE;
+
+	if (le64_to_cpu(sbp->s_feature_compat_ro) &
+			~NILFS_FEATURE_COMPAT_RO_SUPP) {
+		if (err == NILFS_OK)
+			err = UNSUPPORTED_SB_RO_FEATURE;
+	} else
+		*check_mask &= ~CHECK_SB_RO_FEATURE;
+
+	internal_debug("s_feature_compat %lld.",
+			le64_to_cpu(sbp->s_feature_compat));
+	internal_debug("s_feature_compat_ro %lld.",
+			le64_to_cpu(sbp->s_feature_compat_ro));
+	internal_debug("s_feature_incompat %lld.",
+			le64_to_cpu(sbp->s_feature_incompat));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_fs_flags - Check file system independent flags in superblock.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_FLAGS - invalid set of fs independent flags.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_fs_flags(struct nilfs_super_block *sbp,
+				__u64 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_FLAGS))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (sbp->s_flags)
+		err = INVALID_SB_FLAGS;
+	else
+		*check_mask &= ~CHECK_SB_FLAGS;
+
+	internal_debug("s_flags %d.",
+			le16_to_cpu(sbp->s_flags));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_block_size - Check block size value in superblock.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_BLOCK_SIZE - superblock contains invalid block size value.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_block_size(struct nilfs_super_block *sbp,
+				__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	size_t block_size;
+
+	if (!(*check_mask & CHECK_SB_BLOCK_SZ))
+		return NILFS_OK; /* nothing to be checked */
+
+	block_size =
+		1UL << (le32_to_cpu(sbp->s_log_block_size) +
+			NILFS_SB_BLOCK_SIZE_SHIFT);
+
+	if (NILFS_MIN_BLOCK_SIZE > block_size ||
+			NILFS_MAX_BLOCK_SIZE < block_size)
+		err = INVALID_BLOCK_SIZE;
+	else
+		*check_mask &= ~CHECK_SB_BLOCK_SZ;
+
+	internal_debug("s_log_block_size %d.",
+			le32_to_cpu(sbp->s_log_block_size));
+	internal_debug("block size %ld.", block_size);
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_device_size - Check device size value in superblock.
+ * @devfd: file descriptor of opened device.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-OUTSIZED_DEV_SIZE - superblock keeps value that greater of partition size.
+ * %-UNDERSIZED_DEV_SIZE - superblock keeps value that lesser of partition size.
+ * %-OP_FAILED - cannot check device size because of internal error.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_device_size(int devfd,
+				struct nilfs_super_block *sbp,
+				__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u64 dev_size, sb_dev_size;
+
+	if (!(*check_mask & CHECK_SB_DEV_SZ))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (ioctl(devfd, BLKGETSIZE64, &dev_size) != 0) {
+		internal_perror("%s", nilfs_message[OP_FAILED]);
+		return -OP_FAILED;
+	}
+
+	sb_dev_size = le64_to_cpu(sbp->s_dev_size);
+
+	if (sb_dev_size < dev_size)
+		err = UNDERSIZED_DEV_SIZE;
+	else if (sb_dev_size > dev_size)
+		err = OUTSIZED_DEV_SIZE;
+	else
+		*check_mask &= ~CHECK_SB_DEV_SZ;
+
+	internal_debug("device size %lld.", dev_size);
+	internal_debug("s_dev_size %lld.", sb_dev_size);
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_blocks_per_segment - Check number of blocks per full segment.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_BLOCKS_PER_SEG - invalid value of blocks per segment.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_blocks_per_segment(struct nilfs_super_block *sbp,
+					__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u32 sb_blks_per_seg;
+	size_t sb_block_size;
+	__u64 reserved_segs_size;
+
+	if (!(*check_mask & CHECK_SB_BLOCKS_PER_SEG))
+		return NILFS_OK; /* nothing to be checked */
+
+	sb_blks_per_seg = le32_to_cpu(sbp->s_blocks_per_segment);
+	sb_block_size =
+		1UL << (le32_to_cpu(sbp->s_log_block_size) +
+			NILFS_SB_BLOCK_SIZE_SHIFT);
+	reserved_segs_size = sb_blks_per_seg * sb_block_size *
+				NILFS_MIN_NRSVSEGS;
+
+	if (sb_blks_per_seg < NILFS_SEG_MIN_BLOCKS)
+		err = INVALID_SB_BLOCKS_PER_SEG;
+	else if (reserved_segs_size >=
+			le64_to_cpu(sbp->s_dev_size))
+		err = INVALID_SB_BLOCKS_PER_SEG;
+	else
+		*check_mask &= ~CHECK_SB_BLOCKS_PER_SEG;
+
+	internal_debug("s_blocks_per_segment %d.",
+				sb_blks_per_seg);
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_nsegments - Check number of segments in file system.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_NSEGMENTS - invalid number of segments in filesystem.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_nsegments(struct nilfs_super_block *sbp,
+					__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u64 sb_nsegments;
+	__u64 calculated_nsegs;
+	__u32 segment_size;
+	__u64 dev_size;
+
+	if (!(*check_mask & CHECK_SB_NSEGMENTS))
+		return NILFS_OK; /* nothing to be checked */
+
+	sb_nsegments = le64_to_cpu(sbp->s_nsegments);
+	segment_size = le32_to_cpu(sbp->s_blocks_per_segment) *
+				(1UL << (le32_to_cpu(sbp->s_log_block_size) +
+					NILFS_SB_BLOCK_SIZE_SHIFT));
+	dev_size = le64_to_cpu(sbp->s_dev_size);
+	calculated_nsegs = NILFS_SB2_OFFSET_BYTES(dev_size) / segment_size;
+
+	if (sb_nsegments <= NILFS_MIN_NRSVSEGS)
+		err = INVALID_SB_NSEGMENTS;
+	else if (sb_nsegments != calculated_nsegs)
+		err = INVALID_SB_NSEGMENTS;
+	else
+		*check_mask &= ~CHECK_SB_NSEGMENTS;
+
+	internal_debug("s_nsegments %lld.", sb_nsegments);
+	internal_debug("calculated segments number %lld.",
+				calculated_nsegs);
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_first_data_block - Check first segment disk block number.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_FIRST_DATA_BLOCK - invalid value of first data block.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_first_data_block(struct nilfs_super_block *sbp,
+					__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	size_t sb_block_size;
+
+	if (!(*check_mask & CHECK_SB_FIRST_DATA_BLOCK))
+		return NILFS_OK; /* nothing to be checked */
+
+	sb_block_size =
+		1UL << (le32_to_cpu(sbp->s_log_block_size) +
+			NILFS_SB_BLOCK_SIZE_SHIFT);
+
+	if (le64_to_cpu(sbp->s_first_data_block) !=
+		ROUNDUP_DIV(NILFS_SB_OFFSET_BYTES +
+				sizeof(struct nilfs_super_block),
+					sb_block_size))
+		err = INVALID_SB_FIRST_DATA_BLOCK;
+	else
+		*check_mask &= ~CHECK_SB_FIRST_DATA_BLOCK;
+
+	internal_debug("s_first_data_block %lld.",
+			le64_to_cpu(sbp->s_first_data_block));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_r_segs_percentage - Check reserved segments percentage.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_R_SEGS_PERCENTAGE - invalid reserved segments percentage.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_r_segs_percentage(struct nilfs_super_block *sbp,
+					__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u32 r_segs_percentage;
+	__u64 reserved_segs;
+
+	if (!(*check_mask & CHECK_SB_R_SEGS_PERCENT))
+		return NILFS_OK; /* nothing to be checked */
+
+	r_segs_percentage = le32_to_cpu(sbp->s_r_segments_percentage);
+	reserved_segs = (le64_to_cpu(sbp->s_nsegments) *
+				r_segs_percentage + 99) / 100;
+
+	if (r_segs_percentage >= 100 ||
+			reserved_segs < NILFS_MIN_NRSVSEGS)
+		err = INVALID_SB_R_SEGS_PERCENTAGE;
+	else
+		*check_mask &= ~CHECK_SB_R_SEGS_PERCENT;
+
+	internal_debug("s_r_segments_percentage %d.",
+				r_segs_percentage);
+	internal_debug("calculated reserved segments %lld.",
+				reserved_segs);
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_lite_check_last_cno - Check last checkpoint number.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_LAST_CNO - invalid last checkpoint number.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_lite_check_last_cno(struct nilfs_super_block *sbp,
+					__u64 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_LAST_CNO))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le64_to_cpu(sbp->s_last_cno) < NILFS_CNO_MIN)
+		err = INVALID_SB_LAST_CNO;
+	else
+		*check_mask &= ~CHECK_SB_LAST_CNO;
+
+	internal_debug("s_last_cno %lld.",
+				le64_to_cpu(sbp->s_last_cno));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_last_pseg - Check pseg start block.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_LAST_PSEG - invalid disk block of partial segment.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_last_pseg(struct nilfs_super_block *sbp,
+					__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u64 last_pseg;
+	__u32 blks_per_seg;
+	__u64 nsegs;
+	__u64 first_data_block;
+
+	if (!(*check_mask & CHECK_SB_LAST_PSEG))
+		return NILFS_OK; /* nothing to be checked */
+
+	last_pseg = le64_to_cpu(sbp->s_last_pseg);
+	blks_per_seg = le32_to_cpu(sbp->s_blocks_per_segment);
+	nsegs = le64_to_cpu(sbp->s_nsegments);
+	first_data_block = le64_to_cpu(sbp->s_first_data_block);
+
+	if (last_pseg >= (nsegs * blks_per_seg) ||
+				last_pseg < first_data_block)
+		err = INVALID_SB_LAST_PSEG;
+	else
+		*check_mask &= ~CHECK_SB_LAST_PSEG;
+
+	internal_debug("s_last_pseg %lld.", last_pseg);
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_last_seq - Check lastly written segment sequential number.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_LAST_SEQ - invalid sequential number of partial segment.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_last_seq(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u64 last_seq;
+
+	if (!(*check_mask & CHECK_SB_LAST_SEQ))
+		return NILFS_OK; /* nothing to be checked */
+
+	last_seq = le64_to_cpu(sbp->s_last_seq);
+
+	/*INVALID_SB_LAST_SEQ*/
+
+	*check_mask &= ~CHECK_SB_LAST_SEQ;
+
+	internal_debug("s_last_seq %lld.", last_seq);
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_lite_check_free_blks_count - Preliminary check of free blocks count.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_FREE_BLKS - invalid free blocks count.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_lite_check_free_blks_count(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u64 free_blks;
+	__u64 nsegs;
+	__u32 blks_per_seg;
+	__u32 r_segs_percentage;
+	__u64 reserved_segs;
+
+	if (!(*check_mask & CHECK_SB_FREE_BLKS))
+		return NILFS_OK; /* nothing to be checked */
+
+	free_blks = le64_to_cpu(sbp->s_free_blocks_count);
+	blks_per_seg = le32_to_cpu(sbp->s_blocks_per_segment);
+	nsegs = le64_to_cpu(sbp->s_nsegments);
+	r_segs_percentage = le32_to_cpu(sbp->s_r_segments_percentage);
+	reserved_segs = (nsegs * r_segs_percentage + 99) / 100;
+
+	if (free_blks > ((nsegs - 1) * blks_per_seg) ||
+			free_blks < (reserved_segs * blks_per_seg))
+		err = INVALID_SB_FREE_BLKS;
+	else
+		*check_mask &= ~CHECK_SB_FREE_BLKS;
+
+	internal_debug("s_free_blocks_count %lld.", free_blks);
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_timestamps - Check timestamps.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_TIMES - superblock keeps invalid timestamps.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_timestamps(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	time_t current_time;
+	__u64 sb_ctime, sb_mtime, sb_wtime;
+	__u16 mount_cnt;
+
+	if (!(*check_mask & CHECK_SB_TIMES))
+		return NILFS_OK; /* nothing to be checked */
+
+	current_time = time(NULL);
+	sb_ctime = le64_to_cpu(sbp->s_ctime);
+	sb_mtime = le64_to_cpu(sbp->s_mtime);
+	sb_wtime = le64_to_cpu(sbp->s_wtime);
+	mount_cnt = le16_to_cpu(sbp->s_mnt_count);
+
+	if (0 == mount_cnt) {
+		if (!(sb_ctime <= sb_wtime) ||
+				!(sb_ctime < current_time) ||
+				!(sb_wtime < current_time)) {
+			err = INVALID_SB_TIMES;
+		} else
+			*check_mask &= ~CHECK_SB_TIMES;
+	} else {
+		if (!(sb_ctime < sb_mtime) ||
+				!(sb_mtime < sb_wtime) ||
+				!(sb_ctime < sb_mtime) ||
+				!(sb_ctime < current_time) ||
+				!(sb_mtime < current_time) ||
+				!(sb_wtime < current_time))
+			err = INVALID_SB_TIMES;
+		else
+			*check_mask &= ~CHECK_SB_TIMES;
+	}
+
+	internal_debug("current time %s.",
+					ctime(&current_time));
+	internal_debug("creation time s_ctime %s.",
+				ctime((const time_t *)&sb_ctime));
+	internal_debug("mount time s_mtime %s.",
+				ctime((const time_t *)&sb_mtime));
+	internal_debug("write time s_wtime %s.",
+				ctime((const time_t *)&sb_wtime));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_fs_state_flags - Check file system state flags.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_FS_STATE - invalid file system state flags were detected.
+ * %-NOT_CLEAN_UMOUNT_DETECTED - NILFS had been umounted not cleanly.
+ * %-FS_ERRORS_DETECTED_BY_DRIVER - FS errors detected by drivers.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_fs_state_flags(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u16 known_fs_state_flags =
+			NILFS_VALID_FS | NILFS_ERROR_FS | NILFS_RESIZE_FS;
+	__u16 sb_state;
+
+	if (!(*check_mask & CHECK_SB_STATE) &&
+			!(*check_mask & CHECK_SB_CLEAN_UMOUNT_FLAG) &&
+			!(*check_mask & CHECK_SB_ERRS_DETECTED_FLAG))
+		return NILFS_OK; /* nothing to be checked */
+
+	sb_state = le16_to_cpu(sbp->s_state);
+
+	if (*check_mask & CHECK_SB_ERRS_DETECTED_FLAG) {
+		if (sb_state & NILFS_ERROR_FS)
+			err = FS_ERRORS_DETECTED_BY_DRIVER;
+		else
+			*check_mask &= ~CHECK_SB_ERRS_DETECTED_FLAG;
+	}
+
+	if (*check_mask & CHECK_SB_STATE) {
+		if (sb_state & ~known_fs_state_flags) {
+			if (NILFS_OK == err)
+				err = INVALID_SB_FS_STATE;
+		} else
+			*check_mask &= ~CHECK_SB_STATE;
+	}
+
+	if (*check_mask & CHECK_SB_CLEAN_UMOUNT_FLAG) {
+		if (!(sb_state & NILFS_VALID_FS)) {
+			if (NILFS_OK == err)
+				err = NOT_CLEAN_UMOUNT_DETECTED;
+		} else
+			*check_mask &= ~CHECK_SB_CLEAN_UMOUNT_FLAG;
+	}
+
+	internal_debug("s_state %d.",
+				le16_to_cpu(sbp->s_state));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_errors_flag - Check s_errors flag.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_FS_ERRORS - invalid behavior in the case of errors detection.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_errors_flag(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_ERRORS))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le16_to_cpu(sbp->s_errors) != NILFS_ERRORS_CONTINUE)
+		err = INVALID_SB_FS_ERRORS;
+	else
+		*check_mask &= ~CHECK_SB_ERRORS;
+
+	internal_debug("s_errors %d.",
+				le16_to_cpu(sbp->s_errors));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_lastcheck - Check lastcheck timestamp.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_LAST_CHECK - invalid timestamp of last check.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_lastcheck(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	time_t current_time;
+	__u64 sb_ctime, sb_lastcheck;
+
+	if (!(*check_mask & CHECK_SB_LAST_CHECK))
+		return NILFS_OK; /* nothing to be checked */
+
+	current_time = time(NULL);
+	sb_ctime = le64_to_cpu(sbp->s_ctime);
+	sb_lastcheck = le64_to_cpu(sbp->s_lastcheck);
+
+	if (!(sb_ctime <= sb_lastcheck) || !(sb_lastcheck < current_time))
+		err = INVALID_SB_TIMES;
+	else
+		*check_mask &= ~CHECK_SB_LAST_CHECK;
+
+	internal_debug("current time %s.",
+				ctime(&current_time));
+	internal_debug("creation time s_ctime %s.",
+				ctime((const time_t *)&sb_ctime));
+	internal_debug("s_lastcheck %s.",
+				ctime((const time_t *)&sb_lastcheck));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_mnt_count - Compare mount count and max possible mount count.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-MAX_POSSIBLE_MNT_COUNT - Maximum possible mount count has been reached.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_mnt_count(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_MNT_COUNT))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le16_to_cpu(sbp->s_mnt_count) >=
+			le16_to_cpu(sbp->s_max_mnt_count))
+		err = MAX_POSSIBLE_MNT_COUNT;
+	else
+		*check_mask &= ~CHECK_SB_MNT_COUNT;
+
+	internal_debug("mount count %d.",
+				le16_to_cpu(sbp->s_mnt_count));
+	internal_debug("max mount count %d.",
+				le16_to_cpu(sbp->s_max_mnt_count));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_creator_os - Check code for OS.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_OS - invalid code of creator OS.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_creator_os(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u32 creator_os;
+
+	if (!(*check_mask & CHECK_SB_CREATOR_OS))
+		return NILFS_OK; /* nothing to be checked */
+
+	creator_os = le32_to_cpu(sbp->s_creator_os);
+
+	/* Code for Linux is 0. Codes from 1 to 4 are reserved
+	   to keep compatibility with ext2 creator-OS */
+	if (creator_os > 4)
+		err = INVALID_SB_OS;
+	else
+		*check_mask &= ~CHECK_SB_CREATOR_OS;
+
+	internal_debug("s_creator_os %d.", creator_os);
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_res_uid_gid - Check default UID and GUID for reserved blocks.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_DEF_ID - invalid default UID or/and GID for reserved blocks.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_res_uid_gid(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u16 def_resuid, def_resgid;
+	struct passwd *found_passwd_ptr;
+	struct group *found_group_ptr;
+
+	if (!(*check_mask & CHECK_SB_DEF_RES_UID_GID))
+		return NILFS_OK; /* nothing to be checked */
+
+	def_resuid = le16_to_cpu(sbp->s_def_resuid);
+	def_resgid = le16_to_cpu(sbp->s_def_resgid);
+
+	errno = 0;
+	found_passwd_ptr = getpwuid(def_resuid);
+	if (!found_passwd_ptr) {
+		err = INVALID_SB_DEF_ID;
+		internal_perror("%s", "Can't find user ID.");
+	}
+
+	errno = 0;
+	found_group_ptr = getgrgid(def_resgid);
+	if (!found_group_ptr) {
+		err = INVALID_SB_DEF_ID;
+		internal_perror("%s", "Can't find group ID.");
+	}
+
+	if (NILFS_OK == err)
+		*check_mask &= ~CHECK_SB_DEF_RES_UID_GID;
+
+	internal_debug("s_def_resuid %d.", def_resuid);
+	internal_debug("s_def_resgid %d.", def_resgid);
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_first_ino - Check first user's file inode number.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_FIRST_INO - invalid first user's file inode number.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_first_ino(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_FIRST_INO))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le32_to_cpu(sbp->s_first_ino) != NILFS_USER_INO)
+		err = INVALID_SB_FIRST_INO;
+	else
+		*check_mask &= ~CHECK_SB_FIRST_INO;
+
+	internal_debug("s_first_ino %d.",
+				le32_to_cpu(sbp->s_first_ino));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_inode_size - Check size of on-disk inode.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_INO_SZ - invalid size of on-disk inode.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_inode_size(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_INODE_SZ))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le16_to_cpu(sbp->s_inode_size) != sizeof(struct nilfs_inode))
+		err = INVALID_SB_INO_SZ;
+	else
+		*check_mask &= ~CHECK_SB_INODE_SZ;
+
+	internal_debug("s_inode_size %d.",
+				le16_to_cpu(sbp->s_inode_size));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_dat_entry_size - Check DAT entry size.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_DAT_ENTRY_SZ - invalid DAT entry size.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_dat_entry_size(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_DAT_ENTRY_SZ))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le16_to_cpu(sbp->s_dat_entry_size) !=
+			sizeof(struct nilfs_dat_entry))
+		err = INVALID_SB_DAT_ENTRY_SZ;
+	else
+		*check_mask &= ~CHECK_SB_DAT_ENTRY_SZ;
+
+	internal_debug("s_dat_entry_size %d.",
+			le16_to_cpu(sbp->s_dat_entry_size));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_checkpoint_size - Check size of a checkpoint.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_CHECKPOINT_SZ - invalid size of a checkpoint.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_checkpoint_size(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_CHECKPOINT_SZ))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le16_to_cpu(sbp->s_checkpoint_size) !=
+			sizeof(struct nilfs_checkpoint))
+		err = INVALID_SB_CHECKPOINT_SZ;
+	else
+		*check_mask &= ~CHECK_SB_CHECKPOINT_SZ;
+
+	internal_debug("s_checkpoint_size %d.",
+			le16_to_cpu(sbp->s_checkpoint_size));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_segment_usage_size - Check size of a segment usage.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_SEG_USAGE_SZ - invalid size of a segment usage.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_segment_usage_size(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_SEG_USAGE_SZ))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le16_to_cpu(sbp->s_segment_usage_size) !=
+			sizeof(struct nilfs_segment_usage))
+		err = INVALID_SB_SEG_USAGE_SZ;
+	else
+		*check_mask &= ~CHECK_SB_SEG_USAGE_SZ;
+
+	internal_debug("s_segment_usage_size %d.",
+			le16_to_cpu(sbp->s_segment_usage_size));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_commit_seg_interval - Check commit interval of segment.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_C_INTERVAL - invalid value of commit interval of segment.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_commit_seg_interval(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SB_C_INTERVAL))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le32_to_cpu(sbp->s_c_interval) > 10*60)
+		err = INVALID_SB_C_INTERVAL;
+	else
+		*check_mask &= ~CHECK_SB_C_INTERVAL;
+
+	internal_debug("s_c_interval %d.",
+			le32_to_cpu(sbp->s_c_interval));
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * sb_check_commit_blks_max - Check threshold of data for segment construction.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-INVALID_SB_C_BLK_MAX - invalid threshold of data for segment construction.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int sb_check_commit_blks_max(struct nilfs_super_block *sbp,
+						__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	__u32 commit_blks_max;
+	__u32 blks_per_seg;
+	__u64 nsegs;
+
+	if (!(*check_mask & CHECK_SB_C_BLOCK_MAX))
+		return NILFS_OK; /* nothing to be checked */
+
+	commit_blks_max = le32_to_cpu(sbp->s_c_block_max);
+	blks_per_seg = le32_to_cpu(sbp->s_blocks_per_segment);
+	nsegs = le64_to_cpu(sbp->s_nsegments);
+
+	if (commit_blks_max) {
+		if (commit_blks_max < blks_per_seg ||
+				commit_blks_max >= (nsegs * blks_per_seg))
+			err = INVALID_SB_C_BLK_MAX;
+	} else
+		*check_mask &= ~CHECK_SB_C_BLOCK_MAX;
+
+	internal_debug("s_c_block_max %d.", commit_blks_max);
+	internal_debug("check_mask %llx.", *check_mask);
+
+	return (err > 0) ? -err : err;
+}
+
+/*
+ * nilfs_sb_is_valid - Check that superblock is valid.
+ * @devfd: file descriptor of opened device.
+ * @sbp: pointer on superblock.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_TRUE - superblock is valid.
+ * NILFS_FALSE - superblock is in corrupted state.
+ *
+ * @check_mask contains mask of flags on items which should be checked.
+ * During checking flags of valid items are unset. At the end of working
+ * @check_mask contains flags of corrupted items as set. These set flags
+ * inform about detected errors.
+ */
+int nilfs_sb_is_valid(int devfd,
+			struct nilfs_super_block *sbp,
+			__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	int err2;
+
+	internal_debug("devfd %d", devfd);
+	internal_debug("sbp %p", sbp);
+	internal_debug("check_mask ptr %p", check_mask);
+	if (check_mask)
+		internal_debug("check_mask %lld", *check_mask);
+
+	if (!sbp || !check_mask) {
+		internal_error("%s", nilfs_message[OP_FAILED]);
+		return NILFS_FALSE;
+	}
+
+	err = sb_check_magic(sbp, check_mask);
+	if (err) {
+		*check_mask = CHECK_SB_MAGIC;
+		goto end_check;
+	}
+
+	err = sb_check_size(sbp, check_mask);
+	if (err) {
+		*check_mask = CHECK_SB_BYTES;
+		goto end_check;
+	}
+
+	/* Here function may be finished for the compatibility
+	   with previous way of function using */
+	if (!(*check_mask & CHECK_SB_CRC))
+		goto end_check;
+
+	err = sb_check_crc32(sbp, check_mask);
+	if (err) {
+		*check_mask = CHECK_SB_CRC;
+		goto end_check;
+	}
+
+	err = sb_check_rev_level(sbp, check_mask);
+	if (err) {
+		if (-UNSUPPORTED_SB_REV == err) {
+			*check_mask = CHECK_SB_REV_LEVEL;
+			goto end_check;
+		}
+	}
+
+	/* Check s_feature_compat, s_feature_compat_ro, s_feature_incompat */
+	err2 = sb_check_feature_set(sbp, check_mask);
+	if (err2) {
+		if (-UNSUPPORTED_SB_REV == err2) {
+			*check_mask = CHECK_SB_REV_LEVEL;
+			goto end_check;
+		} else
+			err = err2;
+	}
+
+	err2 = sb_check_fs_flags(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_block_size(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_device_size(devfd, sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_blocks_per_segment(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_nsegments(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_first_data_block(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_r_segs_percentage(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_lite_check_last_cno(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_last_pseg(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_last_seq(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_lite_check_free_blks_count(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_timestamps(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_mnt_count(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_fs_state_flags(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_errors_flag(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_lastcheck(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_creator_os(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_res_uid_gid(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_first_ino(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_inode_size(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_dat_entry_size(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_checkpoint_size(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_segment_usage_size(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_commit_seg_interval(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+	err2 = sb_check_commit_blks_max(sbp, check_mask);
+	if (err2)
+		err = err2;
+
+end_check:
+	if (err) {
+		internal_debug("%s", "superblock corruption is detected");
+		return NILFS_FALSE;
+	} else {
+		internal_debug("%s", "superblock is correct");
+		return NILFS_TRUE;
+	}
 }
 
 static int __nilfs_sb_read(int devfd, struct nilfs_super_block **sbp,
 			   __u64 *offsets)
 {
 	__u64 devsize, sb2_offset;
+	__u64 check_mask = CHECK_SB_MAGIC | CHECK_SB_BYTES;
 
 	sbp[0] = malloc(NILFS_MAX_SB_SIZE);
 	sbp[1] = malloc(NILFS_MAX_SB_SIZE);
@@ -112,7 +1468,7 @@ static int __nilfs_sb_read(int devfd, struct nilfs_super_block **sbp,
 
 	if (lseek(devfd, NILFS_SB_OFFSET_BYTES, SEEK_SET) < 0 ||
 	    read(devfd, sbp[0], NILFS_MAX_SB_SIZE) < 0 ||
-	    !nilfs_sb_is_valid(sbp[0], 0)) {
+	    !nilfs_sb_is_valid(devfd, sbp[0], &check_mask)) {
 		free(sbp[0]);
 		sbp[0] = NULL;
 	}
@@ -125,7 +1481,7 @@ static int __nilfs_sb_read(int devfd, struct nilfs_super_block **sbp,
 
 	if (lseek(devfd, sb2_offset, SEEK_SET) < 0 ||
 	    read(devfd, sbp[1], NILFS_MAX_SB_SIZE) < 0 ||
-	    !nilfs_sb_is_valid(sbp[1], 0))
+	    !nilfs_sb_is_valid(devfd, sbp[1], &check_mask))
 		goto sb2_failed;
 
 	if (sb2_offset <
@@ -169,6 +1525,59 @@ struct nilfs_super_block *nilfs_sb_read(int devfd)
 	return sbp[0];
 }
 
+/*
+ * nilfs_sb_read_unchecked - Read superblocks without check.
+ * @devfd: file descriptor of opened device.
+ * @sbp: array of pointers on superblocks.
+ *
+ * Return value:
+ * NILFS_OK - no errors were detected.
+ * %-CANNOT_READ_SUPERBLOCK - cannot read superblock from disk.
+ * %-INVALID_SB_OFFSET - superblock offset has invalid value.
+ */
+int nilfs_sb_read_unchecked(int devfd,
+				struct nilfs_super_block **sbp)
+{
+	__u64 devsize, sb2_offset;
+	__u16 sb_size = sizeof(struct nilfs_super_block);
+
+	internal_debug("devfd %d, sbp %p", devfd, sbp);
+
+	if (sbp[0] == NULL || sbp[1] == NULL)
+		return 0;
+
+	if (ioctl(devfd, BLKGETSIZE64, &devsize) != 0)
+		goto failed_read;
+
+	if (sbp[0]) {
+		if (lseek(devfd, NILFS_SB_OFFSET_BYTES, SEEK_SET) < 0 ||
+				read(devfd, sbp[0], sb_size) < 0)
+			goto failed_read;
+	}
+
+	if (sbp[1]) {
+		sb2_offset = NILFS_SB2_OFFSET_BYTES(devsize);
+		if (sb2_offset <= (NILFS_SB_OFFSET_BYTES + sb_size))
+			goto invalid_sb_offset;
+
+		if (lseek(devfd, sb2_offset, SEEK_SET) < 0 ||
+				read(devfd, sbp[1], sb_size) < 0)
+			goto failed_read;
+	}
+
+	internal_debug("%s", "superblocks read successfully");
+	return NILFS_OK;
+
+invalid_sb_offset:
+	internal_debug("%s", nilfs_message[INVALID_SB_OFFSET]);
+	return -INVALID_SB_OFFSET;
+
+failed_read:
+	internal_debug("%s",
+			nilfs_message[CANNOT_READ_SUPERBLOCK]);
+	return -CANNOT_READ_SUPERBLOCK;
+}
+
 int nilfs_sb_write(int devfd, struct nilfs_super_block *sbp, int mask)
 {
 	__u64 offsets[2];
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
