From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs_cleanerd won't start for root filesystem
Date: Wed, 1 Aug 2012 11:00:28 +0200
Message-ID: <20120801090028.GT1478@wloczykij>
References: <3290425.VTORBmyZ72@coil>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bNLLTo5eXWXFd6av"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3290425.VTORBmyZ72@coil>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


--bNLLTo5eXWXFd6av
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 01, 2012 at 09:21:11AM +0200, dexen deVries wrote:
> Hi list,
>=20
> I've upgraded kernel to v3.5 and udev to v182. Now nilfs_cleanerd won't s=
tart=20
> for root filesystem, even when executed by hand. Attach'd strace output a=
nd=20
> /proc/mounts. It seems the problem is there's no /dev/root symlink anymor=
e.

Got similar issue [1] few days ago.

[1] http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01186.html


Piotr Szymaniak.
--=20
Zaczalem pic przez pewna kobiete. A ja jej nawet nie podziekowalem.
  -- William Claude Dunkinfield

--bNLLTo5eXWXFd6av
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQGPAsAAoJEEMpAov1cw9lXBgQAMKkzH7Agt952utvnpXkX169
XJmfkSeStO7takib7gQbYHAPxhvRLEss035V8ZhEtzDQmtb67gc9z12NuFKvjjNA
kavRlAUrI7XFj+5OOrB+9My8ffi2gitxpcdEo9b+8PWFCZtMSmCpKV1rDK0JDHVW
5alzXsVrITR7zQRVrfjamJdVDnTEslF4IOR8+A9+G9SV8BYITLNLTWmuCogGGWzh
cy5LEdTUcw13FcvHW9Z1+hn1RvS9IOrrnwLWLtMTbIjfmP4C5HBnkyc09e4RS5Th
jhoMipNk2pUj7jAy7TgGt07184jcc+yihMUSifXxDE79s1BPiNQUaKqvMyD7dE2r
G7KAph93TgZ1RV0m6n8thKnGyP4k97hetBy53ZyXL7I3QU43InSfWmh5d0sNPST8
1tA3pXMwB3YUCbrJJOQMIyYc2Plb1l26sjAf+zJZ1QXorIxuECSdhh6O5PKAX5Kp
pZgt88OFpBWjspDjxvBaLaDAOakSIpZ/31CG99/FFoDfwk7V+uXcvxaIXROArnri
XGAdqyqzBS/PnNn/cYnVeGh1HC4QfkEriLLfw+mSjpn05ZTN1mUAqXo7vMzph+Ug
B98A05m36mih4AfzE18+U+4qcrPUYANSJ5CwBkKY722b4NCM78JlbPeJuou5iE63
V+meMcAbAeJKGSjdlgZi
=6l+G
-----END PGP SIGNATURE-----

--bNLLTo5eXWXFd6av--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
