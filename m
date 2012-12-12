From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: nilfs_cleanerd cannot open nilfs on device that exists
Date: Wed, 12 Dec 2012 15:51:16 +0100
Message-ID: <20121212145116.GE3064@wloczykij>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I got a power failure today and after power restore there's a weird
issue with nilfs_cleanerd:

wloczykij ~ # ll /dev/sda3
brw-rw---- 1 root disk 8, 3 Dec 12 08:35 /dev/sda3

wloczykij ~ # mount | grep nilfs
/dev/root on / type nilfs2 (rw,relatime)
/dev/mapper/backup on /mnt/home_backup type nilfs2 (rw,gcpid=3D2995)
/dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D5333)

But when I try to run the cleaner:
Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: start
Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: cannot open nilfs on
/dev/sda3: No such file or directory
Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: cannot create cleanerd
on /dev/sda3: No such file or directory
Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: shutdown

Never happend before. Shutdown should be nice (got UPS monitored by
apcupsd, so I hope it worked - was in the middle of the night, so can't
really tell if was superclean shutdown).


Piotr Szymaniak.
--=20
Smiejmy sie! Kto wie czy swiat potrwa jeszcze trzy tygodnie?
  -- Beaumarchais Pierre Augustin

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQyJnkAAoJEEMpAov1cw9lJX4QAJWQHXYT69VpnvMJcfEJ1aXf
8SupT70xQv25hSujNHw9+y6TCvNe9UZzEayuwMZc2BfFQ4EZtybdLtF0P5gcwlu/
J4bvoI15cTWtjTgm1tZPc7HWMDNA0ed9sAZOGwfqgrkTM9MzaW96iCODguUrBNgZ
e+4oTbPvbzjjndevJtrXu5VyR88Op74T3tXAT8xZj0F4A3UZGuRgxl7k/ecey2Xa
n0SyXQHuQth3ol4ExRM4Grl7KmVW7NlBHtCUWTCtAGdGxp80G7+jJj+nVb2M6May
0uJrlBAJB6HVrV+Omln6OBaSCwvsXu4MyBPHsBf1PSnVqgsrjdNKcWPp2GwtBWk3
PJ+xuzi6cqGtHTNY8MhU3XKJKJnFdr/E2nvw4uvgYvbOPWMLYhZ272A9zMANLXaj
PK/7LIiYHepbWtkgQ0j/jaHPxS81ujV0CMf3Wrz2uSCZnFrSRolbd87+Vby1yl4S
jv6JMEFC+Mmqkteq1zSq8hdQNIC6osxucX+8nZVawfyF6Q6Blk760LR0sZZlQWWR
Fe+hJ6OSsnUfSpYDWnW6VcbK+H0DOwQyQOJhMKyax+zDjiyLCvFonYnQW2cuPDnV
mNkfy7l/wQ0m4CuuiV4vcpjwfLmgaY9uYNsQqojUDBa82yRI4iSpcRWKWFlIH/Ic
KeWXWpgdG9ORXRm7iCrx
=Pzx4
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
