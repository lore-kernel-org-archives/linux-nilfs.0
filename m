From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs_cleanerd cannot open nilfs on device that exists
Date: Wed, 12 Dec 2012 22:20:18 +0100
Message-ID: <20121212212018.GH3064@wloczykij>
References: <20121212145116.GE3064@wloczykij>
 <20121212145454.GF3064@wloczykij>
 <20121212161054.GG3064@wloczykij>
 <7A92569A-D56B-45B0-9305-EBC2EDF90913@dubeyko.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oXNgvKVxGWJ0RPMJ"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7A92569A-D56B-45B0-9305-EBC2EDF90913-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--oXNgvKVxGWJ0RPMJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 12, 2012 at 11:43:40PM +0300, Vyacheslav Dubeyko wrote:
>=20
> On Dec 12, 2012, at 7:10 PM, Piotr Szymaniak wrote:
>=20
> > On Wed, Dec 12, 2012 at 03:54:55PM +0100, Piotr Szymaniak wrote:
> >> On Wed, Dec 12, 2012 at 03:51:16PM +0100, Piotr Szymaniak wrote:
> >>> Hello,
> >>>=20
> >>> I got a power failure today and after power restore there's a weird
> >>> issue with nilfs_cleanerd:
> >>>=20
> >>> wloczykij ~ # ll /dev/sda3
> >>> brw-rw---- 1 root disk 8, 3 Dec 12 08:35 /dev/sda3
> >>>=20
> >>> wloczykij ~ # mount | grep nilfs
> >>> /dev/root on / type nilfs2 (rw,relatime)
> >>> /dev/mapper/backup on /mnt/home_backup type nilfs2 (rw,gcpid=3D2995)
> >>> /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D5333)
> >>>=20
> >>> But when I try to run the cleaner:
>=20
> Sorry, I slightly confused. As I understand, mount output shows that you =
have mounted /dev/sda3 with started nilfs_cleanerd (gcpid=3D5333). Why do y=
ou try to start nilfs_cleanerd by hands? Or I misunderstand something?

It's not running. I got similar message on boot:
Dec 12 08:35:23 wloczykij nilfs_cleanerd[1689]: start
Dec 12 08:35:23 wloczykij nilfs_cleanerd[1689]: cannot open nilfs on
/dev/sda3: No such file or directory
Dec 12 08:35:23 wloczykij nilfs_cleanerd[1689]: cannot create cleanerd
on /dev/sda3: No such file or directory
Dec 12 08:35:23 wloczykij nilfs_cleanerd[1689]: shutdown



> As I can see from strace, there is such error message:
>=20
> futex(0xbff37f24, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NULL=
, b7547940) =3D -1 EAGAIN (Resource temporarily unavailable)
>=20
> I think that it is the reason of failing nilfs_cleanerd start.
>=20
> Maybe, do you have working or failed nilfs_cleanerd for /dev/sda3 in back=
ground? Do you have any NILFS2-related messages in system log?

ps ax shows only one nilfs_cleanerd process (at different drive).


Piotr Szymaniak.
--=20
 Podejrzane!  No,  yhm!  Takem  sobie  pomy=C5=9Bla=C5=82!  Jezus  jakby  s=
i=C4=99  o tym
zwiedzia=C5=82, toby wtrz=C4=85chn=C4=85=C5=82 puszk=C4=99 fasoli!
  -- Stephen King, "The Dark Half"

--oXNgvKVxGWJ0RPMJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQyPUSAAoJEEMpAov1cw9lWxsQAJ7/pV+iK4wXFkJbdtuJQB79
Q0L6QgJmbY15ch22HDyoFOH4KQpBptsICSpxXwbA2NMTCMoSGPkHLBHSrNKLVsD3
Lcdw8aVYDltYFMalcxo73H7T8Hw7GjIb0szCH5qviTidM9lW6GqoV67IVIx85iOm
RYXI3wwoqM0Y7GuYV0V0pdUSAFrrV6ZCkFat9qTCdaHYmo6U6bR9A7Jly94faGCj
1nZEk32Kt+gcH/vaxmCmh+37CDwRS+JiyIYGru58mWgH0NLVsMFhRO89LhwoCh2i
C2Xyw1tEoCA5cKrh5omQPLkwF3U35zq3SVvRi+3W7t98n9RAzhIbuVBJAVYxj2Am
rsVpJ24AE/lTmIXApXAZYZ87Yd+kAJNuCtGZzorYMfVnCihgRK4gs9m3akQ4tTQr
aC+aVUtEkqZxYvh8YRlxQI9J6ytqw8Tj66+eRpvO7g1TcFkWy831wXg3tvrIT2f3
roU1qNLdKv1FUgX1CLvpWnv+R+7J//JwryDCJkdkaOVyspzQFAUBKrHj3FVTSlvo
rELMwDgbvG2NAS/YXvQPNhX6nfwzhRz+uFALv4UH2XChYnHD3CbELIseHK9FAxaE
2oSc6dLZ91GGf3u3lm1fQP8waA0dxr/L8xuIvFo8xojNXr2I5TYVrKM2y6i4Plzr
47JXBUMIUL8PYHFBFHeg
=Oj83
-----END PGP SIGNATURE-----

--oXNgvKVxGWJ0RPMJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
