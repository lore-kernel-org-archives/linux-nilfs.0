From: Philippe CHATAIGNON <liste-ZXOCcuNttmoBe96aLqz0jA@public.gmane.org>
Subject: Re: Bug : reuse same inode
Date: Thu, 10 Feb 2011 23:32:01 +0100
Message-ID: <20110210233201.6e8d711d@micro24>
References: <20110207204232.364e4c5f@micro24>
	<20110208.204230.73657026.ryusuke@osrg.net>
	<20110208213237.0a0bef59@micro24>
	<20110210.140105.33383103.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110210.140105.33383103.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Le Thu, 10 Feb 2011 14:01:05 +0900 (JST),
Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> a =E9crit :
> O.K. so, it seems like something happened at the checkpoint 15731
> according to your information.
>=20
> One thing wired is that the timestamp (mtime) looks to be rewinded
> at cp15731.
>=20
> >   File: =AB=A0mnt/snap6/cut/f5_20110125_202053.ts(0).Xcl=A0=BB
> >   Size: 6214528000	Blocks: 18446744073697366064 IO Block:
> > 4096   fichier Device: fe00h/65024d	Inode: 14
> > Links: 0 Access: (0644/-rw-r--r--)  Uid: ( 1000/philippe)   Gid:
> > (  100/   users) Access: 2011-01-24 01:30:02.260271565 +0100
> > Modify: 2011-01-24 01:30:02.260271565 +0100
> > Change: 2011-01-25 20:28:48.894851740 +0100
>=20
> Do you have any ideas on this timestamp ?

Hi,
I pastebin all the lscp (25600 lines) at : http://dpaste.org/U6w6

As you can see, there is an activity at 2011-01-24 01:30:02.           =
  =20
14442  2011-01-24 01:29:56   cp    -        101         11
14443  2011-01-24 01:30:00   cp    -        925         11
14444  2011-01-24 01:30:07   cp    -        625         11
14445  2011-01-25 20:20:58   cp    -        320         12
14446  2011-01-25 20:21:05   cp    -        544         12

philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D14443 /dev/mapper/v=
g11a-video mnt/snap4                                    =20
philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D14444 /dev/mapper/v=
g11a-video mnt/snap5
philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D14445 /dev/mapper/v=
g11a-video mnt/snap6
philippe@micro11:~$ ls -lid mnt/snap4/**/**                            =
                                                           =20
12 drwxr-xr-x 2 philippe users       4096 23 janv. 22:34 mnt/snap4/capt=
ure/
19 -rw-r--r-- 1 philippe users 4957184000 24 janv. 01:29 mnt/snap4/capt=
ure/f2_20110123_223415.ts
16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 mnt/snap4/capt=
ure/f3_20110107_205154.ts
14 -rw-r--r-- 1 philippe users 6213324800 24 janv. 01:30 mnt/snap4/capt=
ure/f3_20110123_223247.ts
15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 mnt/snap4/capt=
ure/f4_20110119_204007.ts
17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 mnt/snap4/capt=
ure/tf1hd_20101219_203305_schrek2.ts
18 -rw-r--r-- 1 philippe users       4434  9 janv. 15:45 mnt/snap4/chan=
nels.conf
13 drwxr-xr-x 2 philippe users       4096 23 janv. 22:31 mnt/snap4/cut/
philippe@micro11:~$ ls -lid mnt/snap5/**/**
12 drwxr-xr-x 2 philippe users       4096 23 janv. 22:34 mnt/snap5/capt=
ure/
19 -rw-r--r-- 1 philippe users 4958387200 24 janv. 01:30 mnt/snap5/capt=
ure/f2_20110123_223415.ts
16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 mnt/snap5/capt=
ure/f3_20110107_205154.ts
14 -rw-r--r-- 1 philippe users 6214528000 24 janv. 01:30 mnt/snap5/capt=
ure/f3_20110123_223247.ts
15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 mnt/snap5/capt=
ure/f4_20110119_204007.ts
17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 mnt/snap5/capt=
ure/tf1hd_20101219_203305_schrek2.ts
18 -rw-r--r-- 1 philippe users       4434  9 janv. 15:45 mnt/snap5/chan=
nels.conf
13 drwxr-xr-x 2 philippe users       4096 23 janv. 22:31 mnt/snap5/cut/
philippe@micro11:~$ ls -lid mnt/snap6/**/**
12 drwxr-xr-x 2 philippe users       4096 25 janv. 20:20 mnt/snap6/capt=
ure/
19 -rw-r--r-- 1 philippe users 4958387200 24 janv. 01:30 mnt/snap6/capt=
ure/f2_20110123_223415.ts
16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 mnt/snap6/capt=
ure/f3_20110107_205154.ts
14 -rw-r--r-- 1 philippe users 6214528000 24 janv. 01:30 mnt/snap6/capt=
ure/f3_20110123_223247.ts
15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 mnt/snap6/capt=
ure/f4_20110119_204007.ts
20 -rw-r--r-- 1 philippe users    1203200 25 janv. 20:20 mnt/snap6/capt=
ure/f5_20110125_202053.ts
17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 mnt/snap6/capt=
ure/tf1hd_20101219_203305_schrek2.ts
18 -rw-r--r-- 1 philippe users       4434  9 janv. 15:45 mnt/snap6/chan=
nels.conf
13 drwxr-xr-x 2 philippe users       4096 23 janv. 22:31 mnt/snap6/cut/

