From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 11/11] nilfs-utils: fsck: add functionality of superblock checking
Date: Wed, 5 Sep 2012 23:15:46 +0400
Message-ID: <5228146F-029A-4E23-AA1A-A84FCD92E105@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=rY3iuCTfTH6qidTD9dPMTXE1XuXIgDuKdjr39UDR1Po=;
	b=JTwsX84BHtt77cI7Z/aggbImUGMj23qe7osgfPB3i0eg8jfKZJMSRqYOEPQ5dILdVSYzDpQsoVj3PNtGH5JlviBeY2gWJ3llH+F9EGGV19cOhDIPrGqIlo0Up2pGnSnl;
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
Subject: [PATCH v3 11/11] nilfs-utils: fsck: add functionality of superblock checking

This patch adds functionality of superblock checking.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 sbin/fsck/nilfs_superblock.c |  546 ++++++++++++++++++++++++++++++++++++++++++
 sbin/fsck/nilfs_superblock.h |   41 ++++
 2 files changed, 587 insertions(+), 0 deletions(-)
 create mode 100644 sbin/fsck/nilfs_superblock.c
 create mode 100644 sbin/fsck/nilfs_superblock.h

diff --git a/sbin/fsck/nilfs_superblock.c b/sbin/fsck/nilfs_superblock.c
new file mode 100644
index 0000000..a918c33
--- /dev/null
+++ b/sbin/fsck/nilfs_superblock.c
@@ -0,0 +1,546 @@
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
+#include "fsck_common.h"
+#include "fsck_raw_ops.h"
+
+#include "nilfs_superblock.h"
+
+/*****************************************************************************
+ * GLOBAL VARIABLES
+ *****************************************************************************/
+
+/* Array of pointers on NILFS volume's superblocks */
+struct nilfs_super_block *superblocks[SUPERBLOCK_TYPES_NUMBER] = {0};
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
+static int is_nilfs_superblock_valid(struct nilfs_super_block *sb_ptr,
+					__u64 *check_mask);
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
+	internal_debug("<%s>: try to read superblocks from disk.", __func__);
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
+	internal_debug("<%s>: nilfs superblocks are read successfully.",
+			__func__);
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
+	int return_states[ALL_POSSIBLE_SB_STATES] = { -1 };
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
+	internal_debug("<%s>: try to check NILFS superblocks.", __func__);
+
+	err = is_nilfs_signature_ok(superblocks[PRIMARY_SUPERBLOCK]);
+	if (NILFS_OK == err) {
+		internal_debug("<%s>: primary superblock has valid signature.",
+				__func__);
+
+		*sb1_check_mask = SB_FULL_CHECK;
+		err = is_nilfs_superblock_valid(
+					superblocks[PRIMARY_SUPERBLOCK],
+					sb1_check_mask);
+		if (-UNSUPPORTED_SB_REV == err) {
+			internal_debug("<%s>: primary superblock unsupported.",
+					__func__);
+			sb_states |= SB1_NOT_FOUND;
+		} else if (NILFS_OK != err) {
+			internal_debug("<%s>: primary superblock is corrupted.",
+					__func__);
+			sb_states |= SB1_CORRUPTED;
+		} else {
+			internal_debug("<%s>: primary superblock is valid.",
+					__func__);
+			sb_states |= SB1_VALID;
+		}
+
+		internal_debug("<%s>: sb_states has %d value.",
+				__func__, sb_states);
+	} else if (-INVALID_NILFS_SIGNATURE == err) {
+		sb_states |= SB1_NOT_FOUND;
+		internal_debug("<%s>: primary superblock is not found.",
+				__func__);
+		internal_debug("<%s>: sb_states has %d value.",
+				__func__, sb_states);
+	} else
+		goto check_sb_internal_error;
+
+	err = is_nilfs_signature_ok(superblocks[SECONDARY_SUPERBLOCK]);
+	if (NILFS_OK == err) {
+		internal_debug("<%s>: secondary superblock has valid signature.",
+				__func__);
+
+		*sb2_check_mask = SB_FULL_CHECK;
+		err = is_nilfs_superblock_valid(
+					superblocks[SECONDARY_SUPERBLOCK],
+					sb2_check_mask);
+		if (-UNSUPPORTED_SB_REV == err) {
+			internal_debug("<%s>: secondary sb unsupported.",
+					__func__);
+			sb_states |= SB2_NOT_FOUND;
+		} else if (NILFS_OK != err) {
+			internal_debug("<%s>: secondary superblock is corrupted.",
+					__func__);
+			sb_states |= SB2_CORRUPTED;
+		} else {
+			internal_debug("<%s>: secondary superblock is valid.",
+					__func__);
+			sb_states |= SB2_VALID;
+		}
+
+		internal_debug("<%s>: sb_states has %d value.",
+				__func__, sb_states);
+	} else if (-INVALID_NILFS_SIGNATURE == err) {
+		sb_states |= SB2_NOT_FOUND;
+		internal_debug("<%s>: secondary superblock is not found.",
+				__func__);
+		internal_debug("<%s>: sb_states has %d value.",
+				__func__, sb_states);
+	} else
+		goto check_sb_internal_error;
+
+	internal_debug("<%s>: return_states has %d value.",
+			__func__, return_states[sb_states]);
+
+	if (-1 == return_states[sb_states])
+		goto check_sb_internal_error;
+	else if (NILFS_NOT_FOUND == return_states[sb_states])
+		goto check_sb_fs_info;
+	else if ((sb_states & SB1_NOT_FOUND) ||
+				(sb_states & SB2_NOT_FOUND))
+		goto check_sb_fs_fatal_error;
+	else if (SB1_OK_SB2_OK != return_states[sb_states])
+		goto check_sb_fs_critical_error;
+
+check_sb_fs_info:
+	fs_info("%s", nilfs_message[return_states[sb_states]]);
+	return -return_states[sb_states];
+
+check_sb_fs_fatal_error:
+	fs_fatal_error("%s", nilfs_message[return_states[sb_states]]);
+	return -return_states[sb_states];
+
+check_sb_fs_critical_error:
+	fs_critical_error("%s", nilfs_message[return_states[sb_states]]);
+	return -return_states[sb_states];
+
+check_sb_internal_error:
+	internal_error("%s", nilfs_message[CANNOT_DETECT_SB_STATE]);
+	return -CANNOT_DETECT_SB_STATE;
+} /* check_nilfs_superblocks() */
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
+	internal_debug("<%s>: try to free memory of superblocks.", __func__);
+
+	err_sb1 = free_superblock(PRIMARY_SUPERBLOCK);
+	err_sb2 = free_superblock(SECONDARY_SUPERBLOCK);
+
+	if (NILFS_OK != err_sb1 || NILFS_OK != err_sb2) {
+		internal_debug("<%s>: some error occurs during memory freeing.",
+				__func__);
+		return -CANNOT_FREE;
+	}
+
+	internal_debug("<%s>: superblocks memory has freed successfully.",
+			__func__);
+	return NILFS_OK;
+
+} /* free_nilfs_superblocks() */
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
+	internal_debug("<%s>: try to allocate memory for %d superblock type.",
+			__func__, sb_type);
+
+	if (sb_type >= SUPERBLOCK_TYPES_NUMBER) {
+		internal_error("%s", nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	if (superblocks[sb_type]) {
+		internal_error("%s", nilfs_message[CANNOT_ALLOCATE]);
+		internal_debug("<%s>: superblock of %d type has allocated yet",
+				__func__, sb_type);
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
+	internal_debug("<%s>: memory for %d superblock type has allocated.",
+			__func__, sb_type);
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
+	internal_debug("<%s>: try to free memory for %d superblock type.",
+			__func__, sb_type);
+
+	if (sb_type >= SUPERBLOCK_TYPES_NUMBER) {
+		internal_error("%s", nilfs_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	if (NULL == superblocks[sb_type]) {
+		internal_warning("%s", nilfs_message[CANNOT_FREE]);
+		internal_debug("<%s>: superblock of %d type *not* allocated yet",
+				__func__, sb_type);
+		return -CANNOT_FREE;
+	}
+
+	free(superblocks[sb_type]);
+	superblocks[sb_type] = NULL;
+
+	internal_debug("<%s>: superblock of %d type has freed",
+			__func__, sb_type);
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
+	internal_debug("<%s>: try to read superblocks.", __func__);
+
+	if (NULL == superblocks[PRIMARY_SUPERBLOCK] ||
+		NULL == superblocks[SECONDARY_SUPERBLOCK]) {
+		internal_debug("<%s>: superblocks are *not* allocated yet",
+				__func__);
+		goto cannot_read_superblock;
+	}
+
+	devfd = device_file_descriptor();
+	if (-1 == devfd) {
+		internal_debug("<%s>: Device file descriptor: %d.",
+				__func__, devfd);
+		goto cannot_read_superblock;
+	}
+
+	err = nilfs_sb_read_unchecked(devfd, superblocks);
+	if (err)
+		goto cannot_read_superblock;
+
+	internal_debug("<%s>: superblock is read successfully", __func__);
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
+	internal_debug("<%s>: check signature of superblock.", __func__);
+
+	if (NULL == sb_ptr) {
+		internal_error("%s", nilfs_message[INVALID_PARAMETER]);
+		internal_debug("<%s>: pointer on superblock is NULL.",
+				__func__);
+		return -INVALID_PARAMETER;
+	}
+
+	if (le16_to_cpu(sb_ptr->s_magic) != NILFS_SUPER_MAGIC) {
+		fs_warning("%s", nilfs_message[INVALID_NILFS_SIGNATURE]);
+		return -INVALID_NILFS_SIGNATURE;
+	}
+
+	internal_debug("<%s>: NILFS signature is ok.", __func__);
+	return NILFS_OK;
+} /* is_nilfs_signature_ok() */
+
+/*****************************************************************************
+ * NAME:  is_nilfs_superblock_valid (fsck.nilfs2)
+ *
+ * FUNCTION:  Check that superblock is valid.
+ *
+ * PARAMETERS:
+ * @sb_ptr: Pointer on superblock.
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
+static int is_nilfs_superblock_valid(struct nilfs_super_block *sb_ptr,
+					__u64 *check_mask)
+{
+	int err = NILFS_OK;
+	int devfd = -1;
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
+		NOT_CLEAN_UMOUNT_DETECTED,	/*CHECK_SB_CLEAN_UMOUNT_FLAG*/
+		FS_ERRORS_DETECTED_BY_DRIVER,	/*CHECK_SB_ERRS_DETECTED_FLAG*/
+	};
+
+	internal_debug("<%s>: check superblock validity.", __func__);
+	internal_debug("<%s>: sbp %#x, check_mask %#x.",
+				__func__, sb_ptr, check_mask);
+
+	if (NULL == sb_ptr || NULL == check_mask) {
+		err = CANNOT_CHECK_SB;
+		goto failed_check_sb;
+	}
+
+	devfd = device_file_descriptor();
+	if (-1 == devfd) {
+		internal_debug("<%s>: Device file descriptor: %d.",
+				__func__, devfd);
+		err = CANNOT_CHECK_SB;
+		goto failed_check_sb;
+	}
+
+	if (!nilfs_sb_is_valid(devfd, sb_ptr, check_mask)) {
+		print_fs_detected_errors(check_mask,
+					sb_err_id, SB_CHECK_FLAGS_MAX_NUM);
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
+	internal_debug("<%s>: superblock is valid.", __func__);
+
+	return NILFS_OK;
+
+failed_check_sb:
+	internal_error("%s", nilfs_message[err]);
+	return -err;
+} /* is_nilfs_superblock_valid() */
diff --git a/sbin/fsck/nilfs_superblock.h b/sbin/fsck/nilfs_superblock.h
new file mode 100644
index 0000000..0b670a7
--- /dev/null
+++ b/sbin/fsck/nilfs_superblock.h
@@ -0,0 +1,41 @@
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
+/* Check that superblock contains valid NILFS signature */
+int is_nilfs_signature_ok(const struct nilfs_super_block *sb_ptr);
+
+/* Check primary and secondary NILFS superblocks */
+int check_nilfs_superblocks(void);
+
+/* Free memory allocated for superblocks */
+int free_nilfs_superblocks(void);
+
+#endif /* NILFS_SUPERBLOCK_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
