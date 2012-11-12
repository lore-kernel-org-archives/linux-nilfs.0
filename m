From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 09/15] nilfs-utils: fsck: add functionality of superblock
 checking
Date: Mon, 12 Nov 2012 13:36:52 +0400
Message-ID: <1352713012.2555.44.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=grvyAXg+e8/1Hs1akav4Bgh3uGwXQZTjY/4MC1GI7AM=;
	b=NWR7w7noFO4JkHSQWAmNGrmLXPFZFym8JyTlm4iVMZzZ/XrAUaH2zPKOXTPJMfmR9aPRsqGJiYTfw+xYBwAPscaf5LS4fvej4bG/uib/IyQElYg7kPhI8tsjbK5iMRnX;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds functionality of superblock checking.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 09/15] nilfs-utils: fsck: add functionality of superblock checking

This patch adds functionality of superblock checking.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 sbin/fsck/nilfs_superblock.c |  851 ++++++++++++++++++++++++++++++++++++++++++
 sbin/fsck/nilfs_superblock.h |   44 +++
 2 files changed, 895 insertions(+)
 create mode 100644 sbin/fsck/nilfs_superblock.c
 create mode 100644 sbin/fsck/nilfs_superblock.h

diff --git a/sbin/fsck/nilfs_superblock.c b/sbin/fsck/nilfs_superblock.c
new file mode 100644
index 0000000..686ad24
--- /dev/null
+++ b/sbin/fsck/nilfs_superblock.c
@@ -0,0 +1,851 @@
+/*
+ * nilfs_superblock.c - NILFS superblocks checking, processing
+ *                      and recovering operations implementation
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
+
+/*****************************************************************************
+ * FUNCTIONS DECLARATION
+ *****************************************************************************/
+
+/* Allocate memory for superblock */
+static int allocate_superblock(int sb_type);
+
+/* Free memory allocated for superblock */
+static int free_superblock(int sb_type);
+
+/* Read superblocks from disk */
+static int read_superblocks(void);
+
+/* Check that superblock is valid */
+static int is_nilfs_superblock_valid(int sb_type, __u64 *check_mask);
+
+/* Compare superblocks with the purpose of checking */
+static int compare_superblocks(void);
+
+/*****************************************************************************
+ * IMPLEMENTATION SECTION
+ *****************************************************************************/
+
+/*****************************************************************************
+ * NAME:  get_nilfs_superblocks (fsck.nilfs2)
+ *
+ * FUNCTION:  Allocate memory and read primary and secondary
+ *            superblocks from disk.
+ *
+ * RETURNS:
+ * NILFS_OK - primary and secondary superblocks are read successfully.
+ * %-CANNOT_ALLOCATE - cannot allocate memory for superblock.
+ * %-CANNOT_READ_SUPERBLOCK - cannot read superblock from disk.
+ */
+int get_nilfs_superblocks(void)
+{
+	int err = NILFS_OK;
+
+	internal_debug("%s", "try to read superblocks from disk.");
+
+	err = allocate_superblock(PRIMARY_SUPERBLOCK);
+	if (err)
+		goto get_nilfs_superblocks_failed;
+
+	err = allocate_superblock(SECONDARY_SUPERBLOCK);
+	if (err)
+		goto free_primary_superblock;
+
+	err = read_superblocks();
+	if (err)
+		goto free_secondary_superblock;
+
+	internal_debug("%s", "nilfs superblocks are read successfully.");
+	return NILFS_OK;
+
+free_secondary_superblock:
+	free_superblock(SECONDARY_SUPERBLOCK);
+
+free_primary_superblock:
+	free_superblock(PRIMARY_SUPERBLOCK);
+
+get_nilfs_superblocks_failed:
+	return err;
+} /* get_nilfs_superblocks() */
+
+/*****************************************************************************
+ * NAME:  free_nilfs_superblocks (fsck.nilfs2)
+ *
+ * FUNCTION:  Free memory allocated for superblocks.
+ *
+ * RETURNS:
+ * NILFS_OK - primary and secondary superblocks are freed successfully.
+ * %-CANNOT_FREE - cannot free memory for superblocks.
+ */
+int free_nilfs_superblocks(void)
+{
+	int err_sb1 = NILFS_OK;
+	int err_sb2 = NILFS_OK;
+
+	internal_debug("%s", "try to free memory of superblocks.");
+
+	err_sb1 = free_superblock(PRIMARY_SUPERBLOCK);
+	err_sb2 = free_superblock(SECONDARY_SUPERBLOCK);
+
+	if (NILFS_OK != err_sb1 || NILFS_OK != err_sb2) {
+		internal_debug("%s",
+			"some error occurs during memory freeing.");
+		return -CANNOT_FREE;
+	}
+
+	internal_debug("%s", "superblocks memory has freed successfully.");
+	return NILFS_OK;
+
+} /* free_nilfs_superblocks() */
+
+/*****************************************************************************
+ * NAME:  check_nilfs_superblocks (fsck.nilfs2)
+ *
+ * FUNCTION:  Check primary and secondary NILFS superblocks.
+ *
+ * RETURNS:
+ * %-SB1_OK_SB2_OK - Primary and secondary superblocks are valid.
+ * %-NILFS_NOT_FOUND - NILFS superblocks are not detected.
+ * %-ONLY_SB1_OK_FOUND - Primary valid superblock was found but secondary *not*.
+ * %-ONLY_SB1_CORRUPTED_FOUND - Only corrupted primary superblock was found.
+ * %-ONLY_SB2_OK_FOUND - Secondary valid superblock was found but primary *not*.
+ * %-ONLY_SB2_CORRUPTED_FOUND - Only corrupted secondary superblock was found.
+ * %-SB1_SB2_CORRUPTED - Primary and secondary superblocks are corrupted.
+ * %-SB1_OK_SB2_CORRUPTED - Primary superblock is valid, secondary is corrupted.
+ * %-SB1_CORRUPTED_SB2_OK - Secondary superblock is valid, primary is corrupted.
+ * %-CANNOT_DETECT_SB_STATE - Cannot detect state of superblock. Internal error.
+ */
+int check_nilfs_superblocks(void)
+{
+	enum sb_detected_states {
+		SB1_VALID              = 1 << 0,
+		SB1_CORRUPTED          = 1 << 1,
+		SB1_NOT_FOUND          = 1 << 2,
+		SB2_VALID              = 1 << 3,
+		SB2_CORRUPTED          = 1 << 4,
+		SB2_NOT_FOUND          = 1 << 5,
+		ALL_POSSIBLE_SB_STATES = 1 << 6
+	}; /* enum sb_detected_states */
+
+	int err;
+	int sb_states = 0;
+	__u64 *sb1_check_mask =
+			&detected_err_db.sb[PRIMARY_SUPERBLOCK].check_mask;
+	__u64 *sb2_check_mask =
+			&detected_err_db.sb[SECONDARY_SUPERBLOCK].check_mask;
+
+	int return_states[ALL_POSSIBLE_SB_STATES];
+	memset(return_states, -1, sizeof(int) * ALL_POSSIBLE_SB_STATES);
+	return_states[SB1_VALID | SB2_VALID] = SB1_OK_SB2_OK;
+	return_states[SB1_CORRUPTED | SB2_VALID] = SB1_CORRUPTED_SB2_OK;
+	return_states[SB1_NOT_FOUND | SB2_VALID] = ONLY_SB2_OK_FOUND;
+	return_states[SB1_VALID | SB2_CORRUPTED] = SB1_OK_SB2_CORRUPTED;
+	return_states[SB1_CORRUPTED | SB2_CORRUPTED] = SB1_SB2_CORRUPTED;
+	return_states[SB1_NOT_FOUND | SB2_CORRUPTED] = ONLY_SB2_CORRUPTED_FOUND;
+	return_states[SB1_VALID | SB2_NOT_FOUND] = ONLY_SB1_OK_FOUND;
+	return_states[SB1_CORRUPTED | SB2_NOT_FOUND] = ONLY_SB1_CORRUPTED_FOUND;
+	return_states[SB1_NOT_FOUND | SB2_NOT_FOUND] = NILFS_NOT_FOUND;
+
+	internal_debug("%s", "try to check NILFS superblocks.");
+
+	err = is_nilfs_signature_ok(superblocks[PRIMARY_SUPERBLOCK]);
+	if (NILFS_OK == err) {
+		internal_debug("%s", "primary superblock has valid signature.");
+
+		*sb1_check_mask = SB_FULL_CHECK;
+		err = is_nilfs_superblock_valid(
+					PRIMARY_SUPERBLOCK, sb1_check_mask);
+
+		*sb1_check_mask |= SB_HAS_CHECKED;
+
+		if (-UNSUPPORTED_SB_REV == err) {
+			internal_debug("%s",
+				"primary superblock unsupported.");
+			sb_states |= SB1_NOT_FOUND;
+		} else if (NILFS_OK != err) {
+			if ((*sb1_check_mask) & SB_CORRUPTION_MASK) {
+				detected_err_db.volume.errs_bmp |=
+						SB_CORRUPTION_DETECTED;
+				internal_debug("%s",
+					"primary superblock is corrupted.");
+				sb_states |= SB1_CORRUPTED;
+			} else {
+				internal_debug("%s",
+					"primary superblock is inconsistent.");
+				sb_states |= SB1_VALID;
+			}
+		} else {
+			internal_debug("%s",
+				"primary superblock is valid.");
+			sb_states |= SB1_VALID;
+		}
+
+		internal_debug("sb_states has %d value.", sb_states);
+	} else if (-INVALID_NILFS_SIGNATURE == err) {
+		sb_states |= SB1_NOT_FOUND;
+		internal_debug("%s", "primary superblock is not found.");
+		internal_debug("sb_states has %d value.", sb_states);
+	} else
+		goto check_sb_internal_error;
+
+	err = is_nilfs_signature_ok(superblocks[SECONDARY_SUPERBLOCK]);
+	if (NILFS_OK == err) {
+		internal_debug("%s",
+			"secondary superblock has valid signature.");
+
+		*sb2_check_mask = SB_FULL_CHECK;
+		err = is_nilfs_superblock_valid(
+					SECONDARY_SUPERBLOCK, sb2_check_mask);
+
+		*sb2_check_mask |= SB_HAS_CHECKED;
+
+		if (-UNSUPPORTED_SB_REV == err) {
+			internal_debug("%s", "secondary sb unsupported.");
+			sb_states |= SB2_NOT_FOUND;
+		} else if (NILFS_OK != err) {
+			if ((*sb2_check_mask) & SB_CORRUPTION_MASK) {
+				detected_err_db.volume.errs_bmp |=
+						SB_CORRUPTION_DETECTED;
+				internal_debug("%s",
+					"secondary superblock is corrupted.");
+				sb_states |= SB2_CORRUPTED;
+			} else {
+				internal_debug("%s",
+					"secondary superblock is inconsistent.");
+				sb_states |= SB2_VALID;
+			}
+		} else {
+			internal_debug("%s", "secondary superblock is valid.");
+			sb_states |= SB2_VALID;
+		}
+
+		internal_debug("sb_states has %d value.", sb_states);
+	} else if (-INVALID_NILFS_SIGNATURE == err) {
+		sb_states |= SB2_NOT_FOUND;
+		internal_debug("%s", "secondary superblock is not found.");
+		internal_debug("sb_states has %d value.", sb_states);
+	} else
+		goto check_sb_internal_error;
+
+	if (((*sb1_check_mask) & CHECK_SB_CLEAN_UMOUNT_FLAG) &&
+			((*sb2_check_mask) & CHECK_SB_CLEAN_UMOUNT_FLAG)) {
+		fs_description(NOT_CLEAN_UMOUNT_DETECTED,
+				UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	internal_debug("return_states has %d value.",
+			return_states[sb_states]);
+
+	if (-1 == return_states[sb_states])
+		goto check_sb_internal_error;
+	else if (NILFS_NOT_FOUND == return_states[sb_states])
+		goto check_sb_fs_description;
+	else if ((sb_states & SB1_NOT_FOUND) ||
+				(sb_states & SB2_NOT_FOUND))
+		goto check_sb_fs_description;
+	/*else if (SB1_OK_SB2_OK != return_states[sb_states])
+		goto check_sb_fs_description;*/
+
+	err = compare_superblocks();
+	if (err) {
+		if (-FATAL_SB_DIFF == err)
+			return fs_description(FATAL_SB_DIFF,
+					UNKNOWN_SEGMENT, UNKNOWN_LOG);
+		else
+			goto check_sb_internal_error;
+	}
+
+check_sb_fs_description:
+	return fs_description(return_states[sb_states],
+				UNKNOWN_SEGMENT, UNKNOWN_LOG);
+
+check_sb_internal_error:
+	internal_error("%s",
+			nilfs_message[CANNOT_DETECT_SB_STATE]);
+	return -CANNOT_DETECT_SB_STATE;
+} /* check_nilfs_superblocks() */
+
+/*****************************************************************************
+ * NAME:  get_reliable_sb (fsck.nilfs2)
+ *
+ * FUNCTION:  Get valid or less corrupted superblock.
+ *
+ * PARAMETERS:
+ * @flags: Set of flags defines requested reliable superblock's field(s).
+ *
+ * RETURNS:
+ * Pointer on superblock or NULL in the case of failure.
+ */
+struct nilfs_super_block *get_reliable_sb(__u64 flags)
+{
+	__u64 *sb1_errs_bmap =
+		&detected_err_db.sb[PRIMARY_SUPERBLOCK].errs_bmp;
+	__u64 *sb2_errs_bmap =
+		&detected_err_db.sb[SECONDARY_SUPERBLOCK].errs_bmp;
+	__u64 sb1_local_check, sb2_local_check;
+	int sb1_errs_count, sb2_errs_count;
+	struct nilfs_super_block *sbp1 = superblocks[PRIMARY_SUPERBLOCK];
+	struct nilfs_super_block *sbp2 = superblocks[SECONDARY_SUPERBLOCK];
+
+	internal_debug("for %llx flag.", flags);
+
+	if (!sbp1 || !sbp2) {
+		internal_error("%s",
+				nilfs_message[MEMORY_NOT_ALLOCATED]);
+		return NULL;
+	}
+
+	if (!(*sb1_errs_bmap & SB_HAS_CHECKED) ||
+			!(*sb2_errs_bmap & SB_HAS_CHECKED)) {
+		sb1_local_check = flags;
+		is_nilfs_superblock_valid(
+				PRIMARY_SUPERBLOCK, &sb1_local_check);
+		sb2_local_check = flags;
+		is_nilfs_superblock_valid(
+				SECONDARY_SUPERBLOCK, &sb2_local_check);
+	} else {
+		sb1_local_check = (*sb1_errs_bmap) & flags;
+		sb2_local_check = (*sb2_errs_bmap) & flags;
+	}
+
+	sb1_local_check &= SB_CORRUPTION_MASK;
+	sb2_local_check &= SB_CORRUPTION_MASK;
+
+	sb1_errs_count = popcount_4(sb1_local_check);
+	sb2_errs_count = popcount_4(sb2_local_check);
+
+	if (!sb1_errs_count && !sb2_errs_count) {
+		if (le64_to_cpu(sbp1->s_wtime) > le64_to_cpu(sbp2->s_wtime)) {
+			internal_debug("%s", "primary SB is reliable.");
+			return sbp1;
+		} else {
+			internal_debug("%s", "secondary SB is reliable.");
+			return sbp2;
+		}
+	}
+
+	if (sb1_errs_count < sb2_errs_count) {
+		internal_warning("%s", nilfs_message[USE_CORRUPTED_SB]);
+		internal_debug("%s", "primary SB is using.");
+		return sbp1;
+	} else if (sb1_errs_count != sb2_errs_count) {
+		internal_warning("%s", nilfs_message[USE_CORRUPTED_SB]);
+		internal_debug("%s", "secondary SB is using.");
+		return sbp2;
+	}
+
+	internal_warning("%s", nilfs_message[USE_CORRUPTED_SB]);
+	internal_debug("%s", "primary SB is using.");
+
+	return sbp1;
+} /* get_reliable_sb() */
+
+/*****************************************************************************
+ * NAME:  allocate_superblock (fsck.nilfs2)
+ *
+ * FUNCTION:  Allocate memory for superblock.
+ *
+ * PARAMETERS:
+ * @sb_type: Type of superblock.
+ *
+ * RETURNS:
+ * NILFS_OK - memory for superblock is allocated successfully.
+ * %-INVALID_PARAMETER - inavalid input parameter.
+ * %-CANNOT_ALLOCATE - cannot allocate memory for superblock.
+ */
+static int allocate_superblock(int sb_type)
+{
+	struct nilfs_super_block *sb_ptr = NULL;
+
+	internal_debug("try to allocate memory for %d superblock type.",
+			sb_type);
+
+	if (sb_type >= SUPERBLOCK_TYPES_NUMBER) {
+		internal_error("%s",
+				nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	if (superblocks[sb_type]) {
+		internal_error("%s",
+				nilfs_message[CANNOT_ALLOCATE]);
+		internal_debug("superblock of %d type has allocated yet",
+				sb_type);
+		return -CANNOT_ALLOCATE;
+	}
+
+	sb_ptr = calloc(sizeof(struct nilfs_super_block), 1);
+	if (NULL == sb_ptr) {
+		internal_perror("%s", nilfs_message[CANNOT_ALLOCATE]);
+		return -CANNOT_ALLOCATE;
+	}
+
+	superblocks[sb_type] = sb_ptr;
+
+	internal_debug("memory for %d superblock type has allocated.",
+			sb_type);
+
+	return NILFS_OK;
+} /* allocate_superblock() */
+
+/*****************************************************************************
+ * NAME:  free_superblock (fsck.nilfs2)
+ *
+ * FUNCTION:  Free memory allocated for superblock.
+ *
+ * PARAMETERS:
+ * @sb_type: Type of superblock.
+ *
+ * RETURNS:
+ * NILFS_OK - memory for superblock is freed successfully.
+ * %-INVALID_PARAMETER - inavalid input parameter.
+ * %-CANNOT_FREE - cannot free memory for superblock.
+ */
+static int free_superblock(int sb_type)
+{
+	internal_debug("try to free memory for %d superblock type.",
+			sb_type);
+
+	if (sb_type >= SUPERBLOCK_TYPES_NUMBER) {
+		internal_error("%s",
+				nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	if (NULL == superblocks[sb_type]) {
+		internal_warning("%s", nilfs_message[CANNOT_FREE]);
+		internal_debug("superblock of %d type *not* allocated yet",
+				sb_type);
+		return -CANNOT_FREE;
+	}
+
+	free(superblocks[sb_type]);
+	superblocks[sb_type] = NULL;
+
+	internal_debug("superblock of %d type has freed", sb_type);
+
+	return NILFS_OK;
+} /* free_superblock() */
+
+/*****************************************************************************
+ * NAME:  read_superblocks (fsck.nilfs2)
+ *
+ * FUNCTION:  Read superblocks from disk.
+ *
+ * RETURNS:
+ * NILFS_OK - superblock has read successfully.
+ * %-INVALID_PARAMETER - inavalid input parameter.
+ * %-CANNOT_READ_SUPERBLOCK - cannot read superblock from disk.
+ */
+static int read_superblocks(void)
+{
+	int err = NILFS_OK;
+	int devfd = -1;
+
+	internal_debug("%s", "try to read superblocks.");
+
+	if (NULL == superblocks[PRIMARY_SUPERBLOCK] ||
+		NULL == superblocks[SECONDARY_SUPERBLOCK]) {
+		internal_debug("%s", "superblocks are *not* allocated yet");
+		goto cannot_read_superblock;
+	}
+
+	devfd = device_file_descriptor();
+	if (-1 == devfd) {
+		internal_debug("Device file descriptor: %d.", devfd);
+		goto cannot_read_superblock;
+	}
+
+	err = nilfs_sb_read_unchecked(devfd, superblocks);
+	if (err)
+		goto cannot_read_superblock;
+
+	internal_debug("%s", "superblock is read successfully");
+	return NILFS_OK;
+
+cannot_read_superblock:
+	internal_error("%s", nilfs_message[CANNOT_READ_SUPERBLOCK]);
+	return -CANNOT_READ_SUPERBLOCK;
+} /* read_superblocks() */
+
+/*****************************************************************************
+ * NAME:  is_nilfs_signature_ok (fsck.nilfs2)
+ *
+ * FUNCTION:  Check that superblock contains valid NILFS signature.
+ *
+ * PARAMETERS:
+ * @sb_ptr: Pointer on superblock.
+ *
+ * RETURNS:
+ * NILFS_OK - superblock contains valid NILFS signature.
+ * %-INVALID_PARAMETER - inavalid input parameter.
+ * %-INVALID_NILFS_SIGNATURE - superblock signature is invalid.
+ */
+int is_nilfs_signature_ok(const struct nilfs_super_block *sb_ptr)
+{
+	internal_debug("%s", "check signature of superblock.");
+
+	if (NULL == sb_ptr) {
+		internal_error("%s", nilfs_message[INVALID_PARAMETER]);
+		internal_debug("%s", "pointer on superblock is NULL.");
+		return -INVALID_PARAMETER;
+	}
+
+	if (le16_to_cpu(sb_ptr->s_magic) != NILFS_SUPER_MAGIC)
+		return fs_description(INVALID_NILFS_SIGNATURE,
+					UNKNOWN_SEGMENT, UNKNOWN_LOG);
+
+	internal_debug("%s", "NILFS signature is ok.");
+	return NILFS_OK;
+} /* is_nilfs_signature_ok() */
+
+/*****************************************************************************
+ * NAME:  is_nilfs_superblock_valid (fsck.nilfs2)
+ *
+ * FUNCTION:  Check that superblock is valid.
+ *
+ * PARAMETERS:
+ * @sb_type: Type of superblock.
+ * @check_mask: Check mask defines what should be checked.
+ *
+ * RETURNS:
+ * NILFS_OK - superblock is valid.
+ * %-CANNOT_CHECK_SB - cannot check superblock because of internal error.
+ * %-INVALID_SB - superblock is in corrupted state.
+ * %-UNSUPPORTED_SB_REV - unsupported revision of NILFS superblock.
+ *
+ * @check_mask contains mask of flags on items which should be checked.
+ * During checking flags of valid items are unset. At the end of working
+ * @check_mask contains flags of corrupted items as set. These set flags
+ * inform about detected errors.
+ */
+static int is_nilfs_superblock_valid(int sb_type, __u64 *check_mask)
+{
+	int err = NILFS_OK;
+	int devfd = -1;
+	struct nilfs_super_block *sb_ptr = 0;
+	__u64 segment;
+
+	/* Declaration order is crucial!!! */
+	int sb_err_id[SB_CHECK_FLAGS_MAX_NUM] = {
+		INVALID_NILFS_SIGNATURE,	/*CHECK_SB_MAGIC*/
+		UNSUPPORTED_SB_REV,		/*CHECK_SB_REV_LEVEL*/
+/*CRITICAL*/
+		INVALID_SB_SIZE,		/*CHECK_SB_BYTES*/
+		INVALID_CRC,			/*CHECK_SB_CRC*/
+		INVALID_BLOCK_SIZE,		/*CHECK_SB_BLOCK_SZ*/
+		INVALID_SB_DEV_SIZE,		/*CHECK_SB_DEV_SZ*/
+		INVALID_SB_BLOCKS_PER_SEG,	/*CHECK_SB_BLOCKS_PER_SEG*/
+		INVALID_SB_NSEGMENTS,		/*CHECK_SB_NSEGMENTS*/
+		INVALID_SB_FIRST_DATA_BLOCK,	/*CHECK_SB_FIRST_DATA_BLOCK*/
+		INVALID_SB_R_SEGS_PERCENTAGE,	/*CHECK_SB_R_SEGS_PERCENT*/
+		INVALID_SB_LAST_CNO,		/*CHECK_SB_LAST_CNO*/
+		INVALID_SB_LAST_PSEG,		/*CHECK_SB_LAST_PSEG*/
+		INVALID_SB_LAST_SEQ,		/*CHECK_SB_LAST_SEQ*/
+		INVALID_SB_FREE_BLKS,		/*CHECK_SB_FREE_BLKS*/
+		INVALID_SB_FS_STATE,		/*CHECK_SB_STATE*/
+		INVALID_SB_FIRST_INO,		/*CHECK_SB_FIRST_INO*/
+		INVALID_SB_INO_SZ,		/*CHECK_SB_INODE_SZ*/
+		INVALID_SB_DAT_ENTRY_SZ,	/*CHECK_SB_DAT_ENTRY_SZ*/
+		INVALID_SB_CHECKPOINT_SZ,	/*CHECK_SB_CHECKPOINT_SZ*/
+		INVALID_SB_SEG_USAGE_SZ,	/*CHECK_SB_SEG_USAGE_SZ*/
+/*MINOR*/
+		INVALID_SB_FEATURE,		/*CHECK_SB_FEATURE*/
+		UNSUPPORTED_SB_RO_FEATURE,	/*CHECK_SB_RO_FEATURE*/
+		INVALID_SB_FLAGS,		/*CHECK_SB_FLAGS*/
+		INVALID_SB_OS,			/*CHECK_SB_CREATOR_OS*/
+		INVALID_SB_DEF_ID,		/*CHECK_SB_DEF_RES_UID_GID*/
+		INVALID_SB_C_INTERVAL,		/*CHECK_SB_C_INTERVAL*/
+		INVALID_SB_C_BLK_MAX,		/*CHECK_SB_C_BLOCK_MAX*/
+/*LOOKS_LIKE_ERROR*/
+		INVALID_SB_TIMES,		/*CHECK_SB_TIMES*/
+		MAX_POSSIBLE_MNT_COUNT,		/*CHECK_SB_MNT_COUNT*/
+		INVALID_SB_FS_ERRORS,		/*CHECK_SB_ERRORS*/
+		INVALID_SB_LAST_CHECK,		/*CHECK_SB_LAST_CHECK*/
+		NOT_VALID_FS_STATE_FLAG,	/*CHECK_SB_CLEAN_UMOUNT_FLAG*/
+		FS_ERRORS_DETECTED_BY_DRIVER,	/*CHECK_SB_ERRS_DETECTED_FLAG*/
+	};
+
+	internal_debug("%s", "check superblock validity.");
+	internal_debug("sbp %p, check_mask %p.",
+				sb_ptr, check_mask);
+
+	if (sb_type >= SUPERBLOCK_TYPES_NUMBER ||
+				NULL == check_mask ||
+				NULL == superblocks[sb_type]) {
+		err = CANNOT_CHECK_SB;
+		goto failed_check_sb;
+	}
+
+	sb_ptr = superblocks[sb_type];
+
+	devfd = device_file_descriptor();
+	if (-1 == devfd) {
+		internal_debug("Device file descriptor: %d.",
+				devfd);
+		err = CANNOT_CHECK_SB;
+		goto failed_check_sb;
+	}
+
+	if (!nilfs_sb_is_valid(devfd, sb_ptr, check_mask)) {
+		if (PRIMARY_SUPERBLOCK == sb_type)
+			segment = NILFS_PRIMARY_SB_SEG;
+		else
+			segment = le64_to_cpu(NILFS_SECONDARY_SB_SEG(sb_ptr));
+		print_fs_detected_errors(check_mask,
+					sb_err_id, SB_CHECK_FLAGS_MAX_NUM,
+					segment, NILFS_SB_LOG);
+
+		if ((*check_mask) & CHECK_SB_REV_LEVEL)
+			return -UNSUPPORTED_SB_REV;
+
+		if ((*check_mask) & CHECK_SB_RO_FEATURE)
+			fsck_work_mode &= (~FSCK_RW_POLICY_MASK | FSCK_RO_MODE);
+		else
+			fsck_work_mode &= (~FSCK_RW_POLICY_MASK | FSCK_RW_MODE);
+
+		return -INVALID_SB;
+	}
+
+	internal_debug("%s", "superblock is valid.");
+
+	return NILFS_OK;
+
+failed_check_sb:
+	internal_error("%s", nilfs_message[err]);
+	return -err;
+} /* is_nilfs_superblock_valid() */
+
+/*****************************************************************************
+ * NAME:  compare_superblocks (fsck.nilfs2)
+ *
+ * FUNCTION:  Compare superblocks with the purpose of checking.
+ *
+ * RETURNS:
+ * NILFS_OK - superblocks compared successfully.
+ * %-MEMORY_NOT_ALLOCATED - superblocks is not allocated yet.
+ * %-FATAL_SB_DIFF - superblocks have fatal difference (fatal corruption).
+ */
+static int compare_superblocks(void)
+{
+	int err = NILFS_OK;
+	struct nilfs_super_block *sbp1 = superblocks[PRIMARY_SUPERBLOCK];
+	struct nilfs_super_block *sbp2 = superblocks[SECONDARY_SUPERBLOCK];
+
+	internal_debug("sbp1 %p, sbp2 %p.", sbp1, sbp2);
+
+	if (!sbp1 || !sbp2) {
+		internal_error("%s",
+				nilfs_message[MEMORY_NOT_ALLOCATED]);
+		return -MEMORY_NOT_ALLOCATED;
+	}
+
+	if (sbp1->s_log_block_size != sbp2->s_log_block_size) {
+		internal_debug("s_log_block_size: sbp1 %d, sbp2 %d.",
+					le32_to_cpu(sbp1->s_log_block_size),
+					le32_to_cpu(sbp2->s_log_block_size));
+		fs_description(SB_BLK_SIZE_DIFF, UNKNOWN_SEGMENT, UNKNOWN_LOG);
+		err = -FATAL_SB_DIFF;
+	}
+
+	if (sbp1->s_nsegments != sbp2->s_nsegments) {
+		internal_debug("s_nsegments: sbp1 %lld, sbp2 %lld.",
+					le64_to_cpu(sbp1->s_nsegments),
+					le64_to_cpu(sbp2->s_nsegments));
+		fs_description(SB_NSEGS_DIFF, UNKNOWN_SEGMENT, UNKNOWN_LOG);
+		err = -FATAL_SB_DIFF;
+	}
+
+	if (sbp1->s_dev_size != sbp2->s_dev_size) {
+		internal_debug("s_dev_size: sbp1 %lld, sbp2 %lld.",
+					le64_to_cpu(sbp1->s_dev_size),
+					le64_to_cpu(sbp2->s_dev_size));
+		fs_description(SB_DEV_SIZE_DIFF, UNKNOWN_SEGMENT, UNKNOWN_LOG);
+		err = -FATAL_SB_DIFF;
+	}
+
+	if (sbp1->s_blocks_per_segment != sbp2->s_blocks_per_segment) {
+		internal_debug("s_blocks_per_segment: sbp1 %d, sbp2 %d.",
+				le32_to_cpu(sbp1->s_blocks_per_segment),
+				le32_to_cpu(sbp2->s_blocks_per_segment));
+		fs_description(SB_BLKS_PER_SEG_DIFF,
+				UNKNOWN_SEGMENT, UNKNOWN_LOG);
+		err = -FATAL_SB_DIFF;
+	}
+
+	if (sbp1->s_r_segments_percentage != sbp2->s_r_segments_percentage) {
+		internal_debug("s_r_segs_percentage: sbp1 %d, sbp2 %d.",
+				le32_to_cpu(sbp1->s_r_segments_percentage),
+				le32_to_cpu(sbp2->s_r_segments_percentage));
+		fs_description(SB_R_SEGS_PERCENTAGE_DIFF,
+				UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	if (sbp1->s_last_cno != sbp2->s_last_cno) {
+		internal_debug("s_last_cno: sbp1 %lld, sbp2 %lld.",
+				le64_to_cpu(sbp1->s_last_cno),
+				le64_to_cpu(sbp2->s_last_cno));
+		fs_description(SB_LAST_CNO_DIFF, UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	if (sbp1->s_last_pseg != sbp2->s_last_pseg) {
+		internal_debug("s_last_pseg: sbp1 %lld, sbp2 %lld.",
+				le64_to_cpu(sbp1->s_last_pseg),
+				le64_to_cpu(sbp2->s_last_pseg));
+		fs_description(SB_LAST_PSEG_DIFF, UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	if (sbp1->s_last_seq != sbp2->s_last_seq) {
+		internal_debug("s_last_seq: sbp1 %lld, sbp2 %lld.",
+				le64_to_cpu(sbp1->s_last_seq),
+				le64_to_cpu(sbp1->s_last_seq));
+		fs_description(SB_LAST_SEQ_DIFF, UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	if (sbp1->s_free_blocks_count != sbp2->s_free_blocks_count) {
+		internal_debug("s_free_blocks: sbp1 %lld, sbp2 %lld.",
+				le64_to_cpu(sbp1->s_free_blocks_count),
+				le64_to_cpu(sbp1->s_free_blocks_count));
+		fs_description(SB_FREE_BLKS_DIFF, UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	if (sbp1->s_ctime != sbp2->s_ctime) {
+		__u64 sb1_ctime = le64_to_cpu(sbp1->s_ctime);
+		__u64 sb2_ctime = le64_to_cpu(sbp2->s_ctime);
+		internal_debug("s_ctime: sbp1 %s, sbp2 %s.",
+					ctime((const time_t *)&sb1_ctime),
+					ctime((const time_t *)&sb2_ctime));
+		fs_description(SB_CTIME_DIFF, UNKNOWN_SEGMENT, UNKNOWN_LOG);
+		err = -FATAL_SB_DIFF;
+	}
+
+	if (sbp1->s_mtime != sbp2->s_mtime) {
+		__u64 sb1_mtime = le64_to_cpu(sbp1->s_mtime);
+		__u64 sb2_mtime = le64_to_cpu(sbp2->s_mtime);
+		internal_debug("s_mtime: sbp1 %s, sbp2 %s.",
+					ctime((const time_t *)&sb1_mtime),
+					ctime((const time_t *)&sb2_mtime));
+		fs_description(SB_MTIME_DIFF, UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	if (sbp1->s_wtime != sbp2->s_wtime) {
+		__u64 sb1_wtime = le64_to_cpu(sbp1->s_wtime);
+		__u64 sb2_wtime = le64_to_cpu(sbp2->s_wtime);
+		internal_debug("s_wtime: sbp1 %s, sbp2 %s.",
+					ctime((const time_t *)&sb1_wtime),
+					ctime((const time_t *)&sb2_wtime));
+		fs_description(SB_WTIME_DIFF, UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	if (sbp1->s_mnt_count != sbp2->s_mnt_count) {
+		internal_debug("s_mnt_count: sbp1 %d, sbp2 %d.",
+				le16_to_cpu(sbp1->s_mnt_count),
+				le16_to_cpu(sbp2->s_mnt_count));
+		fs_description(SB_MNT_COUNT_DIFF, UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	if (sbp1->s_max_mnt_count != sbp2->s_max_mnt_count) {
+		internal_debug("s_max_mnt_count: sbp1 %d, sbp2 %d.",
+				le16_to_cpu(sbp1->s_max_mnt_count),
+				le16_to_cpu(sbp2->s_max_mnt_count));
+		fs_description(SB_MAX_MNT_COUNT_DIFF,
+					UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	if (sbp1->s_state != sbp2->s_state) {
+		internal_debug("s_state: sbp1 %#x, sbp2 %#x.",
+				le16_to_cpu(sbp1->s_state),
+				le16_to_cpu(sbp2->s_state));
+		fs_description(SB_FS_STATE_DIFF,
+					UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	if (sbp1->s_lastcheck != sbp2->s_lastcheck) {
+		__u64 sb1_lastcheck = le64_to_cpu(sbp1->s_lastcheck);
+		__u64 sb2_lastcheck = le64_to_cpu(sbp2->s_lastcheck);
+		internal_debug("s_lastcheck: sbp1 %s, sbp2 %s.",
+					ctime((const time_t *)&sb1_lastcheck),
+					ctime((const time_t *)&sb2_lastcheck));
+		fs_description(SB_LASTCHECK_DIFF,
+					UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	if (0 != memcmp(sbp1->s_uuid, sbp2->s_uuid, 16)) {
+		internal_debug("UUID: "
+				"sb1 %02x%02x%02x%02x-%02x%02x-%02x%02x-"
+				"%02x%02x-%02x%02x%02x%02x%02x%02x, "
+				"sb2 %02x%02x%02x%02x-%02x%02x-%02x%02x-"
+				"%02x%02x-%02x%02x%02x%02x%02x%02x.",
+				sbp1->s_uuid[0], sbp1->s_uuid[1],
+				sbp1->s_uuid[2], sbp1->s_uuid[3],
+				sbp1->s_uuid[4], sbp1->s_uuid[5],
+				sbp1->s_uuid[6], sbp1->s_uuid[7],
+				sbp1->s_uuid[8], sbp1->s_uuid[9],
+				sbp1->s_uuid[10], sbp1->s_uuid[11],
+				sbp1->s_uuid[12], sbp1->s_uuid[13],
+				sbp1->s_uuid[14], sbp1->s_uuid[15],
+				sbp2->s_uuid[0], sbp2->s_uuid[1],
+				sbp2->s_uuid[2], sbp2->s_uuid[3],
+				sbp2->s_uuid[4], sbp2->s_uuid[5],
+				sbp2->s_uuid[6], sbp2->s_uuid[7],
+				sbp2->s_uuid[8], sbp2->s_uuid[9],
+				sbp2->s_uuid[10], sbp2->s_uuid[11],
+				sbp2->s_uuid[12], sbp2->s_uuid[13],
+				sbp2->s_uuid[14], sbp2->s_uuid[15]);
+		fs_description(SB_UUID_DIFF, UNKNOWN_SEGMENT, UNKNOWN_LOG);
+		err = -FATAL_SB_DIFF;
+	}
+
+	if (0 != memcmp(sbp1->s_volume_name, sbp2->s_volume_name, 80)) {
+		internal_debug("s_volume_name: sbp1 %s, sbp2 %s.",
+					sbp1->s_volume_name,
+					sbp2->s_volume_name);
+		fs_description(SB_VOL_NAMES_DIFF,
+					UNKNOWN_SEGMENT, UNKNOWN_LOG);
+	}
+
+	return err;
+} /* compare_superblocks() */
diff --git a/sbin/fsck/nilfs_superblock.h b/sbin/fsck/nilfs_superblock.h
new file mode 100644
index 0000000..68461cd
--- /dev/null
+++ b/sbin/fsck/nilfs_superblock.h
@@ -0,0 +1,44 @@
+/*
+ * nilfs_superblock.h - Declarations of operations for NILFS superblocks
+ *                      checking, processing and recovering
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
+#ifndef NILFS_SUPERBLOCK_H
+#define NILFS_SUPERBLOCK_H
+
+/* Allocate memory and read superblocks from disk */
+int get_nilfs_superblocks(void);
+
+/* Free memory allocated for superblocks */
+int free_nilfs_superblocks(void);
+
+/* Check that superblock contains valid NILFS signature */
+int is_nilfs_signature_ok(const struct nilfs_super_block *sb_ptr);
+
+/* Check primary and secondary NILFS superblocks */
+int check_nilfs_superblocks(void);
+
+/* Get valid or less corrupted superblock */
+struct nilfs_super_block *get_reliable_sb(__u64 flags);
+
+#endif /* NILFS_SUPERBLOCK_H */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
