From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Wed, 28 Nov 2012 21:59:44 +0100
Message-ID: <20121128205943.GZ4028@wloczykij>
References: <50A5737C.2040805@li.ru>
 <201211160313.AA04185@capsicum.lab.ntt.co.jp>
 <50A65588.3000205@li.ru>
 <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg@mail.gmail.com>
 <20121127151924.GW4028@wloczykij>
 <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB@dubeyko.com>
 <20121128142116.GY4028@wloczykij>
 <1354113560.2017.11.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pvq4FPIYehQuVelz"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1354113560.2017.11.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--pvq4FPIYehQuVelz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2012 at 06:39:20PM +0400, Vyacheslav Dubeyko wrote:
> On Wed, 2012-11-28 at 15:21 +0100, Piotr Szymaniak wrote:
> > On Tue, Nov 27, 2012 at 08:43:01PM +0300, Vyacheslav Dubeyko wrote:
> > > Could you describe the path of issue reproducing? What filesystem
> > > operations took place near before the issue?
> >=20
> > Reproduce: Use a computer with nilfs2? No idea... I notice this issue
> > from time to time. I suppose it's more visible when the system is idle
> > and then I notice a lot of CPU load without any reason (also as I wrote
> > before - it stops immediately after runnig sync).
> >=20
>=20
> Ok. Could you share output of "top" and "ps ax" for the case of issue
> reproducing? These outputs can be helpful for beginning of analysis.

Already attached [1] "ps ax" output before. Don't know if top can get
something usefull here, but I can try to "catch" it.

[1] http://www.spinics.net/lists/linux-nilfs/msg01481.html

Piotr Szymaniak.
--=20
 Moim jedynym bogiem jest w=C3=B3dka.  Moi =C5=9Bwi=C4=99ci to marki, frank=
i i dolary.
Jedyna =C5=9Bwi=C4=85tynia,  kt=C3=B3r=C4=85 odwiedzam,  to pochwa kobiety.=
 A m=C3=B3j sakrament
to pieprzenie.
  -- Nelson DeMille, "The Lion's Game"

--pvq4FPIYehQuVelz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQtns/AAoJEEMpAov1cw9l2y4QAJ2rbGjX1Q+m7ZcJQdVu6VAi
8b9wY1mNchi/VFXpsbFzAuu+cQJ2RuVZtpUHN8jaJkzbpjU6ZOE1ChR1xDjWTZnn
LcUrxXUg/YLTuF+3URTQgBPlMseP4PV2/KjiGTJwLQve52uOA6j5qECAnWwEtk1i
XiXO0Obxr2hSdNlONkqzr46TZ/I5rMFvROMieUeL7TZTqoW6CtQ30hdod80ceaHS
U2D4dQEVVuwZQxW1enDtCy2OWclgX0DMK09v/ZF4+NNvdBNSUokhXTHjvukwIpJ0
z+0MSVU8wDOq/ZSkm1PWP+Gzwm5OkAqhVQhvh6NHbRngka3Ei1zfuzcHz9Z9GvpV
Hnvrl6NTlC5S5IxB7VN7aIKhTpG8RZ4LmZZPvtA1Py6sVQWVM9jt7LpbRsXCcAhV
kq/9N9QfA82ZzuTGQNDrU5UlcsZSukZQyB5E8HWEBgjKDMAOwc5Q7Kyd7i4Olb5Y
uvGWw1R4/g3k/TOqT6iahSA8Jci6w6g0eXBUlbNAeM3QXykOKfQpiPXEFNIM5vZ+
mnkutZ39aVEDqB30hiS4tk4apokSN2sfnqloP3tkHcu1XKRAtKiA5IvIC4Dlgq3b
0lbQeZMQJBpq0uSkQYxyrlz8jG6gt7XQMSc/t9NZ1yZ2xGvpdIm6aOlOdFOk42QL
bTuE2dywCFPDeOor21qt
=ynCQ
-----END PGP SIGNATURE-----

--pvq4FPIYehQuVelz--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
