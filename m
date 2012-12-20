From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Thu, 20 Dec 2012 10:08:33 +0400
Message-ID: <1355983713.2056.3.camel@slavad-ubuntu>
References: <86B5C141-ACFA-4541-999F-E17E09F22476@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=KOszKh6ldUjq9Q0t5MVsrzBkpCZFN/xJfahL4922yCw=;
	b=Js+Mz+eaTspu/KZNxP5pjVT56QTZRWoWYOGMGsAkWpQBhalAMzx+PyrJjZDZfl+c1tQ9tPLut3xH9MKQowjUV88NCS6YTDRDLjYhZkj1iHedjKBZvrv6Hru3Hzcieg97;
In-Reply-To: <86B5C141-ACFA-4541-999F-E17E09F22476-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=E5=BC=A0_=E7=A3=8A?= <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Thu, 2012-12-20 at 10:46 +0800, =E5=BC=A0 =E7=A3=8A wrote:
> Hello.
> 	My nilfs suddenly become read-only. I saw these logs in /var/log/mes=
sages:
>=20
> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D71=
0153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs_bm=
ap_lookup_contig: broken bmap (inode number=3D321775)
> Dec 19 11:20:05 localhost kernel:
> Dec 19 11:20:05 localhost kernel: Remounting filesystem read-only
> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D71=
0153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs_bm=
ap_lookup_contig: broken bmap (inode number=3D321775)
> Dec 19 11:20:05 localhost kernel:
> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D71=
0153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs_bm=
ap_lookup_contig: broken bmap (inode number=3D321775)
> Dec 19 11:20:05 localhost kernel:
> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D71=
0153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs_bm=
ap_lookup_contig: broken bmap (inode number=3D321775)
> Dec 19 11:20:05 localhost kernel:
> =E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=
=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=
=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6
>=20
> 	How can I fix this? There is 6TiB data on my disk, I don't want to f=
ormat the disk.
> 	I found that a lot of people have encountered the same problem. Is t=
his a bug of nilfs? How can I avoid this problem? When it happens, I wa=
s running multiple MySQL and rsync, and nilfs_cleanerd was cleaning seg=
ments.
>=20

Yes, this issue was reported earlier. As I understand, you can simply
remount your filesystem in read-write mode and to continue using your
NILFS2 filesystem.

If you will encounter any troubles with remounting, please, report abou=
t
it.

With the best regards,
Vyacheslav Dubeyko.


> Elmer Zhang--
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
