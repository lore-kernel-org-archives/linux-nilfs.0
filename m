From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs_cleanerd cannot open nilfs on device that exists
Date: Wed, 12 Dec 2012 23:28:06 +0100
Message-ID: <20121212222806.GA19964@wloczykij>
References: <20121212145116.GE3064@wloczykij>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121212145116.GE3064@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 12, 2012 at 03:51:16PM +0100, Piotr Szymaniak wrote:
> Hello,

Sorry, it looks like I need more memory [1]. The issue is _again_
related to missing /dev/root that should point to my /dev/sda3 [2].
I was sure it was fixed meanwhile (had ~200 days uptime, so I just
forgot about the issue=E2=80=A6), but it looks like it isn't (at least in G=
entoo
Linux [3]).

Sorry for wasting your time. New udev, blargh. /-:

[1] http://article.gmane.org/gmane.comp.file-systems.nilfs.user/2437
[2] http://article.gmane.org/gmane.comp.file-systems.nilfs.user/2438
[3] https://bugs.gentoo.org/438380


Piotr Szymaniak.
--=20
 - You know nothing about woman!
 - Of course not, I'm a man, so how could I know?
  -- Berserk

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQyQT2AAoJEEMpAov1cw9liKIQAL3zfTFqMzNeKw5Xgf6QiXgM
NvmjF1JX5q7E/LS5YRQ12TY86pMvDEF2WAeMVZIBXB3xnapl3KnX4o02ujJDhSSA
pYQ8+Hb/4WwHorBZiMNUIZiINW1iORsaE8/H/UNrs6Nc2dH2l1IXRXzFbNy9K4UR
X0wP+TZh247tYqmkAQ84LIXE6S8psZBHf9CWt+9z47znpuSK03FC4lP9qwcLf0nf
V4k/cKy3HtZs6Q/KCt2YL9KddUFB4RhtK8mtL/UYk/6Giih17rgx7zyfCukTycyG
zmc5QW9uNMGtyLfC5iGvv0gLyBbYk0bZ0rTJLrqlslBVXaSubxap91Wh6GXDnS/F
JYn+lKz7MsD0XKkmOs99JVc3t9eD0oxMwBG5nYJF6OeXYI1kjSGUmWVZCxqaMfyO
jXMieFYY9CxSSBcTCUMwbkoYrcGwAeM66dzendHapBZ47xfMYyGS52Xp5Mzira0C
hVsjw7H07BqUmkjP6+wOSLJ/KaXMA8JBxcG5m1FGkeNRH+pLA51ylInWNZ57fwsr
hYK1elv1m4+y9G7wAVfjguuF0XRPklEYU9nqy5z75UraDMY7SkZVn+Z44ciG3khy
bJcOORMsYA9mmRO/n3IxuJbU4BaIgwmB+Ufhw7AtKiqX459Ht8y84qJEW8jlDWh3
DfIJB1yeUHiHcAvRdjRr
=lzhr
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
