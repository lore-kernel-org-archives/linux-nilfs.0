From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Bug : reuse same inode
Date: Mon, 07 Feb 2011 13:02:14 +0900 (JST)
Message-ID: <20110207.130214.221723444.ryusuke@osrg.net>
References: <20110206200928.633fa00c@micro24>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110206200928.633fa00c@micro24>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: liste-ZXOCcuNttmoBe96aLqz0jA@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 6 Feb 2011 20:09:28 +0100, Philippe CHATAIGNON wrote:
> Hi all,
>=20
> I use nilfs2 on a lvm partition for recording dvb streams : it create=
s
> big files and I often deleted them quickly so there only a few files =
on the partition.
>=20
> Today I notice a problem : where a new file were created, it takes th=
e same inode that a file already have.=20
> So the previous file were lost, like if an hard link was made.
>=20
> philippe@micro11:~$ ls -li $v
> total 30051016
> 14 -rw-r--r-- 1 philippe users    93849600  6 f=E9vr. 14:51 f2_201101=
30_174456.ts
> 16 -rw-r--r-- 1 philippe users  8606489600  9 janv. 15:42 f3_20110107=
_205154.ts
> 14 -rw-r--r-- 1 philippe users    93849600  6 f=E9vr. 14:51 f3_201102=
06_144851.ts
> 19 -rw-r--r-- 1 philippe users 10623052800  6 f=E9vr. 19:55 f3_201102=
06_145141.ts
> 15 -rw-r--r-- 1 philippe users  4688870400 19 janv. 23:14 f4_20110119=
_204007.ts
>=20
> The file created today is f3_20110206_144851.ts : it reuse inode 14
> that the file f2_20110130_174456.ts already had. On the third column,=
 you can see there=20
> is only one link (and not 2 as if ln was used).
>=20
> Of course, I can use a snapshot to recover the old file (f2_20110130_=
174456.ts).=20
>=20
> philippe@micro11:~$ ls mnt/snap2/capture -li
> total 32584848
> 20 -rw-r--r-- 1 philippe users     4812800  5 f=E9vr. 17:43 canal_201=
10205_172318.ts
> 14 -rw-r--r-- 0 philippe users 13390412800 31 janv. 01:00 f2_20110130=
_174456.ts=20

This directory list is already broken because the link count of
"f2_20110130_174456.ts" is zero.

Can you track the past state of this file from earlier checkpoints ?

Thanks,
Ryusuke Konishi

> 16 -rw-r--r-- 1 philippe users  8606489600  9 janv. 15:42 f3_20110107=
_205154.ts=20
> 15 -rw-r--r-- 1 philippe users  4688870400 19 janv. 23:14 f4_20110119=
_204007.ts
>=20
> I run Archlinux x86_64 on 2.6.37. It's my first bug report.=20
> Ask me for additionnal information if I could help.
>=20
> Regards,
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
