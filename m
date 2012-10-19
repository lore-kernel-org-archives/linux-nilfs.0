From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Fri, 19 Oct 2012 12:14:21 +0200
Message-ID: <20121019101421.GT27763@wloczykij>
References: <20121011180332.GE27763@wloczykij>
 <1350025832.2026.43.camel@slavad-ubuntu>
 <20121012103119.GF27763@wloczykij>
 <1350040053.2026.47.camel@slavad-ubuntu>
 <20121012114043.GG27763@wloczykij>
 <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC@dubeyko.com>
 <20121014200836.GK27763@wloczykij>
 <1350281888.2488.9.camel@slavad-ubuntu>
 <20121018201528.GS27763@wloczykij>
 <1350628991.2028.25.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/CHBEyLWSSL2QXIQ"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1350628991.2028.25.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--/CHBEyLWSSL2QXIQ
Content-Type: multipart/mixed; boundary="TegBI+r9roYdcP94"
Content-Disposition: inline


--TegBI+r9roYdcP94
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 19, 2012 at 10:43:11AM +0400, Vyacheslav Dubeyko wrote:
> As I can see, both dumps contains blocks of ifile with inodes
> description.
>=20
> I check previous e-mails and can see that maybe you dump not proper
> block. Maybe it is my misspelling in some e-mail. It needed to dump
> #734205 but as I can see you share dump of #743205 block. Firstly, to
> check that block #734205 is really empty. Because if it is not empty
> then the situation is different.

It looks more like my misspelling when I asked about how should I make
raw dump and after that it already was 743* instead of 734*. So my fault
here.

The dump looks like non-empty (attached), so I skipped this experiment
below.


>=20
> If the block #734205 is empty then I suggest to make some experiment:
>=20
> 1. Prepare dump of the corrupted partition:
>=20
> dd if=3D<partition (/dev/sdb1)> of=3D<image file>
>=20
> 2. Setup loop device for the image:
>=20
> losetup /dev/loop0 <image file>
>=20
> 3. Copy block #719300 of ifile (ino =3D 6) with blkoff =3D 2 of checkpoint
> #1843 into empty block #734205 (checkpoint #1874):
>=20
> dd if=3D/dev/loop0 of=3D/dev/loop0 bs=3D4096 skip=3D719300 seek=3D734205 =
count=3D1
>=20
> 4. Try to mount the loop device.
>=20
> Please, share results (console output and dmesg output) of this trying
> to mount.
>=20
> But, please, first of all, CHECK THAT TARGET BLOCK IS REALLY EMPTY. This
> manual manipulation can lead to loosing some filesystem state. Moreover,
> it can't fully recover filesystem but maybe driver can recover
> filesystem and to mount.

--=20
 Piosenki  maj=C4=85  do=C5=9B=C4=87  proste i skonstruowane wed=C5=82ug zn=
anego  schematu:
istota-ch=C5=82opiec spotyka w =C5=9Bwietle srebrnego ksi=C4=99=C5=BCyca is=
tot=C4=99-dziewczyn=C4=99,
ksi=C4=99=C5=BCyc z bli=C5=BCej nie wyja=C5=9Bnionych przyczyn wybucha.
  -- Douglas Adams, "Restaurant at The End of The Universe"

