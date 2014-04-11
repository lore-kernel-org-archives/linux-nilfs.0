From: Dmitry Smirnov <onlyjob-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: few patches from Debian
Date: Fri, 11 Apr 2014 17:49:43 +1000
Message-ID: <2256155.lyPQvkPv8r@debstor>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3359638.p83WGOJCq4"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:subject:date:message-id:user-agent:mime-version
         :content-type;
        bh=ZkjgFrKwfAYKNnzzdRwPdEGNJwpq1iJVm343953zZEo=;
        b=mUhtNPWAlz37RTP1JHN0eroLmiX0JjS/N6dOJmwWN29VUEfo1l84r3VGbLGwUlYU03
         P8VbELKwvqClptRy7Z1c2t+n5EFRANTX+vqs4lI++fUbrt6adVZWigFE5H3o6TRchUWi
         eU1YhcVDkMo6gzdCnqtUPOmpzA0N0XVFmUTDt0lRaU7WlT+zQqDNI0pZjTIvKmRS4VHO
         gdXnXs6vKEq5rUgAhKTSLHmimq5OD0EaLMmZtrwFCctuD5Gmgd0FQW8Ku4TdEdvEmGJt
         4CSeW11fFXGgOKXmmgsjvHo/0PggYFN8R2MdL/8HnG84WG0YEwLNJ7y+xQviTAhAYUfj
         XmLw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--nextPart3359638.p83WGOJCq4
Content-Type: multipart/mixed; boundary="nextPart2933964.7gAWMFQZoV"
Content-Transfer-Encoding: quoted-printable

This is a multi-part message in MIME format.

=2D-nextPart2933964.7gAWMFQZoV
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Dear NILFS team,

Thanks for your hard work and for new release of nilfs-tools.

I'd like to share two patches (attached) to fix some minor problems that I've 
noticed:

 * man.patch (with minor man pages corrections)
 * fhs.patch (to install nilfs-* executables to "/usr/sbin" instead of "/sbin"
   due to library dependencies in "/usr").

Please review and apply (if appropriate).
Also please CC to me as I'm not subscribed.

Thank you.

=2D- 
All the best,
 Dmitry Smirnov
 GPG key : 4096R/53968D1B

=2D-nextPart2933964.7gAWMFQZoV
Content-Disposition: attachment; filename="fhs.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="fhs.patch"

Last-Update: 2014-04-11
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
@@ -165,9 +165,10 @@
 AC_SYS_LARGEFILE
 
 # Install directories
 AC_PREFIX_DEFAULT([/usr])
=2DAC_SUBST([sbindir], [/sbin])
+AC_SUBST([root_sbindir], [/sbin])
+AC_SUBST([sbindir], [${prefix}/sbin])
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

=2D-nextPart2933964.7gAWMFQZoV
Content-Disposition: attachment; filename="man.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="man.patch"

Last-Update: 2014-04-11
Forwarded: yes
Author: Dmitry Smirnov <onlyjob-IGUgQLVVQiRCV4ILt04nZQ@public.gmane.org>
Description: minor man pages lintianisation
 spelling-error-in-manpage
 hyphen-used-as-minus-sign

=2D-- a/man/nilfs-clean.8
+++ b/man/nilfs-clean.8
@@ -19,9 +19,9 @@
 sent to and performed on the \fBnilfs_cleanerd\fP(8) program.  If no
 commands are specified, \fBnilfs-clean\fP just triggers a one-pass
 cleaning.
 .PP
=2DWhen \fIdevice\fP is ommitted, \fBnilfs-clean\fP selects an active
+When \fIdevice\fP is omitted, \fBnilfs-clean\fP selects an active
 NILFS2 file system in the system.
 .PP
 This command is valid only for mounted NILFS2 file systems, and
 will fail if the \fIdevice\fP has no active mounts.
=2D-- a/man/umount.nilfs2.8
+++ b/man/umount.nilfs2.8
@@ -41,9 +41,9 @@
 Verbose mode.
 .SH THE LOOP DEVICE
 .B umount.nilfs2
 will free the loop device (if any) associated with the mount, in case
