From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 04/11] nilfs-utils: fsck: add libnilfsmessages.la library into nilfs-utils package
Date: Wed, 5 Sep 2012 23:14:23 +0400
Message-ID: <D485F3F8-E38B-4D36-8604-41D4E3BFFF0A@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=dk0QjNlIZWdvV2c8ZRbtao/a2Liwxf5J+7O9H8BjasI=;
	b=jyQzt+gOJ2LpQY5aSBJBLy7PTa6rfn/2RqzwcGlQc2srvtOcUHHD7Og48Oin2Z15BdfQ5oio/ErVm7ZjpUGDICzzmEnyf0HTd3d3A/DI3CEZerMCevz+lk4BaVubyIQ+;
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
Subject: [PATCH v3 04/11] nilfs-utils: fsck: add libnilfsmessages.la library into nilfs-utils package

This patch adds libnilfsmessages.la library into nilfs-utils package. The library generalizes messages output.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 include/nilfs_messages.def |  132 +++++++++++++++++
 include/nilfs_messages.h   |  126 ++++++++++++++++
 lib/nilfs_messages.c       |  346 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 604 insertions(+), 0 deletions(-)
 create mode 100644 include/nilfs_messages.def
 create mode 100644 include/nilfs_messages.h
 create mode 100644 lib/nilfs_messages.c

