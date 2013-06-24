From: Bryce Gibson <bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org>
Subject: Re: Corrupt root inode
Date: Mon, 24 Jun 2013 14:53:27 +1000
Message-ID: <1372049607.20711.140661247647122.68C1544E@webmail.messagingengine.com>
References: <1372043988.4304.140661247622873.2030B278@webmail.messagingengine.com>
 <1372048664.18072.140661247643486.0DCAEA3F@webmail.messagingengine.com>
Reply-To: bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	messagingengine.com; h=message-id:from:to:mime-version
	:content-transfer-encoding:content-type:reply-to:in-reply-to
	:references:subject:date; s=smtpout; bh=U5+A3gMuKlhEfLiAcbGO+5GL
	CD4=; b=Tntodz7PxK9OhKyD1z0uqnnY0zQz0iG7Jv8D6/QF399bBU3pu0wBjPK1
	V3jMdL676T3Uylq78TIxxgK1KaLhRZD8PkoiLumar0X/uMr69sTyfo8BpcXU6q4q
	ZHEizF3aDNoQRX3MJBUi58T3LCQJXm1KW1cetadd3G2sFTp7MyM=
In-Reply-To: <1372048664.18072.140661247643486.0DCAEA3F-2RFepEojUI2N1INw9kWLP6GC3tUn3ZHUQQ4Iyu8u01E@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

*sigh*

Just realised that that's the wrong segment...
The dumpseg for the last block address segment (405504) is below;=A0

` dumpseg /dev/loop3 $((405504 / 2048 )) `

Apologies for the spaminess :-(

segment: segnum =3D 198
=A0 sequence number =3D 568326, next segnum =3D 199
=A0 partial segment: blocknr =3D 405504, nblocks =3D 13
=A0 =A0 creation time =3D 2013-06-23 01:00:59
=A0 =A0 nfinfo =3D 1
=A0 =A0 finfo
=A0 =A0 =A0 ino =3D 3, cno =3D 0, nblocks =3D 11, ndatblk =3D 0
=A0 =A0 =A0 =A0 blkoff =3D 255, level =3D 1, blocknr =3D 405505
=A0 =A0 =A0 =A0 blkoff =3D 510, level =3D 1, blocknr =3D 405506
=A0 =A0 =A0 =A0 blkoff =3D 2295, level =3D 1, blocknr =3D 405507
=A0 =A0 =A0 =A0 blkoff =3D 3570, level =3D 1, blocknr =3D 405508
=A0 =A0 =A0 =A0 blkoff =3D 4590, level =3D 1, blocknr =3D 405509
=A0 =A0 =A0 =A0 blkoff =3D 4845, level =3D 1, blocknr =3D 405510
=A0 =A0 =A0 =A0 blkoff =3D 5100, level =3D 1, blocknr =3D 405511
=A0 =A0 =A0 =A0 blkoff =3D 5355, level =3D 1, blocknr =3D 405512
=A0 =A0 =A0 =A0 blkoff =3D 5610, level =3D 1, blocknr =3D 405513
=A0 =A0 =A0 =A0 blkoff =3D 5738, level =3D 1, blocknr =3D 405514
=A0 =A0 =A0 =A0 blkoff =3D 0, level =3D 2, blocknr =3D 405515

--=20
  Bryce Gibson
  bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org

On Mon, Jun 24, 2013, at 02:37 PM, Bryce Gibson wrote:
> Ps,
> I've attached the output of `dumpseg /dev/loop4 0 > dumpseg.txt` inca=
se
> it helps :-)
>=20
> Cheers again,
> Bryce
>=20
> --=20
>   Bryce Gibson
>   bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org
>=20
> On Mon, Jun 24, 2013, at 01:19 PM, Bryce Gibson wrote:
> > Hi :-)
> >=20
> > I have a root nilfs partition that appears to have been corrupted.
> >=20
> > When I try to mount the partition - either on boot or with a liveus=
b -
> > I'm getting "NILFS: corrupt root inode".
> >=20
> > I don't believe anything too exciting happened on the last shutdown=
, but
> > it's entirely possible that the umount/sync command didn't execute
> > correctly.
> >=20
> > I've tried mounting with with two kernels, being 3.9 and 3.9.4
> >=20
> > In the first case nilfs is built in, in the second it's a module.
> >=20
> > This is an x86_64 laptop.
> >=20
> > I was hoping someone might be able to offer some help with trying t=
o
> > recover the partition :-)
> >=20
> > I'm happy to provide any useful info from the drive :-)
> >=20
> > Cheers :-)
> > Bryce
> >=20
> >=20
> >=20
> > nilfs-tune -l /dev/loop4
> > --------------------------
> > nilfs-tune 2.1.5
> > Filesystem volume name:  =A0(none)
> > Filesystem UUID:         =A0fb7fe0c7-f6ef-44e9-8fd7-0125801e5f36
> > Filesystem magic number: =A00x3434
> > Filesystem revision #:   =A02.0
> > Filesystem features: =A0 =A0 =A0(none)
> > Filesystem state:        =A0valid
> > Filesystem OS type:      =A0Linux
> > Block size:              =A04096
> > Filesystem created:      =A0Fri Aug 17 00:26:09 2012
> > Last mount time:         =A0Sat Jun 22 04:18:22 2013
> > Last write time:         =A0Sun Jun 23 01:00:59 2013
> > Mount count:             =A0691
> > Maximum mount count:     =A050
> > Reserve blocks uid:      =A00 (user root)
> > Reserve blocks gid:      =A00 (group root)
> > First inode:             =A011
> > Inode size:              =A0128
> > DAT entry size:          =A032
> > Checkpoint size:         =A0192
> > Segment usage size:      =A016
> > Number of segments:      =A0269
> > Device size:             =A02264924160
> > First data block:        =A01
> > # of blocks per segment: =A02048
> > Reserved segments %:     =A05
> > Last checkpoint #:       =A0373808
> > Last block address:      =A0405504
> > Last sequence #:         =A0568326
> > Free blocks count:       =A073728
> > Commit interval:         =A00
> > # of blks to create seg: =A00
> > CRC seed:                =A00x44983069
> > CRC check sum:           =A00xced8962d
> > CRC check data size:     =A00x00000118
> >=20
> > --=20
> >   Bryce Gibson
> >   bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org
> Email had 1 attachment:
> + dumpseg.txt
>   88k (text/plain)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
