From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs_cleanerd Function not implemented
Date: Sat, 17 Mar 2012 20:43:43 +0900 (JST)
Message-ID: <20120317.204343.93460664.ryusuke@osrg.net>
References: <1331899533.77663.YahooMailNeo@web161902.mail.bf1.yahoo.com>
	<1675589.uo1ijo0JER@coil>
	<1331907699.90830.YahooMailNeo@web161901.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331907699.90830.YahooMailNeo-/W4/QBBOCLJal3a5i+KC+JEhsgyP+Z75VpNB7YpNyf8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Cc: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 16 Mar 2012 07:21:39 -0700 (PDT), Sven-G=F6ran_Bergh wrote:
> Hi dexen,
>=20
> thank you for a prompt reply.
>=20
>=20
>=20
> >>  I am in the process of migrating an embedded project from
> >>  ext2 to nilfs2 and have a problem with nilfs_cleanerd. It
> >>  does not start on mount and I cannot start it manually.
> >>  (...)
> >=20
> > Relevant snippet from strace of my nilfs_cleanerd (version nilfs-
> > utils-2.0.23):
> ...
> > 864=A0  statfs("/dev/shm", {f_type=3D0x1021994, f_bsize=3D4096,=20
> > f_blocks=3D86016,=20
> > f_bfree=3D86010, f_bavail=3D86010, f_files=3D754077, f_ffree=3D7540=
75, f_fsid=3D{0, 0},=20
> > f_namelen=3D255, f_frsize=3D4096}
> > ) =3D 0
> > 864=A0  futex(0x7f551010d31c, FUTEX_WAKE_PRIVATE, 2147483647) =3D 0
> > 864=A0  open("/dev/shm/sem.nilfs-cleaner-2067", O_RDWR|O_NOFOLLOW) =
=3D -1=20
> > ENOENT=20
> > (No such file or directory)
> > 864=A0  lstat("/dev/shm/sem.qLTneb", 0x7fffff54fb70) =3D -1 ENOENT =
(No=20
> > such file or=20
> > directory)
> > 864=A0  open("/dev/shm/sem.qLTneb", O_RDWR|O_CREAT|O_EXCL, 0700) =3D=
 6
>=20
> Hmmm, quite different.

Could you confirm whether /dev/shm is mounted on /run/shm (or
/var/run/shm) ?

Some systems don't mount /dev/shm, and posix semaphores do not work in
such systems.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
