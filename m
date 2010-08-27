From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 2/2] nilfs-utils: add new command nilfs-tune
Date: Fri, 27 Aug 2010 19:17:10 +0900
Message-ID: <1282904230-29618-3-git-send-email-jir@unicus.jp>
References: <1282904230-29618-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282904230-29618-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This patch add new commands named "nilfs-tune".
nilfs-tune modifys tunable NILFS parameters.
Currently supported parameters are:
- volume label
- UUID
- commit interval
- segment contsruction block max

It also displays NILFS super block information if specified.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 configure.ac                 |    7 +-
 man/Makefile.am              |    2 +-
 man/chcp.8                   |    3 +-
 man/lscp.1                   |    3 +-
 man/mkcp.8                   |    3 +-
 man/nilfs-tune.8             |   54 +++++
 man/nilfs.8                  |    1 +
 man/rmcp.8                   |    3 +-
 sbin/Makefile.am             |    2 +-
 sbin/nilfs-tune/Makefile.am  |    9 +
 sbin/nilfs-tune/nilfs-tune.c |  500 ++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 578 insertions(+), 9 deletions(-)
 create mode 100644 man/nilfs-tune.8
 create mode 100644 sbin/nilfs-tune/Makefile.am
 create mode 100644 sbin/nilfs-tune/nilfs-tune.c

diff --git a/configure.ac b/configure.ac
index 74dbae3..af75142 100644
--- a/configure.ac
+++ b/configure.ac
@@ -37,7 +37,7 @@ AC_HEADER_STDC
 AC_HEADER_SYS_WAIT
 AC_CHECK_HEADERS([fcntl.h libintl.h limits.h locale.h mntent.h paths.h \
 		  stdlib.h string.h strings.h sys/ioctl.h sys/mount.h \
-		  sys/time.h syslog.h unistd.h linux/types.h])
+		  sys/time.h syslog.h unistd.h linux/types.h grp.h pwd.h])
 
 # Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
@@ -68,7 +68,7 @@ AC_FUNC_STRFTIME
 AC_FUNC_VPRINTF
 AC_CHECK_FUNCS([alarm atexit ftruncate getcwd gettimeofday localtime_r \
 		memmove memset munmap strchr strdup strerror strrchr strstr \
-		strtoul])
+		strtoul getgrgid getpwuid])
 
 # Checks for system services
 AC_SYS_LARGEFILE
@@ -87,5 +87,6 @@ AC_CONFIG_FILES([Makefile
 		 sbin/Makefile
 		 sbin/cleanerd/Makefile
 		 sbin/mkfs/Makefile
-		 sbin/mount/Makefile])
+		 sbin/mount/Makefile
+		 sbin/nilfs-tune/Makefile])
 AC_OUTPUT
diff --git a/man/Makefile.am b/man/Makefile.am
index 7085c86..3953f90 100644
--- a/man/Makefile.am
+++ b/man/Makefile.am
@@ -2,4 +2,4 @@
 
 dist_man_MANS = nilfs.8 mkfs.nilfs2.8 mount.nilfs2.8 umount.nilfs2.8 \
 	lscp.1 mkcp.8 chcp.8 rmcp.8 lssu.1 dumpseg.8 nilfs_cleanerd.8 \
-	nilfs_cleanerd.conf.5
+	nilfs_cleanerd.conf.5 nilfs-tune.8
diff --git a/man/chcp.8 b/man/chcp.8
index 65445f3..031e2eb 100644
--- a/man/chcp.8
+++ b/man/chcp.8
@@ -33,4 +33,5 @@ http://www.nilfs.org.
 .BR nilfs (8),
 .BR lscp (1),
 .BR mkcp (8),
-.BR rmcp (8).
+.BR rmcp (8),
+.BR nilfs-tune (8).
diff --git a/man/lscp.1 b/man/lscp.1
index 73ffc9a..0513f57 100644
--- a/man/lscp.1
+++ b/man/lscp.1
@@ -70,4 +70,5 @@ http://www.nilfs.org.
 .BR nilfs (8),
 .BR mkcp (8),
 .BR chcp (8),
-.BR rmcp (8).
+.BR rmcp (8),
+.BR nilfs-tune (8).
diff --git a/man/mkcp.8 b/man/mkcp.8
index 20e1848..490a75b 100644
--- a/man/mkcp.8
+++ b/man/mkcp.8
@@ -32,4 +32,5 @@ http://www.nilfs.org.
 .BR nilfs (8),
 .BR lscp (1),
 .BR chcp (8),