Interesting file is :
14 -rw-r--r-- 1 philippe users 6214528000 24 janv. 01:30 mnt/snap5/capt=
ure/f3_20110123_223247.ts
=20
It's the timestamp, the size (6214528000) and the inode (14) of the fil=
e of the cp15731.

=46or your information, at 1:30 the computer shuts down with 'at' comma=
nd. Another remark : 2 files were recorded=20
simultaneously (the other one is f2_20110123_223415.ts at inode 19).

This file is delete in cp 14522. I don't see any trouble after deletion=
 :

philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D14521 /dev/mapper/v=
g11a-video mnt/snap1
philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D14522 /dev/mapper/v=
g11a-video mnt/snap2
philippe@micro11:~$ sudo mount -t nilfs2 -r -o cp=3D14523 /dev/mapper/v=
g11a-video mnt/snap3
philippe@micro11:~$ ls -lid mnt/snap1/**/**                            =
                 =20
12 drwxr-xr-x 2 philippe users       4096 25 janv. 20:26 mnt/snap1/capt=
ure/
16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 mnt/snap1/capt=
ure/f3_20110107_205154.ts
14 -rw-r--r-- 1 philippe users 6214528000 24 janv. 01:30 mnt/snap1/capt=
ure/f3_20110123_223247.ts
15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 mnt/snap1/capt=
ure/f4_20110119_204007.ts
20 -rw-r--r-- 1 philippe users  192512000 25 janv. 20:28 mnt/snap1/capt=
ure/f5_20110125_202053.ts
17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 mnt/snap1/capt=
ure/tf1hd_20101219_203305_schrek2.ts
18 -rw-r--r-- 1 philippe users       4434  9 janv. 15:45 mnt/snap1/chan=
nels.conf
13 drwxr-xr-x 2 philippe users       4096 25 janv. 20:27 mnt/snap1/cut/
21 -rw-r--r-- 1 philippe  1000         48 25 janv. 20:23 mnt/snap1/cut/=
f2_20110123_223415.ts(0).Xcl
19 -rw-r--r-- 1 philippe  1000         47 25 janv. 20:27 mnt/snap1/cut/=
f3_20110123_223247.ts
philippe@micro11:~$ ls -lid mnt/snap2/**/**
12 drwxr-xr-x 2 philippe users       4096 25 janv. 20:28 mnt/snap2/capt=
ure/
16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 mnt/snap2/capt=
ure/f3_20110107_205154.ts
15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 mnt/snap2/capt=
ure/f4_20110119_204007.ts
20 -rw-r--r-- 1 philippe users  196121600 25 janv. 20:28 mnt/snap2/capt=
ure/f5_20110125_202053.ts
17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 mnt/snap2/capt=
ure/tf1hd_20101219_203305_schrek2.ts
18 -rw-r--r-- 1 philippe users       4434  9 janv. 15:45 mnt/snap2/chan=
nels.conf
13 drwxr-xr-x 2 philippe users       4096 25 janv. 20:27 mnt/snap2/cut/
21 -rw-r--r-- 1 philippe  1000         48 25 janv. 20:23 mnt/snap2/cut/=
f2_20110123_223415.ts(0).Xcl
19 -rw-r--r-- 1 philippe  1000         47 25 janv. 20:27 mnt/snap2/cut/=
f3_20110123_223247.ts
philippe@micro11:~$ ls -lid mnt/snap3/**/**
12 drwxr-xr-x 2 philippe users       4096 25 janv. 20:28 mnt/snap3/capt=
ure/
16 -rw-r--r-- 1 philippe users 8606489600  9 janv. 15:42 mnt/snap3/capt=
ure/f3_20110107_205154.ts
15 -rw-r--r-- 1 philippe users 4688870400 19 janv. 23:14 mnt/snap3/capt=
ure/f4_20110119_204007.ts
20 -rw-r--r-- 1 philippe users  199731200 25 janv. 20:29 mnt/snap3/capt=
ure/f5_20110125_202053.ts
17 -rw-r--r-- 1 philippe users 6545408000  9 janv. 15:45 mnt/snap3/capt=
ure/tf1hd_20101219_203305_schrek2.ts
18 -rw-r--r-- 1 philippe users       4434  9 janv. 15:45 mnt/snap3/chan=
nels.conf
13 drwxr-xr-x 2 philippe users       4096 25 janv. 20:27 mnt/snap3/cut/
21 -rw-r--r-- 1 philippe  1000         48 25 janv. 20:23 mnt/snap3/cut/=
f2_20110123_223415.ts(0).Xcl
19 -rw-r--r-- 1 philippe  1000         47 25 janv. 20:27 mnt/snap3/cut/=
f3_20110123_223247.ts

