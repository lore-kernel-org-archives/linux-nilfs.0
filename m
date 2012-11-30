From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Fri, 30 Nov 2012 08:32:20 +0100
Message-ID: <20121130073219.GB4028@wloczykij>
References: <20121129210650.GA4028@wloczykij>
 <1354255744.2090.3.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CGcXfQ1PUDCmwDYp"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1354255744.2090.3.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--CGcXfQ1PUDCmwDYp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 30, 2012 at 10:09:04AM +0400, Vyacheslav Dubeyko wrote:
> Hi,
>=20
> On Thu, 2012-11-29 at 22:06 +0100, Piotr Szymaniak wrote:
> > Hello.
> >=20
> > Doing some work today (system update, kernel update, rsync rootfs with
> > external drive) I noticed some unwanted behaviour:
> > maszn ~ # touch afile
> > touch: cannot touch =E2=80=98afile=E2=80=99: System plik=C3=B3w wy=C5=
=82=C4=85cznie do odczytu
> >                         it's Read only filesystem
> >=20
> > dmesg shows a lot (1812 in the log) of:
> > [ 8288.319012] NILFS: bad btree node (blocknr=3D26229286): level =3D 17=
8,
> > flags =3D 0x0, nchildren =3D 0
> > [ 8288.319017] NILFS error (device sda2): nilfs_bmap_lookup_contig:
> > broken bmap (inode number=3D102230)
> >=20
> > After mount -o remount,rw /
> > [ 8384.734024] segctord starting. Construction interval =3D 300 seconds,
> > CP frequency < 30 seconds
> > [ 8384.734028] NILFS warning: mounting fs with errors
> >=20
> > Never happend before and it looks like it works fine now (using vanilla
> > kernel 3.6.4).
> >=20
> > After a reboot (to vanilla kernel 3.6.8) dmesg shows:
> > [    6.046883] segctord starting. Construction interval =3D 300 seconds,
> > CP frequency < 30 seconds
> > [    6.046884] NILFS warning: mounting fs with errors
> >=20
> > I don't like the "errors" part...
> >=20
>=20
> Can you reproduce this issue (I mean that the issue reproducible or
> not)? Have you any side effects of the issue such as data loss or any
> other bad things?

It was the first time, but I sure will update my system and kernel in
few days, so if this was related to disk-intense work maybe it could be
reproduced.

Didn't noticed any data loss (at least my system works and kernel boots
the way it should). But I will check last updated packages to see if
there's something wrong.


Piotr Szymaniak.
--=20
Nagle zdalam sobie sprawe, ze wszyscy mezczyzni,  ktorzy wciskaja sie w
cialo  kobiety sila,  podstepem czy szantazem,  ktorzy rzna kobiete nie
kochajac  jej,  sa  gwalcicielami.   Przestepcami  godnymi  najwyzszych
wyrokow.
  -- Graham Masterton, "Famine"

--CGcXfQ1PUDCmwDYp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQuGEDAAoJEEMpAov1cw9l63QP/RgO7lvFHJE/IIeZ5dM0FzyV
suCC6r7U2h0hNR4iLXgFVqwzm2CkTfTBi+LRM+xpJ+kGW1BoawVT82sA/JahO39/
09pLn26dll/exC6qEvqkDe+sAJUIgBULqwH/eslzKZE/fbZUxxYDLevWQ81tHXRd
pD/Qilz/yXxSDTztVtBpPq0zcZdahrmrwgEm+xSDqiUJuE46HfJVIziF8w378x+9
8GbNwgIG7q2VDvZcTXl9gdqV1tYzknIjXsgcp0a60YWTwoDuhvxXq2ybSDF/6lO3
u33jk8wPXHLV8l4Fj+GPf7ZeJZelkOsuqp1L6MH90rM/Bqmz+xpMaXAHBYfDRYSH
A9C/u4M76F2B5jTJoRoDyNnVWLtD621PyiuZf3UGaf3fAV3qc9fb3eQmz4T9aLJT
S1xpe0QvNAucImIPACXQHKfpQHiOlRzY701tDK4a4mmExVY1HEljHmfjqFKFYKS4
c/AkR01ZKXg71xptJHJoF6Zljb2pew/vaLjjmlzaNLENggqa7xT4/gImOaZK+g64
mlnOr+QVj0MuUGO86BTjDLM8shW/vPRmr7K/cuFuE0417Hk9Mwj/2kUZhALIw4Iu
CG7JUK+FkBZKWzWxTb3p3LiyUvptcdtJ12MYaxx91K2RijLiWM/4DN52mUBXgd6K
qwLKzai7c9pwJ/tSBRJj
=SQRs
-----END PGP SIGNATURE-----

--CGcXfQ1PUDCmwDYp--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
