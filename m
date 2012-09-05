From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 05/11] nilfs-utils: fsck: add libfsck.la library into nilfs-utils package
Date: Wed, 5 Sep 2012 23:14:37 +0400
Message-ID: <B7F1EF58-9E35-43E1-B2B9-B2157394018A@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=27aDakke/BgsdR8ePgrWh3dSnmiTp9NQ52CwJXOOT08=;
	b=N+qLZD/uTc0pnjbqgG5rtLWcBqVMaTfhQB+dK+efxBnEj1aX15deN5/TyNly07FOM9B8LMG6PjqrLsP3K9lIdB56Y0t0r45KnS8Mu8Vuok6cnPgHakPwFid2q+DistXk;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds libfsck.la library into nilfs-utils package. The library has purpose to encapsulate common functionality of fsck.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 05/11] nilfs-utils: fsck: add libfsck.la library into nilfs-utils package

This patch adds libfsck.la library into nilfs-utils package. The library has purpose to encapsulate common functionality of fsck.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 include/fsck_raw_ops.h |   55 ++++++
 lib/fsck_raw_ops.c     |  478 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 533 insertions(+), 0 deletions(-)
 create mode 100644 include/fsck_raw_ops.h
 create mode 100644 lib/fsck_raw_ops.c

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
diff --git a/lib/fsck_raw_ops.c b/lib/fsck_raw_ops.c
new file mode 100644
index 0000000..98ef844
--- /dev/null
+++ b/lib/fsck_raw_ops.c
@@ -0,0 +1,478 @@
+/*
+ * fsck_raw_ops.c - Raw operations with disk functionality
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
+#include "nilfs_messages.h"
+#include "fsck_raw_ops.h"
+
+/*****************************************************************************
+ * CONSTANTS
+ *****************************************************************************/
+
+#define DEVICE_RO_MODE "rb"
+#define DEVICE_RW_MODE "r+b"
+
+/*****************************************************************************
+ * GLOBAL VARIABLES
+ *****************************************************************************/
+
+/* Pointer on opened device */
+FILE *opened_device_ptr;
+
+/* Block device sector size (default value: 512 bytes) */
+int device_sector_size = DEFAULT_SECTOR_SIZE;
+
+/* Size of the device in bytes */
+__u64 device_size_in_bytes = -1;
+
+/*****************************************************************************
+ * IMPLEMENTATION SECTION
+ *****************************************************************************/
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
+ * NILFS_OK - device has opened successfully.
+ * %-BAD_DEVICE - cannot open device.
+ */
+static int open_device(const char *device_name, const char *mode)
+{
+	int file_descriptor = 0;
+
+	if (!device_name || !mode) {
+		internal_debug("<%s>: NULL pointer.", __func__);
+		return -BAD_DEVICE;
+	}
+
+	internal_debug("<%s>: try to open device %s in %s mode.",
+			__func__, device_name, mode);
+
+	if (opened_device_ptr) {
+		internal_debug("<%s>: %s Device %s is opened yet.",
+				__func__, nilfs_message[BAD_DEVICE],
+				device_name);
+		return -BAD_DEVICE;
+	}
+
+	opened_device_ptr = fopen(device_name, mode);
+	if (!opened_device_ptr) {
+		internal_debug("<%s>: %s The mode %s is invalid for %s device.",
+				__func__, nilfs_message[BAD_DEVICE],
+				device_name, mode);
+		return -BAD_DEVICE;
+	}
+
+	/* In the case of error fileno() returns -1 */
+	file_descriptor = fileno(opened_device_ptr);
+	if (-1 == file_descriptor) {
+		internal_debug("<%s>: cannot convert pointer into descriptor.",
+				__func__);
+		goto open_success;
+	}
+
+	/* In the case of error ioctl() returns -1 */
+	if (-1 == ioctl(file_descriptor, BLKSSZGET, &device_sector_size))
+		internal_debug("<%s>: cannot detect device sector size.",
+				__func__);
+	else {
+		internal_debug("<%s>: sector size %d.",
+				__func__, device_sector_size);
+	}
+
+	/* In the case of error ioctl() returns -1 */
+	if (-1 == ioctl(file_descriptor, BLKGETSIZE64, &device_size_in_bytes)) {
+		internal_debug("<%s>: cannot detect device size in bytes.",
+				__func__);
+	} else {
+		internal_debug("<%s>: device size in bytes %lld.",
+				__func__, device_size_in_bytes);
+	}
+
+open_success:
+	internal_debug("<%s>: device %s is opened in %s mode successfully.",
+			__func__, device_name, mode);
+	return NILFS_OK;
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
+ * NILFS_OK - device has opened successfully.
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
+ * NILFS_OK - device has opened successfully.
+ * %-BAD_DEVICE - cannot open device.
+ */
+static int open_device_rw(const char *device_name)
+{
+	/* <TODO: add support of RW mode> */
+	ui_error("%s %s", nilfs_message[BAD_DEVICE],
+				nilfs_message[NOT_IMPLEMENTED]);
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
+ * NILFS_OK - device has opened successfully.
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
+ * NILFS_OK - device has closed successfully.
+ * %-DEVICE_NOT_OPENED - device is not opened.
+ * %-FLUSH_FAILED - some error occurs during flushing.
+ * %-CANNOT_CLOSE_DEVICE - cannot close device.
+ */
+int close_volume(void)
+{
+	int file_descriptor = 0;
+
+	internal_debug("<%s>: try to close device.", __func__);
+
+	if (!opened_device_ptr) {
+		internal_debug("<%s>: %s",
+			__func__, nilfs_message[DEVICE_NOT_OPENED]);
+		return -DEVICE_NOT_OPENED;
+	}
+
+	/* In the case of error fileno() returns -1 */
+	file_descriptor = fileno(opened_device_ptr);
+	if (-1 == file_descriptor) {
+		internal_debug("<%s>: cannot convert pointer into descriptor.",
+				__func__);
+		goto close_device;
+	}
+
+	/* In the case of error fsync() returns -1 */
+	if (-1 == fsync(file_descriptor)) {
+		internal_debug("<%s>: %s",
+			__func__, nilfs_message[FLUSH_FAILED]);
+	}
+
+close_device:
+	if (fclose(opened_device_ptr)) {
+		internal_debug("<%s>: %s",
+			__func__, nilfs_message[CANNOT_CLOSE_DEVICE]);
+		return -CANNOT_CLOSE_DEVICE;
+	}
+
+	device_sector_size = DEFAULT_SECTOR_SIZE;
+	device_size_in_bytes = 0;
+
+	internal_debug("<%s>: device is closed successfully.", __func__);
+	return NILFS_OK;
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
+ * NILFS_OK - All requested count of data are proccessed successfully.
+ * %-DEVICE_NOT_OPENED - Device is not opened.
+ * %-DATA_PROCCESSED_PARTIALLY - The requested data are proccessed partially.
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
+	int err = NILFS_OK;
+
+	internal_debug("<%s>: try to proccess %d bytes on %lld offset.",
+			__func__, requested_bytes_count, device_offset);
+
+	if (NULL == raw_data_buffer || NULL == actual_bytes_count) {
+		internal_debug("<%s>: %s",
+				__func__, nilfs_message[INVALID_PARAMETER]);
+		internal_debug("<%s>: raw_data_buffer is %#x.",
+				__func__, raw_data_buffer);
+		internal_debug("<%s>: actual_bytes_count is %#x.",
+				__func__, actual_bytes_count);
+		return -INVALID_PARAMETER;
+	}
+
+	(*actual_bytes_count) = 0;
+
+	if (0 == requested_bytes_count) {
+		internal_debug("<%s>: does nothing.", __func__);
+		return NILFS_OK;
+	}
+
+	if (!opened_device_ptr) {
+		internal_debug("<%s>: %s",
+			__func__, nilfs_message[DEVICE_NOT_OPENED]);
+		return -DEVICE_NOT_OPENED;
+	}
+
+	if (device_offset >= device_size_in_bytes) {
+		internal_debug("<%s>: ATTENTION!!! Device size is %lld.",
+				__func__, device_size_in_bytes);
+		return -INVALID_PARAMETER;
+	}
+
+	if ((device_offset + requested_bytes_count) > device_size_in_bytes) {
+		internal_debug("<%s>: %s",
+				__func__, nilfs_message[OUT_OF_VOLUME]);
+	}
+
+	if (0 != fseeko(opened_device_ptr, device_offset, SEEK_SET)) {
+		internal_debug("<%s>: %s",
+				__func__, nilfs_message[CANNOT_SET_DEV_POS]);
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
+		internal_debug("<%s>: the requested value %d is invalid mode.",
+				__func__, op_mode);
+		err = -INVALID_PARAMETER;
+		goto raw_bytes_op_failed;
+	}
+
+	if (-1 == (*actual_bytes_count)) {
+		(*actual_bytes_count) = 0;
+		internal_debug("<%s>: %s", __func__, nilfs_message[OP_FAILED]);
+		err = -OP_FAILED;
+		goto raw_bytes_op_failed;
+	} else if ((*actual_bytes_count) != requested_bytes_count) {
+		internal_debug("<%s>: %s",
+			__func__, nilfs_message[DATA_PROCCESSED_PARTIALLY]);
+		internal_debug("<%s>: Requested %d bytes. Proccessed %d bytes.",
+				__func__, requested_bytes_count,
+				(*actual_bytes_count));
+		err = -DATA_PROCCESSED_PARTIALLY;
+		if (0 != feof(opened_device_ptr)) {
+			clearerr(opened_device_ptr);
+			goto raw_bytes_op_failed;
+		} else
+			goto raw_bytes_finished;
+	} else {
+		internal_debug("<%s>: Requested %d bytes proccessed successfully.",
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
+ * NILFS_OK - All requested count of data are proccessed successfully.
+ * %-DEVICE_NOT_OPENED - Device is not opened.
+ * %-DATA_PROCCESSED_PARTIALLY - The requested data are proccessed partially.
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
+ * NAME:  write_raw_bytes (libfsck)
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
+ * NILFS_OK - All requested count of data are proccessed successfully.
+ * %-DEVICE_NOT_OPENED - Device is not opened.
+ * %-DATA_PROCCESSED_PARTIALLY - The requested data are proccessed partially.
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
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
