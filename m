From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 10/15] nilfs-utils: fsck: add skeleton of functionality
 for segments checking
Date: Mon, 12 Nov 2012 13:37:05 +0400
Message-ID: <1352713025.2555.45.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=nfRNMkD7SXi5mg480vv0oPNVPM5Tc18eKArKbu/VCB8=;
	b=en4LEWfAhGXgqCIl9P0F+kTiD6TUJRHQPAWFCcsd43+x6q/qw8fAcKpFHY5ZFXDEs1j/Vo/eYqoG42sKXP/WThUlqZy7DIU8lA2AJR2df3J0NHazssaXNCc5GdzahZL8;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds skeleton of functionality for segments checking.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 10/15] nilfs-utils: fsck: add skeleton of functionality for segments checking

This patch adds skeleton of functionality for segments checking.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 sbin/fsck/nilfs_segment.c |  934 +++++++++++++++++++++++++++++++++++++++++++++
 sbin/fsck/nilfs_segment.h |   55 +++
 2 files changed, 989 insertions(+)
 create mode 100644 sbin/fsck/nilfs_segment.c
 create mode 100644 sbin/fsck/nilfs_segment.h

diff --git a/sbin/fsck/nilfs_segment.c b/sbin/fsck/nilfs_segment.c
new file mode 100644
index 0000000..94e2a30
--- /dev/null
+++ b/sbin/fsck/nilfs_segment.c
@@ -0,0 +1,934 @@
+/*
+ * nilfs_segment.c - NILFS segments checking, processing
+ *                   and recovering operations implementation
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
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif	/* HAVE_CONFIG_H */
+
+#include <stdio.h>
+
+#if HAVE_STDLIB_H
+#include <stdlib.h>
+#endif	/* HAVE_STDLIB_H */
+
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif	/* HAVE_UNISTD_H */
+
+#if HAVE_STRING_H
+#include <string.h>
+#endif	/* HAVE_STRING_H */
+
+#include "fsck_common.h"
+#include "fsck_raw_ops.h"
+
+#include "nilfs_superblock.h"
+#include "nilfs_segment.h"
+
+/*****************************************************************************
+ * TODO SECTION
+ *****************************************************************************/
+
+/*
+ * 1. Check ss_sumbytes (total size of segment summary in bytes) during
+ *    segment summary checksum checking.
+ *
+ * 2. Check ss_sumsum (segment summary checksum).
+ *
+ * 3. Check ss_datasum (checksum of data).
+ *
+ * 4. Check ss_cno during checkpoint bitmap construction.
+ */
+
+/*****************************************************************************
+ * FUNCTIONS DECLARATION
+ *****************************************************************************/
+
+/* Build array of segments' references on each other */
+static int build_segs_reference_array(struct nilfs_super_block *sbp);
+
+/* Build bitmap of segments through segments' sequence */
+static int build_bitmap_of_segments(struct nilfs_super_block *sbp,
+						void *seg_buf,
+						__u64 *used_segs_count);
+
+/* Compare array of segments' references and bitmap of segments */
+static int compare_segments_ref_array_and_bitmap(void);
+
+/* Check log validity */
+static int is_nilfs_log_valid(__u64 segment,
+				__u32 log,
+				__u64 start_blk,
+				struct nilfs_super_block *sbp,
+				__u64 *next_start_blk_ptr,
+				void *seg_buf,
+				struct log_check *check_db);
+
+/* Read segment summary header for log */
+static int read_segment_summary_header(__u64 start_block,
+				struct nilfs_super_block *sbp,
+				struct nilfs_segment_summary *ss_ptr);
+
+/* Read segment summary for log */
+static int read_segment_summary(__u64 start_block,
+				struct nilfs_super_block *sbp,
+				void *seg_buf);
+
+/* Define reference of current segment */
+static int set_segment_reference(__u64 segment,
+				__u32 logs_count,
+				struct nilfs_super_block *sbp,
+				struct nilfs_segment_summary *ss_ptr,
+				struct nilfs_segment_reference *array_ptr);
+
+/* Set bit in bitmap for the segment */
+static int set_segment_bitmap(__u64 segment, void *bmp_ptr);
+
+/* Allocate memory for segment */
+static void *allocate_segment_buffer(__u32 size);
+
+/* Free allocated for segment memory */
+static void free_segment_buffer(void *ptr);
+
+/* Check validity of segment summary header */
+static int is_nilfs_ss_header_valid(__u64 segment, __u32 log,
+				struct nilfs_super_block *sbp,
+				struct nilfs_segment_summary *ss_ptr,
+				__u16 *check_mask,
+				int verbosity);
+
+/*****************************************************************************
+ * IMPLEMENTATION SECTION
+ *****************************************************************************/
+
+/*****************************************************************************
+ * NAME:  check_nilfs_segments (fsck.nilfs2)
+ *
+ * FUNCTION:  Go through all segments and check validity.
+ *            It checks validity of metadata organization in segment.
+ *            This function collects data that needs for next checking
+ *            phases.
+ *
+ * RETURNS:
+ * NILFS_OK - NILFS segments was checked successfully.
+ * %-CANNOT_CHECK_SEGMENTS - Segments checking fails because of internal error.
+ * %-CANNOT_BUILD_SEGS_REF_ARRAY - Cannot build segments' reference array.
+ * %-CANNOT_BUILD_SEGS_BITMAP - Cannot build segments bitmap.
+ */
+int check_nilfs_segments(void)
+{
+	int err = NILFS_OK;
+	__u64 used_segs_count = 0;
+	__u32 blk_size;
+	__u32 blks_per_seg;
+	struct nilfs_super_block *sb_ptr = NULL;
+	void *seg_buf = NULL;
+
+	internal_debug("%s", "begin to check volume's segments.");
+
+	if (!SEGS_CHECKING_ENV_READY) {
+		internal_error("%s",
+				nilfs_message[SEGS_CHECK_ENV_NOT_READY]);
+		return -CANNOT_CHECK_SEGMENTS;
+	}
+
+	sb_ptr = get_reliable_sb(CHECK_SB_BLOCK_SZ | CHECK_SB_BLOCKS_PER_SEG |
+					CHECK_SB_NSEGMENTS |
+					CHECK_SB_FIRST_DATA_BLOCK);
+	if (!sb_ptr) {
+		internal_warning("%s", nilfs_message[UNRELIABLE_SB]);
+		return -CANNOT_CHECK_SEGMENTS;
+	}
+
+	blk_size = (1UL << (le32_to_cpu(sb_ptr->s_log_block_size) +
+					NILFS_SB_BLOCK_SIZE_SHIFT));
+	blks_per_seg = le32_to_cpu(sb_ptr->s_blocks_per_segment);
+	seg_buf = allocate_segment_buffer(blks_per_seg * blk_size);
+	if (!seg_buf) {
+		internal_perror("%s",
+					nilfs_message[CANNOT_ALLOCATE]);
+		return -CANNOT_ALLOCATE;
+	}
+
+	err = build_segs_reference_array(sb_ptr);
+	if (err) {
+		internal_error("%s",
+				nilfs_message[CANNOT_CHECK_SEGMENTS]);
+		goto failed_check_nilfs_segments;
+	}
+
+	err = build_bitmap_of_segments(sb_ptr, seg_buf, &used_segs_count);
+	if (-BROKEN_SEGS_CHAIN == err)
+		goto end_check_nilfs_segments;
+	else if (err) {
+		internal_error("%s",
+				nilfs_message[CANNOT_CHECK_SEGMENTS]);
+		goto failed_check_nilfs_segments;
+	}
+
+	err = compare_segments_ref_array_and_bitmap();
+	if (err) {
+		internal_error("%s",
+				nilfs_message[CANNOT_CHECK_SEGMENTS]);
+		goto failed_check_nilfs_segments;
+	}
+
+end_check_nilfs_segments:
+	internal_debug("%s", "volume's segments have checked.");
+
+failed_check_nilfs_segments:
+	free_segment_buffer(seg_buf);
+	return err;
+} /* check_nilfs_segments() */
+
+/*****************************************************************************
+ * NAME:  build_segs_reference_array (fsck.nilfs2)
+ *
+ * FUNCTION:  Build array of segments' references on each other.
+ *
+ * PARAMETERS:
+ * @sbp: Pointer on superblock.
+ *
+ * RETURNS:
+ * NILFS_OK - Array of segments' references was built successfully.
+ * %-INVALID_PARAMETER - Input parameter is invalid.
+ * %-CANNOT_BUILD_SEGS_REF_ARRAY - Cannot build segments' reference array.
+ */
+static int build_segs_reference_array(struct nilfs_super_block *sbp)
+{
+	int err = NILFS_OK;
+	__u64 cur_seg = 0;
+	__u64 nsegs = 0;
+	struct nilfs_segment_summary ss_hdr, last_valid_ss_hdr;
+	__u32 cur_log = 0;
+	__u64 start_seg_blk = 0;
+	__u64 end_seg_blk = 0;
+	__u32 blks_per_seg = 0;
+	__u64 cur_start_log_blk = 0;
+	__u16 check_mask = 0;
+
+	internal_debug("sbp %p.", sbp);
+
+	if (!sbp) {
+		internal_error("%s",
+				nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	nsegs = le64_to_cpu(sbp->s_nsegments);
+	blks_per_seg = le32_to_cpu(sbp->s_blocks_per_segment);
+
+	for (cur_seg = 0; cur_seg < nsegs; cur_seg++) {
+		cur_log = 0;
+		start_seg_blk = seg_num_to_start_block(cur_seg, sbp);
+		end_seg_blk = start_seg_blk + blks_per_seg - 1;
+		cur_start_log_blk = start_seg_blk;
+		memset(&last_valid_ss_hdr, 0xFF,
+				sizeof(struct nilfs_segment_summary));
+
+		/* go through logs */
+		do {
+			err = read_segment_summary_header(cur_start_log_blk,
+								sbp,
+								&ss_hdr);
+			if (err) {
+				internal_error(
+				    "SEG: %lld LOG: %d. %s",
+				    cur_seg, cur_log,
+				    nilfs_message[CANNOT_BUILD_SEGS_REF_ARRAY]);
+				err = -CANNOT_BUILD_SEGS_REF_ARRAY;
+				goto failed_build_segs_ref_array;
+			}
+
+			check_mask = CHECK_SS_MAGIC | CHECK_SS_BYTES;
+			err = is_nilfs_ss_header_valid(cur_seg, cur_log, sbp,
+							&ss_hdr, &check_mask,
+							KEEP_SILENCE);
+			if (-INVALID_SS_SIGNATURE == err ||
+					-UNSUPPORTED_SS_REV == err)
+				break;
+			else if (err) {
+				internal_error(
+				    "SEG: %lld LOG: %d. %s",
+				    cur_seg, cur_log,
+				    nilfs_message[CANNOT_BUILD_SEGS_REF_ARRAY]);
+				err = -CANNOT_BUILD_SEGS_REF_ARRAY;
+				goto failed_build_segs_ref_array;
+			}
+
+			memcpy(&last_valid_ss_hdr, &ss_hdr,
+					sizeof(struct nilfs_segment_summary));
+			cur_start_log_blk =
+			    cur_start_log_blk + le32_to_cpu(ss_hdr.ss_nblocks);
+			cur_log++;
+		} while (cur_start_log_blk < end_seg_blk);
+
+		if (0 == cur_log)
+			continue;
+
+		err = set_segment_reference(cur_seg, cur_log, sbp,
+						&last_valid_ss_hdr,
+						seg_refs_array_ptr);
+		if (err) {
+			internal_error(
+				"SEG: %lld. %s", cur_seg,
+				nilfs_message[CANNOT_BUILD_SEGS_REF_ARRAY]);
+			err = -CANNOT_BUILD_SEGS_REF_ARRAY;
+			goto failed_build_segs_ref_array;
+		}
+	}
+
+	return NILFS_OK;
+
+failed_build_segs_ref_array:
+	return err;
+} /* build_segs_reference_array() */
+
+/*****************************************************************************
+ * NAME:  build_bitmap_of_segments (fsck.nilfs2)
+ *
+ * FUNCTION:  Build bitmap of segments through segments' sequence.
+ *
+ * PARAMETERS:
+ * @sbp: Pointer on superblock.
+ * @seg_buf: Pointer on segment buffer (should be allocated before call).
+ * @used_segs_count: Calculated number of used segments [returned].
+ *
+ * RETURNS:
+ * NILFS_OK - Bitmap of segments was built successfully.
+ * %-INVALID_PARAMETER - Input parameter is invalid.
+ * %-CANNOT_BUILD_SEGS_BMP - Cannot build segments bitmap.
+ */
+static int build_bitmap_of_segments(struct nilfs_super_block *sbp,
+						void *seg_buf,
+						__u64 *used_segs_count)
+{
+	int err = NILFS_OK;
+	__u64 cur_seg = 0;
+	__u64 nsegs = 0;
+	__u64 segs_count = 0;
+	__u64 last_segment = 0;
+	__u32 cur_log = 0;
+	__u64 cur_seg_start_blk = 0;
+	__u64 cur_seg_end_blk = 0;
+	__u32 blks_per_seg = 0;
+	__u64 cur_log_start_blk = 0;
+	__u64 next_log_start_blk = 0;
+	struct segment_check *segments = detected_err_db.segments;
+
+	internal_debug("sbp %p, seg_buf %p, segments %p.",
+					sbp, seg_buf, segments);
+
+	if (!sbp || !seg_buf || !used_segs_count || !segments) {
+		internal_error("%s",
+				nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	(*used_segs_count) = 0;
+
+	nsegs = le64_to_cpu(sbp->s_nsegments);
+	last_segment = le64_to_cpu(sbp->s_last_seq);
+	blks_per_seg = le32_to_cpu(sbp->s_blocks_per_segment);
+	cur_seg_start_blk = seg_num_to_start_block(cur_seg, sbp);
+	cur_seg_end_blk = cur_seg_start_blk + blks_per_seg - 1;
+
+	/* Build bitmap of segments through segments' sequence */
+	for (; segs_count <= nsegs; segs_count++) {
+
+		cur_log = 0;
+		cur_log_start_blk = cur_seg_start_blk;
+		next_log_start_blk = -1;
+
+		if (segs_count == nsegs) {
+			/*
+			 * Temporary the logic very simple.
+			 * Simply go through all the chains and
+			 * stop when the count of segments become
+			 * equal to number of segments on volume.
+			 *
+			 * TODO: implement properly.
+			 */
+
+			/*detected_err_db.volume.errs_bmp |=
+				SEGS_CHAIN_INCONSISTENT;
+			err = fs_description(BROKEN_SEGS_CHAIN,
+						cur_seg, cur_log);*/
+			break;
+		}
+
+		if (cur_seg >= detected_err_db.segs_count) {
+			internal_error("%s",
+				nilfs_message[CANNOT_BUILD_SEGS_BMP]);
+			internal_debug("cur_seg %lld, cur_log %d.",
+						cur_seg, cur_log);
+			err = -CANNOT_BUILD_SEGS_BMP;
+			goto failed_build_bitmap_of_segments;
+		}
+
+		if (0 == segments[cur_seg].logs_count)
+			goto define_next_segment;
+
+		if (!segments[cur_seg].logs) {
+			internal_error("%s",
+				nilfs_message[CANNOT_BUILD_SEGS_BMP]);
+			internal_debug("cur_seg %lld, cur_log %d.",
+						cur_seg, cur_log);
+			err = -CANNOT_BUILD_SEGS_BMP;
+			goto failed_build_bitmap_of_segments;
+		}
+
+		/* Go through logs */
+		do {
+			if ((cur_log + 1) > segments[cur_seg].logs_count)
+				break;
+
+			err = is_nilfs_log_valid(cur_seg,
+					cur_log,
+					cur_log_start_blk,
+					sbp,
+					&next_log_start_blk,
+					seg_buf,
+					&(segments[cur_seg].logs[cur_log]));
+
+			if (-EMPTY_LOG_DETECTED == err)
+				break;
+			else if (-INVALID_NILFS_LOG == err)
+				break;
+			else if (err) {
+				internal_error("%s",
+					nilfs_message[CANNOT_BUILD_SEGS_BMP]);
+				internal_debug("cur_seg %lld, cur_log %d.",
+							cur_seg, cur_log);
+				err = -CANNOT_BUILD_SEGS_BMP;
+				goto failed_build_bitmap_of_segments;
+			}
+
+			cur_log_start_blk = next_log_start_blk;
+			cur_log++;
+		} while (cur_log_start_blk < cur_seg_end_blk);
+
+
+		err = set_segment_bitmap(cur_seg, segments_bitmap_ptr);
+		if (err) {
+			internal_error("%s",
+					nilfs_message[CANNOT_BUILD_SEGS_BMP]);
+			internal_debug("cur_seg %lld.", cur_seg);
+			goto failed_build_bitmap_of_segments;
+		}
+
+define_next_segment:
+		if (cur_seg == last_segment)
+			break;
+
+		cur_seg = seg_refs_array_ptr[cur_seg].next_seg;
+		cur_seg_start_blk = seg_num_to_start_block(cur_seg, sbp);
+		cur_seg_end_blk = cur_seg_start_blk + blks_per_seg - 1;
+	}
+
+	(*used_segs_count) = segs_count;
+
+	internal_debug("used_segs_count %lld.",
+				(*used_segs_count));
+
+	return NILFS_OK;
+
+failed_build_bitmap_of_segments:
+	return err;
+} /* build_bitmap_of_segments() */
+
+/* Compare array of segments' references and bitmap of segments */
+static int compare_segments_ref_array_and_bitmap(void)
+{
+	/*segs_count = 0;
+
+	for (cur_seg = 0; segs_count < used_segs_count; segs_count++) {
+		err = check_segment_reference(cur_seg,
+						seg_refs_array_ptr,
+						segments_bitmap_ptr);
+		if (err);
+		cur_seg = get_next_seg_by_ref(cur_seg);
+	}*/
+
+	/*internal_info("<%s>: %s", __func__, nilfs_message[NOT_IMPLEMENTED]);*/
+
+	/* <TODO: implement> */
+	return NILFS_OK;
+} /* compare_segments_ref_array_and_bitmap() */
+
+/*****************************************************************************
+ * NAME:  is_nilfs_log_valid (fsck.nilfs2)
+ *
+ * FUNCTION:  Check log validity.
+ *
+ * PARAMETERS:
+ * @segment: Segment number.
+ * @log: Log number.
+ * @start_blk: Start block of log in segment.
+ * @sbp: Pointer on superblock.
+ * @next_start_blk_ptr: Pointer on returned value of next log start block.
+ * @seg_buf: Pointer on segment buffer (should be allocated before call).
+ * @check_db: Pointer on structure that contains checking flags for log.
+ *
+ * RETURNS:
+ * NILFS_OK - Log validity has checked successfully.
+ * %-INVALID_PARAMETER - Input parameter is invalid.
+ * %-EMPTY_LOG_DETECTED - Empty log is detected in the segment.
+ * %-CANNOT_CHECK_LOG - Cannot check log validity.
+ * %-INVALID_NILFS_LOG - NILFS log is in corrupted state.
+ */
+static int is_nilfs_log_valid(__u64 segment,
+				__u32 log,
+				__u64 start_blk,
+				struct nilfs_super_block *sbp,
+				__u64 *next_start_blk_ptr,
+				void *seg_buf,
+				struct log_check *check_db)
+{
+	int err = NILFS_OK;
+	struct nilfs_segment_summary *ss_ptr;
+
+	internal_debug("segment %lld, log %d, start_blk %lld.",
+					segment, log, start_blk);
+	internal_debug("next_start_blk_ptr %p, seg_buf %p.",
+				next_start_blk_ptr, seg_buf);
+
+	if (!next_start_blk_ptr || !seg_buf) {
+		internal_error("%s",
+				nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	(*next_start_blk_ptr) = -1;
+
+	err = read_segment_summary(start_blk, sbp, seg_buf);
+	ss_ptr = (struct nilfs_segment_summary *)seg_buf;
+
+	if (-SS_FINFO_SECTION_EMPTY == err) {
+		if (0 == ss_ptr->ss_magic &&
+				0 == ss_ptr->ss_bytes &&
+				0 == ss_ptr->ss_nblocks &&
+				0 == ss_ptr->ss_nfinfo &&
+				0 == ss_ptr->ss_sumbytes) {
+			internal_debug("SEG %lld LOG: %d. %s",
+					segment, log,
+					nilfs_message[EMPTY_LOG_DETECTED]);
+			return -EMPTY_LOG_DETECTED;
+		}
+	} else if (-DATA_PROCCESSED_PARTIALLY == err)
+		err = NILFS_OK; /* Do nothing. Simply ignore error. */
+	else if (err) {
+		internal_error("SEG: %lld LOG: %d. %s",
+				segment, log,
+				nilfs_message[CANNOT_CHECK_LOG]);
+		err = -CANNOT_CHECK_LOG;
+		goto failed_check_log;
+	}
+
+	/* Check segment summary header */
+	check_db->ss_hdr.check_mask = SS_HEADER_ONLY_CHECK;
+
+	err = is_nilfs_ss_header_valid(segment, log, sbp, ss_ptr,
+					&(check_db->ss_hdr.check_mask),
+					BE_VERBOSE);
+
+	check_db->ss_hdr.check_mask |= ONLY_SS_HDR_HAS_CHECKED;
+
+	if (-INVALID_SS_SIGNATURE == err || -UNSUPPORTED_SS_REV == err) {
+		err = fs_description(INVALID_NILFS_LOG, segment, log);
+		goto end_check_log;
+	} else if (err) {
+		internal_error("SEG: %lld LOG: %d. %s",
+				segment, log,
+				nilfs_message[CANNOT_CHECK_LOG]);
+		err = -CANNOT_CHECK_LOG;
+		goto failed_check_log;
+	}
+
+	/* Check segment summary checksum */
+	/* Check segment summary */
+	/* Check rest of log */
+
+	(*next_start_blk_ptr) = start_blk + le32_to_cpu(ss_ptr->ss_nblocks);
+
+end_check_log:
+	/*internal_info("<%s>: %s", __func__, nilfs_message[NOT_IMPLEMENTED]);*/
+
+	/* <TODO: implement> */
+
+	return NILFS_OK;
+
+failed_check_log:
+	return err;
+} /* is_nilfs_log_valid() */
+
+/*****************************************************************************
+ * NAME:  allocate_segment_buffer (fsck.nilfs2)
+ *
+ * FUNCTION:  Allocate memory for segment buffer.
+ *
+ * PARAMETERS:
+ * @size: Buffer size in bytes.
+ *
+ * RETURNS:
+ * Valid memory pointer or NULL in the case of failure.
+ */
+static void *allocate_segment_buffer(__u32 size)
+{
+	void *ptr = NULL;
+
+	internal_debug("allocate memory %d for segment.",
+					size);
+
+	ptr = calloc(size, 1);
+	if (!ptr)
+		internal_perror("%s", nilfs_message[CANNOT_ALLOCATE]);
+
+	return ptr;
+} /* allocate_segment_buffer() */
+
+
+/*****************************************************************************
+ * NAME:  free_segment_buffer (fsck.nilfs2)
+ *
+ * FUNCTION:  Free allocated for segment memory.
+ *
+ * PARAMETERS:
+ * @size: Buffer size in bytes.
+ *
+ * RETURNS:
+ * Valid memory pointer or NULL in the case of failure.
+ */
+static void free_segment_buffer(void *ptr)
+{
+	internal_debug("free memory of segment buffer %p.",
+							ptr);
+
+	if (ptr)
+		free(ptr);
+} /* free_segment_buffer() */
+
+/*****************************************************************************
+ * NAME:  read_segment_summary_header (fsck.nilfs2)
+ *
+ * FUNCTION:  Read segment summary header for log.
+ *
+ * PARAMETERS:
+ * @start_block: Start block for read.
+ * @sbp: Pointer on superblock.
+ * @ss_ptr: Pointer on segment summary header buffer (should be allocated yet).
+ *
+ * RETURNS:
+ * NILFS_OK - Segment summary header was read successfully.
+ * %-INVALID_PARAMETER - Input parameter is invalid.
+ * %-DATA_PROCCESSED_PARTIALLY - Segment summary header is read partially.
+ */
+static int read_segment_summary_header(__u64 start_block,
+				struct nilfs_super_block *sbp,
+				struct nilfs_segment_summary *ss_ptr)
+{
+	int err = NILFS_OK;
+	__u32 blk_size;
+	__u32 read_bytes = 0;
+
+	internal_debug("start_block %lld, ss_ptr %p.",
+					start_block, ss_ptr);
+
+	if (!sbp || !ss_ptr) {
+		internal_error("%s",
+				nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	blk_size = (1UL << (le32_to_cpu(sbp->s_log_block_size) +
+					NILFS_SB_BLOCK_SIZE_SHIFT));
+
+	err = read_raw_bytes(start_block * blk_size,
+				ss_ptr, sizeof(*ss_ptr),
+				&read_bytes);
+	if (err) {
+		internal_debug("start_block %lld %s",
+				start_block,
+				nilfs_message[CANNOT_READ_SEG_SUM_HEADER]);
+		goto failed_read_segment_summary_header;
+	}
+
+	if (read_bytes != sizeof(*ss_ptr)) {
+		internal_error("start_block %lld. %s",
+				start_block,
+				nilfs_message[DATA_PROCCESSED_PARTIALLY]);
+		err = -DATA_PROCCESSED_PARTIALLY;
+		goto failed_read_segment_summary_header;
+	}
+
+	return NILFS_OK;
+
+failed_read_segment_summary_header:
+	return err;
+} /* read_segment_summary() */
+
+/*****************************************************************************
+ * NAME:  read_segment_summary (fsck.nilfs2)
+ *
+ * FUNCTION:  Read segment summary for log.
+ *
+ * PARAMETERS:
+ * @start_block: Start block for read.
+ * @sbp: Pointer on superblock.
+ * @seg_buf: Pointer on segment buffer (should be allocated yet).
+ *
+ * RETURNS:
+ * NILFS_OK - Segment summary was read successfully.
+ * %-INVALID_PARAMETER - Input parameter is invalid.
+ * %-SS_FINFO_SECTION_EMPTY - Segment summary hasn't finfo section.
+ * %-CANNOT_READ_SEG_SUMMARY - Cannot read because of internal error.
+ * %-DATA_PROCCESSED_PARTIALLY - Segment summary is read partially.
+ */
+static int read_segment_summary(__u64 start_block,
+				struct nilfs_super_block *sbp,
+				void *seg_buf)
+{
+	int err = NILFS_OK;
+	__u64 read_offset;
+	__u32 blk_size;
+	__u32 blks_per_seg;
+	struct nilfs_segment_summary *ss_ptr = NULL;
+	__u32 seg_sum_size;
+	__u32 read_bytes = 0;
+
+	internal_debug("start_block %lld, sbp %p, seg_buf %p.",
+				start_block, sbp, seg_buf);
+
+	if (!sbp || !seg_buf) {
+		internal_error("%s",
+				nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	ss_ptr = (struct nilfs_segment_summary *)seg_buf;
+	err = read_segment_summary_header(start_block, sbp, ss_ptr);
+	if (err)
+		goto failed_read_seg_sum;
+
+	seg_sum_size = le32_to_cpu(ss_ptr->ss_sumbytes);
+	blk_size = (1UL << (le32_to_cpu(sbp->s_log_block_size) +
+					NILFS_SB_BLOCK_SIZE_SHIFT));
+	blks_per_seg = le32_to_cpu(sbp->s_blocks_per_segment);
+
+	if (seg_sum_size < sizeof(struct nilfs_segment_summary))
+		return -SS_FINFO_SECTION_EMPTY;
+	else if (seg_sum_size > (blks_per_seg * blk_size))
+		seg_sum_size = blks_per_seg * blk_size;
+
+	read_offset = (start_block * blk_size) +
+				sizeof(struct nilfs_segment_summary);
+
+	err = read_raw_bytes(read_offset,
+			seg_buf + sizeof(struct nilfs_segment_summary),
+			seg_sum_size - sizeof(struct nilfs_segment_summary),
+			&read_bytes);
+	if (err) {
+		internal_debug("start_block %lld %s",
+				start_block,
+				nilfs_message[CANNOT_READ_SEG_SUMMARY]);
+		goto failed_read_seg_sum;
+	}
+
+	if (read_bytes !=
+			(le32_to_cpu(ss_ptr->ss_sumbytes) -
+				sizeof(struct nilfs_segment_summary))) {
+		internal_error("start_block %lld. %s",
+				start_block,
+				nilfs_message[DATA_PROCCESSED_PARTIALLY]);
+		err = -DATA_PROCCESSED_PARTIALLY;
+		goto failed_read_seg_sum;
+	}
+
+	return NILFS_OK;
+
+failed_read_seg_sum:
+	return err;
+}
+
+/*****************************************************************************
+ * NAME:  set_segment_reference (fsck.nilfs2)
+ *
+ * FUNCTION:  Define reference of current segment.
+ *
+ * PARAMETERS:
+ * @segment: Segment number.
+ * @logs_count: Count of logs in segment.
+ * @sbp: Pointer on superblock.
+ * @ss_ptr: Pointer on segment summary buffer.
+ * @array_ptr: Pointer on segments' references array.
+ *
+ * RETURNS:
+ * NILFS_OK - Segment's reference was defined successfully.
+ * %-INVALID_PARAMETER - Input parameter is invalid.
+ * %-CANNOT_ALLOCATE - Cannot allocate memory for log checking environment.
+ */
+static int set_segment_reference(__u64 segment,
+				__u32 logs_count,
+				struct nilfs_super_block *sbp,
+				struct nilfs_segment_summary *ss_ptr,
+				struct nilfs_segment_reference *array_ptr)
+{
+	__u64 next_seg;
+
+	internal_debug("SEG: %lld, logs_count %d",
+				segment, logs_count);
+	internal_debug("sbp %p, ss_ptr %p, array_ptr %p",
+				sbp, ss_ptr, array_ptr);
+
+	if (!sbp || !ss_ptr || !array_ptr) {
+		internal_error("%s", nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	if (segment >= le64_to_cpu(sbp->s_nsegments)) {
+		internal_error("%s", nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	next_seg = block_to_seg_num(le64_to_cpu(ss_ptr->ss_next), sbp);
+
+	array_ptr[segment].seg_seq_id = le64_to_cpu(ss_ptr->ss_seq);
+	array_ptr[segment].next_seg = next_seg;
+
+	if (next_seg < le64_to_cpu(sbp->s_nsegments))
+		array_ptr[next_seg].prev_seg = segment;
+
+	array_ptr[segment].logs_count = logs_count;
+
+	if (detected_err_db.segments) {
+		detected_err_db.segments[segment].logs =
+			calloc(sizeof(struct log_check), logs_count);
+		if (!detected_err_db.segments[segment].logs) {
+			internal_perror("%s",
+					nilfs_message[CANNOT_ALLOCATE]);
+			return -CANNOT_ALLOCATE;
+		}
+		detected_err_db.segments[segment].logs_count = logs_count;
+	}
+
+	return NILFS_OK;
+} /* set_segment_reference() */
+
+/* Set bit in bitmap for the segment */
+static int set_segment_bitmap(__u64 segment, void *bmp_ptr)
+{
+	/*internal_info("<%s>: %s", __func__, nilfs_message[NOT_IMPLEMENTED]);*/
+
+	/* <TODO: implement> */
+	return NILFS_OK;
+} /* set_segment_bitmap() */
+
+/*****************************************************************************
+ * NAME:  is_nilfs_ss_header_valid (fsck.nilfs2)
+ *
+ * FUNCTION:  Check validity of segment summary header.
+ *
+ * PARAMETERS:
+ * @segment: Segment number.
+ * @log: Log number.
+ * @sbp: Pointer on superblock.
+ * @ss_ptr: Pointer on segment summary header.
+ * @check_mask: Check mask defines what should be checked.
+ * @verbosity: Verbosity level [KEEP_SILENCE | BE_VERBOSE].
+ *
+ * RETURNS:
+ * NILFS_OK - Segment summary header was checked successfully.
+ * %-INVALID_PARAMETER - Input parameter is invalid.
+ * %-INVALID_SS_SIGNATURE - Segment summary header magic is invalid.
+ * %-UNSUPPORTED_SS_REV - Unsupported revision of segment summary header.
+ *
+ * @check_mask contains mask of flags on items which should be checked.
+ * During checking flags of valid items are unset. At the end of working
+ * @check_mask contains flags of corrupted items as set. These set flags
+ * inform about detected errors.
+ */
+static int is_nilfs_ss_header_valid(__u64 segment, __u32 log,
+				struct nilfs_super_block *sbp,
+				struct nilfs_segment_summary *ss_ptr,
+				__u16 *check_mask,
+				int verbosity)
+{
+	int err = NILFS_OK;
+
+	/* Declaration order is crucial!!! */
+	int ss_hdr_err_id[SS_HDR_CHECK_FLAGS_MAX] = {
+/*WARNING*/
+		INVALID_SS_SIGNATURE,		/*CHECK_SS_MAGIC*/
+		UNSUPPORTED_SS_REV,		/*CHECK_SS_HDR_REV*/
+/*CRITICAL*/
+		INVALID_SS_DATASUM,		/*CHECK_SS_DATASUM*/
+		INVALID_SS_SUMSUM,		/*CHECK_SS_SUMSUM*/
+		INVALID_SS_HEADER_SZ,		/*CHECK_SS_BYTES*/
+		INVALID_SS_NBLOCKS,		/*CHECK_SS_NBLOCKS*/
+		INVALID_SS_NEXT_SEG_BLK,	/*CHECK_SS_NEXT*/
+		INVALID_SS_NFINFO,		/*CHECK_SS_NFIFO*/
+		INVALID_SS_SUMBYTES,		/*CHECK_SS_SUMBYTES*/
+/*MINOR*/
+		INVALID_SS_SEQ,			/*CHECK_SS_SEQ*/
+		INVALID_SS_FLAGS,		/*CHECK_SS_FLAGS*/
+/*LOOKS_LIKE_ERROR*/
+		INVALID_SS_CREATE_TIME,		/*CHECK_SS_CREATE*/
+		INVALID_SS_CNO,			/*CHECK_SS_CNO*/
+	};
+
+	internal_debug("%s", "check segment summary header validity.");
+	internal_debug("SEG %lld, sbp %p, ss_ptr %p, check_mask %p.",
+				segment, sbp, ss_ptr, check_mask);
+
+	if (!sbp || !ss_ptr || !check_mask) {
+		err = INVALID_PARAMETER;
+		goto failed_check_seg_sum_hdr;
+	}
+
+	if (!nilfs_ss_header_is_valid(segment, sbp, ss_ptr, check_mask)) {
+		if (BE_VERBOSE == verbosity) {
+			print_fs_detected_errors(check_mask,
+					ss_hdr_err_id,
+					SS_HDR_CHECK_FLAGS_MAX,
+					segment,
+					log);
+		} else if (KEEP_SILENCE != verbosity) {
+			err = INVALID_PARAMETER;
+			goto failed_check_seg_sum_hdr;
+		}
+
+		if ((*check_mask) & CHECK_SS_MAGIC)
+			return -INVALID_SS_SIGNATURE;
+
+		if ((*check_mask) & CHECK_SS_HDR_REV)
+			return -UNSUPPORTED_SS_REV;
+	}
+
+	return NILFS_OK;
+
+failed_check_seg_sum_hdr:
+	internal_error("%s", nilfs_message[err]);
+	return -err;
+} /* is_nilfs_ss_header_valid() */
diff --git a/sbin/fsck/nilfs_segment.h b/sbin/fsck/nilfs_segment.h
new file mode 100644
index 0000000..6503a5c
--- /dev/null
+++ b/sbin/fsck/nilfs_segment.h
@@ -0,0 +1,55 @@
+/*
+ * nilfs_segment.h - Declarations of operations for NILFS segments
+ *                   checking, processing and recovering
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
+#ifndef NILFS_SEGMENT_H
+#define NILFS_SEGMENT_H
+
+/* Pointer on segment references array */
+extern struct nilfs_segment_reference *seg_refs_array_ptr;
+
+/* Pointer on segments bitmap */
+extern int *segments_bitmap_ptr;
+
+/*
+ * SEGS_CHECKING_ENV_READY
+ *
+ * MACRO:  Check readiness of segments checking environment.
+ *
+ * RETURNS:
+ * NILFS_TRUE - Segments checking environment is ready.
+ * NILFS_FALSE - Segments checking environment is *not* ready.
+ */
+#define SEGS_CHECKING_ENV_READY \
+	((seg_refs_array_ptr && segments_bitmap_ptr) ? NILFS_TRUE : NILFS_FALSE)
+
+/*
+ * Go through all segments and check validity.
+ * It checks validity of metadata organization in segment.
+ * This function collects data that needs for next checking
+ * phases.
+ */
+int check_nilfs_segments(void);
+
+#endif /* NILFS_SEGMENT_H */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
