From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Thu, 11 Oct 2012 00:03:31 +0200
Message-ID: <20121010220331.GA27763@wloczykij>
References: <20121009105239.GV28032@wloczykij>
 <1349784514.1921.9.camel@slavad-ubuntu>
 <20121009135833.GX28032@wloczykij>
 <20121010.012440.17932600.konishi.ryusuke@lab.ntt.co.jp>
 <20121010073912.GA28032@wloczykij>
 <1349870593.1889.107.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1349870593.1889.107.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 10, 2012 at 04:03:13PM +0400, Vyacheslav Dubeyko wrote:
> I need in superblock's content anyway.
>=20
> Currently, I need in raw dumps from two blocks after dump preliminary ana=
lysis. Because you have message about root inode corruption then it needs t=
o check the root inode raw representation in ifile (ino =3D 6). As I can se=
e from your dump that the third block of ifile is located in 734205 block (=
blkoff =3D 2, blocknr =3D 734205). Also I can see that root inode content (=
ino =3D 2) is located in 734158 block ( blkoff =3D 0, blocknr =3D 734158).
>=20
> Could you share these 2 blocks content?
>=20
> Or you can check that these blocks contains expected metadata info. I exp=
ect that some of these blocks doesn't contains valid metadata info.

How should i make the dump?


Piotr Szymaniak.
--=20
Jesli  jego  talent byl darem bozym, to Bog jest niebezpiecznym szalen-
cem, ktorego nalezy natychmiast powstrzymac. Jesli Bog chcial usmiercic
Grega  Stillsona,  to czemu nie sprawil,  zeby pojawil sie na swiecie z
pepowina  owinieta wokol szyi?  Dlaczego nie udusil go kawalkiem miesa?
(...) Johnny  zdecydowal  nagle,  ze  pozwoli  Stillsonowi  zyc i w ten
sposob napluje Bogu w oczy.
  -- Stephen King, "The Dead Zone"

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQdfCzAAoJEEMpAov1cw9lrm0P/RAL3N1M7N8kVK/V9V2UMVyT
UbEX4uhuaHNtb32+Q2eowfvIrsIDx10AEsCzN1cVnkHjRDQXzWNzlKbvLOboFDlz
+1YsIt71ZOQV3bUoIK5sN4rE80HJBws7NEQuZrTcoumOi8N3yKnOwhf+g9IXwfQV
D6zwAF9X3tRJPxXU3dhcf/0IguVu2AEHhJ6IZ8NmX/RpLx/taLr9za0WcOtLj+Y0
1f8JEss/zZnun7dvtsLOCYgqAsJg//Nn1AGGlUzBaXGZUDU1HXA/3rhjU5+XUi7A
PkSbchqdl0ewqZldKxL582Dd0tvRVAYwsSleXylVcH9MoVA03RpNojNLGBbj46tC
w1k8xm40zMXBrEGdT8GaifjROQOawBpaMFGeMRsIXLW0u5GkvdQULwxCep4WVtRZ
sp9u27FwvA0ECvN569TZhnignTos7J3YOjCHnrJeU3JXoOk01SYbc9Xuf3+T5iLH
cCU9xF1bkXebJ0VnperzIcQ64JjAFlbAkCNj6E3m8NeRICcNI+Kewm3uElMjMo2o
RXOCuPmZricBDDnVYejI37l6c2agF7498ntojtmlJy8fRvgz/xNhW92XzNx9rb2m
yFa+ILUte7ibtPCZ79OnrmNTYQLjKAIgVUkyG+Gz+AdHustmxNDDmWtZYz47+DyN
e9hVwx7Mz/scZdEFBxda
=biyh
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
