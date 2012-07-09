From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Mon, 9 Jul 2012 09:33:00 +0200
Message-ID: <20120709073300.GP1478@wloczykij>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="V7BlxAaPrdhzdIM1"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--V7BlxAaPrdhzdIM1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

I've upgraded nilfs-utils (running Gentoo) on 29 july. Today I ran out
of space on my / and found that nilfs_cleanerd isn't working. When I
start it from the command line it exits instantly. Also, all previous
checkpoints on / (also on two other mountpoints on different machine)
are gone.

What I did? Downgraded nilfs-utils to 2.1.1, remounted mountpoints. On
the second machine it's runnig fine (cleaned _all_ checkpoints), on the
first one with disk space issue it exits just like 2.1.3.

Here are some fs details. Machine with disk space issues, rootfs:
    CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
 147688  2012-07-09 08:38:14   cp    -        11075     242915
 147689  2012-07-09 08:38:14   cp    -           60     242895
(=E2=80=A6)
 148999  2012-07-09 09:13:46   cp    -           60     242888
 149000  2012-07-09 09:19:45   cp    -           44     242888

Filesystem      Size  Used Avail Use% Mounted on
rootfs           24G   13G   11G  56% /

mount shows:
/dev/sda2 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D15356)

There's no nilfs_cleanerd with pid 15356.


Second machine rootfs:
   CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
 92246  2012-07-09 08:16:58   cp    -          118      44669
(=E2=80=A6)
 92439  2012-07-09 09:19:14   cp    -           29      44668
 92440  2012-07-09 09:19:46   cp    -           33      44668

Filesystem         Size  Used Avail Use% Mounted on
rootfs             3.7G  888M  2.6G  26% /

(it should be around 3G used)

Second machine second mountpoint:
   CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
  1496  2012-07-09 03:31:23   cp    -         8837     132766
  1497  2012-07-09 03:31:26   cp    -          468     132766
  1498  2012-07-09 03:41:27   cp    -         1474     132765

(this fs should containt *all* 1498 checkpoints)

Filesystem         Size  Used Avail Use% Mounted on
/dev/dm-2          117G   58G   54G  76% /mnt/home_backup

(in this one it should be around 100G of used space)

mount:
/dev/dm-2 on /mnt/home_backup type nilfs2 (rw,gcpid=3D13135)
/dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D1363)

Both cleaners running (the second mountpoint - /mnt/home_backup - is under
heavy load and I suppose it will end with around 20G used space).

Where to go from this point? How to debug nilfs_cleanerd issue?


Piotr Szymaniak.
--=20
 Wybudowali=C5=9Bmy dla siebie klatk=C4=99 - cywilizacj=C4=99 - gdy=C5=BC b=
yli=C5=9Bmy zdolni do
my=C5=9Blenia,  a  teraz musimy my=C5=9Ble=C4=87,  poniewa=C5=BC  jeste=C5=
=9Bmy  zamkni=C4=99ci w tej
klatce.
  -- William Wharton, "Birdy"

--V7BlxAaPrdhzdIM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJP+oksAAoJEEMpAov1cw9lfpoP/Rh7R5E2WNJSqvxNH/VFFDxe
h4OoPj/6QJC2rWTG8N4eD/wngqIFSe/NrNvS3yPflsaAODf6nwX9WRBmbs6HEj/C
pqvWiv4s352lUD8RVHgEpREjq4gb33X5iJu7ZK5MFqnUPQxv38qgajWbeuJoXxwr
x5uY3qp5HHxPiANZC5ZccOliUMhUbBE6MUatA/ynZP4nD29BGyYQxxLAKn8lqNnW
sIsvdDPf0EQxL4F1M45nPZYIToZuDedypm4n/HCqlTJ1Pza0NOxktsSzYxJKC/ES
L9t0i1fAULYctMC8seqZjAlMVoB6CgRLazn94lDMTegQPKa74QSU7/HGyna2ooy5
Xn1vUXlhq7EJsFAZ3aPlpMHz1C3cmw6JwrClrwe3mmB1hY4DsHPS3xFQoDcmHnMg
XvMUyh0Y+kcD1ReNbwYua9jorpC8Vx4WfgPG3m+WkBw2dTy3UGb7ubDM+6Io9KrD
LEFZ7IQhaGk/R8TmqnuyJGSn/gmcPAUMJV46jsWgk/Z8g5VqRqvmc76kRcUFRGGA
yYInTOnubDpWq4+WOWctaXO6O6SL+h6HcWu7taCdYcPpbFOD4AaXgu8I4bgPvLaw
82ilHSxDfEfsoDsDuChvNuDCJuRkIP3i0gbGbhQbvre51duk7+pvytPF+NzZPRit
jY6AFiDoqRPT/+I4YyZT
=b39n
-----END PGP SIGNATURE-----

--V7BlxAaPrdhzdIM1--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