diff --git a/include/nilfs_messages.def b/include/nilfs_messages.def
new file mode 100644
index 0000000..afe4e17
--- /dev/null
+++ b/include/nilfs_messages.def
@@ -0,0 +1,132 @@
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
+#ifndef NILFS_UNKNOWN
+#define NILFS_UNKNOWN		0x0
+#endif
+#ifndef NILFS_INFO
+#define NILFS_INFO		0x1
+#endif
+#ifndef NILFS_WARNING
+#define NILFS_WARNING		0x2
+#endif
+#ifndef NILFS_LOOKS_LIKE_ERROR
+#define NILFS_LOOKS_LIKE_ERROR	0x4
+#endif
+#ifndef NILFS_MINOR_ERROR
+#define NILFS_MINOR_ERROR	0x8
+#endif
+#ifndef NILFS_CRITICAL_ERROR
+#define NILFS_CRITICAL_ERROR	0x10
+#endif
+#ifndef NILFS_FATAL_ERROR
+#define NILFS_FATAL_ERROR	0x20
+#endif
+
+#ifndef NILFS_MESSAGE
+#define NILFS_MESSAGE(ID, SEVERITY, MESSAGE)
+#endif
+
+NILFS_MESSAGE(NILFS_OK, NILFS_UNKNOWN, "")
+NILFS_MESSAGE(UNKNOWN_ERROR, NILFS_FATAL_ERROR, "Unknown error has occured.")
+NILFS_MESSAGE(NOT_IMPLEMENTED, NILFS_WARNING, "Sorry. Functionality is not implemented yet.")
+NILFS_MESSAGE(SUCCESS_FAREWELL, NILFS_INFO, "All is OK. Have a nice day.")
+NILFS_MESSAGE(NO_DEVICE, NILFS_FATAL_ERROR, "Device not specified.")
+NILFS_MESSAGE(BAD_DEVICE, NILFS_FATAL_ERROR, "Cannot open device.")
+NILFS_MESSAGE(NOT_MOUNTED, NILFS_INFO, "Device is not mounted.")
+NILFS_MESSAGE(RO_MOUNT, NILFS_WARNING, "Device is mounted in RO mode.")
+NILFS_MESSAGE(RW_MOUNT, NILFS_WARNING, "Device is mounted in RW mode.")
+NILFS_MESSAGE(DEVICE_NOT_OPENED, NILFS_LOOKS_LIKE_ERROR, "Device is not opened.")
+NILFS_MESSAGE(DEVICE_OPENED_YET, NILFS_LOOKS_LIKE_ERROR, "Device is opened yet.")
+NILFS_MESSAGE(INVALID_MODE, NILFS_MINOR_ERROR, "Requested mode is unavailable.")
+NILFS_MESSAGE(FLUSH_FAILED, NILFS_CRITICAL_ERROR, "Flush is failed.")
+NILFS_MESSAGE(CANNOT_CLOSE_DEVICE, NILFS_LOOKS_LIKE_ERROR, "Cannot close device.")
+NILFS_MESSAGE(INVALID_BLOCK_SIZE, NILFS_CRITICAL_ERROR, "Invalid block size.")
+NILFS_MESSAGE(DATA_PROCCESSED_PARTIALLY, NILFS_LOOKS_LIKE_ERROR, "The requested data are proccessed partially.")
+NILFS_MESSAGE(OP_FAILED, NILFS_FATAL_ERROR, "Requested operation has failed.")
+NILFS_MESSAGE(INVALID_PARAMETER, NILFS_MINOR_ERROR, "Input parameters are invalid.")
+NILFS_MESSAGE(OUT_OF_VOLUME, NILFS_CRITICAL_ERROR, "Trying to operate out of volume.")
+NILFS_MESSAGE(CANNOT_SET_DEV_POS, NILFS_CRITICAL_ERROR, "Cannot set current position on device.")
+NILFS_MESSAGE(CANNOT_ALLOCATE, NILFS_FATAL_ERROR, "Cannot allocate memory.")
+NILFS_MESSAGE(CANNOT_FREE, NILFS_LOOKS_LIKE_ERROR, "Cannot free memory.")
+NILFS_MESSAGE(CANNOT_READ_SUPERBLOCK, NILFS_FATAL_ERROR, "Cannot read superblock from disk.")
+NILFS_MESSAGE(INVALID_SB_OFFSET, NILFS_CRITICAL_ERROR, "Invalid value of superblock offset.")
+NILFS_MESSAGE(CANNOT_GET_SUPERBLOCKS, NILFS_FATAL_ERROR, "Cannot get superblocks from requested device.")
+NILFS_MESSAGE(INVALID_NILFS_SIGNATURE, NILFS_WARNING, "Superblock signature is invalid. This is *not* NILFS superblock")
+NILFS_MESSAGE(NILFS_NOT_FOUND, NILFS_WARNING, "NILFS superblocks are not detected.")
+NILFS_MESSAGE(ONLY_SB1_OK_FOUND, NILFS_CRITICAL_ERROR, "Primary valid superblock was found but secondary *not*.")
+NILFS_MESSAGE(ONLY_SB1_CORRUPTED_FOUND, NILFS_CRITICAL_ERROR, "Corrupted primary superblock was found but secondary *not*.")
+NILFS_MESSAGE(ONLY_SB2_OK_FOUND, NILFS_CRITICAL_ERROR, "Secondary valid superblock was found but primary *not*..")
+NILFS_MESSAGE(ONLY_SB2_CORRUPTED_FOUND, NILFS_CRITICAL_ERROR, "Corrupted secondary superblock was found but primary *not*.")
+NILFS_MESSAGE(SB1_SB2_CORRUPTED, NILFS_CRITICAL_ERROR, "Primary and secondary superblocks were found but in corrupted state.")
+NILFS_MESSAGE(SB1_OK_SB2_CORRUPTED, NILFS_CRITICAL_ERROR, "Primary superblock is valid but secondary is in corrupted state.")
+NILFS_MESSAGE(SB1_CORRUPTED_SB2_OK, NILFS_CRITICAL_ERROR, "Secondary superblock is valid but primary is in corrupted state.")
+NILFS_MESSAGE(CANNOT_DETECT_SB_STATE, NILFS_FATAL_ERROR, "Cannot detect state of a superblock because of internal error.")
+NILFS_MESSAGE(SB1_OK_SB2_OK, NILFS_INFO, "NILFS has valid primary and secondary superblocks.")
+NILFS_MESSAGE(CANNOT_CHECK_SB, NILFS_FATAL_ERROR, "Cannot check superblock validity because of internal error.")
+NILFS_MESSAGE(INVALID_SB, NILFS_CRITICAL_ERROR, "Superblock is in corrupted state.")
+NILFS_MESSAGE(INVALID_SB_SIZE, NILFS_CRITICAL_ERROR, "Superblock contains incorrect size in bytes.")
+NILFS_MESSAGE(UNSUPPORTED_SB_REV, NILFS_WARNING, "It is detected an unsupported revision of NILFS superblock.")
+NILFS_MESSAGE(INVALID_CRC, NILFS_CRITICAL_ERROR, "Invalid checksum was detected.")
+NILFS_MESSAGE(OUTSIZED_DEV_SIZE, NILFS_CRITICAL_ERROR, "Superblock keeps value that greater of partition size.")
+NILFS_MESSAGE(UNDERSIZED_DEV_SIZE, NILFS_LOOKS_LIKE_ERROR, "Superblock keeps value that lesser of partition size.")
+NILFS_MESSAGE(INVALID_SB_DEV_SIZE, NILFS_CRITICAL_ERROR, "Superblock keeps invalid value of partition size.")
+NILFS_MESSAGE(INVALID_SB_FEATURE, NILFS_MINOR_ERROR, "Superblock keeps invalid set of feature flags.")
+NILFS_MESSAGE(UNSUPPORTED_SB_RO_FEATURE, NILFS_MINOR_ERROR, "Superblock keeps unsupported RO feature flags. It should work in RO mode.")
+NILFS_MESSAGE(INVALID_SB_FLAGS, NILFS_MINOR_ERROR, "Superblock keeps invalid set of fs independent flags.")
+NILFS_MESSAGE(INVALID_SB_BLOCKS_PER_SEG, NILFS_CRITICAL_ERROR, "Superblock keeps invalid value of blocks per full segment.")
+NILFS_MESSAGE(INVALID_SB_NSEGMENTS, NILFS_CRITICAL_ERROR, "Superblock keeps invalid number of segments in filesystem.")
+NILFS_MESSAGE(INVALID_SB_FIRST_DATA_BLOCK, NILFS_CRITICAL_ERROR, "Superblock keeps invalid value of first data block.")
+NILFS_MESSAGE(INVALID_SB_R_SEGS_PERCENTAGE, NILFS_CRITICAL_ERROR, "Superblock keeps invalid number of reserved segments percentage.")
+NILFS_MESSAGE(INVALID_SB_LAST_CNO, NILFS_CRITICAL_ERROR, "Superblock keeps invalid last checkpoint number.")
+NILFS_MESSAGE(INVALID_SB_LAST_PSEG, NILFS_CRITICAL_ERROR, "Superblock keeps invalid disk block address of partial segment.")
+NILFS_MESSAGE(INVALID_SB_LAST_SEQ, NILFS_CRITICAL_ERROR, "Superblock keeps invalid sequential number of partial segment.")
+NILFS_MESSAGE(INVALID_SB_FREE_BLKS, NILFS_CRITICAL_ERROR, "Superblock keeps invalid free blocks count.")
+NILFS_MESSAGE(INVALID_SB_TIMES, NILFS_LOOKS_LIKE_ERROR, "Superblock keeps invalid timestamps.")
+NILFS_MESSAGE(MAX_POSSIBLE_MNT_COUNT, NILFS_WARNING, "Maximum possible mount count has been reached. It should check filesystem.")
+NILFS_MESSAGE(INVALID_SB_FS_STATE, NILFS_CRITICAL_ERROR, "Superblock keeps invalid file system state flags.")
+NILFS_MESSAGE(INVALID_SB_FS_ERRORS, NILFS_LOOKS_LIKE_ERROR, "Superblock keeps strange definition of behavior in the case of error detection.")
+NILFS_MESSAGE(INVALID_SB_LAST_CHECK, NILFS_LOOKS_LIKE_ERROR, "Superblock keeps invalid timestamp of last check.")
+NILFS_MESSAGE(INVALID_SB_OS, NILFS_MINOR_ERROR, "Superblock keeps invalid code of creator OS.")
+NILFS_MESSAGE(INVALID_SB_DEF_ID, NILFS_MINOR_ERROR, "Superblock keeps invalid default ID for user and group.")
+NILFS_MESSAGE(INVALID_SB_FIRST_INO, NILFS_CRITICAL_ERROR, "Superblock keeps invalid first user's file inode number.")
+NILFS_MESSAGE(INVALID_SB_INO_SZ, NILFS_CRITICAL_ERROR, "Superblock keeps invalid size of on-disk inode.")
+NILFS_MESSAGE(INVALID_SB_DAT_ENTRY_SZ, NILFS_CRITICAL_ERROR, "Superblock keeps invalid DAT entry size.")
+NILFS_MESSAGE(INVALID_SB_CHECKPOINT_SZ, NILFS_CRITICAL_ERROR, "Superblock keeps invalid size of a checkpoint.")
+NILFS_MESSAGE(INVALID_SB_SEG_USAGE_SZ, NILFS_CRITICAL_ERROR, "Superblock keeps invalid size of a segment usage.")
+NILFS_MESSAGE(INVALID_SB_C_INTERVAL, NILFS_MINOR_ERROR, "Superblock keeps invalid value of commit interval of segment.")
+NILFS_MESSAGE(INVALID_SB_C_BLK_MAX, NILFS_MINOR_ERROR, "Superblock keeps invalid value of threshold of data amount for the segment construction.")
+NILFS_MESSAGE(NOT_CLEAN_UMOUNT_DETECTED, NILFS_WARNING, "NILFS had been umounted not cleanly. It should be checked.")
+NILFS_MESSAGE(FS_ERRORS_DETECTED_BY_DRIVER, NILFS_WARNING, "NILFS volumes has errors detected by drivers. It should be recovered.")
+
+
+NILFS_MESSAGE(REQUESTED_DEV, NILFS_UNKNOWN, "Requested device:")
+NILFS_MESSAGE(DONT_WORK_RO_MOUNT, NILFS_INFO, "FSCK *doesn't* work with RO mounted partition currently.")
+NILFS_MESSAGE(DONT_WORK_RW_MOUNT, NILFS_INFO, "FSCK *doesn't* work with RW mounted partition.")
+NILFS_MESSAGE(NOT_NILFS_VOLUME, NILFS_WARNING, "!!!This is not NILFS volume or NILFS volume completely *UNRECOVERABLE*!!!")
+NILFS_MESSAGE(NILFS_HAS_CORRUPTED_SB, NILFS_CRITICAL_ERROR, "Device contains NILFS volume with *CORRUPTED* superblocks.")
+NILFS_MESSAGE(FSCK_DOES_NOTHING, NILFS_INFO, "FSCK currently does nothing.")
+NILFS_MESSAGE(RO_CHECK_DOES_NOT_WORK, NILFS_WARNING, "Read-only check doesn't supported yet.")
+
+#undef NILFS_MESSAGE
diff --git a/include/nilfs_messages.h b/include/nilfs_messages.h
new file mode 100644
index 0000000..999d235
--- /dev/null
+++ b/include/nilfs_messages.h
@@ -0,0 +1,126 @@
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
+#define NILFS_MESSAGE(ID, SEVERITY, MESSAGE) ID,
+#include "nilfs_messages.def"
+
+	MAX_MESSAGE_CODE
+}; /* enum nilfs_message_codes */
+
+/* Possible severity of errors */
+#define NILFS_UNKNOWN		0x0
+#define NILFS_INFO		0x1
+#define NILFS_WARNING		0x2
+#define NILFS_LOOKS_LIKE_ERROR	0x4
+#define NILFS_MINOR_ERROR	0x8
+#define NILFS_CRITICAL_ERROR	0x10
+#define NILFS_FATAL_ERROR	0x20
+
+/* NILFS message array */
+extern const char *nilfs_message[MAX_MESSAGE_CODE];
+
+/* NILFS severity errors table */
+extern const int error_severity[MAX_MESSAGE_CODE];
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
+/* Report about internal errors */
+void internal_error(const char *fmt, ...);
+
+/* Report about internal errors + print system error message */
+void internal_perror(const char *fmt, ...);
+
+/* Debug message */
+void internal_debug(const char *fmt, ...);
+
+/*****************************************************************************
+ * Helpers
+ */
+
+/* Print all FS detected errors */
+void print_fs_detected_errors(const void *errors_bitmap,
+				const int *err_id,
+				__u16 max_bit_num);
+
+#endif /* NILFS_MESSAGES_H */
diff --git a/lib/nilfs_messages.c b/lib/nilfs_messages.c
new file mode 100644
index 0000000..e6c2da7
--- /dev/null
+++ b/lib/nilfs_messages.c
@@ -0,0 +1,346 @@
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
+#define NILFS_MESSAGE(ID, SEVERITY, MESSAGE) MESSAGE,
+#include "nilfs_messages.def"
+
+}; /* const char *nilfs_message[MAX_MESSAGE_CODE] */
+
+/* NILFS severity errors table */
+const int error_severity[MAX_MESSAGE_CODE] = {
+
+#define NILFS_MESSAGE(ID, SEVERITY, MESSAGE) SEVERITY,
+#include "nilfs_messages.def"
+
+}; /* const int error_severity[MAX_MESSAGE_CODE] */
+
+/* Verbosity level of fsck */
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
+		fprintf(out_stream, prefix); \
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
+ * NAME: internal_error
+ *
+ * FUNCTION: Report about internal errors
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void internal_error(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stderr, "[INTERNAL_ERROR]: ", fmt);
+} /* internal_error() */
+
+/*****************************************************************************
+ * NAME: internal_perror
+ *
+ * FUNCTION: Report about internal errors + print system error message
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void internal_perror(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(BE_VERBOSE, stderr, "[INTERNAL_ERROR]: ", fmt);
+	perror("[SYSTEM_ERROR]");
+} /* internal_perror() */
+
+/*****************************************************************************
+ * NAME: internal_debug
+ *
+ * FUNCTION: Debug messages
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void internal_debug(const char *fmt, ...)
+{
+	NILFS_PRINT_MESSAGE(DEBUG_SPAM, stdout, "[INTERNAL_DEBUG]: ", fmt);
+} /* internal_debug() */
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
+ */
+void print_fs_detected_errors(const void *errors_bitmap,
+				const int *err_id,
+				__u16 max_bit_num)
+{
+	int err, index;
+	const __u8 *err_bitmap_ptr = (const __u8 *)errors_bitmap;
+
+	if (!errors_bitmap || !err_id) {
+		internal_debug("<%s>: %s",
+			__func__, nilfs_message[INVALID_PARAMETER]);
+		return;
+	}
+
+	for (index = 0; index < max_bit_num; index++) {
+		if (err_bitmap_ptr[index / 8] & (1 << (index % 8))) {
+			err = err_id[index];
+
+			if (err < NILFS_OK || err >= MAX_MESSAGE_CODE) {
+				internal_debug("<%s>: error code %d.",
+							__func__, err);
+				return;
+			}
+
+			switch (error_severity[err]) {
+			case NILFS_INFO:
+				fs_info("%s", nilfs_message[err]);
+				break;
+			case NILFS_WARNING:
+				fs_warning("%s", nilfs_message[err]);
+				break;
+			case NILFS_FATAL_ERROR:
+				fs_fatal_error("%s", nilfs_message[err]);
+				break;
+			case NILFS_CRITICAL_ERROR:
+				fs_critical_error("%s", nilfs_message[err]);
+				break;
+			case NILFS_MINOR_ERROR:
+				fs_minor_error("%s", nilfs_message[err]);
+				break;
+			case NILFS_LOOKS_LIKE_ERROR:
+				fs_looks_like_error("%s", nilfs_message[err]);
+				break;
+			default:
+				/* Keep silence */
+				break;
+			}
+		}
+	}
+
+	return;
+} /* print_fs_detected_errors() */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
