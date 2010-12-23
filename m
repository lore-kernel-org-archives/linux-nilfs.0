From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: kernel panic (2.6.36) after file system corruption (?)
Date: Fri, 24 Dec 2010 01:59:54 +0900 (JST)
Message-ID: <20101224.015954.136348587.ryusuke@osrg.net>
References: <AANLkTimMj1DdHaCJwJiGaKY4=+rB6jn6ru1L0koV=suK@mail.gmail.com>
	<20101221.115542.199417894.ryusuke@osrg.net>
	<AANLkTik55mzijPR3ibT2+tKN6QEi2U1mpyprRQ3KU2xO@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik55mzijPR3ibT2+tKN6QEi2U1mpyprRQ3KU2xO-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: fijam7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 21 Dec 2010 18:35:55 +0100, Jan Misiak wrote:
> On 21 December 2010 03:55, Ryusuke Konishi
> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> > Could you get device size information in a few ways?
>=20
> Certainly.
>=20
> > 1) sysfs reported sizes
> > =A0# cat /sys/block/sdb/size
> 31506432
>=20
> > =A0# cat /sys/block/sdb/sdb1/size
> 31504384
>=20
> > 2) Sizes on the partition table
> > =A0# fdisk -lu /dev/sdb
> Disk /dev/sdb: 16.1 GB, 16131293184 bytes
> 25 heads, 25 sectors/track, 50410 cylinders, total 31506432 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x04030201
>=20
> Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1            2048    31506431    15752192    7  HPFS/NTFS
>=20
> > 3) Dump of the first super block (it has the layout information)
> > =A0# dd if=3D/dev/sdb1 bs=3D1k count=3D1 skip=3D1 2>/dev/null | hd
> #dd if=3D/dev/sdb1 bs=3D1k count=3D1 skip=3D1 2>/dev/null | hexdump
> 0000000 0002 0000 0000 3434 0100 0000 e5da ead2
> 0000010 e644 38c1 0002 0000 0782 0000 0000 0000
> 0000020 0000 c170 0003 0000 0001 0000 0000 0000
> 0000030 0800 0000 0005 0000 92c7 0002 0000 0000
> 0000040 f800 0013 0000 0000 f1e3 0001 0000 0000
> 0000050 6000 0007 0000 0000 8836 4c69 0000 0000
> 0000060 f119 4cf0 0000 0000 f119 4cf0 0000 0000
> 0000070 002f 0032 0000 0001 8836 4c69 0000 0000
> 0000080 4e00 00ed 0000 0000 0000 0000 000b 0000
> 0000090 0080 0020 00c0 0010 2be3 b1ef 799b cb4b
> 00000a0 d0a5 5ae1 9892 80a8 0000 0000 0000 0000
> 00000b0 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0000400
>=20
> Hope that helps. Please let me know if you need anything else.
>=20
> Regards,
> Jan

All of the information looks sane including the device sizes.

By the way, did you separate the block layer problem from filesystem
problem ?

If not yet, could you try the following tests ?

1) quick device write test

 # dd if=3D/dev/zero of=3D/dev/sdb1 bs=3D1k count=3D1 skip=3D2

 This zero-fills an unused block in the partition.

2) backup and recovery test

 # dd if=3D/dev/sdb1 of=3D/path-to-large-disk/backup.img bs=3D4k
 # dd if=3D/path-to-large-disk/backup.img of=3D/dev/sdb1 bs=3D4k


With regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
