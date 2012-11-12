From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 15/15] nilfs-utils: fsck: integrate fsck.nilfs2 utility
 into nilfs-utils package
Date: Mon, 12 Nov 2012 13:38:07 +0400
Message-ID: <1352713087.2555.50.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=hGcbOg1LxG/an7Ft9gdVIgVPc02RSYU2r/4Q4uiQe/s=;
	b=H0ly48UwhSsUT8KZmBMPAaAdJ1ngXBWCIK71GQNHUFvxLuGweRRAVdVPRGMkMrrtl4Mtt89RHws75DJF2UUU2yDnp7g5tyoxstG/ioBmiMTY57KKRppnqNY14+0YRWRB;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch integrates fsck.nilfs2 utility into nilfs-utils package.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 15/15] nilfs-utils: fsck: integrate fsck.nilfs2 utility into nilfs-utils package

This patch integrates fsck.nilfs2 utility into nilfs-utils package.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 configure.ac             |    3 ++-
 include/Makefile.am      |    3 ++-
 lib/Makefile.am          |   18 +++++++++++++++---
 sbin/Makefile.am         |    2 +-
 sbin/fsck/ChangeLog.fsck |   44 ++++++++++++++++++++++++++++++++++++++++++++
 sbin/fsck/Makefile.am    |   18 ++++++++++++++++++
 6 files changed, 82 insertions(+), 6 deletions(-)
 create mode 100644 sbin/fsck/ChangeLog.fsck
 create mode 100644 sbin/fsck/Makefile.am

diff --git a/configure.ac b/configure.ac
index c2bcf4c..0d1a2d1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -167,5 +167,6 @@ AC_CONFIG_FILES([Makefile
 		 sbin/mount/Makefile
 		 sbin/nilfs-tune/Makefile
 		 sbin/nilfs-clean/Makefile
-		 sbin/nilfs-resize/Makefile])
+		 sbin/nilfs-resize/Makefile
+		 sbin/fsck/Makefile])
 AC_OUTPUT
diff --git a/include/Makefile.am b/include/Makefile.am
index 1b6d812..5c51024 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -3,4 +3,5 @@
 include_HEADERS = nilfs.h nilfs2_fs.h nilfs_cleaner.h
 noinst_HEADERS = realpath.h nls.h cno.h nilfs_feature.h \
 	vector.h nilfs_gc.h cnoconv.h cleaner_msg.h cleaner_exec.h \
-	pathnames.h
+	pathnames.h nilfs_messages.h nilfs_messages.def fsck_raw_ops.h \
+	fsck_nilfs2.h
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 11d17f3..735c614 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -2,7 +2,8 @@
 
 lib_LTLIBRARIES = libnilfs.la libnilfsgc.la libnilfscleaner.la
 noinst_LTLIBRARIES = librealpath.la libnilfsfeature.la libcno.la \
-	libmountchk.la libcrc32.la libcleanerexec.la
+	libmountchk.la libcrc32.la libcleanerexec.la \
+	libnilfsmessages.la libfsck.la
 
 librealpath_la_SOURCES = realpath.c
 librealpath_la_CFLAGS = -Wall -fPIC
@@ -39,11 +40,11 @@ libnilfs_REVISION = 0
 libnilfs_AGE = 1
 libnilfs_VERSIONINFO = $(libnilfs_CURRENT):$(libnilfs_REVISION):$(libnilfs_AGE)
 
-libnilfs_la_SOURCES = nilfs.c sb.c
+libnilfs_la_SOURCES = nilfs.c sb.c segment.c
 libnilfs_la_CFLAGS = -Wall
 libnilfs_la_CPPFLAGS = -I$(top_srcdir)/include
 libnilfs_la_LDFLAGS = -version-info $(libnilfs_VERSIONINFO)
-libnilfs_la_LIBADD = librealpath.la libcrc32.la $(LIB_POSIX_SEM)
+libnilfs_la_LIBADD = librealpath.la libcrc32.la libnilfsmessages.la $(LIB_POSIX_SEM)
 
 nilfsgc_CURRENT = 0
 nilfsgc_REVISION = 0
@@ -66,3 +67,14 @@ libnilfscleaner_la_CFLAGS = -Wall -fPIC
 libnilfscleaner_la_CPPFLAGS = -I$(top_srcdir)/include
 libnilfscleaner_la_LDFLAGS = -version-info $(cleanerctl_VERSIONINFO)
 libnilfscleaner_la_LIBADD = librealpath.la libcleanerexec.la $(LIB_POSIX_MQ) -luuid
