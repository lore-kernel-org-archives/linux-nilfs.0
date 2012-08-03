From: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH v2 7/7] nilfs-utils: fsck: add functionality of fsck.nilfs2
 skeleton
Date: Fri, 03 Aug 2012 07:59:46 -0600
Message-ID: <dcfacf7166883846903f8af92b95d347@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version; bh=nS40iOxk9w+IMpoDH6BtD/RzWo5C9nsThit8uz9+tSQ=;
	b=qwcPlgpeKP0E1A5ewQUjAGjURqYjpnOTBgouhiNmP/fYb4ad1na5JLCXUJ9HvZprAhjKnhgRqivnUWH/SfibYNiGDnNCaqTy3KvW6wzQgbfxq8wnJdQZLMkzNdX9wWKR;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,

This patch adds functionality of fsck.nilfs2 skeleton that is capable 
to check signature magic and CRC checksum in superblock only.

With the best regards,
Vyacheslav Dubeyko.
--
 From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 7/7] nilfs-utils: fsck: add functionality of 
fsck.nilfs2 skeleton

This patch adds functionality of fsck.nilfs2 skeleton that is capable 
to check signature magic and CRC checksum in superblock only.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
diff --git a/sbin/fsck/Makefile.am b/sbin/fsck/Makefile.am
new file mode 100644
index 0000000..c90e37a
--- /dev/null
+++ b/sbin/fsck/Makefile.am
@@ -0,0 +1,11 @@
+## Makefile.am
+
+AM_CFLAGS = -Wall
+AM_CPPFLAGS = -I$(top_srcdir)/include
+LDADD = $(top_builddir)/lib/libfsck.la 
$(top_builddir)/lib/libmountchk.la \
+	$(top_builddir)/lib/libcrc32.la $(top_builddir)/lib/libnilfs.la
+
+sbin_PROGRAMS = fsck.nilfs2
+
+fsck_nilfs2_SOURCES = fsck_nilfs2.c fsck_nilfs2.h \
+			nilfs_superblock.c nilfs_superblock.h
diff --git a/sbin/fsck/fsck_nilfs2.c b/sbin/fsck/fsck_nilfs2.c
new file mode 100644
index 0000000..7457828
--- /dev/null
+++ b/sbin/fsck/fsck_nilfs2.c
@@ -0,0 +1,385 @@
+/*
+ * fsck_nilfs2.c - NILFS fsck functionality (fsck.nilfs2)
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
+#include "fsck_nilfs2.h"
+#include "fsck_raw_ops.h"
+#include "nilfs_superblock.h"
+
+/*****************************************************************************
+ * GLOBAL VARIABLES
+ 
*****************************************************************************/
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
+/*****************************************************************************
+ * FUNCTIONS DECLARATION
+ 
*****************************************************************************/
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
+ 
*****************************************************************************/
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
+ *                         set verbosity level [silence | info | 
debug]
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
+	int err = FSCK_OK;
+
+	show_fsck_version();
+	parse_params(argc, argv);
+
+	if (-BAD_DEVICE == is_device_exist(device_name)) {
+		ui_error("%s %s %s.", fsck_message[BAD_DEVICE],
+				fsck_message[REQUESTED_DEV], device_name);
+		fsck_usage();
+		return fsck_exit_value;
+	}
+
+	err = is_device_mounted(device_name);
+	if (-RW_MOUNT == err) {
+		fsck_error("%s %s %s.", fsck_message[RW_MOUNT],
+				fsck_message[REQUESTED_DEV], device_name);
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+		goto fsck_exit;
+	} else if (-RO_MOUNT == err) {
+		fsck_warning("%s %s %s.", fsck_message[RO_MOUNT],
+				fsck_message[REQUESTED_DEV], device_name);
+		ui_warning("%s", fsck_message[DONT_WORK_RO_MOUNT]);
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+		goto fsck_exit;
+	}
+
+	err = open_volume(device_name);
+	if (-BAD_DEVICE == err) {
+		fsck_error("%s %s %s.", fsck_message[BAD_DEVICE],
+				fsck_message[REQUESTED_DEV], device_name);
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+		goto fsck_exit;
+	}
+
+	err = get_nilfs_superblocks();
+	if (FSCK_OK != err) {
+		fsck_error("%s %s %s.", fsck_message[CANNOT_GET_SUPERBLOCKS],
+				fsck_message[REQUESTED_DEV], device_name);
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+		goto fsck_close_volume;
+	}
+
+	/* <TODO: process return values more properly.> */
+	err = check_nilfs_superblocks();
+	if (-SB1_OK_SB2_OK == err) {
+		fsck_info("%s %s %s.", fsck_message[SB1_OK_SB2_OK],
+				fsck_message[REQUESTED_DEV], device_name);
+	} else if (-NILFS_NOT_FOUND == err) {
+		ui_warning("%s %s %s.", fsck_message[NILFS_NOT_FOUND],
+				fsck_message[REQUESTED_DEV], device_name);
+		ui_warning("%s", fsck_message[NOT_NILFS_VOLUME]);
+		goto fsck_free_resources;
+	} else if (-CANNOT_DETECT_SB_STATE == err) {
+		fsck_error("%s %s %s.", fsck_message[CANNOT_DETECT_SB_STATE],
+				fsck_message[REQUESTED_DEV], device_name);
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+		goto fsck_free_resources;
+	} else {
+		/* <TODO: process return values more properly.> */
+		ui_warning("%s %s %s.", fsck_message[NILFS_HAS_CORRUPTED_SB],
+				fsck_message[REQUESTED_DEV], device_name);
+	}
+
+	ui_info("%s %s", fsck_message[FSCK_DOES_NOTHING],
+			fsck_message[NOT_IMPLEMENTED]);
+	ui_info(fsck_message[SUCCESS_FAREWELL]);
+
+fsck_free_resources:
+	if (FSCK_OK != free_nilfs_superblocks())
+		fsck_exit_value = RETURN_FSCK_OP_ERROR;
+
+fsck_close_volume:
+	if (FSCK_OK != close_volume()) {
+		fsck_error("%s %s %s.", fsck_message[CANNOT_CLOSE_DEVICE],
+				fsck_message[REQUESTED_DEV], device_name);
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
+ * FUNCTION: Print message informs about current version of the 
utility
+ */
+static void show_fsck_version(void)
+{
+	fprintf(stdout, "%s (%s %s)\n", progname, PACKAGE, PACKAGE_VERSION);
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
+					fsck_message[RO_CHECK_DOES_NOT_WORK],
+					fsck_message[NOT_IMPLEMENTED]);
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
+		fprintf(stderr, "[UI_ERROR]: %s\n", fsck_message[NO_DEVICE]);
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
+ * FUNCTION: Print help message about correct using of utility and 
exit from
+ *           utility
+ */
+static void fsck_usage(void)
+{
+	fprintf(stdout, "Usage: %s [-nV] [-v level] device\n", progname);
+	fprintf(stdout,
+	       "\nEmergency help:\n"
+	       "-n       Check read only, make no changes to the file 
system.\n"
+	       "-v level Set verbosity level [silence | info | debug].\n"
+	       "-V       Print version information only.\n");
+	fsck_exit_value = RETURN_FSCK_USAGE_ERROR;
+	exit(fsck_exit_value);
+} /* fsck_usage() */
+
+/*****************************************************************************
+ * NAME:  is_device_exist (fsck.nilfs2)
+ *
+ * FUNCTION:  Check that device name requested by user is a real 
partition.
+ *
+ * PARAMETERS:
+ * @check_device_name: Name of the device for check
+ *
+ * RETURNS:
+ * FSCK_OK - requested device can be opened in RO mode.
+ * %-BAD_DEVICE - cannot open device.
+ */
+static int is_device_exist(const char *check_device_name)
+{
+	FILE *file_ptr = NULL;
+
+	fsck_debug("<%s>: check device name.", __func__);
+
+	if (!check_device_name) {
+		fsck_debug("<%s>: NULL pointer on device name.", __func__);
+		return -BAD_DEVICE;
+	}
+
+	file_ptr = fopen(check_device_name, "r");
+	if (file_ptr)
+		fclose(file_ptr);
+	else {
+		fsck_debug("<%s>: %s requested device name is not valid.",
+				__func__, check_device_name);
+		return -BAD_DEVICE;
+	}
+
+	fsck_debug("<%s>: %s requested device is opened successfully.",
+				__func__, check_device_name);
+	return FSCK_OK;
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
+	fsck_debug("<%s>: check mount state.", __func__);
+
+	if (!check_device_name) {
+		fsck_debug("<%s>: NULL pointer on device name.", __func__);
+		return -BAD_DEVICE;
+	}
+
+	/* -1 means that device is mounted RW
+	   -2 means that device is mounted RO */
+	mount_type = check_mount(check_device_name);
+	if (-1 == mount_type) {
+		fsck_debug("<%s>: %s device is RW mounted.",
+				__func__, check_device_name);
+		return -RW_MOUNT;
+	} else if (-2 == mount_type) {
+		fsck_debug("<%s>: %s device is RO mounted.",
+				__func__, check_device_name);
+		return -RO_MOUNT;
+	}
+
+	fsck_debug("<%s>: %s device is *not* mounted.",
+				__func__, check_device_name);
+	return -NOT_MOUNTED;
+} /* is_device_mounted */
diff --git a/sbin/fsck/fsck_nilfs2.h b/sbin/fsck/fsck_nilfs2.h
new file mode 100644
index 0000000..b0c6278
--- /dev/null
+++ b/sbin/fsck/fsck_nilfs2.h
@@ -0,0 +1,34 @@
+/*
+ * fsck_nilfs2.h - NILFS fsck declarations
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
+#ifndef FSCK_NILFS2_H
+#define FSCK_NILFS2_H
+
+#include "nilfs.h"
+#include "fsck_messages.h"
+
+/* libmountchk function */
+extern int check_mount(const char *device);
+
+#endif /* FSCK_NILFS2_H */
diff --git a/sbin/fsck/nilfs_superblock.c 
b/sbin/fsck/nilfs_superblock.c
new file mode 100644
index 0000000..3e969d6
--- /dev/null
+++ b/sbin/fsck/nilfs_superblock.c
@@ -0,0 +1,526 @@
+/*
+ * nilfs_superblock.c - NILFS superblocks checking, processing
+ *                      and recovering operations implementation
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
+#include "fsck_nilfs2.h"
+#include "fsck_raw_ops.h"
+
+#include "nilfs_superblock.h"
+
+/*****************************************************************************
+ * GLOBAL VARIABLES
+ 
*****************************************************************************/
+
+/* Array of pointers on NILFS volume's superblocks */
+struct nilfs_super_block *superblocks[SUPERBLOCK_TYPES_NUMBER] = {0};
+
+/*****************************************************************************
+ * FUNCTIONS DECLARATION
+ 
*****************************************************************************/
+
+/* Allocate memory for superblock */
+static int allocate_superblock(int sb_type);
+
+/* Free memory allocated for superblock */
+static int free_superblock(int sb_type);
+
+/* Read superblock from disk */
+static int read_superblock(int sb_type);
+
+/* Check that superblock is valid */
+static int is_nilfs_superblock_valid(struct nilfs_super_block 
*sb_ptr);
+
+/* Compare two superblocks */
+/*static int is_nilfs_superblocks_identical(
+				const struct nilfs_super_block *left_sb_ptr,
+				const struct nilfs_super_block *right_sb_ptr);*/
+
+/*****************************************************************************
+ * IMPLEMENTATION SECTION
+ 
*****************************************************************************/
+
+/*****************************************************************************
+ * NAME:  get_nilfs_superblocks (fsck.nilfs2)
+ *
+ * FUNCTION:  Allocate memory and read primary and secondary
+ *            superblocks from disk.
+ *
+ * RETURNS:
+ * FSCK_OK - primary and secondary superblocks are read successfully.
+ * %-CANNOT_ALLOCATE - cannot allocate memory for superblock.
+ * %-CANNOT_READ_SUPERBLOCK - cannot read superblock from disk.
+ */
+int get_nilfs_superblocks(void)
+{
+	int err = FSCK_OK;
+
+	fsck_debug("<%s>: try to read superblocks from disk.", __func__);
+
+	err = allocate_superblock(PRIMARY_SUPERBLOCK);
+	if (err) {
+		err = CANNOT_ALLOCATE;
+		goto get_nilfs_superblocks_failed;
+	}
+
+	err = allocate_superblock(SECONDARY_SUPERBLOCK);
+	if (err) {
+		err = CANNOT_ALLOCATE;
+		goto free_primary_superblock;
+	}
+
+	err = read_superblock(PRIMARY_SUPERBLOCK);
+	if (err) {
+		err = CANNOT_READ_SUPERBLOCK;
+		goto free_secondary_superblock;
+	}
+
+	err = read_superblock(SECONDARY_SUPERBLOCK);
+	if (err) {
+		err = CANNOT_READ_SUPERBLOCK;
+		goto free_secondary_superblock;
+	}
+
+	fsck_debug("<%s>: nilfs superblocks are read successfully.", 
__func__);
+	return FSCK_OK;
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
+ * %-ONLY_SB1_OK_FOUND - Primary valid superblock was found but 
secondary *not*.
+ * %-ONLY_SB1_CORRUPTED_FOUND - Only corrupted primary superblock was 
found.
+ * %-ONLY_SB2_OK_FOUND - Secondary valid superblock was found but 
primary *not*.
+ * %-ONLY_SB2_CORRUPTED_FOUND - Only corrupted secondary superblock 
was found.
+ * %-SB1_SB2_CORRUPTED - Primary and secondary superblocks are 
corrupted.
+ * %-SB1_OK_SB2_CORRUPTED - Primary superblock is valid, secondary is 
corrupted.
+ * %-SB1_CORRUPTED_SB2_OK - Secondary superblock is valid, primary is 
corrupted.
+ * %-CANNOT_DETECT_SB_STATE - Cannot detect state of superblock. 
Internal error.
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
+
+	int return_states[ALL_POSSIBLE_SB_STATES] = { -1 };
+	return_states[SB1_VALID | SB2_VALID] = SB1_OK_SB2_OK;
+	return_states[SB1_CORRUPTED | SB2_VALID] = SB1_CORRUPTED_SB2_OK;
+	return_states[SB1_NOT_FOUND | SB2_VALID] = ONLY_SB2_OK_FOUND;
+	return_states[SB1_VALID | SB2_CORRUPTED] = SB1_OK_SB2_CORRUPTED;
+	return_states[SB1_CORRUPTED | SB2_CORRUPTED] = SB1_SB2_CORRUPTED;
+	return_states[SB1_NOT_FOUND | SB2_CORRUPTED] = 
ONLY_SB2_CORRUPTED_FOUND;
+	return_states[SB1_VALID | SB2_NOT_FOUND] = ONLY_SB1_OK_FOUND;
+	return_states[SB1_CORRUPTED | SB2_NOT_FOUND] = 
ONLY_SB1_CORRUPTED_FOUND;
+	return_states[SB1_NOT_FOUND | SB2_NOT_FOUND] = NILFS_NOT_FOUND;
+
+	fsck_debug("<%s>: try to check NILFS superblocks.", __func__);
+
+	err = is_nilfs_signature_ok(superblocks[PRIMARY_SUPERBLOCK]);
+	if (FSCK_OK == err) {
+		fsck_debug("<%s>: primary superblock has valid signature.",
+				__func__);
+
+		err = is_nilfs_superblock_valid(
+					superblocks[PRIMARY_SUPERBLOCK]);
+		if (FSCK_OK != err) {
+			fsck_debug("<%s>: primary superblock is corrupted.",
+					__func__);
+			sb_states |= SB1_CORRUPTED;
+		} else {
+			fsck_debug("<%s>: primary superblock is valid.",
+					__func__);
+			sb_states |= SB1_VALID;
+		}
+
+		fsck_debug("<%s>: sb_states has %d value.",
+				__func__, sb_states);
+	} else if (-INVALID_NILFS_SIGNATURE == err) {
+		sb_states |= SB1_NOT_FOUND;
+		fsck_debug("<%s>: primary superblock is not found.", __func__);
+		fsck_debug("<%s>: sb_states has %d value.",
+				__func__, sb_states);
+	} else
+		goto check_sb_internal_error;
+
+	err = is_nilfs_signature_ok(superblocks[SECONDARY_SUPERBLOCK]);
+	if (FSCK_OK == err) {
+		fsck_debug("<%s>: secondary superblock has valid signature.",
+				__func__);
+
+		err = is_nilfs_superblock_valid(
+					superblocks[SECONDARY_SUPERBLOCK]);
+		if (FSCK_OK != err) {
+			fsck_debug("<%s>: secondary superblock is corrupted.",
+					__func__);
+			sb_states |= SB2_CORRUPTED;
+		} else {
+			fsck_debug("<%s>: secondary superblock is valid.",
+					__func__);
+			sb_states |= SB2_VALID;
+		}
+
+		fsck_debug("<%s>: sb_states has %d value.",
+				__func__, sb_states);
+	} else if (-INVALID_NILFS_SIGNATURE == err) {
+		sb_states |= SB2_NOT_FOUND;
+		fsck_debug("<%s>: secondary superblock is not found.",
+				__func__);
+		fsck_debug("<%s>: sb_states has %d value.",
+				__func__, sb_states);
+	} else
+		goto check_sb_internal_error;
+
+	fsck_debug("<%s>: return_states has %d value.",
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
+	fs_info("%s", fsck_message[return_states[sb_states]]);
+	return -return_states[sb_states];
+
+check_sb_fs_fatal_error:
+	fs_fatal_error("%s", fsck_message[return_states[sb_states]]);
+	return -return_states[sb_states];
+
+check_sb_fs_critical_error:
+	fs_critical_error("%s", fsck_message[return_states[sb_states]]);
+	return -return_states[sb_states];
+
+check_sb_internal_error:
+	fsck_error("%s", fsck_message[CANNOT_DETECT_SB_STATE]);
+	return -CANNOT_DETECT_SB_STATE;
+} /* check_nilfs_superblocks() */
+
+/*****************************************************************************
+ * NAME:  free_nilfs_superblocks (fsck.nilfs2)
+ *
+ * FUNCTION:  Free memory allocated for superblocks.
+ *
+ * RETURNS:
+ * FSCK_OK - primary and secondary superblocks are freed successfully.
+ * %-CANNOT_FREE - cannot free memory for superblocks.
+ */
+int free_nilfs_superblocks(void)
+{
+	int err_sb1 = FSCK_OK;
+	int err_sb2 = FSCK_OK;
+
+	fsck_debug("<%s>: try to free memory of superblocks.", __func__);
+
+	err_sb1 = free_superblock(PRIMARY_SUPERBLOCK);
+	err_sb2 = free_superblock(SECONDARY_SUPERBLOCK);
+
+	if (FSCK_OK != err_sb1 || FSCK_OK != err_sb2) {
+		fsck_debug("<%s>: some error occurs during memory freeing.",
+				__func__);
+		return -CANNOT_FREE;
+	}
+
+	fsck_debug("<%s>: superblocks memory has freed successfully.",
+			__func__);
+	return FSCK_OK;
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
+ * FSCK_OK - memory for superblock is allocated successfully.
+ * %-INVALID_PARAMETER - inavalid input parameter.
+ * %-CANNOT_ALLOCATE - cannot allocate memory for superblock.
+ */
+static int allocate_superblock(int sb_type)
+{
+	struct nilfs_super_block *sb_ptr = NULL;
+
+	fsck_debug("<%s>: try to allocate memory for %d superblock type.",
+			__func__, sb_type);
+
+	if (sb_type >= SUPERBLOCK_TYPES_NUMBER) {
+		fsck_error("%s", fsck_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	if (superblocks[sb_type]) {
+		fsck_error("%s", fsck_message[CANNOT_ALLOCATE]);
+		fsck_debug("<%s>: superblock of %d type has allocated yet",
+				__func__, sb_type);
+		return -CANNOT_ALLOCATE;
+	}
+
+	sb_ptr = calloc(sizeof(struct nilfs_super_block), 1);
+	if (NULL == sb_ptr) {
+		fsck_perror("%s", fsck_message[CANNOT_ALLOCATE]);
+		return -CANNOT_ALLOCATE;
+	}
+
+	superblocks[sb_type] = sb_ptr;
+
+	fsck_debug("<%s>: memory for %d superblock type has allocated.",
+			__func__, sb_type);
+
+	return FSCK_OK;
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
+ * FSCK_OK - memory for superblock is freed successfully.
+ * %-INVALID_PARAMETER - inavalid input parameter.
+ * %-CANNOT_FREE - cannot free memory for superblock.
+ */
+static int free_superblock(int sb_type)
+{
+	fsck_debug("<%s>: try to free memory for %d superblock type.",
+			__func__, sb_type);
+
+	if (sb_type >= SUPERBLOCK_TYPES_NUMBER) {
+		fsck_error("%s", fsck_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	if (NULL == superblocks[sb_type]) {
+		fsck_warning("%s", fsck_message[CANNOT_FREE]);
+		fsck_debug("<%s>: superblock of %d type *not* allocated yet",
+				__func__, sb_type);
+		return -CANNOT_FREE;
+	}
+
+	free(superblocks[sb_type]);
+	superblocks[sb_type] = NULL;
+
+	fsck_debug("<%s>: superblock of %d type has freed", __func__, 
sb_type);
+
+	return FSCK_OK;
+} /* free_superblock() */
+
+/*****************************************************************************
+ * NAME:  read_superblock (fsck.nilfs2)
+ *
+ * FUNCTION:  Read superblock from disk.
+ *
+ * PARAMETERS:
+ * @sb_type: Type of superblock.
+ *
+ * RETURNS:
+ * FSCK_OK - superblock has read successfully.
+ * %-INVALID_PARAMETER - inavalid input parameter.
+ * %-CANNOT_READ_SUPERBLOCK - cannot read superblock from disk.
+ */
+static int read_superblock(int sb_type)
+{
+	int err = FSCK_OK;
+	int devfd = -1;
+
+	fsck_debug("<%s>: try to read superblock of %d type.",
+			__func__, sb_type);
+
+	if (NULL == superblocks[sb_type]) {
+		fsck_debug("<%s>: superblock of %d type *not* allocated yet",
+				__func__, sb_type);
+		goto cannot_read_superblock;
+	}
+
+	devfd = device_file_descriptor();
+	if (-1 == devfd) {
+		fsck_debug("<%s>: Device file descriptor: %d bytes.",
+				__func__, devfd);
+		goto cannot_read_superblock;
+	}
+
+	switch (sb_type) {
+	case PRIMARY_SUPERBLOCK:
+		err = nilfs_sb_read_unchecked(devfd,
+						superblocks[sb_type], NULL);
+		if (err)
+			goto cannot_read_superblock;
+		break;
+	case SECONDARY_SUPERBLOCK:
+		err = nilfs_sb_read_unchecked(devfd,
+						NULL, superblocks[sb_type]);
+		if (err)
+			goto cannot_read_superblock;
+		break;
+	default:
+		fsck_error("%s", fsck_message[INVALID_PARAMETER]);
+		return -INVALID_PARAMETER;
+	}
+
+	if (FSCK_OK != err)
+		goto cannot_read_superblock;
+
+	fsck_debug("<%s>: superblock is read successfully", __func__);
+	return FSCK_OK;
+
+cannot_read_superblock:
+	fsck_error("%s", fsck_message[CANNOT_READ_SUPERBLOCK]);
+	return -CANNOT_READ_SUPERBLOCK;
+} /* read_superblock() */
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
+ * FSCK_OK - superblock contains valid NILFS signature.
+ * %-INVALID_PARAMETER - inavalid input parameter.
+ * %-INVALID_NILFS_SIGNATURE - superblock signature is invalid.
+ */
+int is_nilfs_signature_ok(const struct nilfs_super_block *sb_ptr)
+{
+	fsck_debug("<%s>: check signature of superblock.", __func__);
+
+	if (NULL == sb_ptr) {
+		fsck_error("%s", fsck_message[INVALID_PARAMETER]);
+		fsck_debug("<%s>: pointer on superblock is NULL.", __func__);
+		return -INVALID_PARAMETER;
+	}
+
+	if (le16_to_cpu(sb_ptr->s_magic) != NILFS_SUPER_MAGIC) {
+		fs_warning("%s", fsck_message[INVALID_NILFS_SIGNATURE]);
+		return -INVALID_NILFS_SIGNATURE;
+	}
+
+	fsck_debug("<%s>: NILFS signature is ok.", __func__);
+	return FSCK_OK;
+} /* is_nilfs_signature_ok() */
+
+/*****************************************************************************
+ * NAME:  is_nilfs_superblock_valid (fsck.nilfs2)
+ *
+ * FUNCTION:  Check that superblock is valid.
+ *
+ * PARAMETERS:
+ * @sb_ptr: Pointer on superblock.
+ *
+ * RETURNS:
+ * FSCK_OK - superblock is valid.
+ * %-CANNOT_CHECK_SB - cannot check superblock because of internal 
error.
+ * %-INVALID_SB - superblock is in corrupted state.
+ * %-UNSUPPORTED_SB_REV - unsupported revision of NILFS superblock.
+ */
+static int is_nilfs_superblock_valid(struct nilfs_super_block *sb_ptr)
+{
+	int err = FSCK_OK;
+	int err_severity = FS_INFO;
+
+	fsck_debug("<%s>: check superblock validity.", __func__);
+
+	if (NULL == sb_ptr) {
+		fsck_error("%s", fsck_message[CANNOT_CHECK_SB]);
+		fsck_debug("<%s>: pointer on superblock %#x.",
+				__func__, sb_ptr);
+		return -CANNOT_CHECK_SB;
+	}
+
+	if (!nilfs_sb_is_valid(sb_ptr, NILFS_TRUE, &err, &err_severity)) {
+		if (err < FSCK_OK || err >= MAX_MESSAGE_CODE) {
+			fsck_error("%s", fsck_message[CANNOT_CHECK_SB]);
+			fsck_debug("<%s>: error code %d.",
+					__func__, err);
+			return -CANNOT_CHECK_SB;
+		}
+
+		switch (err_severity) {
+		case FS_INFO:
+			fs_info("%s", fsck_message[err]);
+			break;
+		case FS_WARNING:
+			fs_warning("%s", fsck_message[err]);
+			break;
+		case FS_FATAL_ERROR:
+			fs_fatal_error("%s", fsck_message[err]);
+			break;
+		case FS_CRITICAL_ERROR:
+			fs_critical_error("%s", fsck_message[err]);
+			break;
+		case FS_MINOR_ERROR:
+			fs_minor_error("%s", fsck_message[err]);
+			break;
+		case FS_LOOKS_LIKE_ERROR:
+			fs_looks_like_error("%s", fsck_message[err]);
+			break;
+		default:
+			/* Keep silence */
+			break;
+		}
+
+		if (err == UNSUPPORTED_SB_REV)
+			return -UNSUPPORTED_SB_REV;
+		else
+			return -err;
+	}
+
+	fsck_debug("<%s>: superblock is valid.", __func__);
+
+	return FSCK_OK;
+} /* is_nilfs_superblock_valid() */
diff --git a/sbin/fsck/nilfs_superblock.h 
b/sbin/fsck/nilfs_superblock.h
new file mode 100644
index 0000000..e78301e
--- /dev/null
+++ b/sbin/fsck/nilfs_superblock.h
@@ -0,0 +1,48 @@
+/*
+ * nilfs_superblock.h - Declarations of operations for NILFS 
superblocks
+ *                      checking, processing and recovering
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
+#ifndef NILFS_SUPERBLOCK_H
+#define NILFS_SUPERBLOCK_H
+
+/* Type of NILFS superblocks */
+enum superblock_type {
+	PRIMARY_SUPERBLOCK,
+	SECONDARY_SUPERBLOCK,
+	SUPERBLOCK_TYPES_NUMBER
+}; /* enum superblock_type */
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

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
