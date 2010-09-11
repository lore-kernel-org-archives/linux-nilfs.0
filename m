From: Matteo Frigo <athena-/JWCw35jmeM@public.gmane.org>
Subject: [PATCH] Compare device number rather than device name for mount check.
Date: Sat, 11 Sep 2010 15:40:12 -0400
Message-ID: <87d3skgjc3.fsf_-_@fftw.org>
References: <BAEFA5609CC3AB4BAE1625CAD4C27E5C02986E1D@tdpost.td.tandbergdata.com>
	<20090408.023005.48479195.ryusuke@osrg.net>
	<87iq2cr4sq.fsf_-_@fftw.org>
	<20100912.033432.247181057.ryusuke@osrg.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

To check whether a file system is mounted, nilfs-tune was comparing
the device name to the contents of /etc/mtab.  This check does not
detect a mounted file system when the device has multiple names, which
is a common case when using LVM.  (LVM creates symbolic links from
/dev/mapper/vg-lv to /dev/dm-X.)

This patch, borrowed from the analogous check in e2fsprogs, compares
the device number (field st_rdev of struct stat) rather than the
device name.

Signed-off-by: Matteo Frigo <athena-/JWCw35jmeM@public.gmane.org>
---
 configure.ac                 |    3 +-
 sbin/nilfs-tune/nilfs-tune.c |   69 +++++++++++++++++++++++++++++++----------
 2 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/configure.ac b/configure.ac
index af75142..963e2fd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -37,7 +37,8 @@ AC_HEADER_STDC
 AC_HEADER_SYS_WAIT
 AC_CHECK_HEADERS([fcntl.h libintl.h limits.h locale.h mntent.h paths.h \
 		  stdlib.h string.h strings.h sys/ioctl.h sys/mount.h \
-		  sys/time.h syslog.h unistd.h linux/types.h grp.h pwd.h])
+		  sys/time.h syslog.h unistd.h linux/types.h grp.h pwd.h \
+		  mntent.h])
 
 # Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.c
index 18513f2..5b7f030 100644
--- a/sbin/nilfs-tune/nilfs-tune.c
+++ b/sbin/nilfs-tune/nilfs-tune.c
@@ -58,6 +58,11 @@
 #include <pwd.h>
 #endif	/* HAVE_PWD_H */
 
+#ifdef HAVE_MNTENT_H
+#include <mntent.h>
+#endif
+
+#include <sys/stat.h>
 #include <ctype.h>
 
 #include <errno.h>
@@ -444,26 +449,57 @@ int modify_nilfs(char *device, struct nilfs_tune_options *opts)
 	return ret;
 }
 
-/* Code borrowed from nilfs2-util/sbin/mkfs/mkfs.c */
+/* check_mount() checks whether DEVICE is a mounted file system.
+   Returns 0 if the DEVICE is *not* mounted (which we consider a
+   successful outcome), and -1 if DEVICE is mounted or if the mount
+   status cannot be determined.
+
+   Derived from e2fsprogs/lib/ext2fs/ismounted.c
+   Copyright (C) 1995,1996,1997,1998,1999,2000 Theodore Ts'o,
+   LGPL v2
+*/
 static int check_mount(const char *device)
 {
-	FILE *fp;
-	char line[LINE_BUFFER_SIZE];
-
-	fp = fopen(MOUNTS, "r");
-	if (fp == NULL) {
+	struct mntent *mnt;
+	struct stat st_buf;
+	FILE *f;
+	dev_t file_dev = 0, file_rdev = 0;
+	ino_t file_ino = 0;
+
+	f = setmntent(MOUNTS, "r");
+	if (f == NULL) {
 		fprintf(stderr, "Error: cannot open %s!", MOUNTS);
-		return 1;
+		return -1;
 	}
 
-	while (fgets(line, LINE_BUFFER_SIZE, fp) != NULL) {
-		if (strncmp(strtok(line, " "), device, strlen(device)) == 0) {
-			fclose(fp);
-			return 1;
+	if (stat(device, &st_buf) == 0) {
+		if (S_ISBLK(st_buf.st_mode)) {
+			file_rdev = st_buf.st_rdev;
+		} else {
+			file_dev = st_buf.st_dev;
+			file_ino = st_buf.st_ino;
 		}
 	}
-	fclose(fp);
-	return 0;
+
+	while ((mnt = getmntent(f)) != NULL) {
+		if (mnt->mnt_fsname[0] != '/')
+			continue;
+		if (strcmp(device, mnt->mnt_fsname) == 0)
+			break;
+		if (stat(mnt->mnt_fsname, &st_buf) == 0) {
+			if (S_ISBLK(st_buf.st_mode)) {
+				if (file_rdev && (file_rdev == st_buf.st_rdev))
+					break;
+			} else {
+				if (file_dev && ((file_dev == st_buf.st_dev) &&
+						 (file_ino == st_buf.st_ino)))
+					break;
+			}
+		}
+	}
+
+	endmntent(f);
+	return (mnt == NULL) ? 0 : -1;
 }
 
 int main(int argc, char *argv[])
@@ -486,12 +522,11 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	if (!opts.force && opts.flags == O_RDWR && check_mount(device)) {
-		fprintf(stderr, "Warning: %s is currently mounted.\n"
+	if (!opts.force && opts.flags == O_RDWR && (check_mount(device) < 0)) {
+		fprintf(stderr, "ERROR: %s is currently mounted.  Aborting execution.\n"
 			"Running nilfs-tune on a mounted file system "
 			"may cause SEVERE damage.\n"
-			"You can force to modify file system by "
-			"\"-f\" option.\n",
+			"You can use the \"-f\" option to force this operation.\n",
 			device);
 		exit(EXIT_SUCCESS);
 	}
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
