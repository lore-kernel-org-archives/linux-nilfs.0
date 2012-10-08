From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: NILFS: corrupt root inode after Turbo Mode?
Date: Tue, 9 Oct 2012 00:25:57 +0200
Message-ID: <20121008222557.GU28032@wloczykij>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nb8zVy0QMK3AA1xu"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--nb8zVy0QMK3AA1xu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi list.

I'm using nilfs2 on my Raspberry Pi rootfs. I've played around with
Raspberry Pi Turbo Mode and today it refused to boot. It's a headless
setup so I moved the SD Card to my other machine and tried to mount
rootfs partition:

maszyn ~ # mount.nilfs2 /dev/sdf3 /tmp/rpi
mount.nilfs2: Error while mounting /dev/sdf3 on /tmp/rpi: Invalid
argument

dmesg shows:
(...)
[43893.754525] segctord starting. Construction interval =3D 300 seconds,
CP frequency < 30 seconds
[43893.760245] NILFS: corrupt root inode.

Where should I go from here? I can hook it up via HDMI to some screen to
see if there's some error msg on rPi.

I'm using official Raspberry Pi linux 3.2.27 from github [1] (last
updated 2-4 days ago).

[1] https://github.com/raspberrypi/linux


Piotr Szymaniak.
--=20
 ALARM.
 Przyspieszasz kroku, zbiegasz po stoku. Nie mozesz sie ruszyc ni w przod,
ni w tyl, spojrz prosto w lufe i modl sie, bys zyl, zyl, zyl.
   -- Ken Kesey, "One Flew Over The Cuckoo's Nest"

--nb8zVy0QMK3AA1xu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQc1L0AAoJEEMpAov1cw9l3UkP+wYLen21Hkd0p9nCeJRSPM3v
X7aOOWDvUyEzaQpJ0Ne3Ah0GKte2mN63qg/uz/8hUHXqUfmqCQzZM7q0wxBmX75+
wTRmmS2V8pwI8+p03SOu8piJh3xRNtc0gOnZyP4F2N+8F2EC0PmMOcx0vORsrlOe
ImyVcJImCYp8okz62Skz6m0xv1tUZ6zwTzlrk2cWo4O+jjlayUjEYcDK5AAuAw/w
/fuvsChvhvq10Q7iVAqwMUe2mirZJpzQacK/MrB5lj+zanEImNgzvroZraY+hdet
LVt0KdYS3nzU/sDXPv0UAOdAPtZSK1YWPeymTY+46gBPQ6Dg3LJNf0ZiGnwEz7zQ
2tO19aa2DCh2u61PkbVilcvOOze4YndO9OB3N0Y6aS1oxPfyogt5SNkvXemlZrZS
AwhUCSFEGIiWnMBO/qD5Q9KO1j3rprzZOrccHTDgMgsNsVOIwIW3yoBFE4gvIaM0
VEeHgf2FEqBROeM6J6EBGtGT2GAhfRo4iF3ha3FctQ9aUH0RB2x6kJaBPyTzzjWg
enx8mrHlG9iNZT494BLuHqi6rKX28iJu0Vz6XdVpRJ3IlIMYnMH3/OPRb3chVhhl
muBJPhNBz97prhZmjYLD0F1OYb3BeCFUbfj09W9hCDlY4vvvudPhKyhzOdpmZe+D
xOK0UpSqQ7tehUjK+iIt
=tGRV
-----END PGP SIGNATURE-----

--nb8zVy0QMK3AA1xu--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
