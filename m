From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Thu, 12 Jul 2012 13:42:00 +0200
Message-ID: <20120712114159.GF1478@wloczykij>
References: <1341916735.1973.10.camel@slavad-ubuntu-11>
 <20120710.200937.163315083.konishi.ryusuke@lab.ntt.co.jp>
 <20120710140711.GY1478@wloczykij>
 <20120711.014049.157490457.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oPYnW2SrAqZUvu4n"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120711.014049.157490457.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--oPYnW2SrAqZUvu4n
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 11, 2012 at 01:40:49AM +0900, Ryusuke Konishi wrote:
> I don't know, that is not a matter of NILFS.
> NILFS does not replace the root device with /dev/root.
>=20
> NILFS library just tries to find a mount instance by comparing
> canonical path names of the given device node and that in
> /proc/mounts.  Symbolic links are followed in this canonicalization.

That's why I asked. I suppose it is checking if the given partition is
mounted, right?=20


> The difference was simply that /dev/disk/by-uuid/uuid was a proper
> symlink to the real device and /dev/root was not in your one machine
> for some reason.

I checked udev in the first place. udev-182-r3 (from Gentoo portage
tree) with udev-init-scripts-10 creates /dev/root. udev-186 with
udev-init-scripts-12 doesn't. There are some bugs about missing
/dev/root on Gentoo's Bugzilla (grub2 related).


> > Also, maybe there's a reason to remove /dev/root? I will try later with
> > some older udev to see if it is created.
>=20
> In my nilfs-rooted machine, the root device node appears as /dev/sda?
> in /proc/mounts, not /dev/root.  I don't know what makes this
> difference.

All (at least those checked) my Gentoo Linux boxes have /dev/root in
/proc/mounts, but I don't know if this is Gentoo specific. I think some
mentioned above bug pointed to similar "missing /dev/root" bug in
Debian.


Piotr Szymaniak.
--=20
Maj=C4=85 tam ro=C5=BCki, barwione wody sodowe, batoniki, posypki, orzeszki=
, piwo
s=C5=82odowe, koktajle i taki krety=C5=84ski, pa=C5=84ciowaty, kurewski dzw=
onek, kt=C3=B3ry
robi ding-dong albo bing-bang, kiedy kto=C5=9B wchodzi.
  -- Peter Hedges, "What's Eating Gilbert Grape"

--oPYnW2SrAqZUvu4n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJP/rgHAAoJEEMpAov1cw9lIngP/2BGn4Lrnr9s7qtVqw5jdNEU
6xrxRdCafcz/jtFlg0QdhwL5rurbvdmWuK/OeVAI2r7JjISTZz5LIqixwSYXjKnS
JfdPwkfv2EbVdbcqV/WJI4EpRNJDL+O2C3+WDtzeiFoXaidIHieY6Ig95XSfiASJ
BywXs2pFAWyMX0hLF5I9qSKQYG6Jwwqj1wzZgcjc6ZlDaEqX0ZfUjzHhfek/n+Nh
KLs7Ta5vIT24Xx+A/MqQVPcm27JrY4PMwmJKU0hVWkvr0xBdoFEcl1jIVXySW7zs
MuNm/OLEvlINn44st+ZDz3/U3gD6yfUmE2/nEKVPQAaVxVglW9k1PB4PYClizfML
qJdeokxpPWEJ/80bEwJDluvm7gGeEYDQCXkzfQvjGbxiJKzeDnVMyMxt9L4MGKey
FOI6J27Xxg0cj2fhbhUE+O/ftq9ZaNbJWaJtD0PL6Mk2fhXkL1H+sxAIibsBt7BP
JO8S55gqh1Tbh9VwTD+SFcnneiO9e1oWXasnKjLcxdwvaGsvExIxCtcWjGffJr8K
K9EVctyqOoiMtOJQTQnnixhYy9wJ0EKefIwMUgm9A0jJC4z9Ou6nyd0Uvq3XFlVP
l8Fc574zYvjn4kQQH8JzWBE2l5SyyUsYpY6ao5NV9lFkfnR4ERI99APzBaWaRXxO
xhjf7sX9zTi6VzMVCcI1
=PwSB
-----END PGP SIGNATURE-----

--oPYnW2SrAqZUvu4n--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
