From: Dmitry Smirnov <onlyjob-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Re: few patches from Debian
Date: Sat, 19 Apr 2014 21:46:37 +1000
Message-ID: <7826590.1PyduIE8uy@debstor>
References: <6284364.q7fsBQ3iYY@debstor> <4645877.yriC0M9ozk@debstor> <20140419.202620.220041591.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2316239.Wpxmzn7tz8"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:user-agent:in-reply-to
         :references:mime-version:content-type;
        bh=kYIPzMeU5E4tRffxGMU53TU4bLM4FDaUPYMo397SZ4M=;
        b=ztFO95BjinOAnVLI6TFPdTmqznEO/ZD6XNCAE8G1umK8s4ILXE7QOJkDrD0nHJWITA
         TqMQwwbimGvaJOR7FJu+z0vU7GD70JSELj3NltPDGlvTV/BNnAwIQa1cXf8bTutzGu4D
         /hawQ98HpAtCjrZ7YUOlqqlW7QD5zVq9D2nUY9jDF5BFRF9TTDNB15uYPKPnwHDaNv9y
         Cv4yOqI7DyA0073NlH50AFZBn73N619Z0p9LLUp/6bVji6c1ncPbYQpq3B/x5VJtMpzK
         PTUHihmjQOtPu99QgDPmGqnsWvtgCEbTMb13pQPTW0USmM1riLhzvG4O/QqyHs0AA/+e
         Bn6w==
In-Reply-To: <20140419.202620.220041591.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--nextPart2316239.Wpxmzn7tz8
Content-Type: multipart/mixed; boundary="nextPart8337929.E7BpJIY2lc"
Content-Transfer-Encoding: quoted-printable

This is a multi-part message in MIME format.

=2D-nextPart8337929.E7BpJIY2lc
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sat, 19 Apr 2014 20:26:20 Ryusuke Konishi wrote:
> Yes, I agree.  nilfs_cleanerd should statically link libnilfs and
> libnilfsgc.  I am searching the way to do that.

So far I was able to do it with corrected patch (attached).
I hope this time I got it right... Apologies for inconvenience...

=2D- 
Best wishes,
 Dmitry Smirnov.

=2D-nextPart8337929.E7BpJIY2lc
Content-Disposition: attachment; filename="fhs.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="fhs.patch"

Last-Update: 2014-04-19
Forwarded: yes
Author: Dmitry Smirnov <onlyjob-IGUgQLVVQiRCV4ILt04nZQ@public.gmane.org>
Description: install nilfs-* executables to /usr/sbin:
 Fixes the following problems (thanks, `adequate`):
  bin-or-sbin-binary-requires-usr-lib-library
    /sbin/nilfs-clean => /usr/lib/x86_64-linux-gnu/libnilfscleaner.so.0
    /sbin/nilfs-clean => /usr/lib/x86_64-linux-gnu/libnilfs.so.0
    /sbin/nilfs-resize => /usr/lib/x86_64-linux-gnu/libnilfs.so.0
    /sbin/nilfs-resize => /usr/lib/x86_64-linux-gnu/libnilfsgc.so.0
    /sbin/nilfs-tune => /usr/lib/x86_64-linux-gnu/libnilfs.so.0
    /sbin/nilfs_cleanerd => /usr/lib/x86_64-linux-gnu/libnilfs.so.0
    /sbin/nilfs_cleanerd => /usr/lib/x86_64-linux-gnu/libnilfsgc.so.0

=2D-- a/configure.ac
+++ b/configure.ac
@@ -165,9 +165,12 @@
 AC_SYS_LARGEFILE
 
 # Install directories
 AC_PREFIX_DEFAULT([/usr])
