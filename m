From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs-utils: compile legacy {mount,umount}.nilfs2 with libselinux
Date: Sun, 19 Jan 2014 00:42:35 +0900
Message-ID: <1390059755-22459-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

SELinux context mount options were optional for the legacy version of
{mount,umount}.nilfs2.  This changes the default build configuration
so that they are built with selinux library unless --without-selinux
options is specified.  When we compile them with libmount, libselinux
is not used regardless of this because context mount options are
provided by libmount.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 README       |   19 +++++++++----------
 configure.ac |    5 +++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/README b/README
index 0a0dcc8..8d92725 100644
--- a/README
+++ b/README
@@ -2,7 +2,7 @@
 
  - libuuid-devel or uuid-dev
  - libmount-devel (fedora 14 and later)
- - libselinux-devel (if you specify --with-selinux)
+ - libselinux-devel (unless you specify --without-selinux or --enable-libmount)
  - libblkid-devel (unless you specify --without-blkid)
 
 * How to compile
@@ -25,15 +25,6 @@ into /usr/lib64 instead of /usr/lib, change the library directory with
 
  $ ./configure --libdir=/usr/lib64
 
-You can specify --with-selinux option to compile mount.nilfs2
-supporting context mount options (-o context=<context>, etc):
-
- $ ./configure --with-selinux
-
-For mount.nilfs2 built with the --enable-libmount option, support of
-the context mount depends on the libmount library and this configure
-option is not necessary.
-
 
 * Trouble shooting
 
@@ -46,6 +37,14 @@ However, use of this option is normally not recommended because it
 disables the safety check of mkfs.nilfs2 which prevents users from
 unexpectedly overwriting an in-use device.
 
+You can compile legacy mount.nilfs2 and umount.nilfs2 without support
+of selinux context mount options (-o context=<context>, etc):
+
+ $ ./configure --without-selinux
+
+For mount.nilfs2 built with the --enable-libmount option, support of
+the context mount depends on the libmount library.
+
 
 * How to get development sources
 
diff --git a/configure.ac b/configure.ac
index 62f05ce..46821d9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -52,8 +52,8 @@ AC_ARG_ENABLE(libmount,
 	 if test -L /etc/mtab; then enable_libmount=yes; fi])
 
 AC_ARG_WITH([selinux],
-	AS_HELP_STRING([--with-selinux], [compile with SELinux support]),
-	[], with_selinux=no)
+	AS_HELP_STRING([--without-selinux], [compile without SELinux support]),
+	[], with_selinux=yes)
 
 AC_ARG_WITH([blkid],
 	AS_HELP_STRING([--without-blkid], [compile without blkid support]),
@@ -93,6 +93,7 @@ if test "${enable_libmount}" = "yes"; then
    AC_CHECK_LIB(mount, mnt_context_do_mount, [LIB_MOUNT="-lmount"],
    	AC_MSG_ERROR([libmount needed]))
    AC_CHECK_HEADERS([libmount/libmount.h])
+   with_selinux=no
 fi
 AM_CONDITIONAL(CONFIG_LIBMOUNT, [test "$enable_libmount" = "yes"])
 AC_SUBST(LIB_MOUNT)
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
