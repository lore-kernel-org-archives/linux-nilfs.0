From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 02/15] nilfs-utils: fsck: add libnilfsmessages.la library
 into nilfs-utils package
Date: Mon, 12 Nov 2012 13:34:55 +0400
Message-ID: <1352712895.2555.37.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=UBN5ZcjXert41kMq/+T+wBdf68jv3o+uiFfbTPcVynI=;
	b=QKNE86LNKZn6c/zCd0vz1fHN56PSaM8zi90pL/Zunv/DfKOxamJSFjBsrnZTPn4MlRgY/GH9fG9R2yVxvZ75Uz5mftsoQGD3GtrW/v0B3W1SUfVM3cVtNS6jwHE5LE/P;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds libnilfsmessages.la library into nilfs-utils package. The library generalizes messages output.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 02/15] nilfs-utils: fsck: add libnilfsmessages.la library into nilfs-utils package

This patch adds libnilfsmessages.la library into nilfs-utils package. The library generalizes messages output.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 include/nilfs_messages.def |  180 +++++++++++++++++
 include/nilfs_messages.h   |  248 +++++++++++++++++++++++
 lib/nilfs_messages.c       |  474 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 902 insertions(+)
 create mode 100644 include/nilfs_messages.def
 create mode 100644 include/nilfs_messages.h
 create mode 100644 lib/nilfs_messages.c

