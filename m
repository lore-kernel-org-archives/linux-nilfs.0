From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: attempt to access beyond end of device
Date: Mon, 24 Mar 2014 08:13:58 +0100
Message-ID: <20140324071357.GY4686@wloczykij>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kJZGYML2m3vFaueA"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--kJZGYML2m3vFaueA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I'm running nilfs2 on Raspberry Pi and some time ago it got some
problem.

Connected the SD card to my PC today and mounted the fs, the cleaner
started and few minutes later it remounted the fs readonly. Here's the
dmesg part:

[ 1109.889697] mmcblk0: mmc0:b368 SMI   7.51 GiB=20
[ 1109.891261]  mmcblk0: p1 p2 p3
[ 1129.467450] NILFS warning: mounting unchecked fs
[ 1129.956859] NILFS: recovery complete.
[ 1129.960064] segctord starting. Construction interval =3D 300 seconds, CP=
 frequency < 30 seconds
[ 1129.979344] NILFS warning: mounting fs with errors
[ 1283.005874] attempt to access beyond end of device
[ 1283.005882] mmcblk0p3: rw=3D8192, want=3D145241775180196072, limit=3D151=
20384
[ 1283.005891] attempt to access beyond end of device
[ 1283.005896] mmcblk0p3: rw=3D8192, want=3D36678440, limit=3D15120384
[ 1283.512451] init_special_inode: bogus i_mode (160444) for inode mmcblk0p=
3:59824
[ 1283.667864] attempt to access beyond end of device
[ 1283.667869] mmcblk0p3: rw=3D8192, want=3D5764893396078298024, limit=3D15=
120384
[ 1284.492368] init_special_inode: bogus i_mode (4620) for inode mmcblk0p3:=
17013
[ 1284.707910] mmcblk0: error -110 transferring data, sector 5236904, nr 24=
, cmd response 0x900, card status 0xb00
[ 1284.707926] mmcblk0: retrying using single block read
[ 1284.792489] mmcblk0: error -110 transferring data, sector 5236904, nr 24=
, cmd response 0x900, card status 0x0
[ 1284.792498] end_request: I/O error, dev mmcblk0, sector 5236904
[ 1284.877077] mmcblk0: error -110 transferring data, sector 5236905, nr 23=
, cmd response 0x900, card status 0x0
[ 1284.877091] end_request: I/O error, dev mmcblk0, sector 5236905
[ 1284.961660] mmcblk0: error -110 transferring data, sector 5236906, nr 22=
, cmd response 0x900, card status 0x0
[ 1284.961674] end_request: I/O error, dev mmcblk0, sector 5236906
[ 1285.046235] mmcblk0: error -110 transferring data, sector 5236907, nr 21=
, cmd response 0x900, card status 0x0
[ 1285.046246] end_request: I/O error, dev mmcblk0, sector 5236907
[ 1285.130754] mmcblk0: error -110 transferring data, sector 5236908, nr 20=
, cmd response 0x900, card status 0x0
[ 1285.130764] end_request: I/O error, dev mmcblk0, sector 5236908
[ 1285.215320] mmcblk0: error -110 transferring data, sector 5236909, nr 19=
, cmd response 0x900, card status 0x0
[ 1285.215332] end_request: I/O error, dev mmcblk0, sector 5236909
[ 1285.299926] mmcblk0: error -110 transferring data, sector 5236910, nr 18=
, cmd response 0x900, card status 0x0
[ 1285.299945] end_request: I/O error, dev mmcblk0, sector 5236910
[ 1285.384537] mmcblk0: error -110 transferring data, sector 5236911, nr 17=
, cmd response 0x900, card status 0x0
[ 1285.384554] end_request: I/O error, dev mmcblk0, sector 5236911
[ 1285.615295] init_special_inode: bogus i_mode (2024) for inode mmcblk0p3:=
2218
[ 1288.601672] attempt to access beyond end of device
[ 1288.601677] mmcblk0p3: rw=3D8192, want=3D145241775180196072, limit=3D151=
20384
[ 1288.601681] attempt to access beyond end of device
[ 1288.601683] mmcblk0p3: rw=3D8192, want=3D36678440, limit=3D15120384
[ 1290.442474] init_special_inode: bogus i_mode (160545) for inode mmcblk0p=
3:59808
[ 1290.677312] attempt to access beyond end of device
[ 1290.677317] mmcblk0p3: rw=3D0, want=3D12305576757786212880, limit=3D1512=
0384
[ 1290.677319] attempt to access beyond end of device
[ 1290.677321] mmcblk0p3: rw=3D0, want=3D12305576757786212880, limit=3D1512=
0384
[ 1290.677324] NILFS error (device mmcblk0p3): nilfs_readdir: bad page in #=
38030
[ 1290.677325] Remounting filesystem read-only
[ 1290.681553] attempt to access beyond end of device
[ 1290.681557] mmcblk0p3: rw=3D0, want=3D1231588818889969824, limit=3D15120=
384
[ 1290.681559] attempt to access beyond end of device
[ 1290.681560] mmcblk0p3: rw=3D0, want=3D1231588818889969824, limit=3D15120=
384
[ 1290.681563] NILFS error (device mmcblk0p3): nilfs_readdir: bad page in #=
38033
[ 1290.681578] attempt to access beyond end of device
[ 1290.681579] mmcblk0p3: rw=3D0, want=3D6682469067434422488, limit=3D15120=
384
[ 1290.681581] attempt to access beyond end of device
[ 1290.681582] mmcblk0p3: rw=3D0, want=3D6682469067434422488, limit=3D15120=
384
[ 1290.681584] NILFS error (device mmcblk0p3): nilfs_readdir: bad page in #=
38036
[ 1290.734000] init_special_inode: bogus i_mode (1752) for inode mmcblk0p3:=
38170
[ 1290.736411] init_special_inode: bogus i_mode (160545) for inode mmcblk0p=
3:59816
[ 1290.736419] init_special_inode: bogus i_mode (1752) for inode mmcblk0p3:=
59818
[ 1290.736424] init_special_inode: bogus i_mode (160545) for inode mmcblk0p=
3:38168
[ 1291.005227] init_special_inode: bogus i_mode (50004) for inode mmcblk0p3=
:2042
[ 1291.013041] init_special_inode: bogus i_mode (50444) for inode mmcblk0p3=
:2815


