From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Tue, 27 Nov 2012 16:19:25 +0100
Message-ID: <20121127151924.GW4028@wloczykij>
References: <50A5737C.2040805@li.ru>
 <201211160313.AA04185@capsicum.lab.ntt.co.jp>
 <50A65588.3000205@li.ru>
 <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="iwjEIfU64POCkTAH"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--iwjEIfU64POCkTAH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 17, 2012 at 10:27:36AM +0900, Ryusuke Konishi wrote:
> On Sat, Nov 17, 2012 at 12:02 AM,  <fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org> wrote:
> >> Hmm, the default value of this parameter is zero.
> >> Have you changed it with the nilfs-tune tool by some chance ?
> >
> > Yes, I've changed it to 60 sec for rootfs partition, and 180 sec for da=
ta
> > partition. It worked flawlessly with this setup on root partition for l=
ast
> > 14 months...
>=20
> OK, please confirm version of your all kernels including initrd.

As I got this issue here's some info:
(nilfs_cleanerd_rootfs.conf that I'm using for rootfs)
protection_period       3600
min_clean_segments      15%
max_clean_segments      25%
clean_check_interval    10
selection_policy        timestamp       # timestamp in ascend order
nsegments_per_clean     2
mc_nsegments_per_clean  4
cleaning_interval       5
mc_cleaning_interval    1
retry_interval          60
use_mmap
log_priority            info

maszn ~ (: uname -srm
Linux 3.6.4 i686

maszn ~ (: eix nilfs-utils -c
[I] sys-fs/nilfs-utils (2.1.4-bwmKdHsBrCaKN0S5hHIosQ@public.gmane.org): *snip*

What's the next step to debug this issue?

Piotr Szymaniak.
--=20
 Jedna z g=C5=82=C3=B3w  Zaphoda spojrza=C5=82a w bok.  Druga  zrobi=C5=82a=
  zaraz to samo,
gdy=C5=BC  chcia=C5=82a zobaczy=C4=87,  na co patrzy pierwsza,  nie by=C5=
=82o to jednak nic
konkretnego.
  -- Douglas Adams, "The Hitchhiker's Guide to the Galaxy"

--iwjEIfU64POCkTAH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQtNn8AAoJEEMpAov1cw9lPCIP/1GkJiGnOmUoYO8Rq8oVQu/t
IeaUCD6Z+uS31rerpBXq4siK7xAXF64A+8EtPQFUcwMjThzPIwcW3yTOyzrsn1Gq
zN0EorPerZ/hJhq9CaOjLiUOSVulA9yaH0Ir8TMlm7qwlAKZVucDsMLRnv34f5ZK
8tPYJmBmUId7zNnkrxhR8O1tNxuc7dOVANyZ9OHc/zaEtDnDZif+zKMevvIn8w0S
zMD9JhL1wtvk2G1uS++uq0xYB+XpliAvrgdbScjyO1q+7upNRKIldWyWynFfU4c0
kj0wAvrhG9nUrqf141AgRgimUud+v+A6Pt7RRWRoRUpLIn+q5gMcOrcKq0wCGIyX
N9Fd4ZE8QGzJSY7HMsp2wtnmkhSbwIUANdQ7+ZYmu/xweigN1Z2/9+WExTRFNTwF
7+Kg9CF2eG/qPo0nw5eYQOszGc0aZhvkw+OXtLC/6FYYY/0rPN5tS4wYmsEVXcyD
WKB4DXfGBte/GpUc0vnVv5t9fHkN8RB7byqv+Tgs3W82/ZQwntCwnEFbTTuKZPsu
2NVXyYZ8UUyNZCX1spoWJdtOx2Plv721pwdMOb0sMxDW/iqDanrb3SN2vO79jHYh
Pn8yPS+hpGt2Gv+Gs9GBCASIt3R7bjGJdCUSRKPXL5tt8++k4jcoyVZg43ukdqMT
4cts3lJY1vgL+oid/MRV
=0f6Y
-----END PGP SIGNATURE-----

--iwjEIfU64POCkTAH--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