=2Dit finds the option `loop=...' in \fI/etc/mtab\fP.  The -d option,
+it finds the option `loop=...' in \fI/etc/mtab\fP.  The \-d option,
 which also allows \fBumount\fP(8) to free the loop device without the
 `loop=...' option, is not supported.
 .SH AUTHOR
 .B umount.nilfs2

=2D-nextPart2933964.7gAWMFQZoV--
This is a multi-part message in MIME format.

--nextPart2933964.7gAWMFQZoV
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Dear NILFS team,

Thanks for your hard work and for new release of nilfs-tools.

I'd like to share two patches (attached) to fix some minor problems that I've 
noticed:

 * man.patch (with minor man pages corrections)
 * fhs.patch (to install nilfs-* executables to "/usr/sbin" instead of "/sbin"
   due to library dependencies in "/usr").

Please review and apply (if appropriate).
Also please CC to me as I'm not subscribed.

Thank you.

-- 
All the best,
 Dmitry Smirnov
 GPG key : 4096R/53968D1B

--nextPart2933964.7gAWMFQZoV
Content-Disposition: attachment; filename="fhs.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="fhs.patch"

Last-Update: 2014-04-11
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
@@ -165,9 +165,10 @@
 AC_SYS_LARGEFILE
 
 # Install directories
 AC_PREFIX_DEFAULT([/usr])
-AC_SUBST([sbindir], [/sbin])
+AC_SUBST([root_sbindir], [/sbin])
+AC_SUBST([sbindir], [${prefix}/sbin])
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

--nextPart2933964.7gAWMFQZoV
Content-Disposition: attachment; filename="man.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="man.patch"

Last-Update: 2014-04-11
Forwarded: yes
Author: Dmitry Smirnov <onlyjob-IGUgQLVVQiRCV4ILt04nZQ@public.gmane.org>
Description: minor man pages lintianisation
 spelling-error-in-manpage
 hyphen-used-as-minus-sign

--- a/man/nilfs-clean.8
+++ b/man/nilfs-clean.8
@@ -19,9 +19,9 @@
 sent to and performed on the \fBnilfs_cleanerd\fP(8) program.  If no
 commands are specified, \fBnilfs-clean\fP just triggers a one-pass
 cleaning.
 .PP
-When \fIdevice\fP is ommitted, \fBnilfs-clean\fP selects an active
+When \fIdevice\fP is omitted, \fBnilfs-clean\fP selects an active
 NILFS2 file system in the system.
 .PP
 This command is valid only for mounted NILFS2 file systems, and
 will fail if the \fIdevice\fP has no active mounts.
--- a/man/umount.nilfs2.8
+++ b/man/umount.nilfs2.8
@@ -41,9 +41,9 @@
 Verbose mode.
 .SH THE LOOP DEVICE
 .B umount.nilfs2
 will free the loop device (if any) associated with the mount, in case
-it finds the option `loop=...' in \fI/etc/mtab\fP.  The -d option,
+it finds the option `loop=...' in \fI/etc/mtab\fP.  The \-d option,
 which also allows \fBumount\fP(8) to free the loop device without the
 `loop=...' option, is not supported.
 .SH AUTHOR
 .B umount.nilfs2

--nextPart2933964.7gAWMFQZoV--

--nextPart3359638.p83WGOJCq4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABCAAGBQJTR56bAAoJEFK2u9lTlo0b0swP/j11veZ0TQWejV113qsWQdEO
2NYJNx450VuSbBpslrhgEXcZ/b2TsnG0Ss5L7XJICMidJwr3VRFtw2f7KAgdvCZ6
2efDfqePQGxVE/BtGkafZ5YE5wFDQeDOCD9N7kvJCZDhuG8+zs+wHExC6xZJPC7y
YzYhVjYv7nsVWOHFdGHFN7r4BlR+4SrWaZSmaTLUR16TNNIw8kabZp3ohVNDe407
Uwp84W8EsUpzRzUM5c8A/U4i2KcCtPZf4R3+zBbYCJVFQiJQzKd2TyHGFrIP4GR/
XyFs4f0OSMbTpbpfirGvZUyfrOHsBFjJE8zPbreY8zZ+7jWsCeewSjBUhtm5aSWE
kpV1vlZ7Z6RxywxetKDWGH+GypYfB2tF2ECwixuSEzRvR2eRudV1mLLCsFP+vmfB
oqDxq2Ha2yLMoUprSIIkWqdg2yZTAdhu/PD3DqhPpytFusJC+b2hUC3AiX41rNxH
qnFUbKQos27wcOvVv7E/XpgKsBsQhWx3Vu3Jq+w7Rx7MqoKJOmk0zZngw5IWo25A
olp86Gp8lniQyjERBegmIRc8KcT+JbkEU9KQ6c7bk9FIHwZCdL4tBqIgqoygbxw+
meDcHjnSXwsA311Ax8qCysETg1TZwuEnKSWh6FfWx3v4pp4TGAUr7AbTPHgIT19I
O5bQWrZI5aVw1t//I+3N
=vY6T
-----END PGP SIGNATURE-----

--nextPart3359638.p83WGOJCq4--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