Should I check the card in the first place?


Piotr Szymaniak.
--=20
<kow`> "There are 10 types of people in the world... those who
understand binary and those who don't."
<SpaceRain> That's only 2 types of people, kow.
<SpaceRain> STUPID
  -- bash.org

--kJZGYML2m3vFaueA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTL9s1AAoJEEMpAov1cw9lFy0P/A6JDpmClqM3XV8utOGObuk8
P7HNivtHYi75FeBDelYp+M5D26aJVWV2EGuT+IVGhi6rXQD69IqXeW5klpsNK4h3
vjhwpU6X5oQ0vyHIMIzQVkwygtHnTWxxCPnJ88Gh+Qnxwu3qCYiFAoZXpnyT5XI1
PprPk2y2P3ApS08C+xVetE6UrGgnNypboQPhIePAfU4aF4G93vI/+hdMO0E+svIb
2PnFUUcTAcKO6PFSmmBmsPC47230Ro7p95gnBZvaoTkMiuhi95H8hUC8PfE70H0V
nqdjNzZuWbcjsP8GCV9uvFG4KGcXXKjMqxplTkZnSsYP7vF0YS+RYnwIU4c/hkoH
fKn+wnr3ozhuHvyBjifhfhTN66JNZazLJnLH3vl4o2ouodRdlE8xuIHv6x2Sp0iQ
v8Ikl9hSNHXMvGlmVDGoZvjQ2oVSRvbwkfUOKyQUYLpdyewTrDgjetTBXs/7ENJL
bGHNqO/xfS4moZds3Z/kyE0FYmKrys1Z0OkO4VtvjCOno//pfe/t1NIhU+hsa39C
CG/uh50NPTDdV4GppZQpBWoBESLTYdcmIUOVSZu1bUfYVF9+OmtwDeTHlM/uGNbV
3WkayLFQ0EYS3UChQK+hxJYk33W09utzlZ0rtI9pHmU1WvJ98WP0Oulmd/xCDjt7
MHqErffBUnwu3K0GMGNg
=InxU
-----END PGP SIGNATURE-----

--kJZGYML2m3vFaueA--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