-.BR rmcp (8).
+.BR rmcp (8),
+.BR nilfs-tune (8).
diff --git a/man/nilfs-tune.8 b/man/nilfs-tune.8
new file mode 100644
index 0000000..2337c8f
--- /dev/null
+++ b/man/nilfs-tune.8
@@ -0,0 +1,54 @@
+.\"  Copyright (C) 2010 Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
+.\"
+.TH NILFS-TUNE 8 "May 2010" "nilfs-utils version 2.0"
+.SH NAME
+nilfs-tune \- adjust tunable file system parameters on NILFS filesystem
+.SH SYNOPSIS
+.B nilfs-tune
+[\fIoptions\fP] \fIdevice\fP
+.SH DESCRIPTION
+.B nilfs-tune
+is a utility to modify tunable file system parameters on NILFS2 file
+system in \fIdevice\fP.  When \fIdevice\fP is omitted, it tries
+to find a NILFS2 file system from \fI/proc/mounts\fP.
+.PP
+This command is valid only for mounted NILFS2 file systems, and
+will fail if the \fIdevice\fP has no active mounts.
+.SH OPTIONS
+.TP
+.B \-i \fIinterval\fP
+Set the commit interval of segment.
+.TP
+.B \-m \fIblock-max\fP
+Set the threshold of the data amount of the segment construction.
+.TP
+.B \-l
+List the contents of the file system superblock, including the current
+values of the prameters that can be set via this program.
+.TP
+.B \-L \fIvolume-label\fP
+Set the volume label of the file system.  NILFS2 file system labels
+can be at most 80 bytes long.  If volume-label is longer than 80 bytes,
+nilfs-tune will truncate it.  The volume label can be used mount(8) and
+/etc/fstab(5) (and possibly others) by specifying \fBLABEL\fP=volume-label
+instead of a block special device name like /dev/sda5.
+.TP
+.B \-U \fIUUID\fP
+Set the universally unique identifier (UUID) of the filesystem to UUID.
+The format of the UUID is a series of hex digits sepa rated by hyphens,
+like this: "c1b9d5a2-f162-11cf-9ece-0020afc76f16".
+.TP
+.B \-h
+Display help message and exit.
+.SH AUTHOR
+Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
+.SH AVAILABILITY
+.B nilfs-tune
+is part of the nilfs-utils package and is available from
+http://www.nilfs.org.
+.SH SEE ALSO
+.BR nilfs (8),
+.BR lscp (1),
+.BR chcp (8),
+.BR mkcp (8),
+.BR rmcp (8).
diff --git a/man/nilfs.8 b/man/nilfs.8
index 8ec8f13..e8089e6 100644
--- a/man/nilfs.8
+++ b/man/nilfs.8
@@ -111,6 +111,7 @@ was developed by NILFS development team <nilfs-sG5X7nlA6pw@public.gmane.org>.
 .BR umount.nilfs2 (8),
 .BR nilfs_cleanerd (8),
 .BR nilfs_cleanerd.conf (5),
+.BR nilfs-tune (8),
 .BR lscp (1),
 .BR mkcp (8),
 .BR chcp (8),
diff --git a/man/rmcp.8 b/man/rmcp.8
index e7d65f9..6d99a21 100644
--- a/man/rmcp.8
+++ b/man/rmcp.8
@@ -52,4 +52,5 @@ http://www.nilfs.org.
 .BR nilfs (8),
 .BR lscp (1),
 .BR mkcp (8),
-.BR chcp (8).
+.BR chcp (8),
+.BR nilfs-tune (8).
diff --git a/sbin/Makefile.am b/sbin/Makefile.am
index 6038b8f..0783ce0 100644
--- a/sbin/Makefile.am
+++ b/sbin/Makefile.am
@@ -1,3 +1,3 @@
 ## Makefile.am
 
