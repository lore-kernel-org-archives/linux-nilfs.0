From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs_cleanerd Function not implemented
Date: Sun, 18 Mar 2012 02:17:40 +0900 (JST)
Message-ID: <20120318.021740.212402053.ryusuke@osrg.net>
References: <1331907699.90830.YahooMailNeo@web161901.mail.bf1.yahoo.com>
	<20120317.204343.93460664.ryusuke@osrg.net>
	<20120317.225320.67906283.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120317.225320.67906283.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Cc: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 17 Mar 2012 22:53:20 +0900 (JST), Ryusuke Konishi wrote:
> On Sat, 17 Mar 2012 20:43:43 +0900 (JST), Ryusuke Konishi wrote:
> > On Fri, 16 Mar 2012 07:21:39 -0700 (PDT), Sven-G=F6ran_Bergh wrote:
> > > Hi dexen,
> > >=20
> > > thank you for a prompt reply.
> > >=20
> > >=20
> > >=20
> > > >>  I am in the process of migrating an embedded project from
> > > >>  ext2 to nilfs2 and have a problem with nilfs_cleanerd. It
> > > >>  does not start on mount and I cannot start it manually.
> > > >>  (...)
> > > >=20
> > > > Relevant snippet from strace of my nilfs_cleanerd (version nilf=
s-
> > > > utils-2.0.23):
> > > ...
> > > > 864=A0  statfs("/dev/shm", {f_type=3D0x1021994, f_bsize=3D4096,=
=20
> > > > f_blocks=3D86016,=20
> > > > f_bfree=3D86010, f_bavail=3D86010, f_files=3D754077, f_ffree=3D=
754075, f_fsid=3D{0, 0},=20
> > > > f_namelen=3D255, f_frsize=3D4096}
> > > > ) =3D 0
> > > > 864=A0  futex(0x7f551010d31c, FUTEX_WAKE_PRIVATE, 2147483647) =3D=
 0
> > > > 864=A0  open("/dev/shm/sem.nilfs-cleaner-2067", O_RDWR|O_NOFOLL=
OW) =3D -1=20
> > > > ENOENT=20
> > > > (No such file or directory)
> > > > 864=A0  lstat("/dev/shm/sem.qLTneb", 0x7fffff54fb70) =3D -1 ENO=
ENT (No=20
> > > > such file or=20
> > > > directory)
> > > > 864=A0  open("/dev/shm/sem.qLTneb", O_RDWR|O_CREAT|O_EXCL, 0700=
) =3D 6
> > >=20
> > > Hmmm, quite different.
> >=20
> > Could you confirm whether /dev/shm is mounted on /run/shm (or
> > /var/run/shm) ?
> >=20
> > Some systems don't mount /dev/shm, and posix semaphores do not work=
 in
> > such systems.
>=20
> Oops, /dev/shm is just a directory (not a device), and /run/shm was
> irrelevant.  Sorry.
>=20
> The cause of this problem seems that posix semaphores are not
> available in your system.  I'll dig into it.
>=20
> Ryusuke Konishi

I read the source code of sem_open() in glibc and found that
sem_open() fails if there is no tmpfs (former shm fs) mount in the
system.

According to your strace log, your /dev/shm is mounted with "ramfs"
whose magic number is 0x858458f6.  This looks the cause of the error.

> statfs("/dev/shm", {f_type=3D0x858458f6, f_bsize=3D4096, f_blocks=3D0=
,
> f_bfree=3D0, f_bavail=3D0, f_files=3D0, f_ffree=3D0, f_fsid=3D{0, 0},
> f_namelen=3D255, f_frsize=3D4096}) =3D 0

Try following kernel configs to enable tmpfs and mount it to
/dev/shm instead of using ramfs.

 - CONFIG_SHMEM
      Generic setup ->
        Configure standard kernel features (expert users) ->
          Use full shmem filesystem

 - CONFIG_TMPFS
      File systems ->
        Pseudo filesystems ->
          Tmpfs virtual memory file system support (former shm fs)

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
