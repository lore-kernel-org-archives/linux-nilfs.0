From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: attempt to access beyond end of device
Date: Mon, 24 Mar 2014 21:49:18 +0100
Message-ID: <20140324204917.GA4686@wloczykij>
References: <20140324071357.GY4686@wloczykij>
 <1395646655.2178.20.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0rpW5bEisVBStM29"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1395646655.2178.20.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--0rpW5bEisVBStM29
Content-Type: multipart/mixed; boundary="EcLUEBHJhOmOUQ0C"
Content-Disposition: inline


--EcLUEBHJhOmOUQ0C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2014 at 11:37:35AM +0400, Vyacheslav Dubeyko wrote:
> Hi Piotr,
>=20
> On Mon, 2014-03-24 at 08:13 +0100, Piotr Szymaniak wrote:
> > Hello,
> >=20
> > I'm running nilfs2 on Raspberry Pi and some time ago it got some
> > problem.
> >=20
> > Connected the SD card to my PC today and mounted the fs, the cleaner
> > started and few minutes later it remounted the fs readonly. Here's the
> > dmesg part:
> >=20
> > [ 1109.889697] mmcblk0: mmc0:b368 SMI   7.51 GiB=20
> > [ 1109.891261]  mmcblk0: p1 p2 p3
> > [ 1129.467450] NILFS warning: mounting unchecked fs
> > [ 1129.956859] NILFS: recovery complete.
> > [ 1129.960064] segctord starting. Construction interval =3D 300 seconds=
, CP frequency < 30 seconds
> > [ 1129.979344] NILFS warning: mounting fs with errors
> > [ 1283.005874] attempt to access beyond end of device
> > [ 1283.005882] mmcblk0p3: rw=3D8192, want=3D145241775180196072, limit=
=3D15120384
>=20
> I see that it was requested 8 KB block. How did you create file system?

That was some time ago, so I'm unable to answer this question. But
nilfs-tune shows 4KB blocks:

~ # nilfs-tune -l /dev/sdf3
nilfs-tune 2.1.6
Filesystem volume name:   (none)
Filesystem UUID:          53760664-f9ed-4c8d-af42-c6ee2f16d956
Filesystem magic number:  0x3434
Filesystem revision #:    2.0
Filesystem features:      (none)
Filesystem state:         invalid or mounted,error
Filesystem OS type:       Linux
Block size:               4096
Filesystem created:       Fri Aug  3 08:37:06 2012
Last mount time:          Mon Mar 24 07:55:53 2014
Last write time:          Mon Mar 24 07:58:04 2014
Mount count:              100
Maximum mount count:      50
Reserve blocks uid:       0 (user root)
Reserve blocks gid:       0 (group root)
First inode:              11
Inode size:               128
DAT entry size:           32
Checkpoint size:          192
Segment usage size:       16
Number of segments:       922
Device size:              7741636608
First data block:         1
# of blocks per segment:  2048
Reserved segments %:      5
Last checkpoint #:        770589
Last block address:       595617
Last sequence #:          41763
Free blocks count:        395264
Commit interval:          300
# of blks to create seg:  0
CRC seed:                 0x3e0bea06
CRC check sum:            0x2596b671
CRC check data size:      0x00000118



> Could you share the superblock content?

If my calculations are correct (it's the second superblock, right?), it sho=
uld
be:
dd if=3D/dev/nilfs of=3Ddump bs=3DBlock size skip=3DDevice size / Block siz=
e - 1
count=3D1

Attached this one.


> > Should I check the card in the first place?
> >=20
>=20
> Currently, I suspect that you have bad SD card. But, maybe, you have
> something different.

Maybe I will check it.


Piotr Szymaniak.
--=20
(...) wszystko to sprawilo,  iz przekroczyl owa umowna  granice,  ktora
jego przyjaciel,  prawnik Dan Tabares,  nazywal linia MTWD. Gdy raz juz
przekroczyles linie  MTWD  cokolwiek by sie zdarzylo, ty po prostu Masz
To W Dupie.
  -- Graham Masterton, "The Burning"

--EcLUEBHJhOmOUQ0C
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="dump.1890048.gz"
Content-Transfer-Encoding: base64

H4sICD6ZMFMAA2R1bXAuMTg5MDA0OABjYgABExMJRgYGtlfcdvGBT3cwAUVmMTNAQcFZoBQD
I4zLwcDACqQUDnGDuQvEOcG08mKovAUbmJpUKB0Aon9e0w8G0d3XIXQKgxEDE9A0mDyD31uY
yQwgExsYFBgOMAgwBJexpfx869O73unYO32xm2EMVAY6jITVjIJRMApGwSgYBaNgFIyCUTAK
RsEoGAXDBQAAPNUFuAAQAAA=

--EcLUEBHJhOmOUQ0C--

--0rpW5bEisVBStM29
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTMJpNAAoJEEMpAov1cw9lgrwP/iPSoykdU3ZF6chi+EySvbxz
pfxU0Krc+9c4h+UR0mdEUvGcAvi6cTGnYJ7zJB+Zo9pg/8Y82OW8+7IsaB8qYiZz
rNRbmm7z7Xea+vHEe/TQjeKr+ZoCwrmQ659T9QhHq9KPzL7pz8irlgWFC8jC/5c3
y4XT8H16zxMqllNCJ95tMQsY7mTvIFKl4X7tDFacS8Cm8MjKhB9vovttM/5T0kPe
Ml43QbOqDVmXr0QInfpJsGX5G80cjDDbFr1hwCBrQn+of+OzfJv8QJNAz6i/fxYc
H1L2ppBosUYSeS1kZMZjy0Uh8A0JIJyZJdpQgSA83NwGvHH5JSGkWO+z/5IuW6Wm
ujoG/sxwQnC5HWG9biJA3gDy/SpuPWBrp3i2xgTES0rnHnIeLydQUfWiWINenDzX
cVj2IZhqbebZCZDs3zNSbTHI7JRYrb9PNt60SRE6GHm3UafGl7SdLRceC69c2Wbr
jMQWkVZk17AX06BipDTmeEd3PKUuBWO0+q2yMaDt+jkrJ5zKT5XeWiXuFxDZtw2S
/QgSQ7DBuTuxqVsOA7OqYzhiALHcTTHO55wmbRxP0Zi3aVUl4LhqPSA1/nsOVxTi
tCBZdYTKdb6tzNZ51Ypl72/G2Ct7q40bnOWdKsM+UGM9gkRyR4geM735yGm2WBbu
pXgiVJUDzSxmtYpRkkCQ
=X2+V
-----END PGP SIGNATURE-----

--0rpW5bEisVBStM29--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
