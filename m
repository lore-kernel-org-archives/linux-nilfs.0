From: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH v2 3/7] nilfs-utils: fsck: add functionality of libfsck.la
 library
Date: Fri, 03 Aug 2012 07:53:34 -0600
Message-ID: <6e9ee54f87a2079f108a416980db89fb@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version; bh=MEM6bzZGEdTs0kSyqpT0QuXffY15DpCkLFOShcBV8n8=;
	b=raB+r2nIDmCq49MWBF99n241vccv/vVNDUFfI55uA1EsL3YGyHIOa332n6x+6CaCSh20PF5fBDvvIzKtUHq8PB4mQGzuNzjr/zVUoIWre0zv9IPlwPIWfGwzO6gYT0+F;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,

This patch adds functionality of libfsck.la library (printing routines 
and raw operations with disk).

With the best regards,
Vyacheslav Dubeyko.
--
 From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 3/7] nilfs-utils: fsck: add functionality of 
libfsck.la library

This patch adds functionality of libfsck.la library (printing routines 
and raw operations with disk).

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
diff --git a/include/fsck_messages.def b/include/fsck_messages.def
new file mode 100644
index 0000000..729ae94
--- /dev/null
+++ b/include/fsck_messages.def
@@ -0,0 +1,80 @@
+/*
+ * fsck_messages.def - List of codes and associated messages
+ *                     (fsck.nilfs2)
+ *
+ * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This file is part of NILFS.
+ *
+ * NILFS is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published 
by
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
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  
02110-1301  USA
+ *
+ * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ */
+
+#ifndef NILFS_FSCK_MESSAGE
+#define NILFS_FSCK_MESSAGE(ID, MESSAGE)
+#endif
+
+NILFS_FSCK_MESSAGE(FSCK_OK, "")
+NILFS_FSCK_MESSAGE(UNKNOWN_ERROR, "Unknown error has occured.")
+NILFS_FSCK_MESSAGE(NOT_IMPLEMENTED, "Sorry. Functionality is not 
implemented yet.")
+NILFS_FSCK_MESSAGE(SUCCESS_FAREWELL, "All is OK. Have a nice day.")
+NILFS_FSCK_MESSAGE(NO_DEVICE, "Device not specified.")
+NILFS_FSCK_MESSAGE(BAD_DEVICE, "Cannot open device.")
+NILFS_FSCK_MESSAGE(NOT_MOUNTED, "Device is not mounted.")
+NILFS_FSCK_MESSAGE(RO_MOUNT, "Device is mounted in RO mode.")
+NILFS_FSCK_MESSAGE(RW_MOUNT, "Device is mounted in RW mode.")
+NILFS_FSCK_MESSAGE(DEVICE_NOT_OPENED, "Device is not opened.")
+NILFS_FSCK_MESSAGE(DEVICE_OPENED_YET, "Device is opened yet.")
+NILFS_FSCK_MESSAGE(INVALID_MODE, "Requested mode is unavailable.")
+NILFS_FSCK_MESSAGE(FLUSH_FAILED, "Flush is failed.")
+NILFS_FSCK_MESSAGE(CANNOT_CLOSE_DEVICE, "Cannot close device.")
+NILFS_FSCK_MESSAGE(INVALID_BLOCK_SIZE, "Invalid block size.")
+NILFS_FSCK_MESSAGE(DATA_PROCCESSED_PARTIALLY, "The requested data are 
proccessed partially.")
+NILFS_FSCK_MESSAGE(OP_FAILED, "Requested operation has failed.")
+NILFS_FSCK_MESSAGE(INVALID_PARAMETER, "Input parameters are invalid.")
+NILFS_FSCK_MESSAGE(OUT_OF_VOLUME, "Trying to operate out of volume.")
+NILFS_FSCK_MESSAGE(CANNOT_SET_DEV_POS, "Cannot set current position on 
device.")
+NILFS_FSCK_MESSAGE(CANNOT_ALLOCATE, "Cannot allocate memory.")
+NILFS_FSCK_MESSAGE(CANNOT_FREE, "Cannot free memory.")
+NILFS_FSCK_MESSAGE(CANNOT_READ_SUPERBLOCK, "Cannot read superblock 
from disk.")
+NILFS_FSCK_MESSAGE(INVALID_SB_OFFSET, "Invalid value of superblock 
offset.")
+NILFS_FSCK_MESSAGE(CANNOT_GET_SUPERBLOCKS, "Cannot get superblocks 
from requested device.")
+NILFS_FSCK_MESSAGE(INVALID_NILFS_SIGNATURE, "Superblock signature is 
invalid. This is *not* NILFS superblock")
+NILFS_FSCK_MESSAGE(NILFS_NOT_FOUND, "NILFS superblocks are not 
detected.")
+NILFS_FSCK_MESSAGE(ONLY_SB1_OK_FOUND, "Primary valid superblock was 
found but secondary *not*.")
+NILFS_FSCK_MESSAGE(ONLY_SB1_CORRUPTED_FOUND, "Corrupted primary 
superblock was found but secondary *not*.")
+NILFS_FSCK_MESSAGE(ONLY_SB2_OK_FOUND, "Secondary valid superblock was 
found but primary *not*..")
+NILFS_FSCK_MESSAGE(ONLY_SB2_CORRUPTED_FOUND, "Corrupted secondary 
superblock was found but primary *not*.")
+NILFS_FSCK_MESSAGE(SB1_SB2_CORRUPTED, "Primary and secondary 
superblocks were found but in corrupted state.")
+NILFS_FSCK_MESSAGE(SB1_OK_SB2_CORRUPTED, "Primary superblock is valid 
but secondary is in corrupted state..")
+NILFS_FSCK_MESSAGE(SB1_CORRUPTED_SB2_OK, "Secondary superblock is 
valid but primary is in corrupted state.")
+NILFS_FSCK_MESSAGE(CANNOT_DETECT_SB_STATE, "Cannot detect state of a 
superblock because of internal error.")
+NILFS_FSCK_MESSAGE(SB1_OK_SB2_OK, "NILFS has valid primary and 
secondary superblocks.")
+NILFS_FSCK_MESSAGE(CANNOT_CHECK_SB, "Cannot check superblock validity 
because of internal error.")
+NILFS_FSCK_MESSAGE(INVALID_SB, "Superblock is in corrupted state.")
+NILFS_FSCK_MESSAGE(INVALID_SB_SIZE, "Superblock contains incorrect 
size in bytes.")
+NILFS_FSCK_MESSAGE(UNSUPPORTED_SB_REV, "It is detected an unsupported 
revision of NILFS superblock.")
+NILFS_FSCK_MESSAGE(INVALID_CRC, "Invalid checksum was detected.")
+
+NILFS_FSCK_MESSAGE(REQUESTED_DEV, "Requested device:")
+NILFS_FSCK_MESSAGE(DONT_WORK_RO_MOUNT, "FSCK *doesn't* work with RO 
mounted partition currently.")
+NILFS_FSCK_MESSAGE(DONT_WORK_RW_MOUNT, "FSCK *doesn't* work with RW 
mounted partition.")
+NILFS_FSCK_MESSAGE(NOT_NILFS_VOLUME, "!!!This is not NILFS volume or 
NILFS volume completely *UNRECOVERABLE*!!!")
+NILFS_FSCK_MESSAGE(NILFS_HAS_CORRUPTED_SB, "Device contains NILFS 
volume with *CORRUPTED* superblocks.")
+NILFS_FSCK_MESSAGE(FSCK_DOES_NOTHING, "FSCK currently does nothing.")
+NILFS_FSCK_MESSAGE(RO_CHECK_DOES_NOT_WORK, "Read-only check doesn't 
supported yet.")
+
+#undef NILFS_FSCK_MESSAGE
diff --git a/include/fsck_messages.h b/include/fsck_messages.h
new file mode 100644
index 0000000..6efe42f
--- /dev/null
+++ b/include/fsck_messages.h
@@ -0,0 +1,126 @@
+/*
+ * fsck_messages.h - Declaration of fsck error, warning, info codes,
+ *                   associated messages and routines (fsck.nilfs2)
+ *
+ * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This file is part of NILFS.
+ *
+ * NILFS is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published 
by
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
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  
02110-1301  USA
+ *
+ * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ */
+
+#ifndef FSCK_MESSAGES_H
+#define FSCK_MESSAGES_H
+
+/* Available verbosity levels of fsck. */
+enum fsck_verbosity_level {
+	KEEP_SILENCE,
+	BE_VERBOSE,
+	DEBUG_SPAM
+}; /* enum fsck_verbosity_level */
+
+/* NILFS error, warning, info codes and associated messages. */
+enum fsck_message_codes {
+
+#define NILFS_FSCK_MESSAGE(ID, MESSAGE) ID,
+#include "fsck_messages.def"
+
+	MAX_MESSAGE_CODE
+}; /* enum fsck_message_codes */
+
+/* Possible severity of FS errors */
+enum fs_error_severity {
+	FS_INFO,
+	FS_WARNING,
+	FS_FATAL_ERROR,
+	FS_CRITICAL_ERROR,
+	FS_MINOR_ERROR,
+	FS_LOOKS_LIKE_ERROR
+}; /* enum fsck_error_severity */
+
+/* NILFS fsck exit codes. */
+enum fsck_exit_codes {
+	RETURN_FSCK_OK                 = 0,
+	RETURN_FSCK_CORRECTED          = 1,
+	RETURN_FSCK_REBOOT             = 2,
+	RETURN_FSCK_ERRORS_UNCORRECTED = 4,
+	RETURN_FSCK_OP_ERROR           = 8,
+	RETURN_FSCK_USAGE_ERROR        = 16,
+	EXIT_LIBRARY                   = 128
+}; /* enum fsck_exit_codes */
+
+/* NILFS fsck message array */
+extern const char *fsck_message[MAX_MESSAGE_CODE];
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
+ * Fsck internal messages
+ */
+
+/* Inform user about fsck common actions */
+void fsck_info(const char *fmt, ...);
+
+/* Warn user about some important situation in fsck states */
+void fsck_warning(const char *fmt, ...);
+
+/* Report about internal fsck errors */
+void fsck_error(const char *fmt, ...);
+
+/* Report about internal fsck errors + print system error message */
+void fsck_perror(const char *fmt, ...);
+
+/* Debug messages of fsck */
+void fsck_debug(const char *fmt, ...);
+
+#endif /* FSCK_MESSAGES_H */
diff --git a/include/fsck_raw_ops.h b/include/fsck_raw_ops.h
new file mode 100644
index 0000000..5d2ee48
--- /dev/null
+++ b/include/fsck_raw_ops.h
@@ -0,0 +1,55 @@
+/*
+ * fsck_raw_ops.h - Declarations for raw operations with disk
+ *
+ * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This file is part of NILFS.
+ *
+ * NILFS is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published 
by
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
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  
02110-1301  USA
+ *
+ * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ */
+
+#ifndef FSCK_RAW_OPS_H
+#define FSCK_RAW_OPS_H
+
+/* Open volume for fsck operations */
+int open_volume(const char *device_name);
+
+/* Get file descriptor of opened volume */
+int device_file_descriptor(void);
+
+/* Close volume after fsck operations */
+int close_volume(void);
+
+/* Return device sector size in bytes */
+int get_device_sector_size(void);
+
+/* Return device size in bytes */
+__u64 get_device_size_in_bytes(void);
+
+/* Read bytes from volume */
+int read_raw_bytes(__u64 device_offset,
+			void *raw_data_buffer,
+			__u32 requested_bytes_count,
+			__u32 *read_bytes_count);
+
+/* Write bytes to volume */
+int write_raw_bytes(__u64 device_offset,
+			void *raw_data_buffer,
+			__u32 requested_bytes_count,
+			__u32 *written_bytes_count);
+
+#endif /* FSCK_RAW_OPS_H */
diff --git a/lib/fsck_messages.c b/lib/fsck_messages.c
new file mode 100644
index 0000000..66885af
--- /dev/null
+++ b/lib/fsck_messages.c
@@ -0,0 +1,274 @@
+/*
+ * fsck_messages.c - Print routines (libfsck)
+ *
+ * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This file is part of NILFS.
+ *
+ * NILFS is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published 
by
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
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  
02110-1301  USA
+ *
+ * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ */
+
+#include <stdio.h>
+#include <stdarg.h>
+
+#include "fsck_messages.h"
+
+/*****************************************************************************
+ * GLOBAL VARIABLES
+ 
*****************************************************************************/
+
+/* NILFS fsck message array */
+const char *fsck_message[MAX_MESSAGE_CODE] = {
+
+#define NILFS_FSCK_MESSAGE(ID, MESSAGE) MESSAGE,
+#include "fsck_messages.def"
+
+}; /* const char *fsck_message[MAX_MESSAGE_CODE] */
+
+/* Verbosity level of fsck */
+int verbosity_level = BE_VERBOSE;
+
+/*****************************************************************************
+ * IMPLEMENTATION SECTION
+ 
*****************************************************************************/
+
+/*****************************************************************************
+ * NAME: set_verbosity_level (libfsck)
+ *
+ * MACRO: Set verbosity level
+ *
+ * PARAMETERS:
+ * @requested_level: Requested level of verbosity.
+ */
+void set_verbosity_level(int requested_level)
+{
+	if (requested_level < KEEP_SILENCE ||
+			requested_level > DEBUG_SPAM) {
+		fprintf(stderr, "[FSCK_ERROR]: unknow verbosity level.");
+		fprintf(stderr, "Keep the same verbosity level.\n");
+		return;
+	}
+
+	verbosity_level = requested_level;
+} /* set_verbosity_level */
+
+/*****************************************************************************
+ * NAME: FSCK_PRINT_MESSAGE (libfsck)
+ *
+ * MACRO: Print fsck message into stdout/stderr
+ *
+ * PARAMETERS:
+ * @granted_verbosity: Verbosity level gives right to print.
+ * @out_stream: Type of the standard output stream [stdout | stderr].
+ * @prefix: Prefix word begins a message.
+ * @fmt: Format of the message.
+ */
+#define FSCK_PRINT_MESSAGE(granted_verbosity, out_stream, prefix, fmt) 
\
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
+/* FSCK_PRINT_MESSAGE */
+
+/*****************************************************************************
+ * NAME: ui_info (libfsck)
+ *
+ * FUNCTION: Inform user about something
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void ui_info(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stdout, "[UI_INFO]: ", fmt);
+} /* ui_info() */
+
+/*****************************************************************************
+ * NAME: ui_warning (libfsck)
+ *
+ * FUNCTION: Warn user about some important but not critical situation
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void ui_warning(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stdout, "[UI_WARNING]: ", fmt);
+} /* ui_warning() */
+
+/*****************************************************************************
+ * NAME: ui_error (libfsck)
+ *
+ * FUNCTION: Report error in way of using the utility
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void ui_error(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stdout, "[UI_ERROR]: ", fmt);
+} /* ui_error() */
+
+/*****************************************************************************
+ * NAME: fs_info (libfsck)
+ *
+ * FUNCTION: Inform user about file system state
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fs_info(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stdout, "[FS_INFO]: ", fmt);
+} /* fs_info() */
+
+/*****************************************************************************
+ * NAME: fs_warning (libfsck)
+ *
+ * FUNCTION: Warn user about some important thing in file system state
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fs_warning(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_WARNING]: ", fmt);
+} /* fs_warning() */
+
+/*****************************************************************************
+ * NAME: fs_fatal_error (libfsck)
+ *
+ * FUNCTION: Report about detected unrecoverable error in file 
system's metadata
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fs_fatal_error(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_FATAL_ERROR]: ", fmt);
+} /* fs_fatal_error() */
+
+/*****************************************************************************
+ * NAME: fs_critical_error (libfsck)
+ *
+ * FUNCTION: Report about detected critical file system's metadata 
error
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fs_critical_error(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_CRITICAL_ERROR]: ", fmt);
+} /* fs_critical_error() */
+
+/*****************************************************************************
+ * NAME: fs_minor_error (libfsck)
+ *
+ * FUNCTION: Report about detected minor file system's metadata error
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fs_minor_error(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_MINOR_ERROR]: ", fmt);
+} /* fs_minor_error() */
+
+/*****************************************************************************
+ * NAME: fs_looks_like_error (libfsck)
+ *
+ * FUNCTION: Report about detected suspicious metadata's state looks 
like error
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fs_looks_like_error(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FS_LOOKS_LIKE_ERROR]: ", 
fmt);
+} /* fs_looks_like_error() */
+
+/*****************************************************************************
+ * NAME: fsck_info (libfsck)
+ *
+ * FUNCTION: Inform user about fsck common actions
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fsck_info(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stdout, "[FSCK_INFO]: ", fmt);
+} /* fsck_info() */
+
+/*****************************************************************************
+ * NAME: fsck_warning (libfsck)
+ *
+ * FUNCTION: Warn user about some important situation in fsck states
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fsck_warning(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FSCK_WARNING]: ", fmt);
+} /* fsck_warning() */
+
+/*****************************************************************************
+ * NAME: fsck_error (libfsck)
+ *
+ * FUNCTION: Report about internal fsck errors
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fsck_error(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FSCK_ERROR]: ", fmt);
+} /* fsck_error() */
+
+/*****************************************************************************
+ * NAME: fsck_perror (libfsck)
+ *
+ * FUNCTION: Report about internal fsck errors + print system error 
message
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fsck_perror(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(BE_VERBOSE, stderr, "[FSCK_ERROR]: ", fmt);
+	perror("[SYSTEM_ERROR]");
+} /* fsck_perror() */
+
+/*****************************************************************************
+ * NAME: fsck_debug (libfsck)
+ *
+ * FUNCTION: Debug messages of fsck
+ *
+ * PARAMETERS:
+ * @fmt: Format of the message.
+ */
+void fsck_debug(const char *fmt, ...)
+{
+	FSCK_PRINT_MESSAGE(DEBUG_SPAM, stdout, "[FSCK_DEBUG]: ", fmt);
+} /* fsck_debug() */
diff --git a/lib/fsck_raw_ops.c b/lib/fsck_raw_ops.c
new file mode 100644
index 0000000..04decdd
--- /dev/null
+++ b/lib/fsck_raw_ops.c
@@ -0,0 +1,473 @@
+/*
+ * fsck_raw_ops.c - Raw operations with disk functionality
+ *
+ * Copyright (C) 2012 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This file is part of NILFS.
+ *
+ * NILFS is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published 
by
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
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  
02110-1301  USA
+ *
+ * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ */
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
+#include <string.h>
+#include <linux/fs.h>
+
+#if HAVE_SYS_IOCTL_H
+#include <sys/ioctl.h>
+#endif	/* HAVE_SYS_IOCTL_H */
+
+#include "nilfs.h"
+#include "fsck_messages.h"
+#include "fsck_raw_ops.h"
+
+/*****************************************************************************
+ * CONSTANTS
+ 
*****************************************************************************/
+
+#define DEVICE_RO_MODE "rb"
+#define DEVICE_RW_MODE "r+b"
+
+/*****************************************************************************
+ * GLOBAL VARIABLES
+ 
*****************************************************************************/
+
+/* Pointer on opened device */
+FILE *opened_device_ptr;
+
+/* Block device sector size (default value: 512 bytes) */
+int device_sector_size = DEFAULT_SECTOR_SIZE;
+
+/* Size of the device in bytes */
+__u64 device_size_in_bytes;
+
+/*****************************************************************************
+ * IMPLEMENTATION SECTION
+ 
*****************************************************************************/
+
+/*****************************************************************************
+ * NAME:  get_device_sector_size (libfsck)
+ *
+ * FUNCTION:  Return device sector size in bytes.
+ *
+ * RETURNS:
+ * It simply returns value of device_sector_size global variable.
+ * The value is set during device opening.
+ */
+int get_device_sector_size(void)
+{
+	return device_sector_size;
+} /* get_device_sector_size() */
+
+/*****************************************************************************
+ * NAME:  get_device_size_in_bytes (libfsck)
+ *
+ * FUNCTION:  Return device size in bytes.
+ *
+ * RETURNS:
+ * It simply returns value of device_size_in_bytes global variable.
+ * The value is set during device opening.
+ */
+__u64 get_device_size_in_bytes(void)
+{
+	return device_size_in_bytes;
+} /* get_device_size_in_bytes() */
+
+/*****************************************************************************
+ * NAME:  open_device (libfsck)
+ *
+ * FUNCTION:  Open device.
+ *
+ * PARAMETERS:
+ * @device_name: Name of the device for opening
+ * @mode: mode of opening [RO | RW]
+ *
+ * RETURNS:
+ * FSCK_OK - device has opened successfully.
+ * %-BAD_DEVICE - cannot open device.
+ */
+static int open_device(const char *device_name, const char *mode)
+{
+	int file_descriptor = 0;
+
+	if (!device_name || !mode) {
+		fsck_debug("<%s>: NULL pointer.", __func__);
+		return -BAD_DEVICE;
+	}
+
+	fsck_debug("<%s>: try to open device %s in %s mode.",
+			__func__, device_name, mode);
+
+	if (opened_device_ptr) {
+		fsck_debug("<%s>: %s Device %s is opened yet.",
+				__func__, fsck_message[BAD_DEVICE],
+				device_name);
+		return -BAD_DEVICE;
+	}
+
+	opened_device_ptr = fopen(device_name, mode);
+	if (!opened_device_ptr) {
+		fsck_debug("<%s>: %s The mode %s is invalid for %s device.",
+				__func__, fsck_message[BAD_DEVICE],
+				device_name, mode);
+		return -BAD_DEVICE;
+	}
+
+	/* In the case of error fileno() returns -1 */
+	file_descriptor = fileno(opened_device_ptr);
+	if (-1 == file_descriptor) {
+		fsck_debug("<%s>: cannot convert pointer into descriptor.",
+				__func__);
+		goto open_success;
+	}
+
+	/* In the case of error ioctl() returns -1 */
+	if (-1 == ioctl(file_descriptor, BLKSSZGET, &device_sector_size))
+		fsck_debug("<%s>: cannot detect device sector size.", __func__);
+	else {
+		fsck_debug("<%s>: sector size %d.",
+				__func__, device_sector_size);
+	}
+
+	/* In the case of error ioctl() returns -1 */
+	if (-1 == ioctl(file_descriptor, BLKGETSIZE64, 
&device_size_in_bytes)) {
+		fsck_debug("<%s>: cannot detect device size in bytes.",
+				__func__);
+	} else {
+		fsck_debug("<%s>: device size in bytes %lld.",
+				__func__, device_size_in_bytes);
+	}
+
+open_success:
+	fsck_debug("<%s>: device %s is opened in %s mode successfully.",
+			__func__, device_name, mode);
+	return FSCK_OK;
+} /* open_device() */
+
+/*****************************************************************************
+ * NAME:  open_device_ro (libfsck)
+ *
+ * FUNCTION:  Open device in READ-ONLY mode.
+ *
+ * PARAMETERS:
+ * @device_name: Name of the device for opening
+ *
+ * RETURNS:
+ * FSCK_OK - device has opened successfully.
+ * %-BAD_DEVICE - cannot open device.
+ */
+static int open_device_ro(const char *device_name)
+{
+	return open_device(device_name, DEVICE_RO_MODE);
+} /* open_device_ro() */
+
+/*****************************************************************************
+ * NAME:  open_device_rw (libfsck)
+ *
+ * FUNCTION:  Open device in READ-WRITE mode.
+ *
+ * PARAMETERS:
+ * @device_name: Name of the device for opening
+ *
+ * RETURNS:
+ * FSCK_OK - device has opened successfully.
+ * %-BAD_DEVICE - cannot open device.
+ */
+static int open_device_rw(const char *device_name)
+{
+	/* <TODO: add support of RW mode> */
+	ui_error("%s %s", fsck_message[BAD_DEVICE],
+				fsck_message[NOT_IMPLEMENTED]);
+	return -BAD_DEVICE;
+} /* open_device_rw() */
+
+/*****************************************************************************
+ * NAME:  open_volume (libfsck)
+ *
+ * FUNCTION:  Open volume for fsck operations.
+ *
+ * PARAMETERS:
+ * @device_name: Name of the device for opening
+ *
+ * RETURNS:
+ * FSCK_OK - device has opened successfully.
+ * %-BAD_DEVICE - cannot open device.
+ */
+int open_volume(const char *device_name)
+{
+	/* <TODO: Currently it simply opens device in RO mode.
+		  Function should analyze user options and open
+		  device in proper mode.> */
+	return open_device_ro(device_name);
+} /* open_volume() */
+
+/*****************************************************************************
+ * NAME:  device_file_descriptor (libfsck)
+ *
+ * FUNCTION:  Get file descriptor of opened volume.
+ *
+ * RETURNS:
+ * Returns file descriptor or -1 in the case of failure.
+ */
+int device_file_descriptor(void)
+{
+	if (!opened_device_ptr)
+		return -1;
+
+	return fileno(opened_device_ptr);
+} /* device_file_descriptor() */
+
+/*****************************************************************************
+ * NAME:  close_volume (libfsck)
+ *
+ * FUNCTION:  Close volume after fsck operations.
+ *
+ * RETURNS:
+ * FSCK_OK - device has closed successfully.
+ * %-DEVICE_NOT_OPENED - device is not opened.
+ * %-FLUSH_FAILED - some error occurs during flushing.
+ * %-CANNOT_CLOSE_DEVICE - cannot close device.
+ */
+int close_volume(void)
+{
+	int file_descriptor = 0;
+
+	fsck_debug("<%s>: try to close device.", __func__);
+
+	if (!opened_device_ptr) {
+		fsck_debug("<%s>: %s",
+			__func__, fsck_message[DEVICE_NOT_OPENED]);
+		return -DEVICE_NOT_OPENED;
+	}
+
+	/* In the case of error fileno() returns -1 */
+	file_descriptor = fileno(opened_device_ptr);
+	if (-1 == file_descriptor) {
+		fsck_debug("<%s>: cannot convert pointer into descriptor.",
+				__func__);
+		goto close_device;
+	}
+
+	/* In the case of error fsync() returns -1 */
+	if (-1 == fsync(file_descriptor))
+		fsck_debug("<%s>: %s", __func__, fsck_message[FLUSH_FAILED]);
+
+close_device:
+	if (fclose(opened_device_ptr)) {
+		fsck_debug("<%s>: %s",
+			__func__, fsck_message[CANNOT_CLOSE_DEVICE]);
+		return -CANNOT_CLOSE_DEVICE;
+	}
+
+	device_sector_size = DEFAULT_SECTOR_SIZE;
+	device_size_in_bytes = 0;
+
+	fsck_debug("<%s>: device is closed successfully.", __func__);
+	return FSCK_OK;
+} /* close_volume() */
+
+/* Define type of operation with raw bytes */
+enum {
+	OP_READ,
+	OP_WRITE
+};
+
+/*****************************************************************************
+ * NAME:  raw_bytes (libfsck)
+ *
+ * FUNCTION:  Read or write bytes on volume.
+ *
+ * PARAMETERS:
+ * @op_mode: Type of operation with volume.
+ * @device_offset: Offset from device beginning in bytes.
+ * @raw_data_buffer: Pointer on buffer with data.
+ * @requested_bytes_count: Requested count of bytes for operation.
+ * @actual_bytes_count: Actual count of proccessed bytes.
+ *
+ * RETURNS:
+ * FSCK_OK - All requested count of data are proccessed successfully.
+ * %-DEVICE_NOT_OPENED - Device is not opened.
+ * %-DATA_PROCCESSED_PARTIALLY - The requested data are proccessed 
partially.
+ * %-OP_FAILED - Requested operation has failed.
+ * %-INVALID_PARAMETER - Input parameters are invalid.
+ * %-CANNOT_SET_DEV_POS - Cannot set current position on device.
+ */
+static int raw_bytes(int op_mode,
+			__u64 device_offset,
+			void *raw_data_buffer,
+			__u32 requested_bytes_count,
+			__u32 *actual_bytes_count)
+{
+	int err = FSCK_OK;
+
+	fsck_debug("<%s>: try to proccess %d bytes on %lld offset.",
+			__func__, requested_bytes_count, device_offset);
+
+	if (NULL == raw_data_buffer || NULL == actual_bytes_count) {
+		fsck_debug("<%s>: %s",
+				__func__, fsck_message[INVALID_PARAMETER]);
+		fsck_debug("<%s>: raw_data_buffer is %#x.",
+				__func__, raw_data_buffer);
+		fsck_debug("<%s>: actual_bytes_count is %#x.",
+				__func__, actual_bytes_count);
+		return -INVALID_PARAMETER;
+	}
+
+	(*actual_bytes_count) = 0;
+
+	if (0 == requested_bytes_count) {
+		fsck_debug("<%s>: does nothing.", __func__);
+		return FSCK_OK;
+	}
+
+	if (!opened_device_ptr) {
+		fsck_debug("<%s>: %s",
+			__func__, fsck_message[DEVICE_NOT_OPENED]);
+		return -DEVICE_NOT_OPENED;
+	}
+
+	if (device_offset >= device_size_in_bytes) {
+		fsck_debug("<%s>: ATTENTION!!! Device size is %lld.",
+				__func__, device_size_in_bytes);
+		return -INVALID_PARAMETER;
+	}
+
+	if ((device_offset + requested_bytes_count) > device_size_in_bytes)
+		fsck_debug("<%s>: %s", __func__, fsck_message[OUT_OF_VOLUME]);
+
+	if (0 != fseeko(opened_device_ptr, device_offset, SEEK_SET)) {
+		fsck_debug("<%s>: %s",
+				__func__, fsck_message[CANNOT_SET_DEV_POS]);
+		err = -CANNOT_SET_DEV_POS;
+		goto raw_bytes_op_failed;
+	}
+
+	switch (op_mode) {
+	case OP_READ:
+		(*actual_bytes_count) =
+			fread(raw_data_buffer, 1,
+				requested_bytes_count, opened_device_ptr);
+		break;
+	case OP_WRITE:
+		(*actual_bytes_count) =
+			fwrite(raw_data_buffer, 1,
+				requested_bytes_count, opened_device_ptr);
+		break;
+	default:
+		fsck_debug("<%s>: the requested value %d is invalid mode.",
+				__func__, op_mode);
+		err = -INVALID_PARAMETER;
+		goto raw_bytes_op_failed;
+	}
+
+	if (-1 == (*actual_bytes_count)) {
+		(*actual_bytes_count) = 0;
+		fsck_debug("<%s>: %s", __func__, fsck_message[OP_FAILED]);
+		err = -OP_FAILED;
+		goto raw_bytes_op_failed;
+	} else if ((*actual_bytes_count) != requested_bytes_count) {
+		fsck_debug("<%s>: %s",
+			__func__, fsck_message[DATA_PROCCESSED_PARTIALLY]);
+		fsck_debug("<%s>: Requested %d bytes. Proccessed %d bytes.",
+				__func__, requested_bytes_count,
+				(*actual_bytes_count));
+		err = -DATA_PROCCESSED_PARTIALLY;
+		if (0 != feof(opened_device_ptr)) {
+			clearerr(opened_device_ptr);
+			goto raw_bytes_op_failed;
+		} else
+			goto raw_bytes_finished;
+	} else {
+		fsck_debug("<%s>: Requested %d bytes proccessed successfully.",
+				__func__, requested_bytes_count);
+		goto raw_bytes_finished;
+	}
+
+raw_bytes_op_failed:
+	rewind(opened_device_ptr);
+
+raw_bytes_finished:
+	return err;
+} /* raw_bytes() */
+
+/*****************************************************************************
+ * NAME:  read_raw_bytes (libfsck)
+ *
+ * FUNCTION:  Read bytes from volume.
+ *
+ * PARAMETERS:
+ * @device_offset: Offset from device beginning in bytes.
+ * @raw_data_buffer: Pointer on buffer with read data.
+ * @requested_bytes_count: Requested count of bytes for read.
+ * @read_bytes_count: Actual count of read bytes.
+ *
+ * RETURNS:
+ * FSCK_OK - All requested count of data are proccessed successfully.
+ * %-DEVICE_NOT_OPENED - Device is not opened.
+ * %-DATA_PROCCESSED_PARTIALLY - The requested data are proccessed 
partially.
+ * %-OP_FAILED - Requested operation has failed.
+ * %-INVALID_PARAMETER - Input parameters are invalid.
+ * %-CANNOT_SET_DEV_POS - Cannot set current position on device.
+ */
+int read_raw_bytes(__u64 device_offset,
+			void *raw_data_buffer,
+			__u32 requested_bytes_count,
+			__u32 *read_bytes_count)
+{
+	return raw_bytes(OP_READ, device_offset, raw_data_buffer,
+				requested_bytes_count,
+				read_bytes_count);
+} /* read_raw_bytes() */
+
+/*****************************************************************************
+ * NAME:  write_raw_bytes (fsck.nilfs2)
+ *
+ * FUNCTION:  Write bytes to volume.
+ *
+ * PARAMETERS:
+ * @device_offset: Offset from device beginning in bytes.
+ * @raw_data_buffer: Pointer on buffer with data for write.
+ * @requested_bytes_count: Requested count of bytes for write.
+ * @written_bytes_count: Actual count of written bytes.
+ *
+ * RETURNS:
+ * FSCK_OK - All requested count of data are proccessed successfully.
+ * %-DEVICE_NOT_OPENED - Device is not opened.
+ * %-DATA_PROCCESSED_PARTIALLY - The requested data are proccessed 
partially.
+ * %-OP_FAILED - Requested operation has failed.
+ * %-INVALID_PARAMETER - Input parameters are invalid.
+ * %-CANNOT_SET_DEV_POS - Cannot set current position on device.
+ */
+int write_raw_bytes(__u64 device_offset,
+			void *raw_data_buffer,
+			__u32 requested_bytes_count,
+			__u32 *written_bytes_count)
+{
+	/* <TODO: maybe not write full portion of data is error.
+	   Need to think.> */
+	return raw_bytes(OP_WRITE, device_offset, raw_data_buffer,
+				requested_bytes_count,
+				written_bytes_count);
+} /* write_raw_bytes() */
--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
