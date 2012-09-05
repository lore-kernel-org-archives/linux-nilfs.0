From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 10/11] nilfs-utils: fsck: add functionality of fsck.nilfs2 skeleton
Date: Wed, 5 Sep 2012 23:15:35 +0400
Message-ID: <6FB56B08-40E1-46CA-806B-A1FB95D648D2@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=Lm5AEg2DUrpfbEgFsjsqZFzJjdGiAjXFWNeL64J0vEY=;
	b=iLLfgowFRA2eD/8Ax4GVMtFVShgU+5RQfkTi+AAeOeuB77PUBsH05gIyFEQQVRSXC1Uqmfbp+L9vLT24sNpcUlt2VH0U9DIDg4fzDy9VRwtF1ODIvFGSGaLERkAMurpQ;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds functionality of fsck.nilfs2 skeleton that is capable to check superblock correctness only.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 10/11] nilfs-utils: fsck: add functionality of fsck.nilfs2 skeleton

This patch adds functionality of fsck.nilfs2 skeleton that is capable to check superblock correctness only.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 sbin/fsck/fsck_common.h |   43 +++++
 sbin/fsck/fsck_nilfs2.c |  429 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 472 insertions(+), 0 deletions(-)
 create mode 100644 sbin/fsck/fsck_common.h
 create mode 100644 sbin/fsck/fsck_nilfs2.c