=2DAC_SUBST([sbindir], [/sbin])
+test "x$prefix" = "xNONE" && prefix="/usr"
+test "x$exec_prefix" = "xNONE" && exec_prefix="${prefix}"
+AC_SUBST([root_sbindir], [/sbin])
+AC_SUBST([sbindir], [${exec_prefix}/sbin])
 AC_SUBST([sysconfdir], [/etc])
 AC_SUBST([localstatedir], [/var])
 
 AC_CONFIG_FILES([Makefile
=2D-- a/sbin/mkfs/Makefile.am
+++ b/sbin/mkfs/Makefile.am
@@ -5,9 +5,9 @@
 LDADD = -luuid $(LIB_BLKID) $(top_builddir)/lib/libnilfsfeature.la \
 	$(top_builddir)/lib/libmountchk.la \
 	$(top_builddir)/lib/libcrc32.la
 
=2Dsbin_PROGRAMS = mkfs.nilfs2
+root_sbin_PROGRAMS = mkfs.nilfs2
 
 mkfs_nilfs2_SOURCES = mkfs.c bitops.c mkfs.h
 
 EXTRA_DIST = .gitignore
=2D-- a/sbin/mount/Makefile.am
+++ b/sbin/mount/Makefile.am
@@ -10,9 +10,9 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include
 LDADD = $(top_builddir)/lib/librealpath.la \
 	$(top_builddir)/lib/libcleanerexec.la $(LIB_MOUNT) $(LIB_SELINUX)
 
=2Dsbin_PROGRAMS = mount.nilfs2 umount.nilfs2
+root_sbin_PROGRAMS = mount.nilfs2 umount.nilfs2
 
 if CONFIG_LIBMOUNT
 
 COMMONSOURCES += mount_attrs.c
=2D-- a/sbin/cleanerd/Makefile.am
+++ b/sbin/cleanerd/Makefile.am
@@ -1,7 +1,8 @@
 ## Makefile.am
 
=2Dsbin_PROGRAMS = nilfs_cleanerd
+root_sbin_PROGRAMS = nilfs_cleanerd
+AM_LDFLAGS = -static
 LDADD = $(top_builddir)/lib/libnilfs.la $(top_builddir)/lib/libnilfsgc.la \
 	$(LIB_POSIX_MQ) -luuid
 
 nilfs_cleanerd_SOURCES = cleanerd.c cldconfig.c \

=2D-nextPart8337929.E7BpJIY2lc--
This is a multi-part message in MIME format.

--nextPart8337929.E7BpJIY2lc
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sat, 19 Apr 2014 20:26:20 Ryusuke Konishi wrote:
> Yes, I agree.  nilfs_cleanerd should statically link libnilfs and
> libnilfsgc.  I am searching the way to do that.

So far I was able to do it with corrected patch (attached).
I hope this time I got it right... Apologies for inconvenience...

-- 
Best wishes,
 Dmitry Smirnov.

--nextPart8337929.E7BpJIY2lc
Content-Disposition: attachment; filename="fhs.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="fhs.patch"

Last-Update: 2014-04-19
Forwarded: yes
Author: Dmitry Smirnov <onlyjob-IGUgQLVVQiRCV4ILt04nZQ@public.gmane.org>
Description: install nilfs-* executables to /usr/sbin:
 Fixes the following problems (thanks, `adequate`):
  bin-or-sbin-binary-requires-usr-lib-library
    /sbin/nilfs-clean => /usr/lib/x86_64-linux-gnu/libnilfscleaner.so.0
    /sbin/nilfs-clean => /usr/lib/x86_64-linux-gnu/libnilfs.so.0
    /sbin/nilfs-resize => /usr/lib/x86_64-linux-gnu/libnilfs.so.0
    /sbin/nilfs-resize => /usr/lib/x86_64-linux-gnu/libnilfsgc.so.0
    /sbin/nilfs-tune => /usr/lib/x86_64-linux-gnu/libnilfs.so.0
    /sbin/nilfs_cleanerd => /usr/lib/x86_64-linux-gnu/libnilfs.so.0
    /sbin/nilfs_cleanerd => /usr/lib/x86_64-linux-gnu/libnilfsgc.so.0

--- a/configure.ac
+++ b/configure.ac
@@ -165,9 +165,12 @@
 AC_SYS_LARGEFILE
 
 # Install directories
 AC_PREFIX_DEFAULT([/usr])
-AC_SUBST([sbindir], [/sbin])
+test "x$prefix" = "xNONE" && prefix="/usr"
+test "x$exec_prefix" = "xNONE" && exec_prefix="${prefix}"
+AC_SUBST([root_sbindir], [/sbin])
+AC_SUBST([sbindir], [${exec_prefix}/sbin])
 AC_SUBST([sysconfdir], [/etc])
 AC_SUBST([localstatedir], [/var])
 
 AC_CONFIG_FILES([Makefile
--- a/sbin/mkfs/Makefile.am
+++ b/sbin/mkfs/Makefile.am
@@ -5,9 +5,9 @@
 LDADD = -luuid $(LIB_BLKID) $(top_builddir)/lib/libnilfsfeature.la \
 	$(top_builddir)/lib/libmountchk.la \
 	$(top_builddir)/lib/libcrc32.la
 
-sbin_PROGRAMS = mkfs.nilfs2
+root_sbin_PROGRAMS = mkfs.nilfs2
 
 mkfs_nilfs2_SOURCES = mkfs.c bitops.c mkfs.h
 
 EXTRA_DIST = .gitignore
--- a/sbin/mount/Makefile.am
+++ b/sbin/mount/Makefile.am
@@ -10,9 +10,9 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include
 LDADD = $(top_builddir)/lib/librealpath.la \
 	$(top_builddir)/lib/libcleanerexec.la $(LIB_MOUNT) $(LIB_SELINUX)
 
-sbin_PROGRAMS = mount.nilfs2 umount.nilfs2
+root_sbin_PROGRAMS = mount.nilfs2 umount.nilfs2
 
 if CONFIG_LIBMOUNT
 
 COMMONSOURCES += mount_attrs.c
--- a/sbin/cleanerd/Makefile.am
+++ b/sbin/cleanerd/Makefile.am
@@ -1,7 +1,8 @@
 ## Makefile.am
 
-sbin_PROGRAMS = nilfs_cleanerd
+root_sbin_PROGRAMS = nilfs_cleanerd
+AM_LDFLAGS = -static
 LDADD = $(top_builddir)/lib/libnilfs.la $(top_builddir)/lib/libnilfsgc.la \
 	$(LIB_POSIX_MQ) -luuid
 
 nilfs_cleanerd_SOURCES = cleanerd.c cldconfig.c \

--nextPart8337929.E7BpJIY2lc--

--nextPart2316239.Wpxmzn7tz8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABCAAGBQJTUmIhAAoJEFK2u9lTlo0bJEsQAL6lVfij2jdPbwn/ojq55hIr
/SURY36KXymBrE5dxDqlGq+IjrF7Kex4u7EKte0p6zNl9jhb7oIYHWf4byZP3QyS
JmZd0QXOlnC0B6ORKT6lZLIihnuSWkoZDVA5Wh304n1j5ZHoxtmV2EI6XJ+U7I+p
uNn4DwLJuEIL0ve/JW7MakFfkls0+dbAlk6zdAFot3yyLDpelL15IBmeEdtgLvwG
rt1iqHaNtptXLROoXwq5s2RgPuOW3VteGHTgFvFVTKttfTmjtdF+wB1G+UqL9jXi
HghARq2KC0zREeJUSMRoEQzbgR8cvmUgOv4cMrKIjqME1VgIO9MoU8AHtylk9BZg
3rd8wENzZTEXR2BKRVjC1jbC0yOcdedmG+LCph+h7ws7wHlm9eb5sXV/cBSK0eKv
Tm6PrcM5m6d9lovoZEuCYRFb8Csy3OO+C5WBAdd2/S5xKTW4XYtz2XHRop+MLNT4
TmZVu6+MX8vK0bm4zyiwn3JVk+Br+0C9PfEjuOOZ2r4IL5BYk3qI+duH6cX66IvN
+1tTi4aEClcfOrag/sVuDn5UJPkMTHp7lCdDh43FscUIuZuDUCDZUbdVizcJhmYw
/2ScJTne4Km1xJtkWpkCfYOxZgbrY9QQUvHRdLKwIfbXjqSh/gXmJX8V4PZHlOZ8
bi4zlblccx7fgmYV9W/V
=X0eo
-----END PGP SIGNATURE-----

--nextPart2316239.Wpxmzn7tz8--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
