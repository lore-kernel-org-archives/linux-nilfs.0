From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: A lot of NILFS: bad btree node messages (readonly fs)
Date: Thu, 29 Nov 2012 22:06:51 +0100
Message-ID: <20121129210650.GA4028@wloczykij>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="E50aLcSU4JxQSj/B"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--E50aLcSU4JxQSj/B
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

Doing some work today (system update, kernel update, rsync rootfs with
external drive) I noticed some unwanted behaviour:
maszn ~ # touch afile
touch: cannot touch =E2=80=98afile=E2=80=99: System plik=C3=B3w wy=C5=82=C4=
=85cznie do odczytu
                        it's Read only filesystem

dmesg shows a lot (1812 in the log) of:
[ 8288.319012] NILFS: bad btree node (blocknr=3D26229286): level =3D 178,
flags =3D 0x0, nchildren =3D 0
[ 8288.319017] NILFS error (device sda2): nilfs_bmap_lookup_contig:
broken bmap (inode number=3D102230)

After mount -o remount,rw /
[ 8384.734024] segctord starting. Construction interval =3D 300 seconds,
CP frequency < 30 seconds
[ 8384.734028] NILFS warning: mounting fs with errors

Never happend before and it looks like it works fine now (using vanilla
kernel 3.6.4).

After a reboot (to vanilla kernel 3.6.8) dmesg shows:
[    6.046883] segctord starting. Construction interval =3D 300 seconds,
CP frequency < 30 seconds
[    6.046884] NILFS warning: mounting fs with errors

I don't like the "errors" part...


Piotr Szymaniak.
--=20
 - Nie doceniasz sie - zaoponowal. - Jestes samoukiem,  madrym facetem.
W dodatku, moim zdaniem, dosc niezwyklym.
 - Hej, nawet nie mam matury.
 - Wiem - odparl. - Jednak to nie kawalek papieru stanowi o czlowieku.
  -- Stephen King, "Rita Hayworth and Shawshank Redemption"

--E50aLcSU4JxQSj/B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQt85qAAoJEEMpAov1cw9lAlEQAMJFHcZ7viTZh2EAlxNJLsLj
tD7O7bm4tUCAcyngR76dlJSa+AN8VtJzM//TdN05KR4XNba4M2+baNayDgXm/CUV
GLhEoG9IKXhOf3PbCDgWD1TCFoS3lc778bnFhpCIDSBbUUqND+Oz0EKOfrNHwwGy
RUlWDK7QpjDsew09nH0/+a0Z7+csL/YTcotIdYxo9uWBRnzMj1w8tiuFsQP8bxkI
L/iPvBxjS28rLRXtgwacj2jY49eQGVvrTxLUiy0p0C+ZexRxh39Kdtyrdkjld2D7
T5prEXKsid9JcvIM5L1n86tx/32XKO7Ov+r0KBfCaPQZ67oJzy6LhgPu1hqCk7pY
bjIBz17y3Rl2iWiKOqO4WWJw7b+iMsLr9e91YIf00AQq53OUuVIUkixbH+kb74Nm
gkCAtnqpWOscLotESbrdFWLDVKQRos5XavDma+mshfsSwjCXrb7KcSIVqPpzeRAs
RTBNBFpLpYCvm2gr7cj8Nm2BB+R3ZQJ28xCG1iuwkaSCKQXNWQdKkISIzs/r7l6M
GnzcOZboZzIF3iDyvTVK20ZcQTMK7qM1DCYBgWpI10aEzObaKyy6QumCavOR8xCj
Y43ExgN6MRQIWh5hrS5uQKl7knsVz/s/1tUTBKMM2x5YM1kTyjqLbfFS0hhgh/KD
U9/jiRnUSMZYFfiTCqPT
=a39v
-----END PGP SIGNATURE-----

--E50aLcSU4JxQSj/B--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
