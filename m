From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] libmount, libblkid: use PKG_CHECK_MODULES for probing
Date: Wed, 24 Jan 2018 01:26:53 +0900
Message-ID: <CAKFNMon+J02xT+qn5cq7f=e5BczCZXTopzP5L2+d7HxEzUX=Ow@mail.gmail.com>
References: <1516655654-12684-1-git-send-email-dev.kurt@vandijck-laurijssen.be>
 <CAKFNMo=ZwtT0A8mC9YuO8Ei7WHa9QHTm52pTpPS=BOk7+TOaOw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=btEweKNXdBr5uFvCsw3dtSm5fcSBZTKfP0vzdsMufqY=;
        b=lEuorrT1HQM/3MArTvKXO3sVWrfujP830C1l5cQAiuIROL9oPnn/KMRqv3k82/BoQU
         p2ZP6lKUrT8XcsX1RMWiREix2rI6aujTneClhlMvcc2R+EMfNp7vAYqB/cJYR9X6jdKF
         7YzUW7cwSYGVHglbHBJUahaDdZq571uVDNDweXLIHFwvFxDncmIhopW5HlNKnycw0QJ4
         CVclnWaeDRqL5fEG+7+Ku3/ZR1Kxj6BCX6rt2RB/9zJjfcMmwrKZjC0wuHTGVlSz9zzX
         WJ4XySomwzE/UvZrM7P5tYTE9i6PTodGtwIZrTaTdJ9BoTCQXevL5fRWe4YBXu9TLryz
         QRDw==
In-Reply-To: <CAKFNMo=ZwtT0A8mC9YuO8Ei7WHa9QHTm52pTpPS=BOk7+TOaOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch induced the following warnings.   Look like mount_attrs.c
needs to be changed as well.

