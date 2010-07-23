From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Error while testing (using loop device)
Date: Fri, 23 Jul 2010 11:31:25 +0900 (JST)
Message-ID: <20100723.113125.163336402.ryusuke@osrg.net>
References: <AANLkTikwTRGooDQD+Uo08MkywS+KJ8BXxqqytxbNFiqr@mail.gmail.com>
	<AANLkTin0qMJvDgs705a9Nu0hWNLCdGEXWn7q_2sXQ6yZ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin0qMJvDgs705a9Nu0hWNLCdGEXWn7q_2sXQ6yZ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: rdeleonp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 22 Jul 2010 14:26:38 -0500, Rodrigo_E._De_Le=F3n_Plicet wrote:
> Hi.
>=20
> Ubuntu 10.04
> nilfs-tools 2.0.15
>=20
> ---------------------------------------------------------------------=
-----------
>=20
> rdl@linage:/tmp$ mkdir t
>=20
> rdl@linage:/tmp$ mkdir t2
>=20
> rdl@linage:/tmp$ chmod 777 t t2
>=20
> rdl@linage:/tmp$ dd if=3D/dev/zero of=3Dtest.img bs=3D1M seek=3D1000 =
count=3D1
> 1+0 records in
> 1+0 records out
> 1048576 bytes (1.0 MB) copied, 0.00422859 s, 248 MB/s
>=20
> rdl@linage:/tmp$ mkfs -t nilfs2 test.img
> mkfs.nilfs2 ver 2.0
> Start writing file system initial data to the device
> =A0 =A0 =A0 Blocksize:4096 =A0Device:test.img =A0Device Size:10496245=
76
> File system initialization succeeded !!
>=20
> rdl@linage:/tmp$ sudo mount -t nilfs2 -o loop /tmp/test.img /tmp/t
> mount.nilfs2: WARNING! - The NILFS on-disk format may change at any t=
ime.
> mount.nilfs2: WARNING! - Do not place critical data on a NILFS filesy=
stem.
>=20
> (... time passes ...)
>=20
> rdl@linage:/tmp$ lscp
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CNO =A0 =A0 =A0 =A0DATE =A0 =A0 TIME =
=A0MODE =A0FLG =A0 NBLKINC =A0 =A0 =A0 ICNT
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A02010-07-21 15:25:07 =A0 cp =A0=
 =A0- =A0 =A0 =A0 =A0 11 =A0 =A0 =A0 =A0 =A03
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 2 =A02010-07-21 15:26:47 =A0 cp =A0=
 =A0- =A0 =A0 =A0 =A0118 =A0 =A0 =A0 =A0 =A04
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 3 =A02010-07-21 15:26:56 =A0 cp =A0=
 =A0- =A0 =A0 =A0 =A0224 =A0 =A0 =A0 =A0 =A06
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 4 =A02010-07-21 15:27:03 =A0 cp =A0=
 =A0- =A0 =A0 =A0 =A0 23 =A0 =A0 =A0 =A0 12
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 5 =A02010-07-21 15:27:14 =A0 cp =A0=
 =A0- =A0 =A0 =A0 =A0 48 =A0 =A0 =A0 =A0 13
>=20
> rdl@linage:/tmp$ sudo chcp ss 3
>=20
> rdl@linage:/tmp$ lscp
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CNO =A0 =A0 =A0 =A0DATE =A0 =A0 TIME =
=A0MODE =A0FLG =A0 NBLKINC =A0 =A0 =A0 ICNT
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A02010-07-21 15:25:07 =A0 cp =A0=
 =A0- =A0 =A0 =A0 =A0 11 =A0 =A0 =A0 =A0 =A03
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 2 =A02010-07-21 15:26:47 =A0 cp =A0=
 =A0- =A0 =A0 =A0 =A0118 =A0 =A0 =A0 =A0 =A04
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 3 =A02010-07-21 15:26:56 =A0 ss =A0=
 =A0- =A0 =A0 =A0 =A0224 =A0 =A0 =A0 =A0 =A06
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 4 =A02010-07-21 15:27:03 =A0 cp =A0=
 =A0- =A0 =A0 =A0 =A0 23 =A0 =A0 =A0 =A0 12
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 5 =A02010-07-21 15:27:14 =A0 cp =A0=
 =A0- =A0 =A0 =A0 =A0 48 =A0 =A0 =A0 =A0 13
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 6 =A02010-07-21 15:27:33 =A0 cp =A0=
 =A0- =A0 =A0 =A0 =A0 14 =A0 =A0 =A0 =A0 14
>=20
> rdl@linage:/tmp$ sudo mount -t nilfs2 -o ro,cp=3D2,loop /tmp/test.img=
 /tmp/t2
> mount.nilfs2: Error while mounting /dev/loop1 on /tmp/t2: Read-only f=
ile system
>=20
> rdl@linage:/tmp$ sudo mount -t nilfs2 -r -o cp=3D2,loop /tmp/test.img=
 /tmp/t2
> mount.nilfs2: Error while mounting /dev/loop1 on /tmp/t2: Read-only f=
ile system

How about this?

 $ sudo mount -t nilfs2 -o ro,cp=3D3,loop=3D/dev/loop0 /tmp/test.img /t=
mp/t2

or

 $ sudo mount -t nilfs2 -r -o cp=3D3,loop=3D/dev/loop0 /tmp/test.img /t=
mp/t2
 ...
 $ sudo umount /tmp/t2

Note that you have to manually detach the device like "losetup -d
/dev/loop0" if you once failed to mount it.  This is because the loop
device is handled by the common "mount" program not by "mount.nilfs2".

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
