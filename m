From: =?iso-8859-1?Q?Sven-G=F6ran_Bergh?= <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: RE: nilfs_cleanerd Function not implemented
Date: Mon, 19 Mar 2012 01:19:06 -0700 (PDT)
Message-ID: <1332145146.39316.YahooMailNeo@web161904.mail.bf1.yahoo.com>
References: <1331907699.90830.YahooMailNeo@web161901.mail.bf1.yahoo.com> <20120317.204343.93460664.ryusuke@osrg.net> <20120317.225320.67906283.ryusuke@osrg.net> <20120318.021740.212402053.ryusuke@osrg.net>
Reply-To: =?iso-8859-1?Q?Sven-G=F6ran_Bergh?= <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1332145146; bh=qAOGPRMccqat/mTOncRlII6QjMlWF59Z05KOx1bG7UY=; h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding; b=bQwIGtDnUbCciePz+3UIB0atVAp6MBvgqAzAEzuoo7gP3Ji0DcDcqKeMcoyFr5L7gv3W7JLbuzNrPZDYY2ZZutefdYgm2hPADAcCZPKcExFzylR7NcuzpIFnwLrBcucs4+Psrm07G9Y7wI/Paig+VV6HP0CiPcVomGWH9FsUhEM=
In-Reply-To: <20120318.021740.212402053.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Ryusuke,

thank you for your investigations.


> On Sat, 17 Mar 2012 22:53:20 +0900 (JST), Ryusuke Konishi wrote:

>>  On Sat, 17 Mar 2012 20:43:43 +0900 (JST), Ryusuke Konishi wrote:
>>  > On Fri, 16 Mar 2012 07:21:39 -0700 (PDT), Sven-G=F6ran_Bergh wrot=
e:
>>  > > Hi dexen,
>>  > >=20
>>  > > thank you for a prompt reply.
>>  > >=20
>>  > >=20
>>  > >=20
>>  > > >>=A0 I am in the process of migrating an embedded project=20
> from
>>  > > >>=A0 ext2 to nilfs2 and have a problem with nilfs_cleanerd.=20
> It
>>  > > >>=A0 does not start on mount and I cannot start it manually.
>>  > > >>=A0 (...)
>>  > > >=20
>>  > > > Relevant snippet from strace of my nilfs_cleanerd (version=20
> nilfs-
>>  > > > utils-2.0.23):
>>  > > ...
>>  > > > 864=A0=A0 statfs("/dev/shm", {f_type=3D0x1021994,=20
> f_bsize=3D4096,=20
>>  > > > f_blocks=3D86016,=20
>>  > > > f_bfree=3D86010, f_bavail=3D86010, f_files=3D754077,=20
> f_ffree=3D754075, f_fsid=3D{0, 0},=20
>>  > > > f_namelen=3D255, f_frsize=3D4096}
>>  > > > ) =3D 0
>>  > > > 864=A0=A0 futex(0x7f551010d31c, FUTEX_WAKE_PRIVATE, 214748364=
7)=20
> =3D 0
>>  > > > 864=A0=A0 open("/dev/shm/sem.nilfs-cleaner-2067",=20
> O_RDWR|O_NOFOLLOW) =3D -1=20
>>  > > > ENOENT=20
>>  > > > (No such file or directory)
>>  > > > 864=A0=A0 lstat("/dev/shm/sem.qLTneb", 0x7fffff54fb70)=20
> =3D -1 ENOENT (No=20
>>  > > > such file or=20
>>  > > > directory)
>>  > > > 864=A0=A0 open("/dev/shm/sem.qLTneb",=20
> O_RDWR|O_CREAT|O_EXCL, 0700) =3D 6
>>  > >=20
>>  > > Hmmm, quite different.
>>  >=20
>>  > Could you confirm whether /dev/shm is mounted on /run/shm (or
>>  > /var/run/shm) ?
>>  >=20
>>  > Some systems don't mount /dev/shm, and posix semaphores do not=20
> work in
>>  > such systems.
>>=20
>>  Oops, /dev/shm is just a directory (not a device), and /run/shm was
>>  irrelevant.=A0 Sorry.
>>=20
>>  The cause of this problem seems that posix semaphores are not
>>  available in your system.=A0 I'll dig into it.
>>=20
>>  Ryusuke Konishi
>=20
> I read the source code of sem_open() in glibc and found that
> sem_open() fails if there is no tmpfs (former shm fs) mount in the
> system.
>=20
> According to your strace log, your /dev/shm is mounted with "ramfs"
> whose magic number is 0x858458f6.=A0 This looks the cause of the erro=
r.
>=20
>>  statfs("/dev/shm", {f_type=3D0x858458f6, f_bsize=3D4096, f_blocks=3D=
0,
>>  f_bfree=3D0, f_bavail=3D0, f_files=3D0, f_ffree=3D0, f_fsid=3D{0, 0=
},
>>  f_namelen=3D255, f_frsize=3D4096}) =3D 0
>=20
> Try following kernel configs to enable tmpfs and mount it to
> /dev/shm instead of using ramfs.
>=20
> - CONFIG_SHMEM
> =A0 =A0 =A0 Generic setup ->
> =A0 =A0 =A0 =A0 Configure standard kernel features (expert users) ->
> =A0 =A0 =A0 =A0 =A0 Use full shmem filesystem
>=20
> - CONFIG_TMPFS
> =A0 =A0 =A0 File systems ->
> =A0 =A0 =A0 =A0 Pseudo filesystems ->
> =A0 =A0 =A0 =A0 =A0 Tmpfs virtual memory file system support (former =
shm fs)

You are right. I was using ramfs and when I tried with CONFIG_SHMEM
I still used ramfs, so right now I am compiling a new kernel with
both CONFIG_SHMEM and CONFIG_TMPFS. I will report my results when
I have tried the new kernel.

Thanks again
/S-G
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
