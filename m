From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Thu, 11 Oct 2012 20:03:32 +0200
Message-ID: <20121011180332.GE27763@wloczykij>
References: <20121009105239.GV28032@wloczykij>
 <1349784514.1921.9.camel@slavad-ubuntu>
 <20121009135833.GX28032@wloczykij>
 <20121010.012440.17932600.konishi.ryusuke@lab.ntt.co.jp>
 <20121010073912.GA28032@wloczykij>
 <1349870593.1889.107.camel@slavad-ubuntu>
 <20121010220331.GA27763@wloczykij>
 <1349938258.1908.3.camel@slavad-ubuntu>
 <20121011092300.GB27763@wloczykij>
 <1349950320.1908.11.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5Mfx4RzfBqgnTE/w"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1349950320.1908.11.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--5Mfx4RzfBqgnTE/w
Content-Type: multipart/mixed; boundary="VUDLurXRWRKrGuMn"
Content-Disposition: inline


--VUDLurXRWRKrGuMn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 11, 2012 at 02:12:00PM +0400, Vyacheslav Dubeyko wrote:
> On Thu, 2012-10-11 at 11:23 +0200, Piotr Szymaniak wrote:
> > So I should dump block 743205 and 734158? Ok, but I'm not familiar with
> > blkoff.
> >=20
> > ie. blkoff =3D 2, blocknr =3D 734205 it means the dump should be block
> > 734205 and (blkoff =3D 2) next two blocks? If this is correct then this
> > should work, right?
> > dd if=3D/dev/<device> of=3D<dump> bs=3D2048 skip=3D734205 count=3D3 (no=
t sure if
> > dd counts skip=3D and count=3D from 0 or 1)
> > And similar with block 734158 but only one block (blkoff =3D 0)?
> >=20
>=20
> Sorry, I confuse you by blkoff mentioning. The blkoff is logical offset f=
rom file begin (for example, from ifile begin). You need to take into accou=
nt only blocknr.
>=20
> It needs to dump block 743205 and 734158. Your superblock's content infor=
ms that block size is 4096 bytes.
>=20
> For example, dd if=3D/dev/<device> of=3D<dump> bs=3D4096 skip=3D734205 co=
unt=3D1

Block 743205 is empty:
maszyn tmp (: cat dump.743205
maszyn tmp (: hexdump dump.743205
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0001000

Block 734158 attached.

Piotr Szymaniak.
--=20
W   tamtych   latach   wiejskie   rodziny   chodzi=C5=82y  do  l=C3=B3=C5=
=BCka  bardzo
wcze=C5=9Bnie - "kiedy  robi=C5=82o  si=C4=99  ciemno  pod  sto=C5=82em",  =
jak mawia=C5=82a moja
w=C5=82asna matka - i spa=C5=82y kamiennym snem.
  -- Stephen King, "The Green Mile"

--VUDLurXRWRKrGuMn
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="dump.734158.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWY2XkFIAAF953f+tQEAAASpAP/ffMCAEAgBAAEAAAACrDjAAuMMNDTQA0ABo
AAZDQRMjSaaGmkANAGQA0eQGJSaZAGjEYhoaaNABmpUz8BhLMBZAMddeXU1oJ1yZgSSkSY0k
SUCESiJGSn0c68Nl/bmDAl/u0c/h4ACaWeZBKhBgkgHyRsRNNLE/Pt1tznQWdvOS9E50QDwA
SISqVEo0wnP6u4DLzFsCk4wA1XQoSlK7AOZbRBiYjTN1i0mSgZE36/wYRvJ2Un1SMN65wcSh
PByO6i2CHwQQigcRdyRThQkI2XkFIA==

--VUDLurXRWRKrGuMn--

--5Mfx4RzfBqgnTE/w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQdwn0AAoJEEMpAov1cw9l1sYP/0gmJi65VN9w6GZL3bEpY1l9
IVqawA712cc+U5pTiwe8XnkkDaYtxCjCbcENnhOqzzSoa7Jj67inzQX1AVlqFvdT
XE/Ca4Pbxo9PMCDE9KP69Gr32sH6oumhMGH4sUL8nzVIMl+XDu4pAxOi7dBloqpL
k54c9kTBvRtSAIaV5FaLbUuByt3x/CphvNyBplyKbHpPF14NY40+f6+ZfTIjkTqw
T2ky4OdS2q2u/IQ62Covh1ICAQ+7dMOWS9NsUmTrVTbK/Y5PUaddaLxx6qUXGgCD
uSjHDloPz62v2sI48jxYIrvyzOqiOIQvyVisntynJLNw2Wmk01ObqHCkT49QVWQJ
ils9Z2xq7cH/72uoJe75sVCO1tqu6SUUZ/lT8D5WY6MczhQSvIp3SxlaUHpaf8eU
h5GioNrJUV0WCrLiy2pf83SIQkBKKxE0E/oJpd0m25ELdpXhDr5UEFR7xxxhpYyg
lVUgx+Sy/esh8eiAb+d6P7ttMxLx5i7SFd4OHBXzHjH67waEBmcEvy4c3VjNh68u
VhLlIPYcwGwdjEmJNjzSGueMoiwEwA3bOrf1TpG1F1PbCjCAMxRuGlsyjFejBb59
WlrcNDImPhd4oVc+rxgDJMnnul+gdp4bP3aliYRXcrcucEtuzWQiXv/Eqc87ddlQ
drHJUwWEihaxGgl7XEt0
=fI8J
-----END PGP SIGNATURE-----

--5Mfx4RzfBqgnTE/w--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
