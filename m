From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3] nilfs-utils: mkfs.nilfs2 should check presence of NILFS2
 volume on device
Date: Mon, 25 Mar 2013 15:47:21 +0400
Message-ID: <1364212041.2505.7.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=EMq+lDpYtGoAIGoSe1qkA+Jaiappf7/bOehsVxJQpWY=;
	b=EtNLrEtOrAq+VJDecc9L/JSM8HqLBJgZalHiyrOl/PVXU+4ogMZy1EzhaLIkuq036NQTndIYlXAk4cl2BsymosALEFsbgpV5UA1rjgARd0hzET9tvfQfunSWtvAuf+Ft;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>, Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3] nilfs-utils: mkfs.nilfs2 should check presence of NILFS2 volume on device

The mkfs.nilfs2 utility should check presence of existing file system or partition table on device and to warn a user about possibility to destroy data by mkfs activity. This patch uses libblkid library for detection of presence of file system or partition table on opened device. If libblkid detects any known signature then mkfs.nilfs2 informs a user about potential danger to destroy existing file system or partition table. The execution of mkfs.nilfs2 stops with offering to make decision about continuation or abortion of operation.

Moreover, this patch adds "-f" option that gives opportunity to force overwrite when an existing file system is detected on the device. By default, mkfs.nilfs2 will not write to the device if it suspects that there is a file system on the device already. The man page of mkfs.nilfs2 was modified by description of "-f" option.

Reported-by: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>
Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>
Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 configure.ac          |    8 +++-
 man/mkfs.nilfs2.8     |   13 +++++++
 sbin/mkfs/Makefile.am |    2 +-
 sbin/mkfs/mkfs.c      |  104 ++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 123 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index c2bcf4c..1c4cd25 100644
--- a/configure.ac
+++ b/configure.ac
@@ -61,6 +61,11 @@ AC_CHECK_LIB([uuid], [uuid_generate],
 	  [Define to 1 if you have the 'uuid' library (-luuid).])],
 	[AC_MSG_ERROR([UUID library not found])])
 