+
+libnilfsmessages_la_SOURCES = nilfs_messages.c
+libnilfsmessages_la_CFLAGS = -Wall -fPIC
+libnilfsmessages_la_CPPFLAGS = -I$(top_srcdir)/include
+libnilfsmessages_la_LDFLAGS = -static
+
+libfsck_la_SOURCES = fsck_raw_ops.c
+libfsck_la_CFLAGS = -Wall -fPIC
+libfsck_la_CPPFLAGS = -I$(top_srcdir)/include
+libfsck_la_LDFLAGS = -static
+libfsck_la_LIBADD = libnilfsmessages.la
diff --git a/sbin/Makefile.am b/sbin/Makefile.am
index 302e9a7..8a0d306 100644
--- a/sbin/Makefile.am
+++ b/sbin/Makefile.am
@@ -1,3 +1,3 @@
 ## Makefile.am
 
-SUBDIRS = cleanerd mkfs mount nilfs-tune nilfs-clean nilfs-resize
+SUBDIRS = cleanerd mkfs mount nilfs-tune nilfs-clean nilfs-resize fsck
diff --git a/sbin/fsck/ChangeLog.fsck b/sbin/fsck/ChangeLog.fsck
new file mode 100644
index 0000000..248e8ea
--- /dev/null
+++ b/sbin/fsck/ChangeLog.fsck
@@ -0,0 +1,44 @@
+
+fsck.nilfs2-0.04-under-development November 7, 2012
+	* Every message is associated with subsystem.
+	* It was introduced complex error and it was implemented output of
+	  complex error number with segment and log numbers.
+	* Functionality of primary and secondary superblocks comparing
+	  was added.
+	* Preliminary vision of architecture of checking functionality
+	  was implemented.
+	* Functionality of segment summary header checking was implemented.
+	* Some bugs in superblock checking functionality were fixed.
+
+fsck.nilfs2-0.03-under-development September 5, 2012
+	* It was implemented functionality of NILFS superblock correctness
+	  checking.
+	* Message printing primitives are generalized into single library
+	  (libnilfsmessages.la).
+	* Error definition is associated with definition of error id,
+	  error severity and error message.
+	* It was introduced conception of detected errors database in the
+	  form of set of checking flags bitmaps. The checking flags bitmap
+	  defines what should be checked (for example, in superblock) and,
+	  then, it keeps information about detected corrupted items after
+	  check execution.
+
+fsck.nilfs2-0.02-under-development August 3, 2012
+	* Coding style was reworked (checkpatch.pl script).
+	* The libfsck.la library was added (print routines + raw ops with disk).
+	* nilfs.h - several constants and function declarations was added.
+	* ismounted.c - check_mount() function is reworked for checking on
+	  RO mount.
+	* sb.c - nilfs_sb_is_valid() function is reworked;
+	  nilfs_sb_read_unchecked() was added.
+	* fsck_message.h, fsck_message.def, fsck_raw_ops.h are moved into
+	  include folder.
+	* fsck_message.c, fsck_raw_ops.c are moved into lib folder.
+	* Superblocks are read by means of library function
+	  nilfs_sb_read_unchecked().
+	* Superblocks are checked by means of library function
+	  nilfs_sb_is_valid().
+	* fsck_debug() identifies reported function by means of __func__ macro.
+
+fsck.nilfs2-0.01-under-development July 22, 2012
+	* A skeleton of fsck.nilfs2 utility was added into nilfs-utils package.
diff --git a/sbin/fsck/Makefile.am b/sbin/fsck/Makefile.am
new file mode 100644
index 0000000..7fbe7f2
--- /dev/null
+++ b/sbin/fsck/Makefile.am
@@ -0,0 +1,18 @@
+## Makefile.am
+
+AM_CFLAGS = -Wall
+AM_CPPFLAGS = -I$(top_srcdir)/include
+LDADD = $(top_builddir)/lib/libnilfsmessages.la \
+	$(top_builddir)/lib/libfsck.la \
+	$(top_builddir)/lib/libmountchk.la \
+	$(top_builddir)/lib/libcrc32.la \
+	$(top_builddir)/lib/libnilfs.la
+
+sbin_PROGRAMS = fsck.nilfs2
+
+fsck_nilfs2_SOURCES = fsck_common.h fsck_nilfs2.c \
+			nilfs_superblock.h nilfs_superblock.c \
+			nilfs_segment.h nilfs_segment.c \
+			nilfs_checkpoint.h nilfs_checkpoint.c \
+			nilfs_fs_hierarchy.h nilfs_fs_hierarchy.c \
+			nilfs_volume_check.h nilfs_volume_check.c
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
