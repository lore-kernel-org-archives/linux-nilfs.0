From: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
Subject: [PATCH 3/3] libmount, libblkid: fix order of autoconf probing
Date: Wed,  3 Jan 2018 21:28:23 +0100
Message-ID: <1515011303-8797-3-git-send-email-dev.kurt@vandijck-laurijssen.be>
References: <1515011303-8797-1-git-send-email-dev.kurt@vandijck-laurijssen.be>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515011303-8797-1-git-send-email-dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>

make sure that libuuid is linked during probes.
Since libmount depends on libblkid, probe libblkid first.
This fixes autoprobing on systems that use static libraries exclusively

Signed-off-by: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
---
 configure.ac | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/configure.ac b/configure.ac
index 6fa8c41..50250d9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -103,9 +103,20 @@ AC_CHECK_HEADERS([ctype.h err.h fcntl.h grp.h libintl.h limits.h \
 		  time.h unistd.h])
 
 # Check for conditional libraries and headers.
+if test "${with_blkid}" = "yes"; then
+   AC_CHECK_LIB(blkid, blkid_new_probe_from_filename,
+   		[AC_DEFINE(HAVE_LIBBLKID, 1,
+		    [Define to 1 if you have the 'blkid' library (-lblkid).])
+		 LIB_BLKID="-lblkid -luuid"
+		],
+		AC_MSG_ERROR([BLKID library not found]), [-luuid])
+   AC_CHECK_HEADERS([blkid/blkid.h])
+fi
+AC_SUBST(LIB_BLKID)
+
 if test "${with_libmount}" = "yes"; then
-   AC_CHECK_LIB(mount, mnt_context_do_mount, [LIB_MOUNT="-lmount"],
-   	AC_MSG_ERROR([Mount library is enabled but libmount not found]))
+   AC_CHECK_LIB(mount, mnt_context_do_mount, [LIB_MOUNT="-lmount $LIB_BLKID"],
+   	AC_MSG_ERROR([Mount library is enabled but libmount not found]), [$LIB_BLKID])
    AC_CHECK_HEADERS([libmount/libmount.h])
    with_selinux=no
 fi
@@ -124,17 +135,6 @@ if test "${with_selinux}" = "yes"; then
 fi
 AC_SUBST([LIB_SELINUX])
 
-if test "${with_blkid}" = "yes"; then
-   AC_CHECK_LIB(blkid, blkid_new_probe_from_filename,
-   		[AC_DEFINE(HAVE_LIBBLKID, 1,
-		    [Define to 1 if you have the 'blkid' library (-lblkid).])
-		 LIB_BLKID="-lblkid"
-		],
-		AC_MSG_ERROR([BLKID library not found]))
-   AC_CHECK_HEADERS([blkid/blkid.h])
-fi
-AC_SUBST(LIB_BLKID)
-
 # Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
 AC_C_INLINE
-- 
1.8.5.rc3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
