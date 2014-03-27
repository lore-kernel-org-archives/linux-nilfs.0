From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: attempt to access beyond end of device
Date: Thu, 27 Mar 2014 13:39:18 +0100
Message-ID: <20140327123918.GH30294@wloczykij>
References: <20140324071357.GY4686@wloczykij>
 <1395646655.2178.20.camel@slavad-CELSIUS-H720>
 <20140324204917.GA4686@wloczykij>
 <1395739090.2197.11.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cYtjc4pxslFTELvY"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1395739090.2197.11.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--cYtjc4pxslFTELvY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2014 at 01:18:10PM +0400, Vyacheslav Dubeyko wrote:
> On Mon, 2014-03-24 at 21:49 +0100, Piotr Szymaniak wrote:
>=20
> > That was some time ago, so I'm unable to answer this question. But
> > nilfs-tune shows 4KB blocks:
> >=20
> > ~ # nilfs-tune -l /dev/sdf3
> > nilfs-tune 2.1.6
> > Filesystem volume name:   (none)
> > Filesystem UUID:          53760664-f9ed-4c8d-af42-c6ee2f16d956
> > Filesystem magic number:  0x3434
> > Filesystem revision #:    2.0
> > Filesystem features:      (none)
> > Filesystem state:         invalid or mounted,error
> > Filesystem OS type:       Linux
> > Block size:               4096
> > Filesystem created:       Fri Aug  3 08:37:06 2012
>=20
> I suspect that you used this NILFS2 volume with kernel version that it
> was trouble with segments creation. So, you can have volume corruption
> because of this bug that it was fixed.
>=20
> (1) What Linux kernel version do use currently?

I think it was 3.6.y or 3.10.y


> (2) How long did you use old kernel versions?

I suppose at least since 2012-10.08 [1] as this is the same Raspberry Pi
and, afair, the same fs. So it was 3.2.27 and then some of (some of them
was unstable) 3.{6,10,11}.y


> (3) What workloads did you use for this volume?

It was almost idle except once a day or two accepting backup from
another machine (but that was kept on external drive/fs).


> (4) Had you situations of simultaneous working of several threads with
> intensive operations with volume (for example, simultaneous compilation
> and checking for updates)?

Could be, but compilation was made on external drive. nilfs holds the
rootfs and almost nothing more.


[1] http://marc.info/?l=3Dlinux-nilfs&m=3D134973563927736&w=3D2


Piotr Szymaniak.
--=20
Czekajcie,  czekajcie.  Ktos cos do mnie mowil,  ale nie wiem kto i nie
wiem co.
  -- Rafal Solecki

--cYtjc4pxslFTELvY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTNBv2AAoJEEMpAov1cw9lT+AP/A9bS8rEuXT9IBQhuVpPuC1a
QpDKcur8hCf7oczIYt7dNqqdQ5W25ZwvYheK2ZAW/oM4lJ/o0sLJ8hZJ53HRGzwh
k60C4pj/ojDVDmH92SbRSqHK3aF/LoDUaAoxylTutEECq2iUrGLvL/3f0IDqZL8W
QQypM7nI2R4BlCLuknaYkaG8XS+aFiu3GjzMflr0Q0AGAW4bihc6DS1GMX25Pexy
gvSxKGeJuAZ5C/CTTlc9d5eV8R4ogJIHp3xAWJmawvM7O0frNSinwOPridi0GN4s
7Or51PKFzlpJ/ytfH+lsZ8lMiVSwUg9uctx41gr1SwxO4e0Ihs9HoFfjzNJIo7+2
lygFWrmPrkbM2FoPOtNpU3AQjQBM3jgnl+CSQzXeTDiWwwahn+9Zs0So/l09DZ4V
1gE9l5zJlRXYvEDX5NiNP5C5m2ujcHas057WVdTYbQidASGivBeMmhHHoul1IRIi
Vten1wNWjvtyTGhe2TOtsPGJ0XIN1+FT3dz2pkIJ/cLf79OmK+b+Nu5KRqzZ8zf2
XI5NzEfMbbX+KUR90j1PYrxjmfmhGCzkOUMYMn2wh7rLjH7eoPr9eO9/4pZUvTPx
IvNfTYjXXNNFG/H3o1wIJxeoVvIaVEjAQ71VMu0zZM84sl1DKAbR0jFy6SMfOOq5
zL5fQmzOHl8eX0RflVUP
=R+nN
-----END PGP SIGNATURE-----

--cYtjc4pxslFTELvY--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
