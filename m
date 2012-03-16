From: =?iso-8859-1?Q?Sven-G=F6ran_Bergh?= <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: RE: nilfs_cleanerd Function not implemented
Date: Fri, 16 Mar 2012 07:21:39 -0700 (PDT)
Message-ID: <1331907699.90830.YahooMailNeo@web161901.mail.bf1.yahoo.com>
References: <1331899533.77663.YahooMailNeo@web161902.mail.bf1.yahoo.com> <1675589.uo1ijo0JER@coil>
Reply-To: =?iso-8859-1?Q?Sven-G=F6ran_Bergh?= <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1331907699; bh=XO0dDXBilSIl2/YNilEHLlW62S93P3c66nU9+HOHBtw=; h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding; b=ByGuDMrDUwFmWkN2hS1x1eDi1whmktF2vae/085uvu5KEHtMhfqMl33jEZ7egfxRNztx+XBw6IXBCCwbPvEk/9ok2TlT6Mc+Ev0cRICP44XMabR6cBd0gfN/5ZOZrrfoTeeWxi8D9oTXXzPVc23y0mnlSXOATRUFV9PE4ML7cYk=
In-Reply-To: <1675589.uo1ijo0JER@coil>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi dexen,

thank you for a prompt reply.



>>  I am in the process of migrating an embedded project from
>>  ext2 to nilfs2 and have a problem with nilfs_cleanerd. It
>>  does not start on mount and I cannot start it manually.
>>  (...)
>=20
> I'd suspect futex() or open(..., O_RDWR|O_NOFOLLOW). Do you have=20
> `CONFIG_FUTEX' enabled in your embedded kernel?

Yes, futex is enabled.
# zcat /proc/config.gz | grep CONFIG_FUTEX
CONFIG_FUTEX=3Dy

> Relevant snippet from strace of my nilfs_cleanerd (version nilfs-
> utils-2.0.23):
=2E..
> 864=A0  statfs("/dev/shm", {f_type=3D0x1021994, f_bsize=3D4096,=20
> f_blocks=3D86016,=20
> f_bfree=3D86010, f_bavail=3D86010, f_files=3D754077, f_ffree=3D754075=
, f_fsid=3D{0, 0},=20
> f_namelen=3D255, f_frsize=3D4096}
> ) =3D 0
> 864=A0  futex(0x7f551010d31c, FUTEX_WAKE_PRIVATE, 2147483647) =3D 0
> 864=A0  open("/dev/shm/sem.nilfs-cleaner-2067", O_RDWR|O_NOFOLLOW) =3D=
 -1=20
> ENOENT=20
> (No such file or directory)
> 864=A0  lstat("/dev/shm/sem.qLTneb", 0x7fffff54fb70) =3D -1 ENOENT (N=
o=20
> such file or=20
> directory)
> 864=A0  open("/dev/shm/sem.qLTneb", O_RDWR|O_CREAT|O_EXCL, 0700) =3D =
6

Hmmm, quite different.

> Btw., you may not be seeing the failed (with `Function not implemente=
d')=20
> syscall in strace, if the libc itself signals the `Function not imple=
mented'=20
> error instead of issuing the syscall. Consider using ``ltrace'' inste=
ad,=20
> to intercept all lib calls.

I cannot get any clues from ltrace either:

# ltrace -f /sbin/nilfs_cleanerd /dev/sdb1
__libc_start_main(0x804c20b, 2, 0xbfc16354, 0x804dcd0, 0x804dcc0 <unfin=
ished ...>
strrchr("/sbin/nilfs_cleanerd", '/')=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D "/nilfs_cleanerd"
strrchr("/sbin/nilfs_cleanerd", '/')=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D "/nilfs_cleanerd"
getopt_long(2, 0xbfc16354, "c:hnp:V", 0x804de20, 0xbfc1528c)=A0=A0=A0 =3D=
 -1
myrealpath(0xbfc16c5c, 0xbfc15296, 4098, 0x804de20, 0xbfc1528c) =3D 0xb=
fc15296
strdup("/dev/sdb1")=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 =3D 0x9268008
fork( <unfinished ...>
[pid 3534] --- SIGSTOP (Stopped (signal)) ---
[pid 3534] --- SIGSTOP (Stopped (signal)) ---
[pid 3533] <... fork resumed> )=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 3534
[pid 3533] --- SIGCHLD (Child exited) ---
[pid 3533] _exit(0 <unfinished ...>
[pid 3533] +++ exited (status 0) +++
+++ exited (status 1) +++


BTW: CONFIG_SHMEM is not enabled:
# zcat /proc/config.gz | grep CONFIG_SHMEM
# CONFIG_SHMEM is not set

Is it needed? I am a bit confused by the kernel help text:
"...Disabling this
option replaces shmem and tmpfs with the much
simpler ramfs code,
which may be appropriate on small systems
without swap."

=2E..wait a moment...

I just recompiled the kernel with CONFIG_SHMEM enabled,
but no success. Same result as before :-(

What caught my attention in the first strace was:

sendto(-1218631408, umovestr: Input/output error

It happens before the futex call and to me the socketfd
(-1218631408) seems invalid. Just a wild shot...

/S-G

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
