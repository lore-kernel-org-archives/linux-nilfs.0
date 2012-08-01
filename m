From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs_cleanerd won't start for root filesystem
Date: Wed, 1 Aug 2012 13:19:21 +0200
Message-ID: <20120801111921.GU1478@wloczykij>
References: <3290425.VTORBmyZ72@coil>
 <20120801090028.GT1478@wloczykij>
 <1544142.eijMQvyoNB@coil>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ukZ3tWq1IjZw6zEx"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1544142.eijMQvyoNB@coil>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


--ukZ3tWq1IjZw6zEx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 01, 2012 at 11:32:58AM +0200, dexen deVries wrote:
> Hi Piotr,
>=20
>=20
> On Wednesday 01 of August 2012 11:00:28 you wrote:
> > Got similar issue [1] few days ago.
> >=20
> > [1] http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01186.ht=
ml
>=20
> quick recap, have you gotten any solution better than creating /dev/root=
=20
> symlink by hand? ;-)

udev downgrade... Looks like there are also other things broken by
missing /dev/root [1] [2] [3] (a least in Gentoo Linux).

[1] https://bugs.gentoo.org/381761
[2] https://bugs.gentoo.org/427818
[3] https://bugs.gentoo.org/390519


Piotr Szymaniak.

--ukZ3tWq1IjZw6zEx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQGRC5AAoJEEMpAov1cw9lBlEP+wZobHNtETVSLCbQX0XqQg5G
l2LxCP0UGyjuz634TONgDk4gJqUcFv4qUfI0ELVAPuj5UQV7RugPsb9B8fC1y8ye
zp9DNFuOjGjb/2awFeFjpVbRe74A7oKEq2r65W0JifLp5H4VqRGCAtN4YBPWdh1b
1xRlqSY7opDexOXxnlUDhDJJrNghxrKdKQAI4+YqDJoKgK0LhE2ZSaq26oWNfCIw
jm5twWO0IRHORvcP46ePMHkRCqR8yhU6iTvS3qsvPgHnXLv0G8dhca550NYjyDp6
Zu5IqQLwjhQ9nqVE8bwpJ74RQ/y2FHjm76J1LnHkpTkVG27nLWMuUnkRb9VyEbzq
inDpjvxjr90FMsLRN9CbvAUa/NThsmLNEIycNn9b0S9XbIylv8ceSTH05JFToYoo
LHy+0aaSPrSWYy/01VsGfJg/YsT/aSQ1S2Z9lp4JSNjpUAYrniX6NVhB3URYc2Mm
jWyOv5jLqwRX5niPDfHnd14h0gs0SmIyVfDYHIxUULT9HEvDgvZR8jeDS1ZaZmgH
GQI5E/wAK2PAEUugZ/CtKv0nrsyvOE5qufjegm3fs44g8hkewNOorX7jcswWvaEK
V9SGG0XUO638km3mch5MG/hliKS78qcvojVDDoQ6epEfON5koO/mlNOGLZaFNlXR
AN2gpRku6cC0009sMy2x
=o3nT
-----END PGP SIGNATURE-----

--ukZ3tWq1IjZw6zEx--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
