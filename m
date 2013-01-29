From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Time issues with checkpoints resolved?
Date: Tue, 29 Jan 2013 23:10:21 +0100
Message-ID: <20130129221021.GL10316@wloczykij>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="v2Uk6McLiE8OV1El"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--v2Uk6McLiE8OV1El
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Sorry, but I can't find an answer and noticed some checkpoints in the
past in the middle of other checkpoints (there was a thread, I think,
about similar issue with timezone change).

Right now I have (Raspberry Pi doesn't have RTC):
~ lscp
(...)
7870  2013-01-27 15:12:30   cp    -           22      42174
7871  2013-01-27 15:34:23   cp    -           19      42174
7872  2013-01-27 15:42:29   cp    -           22      42174
7873  1970-01-01 01:05:05   cp    -           93      42176
7874  1970-01-01 01:10:05   cp    -           22      42174
7875  1970-01-01 01:36:36   cp    -           18      42174
(...)
8031  1970-01-03 07:08:19   cp    -           57      42183
8032  1970-01-03 07:13:20   cp    -           36      42182
8033  2013-01-29 00:01:57   cp    -           30      42182
8034  2013-01-29 00:19:34   cp    -          599      42313

I just wonder if cleaner is now smart enough to clean this mess.


Piotr Szymaniak.
--=20
 Szpakowate w=C5=82osy przytrzymywa=C5=82a niebiesk=C4=85 aksamitn=C4=85 op=
ask=C4=85; oczy mia=C5=82a
prawie fio=C5=82kowe i szerok=C4=85,  inteligentn=C4=85  twarz  kogo=C5=9B,=
  kto nie b=C4=99dzie
cierpliwie  znosi=C5=82  g=C5=82upc=C3=B3w,  ale te=C5=BC potrafi =C5=9Bmia=
=C4=87 si=C4=99 z samego siebie
szybciej, ni=C5=BC ktokolwiek inny zdo=C5=82a.
  -- Graham Masterton, "Zakl=C4=99ci"

--v2Uk6McLiE8OV1El
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRCEjNAAoJEEMpAov1cw9lNFUQAMckskMPzXMmq5iIW9B8Es8Z
saphE8Upm/2+ASVCR5bfYHYSANiy21IERsGyK7ENYUOzjrfmLLNtVE6DUzlKGz2u
+dWhXCWBDpP2ec8QxVpBxtTRMVA7CsxD+EQZr9aify4buRG5Gc8w3J5W704NOGd8
XK4KtUoIP63CbdG3nIREr4yKaRWqF69voVC04C7Kc2CZyJ6hpBWQ0T57eSX7VIt2
+jKFsUBwBBtc95wozlgD75+oHeRvez+iLVEZI6Z9m6GjAMxNTz2mp83zFn9WrRrd
00OEmnNj25d4a6Rl5Na9tvHwAsOwRGR2to28fCzhmsiYP+6y1fQv6TF4NA9cQDfw
VFjd9Asi6SN2jfPYPbBuO8sQbR8J476L5Bx+Di1Iw6OS84KhWhllENyOF0TzSroK
QjYPHvdyovFR7064Dvl6d/6zTSU/RLr3MZ0GrPxBVHBr5/WmR4zrsHVXi4DfhIT4
QfLzIbHxhAUGRQRwPV3EmVKEHIBKFGVjPrSYBTNYImvP+Hje79ISYXIUa/49JgE1
69d0mRwxbFyFhgbmmJwPbQeph9Ivv8D7xcEv7wBeff9E37XF3Ia3weslVv3Boq1Y
xqMUWBR809OrENIb51nIN639HoFwcIMEb9+qJoS0zBPKq1H8WzWTmFWW+OOTRsCz
DVShwu1XBBDQBVxgEy/C
=xfE2
-----END PGP SIGNATURE-----

--v2Uk6McLiE8OV1El--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
