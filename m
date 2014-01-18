From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs-utils: add --with-libmount build option
Date: Sun, 19 Jan 2014 02:20:18 +0900
Message-ID: <1390065618-29556-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The libmount build option of the current configure script is confusing
since it is provided as an --enable-<feature> style option.

This fixes the issue by adding --with-libmount configure option.  The
--enable-libmount option is still available for compatibility reason.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 README       |    8 ++++----
 configure.ac |   23 +++++++++++++++--------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/README b/README
index 8d92725..f62bc3f 100644
--- a/README
+++ b/README
@@ -2,7 +2,7 @@
 
  - libuuid-devel or uuid-dev
  - libmount-devel (fedora 14 and later)
- - libselinux-devel (unless you specify --without-selinux or --enable-libmount)
+ - libselinux-devel (unless you specify --without-selinux or --with-libmount)
  - libblkid-devel (unless you specify --without-blkid)
 
 * How to compile
@@ -12,9 +12,9 @@
 
 To link mount.nilfs2 and umount.nilfs2 helper programs with libmount
 library, install libmount-devel package and run the configure script
-with --enable-libmount option:
+with --with-libmount option:
 
- $ ./configure --enable-libmount
+ $ ./configure --with-libmount
 
 This option is set by default if /etc/mtab is a symlink to
 /proc/mounts in your system.
@@ -42,7 +42,7 @@ of selinux context mount options (-o context=<context>, etc):
 
  $ ./configure --without-selinux
 
-For mount.nilfs2 built with the --enable-libmount option, support of
+For mount.nilfs2 built with the --with-libmount option, support of
 the context mount depends on the libmount library.
 
 
diff --git a/configure.ac b/configure.ac
index 46821d9..de30ab0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -44,12 +44,19 @@ AC_DEFUN([UTIL_CHECK_LIB], [
 ])
 
 # Check for options.
+AC_ARG_WITH([libmount],
+	AS_HELP_STRING([--with-libmount],
+		       [compile mount.nilfs2 with libmount support]),
+	[with_libmount=$withval],
+	[with_libmount=no; \
+	 if test -L /etc/mtab; then with_libmount=yes; fi])
+
+# Leave --enable-libmount[=ARG] and --disable-libmount options for
+# compatibility reason.
 AC_ARG_ENABLE(libmount,
-	[AC_HELP_STRING([--enable-libmount=[ARG]],
-			[Link mount.nilfs2 with libmount [ARG=yes] (EXPERIMENTAL)])],
-	[enable_libmount=$enableval],
-	[enable_libmount=no; \
-	 if test -L /etc/mtab; then enable_libmount=yes; fi])
+	AS_HELP_STRING([--enable-libmount (obsolete)],
+		       [same as --with-libmount]),
+	[with_libmount=$enableval], [])
 
 AC_ARG_WITH([selinux],
 	AS_HELP_STRING([--without-selinux], [compile without SELinux support]),
@@ -89,13 +96,13 @@ AC_CHECK_HEADERS([ctype.h fcntl.h grp.h libintl.h limits.h linux/magic.h \
 		  sys/mount.h sys/time.h syslog.h time.h unistd.h])
 
 # Check for conditional libraries and headers.
-if test "${enable_libmount}" = "yes"; then
+if test "${with_libmount}" = "yes"; then
    AC_CHECK_LIB(mount, mnt_context_do_mount, [LIB_MOUNT="-lmount"],
-   	AC_MSG_ERROR([libmount needed]))
+   	AC_MSG_ERROR([Mount library is enabled but libmount not found]))
    AC_CHECK_HEADERS([libmount/libmount.h])
    with_selinux=no
 fi
-AM_CONDITIONAL(CONFIG_LIBMOUNT, [test "$enable_libmount" = "yes"])
+AM_CONDITIONAL(CONFIG_LIBMOUNT, [test "$with_libmount" = "yes"])
 AC_SUBST(LIB_MOUNT)
 
 if test "${with_selinux}" = "yes"; then
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
