From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Bug : reuse same inode
Date: Tue, 08 Feb 2011 20:42:30 +0900 (JST)
Message-ID: <20110208.204230.73657026.ryusuke@osrg.net>
References: <20110206200928.633fa00c@micro24>
	<20110207.130214.221723444.ryusuke@osrg.net>
	<20110207204232.364e4c5f@micro24>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110207204232.364e4c5f@micro24>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: liste-ZXOCcuNttmoBe96aLqz0jA@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Thank you for the detail report!  It's really helpful.

I understood the zero link count inode was causing a chain reaction.

And the inode in question at cp15731 also seems to be overridden
because gid, size, and timestamp all differs from that file at
cp15730.

> cp15730
> -------
> mnt/snap5/cut:
> total 4
> 14 -rw-r--r-- 1 philippe 1000 47 25 janv. 22:33 f5_20110125_202053.ts=
(0).Xcl

> cp15731
> -------
> mnt/snap7/cut:
> total 9223372036848683032
> 14 -rw-r--r-- 0 philippe users 6214528000 24 janv. 01:30 f5_20110125_=
202053.ts(0).Xcl

Can't you find another file with the inode number 14 in the snapshot
cp15731 or cp15730 ?

I reviewed back unlink() implementation, but haven't found any issues
so far.  The problem may be rooted much deeper.

'stat' command may give us much information than 'ls -l' in this case.


Thanks,
Ryusuke Konishi


On Mon, 7 Feb 2011 20:42:32 +0100, Philippe CHATAIGNON wrote:
> Le Mon, 07 Feb 2011 13:02:14 +0900 (JST),
> Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> a =E9crit :
>=20
> > Can you track the past state of this file from earlier checkpoints =
?
> Just before recording :
> philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D16940 /dev/mapper=
/vg11a-video mnt/snap5
> philippe@micro11:~$ ls -li mnt/snap5/**
> 18 -rw-r--r-- 1 philippe users 4434  9 janv. 15:45 mnt/snap5/channels=
=2Econf
>=20
> mnt/snap5/capture:
> total 19452056
> 16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 f3_20110107_=
205154.ts
> 15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 f4_20110119_=
204007.ts
> 17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 tf1hd_201012=
19_203305_schrek2.ts
>=20
> mnt/snap5/cut:
> total 4
> 19 -rw-r--r-- 1 philippe  1000        156 29 janv. 21:16 canal_201101=
29_181951.ts(0).Xcl
> 14 -rw-r--r-- 0 philippe users 4838067200 30 janv. 00:58 f5_20110125_=
202053.ts(0).Xcl
>=20
> Start of recording :
> philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D16941 /dev/mapper=
/vg11a-video mnt/snap6
> philippe@micro11:~$ ls -li mnt/snap6/**                              =
                   =20
> 18 -rw-r--r-- 1 philippe users 4434  9 janv. 15:45 mnt/snap6/channels=
=2Econf
>=20
> mnt/snap6/capture:
> total 19454420
> 14 -rw-r--r-- 1 philippe users    2406400 30 janv. 17:45 f2_20110130_=
174456.ts
> 16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 f3_20110107_=
205154.ts
> 15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 f4_20110119_=
204007.ts
> 17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 tf1hd_201012=
19_203305_schrek2.ts
>=20
> mnt/snap6/cut:
> total 2368
> 19 -rw-r--r-- 1 philippe  1000     156 29 janv. 21:16 canal_20110129_=
181951.ts(0).Xcl
> 14 -rw-r--r-- 1 philippe users 2406400 30 janv. 17:45 f5_20110125_202=
053.ts(0).Xcl
>=20
> That's the problem : inode 14 is reused because there was a file with=
 0 link (f5_20110125_202053.ts(0).Xcl)=20
> in another directory. So I tracked earlier and found that :
>=20
> cp15730
> -------
> philippe@micro11:~$ ls -li mnt/snap5/**
> 18 -rw-r--r-- 1 philippe users 4434  9 janv. 15:45 mnt/snap5/channels=
=2Econf
>=20
> mnt/snap5/capture:
> total 19452056
> 16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 f3_20110107_=
205154.ts
> 15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 f4_20110119_=
204007.ts
> 17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 tf1hd_201012=
19_203305_schrek2.ts
>=20
> mnt/snap5/cut:
> total 4
> 14 -rw-r--r-- 1 philippe 1000 47 25 janv. 22:33 f5_20110125_202053.ts=
(0).Xcl
>=20
> All is OK
>=20
> cp15731
> -------
> philippe@micro11:~$ ls -li mnt/snap7/**
> 18 -rw-r--r-- 1 philippe users 4434  9 janv. 15:45 mnt/snap7/channels=
=2Econf
>=20
> mnt/snap7/capture:
> total 19452056
> 16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 f3_20110107_=
205154.ts
> 15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 f4_20110119_=
204007.ts
> 17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 tf1hd_201012=
19_203305_schrek2.ts
>=20
> mnt/snap7/cut:
> total 9223372036848683032
> 14 -rw-r--r-- 0 philippe users 6214528000 24 janv. 01:30 f5_20110125_=
202053.ts(0).Xcl
>=20
> Size of file f5_20110125_202053.ts(0).Xcl is incorrect and it appears=
 with 0 link.
>=20
>=20
> cp15732
> -------
> philippe@micro11:~$ ls -li mnt/snap2/**
> 18 -rw-r--r-- 1 philippe users 4434  9 janv. 15:45 mnt/snap2/channels=
=2Econf
>=20
> mnt/snap2/capture:
> total 19452056
> 14 -rw-r--r-- 1 philippe users          0 29 janv. 18:19 canal_201101=
29_181951.ts
> 16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 f3_20110107_=
205154.ts
> 15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 f4_20110119_=
204007.ts
> 17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 tf1hd_201012=
19_203305_schrek2.ts
>=20
> mnt/snap2/cut:
> total 0
> 14 -rw-r--r-- 1 philippe users 0 29 janv. 18:19 f5_20110125_202053.ts=
(0).Xcl
>=20
>=20
> Inode 14 is used by 2 files. When I deleted the file canal_20110129_1=
81951.ts, we have
> the situation of the cp 16940 (the first of this mail) and a file wit=
h 0 link.
>=20
> Problem is in cp15731, just before the creation of file canal_2011012=
9_181951.ts.
>=20
> PhC
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