--TegBI+r9roYdcP94
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="dump.734205.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWQ1uZtsAAIv////3a/1/dP/eZT/7MNV54s1tfvfdJ/+Bto98z/whXgDbwAJc
AkKoaiSM1MQNNBoGmgGmQBppkAAAADQaAAaAA0ANA0GgaaANNB6nqIA000000whkyGQYTQ0Y
AhoYE0ZGEGTTRoAMEaGIYmmTTEYRgTRowmgQBpppppphDJkMgwmhowBDQwJoyMIMmmjQAYI0
MQxNMmmIwjAmjRhNAJEk0mkTNAmkZP1J7Um1GCMmmj0mjTNBDGkMAQYQZDCYRoGmmgyabaoD
QZM1PTSeRPZa131ki01KUQEEQkyHGvH1nA1SxBDRWFdpAQYD3bcQ3hnCl0tpIGVktK788O+0
6uTNu0zcRVeM8A1Fxe6zNXWbQXWq8urV3E7NzazVFFi6YrDbaG3hyLuQr9KE87AqbTrs0Hj6
2kVcy4FANICJwkgQi20JcQWy59iTY01DiI9tsJiri6pABYrQkF/vPRVYVBJgptB+WNAtE0qK
oSK7jqd15FATYEzuVpbuJ0fUEligYo220mhoYVqmqGGDQponovONhVUhfS0kQ0aT7oJPWbTk
eKFuYrOy2fsXuF8HzRUZ2HlOGgaAhSFBHtAFlDcRCeF5eZvzyZxx1K4X1N1FXMoyqFl8zZwz
XZ2tvc9/h38vMbHkG31LLQrWsF1oyHl+cfoaYkMYpTEgQKnoNdfYKgIaU0oIYCk6e1oLHmRf
ulnEIOTLJLg+/mRG1V8SpqJGYFB1yyDDqsBs6ZWJvld4s5RlLqYlnpfhjxrRhiNSpnNKgFTB
GNg7yPotXyNLULPY5+n5jR87MOr/C3p8LmzDQjLZ2yEVx3ezLZmCwPIwbnrgutjh8nbJ3WqI
9+X4o1KWImDrftepHdEbr2cLlY5H4wFkjOAB0wRKYO8UqO5y5qzW7q7KR1BAj8XAeAq+AS5C
bCs8oycvJaMwlzO+tSF9r1jYGR3i8kqRmLEGGZGQU0UNnBQ14JhCtDaiNDsI49VnfqE9CDif
x6xCSqACZOQGqGKg889oAiHcs98u9AG+SMu8vCYznk6X/4u5IpwoSAa3M22A

--TegBI+r9roYdcP94--

--/CHBEyLWSSL2QXIQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQgSf8AAoJEEMpAov1cw9lg90P+gN8FVCyb++o4qgBU4CyS7VM
lF93hB2PlmQle/jhhN6DXafFiXlo/zNGYiiYLmH1s8VDgfcwmXrvEa0UMEEP1y9+
BM9f5fasouYCJnU54HQDlQLY2CataOQGxpDJ0ymW3swVtU2kagIlTnGKgR9hdDMr
vvRJvN5Yrf5Gk28U7x8VD3ZYH1jYrOsNpmv3RbjPoNYDvML3a/Yb5ZcLiXVMaQha
MVhcKLlmtaQibM0q5AVsuHUssOLqzPvPN0S9ME7SPISV73v+181Mv0V+vmao0XHn
W54Kmxv0a6gIkAq8UmZ7g1hbP562UANVDxdeGcOldxx9VcwmBYzmelKx/+N7UQDv
d08SDd5ADA4PATxt446Mp57dzVCeAYGww914nxVSeHiNdje1xFymVvQpRha3m4Af
ZazFm40Jz+C6GTze1oWtTG0LRzieCo/zo89Kq3Xtt4emjfa8fo9YHEJfaccABti9
6xFKqwKa+qzM5qtFLINUKM94z9yygLJBi3wpphv1CLZO4KqEXIPkHmgL0YU8Pr2D
AtnRSyPq6heBp/riWmM3TcImioPiLdTU/ef1HzgQtF7i1JdHUoi4yjISf8ttacfA
d2bV5zUcTJo9Dzc9I0hzYZEUR1uNvzfN3jY10atkLg96pfNu3e4IJYyTIntV0QAx
wsJjBRoEep4PIe+kdu+h
=xF3h
-----END PGP SIGNATURE-----

--/CHBEyLWSSL2QXIQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