-SUBDIRS = cleanerd mkfs mount
+SUBDIRS = cleanerd mkfs mount nilfs-tune
diff --git a/sbin/nilfs-tune/Makefile.am b/sbin/nilfs-tune/Makefile.am
new file mode 100644
index 0000000..e29ba2e
--- /dev/null
+++ b/sbin/nilfs-tune/Makefile.am
@@ -0,0 +1,9 @@
+## Makefile.am
+
+AM_CFLAGS = -Wall
+AM_CPPFLAGS = -I$(top_srcdir)/include
+
+sbin_PROGRAMS = nilfs-tune
+
+nilfs_tune_SOURCES = nilfs-tune.c
+nilfs_tune_LDADD = $(top_builddir)/lib/libnilfs.la
diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.c
new file mode 100644
index 0000000..99abb56
--- /dev/null
+++ b/sbin/nilfs-tune/nilfs-tune.c
@@ -0,0 +1,500 @@
+/*
+ * nilfs-tune.c - adjust tunable filesystem parameters on NILFS filesystem
+ *
+ * Copyright (C) 2010 Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with NILFS; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif	/* HAVE_CONFIG_H */
+
+#define _FILE_OFFSET_BITS 64
+//#define _LARGEFILE_SOURCE
+#define _LARGEFILE64_SOURCE
+#define __USE_FILE_OFFSET64
+#define _XOPEN_SOURCE 600
+
+#include <stdio.h>
+
+#if HAVE_STDLIB_H
+#include <stdlib.h>
+#endif	/* HAVE_STDLIB_H */
+
+#if HAVE_STRINGS_H
+#include <strings.h>
+#endif	/* HAVE_STRINGS_H */
+
+#if HAVE_SYS_IOCTL_H
+#include <sys/ioctl.h>
+#endif	/* HAVE_SYS_IOCTL_H */
+
+#if HAVE_STRING_H
+#include <string.h>
+#endif	/* HAVE_STRING_H */
+
+#if HAVE_LIMITS_H
+#include <limits.h>
+#endif	/* HAVE_LIMITS_H */
+
+#if HAVE_GRP_H
+#include <grp.h>
+#endif	/* HAVE_GRP_H */
+
+#if HAVE_PWD_H
+#include <pwd.h>
+#endif	/* HAVE_PWD_H */
+
+#include <ctype.h>
+
+#include <errno.h>
+#include "nilfs.h"
+
+#define MOUNTS			"/etc/mtab"
+#define LINE_BUFFER_SIZE	256  /* Line buffer size for reading mtab */
+
+struct nilfs_tune_options {
+	int flags;
+	int display;
+	int mask;
+	int force;
+	__u32 c_interval;
+	__u32 c_block_max;
+	char label[80];
+	__u8 uuid[16];
+};
+
+static void nilfs_tune_usage(void)
+{
+	printf("Usage: nilfs-tune [-h] [-l] [-i interval] [-L volume_name]\n"
+	       "                  [-m block_max] [-U UUID] device\n");
+}
+
+int parse_uuid(const char *uuid_string, __u8 *uuid)
+{
+	int i;
+	char p[3];
+
+	if (strlen(uuid_string) != 36)
+		return -1;
+
+	for (i=0, p[2]='\0'; i < 36; i++) {
+		if ((i == 8) || (i == 13) || (i == 18) || (i == 23)) {
+			if (uuid_string[i] == '-')
+				continue;
+			else
+				return -1;
+		}
+		if (!isxdigit(uuid_string[i]) || !isxdigit(uuid_string[i+1]))
+			return -1;
+
+		p[0] = uuid_string[i++];
+		p[1] = uuid_string[i];
+		*uuid = strtoul(p, NULL, 16);
+		uuid++;
+	}
+	return 0;
+}
+
+void parse_options(int argc, char *argv[], struct nilfs_tune_options *opts)
+{
+	int c;
+	opts->flags = O_RDONLY;
+	opts->display = 0;
+	opts->mask = 0;
+	opts->force = 0;
+
+	while ((c = getopt(argc, argv, "flhi:L:m:U:")) != EOF) {
+		switch (c) {
+		case 'f':
+			opts->force = 1;
+			break;
+		case 'h':
+			nilfs_tune_usage();
+			exit(EXIT_SUCCESS);
+			break;
+		case 'i':
+			opts->c_interval = atol(optarg);
+			opts->mask |= NILFS_SB_COMMIT_INTERVAL;
+			opts->flags = O_RDWR;
+			break;
+		case 'L':
+			strncpy(opts->label, optarg, sizeof(opts->label));
+			opts->mask |= NILFS_SB_LABEL;
+			opts->flags = O_RDWR;
+			break;
+		case 'm':
+			opts->c_block_max = atol(optarg);
+			opts->mask |= NILFS_SB_BLOCK_MAX;
+			opts->flags = O_RDWR;
+			break;
+		case 'l':
+			opts->display = 1;
+			break;
+		case 'U':
+			if (parse_uuid(optarg, opts->uuid)) {
+				fprintf(stderr, "Invalid UUID format\n");
+				exit(EXIT_FAILURE);
+			}
+			opts->mask |= NILFS_SB_UUID;
+			opts->flags = O_RDWR;
+			break;
+		default:
+			nilfs_tune_usage();
+		}
+	}
+}
+
+#define MINUTE	(60)
+#define HOUR	(MINUTE * 60)
+#define DAY	(HOUR * 24)
+#define WEEK	(DAY * 7)
+#define MONTH	(DAY * 30)
+
+#define DIV_SECS(v, C)		\
+do {				\
+	if (secs > (C)) {	\
+		v = secs / C;	\
+		secs -= v * C;	\
+	} else {		\
+		v = 0;		\
+	}			\
+} while(0)
+
+#define FORMAT_VARIABLE(v) \
+do {				\
+	if (v##s) {		\
+		sprintf(tmp, "%s%d " #v "%s", buf[0] ? ", " : "", \
+			v##s, (v##s>1) ? "s" : ""); \
+		strcat(buf, tmp);	\
+	}			\
+} while(0)
+
+static const char *interval_string(unsigned int secs)
+{
+	static char buf[512], tmp[128];
+	int months, weeks, days, hours, minutes;
+
+	if (secs == 0)
+		return "none";
+
+	buf[0] = 0;
+	DIV_SECS(months, MONTH);
+	DIV_SECS(weeks, WEEK);
+	DIV_SECS(days, DAY);
+	DIV_SECS(hours, HOUR);
+	DIV_SECS(minutes, MINUTE);
+
+	FORMAT_VARIABLE(month);
+	FORMAT_VARIABLE(week);
+	FORMAT_VARIABLE(day);
+	FORMAT_VARIABLE(hour);
+	FORMAT_VARIABLE(minute);
+	FORMAT_VARIABLE(sec);
+
+	return buf;
+}
+
+static const char *user_string(uid_t uid)
+{
+	static char tmp[LOGIN_NAME_MAX];
+	static char buf[LOGIN_NAME_MAX + 8];
+	struct passwd *pwd;
+
+	strcpy(buf, "user ");
+
+	pwd = getpwuid(uid);
+	if (pwd)
+		strncpy(tmp, pwd->pw_name, sizeof(tmp));
+	else
+		strcpy(tmp, "unknown");
+	strcat(buf, tmp);
+	return buf;
+}
+
+static const char *group_string(gid_t gid)
+{
+	static char tmp[LOGIN_NAME_MAX];
+	static char buf[LOGIN_NAME_MAX + 8];
+	struct group *grp;
+
+	strcpy(buf, "group ");
+
+	grp = getgrgid(gid);
+	if (grp)
+		strncpy(tmp, grp->gr_name, sizeof(tmp));
+	else
+		strcpy(tmp, "unknown");
+	strcat(buf, tmp);
+	return buf;
+}
+
+static const char *uuid_string(unsigned char *uuid)
+{
+	static char buf[256];
+
+	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+		"%02x%02x-%02x%02x%02x%02x%02x%02x", uuid[0], uuid[1],
+		uuid[2], uuid[3], uuid[4], uuid[5], uuid[6], uuid[7],
+		uuid[8], uuid[9], uuid[10], uuid[11], uuid[12],
+		uuid[13], uuid[14], uuid[15]);
+	return buf;
+}
+
+static const char *state_string(unsigned int state)
+{
+	static char buf[256];
+
+	if (state & NILFS_VALID_FS)
+		strcpy(buf, "valid");
+	else
+		strcpy(buf, "invalid or mounted");
+	if (state & NILFS_ERROR_FS)
+		strcat(buf, ",error");
+	if (state & NILFS_RESIZE_FS)
+		strcat(buf, ",resize");
+	return buf;
+}
+
+static const char *creator_os_string(unsigned int creator)
+{
+	static char buf[64];
+
+	switch(creator) {
+	case NILFS_OS_LINUX:
+		strcpy(buf, "Linux");
+		break;
+	default:
+		strcpy(buf, "Unknown");
+		break;
+	}
+
+	return buf;
+}
+
+static char *time_string(time_t t)
+{
+	return ctime(&t);
+}
+
+void show_nilfs_sb(struct nilfs_super_block *sbp)
+{
+	char label[sizeof(sbp->s_volume_name) + 1];
+	gid_t gid;
+	uid_t uid;
+
+	memset(label, 0, sizeof(label));
+	memcpy(label, sbp->s_volume_name, sizeof(sbp->s_volume_name));
+	if (!label[0])
+		strcpy(label, "<none>");
+
+	printf("Filesystem volume name:\t  %s\n", label);
+	printf("Filesystem UUID:\t  %s\n", uuid_string(sbp->s_uuid));
+	printf("Filesystem magic number:  0x%04x\n",
+	       le16_to_cpu(sbp->s_magic));
+	printf("Filesystem revision #:\t  %d.%d\n",
+	       le32_to_cpu(sbp->s_rev_level),
+	       le32_to_cpu(sbp->s_minor_rev_level));
+
+	/* sbp->s_flags is not used */
+
+	printf("Filesystem state:\t  %s\n",
+	       state_string(le16_to_cpu(sbp->s_state)));
+
+	/* sbp->s_errors is not used */
+
+	printf("Filesystem OS type:\t  %s\n",
+	       creator_os_string(le32_to_cpu(sbp->s_creator_os)));
+
+	printf("Block size:\t\t  %u\n",
+	       1 << (le32_to_cpu(sbp->s_log_block_size) + 10));
+
+	printf("Filesystem created:\t  %s",
+	       time_string(le64_to_cpu(sbp->s_ctime)));
+	printf("Last mount time:\t  %s",
+	       time_string(le64_to_cpu(sbp->s_mtime)));
+	printf("Last write time:\t  %s",
+	       time_string(le64_to_cpu(sbp->s_wtime)));
+	printf("Mount count:\t\t  %u\n", le16_to_cpu(sbp->s_mnt_count));
+	printf("Maximum mount count:\t  %u\n",
+	       le16_to_cpu(sbp->s_max_mnt_count));
+
+#if 0 /* filesystem check is not implemented yet */
+	{
+		time_t t;
+		unsigned int interval;
+
+		t = (time_t)le64_to_cpu(sbp->s_lastcheck);
+		printf("Last checked:\t\t  %s", ctime(&t));
+
+		interval = le32_to_cpu(sbp->s_checkinterval);
+		printf("Check interval:\t\t  %u (%s)\n", interval,
+		       interval_string(interval));
+
+		if(interval)
+			printf("Next check after:\t  %s",
+			       time_string(t+interval));
+	}
+#endif
+
+	uid = (uid_t)le16_to_cpu(sbp->s_def_resuid);
+	printf("Reserve blocks uid:\t  %u (%s)\n", uid, user_string(uid));
+	gid = (gid_t)le16_to_cpu(sbp->s_def_resgid);
+	printf("Reserve blocks gid:\t  %u (%s)\n", gid, group_string(gid));
+
+	printf("First inode:\t\t  %u\n", le32_to_cpu(sbp->s_first_ino));
+
+	printf("Inode size:\t\t  %u\n", le16_to_cpu(sbp->s_inode_size));
+	printf("DAT entry size:\t\t  %u\n", le16_to_cpu(sbp->s_dat_entry_size));
+	printf("Checkpoint size:\t  %u\n",
+	       le16_to_cpu(sbp->s_checkpoint_size));
+	printf("Segment usage size:\t  %u\n",
+	       le16_to_cpu(sbp->s_segment_usage_size));
+
+	printf("Number of segments:\t  %llu\n", le64_to_cpu(sbp->s_nsegments));
+	printf("Device size:\t\t  %llu\n", le64_to_cpu(sbp->s_dev_size));
+	printf("First data block:\t  %llu\n",
+	       le64_to_cpu(sbp->s_first_data_block));
+	printf("# of blocks per segment:  %u\n",
+	       le32_to_cpu(sbp->s_blocks_per_segment));
+	printf("Reserved segments %%:\t  %u\n",
+	       le32_to_cpu(sbp->s_r_segments_percentage));
+	printf("Last checkpoint #:\t  %llu\n", le64_to_cpu(sbp->s_last_cno));
+	printf("Last block address:\t  %llu\n", le64_to_cpu(sbp->s_last_pseg));
+	printf("Last sequence #:\t  %llu\n", le64_to_cpu(sbp->s_last_seq));
+	printf("Free blocks count:\t  %llu\n",
+	       le64_to_cpu(sbp->s_free_blocks_count));
+
+	printf("Commit interval:\t  %u\n", le32_to_cpu(sbp->s_c_interval));
+	printf("# of blks to create seg:  %u\n", le32_to_cpu(sbp->s_c_block_max));
+
+	printf("CRC seed:\t\t  0x%08x\n", le32_to_cpu(sbp->s_crc_seed));
+	printf("CRC check sum:\t\t  0x%08x\n", le32_to_cpu(sbp->s_sum));
+	printf("CRC check data size:\t  0x%08x\n", le32_to_cpu(sbp->s_bytes));
+}
+
+int modify_nilfs(char *device, struct nilfs_tune_options *opts)
+{
+	int devfd;
+	int ret = EXIT_SUCCESS;
+	struct nilfs_super_block *sbp;
+	__u64 features;
+
+	devfd = open(device, opts->flags);
+
+	if (devfd == -1) {
+		fprintf(stderr, "%s: cannot open NILFS\n", device);
+		ret = EXIT_FAILURE;
+		goto out;
+	}
+
+	sbp = nilfs_sb_read(devfd);
+	if (!sbp) {
+		fprintf(stderr, "%s: cannot open NILFS\n", device);
+		ret = EXIT_FAILURE;
+		goto close_fd;
+	}
+
+	features = le64_to_cpu(sbp->s_feature_incompat);
+	if (features & ~NILFS_FEATURE_INCOMPAT_SUPP)
+		fprintf(stderr, "Warning: %s: unknown incompatible "
+			"features: 0x%llx\n", device, features);
+
+	features = le64_to_cpu(sbp->s_feature_compat_ro);
+	if (opts->flags == O_RDWR &&
+	    (features & ~NILFS_FEATURE_COMPAT_RO_SUPP))
+		fprintf(stderr, "Warning: %s: unknown read-only compatible "
+			"features: 0x%llx\n", device, features);
+
+	if (opts->mask & NILFS_SB_LABEL)
+		memcpy(sbp->s_volume_name, opts->label,
+		       sizeof(opts->label));
+	if (opts->mask & NILFS_SB_UUID)
+		memcpy(sbp->s_uuid, opts->uuid, sizeof(opts->uuid));
+	if (opts->mask & NILFS_SB_COMMIT_INTERVAL)
+		sbp->s_c_interval = cpu_to_le32(opts->c_interval);
+	if (opts->mask & NILFS_SB_BLOCK_MAX)
+		sbp->s_c_block_max = cpu_to_le32(opts->c_block_max);
+
+	if (opts->mask)
+		nilfs_sb_write(devfd, sbp, opts->mask);
+
+	if (opts->display)
+		show_nilfs_sb(sbp);
+
+	free(sbp);
+
+ close_fd:
+	close(devfd);
+ out:
+	return ret;
+}
+
+/* Code borrowed from nilfs2-util/sbin/mkfs/mkfs.c */
+static int check_mount(const char *device)
+{
+	FILE *fp;
+	char line[LINE_BUFFER_SIZE];
+
+	fp = fopen(MOUNTS, "r");
+	if (fp == NULL) {
+		fprintf(stderr, "Error: cannot open %s!", MOUNTS);
+		return 1;
+	}
+
+	while (fgets(line, LINE_BUFFER_SIZE, fp) != NULL) {
+		if (strncmp(strtok(line, " "), device, strlen(device)) == 0) {
+			fclose(fp);
+			return 1;
+		}
+	}
+	fclose(fp);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct nilfs_tune_options opts;
+	char *device;
+
+	printf("nilfs-tune %s\n", VERSION);
+	if (argc < 2) {
+		nilfs_tune_usage();
+		exit(EXIT_SUCCESS);
+	}
+
+	parse_options(argc, argv, &opts);
+
+	device = argv[argc-1];
+
+	if (!device) {
+		nilfs_tune_usage();
+		exit(EXIT_FAILURE);
+	}
+
+	if (!opts.force && opts.flags == O_RDWR && check_mount(device)) {
+		fprintf(stderr, "Warning: %s is currently mounted.\n"
+			"Running nilfs-tune on a mounted file system "
+			"may cause SEVERE damage.\n"
+			"You can force to modify file system by "
+			"\"-f\" option.\n",
+			device);
+		exit(EXIT_SUCCESS);
+	}
+
+	return modify_nilfs(device, &opts);
+}
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