Remark :=20
cp 14522 is at 2011-01-25 20:29:09
like the Change timestamp: 2011-01-25 20:28:48.894851740 +0100
that appears in the cp15731.=20

>=20
> Then, let's look back in a different perspective.
>=20
> As you know, the lscp command displays the total number of inodes
> (ICNT). Does it match the actual number of files and directories ?

Last line :=20
5631  2011-02-07 20:27:54   cp    -         21         10

And=20
philippe@micro11:~$ find /mnt/tmp1                  =20
/mnt/tmp1
/mnt/tmp1/.nilfs
/mnt/tmp1/capture
/mnt/tmp1/capture/f3_20110107_205154.ts
/mnt/tmp1/capture/tf1hd_20101219_203305_schrek2.ts
/mnt/tmp1/capture/f2_20110130_174456.ts
/mnt/tmp1/capture/f4_20110119_204007.ts
/mnt/tmp1/capture/f3_20110206_144851.ts
/mnt/tmp1/channels.conf
/mnt/tmp1/cut
/mnt/tmp1/cut/f3_20110206_145141.ts(0).Xcl

gives 10 files for me. That seems OK.

Recently I noticed this message in dmesg :
=46eb  8 21:34:29 localhost kernel: nilfs_palloc_commit_free_entry: ent=
ry number 14 already freed
and
=46eb  6 20:53:30 localhost kernel: nilfs_palloc_commit_free_entry: ent=
ry number 19 already freed
(remember inode 19 was the second file's one)

and the system hangs on umount the nilfs (slow task I presume) :=20
=46eb  7 22:21:50 localhost nilfs_cleanerd[1819]: shutdown
=46eb  7 22:21:50 localhost kernel: nilfs_palloc_commit_free_entry: ent=
ry number 14 already freed
=46eb  7 22:22:10 localhost kernel: nilfs_palloc_commit_free_entry: ent=
ry number 14 already freed
=46eb  7 22:25:12 localhost -- MARK --
=46eb  7 22:27:02 localhost kernel: umount.nilfs2 D ffff88003f861bc0   =
  0  2499   2498 0x00000000
=46eb  7 22:27:02 localhost kernel: ffff88002c2cbc28 0000000000000086 f=
fff88002c2cbfd8 ffff88002c2cbfd8
=46eb  7 22:27:02 localhost kernel: ffff88002c2cbfd8 ffff88003f861bc0 f=
fff88002c2cbfd8 ffff88002c2cbfd8
=46eb  7 22:27:02 localhost kernel: ffff88002c2cbfd8 ffff88003f861ea0 f=
fff88002c2cbfd8 ffff88002c2ca000
=46eb  7 22:27:02 localhost kernel: Call Trace:
=46eb  7 22:27:02 localhost kernel: [<ffffffff810480bc>] ? finish_task_=
switch+0x3c/0xd0
=46eb  7 22:27:02 localhost kernel: [<ffffffff813a3ca1>] ? schedule+0x3=
81/0xaa0
=46eb  7 22:27:02 localhost kernel: [<ffffffff810e62f0>] ? find_get_pag=
es_tag+0x100/0x130
=46eb  7 22:27:02 localhost kernel: [<ffffffff813a49bd>] schedule_timeo=
ut+0x2bd/0x340
=46eb  7 22:27:02 localhost kernel: [<ffffffff810eea44>] ? write_cache_=
pages+0x114/0x4e0
=46eb  7 22:27:02 localhost kernel: [<ffffffff8104ee9b>] ? check_preemp=
t_wakeup+0x18b/0x240
=46eb  7 22:27:02 localhost kernel: [<ffffffff810ee3f0>] ? __writepage+=
0x0/0x40
=46eb  7 22:27:02 localhost kernel: [<ffffffff813a37d0>] wait_for_commo=
n+0xc0/0x160
=46eb  7 22:27:02 localhost kernel: [<ffffffff8104fe00>] ? default_wake=
_function+0x0/0x10
=46eb  7 22:27:02 localhost kernel: [<ffffffff813a3918>] wait_for_compl=
etion+0x18/0x20
=46eb  7 22:27:02 localhost kernel: [<ffffffff81159333>] sync_inodes_sb=
+0x83/0x180
=46eb  7 22:27:02 localhost kernel: [<ffffffff8115de00>] __sync_filesys=
tem+0x80/0x90
=46eb  7 22:27:02 localhost kernel: [<ffffffff8115de73>] sync_filesyste=
m+0x43/0x60
=46eb  7 22:27:02 localhost kernel: [<ffffffff811373df>] generic_shutdo=
wn_super+0x2f/0x100
=46eb  7 22:27:02 localhost kernel: [<ffffffff811374dc>] kill_block_sup=
er+0x2c/0x50
=46eb  7 22:27:02 localhost kernel: [<ffffffff81137825>] deactivate_loc=
ked_super+0x45/0x60
=46eb  7 22:27:02 localhost kernel: [<ffffffff811386b5>] deactivate_sup=
er+0x45/0x60
=46eb  7 22:27:02 localhost kernel: [<ffffffff81151436>] mntput_no_expi=
re+0x86/0xf0
=46eb  7 22:27:02 localhost kernel: [<ffffffff81151f37>] sys_umount+0x6=
7/0x370
=46eb  7 22:27:02 localhost kernel: [<ffffffff8100bf12>] system_call_fa=
stpath+0x16/0x1b
=46eb  7 22:29:02 localhost kernel: umount.nilfs2 D ffff88003f861bc0   =
  0  2499   2498 0x00000000

Now I don't use this filesystem. I just keep it for debug and umount if=
 OK.

Regards,

PhC
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