+AC_CHECK_LIB([blkid], [blkid_new_probe_from_filename],
+	[AC_DEFINE([HAVE_LIBBLKID], 1,
+	  [Define to 1 if you have the 'blkid' library (-lblkid).])],
+	[AC_MSG_ERROR([BLKID library not found])])
+
 LIB_POSIX_MQ=''
 AC_CHECK_FUNC(mq_open,,
 	[AC_CHECK_LIB(rt, mq_open, LIB_POSIX_MQ=-lrt,
@@ -82,7 +87,8 @@ AC_HEADER_SYS_WAIT
 AC_CHECK_HEADERS([ctype.h fcntl.h grp.h libintl.h limits.h linux/magic.h \
 		  linux/types.h locale.h mntent.h mqueue.h paths.h pwd.h \
 		  semaphore.h stdlib.h string.h strings.h sys/ioctl.h \
-		  sys/mount.h sys/time.h syslog.h time.h unistd.h])
+		  sys/mount.h sys/time.h syslog.h time.h unistd.h \
+		  blkid/blkid.h])
 
 # Check for conditional libraries and headers.
 if test "${enable_libmount}" = "yes"; then
diff --git a/man/mkfs.nilfs2.8 b/man/mkfs.nilfs2.8
index 6b7dffe..a42d5b4 100644
--- a/man/mkfs.nilfs2.8
+++ b/man/mkfs.nilfs2.8
@@ -18,6 +18,9 @@ mkfs.nilfs2 \- create a NILFS2 filesystem
 .B \-c
 ]
 [
+.B \-f
+]
+[
 .B \-K
 ]
 [
@@ -62,6 +65,9 @@ mkfs.nilfs2 \- create a NILFS2 filesystem
 .B \-c
 ]
 [
+.B \-f
+]
+[
 .B \-K
 ]
 [
@@ -120,6 +126,13 @@ number of blocks per segment is 2048 (= 8MB with 4KB blocks).
 .B \-c
 Check the device for bad blocks before building the filesystem.
 .TP
+.B \-f
+Force overwrite when an existing filesystem is detected on the device.
+By default,
+.B mkfs.nilfs2
+will not write to the device if it suspects  that  there is a filesystem
+on the device already.
+.TP
 .B \-h
 Display help message and exit.
 .TP
diff --git a/sbin/mkfs/Makefile.am b/sbin/mkfs/Makefile.am
index b3eb78a..85f30db 100644
--- a/sbin/mkfs/Makefile.am
+++ b/sbin/mkfs/Makefile.am
@@ -2,7 +2,7 @@
 
 AM_CFLAGS = -Wall
 AM_CPPFLAGS = -I$(top_srcdir)/include
-LDADD = -luuid $(top_builddir)/lib/libnilfsfeature.la \
+LDADD = -luuid -lblkid $(top_builddir)/lib/libnilfsfeature.la \
 	$(top_builddir)/lib/libmountchk.la \
 	$(top_builddir)/lib/libcrc32.la
 
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index fde1c76..b15cc3e 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -72,6 +72,10 @@
 
 #include <errno.h>
 
+#if HAVE_BLKID_BLKID_H
+#include <blkid/blkid.h>
+#endif	/* HAVE_BLKID_BLKID_H */
+
 #include "nilfs.h"
 #include "nilfs_feature.h"
 #include "mkfs.h"
@@ -112,6 +116,7 @@ static int cflag = 0;
 static int nflag = 0;
 static int verbose = 0;
 static int discard = 1;
+static int force_overwrite = 0;
 static unsigned long blocksize = NILFS_DEF_BLOCKSIZE;
 static unsigned long blocks_per_segment = NILFS_DEF_BLKS_PER_SEG;
 static unsigned long r_segments_percentage = NILFS_DEF_RESERVED_SEGMENTS;
@@ -347,6 +352,7 @@ static int nilfs_mkfs_discard_zeroes_data(int fd)
 
 static void disk_scan(const char *device);
 static void check_mount(int fd, const char *device);
+static void check_safety_of_device_overwrite(int fd, const char *device);
 
 
 /*
@@ -611,6 +617,7 @@ int main(int argc, char *argv[])
 	if ((fd = open(device, O_RDWR)) < 0)
 		perr("Error: cannot open device: %s", device);
 	check_mount(fd, device);
+	check_safety_of_device_overwrite(fd, device);
 
 	init_disk_layout(di, fd, device);
 	si = new_segment(di);
@@ -729,6 +736,96 @@ static void check_mount(int fd, const char *device)
 	fclose(fp);
 }
 
+static void check_safety_of_device_overwrite(int fd, const char *device)
+{
+	int c, c_next;
+	blkid_probe pr = NULL;
+	blkid_loff_t size;
+	int ret = 0;
+
+	if (!device || !*device)
+		return;
+
+	if (force_overwrite == 0) {
+		pr = blkid_new_probe_from_filename(device);
+		if (!pr) {
+			ret = -1;
+			goto end_check;
+		}
+
+		size = blkid_probe_get_size(pr);
+		if (size <= 0)
+			goto end_check;
+
+		ret = blkid_probe_enable_partitions(pr, 1);
+		if (ret < 0)
+			goto end_check;
+
+		ret = blkid_do_fullprobe(pr);
+		if (ret < 0) /* error */
+			goto end_check;
+		else if (ret == 0) { /* some signature was found */
+			const char *type;
+
+			if (!blkid_probe_lookup_value(pr, "TYPE",
+							&type, NULL)) {
+				pinfo("WARNING: Device %s appears to contain "
+					"an existing %s superblock.",
+					device, type);
+			} else if (!blkid_probe_lookup_value(pr, "PTTYPE",
+								&type, NULL)) {
+				pinfo("WARNING: Device %s appears to contain "
+					"an partition table (%s).",
+					device, type);
+			} else {
+				if (quiet == 0) {
+					pinfo("Device %s appears to contain "
+						"something weird.", device);
+				}
+				goto end_check;
+			}
+
+			pinfo("WARNING: All data will be lost after format!");
+			pinfo("\nDO YOU REALLY WANT TO FORMAT DEVICE %s?",
+				device);
+
+			do {
+				fprintf(stderr, "\nContinue? [y/N] ");
+				c = getchar();
+
+				if (c == EOF || c == '\n')
+					goto abort_format;
+
+				c_next = getchar();
+				if (c_next != EOF && c_next != '\n')
+					goto clear_input_buffer;
+
+				if (c == 'n' || c == 'N')
+					goto abort_format;
+
+clear_input_buffer:
+				while (c_next != '\n' && c_next != EOF)
+					c_next = getchar();
+			} while (c != 'y' && c != 'Y');
+		}
+	}
+
+end_check:
+	if (pr)
+		blkid_free_probe(pr);
+	if (quiet == 0 && ret < 0)
+		pinfo("Probe of %s failed, can't detect fs existence.",
+			device);
+	return;
+
+abort_format:
+	if (pr)
+		blkid_free_probe(pr);
+	close(fd);
+	perr("Abort format of device %s", device);
+	return;
+}
+
 static void destroy_disk_buffer(void)
 {
 	if (disk_buffer) {
@@ -973,7 +1070,7 @@ static void parse_options(int argc, char *argv[])
 	int c, show_version_only = 0;
 	char *fs_features = NULL;
 
-	while ((c = getopt(argc, argv, "b:B:chKL:m:nqvO:P:V")) != EOF) {
+	while ((c = getopt(argc, argv, "b:B:cfhKL:m:nqvO:P:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = atol(optarg);
@@ -985,6 +1082,9 @@ static void parse_options(int argc, char *argv[])
 		case 'c':
 			cflag++;
 			break;
+		case 'f':
+			force_overwrite = 1;
+			break;
 		case 'h':
 			usage();
 			exit(EXIT_SUCCESS);
@@ -1056,7 +1156,7 @@ static void parse_options(int argc, char *argv[])
 static void usage(void)
 {
 	fprintf(stderr,
-		"Usage: %s [-b block-size] [-B blocks-per-segment] [-c] \n"
+		"Usage: %s [-b block-size] [-B blocks-per-segment] [-c] [-f] \n"
 		"       [-L volume-label] [-m reserved-segments-percentage] \n"
 		"       [-O feature[,...]] \n"
 		"       [-hnqvKV] device\n",
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
