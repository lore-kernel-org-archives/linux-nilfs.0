From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_cleanerd Function not implemented
Date: Fri, 16 Mar 2012 13:37:01 +0100
Message-ID: <1675589.uo1ijo0JER@coil>
References: <1331899533.77663.YahooMailNeo@web161902.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:subject:date:message-id:x-face:user-agent:in-reply-to
         :references:mime-version:content-transfer-encoding:content-type;
        bh=zgTsnoUlqtxGGIQ7AAzgDk6SiUJiwpH+JhkqSE9PLlU=;
        b=sLLzcVpXhBQfmPl8MmIg2RBKdXk5gTlWwvZEUGSrphVgPehmCdnJWvVCin2z3shIzK
         ObHaQXbf+B+iLyQbGcqaWQX+ddvi1uvPksf/+doB5W72wT1aM52b/vDgx+BrWj4bCfj3
         L5ji6aaVeP0vuXlXjRC4ubLVEro6C1Qzjhk1nVeBX1r0f1g0nDxwKJjngWahni2NIkCx
         TA8GQe1zdKf8fVF7KMIyZw6l+OxLgRsEIgbQZiYL6qV6o5FMGNmyJ8S5ZBp0hYL0XPnM
         p8Z4cqMq5N5nHlhzecd6HpsB6SIlNNkXHuz25PKWIxmArqp86wZe86NrrIlq0taIC6NW
         klXw==
In-Reply-To: <1331899533.77663.YahooMailNeo-/W4/QBBOCLIR8UyDmTZ/NZEhsgyP+Z75VpNB7YpNyf8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Sven,


On Friday 16 of March 2012 05:05:33 you wrote:
> Hi list,
>=20
> I am in the process of migrating an embedded project from
> ext2 to nilfs2 and have a problem with nilfs_cleanerd. It
> does not start on mount and I cannot start it manually.
> (...)

I'd suspect futex() or open(..., O_RDWR|O_NOFOLLOW). Do you have=20
`CONFIG_FUTEX' enabled in your embedded kernel?

Relevant snippet from strace of my nilfs_cleanerd (version nilfs-
utils-2.0.23):

864   open("/proc/mounts", O_RDONLY)    =3D 5
864   fstat(5, {st_mode=3DS_IFREG|0444, st_size=3D0, ...}) =3D 0
864   mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,=
 -1, 0)=20
=3D 0x7f551032d000
864   read(5, "rootfs / rootfs rw 0 0\n/dev/root"..., 1024) =3D 480
864   readlink("/dev", 0x7fffff54d630, 4096) =3D -1 EINVAL (Invalid arg=
ument)
864   readlink("/dev/root", "sda3", 4096) =3D 4
864   readlink("/dev/sda3", 0x7fffff54d630, 4096) =3D -1 EINVAL (Invali=
d argument)
864   readlink("/dev", 0x7fffff54d630, 4096) =3D -1 EINVAL (Invalid arg=
ument)
864   readlink("/dev/sdb3", 0x7fffff54d630, 4096) =3D -1 EINVAL (Invali=
d argument)
864   close(5)                          =3D 0
864   munmap(0x7f551032d000, 4096)      =3D 0
864   open("/home", O_RDONLY)           =3D 5
864   stat("/dev/sdb3", {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 1=
9), ...}) =3D=20
0
864   statfs("/dev/shm", {f_type=3D0x1021994, f_bsize=3D4096, f_blocks=3D=
86016,=20
f_bfree=3D86010, f_bavail=3D86010, f_files=3D754077, f_ffree=3D754075, =
f_fsid=3D{0, 0},=20
f_namelen=3D255, f_frsize=3D4096}
) =3D 0
864   futex(0x7f551010d31c, FUTEX_WAKE_PRIVATE, 2147483647) =3D 0
864   open("/dev/shm/sem.nilfs-cleaner-2067", O_RDWR|O_NOFOLLOW) =3D -1=
 ENOENT=20
(No such file or directory)
864   lstat("/dev/shm/sem.qLTneb", 0x7fffff54fb70) =3D -1 ENOENT (No su=
ch file or=20
directory)
864   open("/dev/shm/sem.qLTneb", O_RDWR|O_CREAT|O_EXCL, 0700) =3D 6


Btw., you may not be seeing the failed (with `Function not implemented'=
)=20
syscall in strace, if the libc itself signals the `Function not impleme=
nted'=20
error instead of issuing the syscall. Consider using ``ltrace'' instead=
, to=20
intercept all lib calls.


Cheers,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

Already many of the mutants disguised=EF=BB=BF as human beings are walk=
ing the streets=20
of Earth's cities.
 -- Music Instructor, ``Electro City''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
