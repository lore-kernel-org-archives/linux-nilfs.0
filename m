From: Philippe CHATAIGNON <liste-ZXOCcuNttmoBe96aLqz0jA@public.gmane.org>
Subject: Bug : reuse same inode
Date: Sun, 6 Feb 2011 20:09:28 +0100
Message-ID: <20110206200928.633fa00c@micro24>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

I use nilfs2 on a lvm partition for recording dvb streams : it creates
big files and I often deleted them quickly so there only a few files on=
 the partition.

Today I notice a problem : where a new file were created, it takes the =
same inode that a file already have.=20
So the previous file were lost, like if an hard link was made.

philippe@micro11:~$ ls -li $v
total 30051016
14 -rw-r--r-- 1 philippe users    93849600  6 f=E9vr. 14:51 f2_20110130=
_174456.ts
16 -rw-r--r-- 1 philippe users  8606489600  9 janv. 15:42 f3_20110107_2=
05154.ts
14 -rw-r--r-- 1 philippe users    93849600  6 f=E9vr. 14:51 f3_20110206=
_144851.ts
19 -rw-r--r-- 1 philippe users 10623052800  6 f=E9vr. 19:55 f3_20110206=
_145141.ts
15 -rw-r--r-- 1 philippe users  4688870400 19 janv. 23:14 f4_20110119_2=
04007.ts

The file created today is f3_20110206_144851.ts : it reuse inode 14
that the file f2_20110130_174456.ts already had. On the third column, y=
ou can see there=20
is only one link (and not 2 as if ln was used).

Of course, I can use a snapshot to recover the old file (f2_20110130_17=
4456.ts).=20

philippe@micro11:~$ ls mnt/snap2/capture -li
total 32584848
20 -rw-r--r-- 1 philippe users     4812800  5 f=E9vr. 17:43 canal_20110=
205_172318.ts
14 -rw-r--r-- 0 philippe users 13390412800 31 janv. 01:00 f2_20110130_1=
74456.ts=20
16 -rw-r--r-- 1 philippe users  8606489600  9 janv. 15:42 f3_20110107_2=
05154.ts=20
15 -rw-r--r-- 1 philippe users  4688870400 19 janv. 23:14 f4_20110119_2=
04007.ts

I run Archlinux x86_64 on 2.6.37. It's my first bug report.=20
Ask me for additionnal information if I could help.

Regards,

PhC
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
