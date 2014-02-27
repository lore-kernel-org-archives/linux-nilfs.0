From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: snapshots contain the same rrd database
Date: Thu, 27 Feb 2014 11:58:07 +0100
Message-ID: <20140227105806.GA1845@wloczykij>
References: <20140226133201.GA2022@wloczykij>
 <20140227.114547.220041242.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140227.114547.220041242.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2014 at 11:45:47AM +0900, Ryusuke Konishi wrote:
> Hi Piotr,
> On Wed, 26 Feb 2014 14:32:02 +0100, Piotr Szymaniak wrote:
> > Hi,
> >=20
> > I got a system crash after some 160+ days uptime. After a hard reboot I
> > noticed my rrd database looks corrupted.
> >=20
> > So I changed some recent checkpoints to snapshots, mounted them and...
> > all the rrd files are the same!
> >=20
> > Here's some info about current state:
> <snip>
> > wloczykij ~ # uname -sr
> > Linux 3.4.56
>=20
> This version looks a bit old.  The current head of linux-3.4.y is
> v3.4.82.

Updated.


> The following important bug fixes are not included in this version:
>=20
>  $ git shortlog v3.4.56..v3.4.82 | grep nilfs
>    nilfs2: fix segctor bug that causes file system corruption
>    nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNO=
TSUPP error
>    nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTS=
UPP error detection
>=20
> Was it a distro kernel?

No, it's a hand made Gentoo kernel.


Piotr Szymaniak.
--=20
Czekajcie,  czekajcie.  Ktos cos do mnie mowil,  ale nie wiem kto i nie
wiem co.
  -- Rafal Solecki

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDxo+AAoJEEMpAov1cw9lmYEP/jxjsyiEzUOJw3BOqHzKpdx9
0Q5Z2Xs/i4KovEoG9iIv0X5wFfbc6cBsIn5ikh+59OGcR1evGBHy12iT8KDX43zz
8wc27CedgUHy2RpCJRGTBmnfWJEZ+ijU7eeAKb8RljV9VgC5D3Mn+bYDc2uOpAhb
+tENFYQsSNbAFJke6a1rTrzZ0jgiODYI7FSSWJ90Sp2OML1Rd6O/wtnvEXxtA6Np
EGPOTWA6J0lWiIjT4Ck1uGS9Hm7RAUwm7MCFQXI5SM86QjRvDDpX8DbVV33bUrdG
aNIaobIDu+T+6LKkP9RLpovyN9wO+PuqK4N8Xdw5xOpv8YvMtQM/F4eGAo+Q4Wep
EpWiygcC8kJE5xB0uQdpM+7ovrJYKGPjXGAKKanZoLk3x8HwUr4+JqgULJBTKnEr
54Qz+fr1yCHk2pXFY2JAfD0yX6rpkPSo9YjOOetY1uXTufPb9fuCLtoOVDMMGRbO
sBoJxt+M6by8TGorvhPRGl5COyfipDQUSNlVyvKb9T7pTxg2RiOyAe6HKcT76nfk
k/4z+Uo8JksXYf3cbDzVZU2CfKU0ViB5g+/rRPwD8rpMoMTDfzghVl5zfGd/lQYY
9QqEwXDFfFSSsB9y3UxauGq0Mx0kOx4tYnKJQAgDw+roEhz6OMNcwn55OxMKlj6P
yvQu64XtSONObfc2YuV9
=Edb1
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
