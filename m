From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Sat, 12 Jan 2013 22:24:21 +0100
Message-ID: <20130112212421.GD22054@wloczykij>
References: <20121130073219.GB4028@wloczykij>
 <1356415552.2052.11.camel@slavad-ubuntu>
 <20130103214913.GE2080@wloczykij>
 <28ABE57F-66DD-491E-9FDB-A6CE3CF773FB@dubeyko.com>
 <20130104191633.GF2080@wloczykij>
 <C2F4A5DE-538B-4468-9A6A-BA619EDDA462@dubeyko.com>
 <20130105164752.GG2080@wloczykij>
 <504C0292-D0C6-426C-BDFD-1CD50FB32617@dubeyko.com>
 <20130109210943.GA22054@wloczykij>
 <1357801925.2050.41.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="76DTJ5CE0DCVQemd"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1357801925.2050.41.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?B?0KHQtdGA0LPQtdC5INCQ0LvQtdC60YHQsNC90LTRgNC+0LI=?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--76DTJ5CE0DCVQemd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 11:12:05AM +0400, Vyacheslav Dubeyko wrote:
> On Wed, 2013-01-09 at 22:09 +0100, Piotr Szymaniak wrote:
> > On Tue, Jan 08, 2013 at 03:52:30PM +0300, Vyacheslav Dubeyko wrote:
> > >=20
> [snip]
>=20
> Thank you for additional details.
>=20
> As I remember, you reported about issue with flush kernel thread firstly
> and, then, about this issue. So, I think that you can have some similar
> environment peculiarities as Elmer Zhang.
>=20
> Could you share details of your virtual memory configuration
> (especially, vm.min_free_kbytes)?

vm.min_free_kbytes =3D 3806


> Could you share more detailed output of your system log? Especially, I
> interested what was in the first case of the issue occurrence. But it
> can be interested also part of system log that begins from system start
> and ends with messages about remounting in RO state.

I can connect the broken file with other event. User repoted that his
KDE session wont load or loads very (and it's like few minutes+) long
time. Now I think the reason for this could be the broken file in
/var/tmp/kde-foo. User moved his "broken" ~/.kde and everything was back
to normal state (well, except that he was missing his session and DE
setting).

I'm just writing it as this was some time ago (looking at the broken
file it was ~2 months ago) and the logs are somewhere in /dev/null now
and I think that those issues are connected somehow.


Piotr Szymaniak.
--=20
Stajesz sie odpowiedzialny na zawsze za to, co oswoiles.
  -- Antoine De Saint-Exupery, "Le Petit Prince"

--76DTJ5CE0DCVQemd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQ8dSFAAoJEEMpAov1cw9ll9sP/iPW+i3D9ly970KDI3lHLPo/
413/y0CFIzouSNl7tyIZQ6jphn2/5z71p6eXaWZq/DptSUV9puCPCQKMQ+Me3v9N
/GVLoQXgoJpcrz6orVs4wHwtsSkYIxirsqVGLqyM5ed3VEiZpxWhsspHIMscTjiH
zafVZmS0iHqZN5rwl00DP3+h9VY+dB2F/6yVVsCblKU+KICZUjLv0YmLLAmF0Kbt
GsMoPLSA/IogxSMuqdSP4eJJkFmEa92uOZHfCb2uA/4m4lRAeoIvlAP/8oS7S5g5
WervSkMH32wVNftQhOWX/FL267gbWQ0sxHTSC3ys0zjRZsL0UeBm6RBJ+VanVf8k
F5bKgzjn4Tw4RcAW/yCHhIKPLRoW7d1KJ7Th10fHN2OjSV+LoSEHtz+s8vvJ/8DM
RWWR3czr4HOQoLygJZ2FOyUVrxpgKjsPCrb1ylh4NGo2tCJFAEFyQx3ulA6u+On6
XPyGv0NMIYq2ADGaM39OHebLW6P5zF2rXUi8jX1gpOT0sYXDO/pf8Nja5uX8YJq8
amXc8oIa1ekK/4HDjjtPCf1vQJTc7gnGxi5N0nuoZWvqHEeZef5wK58jGfgYHIUj
xDg4Auk6IyJxJuFFHXt63XyuG8aA7Vs0by347TScJOHpxkPXFz0PVmUu/mz4tFNg
WM2Vsn6/IqYlPwGKwjI3
=2iEF
-----END PGP SIGNATURE-----

--76DTJ5CE0DCVQemd--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
