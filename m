From: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
Subject: [PATCH] libmount, libblkid: use PKG_CHECK_MODULES for probing
Date: Mon, 22 Jan 2018 22:14:14 +0100
Message-ID: <1516655654-12684-1-git-send-email-dev.kurt@vandijck-laurijssen.be>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>

After a round to add this to buildroot, I learned that
the proper way to check the dependencies seems to point to pkg-config.
This commit migrates the libmount & libblkid checks to use PKG_CHECK_MODULES.
I added a similar patch to current buildroot, and this succeeds
all daily tests as well.

Signed-off-by: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
---
 configure.ac                 | 13 +++----------
 sbin/Makefile.am             |  3 ++-
 sbin/mkfs.c                  |  6 +++---
 sbin/mount/Makefile.am       |  4 ++--
 sbin/mount/mount_libmount.c  |  4 +---
 sbin/mount/umount_libmount.c |  4 +---
 6 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/configure.ac b/configure.ac
index c92d1c5..6a824f2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -106,27 +106,20 @@ fi
 
 # Check for conditional libraries and headers.
 if test "${with_blkid}" = "yes"; then
-   AC_CHECK_LIB(blkid, blkid_new_probe_from_filename,
+   PKG_CHECK_MODULES([BLKID], [blkid],
    		[AC_DEFINE(HAVE_LIBBLKID, 1,
 		    [Define to 1 if you have the 'blkid' library (-lblkid).])
-		 LIB_BLKID="-lblkid -luuid"
-		],
-		AC_MSG_ERROR([BLKID library not found]), [-luuid])
-   AC_CHECK_HEADERS([blkid/blkid.h])
+		])
 fi
-AC_SUBST(LIB_BLKID)
 
 if test "${with_libmount}" = "yes"; then
    if test "$mtab_type" = file; then
       AC_MSG_WARN([Use --without-libmount option to generate mount helpers that work with the legacy mtab file.])
    fi
-   AC_CHECK_LIB(mount, mnt_context_do_mount, [LIB_MOUNT="-lmount $LIB_BLKID"],
-   	AC_MSG_ERROR([Mount library is enabled but libmount not found]), [$LIB_BLKID])
-   AC_CHECK_HEADERS([libmount/libmount.h])
+   PKG_CHECK_MODULES([MOUNT], [mount])
    with_selinux=no
 fi
 AM_CONDITIONAL(CONFIG_LIBMOUNT, [test "$with_libmount" = "yes"])
-AC_SUBST(LIB_MOUNT)
 
 if test "${with_selinux}" = "yes"; then
    AC_CHECK_LIB(selinux, getprevcon,
diff --git a/sbin/Makefile.am b/sbin/Makefile.am
index 7729166..4eac742 100644
--- a/sbin/Makefile.am
+++ b/sbin/Makefile.am
@@ -10,7 +10,8 @@ root_sbin_PROGRAMS = mkfs.nilfs2 nilfs_cleanerd
 sbin_PROGRAMS = nilfs-clean nilfs-resize nilfs-tune
 
 mkfs_nilfs2_SOURCES = mkfs.c bitops.c mkfs.h
-mkfs_nilfs2_LDADD = $(LIB_BLKID) -luuid \
+mkfs_nilfs2_CFLAGS = -Wall $(BLKID_CFLAGS)
+mkfs_nilfs2_LDADD = $(BLKID_LIBS) -luuid \
 	$(top_builddir)/lib/libcrc32.la \
 	$(top_builddir)/lib/libmountchk.la \
 	$(top_builddir)/lib/libnilfsfeature.la
diff --git a/sbin/mkfs.c b/sbin/mkfs.c
index a0da7fe..95679dc 100644
--- a/sbin/mkfs.c
+++ b/sbin/mkfs.c
@@ -58,9 +58,9 @@
 
 #include <errno.h>
 
-#if HAVE_BLKID_BLKID_H
-#include <blkid/blkid.h>
-#endif	/* HAVE_BLKID_BLKID_H */
+#if HAVE_LIBBLKID
+#include <blkid.h>
+#endif	/* HAVE_LIBBLKID */
 
 #include "nilfs.h"
 #include "mkfs.h"
diff --git a/sbin/mount/Makefile.am b/sbin/mount/Makefile.am
index f5d3c27..9554aa5 100644
--- a/sbin/mount/Makefile.am
+++ b/sbin/mount/Makefile.am
@@ -6,10 +6,10 @@ COMMONHEADERS = mount.nilfs2.h sundries.h xmalloc.h
 LEGACYSOURCES = fstab.c mount_mntent.c mount_opts.c
 LEGACYHEADERS = fstab.h mount_constants.h mount_mntent.h mount_opts.h
 
-AM_CFLAGS = -Wall
+AM_CFLAGS = -Wall $(MOUNT_CFLAGS)
 AM_CPPFLAGS = -I$(top_srcdir)/include
 LDADD = $(top_builddir)/lib/librealpath.la \
-	$(top_builddir)/lib/libcleanerexec.la $(LIB_MOUNT) $(LIB_SELINUX) \
+	$(top_builddir)/lib/libcleanerexec.la $(MOUNT_LIBS) $(LIB_SELINUX) \
 	$(LIB_POSIX_TIMER)
 
 root_sbin_PROGRAMS = mount.nilfs2 umount.nilfs2
diff --git a/sbin/mount/mount_libmount.c b/sbin/mount/mount_libmount.c
index ef40e68..a7fec00 100644
--- a/sbin/mount/mount_libmount.c
+++ b/sbin/mount/mount_libmount.c
@@ -67,9 +67,7 @@
 #include <syslog.h>
 #endif	/* HAVE_SYSLOG_H */
 
-#if HAVE_LIBMOUNT_LIBMOUNT_H
-#include <libmount/libmount.h>
-#endif	/* HAVE_LIBMOUNT_H */
+#include <libmount.h>
 
 #include <stdarg.h>
 #include <errno.h>
diff --git a/sbin/mount/umount_libmount.c b/sbin/mount/umount_libmount.c
index ae5a337..b678f54 100644
--- a/sbin/mount/umount_libmount.c
+++ b/sbin/mount/umount_libmount.c
@@ -59,9 +59,7 @@
 #include <syslog.h>
 #endif	/* HAVE_SYSLOG_H */
 
-#if HAVE_LIBMOUNT_LIBMOUNT_H
-#include <libmount/libmount.h>
-#endif	/* HAVE_LIBMOUNT_H */
+#include <libmount.h>
 
 #include <stdarg.h>
 #include <errno.h>
-- 
1.8.5.rc3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
