From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Bug : reuse same inode
Date: Thu, 10 Feb 2011 14:01:05 +0900 (JST)
Message-ID: <20110210.140105.33383103.ryusuke@osrg.net>
References: <20110207204232.364e4c5f@micro24>
	<20110208.204230.73657026.ryusuke@osrg.net>
	<20110208213237.0a0bef59@micro24>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110208213237.0a0bef59@micro24>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: liste-ZXOCcuNttmoBe96aLqz0jA@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 8 Feb 2011 21:32:37 +0100, Philippe CHATAIGNON wrote:
> Le Tue, 08 Feb 2011 20:42:30 +0900 (JST),
> Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> a =E9crit :
>=20
> > Hi,
> >=20
> > Thank you for the detail report!  It's really helpful.
> >=20
> > I understood the zero link count inode was causing a chain reaction=
=2E
> >=20
> > And the inode in question at cp15731 also seems to be overridden
> > because gid, size, and timestamp all differs from that file at
> > cp15730.
> >=20
> > > cp15730
> > > -------
> > > mnt/snap5/cut:
> > > total 4
> > > 14 -rw-r--r-- 1 philippe 1000 47 25 janv. 22:33
> > > f5_20110125_202053.ts(0).Xcl
> >=20
> > > cp15731
> > > -------
> > > mnt/snap7/cut:
> > > total 9223372036848683032
> > > 14 -rw-r--r-- 0 philippe users 6214528000 24 janv. 01:30
> > > f5_20110125_202053.ts(0).Xcl
> >=20
> > Can't you find another file with the inode number 14 in the snapsho=
t
> > cp15731 or cp15730 ?
> >=20
> > I reviewed back unlink() implementation, but haven't found any issu=
es
> > so far.  The problem may be rooted much deeper.
> >=20
> > 'stat' command may give us much information than 'ls -l' in this ca=
se.
>=20
> Hi,
> in my previous mail, ls -li ** give all the files in the filesystem (=
directory capture has inode 12 and cut 13). In
> cp15730 and cp15731, there's only one file with inode 14.

O.K. so, it seems like something happened at the checkpoint 15731
according to your information.

One thing wired is that the timestamp (mtime) looks to be rewinded
at cp15731.

>   File: =AB=A0mnt/snap6/cut/f5_20110125_202053.ts(0).Xcl=A0=BB
>   Size: 6214528000	Blocks: 18446744073697366064 IO Block: 4096   fich=
ier
> Device: fe00h/65024d	Inode: 14          Links: 0
> Access: (0644/-rw-r--r--)  Uid: ( 1000/philippe)   Gid: (  100/   use=
rs)
> Access: 2011-01-24 01:30:02.260271565 +0100
> Modify: 2011-01-24 01:30:02.260271565 +0100
> Change: 2011-01-25 20:28:48.894851740 +0100

Do you have any ideas on this timestamp ?

Then, let's look back in a different perspective.

As you know, the lscp command displays the total number of inodes (ICNT=
).
Does it match the actual number of files and directories ?

Thanks,
Ryusuke Konishi

> Heres's the 3 stat outputs :
> philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D15730 /dev/mapper=
/vg11a-video mnt/snap5
> philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D15731 /dev/mapper=
/vg11a-video mnt/snap6
> philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D15732 /dev/mapper=
/vg11a-video mnt/snap7
>=20
> philippe@micro11:~$ stat mnt/snap5/cut/f5_20110125_202053.ts\(0\).Xcl=
=20
>   File: =AB=A0mnt/snap5/cut/f5_20110125_202053.ts(0).Xcl=A0=BB
>   Size: 47        	Blocks: 8          IO Block: 4096   fichier
> Device: fe00h/65024d	Inode: 14          Links: 1
> Access: (0644/-rw-r--r--)  Uid: ( 1000/philippe)   Gid: ( 1000/ UNKNO=
WN)
> Access: 2011-01-25 22:33:34.914556435 +0100
> Modify: 2011-01-25 22:33:34.914556435 +0100
> Change: 2011-01-25 22:33:34.914556435 +0100
>  Birth: -
>=20
> philippe@micro11:~$ stat mnt/snap6/cut/f5_20110125_202053.ts\(0\).Xcl
>   File: =AB=A0mnt/snap6/cut/f5_20110125_202053.ts(0).Xcl=A0=BB
>   Size: 6214528000	Blocks: 18446744073697366064 IO Block: 4096   fich=
ier
> Device: fe00h/65024d	Inode: 14          Links: 0
> Access: (0644/-rw-r--r--)  Uid: ( 1000/philippe)   Gid: (  100/   use=
rs)
> Access: 2011-01-24 01:30:02.260271565 +0100
> Modify: 2011-01-24 01:30:02.260271565 +0100
> Change: 2011-01-25 20:28:48.894851740 +0100
>  Birth: -
>=20
>   File: =AB=A0mnt/snap7/cut/f5_20110125_202053.ts(0).Xcl=A0=BB
>   Size: 0         	Blocks: 0          IO Block: 4096   fichier vide
> Device: fe00h/65024d	Inode: 14          Links: 1
> Access: (0644/-rw-r--r--)  Uid: ( 1000/philippe)   Gid: (  100/   use=
rs)
> Access: 2011-01-29 18:19:51.719138031 +0100
> Modify: 2011-01-29 18:19:51.719138031 +0100
> Change: 2011-01-29 18:19:51.719138031 +0100
>  Birth: -
>=20
> PhC
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
