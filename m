From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 07/15] nilfs-utils: fsck: NILFS segment summary header
 check implementation
Date: Mon, 12 Nov 2012 13:36:21 +0400
Message-ID: <1352712981.2555.42.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=5mhyplPuqpzeoBBTfB0MI1GaxN7blvbjQeZlMPkGq2o=;
	b=Ki7Le37sfaPHkl3850b5pnKeyJlYwIKEvUZSENfYg8DIDBT7d4EM7uDikjbLwEeyoo6HwQrzpaJELu04QPIQvk3rMmCW5MmSRxC3XXIOgTBCTpkoMLuOtcTbSMgYmtFk;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds nilfs_ss_header_is_valid() function with the purpose of making segment summary header check.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 07/15] nilfs-utils: fsck: NILFS segment summary header check implementation

This patch adds nilfs_ss_header_is_valid() function with the purpose of making segment summary header check.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 lib/segment.c |  509 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 509 insertions(+)
 create mode 100644 lib/segment.c

diff --git a/lib/segment.c b/lib/segment.c
new file mode 100644
index 0000000..9c14fb6
--- /dev/null
+++ b/lib/segment.c
@@ -0,0 +1,509 @@
+/*
+ * segment.c - NILFS2 segment checking functionality
+ *
+ * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This file is part of NILFS.
+ *
+ * NILFS is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * NILFS is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with NILFS; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ */
+
+#include "nilfs.h"
+#include "nilfs_messages.h"
+#include "fsck_nilfs2.h"
+
+/*
+ * ss_check_magic - Check magic signature of segment summary header.
+ * @ss_ptr: pointer on segment summary header.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-INVALID_SS_SIGNATURE - segment summary header has invalid magic.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int ss_check_magic(struct nilfs_segment_summary *ss_ptr,
+						__u16 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SS_MAGIC))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le32_to_cpu(ss_ptr->ss_magic) != NILFS_SEGSUM_MAGIC)
+		err = INVALID_SS_SIGNATURE;
+	else
+		*check_mask &= ~CHECK_SS_MAGIC;
+
+	internal_debug("ss_magic %#x.",
+			le32_to_cpu(ss_ptr->ss_magic));
+	internal_debug("check_mask %x.", *check_mask);
+
+	return (err > 0) ? -err : err;
+} /* ss_check_magic() */
+
+/*
+ * ss_check_header_size - Check segment summary header size in bytes.
+ * @ss_ptr: pointer on segment summary header.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-INVALID_SS_HEADER_SZ - size of segment summary header is invalid.
+ * %-UNSUPPORTED_SS_REV - unsupported revision of segment summary.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int ss_check_header_size(struct nilfs_segment_summary *ss_ptr,
+						__u16 *check_mask)
+{
+	int err = NILFS_OK;
+	__u16 ss_bytes = le16_to_cpu(ss_ptr->ss_bytes);
+
+	if (!(*check_mask & CHECK_SS_BYTES))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (ss_bytes < sizeof(struct nilfs_segment_summary)) {
+		err = INVALID_SS_HEADER_SZ;
+		*check_mask &= (~CHECK_SS_HDR_REV);
+	} else if (ss_bytes > sizeof(struct nilfs_segment_summary)) {
+		err = UNSUPPORTED_SS_REV;
+		*check_mask &= (~CHECK_SS_BYTES);
+	} else
+		*check_mask &= (~(CHECK_SS_BYTES | CHECK_SS_HDR_REV));
+
+	internal_debug("ss_bytes %d.",
+			le16_to_cpu(ss_ptr->ss_bytes));
+	internal_debug("check_mask %x.", *check_mask);
+
+	return (err > 0) ? -err : err;
+} /* ss_check_header_size() */
+
+/*
+ * ss_check_segment_sequence_number - Check segment sequence number.
+ * @segment: current segment number.
+ * @sbp: pointer on superblock.
+ * @ss_ptr: pointer on segment summary header.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-INVALID_SS_SEQ - segment summary header keeps invalid seq number.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int ss_check_segment_sequence_number(__u64 segment,
+				struct nilfs_super_block *sbp,
+				struct nilfs_segment_summary *ss_ptr,
+				__u16 *check_mask)
+{
+	int err = NILFS_OK;
+	__u64 sequence_number;
+	__u64 nsegs;
+	__u64 iteration;
+
+	if (!(*check_mask & CHECK_SS_SEQ))
+		return NILFS_OK; /* nothing to be checked */
+
+	sequence_number = le64_to_cpu(ss_ptr->ss_seq);
+	nsegs = le64_to_cpu(sbp->s_nsegments);
+	iteration = sequence_number / nsegs;
+
+	if ((segment + (nsegs * iteration)) != sequence_number)
+		err = INVALID_SS_SEQ;
+	else
+		*check_mask &= ~CHECK_SS_SEQ;
+
+	internal_debug("ss_seq %lld.",
+			le64_to_cpu(ss_ptr->ss_seq));
+	internal_debug("check_mask %x.", *check_mask);
+
+	return (err > 0) ? -err : err;
+} /* ss_check_segment_sequence_number() */
+
+/*
+ * ss_check_seg_used_blocks_number - Check number of really used blocks.
+ * @sbp: pointer on superblock.
+ * @ss_ptr: pointer on segment summary header.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-INVALID_SS_NBLOCKS - invalid number of really used blocks in segment.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int ss_check_seg_used_blocks_number(struct nilfs_super_block *sbp,
+					struct nilfs_segment_summary *ss_ptr,
+					__u16 *check_mask)
+{
+	int err = NILFS_OK;
+	__u32 nblocks;
+	__u32 blk_size;
+	__u32 seg_sum_blocks;
+
+	if (!(*check_mask & CHECK_SS_NBLOCKS))
+		return NILFS_OK; /* nothing to be checked */
+
+	nblocks = le32_to_cpu(ss_ptr->ss_nblocks);
+	blk_size = (1UL << (le32_to_cpu(sbp->s_log_block_size) +
+					NILFS_SB_BLOCK_SIZE_SHIFT));
+	seg_sum_blocks =
+		ROUNDUP_DIV(le32_to_cpu(ss_ptr->ss_sumbytes), blk_size);
+
+	if (nblocks > le32_to_cpu(sbp->s_blocks_per_segment) ||
+			nblocks <= seg_sum_blocks)
+		err = INVALID_SS_NBLOCKS;
+	else
+		*check_mask &= ~CHECK_SS_NBLOCKS;
+
+	internal_debug("ss_nblocks %d.", nblocks);
+	internal_debug("check_mask %x.", *check_mask);
+
+	return (err > 0) ? -err : err;
+} /* ss_check_seg_used_blocks_number() */
+
+/*
+ * ss_check_flags - Check segment summary header flags.
+ * @ss_ptr: pointer on segment summary header.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-INVALID_SS_FLAGS - unknown flags were detected.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int ss_check_flags(struct nilfs_segment_summary *ss_ptr,
+						__u16 *check_mask)
+{
+	int err = NILFS_OK;
+	__u16 known_flags = NILFS_SS_LOGBGN | NILFS_SS_LOGEND |
+				NILFS_SS_SR | NILFS_SS_SYNDT |
+				NILFS_SS_GC;
+
+	if (!(*check_mask & CHECK_SS_FLAGS))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le16_to_cpu(ss_ptr->ss_flags) & ~known_flags)
+		err = INVALID_SS_FLAGS;
+	else
+		*check_mask &= ~CHECK_SS_FLAGS;
+
+	internal_debug("ss_flags %d.",
+			le16_to_cpu(ss_ptr->ss_flags));
+	internal_debug("check_mask %x.", *check_mask);
+
+	return (err > 0) ? -err : err;
+} /* ss_check_flags() */
+
+/*
+ * ss_check_creation_timestamp - Check segment summary header creation time.
+ * @sbp: pointer on superblock.
+ * @ss_ptr: pointer on segment summary header.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-INVALID_SS_CREATE_TIME - creation timestamp has strange value.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int ss_check_creation_timestamp(struct nilfs_super_block *sbp,
+					struct nilfs_segment_summary *ss_ptr,
+							__u16 *check_mask)
+{
+	int err = NILFS_OK;
+	__u64 ss_create;
+
+	if (!(*check_mask & CHECK_SS_CREATE))
+		return NILFS_OK; /* nothing to be checked */
+
+	ss_create = le64_to_cpu(ss_ptr->ss_create);
+
+	if (ss_create >= time(NULL) || ss_create < le64_to_cpu(sbp->s_ctime))
+		err = INVALID_SS_CREATE_TIME;
+	else
+		*check_mask &= ~CHECK_SS_CREATE;
+
+	internal_debug("ss_create %s.",
+			ctime((const time_t *)&ss_create));
+	internal_debug("check_mask %x.", *check_mask);
+
+	return (err > 0) ? -err : err;
+} /* ss_check_creation_timestamp() */
+
+/*
+ * ss_check_next_seg_start_block - Check next segment start block.
+ * @segment: segment sequence number.
+ * @sbp: pointer on superblock.
+ * @ss_ptr: pointer on segment summary header.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-INVALID_SS_NEXT_SEG_BLK - next segment start block is invalid.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int ss_check_next_seg_start_block(__u64 segment,
+					struct nilfs_super_block *sbp,
+					struct nilfs_segment_summary *ss_ptr,
+							__u16 *check_mask)
+{
+	int err = NILFS_OK;
+	__u64 cur_seg_start_block;
+	__u64 next_seg_start_block;
+	__u64 nsegs;
+	__u32 blks_per_seg;
+	__u64 seg_start_diff;
+	__u64 first_data_block;
+
+	if (!(*check_mask & CHECK_SS_NEXT))
+		return NILFS_OK; /* nothing to be checked */
+
+	cur_seg_start_block = seg_num_to_start_block(segment, sbp);
+	next_seg_start_block = le64_to_cpu(ss_ptr->ss_next);
+	nsegs = le64_to_cpu(sbp->s_nsegments);
+	blks_per_seg = le32_to_cpu(sbp->s_blocks_per_segment);
+	first_data_block = le64_to_cpu(sbp->s_first_data_block);
+	seg_start_diff = (next_seg_start_block > cur_seg_start_block ?
+				next_seg_start_block - cur_seg_start_block :
+				cur_seg_start_block - next_seg_start_block);
+
+	if (next_seg_start_block >= (nsegs * blks_per_seg))
+		err = INVALID_SS_NEXT_SEG_BLK;
+	else if (0 == seg_start_diff)
+		err = INVALID_SS_NEXT_SEG_BLK;
+	else if (0 == segment || next_seg_start_block == first_data_block) {
+		if ((seg_start_diff + first_data_block) < blks_per_seg ||
+			    (seg_start_diff + first_data_block) % blks_per_seg)
+			err = INVALID_SS_NEXT_SEG_BLK;
+		else
+			*check_mask &= ~CHECK_SS_NEXT;
+	} else {
+		if (seg_start_diff < blks_per_seg ||
+				seg_start_diff % blks_per_seg)
+			err = INVALID_SS_NEXT_SEG_BLK;
+		else
+			*check_mask &= ~CHECK_SS_NEXT;
+	}
+
+	internal_debug("ss_next %lld.",
+			le64_to_cpu(ss_ptr->ss_next));
+	internal_debug("check_mask %x.", *check_mask);
+
+	return (err > 0) ? -err : err;
+} /* ss_check_next_seg_start_block() */
+
+/*
+ * ss_check_nfifo - Check number of finfo structures.
+ * @sbp: pointer on superblock.
+ * @ss_ptr: pointer on segment summary header.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-INVALID_SS_NFINFO - invalid number of finfo structures.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int ss_check_nfifo(struct nilfs_super_block *sbp,
+			struct nilfs_segment_summary *ss_ptr,
+			__u16 *check_mask)
+{
+	int err = NILFS_OK;
+	__u32 min_finfo_size;
+	__u32 blk_size;
+
+	if (!(*check_mask & CHECK_SS_NFINFO))
+		return NILFS_OK; /* nothing to be checked */
+
+	min_finfo_size = le32_to_cpu(ss_ptr->ss_nfinfo) *
+		(sizeof(struct nilfs_finfo) + sizeof(union nilfs_binfo));
+	blk_size = (1UL << (le32_to_cpu(sbp->s_log_block_size) +
+					NILFS_SB_BLOCK_SIZE_SHIFT));
+
+	if (le32_to_cpu(ss_ptr->ss_sumbytes) <=
+			sizeof(struct nilfs_segment_summary))
+		err = INVALID_SS_NFINFO;
+	else if (min_finfo_size >
+			(le32_to_cpu(ss_ptr->ss_sumbytes) -
+				sizeof(struct nilfs_segment_summary)))
+		err = INVALID_SS_NFINFO;
+	else if (ROUNDUP_DIV(min_finfo_size, blk_size) >
+				le32_to_cpu(ss_ptr->ss_nblocks))
+		err = INVALID_SS_NFINFO;
+	else
+		*check_mask &= ~CHECK_SS_NFINFO;
+
+	internal_debug("ss_nfinfo %d.",
+			le32_to_cpu(ss_ptr->ss_nfinfo));
+	internal_debug("check_mask %x.", *check_mask);
+
+	return (err > 0) ? -err : err;
+} /* ss_check_nfifo() */
+
+/*
+ * ss_check_cno - Check checkpoint number.
+ * @sbp: pointer on superblock.
+ * @ss_ptr: pointer on segment summary header.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_OK - no internal errors were occured.
+ * %-INVALID_SS_CNO - invalid checkpoint number.
+ *
+ * In the case of valid successfull call @check_mask keeps
+ * flags with detected errors.
+ */
+static int ss_check_cno(struct nilfs_super_block *sbp,
+			struct nilfs_segment_summary *ss_ptr,
+			__u16 *check_mask)
+{
+	int err = NILFS_OK;
+
+	if (!(*check_mask & CHECK_SS_CNO))
+		return NILFS_OK; /* nothing to be checked */
+
+	if (le64_to_cpu(ss_ptr->ss_cno) > le64_to_cpu(sbp->s_last_cno))
+		err = INVALID_SS_CNO;
+	else
+		*check_mask &= ~CHECK_SS_CNO;
+
+	internal_debug("ss_cno %lld.",
+				le64_to_cpu(ss_ptr->ss_cno));
+	internal_debug("check_mask %x.", *check_mask);
+
+	return (err > 0) ? -err : err;
+} /* ss_check_cno() */
+
+/*
+ * nilfs_ss_header_is_valid - Check that segment summary header is valid.
+ * @segment: segment sequence number.
+ * @sbp: pointer on superblock.
+ * @ss_ptr: pointer on segment summary header.
+ * @check_mask: mask that defines what should be checked and returns error.
+ *
+ * Return value:
+ * NILFS_TRUE - segment summary header is valid.
+ * NILFS_FALSE - segment summary header is in corrupted state.
+ *
+ * @check_mask contains mask of flags on items which should be checked.
+ * During checking flags of valid items are unset. At the end of execution
+ * @check_mask contains flags of corrupted items as set. These set flags
+ * inform about detected errors.
+ */
+int nilfs_ss_header_is_valid(__u64 segment,
+				struct nilfs_super_block *sbp,
+				struct nilfs_segment_summary *ss_ptr,
+				__u16 *check_mask)
+{
+	int err = NILFS_OK;
+	int sub_err = NILFS_OK;
+
+	internal_debug("SEG: %lld, sbp %p, ss_ptr %p",
+				segment, sbp, ss_ptr);
+	internal_debug("check_mask ptr %p", check_mask);
+	if (check_mask)
+		internal_debug("check_mask %x", *check_mask);
+
+	if (!sbp || !ss_ptr || !check_mask) {
+		internal_error("%s",
+				nilfs_message[INVALID_PARAMETER]);
+		err = -INVALID_PARAMETER;
+		goto end_ss_check;
+	}
+
+	if (segment >= le64_to_cpu(sbp->s_nsegments)) {
+		internal_error("%s",
+				nilfs_message[INVALID_PARAMETER]);
+		err = -INVALID_PARAMETER;
+		goto end_ss_check;
+	}
+
+	sub_err = ss_check_magic(ss_ptr, check_mask);
+	if (sub_err) {
+		err = sub_err;
+		*check_mask = CHECK_SS_MAGIC;
+		goto end_ss_check;
+	}
+
+	sub_err = ss_check_header_size(ss_ptr, check_mask);
+	if (sub_err) {
+		err = sub_err;
+		if (-UNSUPPORTED_SS_REV == sub_err)
+			*check_mask = CHECK_SS_HDR_REV;
+		else
+			*check_mask = CHECK_SS_BYTES;
+		goto end_ss_check;
+	}
+
+	sub_err = ss_check_segment_sequence_number(segment, sbp,
+							ss_ptr, check_mask);
+	if (sub_err)
+		err = sub_err;
+
+	sub_err = ss_check_seg_used_blocks_number(sbp, ss_ptr, check_mask);
+	if (sub_err)
+		err = sub_err;
+
+	sub_err = ss_check_flags(ss_ptr, check_mask);
+	if (sub_err)
+		err = sub_err;
+
+	sub_err = ss_check_creation_timestamp(sbp, ss_ptr, check_mask);
+	if (sub_err)
+		err = sub_err;
+
+	sub_err = ss_check_next_seg_start_block(segment, sbp,
+						ss_ptr, check_mask);
+	if (sub_err)
+		err = sub_err;
+
+	sub_err = ss_check_nfifo(sbp, ss_ptr, check_mask);
+	if (sub_err)
+		err = sub_err;
+
+	sub_err = ss_check_cno(sbp, ss_ptr, check_mask);
+	if (sub_err)
+		err = sub_err;
+
+end_ss_check:
+	if (-UNSUPPORTED_SS_REV == err) {
+		internal_debug("SEG: %lld unsupported segment summary",
+				segment);
+		return NILFS_TRUE;
+	} else if (err) {
+		internal_debug("SEG: %lld segment summary is corrupted",
+				segment);
+		return NILFS_FALSE;
+	} else {
+		internal_debug("SEG: %lld segment summary is correct",
+				segment);
+		return NILFS_TRUE;
+	}
+} /* nilfs_ss_header_is_valid() */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