diff --git a/include/nilfs_messages.def b/include/nilfs_messages.def
new file mode 100644
index 0000000..e3a9db0
--- /dev/null
+++ b/include/nilfs_messages.def
@@ -0,0 +1,180 @@
+/*
+ * nilfs_messages.def - List of codes and associated messages
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
+#ifndef NILFS_SUBSYSTEM
+#define NILFS_SUBSYSTEM(ID, SUBSYS_STRING)
+#endif
+
+NILFS_SUBSYSTEM(APP_INTERNAL, "[COMMON]")
+NILFS_SUBSYSTEM(FSCK_INTERNAL, "[FSCK]")
+NILFS_SUBSYSTEM(NILFS_SUPERBLOCK, "[SB]")
+NILFS_SUBSYSTEM(NILFS_SEGMENT, "[SEGMENT]")
+
+#undef NILFS_SUBSYSTEM
+
+#ifndef NILFS_MESSAGE
+#define NILFS_MESSAGE(SUBSYSTEM, ID, SEVERITY, MESSAGE)
+#endif
+
+NILFS_MESSAGE(APP_INTERNAL, NILFS_OK, NILFS_UNKNOWN, "NILFS_OK")
+NILFS_MESSAGE(APP_INTERNAL, UNKNOWN_ERROR, NILFS_FATAL_ERROR, "Unknown error has occured.")
+NILFS_MESSAGE(APP_INTERNAL, NOT_IMPLEMENTED, NILFS_WARNING, "Sorry. Functionality is not implemented yet.")
+NILFS_MESSAGE(APP_INTERNAL, SUCCESS_FAREWELL, NILFS_INFO, "All is OK. Have a nice day.")
+NILFS_MESSAGE(APP_INTERNAL, REQUESTED_DEV, NILFS_UNKNOWN, "Requested device:")
+NILFS_MESSAGE(APP_INTERNAL, NO_DEVICE, NILFS_FATAL_ERROR, "Device not specified.")
+NILFS_MESSAGE(APP_INTERNAL, BAD_DEVICE, NILFS_FATAL_ERROR, "Cannot open device.")
+NILFS_MESSAGE(APP_INTERNAL, NOT_MOUNTED, NILFS_INFO, "Device is not mounted.")
+NILFS_MESSAGE(APP_INTERNAL, RO_MOUNT, NILFS_WARNING, "Device is mounted in RO mode.")
+NILFS_MESSAGE(APP_INTERNAL, RW_MOUNT, NILFS_WARNING, "Device is mounted in RW mode.")
+NILFS_MESSAGE(APP_INTERNAL, DEVICE_NOT_OPENED, NILFS_LOOKS_LIKE_ERROR, "Device is not opened.")
+NILFS_MESSAGE(APP_INTERNAL, DEVICE_OPENED_YET, NILFS_LOOKS_LIKE_ERROR, "Device is opened yet.")
+NILFS_MESSAGE(APP_INTERNAL, INVALID_MODE, NILFS_MINOR_ERROR, "Requested mode is unavailable.")
+NILFS_MESSAGE(APP_INTERNAL, FLUSH_FAILED, NILFS_CRITICAL_ERROR, "Flush is failed.")
+NILFS_MESSAGE(APP_INTERNAL, CANNOT_CLOSE_DEVICE, NILFS_LOOKS_LIKE_ERROR, "Cannot close device.")
+NILFS_MESSAGE(APP_INTERNAL, INVALID_BLOCK_SIZE, NILFS_CRITICAL_ERROR, "Invalid block size.")
+NILFS_MESSAGE(APP_INTERNAL, DATA_PROCCESSED_PARTIALLY, NILFS_LOOKS_LIKE_ERROR, "The requested data are proccessed partially.")
+NILFS_MESSAGE(APP_INTERNAL, OP_FAILED, NILFS_FATAL_ERROR, "Requested operation has failed.")
+NILFS_MESSAGE(APP_INTERNAL, INVALID_PARAMETER, NILFS_MINOR_ERROR, "Input parameters are invalid.")
+NILFS_MESSAGE(APP_INTERNAL, OUT_OF_VOLUME, NILFS_CRITICAL_ERROR, "Trying to operate out of volume.")
+NILFS_MESSAGE(APP_INTERNAL, CANNOT_SET_DEV_POS, NILFS_CRITICAL_ERROR, "Cannot set current position on device.")
+NILFS_MESSAGE(APP_INTERNAL, CANNOT_ALLOCATE, NILFS_FATAL_ERROR, "Cannot allocate memory.")
+NILFS_MESSAGE(APP_INTERNAL, MEMORY_ALLOCATED_YET, NILFS_WARNING, "Memory is allocated yet.")
+NILFS_MESSAGE(APP_INTERNAL, CANNOT_FREE, NILFS_LOOKS_LIKE_ERROR, "Cannot free memory.")
+NILFS_MESSAGE(APP_INTERNAL, INVALID_CRC, NILFS_CRITICAL_ERROR, "Invalid checksum was detected.")
+NILFS_MESSAGE(APP_INTERNAL, MEMORY_NOT_ALLOCATED, NILFS_MINOR_ERROR, "Memory for object is *not* allocated yet.")
+
+NILFS_MESSAGE(FSCK_INTERNAL, DONT_WORK_RO_MOUNT, NILFS_INFO, "FSCK *doesn't* work with RO mounted partition currently.")
+NILFS_MESSAGE(FSCK_INTERNAL, DONT_WORK_RW_MOUNT, NILFS_INFO, "FSCK *doesn't* work with RW mounted partition.")
+NILFS_MESSAGE(FSCK_INTERNAL, FSCK_DOES_NOTHING, NILFS_INFO, "FSCK currently has partial and experimental checking functionality.")
+NILFS_MESSAGE(FSCK_INTERNAL, RO_CHECK_DOES_NOT_WORK, NILFS_WARNING, "Read-only check doesn't supported yet.")
+NILFS_MESSAGE(FSCK_INTERNAL, SB_CHECKING_BEGIN, NILFS_INFO, "The NILFS superblocks checking begins.")
+NILFS_MESSAGE(FSCK_INTERNAL, NOT_NILFS_VOLUME, NILFS_WARNING, "!!!This is not NILFS volume or NILFS volume completely *UNRECOVERABLE*!!!")
+NILFS_MESSAGE(FSCK_INTERNAL, SEGMENTS_CHECKING_BEGIN, NILFS_INFO, "NILFS volume's segments checking begins.")
+NILFS_MESSAGE(FSCK_INTERNAL, CANNOT_CHECK_SEGMENTS, NILFS_FATAL_ERROR, "Segments checking fails because of internal error.")
+NILFS_MESSAGE(FSCK_INTERNAL, SNAPSHOTS_CHECKING_BEGIN, NILFS_INFO, "NILFS volume's snapshots checking begins.")
+NILFS_MESSAGE(FSCK_INTERNAL, INVALID_SNAPSHOT_NUMBER, NILFS_CRITICAL_ERROR, "Invalid snapshot number.")
+NILFS_MESSAGE(FSCK_INTERNAL, CANNOT_CHECK_FS_HIERARCHY, NILFS_FATAL_ERROR, "FS hierarchy checking fails because of internal error.")
+NILFS_MESSAGE(FSCK_INTERNAL, CANNOT_CHECK_BY_COMPARE, NILFS_FATAL_ERROR, "Checking by different bitmaps comparison fails because of internal error.")
+NILFS_MESSAGE(FSCK_INTERNAL, USE_CORRUPTED_SB, NILFS_WARNING, "Corrupted superblock is using for checking operation.")
+NILFS_MESSAGE(FSCK_INTERNAL, CANNOT_PREPARE_SEGS_CHECK_ENV, NILFS_FATAL_ERROR, "Cannot prepare segments sequence checking environment.")
+NILFS_MESSAGE(FSCK_INTERNAL, SEGS_CHECK_ENV_NOT_READY, NILFS_CRITICAL_ERROR, "Segments checking environment is *not* ready.")
+NILFS_MESSAGE(FSCK_INTERNAL, CANNOT_READ_SEG_SUM_HEADER, NILFS_CRITICAL_ERROR, "Cannot read segment summary header because of internal error.")
+NILFS_MESSAGE(FSCK_INTERNAL, CANNOT_READ_SEG_SUMMARY, NILFS_CRITICAL_ERROR, "Cannot read segment summary because of internal error.")
+NILFS_MESSAGE(FSCK_INTERNAL, CANNOT_BUILD_SEGS_REF_ARRAY, NILFS_CRITICAL_ERROR, "Cannot build array of segments' references because of internal error.")
+NILFS_MESSAGE(FSCK_INTERNAL, CANNOT_BUILD_SEGS_BMP, NILFS_CRITICAL_ERROR, "Cannot build segments bitmap because of internal error.")
+NILFS_MESSAGE(FSCK_INTERNAL, CANNOT_PREPARE_NILFS_OBJ, NILFS_FATAL_ERROR, "Cannot prepare nilfs object because of internal error.")
+NILFS_MESSAGE(FSCK_INTERNAL, CANNOT_CHECK_LOG, NILFS_CRITICAL_ERROR, "Cannot check log because of internal error.")
+NILFS_MESSAGE(FSCK_INTERNAL, DETECTED_CORRUPTION_FAREWELL, NILFS_WARNING, "NILFS volume is detected as corrupted. Be carefull. It is a bad news. Sorry.")
+
+NILFS_MESSAGE(NILFS_SUPERBLOCK, CANNOT_READ_SUPERBLOCK, NILFS_FATAL_ERROR, "Cannot read superblock from disk.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_OFFSET, NILFS_CRITICAL_ERROR, "Invalid value of superblock offset.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, CANNOT_GET_SUPERBLOCKS, NILFS_FATAL_ERROR, "Cannot get superblocks from requested device.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_NILFS_SIGNATURE, NILFS_WARNING, "Superblock signature is invalid. This is *not* NILFS superblock.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, NILFS_NOT_FOUND, NILFS_WARNING, "NILFS superblocks are not detected.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, ONLY_SB1_OK_FOUND, NILFS_CRITICAL_ERROR, "Primary valid superblock was found but secondary *not*.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, ONLY_SB1_CORRUPTED_FOUND, NILFS_CRITICAL_ERROR, "Corrupted primary superblock was found but secondary *not*.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, ONLY_SB2_OK_FOUND, NILFS_CRITICAL_ERROR, "Secondary valid superblock was found but primary *not*.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, ONLY_SB2_CORRUPTED_FOUND, NILFS_CRITICAL_ERROR, "Corrupted secondary superblock was found but primary *not*.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB1_SB2_CORRUPTED, NILFS_CRITICAL_ERROR, "Primary and secondary superblocks were found but in corrupted state.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB1_OK_SB2_CORRUPTED, NILFS_CRITICAL_ERROR, "Primary superblock is valid but secondary is in corrupted state.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB1_CORRUPTED_SB2_OK, NILFS_CRITICAL_ERROR, "Secondary superblock is valid but primary is in corrupted state.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, CANNOT_DETECT_SB_STATE, NILFS_FATAL_ERROR, "Cannot detect state of a superblock because of internal error.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB1_OK_SB2_OK, NILFS_INFO, "NILFS has valid primary and secondary superblocks.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, CANNOT_CHECK_SB, NILFS_FATAL_ERROR, "Cannot check superblock validity because of internal error.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB, NILFS_CRITICAL_ERROR, "Superblock is in corrupted state.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_SIZE, NILFS_CRITICAL_ERROR, "Superblock contains incorrect size in bytes.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, UNSUPPORTED_SB_REV, NILFS_WARNING, "It is detected an unsupported revision of NILFS superblock.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, OUTSIZED_DEV_SIZE, NILFS_CRITICAL_ERROR, "Superblock keeps value that greater of partition size.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, UNDERSIZED_DEV_SIZE, NILFS_LOOKS_LIKE_ERROR, "Superblock keeps value that lesser of partition size.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_DEV_SIZE, NILFS_CRITICAL_ERROR, "Superblock keeps invalid value of partition size.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_FEATURE, NILFS_MINOR_ERROR, "Superblock keeps invalid set of feature flags.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, UNSUPPORTED_SB_RO_FEATURE, NILFS_MINOR_ERROR, "Superblock keeps unsupported RO feature flags. It should work in RO mode.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_FLAGS, NILFS_MINOR_ERROR, "Superblock keeps invalid set of fs independent flags.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_BLOCKS_PER_SEG, NILFS_CRITICAL_ERROR, "Superblock keeps invalid value of blocks per full segment.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_NSEGMENTS, NILFS_CRITICAL_ERROR, "Superblock keeps invalid number of segments in filesystem.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_FIRST_DATA_BLOCK, NILFS_CRITICAL_ERROR, "Superblock keeps invalid value of first data block.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_R_SEGS_PERCENTAGE, NILFS_CRITICAL_ERROR, "Superblock keeps invalid number of reserved segments percentage.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_LAST_CNO, NILFS_CRITICAL_ERROR, "Superblock keeps invalid last checkpoint number.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_LAST_PSEG, NILFS_CRITICAL_ERROR, "Superblock keeps invalid disk block address of partial segment.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_LAST_SEQ, NILFS_CRITICAL_ERROR, "Superblock keeps invalid sequential number of partial segment.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_FREE_BLKS, NILFS_CRITICAL_ERROR, "Superblock keeps invalid free blocks count.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_TIMES, NILFS_LOOKS_LIKE_ERROR, "Superblock keeps invalid timestamps.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, MAX_POSSIBLE_MNT_COUNT, NILFS_WARNING, "Maximum possible mount count has been reached.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_FS_STATE, NILFS_CRITICAL_ERROR, "Superblock keeps invalid file system state flags.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_FS_ERRORS, NILFS_LOOKS_LIKE_ERROR, "Superblock keeps strange definition of behavior in the case of error detection.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_LAST_CHECK, NILFS_LOOKS_LIKE_ERROR, "Superblock keeps invalid timestamp of last check.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_OS, NILFS_MINOR_ERROR, "Superblock keeps invalid code of creator OS.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_DEF_ID, NILFS_MINOR_ERROR, "Superblock keeps invalid default ID for user and group.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_FIRST_INO, NILFS_CRITICAL_ERROR, "Superblock keeps invalid first user's file inode number.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_INO_SZ, NILFS_CRITICAL_ERROR, "Superblock keeps invalid size of on-disk inode.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_DAT_ENTRY_SZ, NILFS_CRITICAL_ERROR, "Superblock keeps invalid DAT entry size.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_CHECKPOINT_SZ, NILFS_CRITICAL_ERROR, "Superblock keeps invalid size of a checkpoint.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_SEG_USAGE_SZ, NILFS_CRITICAL_ERROR, "Superblock keeps invalid size of a segment usage.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_C_INTERVAL, NILFS_MINOR_ERROR, "Superblock keeps invalid value of commit interval of segment.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, INVALID_SB_C_BLK_MAX, NILFS_MINOR_ERROR, "Superblock keeps invalid value of threshold of data amount for the segment construction.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, NOT_CLEAN_UMOUNT_DETECTED, NILFS_WARNING, "NILFS had been unmounted not cleanly.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, NOT_VALID_FS_STATE_FLAG, NILFS_INFO, "Superblock state flag *tells* that filesystem stays in mounted state.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, FS_ERRORS_DETECTED_BY_DRIVER, NILFS_WARNING, "NILFS volumes has errors detected by drivers. It should be recovered.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, NILFS_HAS_CORRUPTED_SB, NILFS_CRITICAL_ERROR, "Device contains NILFS volume with *CORRUPTED* superblock.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, NILFS_HAS_INCONSISTENT_SB, NILFS_WARNING, "Device contains NILFS volume with *INCONSISTENT* superblock.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, UNRELIABLE_SB, NILFS_CRITICAL_ERROR, "Superblock doesn't contain reliable info.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, FATAL_SB_DIFF, NILFS_FATAL_ERROR, "Primary and secondary superblocks have fatal difference.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_BLK_SIZE_DIFF, NILFS_FATAL_ERROR, "Primary and secondary superblocks have different info about block size.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_NSEGS_DIFF, NILFS_FATAL_ERROR, "Primary and secondary superblocks have different info about number of segments in file system.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_DEV_SIZE_DIFF, NILFS_FATAL_ERROR, "Primary and secondary superblocks have different info about device size.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_BLKS_PER_SEG_DIFF, NILFS_FATAL_ERROR, "Primary and secondary superblocks have different info about number of blocks on segment.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_R_SEGS_PERCENTAGE_DIFF, NILFS_LOOKS_LIKE_ERROR, "Primary and secondary superblocks have different info about reserved segments percentage.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_LAST_CNO_DIFF, NILFS_INFO, "Primary and secondary superblocks have different info about last checkpoint.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_LAST_PSEG_DIFF, NILFS_INFO, "Primary and secondary superblocks have different info about disk block address of partial segment.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_LAST_SEQ_DIFF, NILFS_INFO, "Primary and secondary superblocks have different info about sequential number of partial segment.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_FREE_BLKS_DIFF, NILFS_INFO, "Primary and secondary superblocks have different info about free blocks count.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_CTIME_DIFF, NILFS_FATAL_ERROR, "Primary and secondary superblocks have different creation time.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_MTIME_DIFF, NILFS_WARNING, "Primary and secondary superblocks have different mount time.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_WTIME_DIFF, NILFS_INFO, "Primary and secondary superblocks have different last write time.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_MNT_COUNT_DIFF, NILFS_WARNING, "Primary and secondary superblocks have different mount count.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_MAX_MNT_COUNT_DIFF, NILFS_WARNING, "Primary and secondary superblocks have different maximum mount count.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_FS_STATE_DIFF, NILFS_INFO, "Primary and secondary superblocks have different file system state flags.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_LASTCHECK_DIFF, NILFS_WARNING, "Primary and secondary superblocks have different last check time.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_UUID_DIFF, NILFS_LOOKS_LIKE_ERROR, "Primary and secondary superblocks have different UUIDs.")
+NILFS_MESSAGE(NILFS_SUPERBLOCK, SB_VOL_NAMES_DIFF, NILFS_LOOKS_LIKE_ERROR, "Primary and secondary superblocks have different volume names.")
+
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_SS_SIGNATURE, NILFS_WARNING, "Segment summary signature is invalid.")
+NILFS_MESSAGE(NILFS_SEGMENT, UNSUPPORTED_SS_REV, NILFS_WARNING, "Unsupported revision of segment summary.")
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_SS_HEADER_SZ, NILFS_CRITICAL_ERROR, "Size of segment summary header is invalid.")
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_SS_SEQ, NILFS_MINOR_ERROR, "Segment summary header keeps invalid sequential number.")
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_SS_FLAGS, NILFS_MINOR_ERROR, "Segment summary header contains unknow flags.")
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_SS_CREATE_TIME, NILFS_LOOKS_LIKE_ERROR, "Segment summary header contains strange value of creation timestamp.")
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_SS_NEXT_SEG_BLK, NILFS_CRITICAL_ERROR, "Segment summary header contains invalid next segment start block.")
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_SS_NBLOCKS, NILFS_CRITICAL_ERROR, "Segment summary header contains invalid number of really used blocks in segment.")
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_SS_NFINFO, NILFS_CRITICAL_ERROR, "Segment summary header contains invalid number of finfo structures.")
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_SS_CNO, NILFS_LOOKS_LIKE_ERROR, "Segment summary header contains invalid checkpoint number.")
+NILFS_MESSAGE(NILFS_SEGMENT, BROKEN_SEGS_CHAIN, NILFS_CRITICAL_ERROR, "NILFS2 volume has inconsistent segments' chain sequence.")
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_NILFS_LOG, NILFS_CRITICAL_ERROR, "NILFS2 log is in corrupted state.")
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_SS_SUMSUM, NILFS_CRITICAL_ERROR, "Segment summary checksum is invalid.")
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_SS_DATASUM, NILFS_CRITICAL_ERROR, "Log's data checksum is invalid.")
+NILFS_MESSAGE(NILFS_SEGMENT, INVALID_SS_SUMBYTES, NILFS_CRITICAL_ERROR, "Segment summary size is invalid.")
+NILFS_MESSAGE(NILFS_SEGMENT, SS_FINFO_SECTION_EMPTY, NILFS_INFO, "Segment summary's finfo section is empty.")
+NILFS_MESSAGE(NILFS_SEGMENT, EMPTY_LOG_DETECTED, NILFS_INFO, "It was detected empty log in the segment.")
+
+#undef NILFS_MESSAGE
diff --git a/include/nilfs_messages.h b/include/nilfs_messages.h
new file mode 100644
index 0000000..d0d3716
--- /dev/null
+++ b/include/nilfs_messages.h
@@ -0,0 +1,248 @@
+/*
+ * nilfs_messages.h - Declaration of error, warning, info codes,
+ *                    associated messages and routines
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
+#ifndef NILFS_MESSAGES_H
+#define NILFS_MESSAGES_H
+
+/*
+ * Error code structure:
+ * +-----------+-----------+-----------+------------+
+ * | error     |  error    | subsystem |   message  |
+ * | severity  |  type     |   code    |    code    |
+ * +-----------+-----------+-----------+------------+
+ *    1 byte      1 byte      2 byte      4 bytes
+ */
+
+#define MSG_CODE_MASK		0x00000000FFFFFFFF
+#define SUBSYS_CODE_MASK	0x0000FFFF00000000
+#define ERR_TYPE_MASK		0x00FF000000000000
+#define ERR_SEVERITY_MASK	0xFF00000000000000
+
+#define MSG_CODE_SHIFT		0
+#define SUBSYS_CODE_SHIFT	(4*8)
+#define ERR_TYPE_SHIFT		((4+2)*8)
+#define ERR_SEVERITY_SHIFT	((4+2+1)*8)
+
+#define MSG_CODE_MAX		0xFFFFFFFF
+#define SUBSYS_CODE_MAX		0xFFFF
+#define ERR_TYPE_MAX		0xFF
+#define ERR_SEVERITY_MAX	0xFF
+
+#define NILFS_INVALID_ERR_CODE -1
+#define UNKNOWN_SEGMENT -1
+#define UNKNOWN_LOG -1
+
+#define ENCODE_ERR(complex_err, code, shift) \
+	(complex_err |= (code << shift))
+
+#define DECODE_ERR(complex_err, mask, shift) \
+	((complex_err & mask) >> shift)
+
+/* Available verbosity levels. */
+enum nilfs_verbosity_level {
+	KEEP_SILENCE,
+	BE_VERBOSE,
+	DEBUG_SPAM
+}; /* enum nilfs_verbosity_level */
+
+/* NILFS error, warning, info codes and associated messages. */
+enum nilfs_message_codes {
+
+#define NILFS_MESSAGE(SUBSYSTEM, ID, SEVERITY, MESSAGE) ID,
+#include "nilfs_messages.def"
+
+	MAX_MESSAGE_CODE
+}; /* enum nilfs_message_codes */
+
+/* Possible severity of errors */
+enum nilfs_error_severity {
+	NILFS_UNKNOWN		= 0x0,
+	NILFS_INFO		= 0x1,
+	NILFS_WARNING		= 0x2,
+	NILFS_LOOKS_LIKE_ERROR	= 0x4,
+	NILFS_MINOR_ERROR	= 0x8,
+	NILFS_CRITICAL_ERROR	= 0x10,
+	NILFS_FATAL_ERROR	= 0x20,
+}; /* enum nilfs_error_severity */
+
+/* Possible error type */
+enum nilfs_error_type {
+	UI_ERROR_TYPE		= 1,
+	FS_ERROR_TYPE		= 2,
+	INTERNAL_ERROR_TYPE	= 3,
+}; /* enum nilfs_error_type */
+
+/* NILFS subsystems identification numbers */
+enum nilfs_subsystem_ids {
+
+#define NILFS_SUBSYSTEM(ID, SUBSYS_STRING) ID,
+#include "nilfs_messages.def"
+
+	MAX_SUBSYSTEM_ID
+}; /* enum nilfs_subsystem_ids */
+
+/* NILFS message array */
+extern const char *nilfs_message[MAX_MESSAGE_CODE];
+
+/* NILFS severity errors table */
+extern const int error_severity[MAX_MESSAGE_CODE];
+
+/* Association between error and subsystem identification id */
+extern const int err2subsys_id[MAX_MESSAGE_CODE];
+
+/* NILFS subsystem strings array */
+extern const char *nilfs_subsys_str[MAX_SUBSYSTEM_ID];
+
+/* Verbosity level of application */
+extern int verbosity_level;
+
+/* Set verbosity level */
+void set_verbosity_level(int requested_level);
+
+/*****************************************************************************
+ * User Interface (UI) messages
+ */
+
+/* Inform user about something */
+void ui_info(const char *fmt, ...);
+
+/* Warn user about some important but not critical situation */
+void ui_warning(const char *fmt, ...);
+
+/* Report error in way of using the utility */
+void ui_error(const char *fmt, ...);
+
+/*****************************************************************************
+ * Messages inform about file system state
+ */
+
+/* Inform user about file system state */
+void fs_info(const char *fmt, ...);
+
+/* Warn user about some important thing in file system state */
+void fs_warning(const char *fmt, ...);
+
+/* Report about detected unrecoverable file system's error */
+void fs_fatal_error(const char *fmt, ...);
+
+/* Report about detected critical file system's error */
+void fs_critical_error(const char *fmt, ...);
+
+/* Report about detected minor file system's error */
+void fs_minor_error(const char *fmt, ...);
+
+/* Report about detected suspicious state looks like error */
+void fs_looks_like_error(const char *fmt, ...);
+
+/*****************************************************************************
+ * Internal messages
+ */
+
+/* Inform user about common internal actions */
+void internal_info(const char *fmt, ...);
+
+/* Warn user about some important situation */
+void internal_warning(const char *fmt, ...);
+
+/*
+ * NAME: internal_error
+ *
+ * MACRO: Report about internal errors
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+#define internal_error(fmt, ...) \
+	do { \
+		if (verbosity_level >= BE_VERBOSE) { \
+			fprintf(stderr, \
+				"[INTERNAL_ERROR]: <%s:%d %s>: ", \
+				__FILE__, __LINE__, __func__); \
+			fprintf(stderr, fmt, __VA_ARGS__); \
+			fprintf(stderr, "\n"); \
+		} \
+	} while (0)
+/* internal_error() */
+
+/*
+ * NAME: internal_perror
+ *
+ * MACRO: Report about internal errors + print system error message
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+#define internal_perror(fmt, ...) \
+	do { \
+		if (verbosity_level >= BE_VERBOSE) { \
+			fprintf(stderr, \
+				"[INTERNAL_ERROR]: <%s:%d %s>: ", \
+				__FILE__, __LINE__, __func__); \
+			fprintf(stderr, fmt, __VA_ARGS__); \
+			fprintf(stderr, "\n"); \
+			perror("[SYSTEM_ERROR]"); \
+		} \
+	} while (0)
+/* internal_perror() */
+
+/*
+ * NAME: internal_debug
+ *
+ * MACRO: Debug messages
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+#define internal_debug(fmt, ...) \
+	do { \
+		if (verbosity_level >= DEBUG_SPAM) { \
+			fprintf(stderr, \
+				"[DBG]: <%s:%d %s>: ", \
+				__FILE__, __LINE__, __func__); \
+			fprintf(stderr, fmt, __VA_ARGS__); \
+			fprintf(stderr, "\n"); \
+		} \
+	} while (0)
+/* internal_debug() */
+
+/*****************************************************************************
+ * Helpers
+ */
+
+/* Encode subsystem code, message code, error type and error severity */
+__u64 encode_error(__u16 subsystem_code, int msg_code,
+					__u8 type, __u8 severity);
+
+/* Prepare formated message about filesystem state for message code */
+int fs_description(int msg_code, __u64 segment, __u32 log);
+
+/* Print all FS detected errors */
+void print_fs_detected_errors(const void *errors_bitmap,
+				const int *err_id,
+				__u16 max_bit_num,
+				__u64 segment,
+				__u32 log);
+
+#endif /* NILFS_MESSAGES_H */
diff --git a/lib/nilfs_messages.c b/lib/nilfs_messages.c
new file mode 100644
index 0000000..6bd9f93
--- /dev/null
+++ b/lib/nilfs_messages.c
@@ -0,0 +1,474 @@
+/*
+ * nilfs_messages.c - Print routines (libnilfsmessages)
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
+#include <stdio.h>
+#include <stdarg.h>
+#include <string.h>
+#include <strings.h>
+
+#include "nilfs.h"
+#include "nilfs_messages.h"
+#include "fsck_nilfs2.h"
+
+/*****************************************************************************
+ * GLOBAL VARIABLES
+ *****************************************************************************/
+
+/* NILFS message array */
+const char *nilfs_message[MAX_MESSAGE_CODE] = {
+
+#define NILFS_MESSAGE(SUBSYSTEM, ID, SEVERITY, MESSAGE) MESSAGE,
+#include "nilfs_messages.def"
+
+}; /* const char *nilfs_message[MAX_MESSAGE_CODE] */
+
+/* NILFS severity errors table */
+const int error_severity[MAX_MESSAGE_CODE] = {
+
+#define NILFS_MESSAGE(SUBSYSTEM, ID, SEVERITY, MESSAGE) SEVERITY,
+#include "nilfs_messages.def"
+
+}; /* const int error_severity[MAX_MESSAGE_CODE] */
+
+/* Association between error and subsystem identification id */
+const int err2subsys_id[MAX_MESSAGE_CODE] = {
+
+#define NILFS_MESSAGE(SUBSYSTEM, ID, SEVERITY, MESSAGE) SUBSYSTEM,
+#include "nilfs_messages.def"
+
+}; /* const int err2subsys_id[MAX_MESSAGE_CODE] */
+
+/* NILFS subsystem strings array */
+const char *nilfs_subsys_str[MAX_SUBSYSTEM_ID] = {
+
+#define NILFS_SUBSYSTEM(ID, SUBSYS_STRING) SUBSYS_STRING,
+#include "nilfs_messages.def"
+
+}; /* const char *nilfs_subsys_str[MAX_SUBSYSTEM_ID] */
+
+/* Verbosity level of application */
+int verbosity_level = BE_VERBOSE;
+
+/*****************************************************************************
+ * IMPLEMENTATION SECTION
+ *****************************************************************************/
+
+/*****************************************************************************
+ * NAME: set_verbosity_level
+ *
+ * FUNCTION: Set verbosity level
+ *
+ * PARAMETERS:
+ * @requested_level: Requested level of verbosity.
+ */
+void set_verbosity_level(int requested_level)
+{
+	if (requested_level < KEEP_SILENCE ||
+			requested_level > DEBUG_SPAM) {
+		fprintf(stderr, "[NILFS_ERROR]: unknow verbosity level.");
+		fprintf(stderr, "Keep the same verbosity level.\n");
+		return;
+	}
+
+	verbosity_level = requested_level;
+} /* set_verbosity_level */
+
+/*****************************************************************************
+ * NAME: NILFS_PRINT_MESSAGE
+ *
+ * MACRO: Print message into stdout/stderr
+ *
+ * PARAMETERS:
+ * @granted_verbosity: Verbosity level gives right to print.
+ * @out_stream: Type of the standard output stream [stdout | stderr].
+ * @prefix: Prefix word begins a message.
+ * @fmt: Format of the message.
+ */
+#define NILFS_PRINT_MESSAGE(granted_verbosity, out_stream, prefix, fmt) \
+	do { \
+		va_list args_list; \
+		if (verbosity_level < granted_verbosity) \
+			return; \
+		va_start(args_list, fmt); \
+		fprintf(out_stream, "%s", prefix); \
+		vfprintf(out_stream, fmt, args_list); \
+		fprintf(out_stream, "\n"); \
+		va_end(args_list); \
+	} while (0)
+/* NILFS_PRINT_MESSAGE */
+
+/*****************************************************************************
+ * NAME: ui_info
+ *
+ * FUNCTION: Inform user about something
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void ui_info(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stdout, "[UI_INFO]: ", fmt);
+} /* ui_info() */
+
+/*****************************************************************************
+ * NAME: ui_warning
+ *
+ * FUNCTION: Warn user about some important but not critical situation
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void ui_warning(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stdout, "[UI_WARNING]: ", fmt);
+} /* ui_warning() */
+
+/*****************************************************************************
+ * NAME: ui_error
+ *
+ * FUNCTION: Report error in way of using the utility
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void ui_error(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stdout, "[UI_ERROR]: ", fmt);
+} /* ui_error() */
+
+/*****************************************************************************
+ * NAME: fs_info
+ *
+ * FUNCTION: Inform user about file system state
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fs_info(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stdout, "[FS_INFO]: ", fmt);
+} /* fs_info() */
+
+/*****************************************************************************
+ * NAME: fs_warning
+ *
+ * FUNCTION: Warn user about some important thing in file system state
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fs_warning(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_WARNING]: ", fmt);
+} /* fs_warning() */
+
+/*****************************************************************************
+ * NAME: fs_fatal_error
+ *
+ * FUNCTION: Report about detected unrecoverable error in file system's metadata
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fs_fatal_error(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_FATAL_ERROR]: ", fmt);
+} /* fs_fatal_error() */
+
+/*****************************************************************************
+ * NAME: fs_critical_error
+ *
+ * FUNCTION: Report about detected critical file system's metadata error
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fs_critical_error(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_CRITICAL_ERROR]: ", fmt);
+} /* fs_critical_error() */
+
+/*****************************************************************************
+ * NAME: fs_minor_error
+ *
+ * FUNCTION: Report about detected minor file system's metadata error
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fs_minor_error(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_MINOR_ERROR]: ", fmt);
+} /* fs_minor_error() */
+
+/*****************************************************************************
+ * NAME: fs_looks_like_error
+ *
+ * FUNCTION: Report about detected suspicious metadata's state looks like error
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fs_looks_like_error(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_LOOKS_LIKE_ERROR]: ", fmt);
+} /* fs_looks_like_error() */
+
+/*****************************************************************************
+ * NAME: internal_info
+ *
+ * FUNCTION: Inform user about common actions
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void internal_info(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stdout, "[INTERNAL_INFO]: ", fmt);
+} /* internal_info() */
+
+/*****************************************************************************
+ * NAME: internal_warning
+ *
+ * FUNCTION: Warn user about some important situation
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void internal_warning(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stderr, "[INTERNAL_WARNING]: ", fmt);
+} /* internal_warning() */
+
+/*****************************************************************************
+ * NAME: fs_description
+ *
+ * FUNCTION: Prepare formated message about filesystem state for message code
+ *
+ * PARAMETERS:
+ * @msg_code: Code of the message.
+ * @segment: Segment number.
+ * @log: Log number.
+ *
+ * RETURNS:
+ * %-Error code.
+ */
+int fs_description(int msg_code, __u64 segment, __u32 log)
+{
+	int subsys_id;
+	__u64 error_code;
+	char wide_format[] = "%s [ID: %#0llx] [SEG: %lld LOG: %d] %s";
+	char brief_format[] = "%s [ID: %#0llx] %s";
+
+	if (msg_code < 0)
+		msg_code = -msg_code;
+
+	if (msg_code >= MAX_MESSAGE_CODE ||
+			NILFS_OK == msg_code) {
+		internal_error("%s", "invalid message code.");
+		internal_debug("message code %d", msg_code);
+		return -INVALID_PARAMETER;
+	}
+
+	subsys_id = err2subsys_id[msg_code];
+	error_code = encode_error(subsys_id, msg_code,
+				FS_ERROR_TYPE, error_severity[msg_code]);
+
+	switch (error_severity[msg_code]) {
+	case NILFS_INFO:
+		if (UNKNOWN_SEGMENT == segment || UNKNOWN_LOG == log) {
+			fs_info(brief_format,
+				nilfs_subsys_str[subsys_id],
+				error_code,
+				nilfs_message[msg_code]);
+		} else {
+			fs_info(wide_format,
+				nilfs_subsys_str[subsys_id],
+				error_code,
+				segment,
+				log,
+				nilfs_message[msg_code]);
+		}
+		break;
+	case NILFS_WARNING:
+		if (UNKNOWN_SEGMENT == segment || UNKNOWN_LOG == log) {
+			fs_warning(brief_format,
+				nilfs_subsys_str[subsys_id],
+				error_code,
+				nilfs_message[msg_code]);
+		} else {
+			fs_warning(wide_format,
+				nilfs_subsys_str[subsys_id],
+				error_code,
+				segment,
+				log,
+				nilfs_message[msg_code]);
+		}
+		break;
+	case NILFS_FATAL_ERROR:
+		if (UNKNOWN_SEGMENT == segment || UNKNOWN_LOG == log) {
+			fs_fatal_error(brief_format,
+				nilfs_subsys_str[subsys_id],
+				error_code,
+				nilfs_message[msg_code]);
+		} else {
+			fs_fatal_error(wide_format,
+				nilfs_subsys_str[subsys_id],
+				error_code,
+				segment,
+				log,
+				nilfs_message[msg_code]);
+		}
+		break;
+	case NILFS_CRITICAL_ERROR:
+		if (UNKNOWN_SEGMENT == segment || UNKNOWN_LOG == log) {
+			fs_critical_error(brief_format,
+				nilfs_subsys_str[subsys_id],
+				error_code,
+				nilfs_message[msg_code]);
+		} else {
+			fs_critical_error(wide_format,
+				nilfs_subsys_str[subsys_id],
+				error_code,
+				segment,
+				log,
+				nilfs_message[msg_code]);
+		}
+		break;
+	case NILFS_MINOR_ERROR:
+		if (UNKNOWN_SEGMENT == segment || UNKNOWN_LOG == log) {
+			fs_minor_error(brief_format,
+				nilfs_subsys_str[subsys_id],
+				error_code,
+				nilfs_message[msg_code]);
+		} else {
+			fs_minor_error(wide_format,
+				nilfs_subsys_str[subsys_id],
+				error_code,
+				segment,
+				log,
+				nilfs_message[msg_code]);
+		}
+		break;
+	case NILFS_LOOKS_LIKE_ERROR:
+		if (UNKNOWN_SEGMENT == segment || UNKNOWN_LOG == log) {
+			fs_looks_like_error(brief_format,
+				nilfs_subsys_str[subsys_id],
+				error_code,
+				nilfs_message[msg_code]);
+		} else {
+			fs_looks_like_error(wide_format,
+				nilfs_subsys_str[subsys_id],
+				error_code,
+				segment,
+				log,
+				nilfs_message[msg_code]);
+		}
+		break;
+	default:
+		/* Keep silence */
+		break;
+	}
+
+	return -msg_code;
+} /* fs_description() */
+
+/*****************************************************************************
+ * NAME:  print_fs_detected_errors
+ *
+ * FUNCTION:  Print all detected FS errors.
+ *
+ * PARAMETERS:
+ * @errors_bitmap: Pointer on bitmap with detected errors' flags.
+ * @err_id: Pointer on array of error codes associated with errors' flags.
+ * @max_bit_num: Maximum count of flags in error bitmap and array of errors.
+ * @segment: Segment number.
+ * @log: Log number.
+ */
+void print_fs_detected_errors(const void *errors_bitmap,
+				const int *err_id,
+				__u16 max_bit_num,
+				__u64 segment,
+				__u32 log)
+{
+	int index;
+	const __u8 *err_bitmap_ptr = (const __u8 *)errors_bitmap;
+
+	if (!errors_bitmap || !err_id) {
+		internal_debug("%s",
+			nilfs_message[INVALID_PARAMETER]);
+		return;
+	}
+
+	for (index = 0; index < max_bit_num; index++) {
+		if (err_bitmap_ptr[index / 8] & (1 << (index % 8)))
+			fs_description(err_id[index], segment, log);
+	}
+
+	return;
+} /* print_fs_detected_errors() */
+
+/*****************************************************************************
+ * NAME:  encode_error
+ *
+ * FUNCTION:  Encode subsystem code, message code, segment number and
+ *            log number into error code.
+ *
+ * PARAMETERS:
+ * @subsystem_code: Code of subsystem.
+ * @msg_code: Code of the message.
+ * @type: Error type.
+ * @severity: Error severity.
+ *
+ * RETURNS:
+ * Complex error code or ERR_SEVERITY_SHIFT in the case of internal error.
+ */
+__u64 encode_error(__u16 subsystem_code,
+			int msg_code,
+			__u8 type,
+			__u8 severity)
+{
+	__u64 err_code = 0;
+	__u64 tmp;
+
+	if (msg_code < 0)
+		msg_code = -msg_code;
+
+	if (msg_code >= MSG_CODE_MAX || NILFS_OK == msg_code ||
+			subsystem_code >= SUBSYS_CODE_MAX ||
+			type >= ERR_TYPE_MAX ||
+			severity >= ERR_SEVERITY_MAX)
+		return NILFS_INVALID_ERR_CODE;
+
+	tmp = msg_code;
+	ENCODE_ERR(err_code, tmp, 0);
+	tmp = subsystem_code;
+	ENCODE_ERR(err_code, tmp, SUBSYS_CODE_SHIFT);
+	tmp = type;
+	ENCODE_ERR(err_code, tmp, ERR_TYPE_SHIFT);
+	tmp = severity;
+	ENCODE_ERR(err_code, tmp, ERR_SEVERITY_SHIFT);
+
+	return err_code;
+} /* encode_error() */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