gcc -std=3Dgnu99 -DHAVE_CONFIG_H -I. -I../..  -I../../include  -Wall
-I/usr/include/libmount -I/usr/include/blkid -I/usr/include/uuid   -g
-O2 -MT mount_attrs.o -MD -MP -MF .deps/mount_attrs.Tpo -c -o
mount_attrs.o mount_attrs.c
mount_attrs.c: In function =E2=80=98nilfs_mount_attrs_parse=E2=80=99:
mount_attrs.c:82:2: warning: implicit declaration of function
=E2=80=98mnt_optstr_next_option=E2=80=99 [-Wimplicit-function-declaration]
  while (!mnt_optstr_next_option(&p, &name, &namesz, &val, &valsz)) {
  ^
mount_attrs.c:117:4: warning: implicit declaration of function
=E2=80=98mnt_optstr_append_option=E2=80=99 [-Wimplicit-function-declaration=
]
    res =3D mnt_optstr_append_option(rest, prev, NULL);
    ^
mount_attrs.c: In function =E2=80=98nilfs_mount_attrs_update=E2=80=99:
mount_attrs.c:168:2: warning: implicit declaration of function
=E2=80=98mnt_context_get_fs=E2=80=99 [-Wimplicit-function-declaration]
  fs =3D mnt_context_get_fs(cxt);
  ^
mount_attrs.c:168:5: warning: assignment makes pointer from integer
without a cast [enabled by default]
  fs =3D mnt_context_get_fs(cxt);
     ^
mount_attrs.c:169:2: warning: implicit declaration of function
=E2=80=98mnt_fs_set_attributes=E2=80=99 [-Wimplicit-function-declaration]
  mnt_fs_set_attributes(fs, NULL);
  ^
mount_attrs.c:174:3: warning: implicit declaration of function
=E2=80=98mnt_fs_append_attributes=E2=80=99 [-Wimplicit-function-declaration=
]
   mnt_fs_append_attributes(fs, NOGCOPT_NAME);
   ^

Thanks,
Ryusuke Konishi


2018-01-23 9:44 GMT+09:00 Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>:
> 2018-01-23 6:14 GMT+09:00 Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org=
>:
>> After a round to add this to buildroot, I learned that
>> the proper way to check the dependencies seems to point to pkg-config.
>> This commit migrates the libmount & libblkid checks to use PKG_CHECK_MOD=
ULES.
>> I added a similar patch to current buildroot, and this succeeds
>> all daily tests as well.
>>
>> Signed-off-by: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
>
> Thank you again.   Will review later.
>
> Regards,
> Ryusuke Konishi
>
>> ---
>>  configure.ac                 | 13 +++----------
>>  sbin/Makefile.am             |  3 ++-
>>  sbin/mkfs.c                  |  6 +++---
>>  sbin/mount/Makefile.am       |  4 ++--
>>  sbin/mount/mount_libmount.c  |  4 +---
>>  sbin/mount/umount_libmount.c |  4 +---
>>  6 files changed, 12 insertions(+), 22 deletions(-)
>>
>> diff --git a/configure.ac b/configure.ac
>> index c92d1c5..6a824f2 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -106,27 +106,20 @@ fi
>>
>>  # Check for conditional libraries and headers.
>>  if test "${with_blkid}" =3D "yes"; then
>> -   AC_CHECK_LIB(blkid, blkid_new_probe_from_filename,
>> +   PKG_CHECK_MODULES([BLKID], [blkid],
>>                 [AC_DEFINE(HAVE_LIBBLKID, 1,
>>                     [Define to 1 if you have the 'blkid' library (-lblki=
d).])
>> -                LIB_BLKID=3D"-lblkid -luuid"
>> -               ],
>> -               AC_MSG_ERROR([BLKID library not found]), [-luuid])
>> -   AC_CHECK_HEADERS([blkid/blkid.h])
>> +               ])
>>  fi
>> -AC_SUBST(LIB_BLKID)
>>
>>  if test "${with_libmount}" =3D "yes"; then
>>     if test "$mtab_type" =3D file; then
>>        AC_MSG_WARN([Use --without-libmount option to generate mount help=
ers that work with the legacy mtab file.])
>>     fi
>> -   AC_CHECK_LIB(mount, mnt_context_do_mount, [LIB_MOUNT=3D"-lmount $LIB=
_BLKID"],
>> -       AC_MSG_ERROR([Mount library is enabled but libmount not found]),=
 [$LIB_BLKID])
>> -   AC_CHECK_HEADERS([libmount/libmount.h])
>> +   PKG_CHECK_MODULES([MOUNT], [mount])
>>     with_selinux=3Dno
>>  fi
>>  AM_CONDITIONAL(CONFIG_LIBMOUNT, [test "$with_libmount" =3D "yes"])
>> -AC_SUBST(LIB_MOUNT)
>>
>>  if test "${with_selinux}" =3D "yes"; then
>>     AC_CHECK_LIB(selinux, getprevcon,
>> diff --git a/sbin/Makefile.am b/sbin/Makefile.am
>> index 7729166..4eac742 100644
>> --- a/sbin/Makefile.am
>> +++ b/sbin/Makefile.am
>> @@ -10,7 +10,8 @@ root_sbin_PROGRAMS =3D mkfs.nilfs2 nilfs_cleanerd
>>  sbin_PROGRAMS =3D nilfs-clean nilfs-resize nilfs-tune
>>
>>  mkfs_nilfs2_SOURCES =3D mkfs.c bitops.c mkfs.h
>> -mkfs_nilfs2_LDADD =3D $(LIB_BLKID) -luuid \
>> +mkfs_nilfs2_CFLAGS =3D -Wall $(BLKID_CFLAGS)
>> +mkfs_nilfs2_LDADD =3D $(BLKID_LIBS) -luuid \
>>         $(top_builddir)/lib/libcrc32.la \
>>         $(top_builddir)/lib/libmountchk.la \
>>         $(top_builddir)/lib/libnilfsfeature.la
>> diff --git a/sbin/mkfs.c b/sbin/mkfs.c
>> index a0da7fe..95679dc 100644
>> --- a/sbin/mkfs.c
>> +++ b/sbin/mkfs.c
>> @@ -58,9 +58,9 @@
>>
>>  #include <errno.h>
>>
>> -#if HAVE_BLKID_BLKID_H
>> -#include <blkid/blkid.h>
>> -#endif /* HAVE_BLKID_BLKID_H */
>> +#if HAVE_LIBBLKID
>> +#include <blkid.h>
>> +#endif /* HAVE_LIBBLKID */
>>
>>  #include "nilfs.h"
>>  #include "mkfs.h"
>> diff --git a/sbin/mount/Makefile.am b/sbin/mount/Makefile.am
>> index f5d3c27..9554aa5 100644
>> --- a/sbin/mount/Makefile.am
>> +++ b/sbin/mount/Makefile.am
>> @@ -6,10 +6,10 @@ COMMONHEADERS =3D mount.nilfs2.h sundries.h xmalloc.h
>>  LEGACYSOURCES =3D fstab.c mount_mntent.c mount_opts.c
>>  LEGACYHEADERS =3D fstab.h mount_constants.h mount_mntent.h mount_opts.h
>>
>> -AM_CFLAGS =3D -Wall
>> +AM_CFLAGS =3D -Wall $(MOUNT_CFLAGS)
>>  AM_CPPFLAGS =3D -I$(top_srcdir)/include
>>  LDADD =3D $(top_builddir)/lib/librealpath.la \
>> -       $(top_builddir)/lib/libcleanerexec.la $(LIB_MOUNT) $(LIB_SELINUX=
) \
>> +       $(top_builddir)/lib/libcleanerexec.la $(MOUNT_LIBS) $(LIB_SELINU=
X) \
>>         $(LIB_POSIX_TIMER)
>>
>>  root_sbin_PROGRAMS =3D mount.nilfs2 umount.nilfs2
>> diff --git a/sbin/mount/mount_libmount.c b/sbin/mount/mount_libmount.c
>> index ef40e68..a7fec00 100644
>> --- a/sbin/mount/mount_libmount.c
>> +++ b/sbin/mount/mount_libmount.c
>> @@ -67,9 +67,7 @@
>>  #include <syslog.h>
>>  #endif /* HAVE_SYSLOG_H */
>>
>> -#if HAVE_LIBMOUNT_LIBMOUNT_H
>> -#include <libmount/libmount.h>
>> -#endif /* HAVE_LIBMOUNT_H */
>> +#include <libmount.h>
>>
>>  #include <stdarg.h>
>>  #include <errno.h>
>> diff --git a/sbin/mount/umount_libmount.c b/sbin/mount/umount_libmount.c
>> index ae5a337..b678f54 100644
>> --- a/sbin/mount/umount_libmount.c
>> +++ b/sbin/mount/umount_libmount.c
>> @@ -59,9 +59,7 @@
>>  #include <syslog.h>
>>  #endif /* HAVE_SYSLOG_H */
>>
>> -#if HAVE_LIBMOUNT_LIBMOUNT_H
>> -#include <libmount/libmount.h>
>> -#endif /* HAVE_LIBMOUNT_H */
>> +#include <libmount.h>
>>
>>  #include <stdarg.h>
>>  #include <errno.h>
>> --
>> 1.8.5.rc3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" i=
n
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