diff --git a/sbin/fsck/fsck_common.h b/sbin/fsck/fsck_common.h
new file mode 100644
index 0000000..3d2d423
--- /dev/null
+++ b/sbin/fsck/fsck_common.h
@@ -0,0 +1,43 @@
+/*
+ * fsck_common.h - NILFS fsck application-related declarations
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
+#ifndef FSCK_COMMON_H
+#define FSCK_COMMON_H
+
+#include "nilfs.h"
+#include "nilfs_messages.h"
+#include "fsck_nilfs2.h"
+
+/* libmountchk function */
+extern int check_mount(const char *device);
+
+/* Current mode of fsck working */
+extern int fsck_work_mode;
+
+/* Defines what should check and keeps errors */
+extern struct fsck_check detected_err_db;
+
+#define FSCK_VERSION "v.0.03-under-development"
+
+#endif /* FSCK_COMMON_H */
diff --git a/sbin/fsck/fsck_nilfs2.c b/sbin/fsck/fsck_nilfs2.c
new file mode 100644
index 0000000..3dbcc20
--- /dev/null
+++ b/sbin/fsck/fsck_nilfs2.c
@@ -0,0 +1,429 @@
+/*
+ * fsck_nilfs2.c - NILFS fsck functionality (fsck.nilfs2)
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
+#include <assert.h>
+
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif	/* HAVE_UNISTD_H */
+
+#if HAVE_STRINGS_H
+#include <strings.h>
+#endif	/* HAVE_STRINGS_H */
+
+#include <string.h>
+#include <stdarg.h>
+
+#include "fsck_common.h"
+#include "fsck_raw_ops.h"
+#include "nilfs_superblock.h"
+
+/*****************************************************************************
+ * TODO SECTION
+ *****************************************************************************/
+
+/* 1. s_last_cno:
+ * It needs to check last checkpoint number during checkpoints checking
+ *
+ * 2. s_last_pseg:
+ * It needs to check disk block address of partial segment during
+ * segments checking
+ *
+ * 3. s_last_seq:
+ * It needs to check sequential number of last written segment during
+ * segments checking
+ *
+ * 4. s_free_blocks_count:
+ * It needs to check free blocks count after construction of volume's
+ * blocks bitmap
+ *
+ * 5. s_mnt_count
+ * It needs to save corrected value after sucessful check OR recovering
+ * of a volume in the case of RW mode and when s_mnt_count greater or
+ * equal to s_max_mnt_count
+ *
+ * 6. s_state
+ * It needs to dedicate special logic for the case not clean umount
+ * (NILFS_VALID_FS) and detection of errors by driver (NILFS_ERROR_FS)
+ *
+ * 7. s_lastcheck
+ * It needs to change timestamp of last check in the case of RW mode
+ * and ending of check without internal errors
+ */
+
+/*****************************************************************************
+ * GLOBAL VARIABLES
+ *****************************************************************************/
+
+/* Name of fsck utility */
+const char *progname = "fsck.nilfs2";
+
+/* Current exit value */
+int fsck_exit_value = RETURN_FSCK_OK;
+
+/* Name of raw device keeps volume for check */
+char *device_name;
+
+/* Check results:
+   A. It keeps check mask, firstly.
+   B. It keeps detected errors' flags after check. */
+struct fsck_check detected_err_db;
+
+/* Current mode of fsck working */
+int fsck_work_mode = FSCK_RO_MODE;
+
+/*****************************************************************************
+ * FUNCTIONS DECLARATION
+ *****************************************************************************/
+
+/* Print help message about correct using of utility and exit */
+static void fsck_usage(void);
+
+/* Print message informs about current version of the utility */
+static void show_fsck_version(void);
+
+/* Parse fsck's input parameters */
+static void parse_params(int argc, char **argv);
+
+/* Check that device name requested by user is a real partition */
+static int is_device_exist(const char *check_device_name);
+
+/* Check that device mounted or not */
+static int is_device_mounted(const char *check_device_name);
+
+/*****************************************************************************
+ * IMPLEMENTATION SECTION
+ *****************************************************************************/
+
+/*****************************************************************************
+ * NAME: main (fsck.nilfs2)
+ *
+ * FUNCTION: Entry point for nilfs2 check/repair utility
+ *
+ * INTERFACE:
+ *            fsck.nilfs2 <device name>
+ *
+ *                         [ -n ]
+ *                         read only check
+ *                         report but do not repair problems
+ *
+ *                         [-v level]
+ *                         set verbosity level [silence | info | debug]
+ *
+ *                         [ -V ]
+ *                         version information
+ *                         print version information and exit
+ *
+ * RETURNS:
+ *      success:                   RETURN_FSCK_OK (0)
+ *      errors corrected:          RETURN_FSCK_CORRECTED (1)
+ *      errors uncorrected:        RETURN_FSCK_ERRORS_UNCORRECTED (4)
+ *      operational error:         RETURN_FSCK_OP_ERROR (8)
+ *      usage error:               RETURN_FSCK_USAGE_ERROR (16)
+ */
+int main(int argc, char **argv)
+{
+	int err = NILFS_OK;
+
+	show_fsck_version();
+	parse_params(argc, argv);
+
+	if (-BAD_DEVICE == is_device_exist(device_name)) {
+		ui_error("%s %s %s.", nilfs_message[BAD_DEVICE],
+				nilfs_message[REQUESTED_DEV], device_name);
+		fsck_usage();
+		return fsck_exit_value;
+	}
+
+	err = is_device_mounted(device_name);
+	if (-RW_MOUNT == err) {
+		internal_error("%s %s %s.", nilfs_message[RW_MOUNT],
+				nilfs_message[REQUESTED_DEV], device_name);
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+		goto fsck_exit;
+	} else if (-RO_MOUNT == err) {
+		internal_warning("%s %s %s.", nilfs_message[RO_MOUNT],
+				nilfs_message[REQUESTED_DEV], device_name);
+		ui_warning("%s", nilfs_message[DONT_WORK_RO_MOUNT]);
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+		goto fsck_exit;
+	}
+
+	err = open_volume(device_name);
+	if (-BAD_DEVICE == err) {
+		internal_error("%s %s %s.", nilfs_message[BAD_DEVICE],
+				nilfs_message[REQUESTED_DEV], device_name);
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+		goto fsck_exit;
+	}
+
+	err = get_nilfs_superblocks();
+	if (NILFS_OK != err) {
+		internal_error("%s %s %s.",
+				nilfs_message[CANNOT_GET_SUPERBLOCKS],
+				nilfs_message[REQUESTED_DEV], device_name);
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+		goto fsck_close_volume;
+	}
+
+	/* <TODO: process return values more properly.> */
+	err = check_nilfs_superblocks();
+	if (-SB1_OK_SB2_OK == err) {
+		internal_info("%s %s %s.", nilfs_message[SB1_OK_SB2_OK],
+				nilfs_message[REQUESTED_DEV], device_name);
+	} else if (-NILFS_NOT_FOUND == err) {
+		ui_warning("%s %s %s.", nilfs_message[NILFS_NOT_FOUND],
+				nilfs_message[REQUESTED_DEV], device_name);
+		ui_warning("%s", nilfs_message[NOT_NILFS_VOLUME]);
+		goto fsck_free_resources;
+	} else if (-CANNOT_DETECT_SB_STATE == err) {
+		internal_error("%s %s %s.",
+				nilfs_message[CANNOT_DETECT_SB_STATE],
+				nilfs_message[REQUESTED_DEV], device_name);
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+		goto fsck_free_resources;
+	} else {
+		/* <TODO: process return values more properly.> */
+		ui_warning("%s %s %s.", nilfs_message[NILFS_HAS_CORRUPTED_SB],
+				nilfs_message[REQUESTED_DEV], device_name);
+	}
+
+	ui_info("%s %s", nilfs_message[FSCK_DOES_NOTHING],
+			nilfs_message[NOT_IMPLEMENTED]);
+	ui_info(nilfs_message[SUCCESS_FAREWELL]);
+
+fsck_free_resources:
+	if (NILFS_OK != free_nilfs_superblocks())
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+
+fsck_close_volume:
+	if (NILFS_OK != close_volume()) {
+		internal_error("%s %s %s.", nilfs_message[CANNOT_CLOSE_DEVICE],
+				nilfs_message[REQUESTED_DEV], device_name);
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+	}
+
+fsck_exit:
+	return fsck_exit_value;
+} /* main() */
+
+/*****************************************************************************
+ * NAME: show_fsck_version (fsck.nilfs2)
+ *
+ * FUNCTION: Print message informs about current version of the utility
+ */
+static void show_fsck_version(void)
+{
+	fprintf(stdout, "%s %s (%s %s)\n",
+			progname, FSCK_VERSION, PACKAGE, PACKAGE_VERSION);
+} /* show_fsck_version() */
+
+/*****************************************************************************
+ * NAME: parse_params (fsck.nilfs2)
+ *
+ * FUNCTION:  Parse fsck's input parameters.  If any unrecognized
+ *            parameters are detected, or if any required parameter is
+ *            omitted, issue a message and exit.
+ *
+ * RETURNS:
+ * If there is an error in parse_params(), it calls fsck_usage()
+ * to remind the user of command format and proper options.
+ */
+void parse_params(int argc, char **argv)
+{
+	int c;
+	char *short_opts = "nv:V";
+	int len = 0;
+
+	/* Names of verbosity levels that
+	   can be requested by user by input option */
+	const char *names[] = {
+				[KEEP_SILENCE] = "silence",
+				[BE_VERBOSE] = "info",
+				[DEBUG_SPAM] = "debug" };
+
+	while ((c = getopt(argc, argv, short_opts)) != EOF) {
+		switch (c) {
+		case 'n':
+		/*************************************
+		 * read only check                   *
+		 * report but do not repair problems *
+		 *************************************/
+			fprintf(stdout, "%s %s\n",
+					nilfs_message[RO_CHECK_DOES_NOT_WORK],
+					nilfs_message[NOT_IMPLEMENTED]);
+			fsck_exit_value = RETURN_FSCK_OP_ERROR;
+			exit(fsck_exit_value);
+			break;
+
+		case 'v':
+		/**************************
+		 * Set verbosity level    *
+		 **************************/
+			for (int index = KEEP_SILENCE;
+					index <= (DEBUG_SPAM + 1);
+								index++) {
+				if (index == (DEBUG_SPAM + 1)) {
+					fsck_usage();
+					return;
+				}
+				len = strlen(names[index]);
+				if (0 == strncmp(names[index], optarg, len)) {
+					set_verbosity_level(index);
+					break;
+				}
+			}
+			break;
+
+		case 'V':
+		/**********************
+		 * print version only *
+		 **********************/
+			exit(RETURN_FSCK_OK);
+			break;
+
+		default:
+			fsck_usage();
+		}
+	}
+
+	/* TODO: check params existence in together */
+
+	if (optind != argc - 1) {
+		fprintf(stderr, "[UI_ERROR]: %s\n", nilfs_message[NO_DEVICE]);
+		fsck_usage();
+	}
+
+	device_name = argv[optind];
+
+	return;
+} /* parse_params() */
+
+/*****************************************************************************
+ * NAME: fsck_usage (fsck.nilfs2)
+ *
+ * FUNCTION: Print help message about correct using of utility and exit from
+ *           utility
+ */
+static void fsck_usage(void)
+{
+	fprintf(stdout, "Usage: %s [-nV] [-v level] device\n", progname);
+	fprintf(stdout,
+	       "\nEmergency help:\n"
+	       "-n       Check read only, make no changes to the file system.\n"
+	       "-v level Set verbosity level [silence | info | debug].\n"
+	       "-V       Print version information only.\n");
+	fsck_exit_value = RETURN_FSCK_USAGE_ERROR;
+	exit(fsck_exit_value);
+} /* fsck_usage() */
+
+/*****************************************************************************
+ * NAME:  is_device_exist (fsck.nilfs2)
+ *
+ * FUNCTION:  Check that device name requested by user is a real partition.
+ *
+ * PARAMETERS:
+ * @check_device_name: Name of the device for check
+ *
+ * RETURNS:
+ * NILFS_OK - requested device can be opened in RO mode.
+ * %-BAD_DEVICE - cannot open device.
+ */
+static int is_device_exist(const char *check_device_name)
+{
+	FILE *file_ptr = NULL;
+
+	internal_debug("<%s>: check device name.", __func__);
+
+	if (!check_device_name) {
+		internal_debug("<%s>: NULL pointer on device name.", __func__);
+		return -BAD_DEVICE;
+	}
+
+	file_ptr = fopen(check_device_name, "r");
+	if (file_ptr)
+		fclose(file_ptr);
+	else {
+		internal_debug("<%s>: %s requested device name is not valid.",
+				__func__, check_device_name);
+		return -BAD_DEVICE;
+	}
+
+	internal_debug("<%s>: %s requested device is opened successfully.",
+				__func__, check_device_name);
+	return NILFS_OK;
+} /* is_device_exists() */
+
+/*****************************************************************************
+ * NAME:  is_device_mounted (fsck.nilfs2)
+ *
+ * FUNCTION:  Check that device mounted or not.
+ *
+ * PARAMETERS:
+ * @check_device_name: Name of the device for check
+ *
+ * RETURNS:
+ * %-NOT_MOUNTED - Device is not mounted.
+ * %-RO_MOUNT - Device is mounted in RO mode.
+ * %-RW_MOUNT - Device is mounted in RW mode.
+ * %-BAD_DEVICE - Some error in function logic has occured.
+ */
+static int is_device_mounted(const char *check_device_name)
+{
+	int mount_type = 0;
+
+	internal_debug("<%s>: check mount state.", __func__);
+
+	if (!check_device_name) {
+		internal_debug("<%s>: NULL pointer on device name.", __func__);
+		return -BAD_DEVICE;
+	}
+
+	/* -1 means that device is mounted RW
+	   -2 means that device is mounted RO */
+	mount_type = check_mount(check_device_name);
+	if (-1 == mount_type) {
+		internal_debug("<%s>: %s device is RW mounted.",
+				__func__, check_device_name);
+		return -RW_MOUNT;
+	} else if (-2 == mount_type) {
+		internal_debug("<%s>: %s device is RO mounted.",
+				__func__, check_device_name);
+		return -RO_MOUNT;
+	}
+
+	internal_debug("<%s>: %s device is *not* mounted.",
+				__func__, check_device_name);
+	return -NOT_MOUNTED;
+} /* is_device_mounted */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
