From: Dmitry Smirnov <onlyjob-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Re: few patches from Debian
Date: Wed, 16 Apr 2014 11:22:48 +1000
Message-ID: <6284364.q7fsBQ3iYY@debstor>
References: <2256155.lyPQvkPv8r@debstor> <20140414.063654.356443912.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2397988.yARC6T1g7r"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:user-agent:in-reply-to
         :references:mime-version:content-type;
        bh=i3HceKVmmRFqQtRsTPaufiegZPSP2zTDbJ7PS8Iy9+c=;
        b=SiGurl+ASqdTjSLmVdNJM+VLn6vMnIoPUJkztKDfB8pyishTjH1on+h8V4zTauZUCs
         sgvRXKx7aCwOl2Ays6fDUyo4ZTeaMyUnsxGq7ofFYGIg0XjwNhOlcmz7x6fboT4uJf5o
         gZWTKdGN43/Yi2vMPrWiKjHz5YLvx2N+Tpge9BDXFB69XGt0W7wojv+qBfHV/HBf0BFK
         zHun/kt+n91JCKDuRnZ8S9oWGA1qdhK6WnpF/b4U9X99PlKJDS7gKZ0gEeU31xRV/bf5
         rM/ZDfbP1XXBta7VNJMLL5pBujSHuWQAhB+BdXfkQIrquo4lkYbPXrG7pfGP/dPGXcsH
         sMoA==
In-Reply-To: <20140414.063654.356443912.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--nextPart2397988.yARC6T1g7r
Content-Type: multipart/mixed; boundary="nextPart8644279.qaQxpZWPAB"
Content-Transfer-Encoding: quoted-printable

This is a multi-part message in MIME format.

=2D-nextPart8644279.qaQxpZWPAB
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Mon, 14 Apr 2014 06:36:54 Ryusuke Konishi wrote:
> fhs.patch introduced the following error:
> 
>  $ ./autogen.sh
>  $ ./configure
>  $ make
>  $ sudo make install
>  ...
>  make[2]: Entering directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
>  make[3]: Entering directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
>   /bin/mkdir -p '/etc'
>   /usr/bin/install -c -m 644 nilfs_cleanerd.conf '/etc'
>   /bin/mkdir -p 'NONE/sbin'
>    /bin/sh ../../libtool   --mode=install /usr/bin/install -c nilfs_cleanerd
> 'NONE/sbin' libtool: install: `NONE/sbin' must be an absolute directory
> name
>  libtool: install: Try `libtool --help --mode=install' for more information.
> make[3]: *** [install-sbinPROGRAMS] Error 1
>  make[3]: Leaving directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
>  make[2]: *** [install-am] Error 2
>  make[2]: Leaving directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
>  make[1]: *** [install-recursive] Error 1
>  make[1]: Leaving directory `/home/ryusuke/git/nilfs-utils/sbin'
>  make: *** [install-recursive] Error 1
> 
> Can you fix this error ?

O, my bad, sorry...
Strangely enough I did not hit this error because I was explicitly passing
"--prefix=/usr" to "./configure".

Please find updated patch attached. It should be fine but there might be more 
elegant way to implement this with autotools.

By the way it's pretty scary to do 

    sudo make install

I'd rather invoke as (for example) as:

    make install DESTDIR=/tmp/nilfs-tools.test

Thank you.

=2D- 
Regards,
 Dmitry Smirnov.

=2D-nextPart8644279.qaQxpZWPAB
Content-Disposition: attachment; filename="fhs.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="fhs.patch"

Last-Update: 2014-04-16
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

=2D-nextPart8644279.qaQxpZWPAB--
This is a multi-part message in MIME format.

--nextPart8644279.qaQxpZWPAB
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Mon, 14 Apr 2014 06:36:54 Ryusuke Konishi wrote:
> fhs.patch introduced the following error:
> 
>  $ ./autogen.sh
>  $ ./configure
>  $ make
>  $ sudo make install
>  ...
>  make[2]: Entering directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
>  make[3]: Entering directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
>   /bin/mkdir -p '/etc'
>   /usr/bin/install -c -m 644 nilfs_cleanerd.conf '/etc'
>   /bin/mkdir -p 'NONE/sbin'
>    /bin/sh ../../libtool   --mode=install /usr/bin/install -c nilfs_cleanerd
> 'NONE/sbin' libtool: install: `NONE/sbin' must be an absolute directory
> name
>  libtool: install: Try `libtool --help --mode=install' for more information.
> make[3]: *** [install-sbinPROGRAMS] Error 1
>  make[3]: Leaving directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
>  make[2]: *** [install-am] Error 2
>  make[2]: Leaving directory `/home/ryusuke/git/nilfs-utils/sbin/cleanerd'
>  make[1]: *** [install-recursive] Error 1
>  make[1]: Leaving directory `/home/ryusuke/git/nilfs-utils/sbin'
>  make: *** [install-recursive] Error 1
> 
> Can you fix this error ?

O, my bad, sorry...
Strangely enough I did not hit this error because I was explicitly passing
"--prefix=/usr" to "./configure".

Please find updated patch attached. It should be fine but there might be more 
elegant way to implement this with autotools.

By the way it's pretty scary to do 

    sudo make install

I'd rather invoke as (for example) as:

    make install DESTDIR=/tmp/nilfs-tools.test

Thank you.

-- 
Regards,
 Dmitry Smirnov.

--nextPart8644279.qaQxpZWPAB
Content-Disposition: attachment; filename="fhs.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="fhs.patch"

Last-Update: 2014-04-16
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

--nextPart8644279.qaQxpZWPAB--

--nextPart2397988.yARC6T1g7r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABCAAGBQJTTdttAAoJEFK2u9lTlo0buhEQAJ0/RLGOUWCbsnlC+jhgdkGv
W5Lr2tCYYcp+LUlvSCX2dO9XmmTjrXRDTCG/pHrnfGaqujB1xE7uBxs+jwFwjdIS
Q6/aq2bpsju1azFTprkrt9SS38PjM8N1Yy0KCLLEpyz6EgFs1iqCAhFwkdCUcYYK
LD2NB6RGmufY+XoiG2bMC9aRfGxxVyA2l7CoZZJ7GIqbJm9FBfbwbdN25KkgnJCm
GpZohtf8WxGR1j+hHk5UvkV7QugaVuSypEaUY+Sep8Of6i87mGvjbOgIDIxBzvkJ
8jSIKpp+3tLBJqf/ODAHpQ1p0oqW+3zG1r+B7L/Xc1YXADM7Km0zsgOt3PCkN5EQ
1sSx+6KGVB3pZerbNA0+AY/RMi0GxxoXW0HEUeOTKEfhcl2Yj32QJCfFbKIpiaTL
EWpWOw1qFirVnnH1BvGGoIXWVMo+0ibLtclWZg5q27Qv/BkijgkDQuWKvPoOlI9u
GkXNfzWiQ6gAOVC2qmENQz+dXAvOND9e6j3AcM31MQm2BC1Lae4UK4klMrebUlax
Sg0PefhX7i6s5a3LE8nacYXajteW9ETWUBaYNqRiOWsBgBJbNgrd0xbHfs0tlHAN
5lVUqih2Y/yCHGZkTzLGZsFB9kbOn3QJmMzEZL1rZZHNRVWurvpfQR3DAN82GSZg
nHN6CAXPLOCAJcypoCrw
=TjQe
-----END PGP SIGNATURE-----

--nextPart2397988.yARC6T1g7r--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
