From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Bug : reuse same inode
Date: Fri, 18 Feb 2011 16:21:45 +0900 (JST)
Message-ID: <20110218.162145.57461053.ryusuke@osrg.net>
References: <20110208213237.0a0bef59@micro24>
	<20110210.140105.33383103.ryusuke@osrg.net>
	<20110210233201.6e8d711d@micro24>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110210233201.6e8d711d@micro24>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: liste-ZXOCcuNttmoBe96aLqz0jA@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 10 Feb 2011 23:32:01 +0100, Philippe CHATAIGNON wrote:
> Le Thu, 10 Feb 2011 14:01:05 +0900 (JST),
> Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> a =E9crit :
> > O.K. so, it seems like something happened at the checkpoint 15731
> > according to your information.
> >=20
> > One thing wired is that the timestamp (mtime) looks to be rewinded
> > at cp15731.
> >=20
> > >   File: =AB=A0mnt/snap6/cut/f5_20110125_202053.ts(0).Xcl=A0=BB
> > >   Size: 6214528000	Blocks: 18446744073697366064 IO Block:
> > > 4096   fichier Device: fe00h/65024d	Inode: 14
> > > Links: 0 Access: (0644/-rw-r--r--)  Uid: ( 1000/philippe)   Gid:
> > > (  100/   users) Access: 2011-01-24 01:30:02.260271565 +0100
> > > Modify: 2011-01-24 01:30:02.260271565 +0100
> > > Change: 2011-01-25 20:28:48.894851740 +0100
> >=20
> > Do you have any ideas on this timestamp ?
>=20
> Hi,
> I pastebin all the lscp (25600 lines) at : http://dpaste.org/U6w6
>=20
> As you can see, there is an activity at 2011-01-24 01:30:02.         =
    =20
> 14442  2011-01-24 01:29:56   cp    -        101         11
> 14443  2011-01-24 01:30:00   cp    -        925         11
> 14444  2011-01-24 01:30:07   cp    -        625         11
> 14445  2011-01-25 20:20:58   cp    -        320         12
> 14446  2011-01-25 20:21:05   cp    -        544         12
>=20
> philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D14443 /dev/mapper=
/vg11a-video mnt/snap4                                    =20
> philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D14444 /dev/mapper=
/vg11a-video mnt/snap5
> philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D14445 /dev/mapper=
/vg11a-video mnt/snap6
> philippe@micro11:~$ ls -lid mnt/snap4/**/**                          =
                                                             =20
> 12 drwxr-xr-x 2 philippe users       4096 23 janv. 22:34 mnt/snap4/ca=
pture/
> 19 -rw-r--r-- 1 philippe users 4957184000 24 janv. 01:29 mnt/snap4/ca=
pture/f2_20110123_223415.ts
> 16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 mnt/snap4/ca=
pture/f3_20110107_205154.ts
> 14 -rw-r--r-- 1 philippe users 6213324800 24 janv. 01:30 mnt/snap4/ca=
pture/f3_20110123_223247.ts
> 15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 mnt/snap4/ca=
pture/f4_20110119_204007.ts
> 17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 mnt/snap4/ca=
pture/tf1hd_20101219_203305_schrek2.ts
> 18 -rw-r--r-- 1 philippe users       4434  9 janv. 15:45 mnt/snap4/ch=
annels.conf
> 13 drwxr-xr-x 2 philippe users       4096 23 janv. 22:31 mnt/snap4/cu=
t/
> philippe@micro11:~$ ls -lid mnt/snap5/**/**
> 12 drwxr-xr-x 2 philippe users       4096 23 janv. 22:34 mnt/snap5/ca=
pture/
> 19 -rw-r--r-- 1 philippe users 4958387200 24 janv. 01:30 mnt/snap5/ca=
pture/f2_20110123_223415.ts
> 16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 mnt/snap5/ca=
pture/f3_20110107_205154.ts
> 14 -rw-r--r-- 1 philippe users 6214528000 24 janv. 01:30 mnt/snap5/ca=
pture/f3_20110123_223247.ts
> 15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 mnt/snap5/ca=
pture/f4_20110119_204007.ts
> 17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 mnt/snap5/ca=
pture/tf1hd_20101219_203305_schrek2.ts
> 18 -rw-r--r-- 1 philippe users       4434  9 janv. 15:45 mnt/snap5/ch=
annels.conf
> 13 drwxr-xr-x 2 philippe users       4096 23 janv. 22:31 mnt/snap5/cu=
t/
> philippe@micro11:~$ ls -lid mnt/snap6/**/**
> 12 drwxr-xr-x 2 philippe users       4096 25 janv. 20:20 mnt/snap6/ca=
pture/
> 19 -rw-r--r-- 1 philippe users 4958387200 24 janv. 01:30 mnt/snap6/ca=
pture/f2_20110123_223415.ts
> 16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 mnt/snap6/ca=
pture/f3_20110107_205154.ts
> 14 -rw-r--r-- 1 philippe users 6214528000 24 janv. 01:30 mnt/snap6/ca=
pture/f3_20110123_223247.ts
> 15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 mnt/snap6/ca=
pture/f4_20110119_204007.ts
> 20 -rw-r--r-- 1 philippe users    1203200 25 janv. 20:20 mnt/snap6/ca=
pture/f5_20110125_202053.ts
> 17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 mnt/snap6/ca=
pture/tf1hd_20101219_203305_schrek2.ts
> 18 -rw-r--r-- 1 philippe users       4434  9 janv. 15:45 mnt/snap6/ch=
annels.conf
> 13 drwxr-xr-x 2 philippe users       4096 23 janv. 22:31 mnt/snap6/cu=
t/
>=20
> Interesting file is :
> 14 -rw-r--r-- 1 philippe users 6214528000 24 janv. 01:30 mnt/snap5/ca=
pture/f3_20110123_223247.ts
> =20
> It's the timestamp, the size (6214528000) and the inode (14) of the f=
ile of the cp15731.
>=20
> For your information, at 1:30 the computer shuts down with 'at' comma=
nd. Another remark : 2 files were recorded=20
> simultaneously (the other one is f2_20110123_223415.ts at inode 19).

Thank you for the cooperation.

Yeah, this file is exactly the file that overrode
"f5_20110125_202053.ts(0).Xcl" at cp15731.

I don't know why the past inode overrode the latest inode.  One
possible explanation is that garbage collection caused this
interference, and another is interference by a snapshot mount for the
checkpoint 14444.

Were you mounting the snapshot cp14444 when
"f5_20110125_202053.ts(0).Xcl" was destroyed at cp15731 ?

If not, dummy on-memory inodes used for the garbage collection seem
suspicious to me.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
