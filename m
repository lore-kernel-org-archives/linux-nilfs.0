From: Philippe CHATAIGNON <liste-ZXOCcuNttmoBe96aLqz0jA@public.gmane.org>
Subject: Re: Bug : reuse same inode
Date: Tue, 8 Feb 2011 21:32:37 +0100
Message-ID: <20110208213237.0a0bef59@micro24>
References: <20110206200928.633fa00c@micro24>
	<20110207.130214.221723444.ryusuke@osrg.net>
	<20110207204232.364e4c5f@micro24>
	<20110208.204230.73657026.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110208.204230.73657026.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Le Tue, 08 Feb 2011 20:42:30 +0900 (JST),
Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> a =E9crit :

> Hi,
>=20
> Thank you for the detail report!  It's really helpful.
>=20
> I understood the zero link count inode was causing a chain reaction.
>=20
> And the inode in question at cp15731 also seems to be overridden
> because gid, size, and timestamp all differs from that file at
> cp15730.
>=20
> > cp15730
> > -------
> > mnt/snap5/cut:
> > total 4
> > 14 -rw-r--r-- 1 philippe 1000 47 25 janv. 22:33
> > f5_20110125_202053.ts(0).Xcl
>=20
> > cp15731
> > -------
> > mnt/snap7/cut:
> > total 9223372036848683032
> > 14 -rw-r--r-- 0 philippe users 6214528000 24 janv. 01:30
> > f5_20110125_202053.ts(0).Xcl
>=20
> Can't you find another file with the inode number 14 in the snapshot
> cp15731 or cp15730 ?
>=20
> I reviewed back unlink() implementation, but haven't found any issues
> so far.  The problem may be rooted much deeper.
>=20
> 'stat' command may give us much information than 'ls -l' in this case=
=2E

Hi,
in my previous mail, ls -li ** give all the files in the filesystem (di=
rectory capture has inode 12 and cut 13). In
cp15730 and cp15731, there's only one file with inode 14.

Heres's the 3 stat outputs :
philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D15730 /dev/mapper/v=
g11a-video mnt/snap5
philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D15731 /dev/mapper/v=
g11a-video mnt/snap6
philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D15732 /dev/mapper/v=
g11a-video mnt/snap7

philippe@micro11:~$ stat mnt/snap5/cut/f5_20110125_202053.ts\(0\).Xcl=20
  File: =AB=A0mnt/snap5/cut/f5_20110125_202053.ts(0).Xcl=A0=BB
  Size: 47        	Blocks: 8          IO Block: 4096   fichier
Device: fe00h/65024d	Inode: 14          Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/philippe)   Gid: ( 1000/ UNKNOWN=
)
Access: 2011-01-25 22:33:34.914556435 +0100
Modify: 2011-01-25 22:33:34.914556435 +0100
Change: 2011-01-25 22:33:34.914556435 +0100
 Birth: -

philippe@micro11:~$ stat mnt/snap6/cut/f5_20110125_202053.ts\(0\).Xcl
  File: =AB=A0mnt/snap6/cut/f5_20110125_202053.ts(0).Xcl=A0=BB
  Size: 6214528000	Blocks: 18446744073697366064 IO Block: 4096   fichie=
r
Device: fe00h/65024d	Inode: 14          Links: 0
Access: (0644/-rw-r--r--)  Uid: ( 1000/philippe)   Gid: (  100/   users=
)
Access: 2011-01-24 01:30:02.260271565 +0100
Modify: 2011-01-24 01:30:02.260271565 +0100
Change: 2011-01-25 20:28:48.894851740 +0100
 Birth: -

  File: =AB=A0mnt/snap7/cut/f5_20110125_202053.ts(0).Xcl=A0=BB
  Size: 0         	Blocks: 0          IO Block: 4096   fichier vide
Device: fe00h/65024d	Inode: 14          Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/philippe)   Gid: (  100/   users=
)
Access: 2011-01-29 18:19:51.719138031 +0100
Modify: 2011-01-29 18:19:51.719138031 +0100
Change: 2011-01-29 18:19:51.719138031 +0100
 Birth: -

PhC
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
