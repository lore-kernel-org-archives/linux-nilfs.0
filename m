From: =?UTF-8?Q?=C5=81ukasz_W=C3=B3jcicki?= <lwojcicki-V+nj596LuoKHKKo6LODCOg@public.gmane.org>
Subject: Re: problem with nilfs_cleanerd - part 2
Date: Wed, 07 Jul 2010 12:48:49 +0200
Message-ID: <1278499729.8049.31.camel@Stanowisko-25>
References: <1278406961.8438.6.camel@Stanowisko-25>
	 <20100707.150225.135808641.ryusuke@osrg.net>
	 <20100707.165348.25143177.ryusuke@osrg.net>
	 <1278498746.8049.26.camel@Stanowisko-25>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1278498746.8049.26.camel@Stanowisko-25>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



Dnia 2010-07-07, =C5=9Bro o godzinie 12:32 +0200, =C5=81ukasz W=C3=B3jc=
icki pisze:
> I notice another problem with nilfs_cleanerd :
>=20
> <2>nilfs_ioctl_move_inode_block: conflicting data buffer: ino=3D4, cn=
o=3D0,
> offset=3D0, blocknr=3D19063, vblocknr=3D2389
> <3>NILFS: GC failed during preparation: cannot read source blocks:
> err=3D-17
>=20
>=20
> =C5=81ukasz W=C3=B3jcicki
>=20

Problem disappeared after rmcp command .

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
