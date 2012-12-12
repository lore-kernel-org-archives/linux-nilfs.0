From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs_cleanerd cannot open nilfs on device that exists
Date: Wed, 12 Dec 2012 15:54:55 +0100
Message-ID: <20121212145454.GF3064@wloczykij>
References: <20121212145116.GE3064@wloczykij>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="VMt1DrMGOVs3KQwf"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121212145116.GE3064@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 12, 2012 at 03:51:16PM +0100, Piotr Szymaniak wrote:
> Hello,
>=20
> I got a power failure today and after power restore there's a weird
> issue with nilfs_cleanerd:
>=20
> wloczykij ~ # ll /dev/sda3
> brw-rw---- 1 root disk 8, 3 Dec 12 08:35 /dev/sda3
>=20
> wloczykij ~ # mount | grep nilfs
> /dev/root on / type nilfs2 (rw,relatime)
> /dev/mapper/backup on /mnt/home_backup type nilfs2 (rw,gcpid=3D2995)
> /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D5333)
>=20
> But when I try to run the cleaner:
> Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: start
> Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: cannot open nilfs on
> /dev/sda3: No such file or directory
> Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: cannot create cleanerd
> on /dev/sda3: No such file or directory
> Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: shutdown
>=20
> Never happend before. Shutdown should be nice (got UPS monitored by
> apcupsd, so I hope it worked - was in the middle of the night, so can't
> really tell if was superclean shutdown).

I should also notice, that other cleaner of different drive is working
without issues:
wloczykij ~ # ps aux | grep nilfs
root      2995  0.0  0.0   2348   808 ?        Ss   12:19   0:00
/sbin/nilfs_cleanerd -n /dev/mapper/backup /mnt/backup


Piotr Szymaniak.
--=20
Przypomnialem sobie, jak powiedzial, ze po raz pierwszy w zyciu boi sie
piekla,  poniewaz  szykujemy sie do zniszczenia daru niebios.  Poczulem
nagle, ze chce mi sie rzygac.
  -- Stephen King, "The Green Mile"

--VMt1DrMGOVs3KQwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQyJq+AAoJEEMpAov1cw9lHG0P/3uLSQURgihe3hr2PuBWh9x9
xgBdG3HUBnrxr/JEaqnCRC+59XuZ7783xwatHGXCob88cVzzZnZ3ytEbeMavOMYN
/7CA/0FWRSFFh12zV+JUnquGbIcVgEoy77FnWaLeugNZKhwdklSEumj8rZGa3YhQ
ji9xKhNBC9xcmHkaumJZ+Wsy63t3lQaCGbHFqY1RHZ6v772sjPcbQtQ7EWzzYIU+
013+tZx69R+7thz8pp3AkuKKPGBuTPq5IGqzPmDiqrxCUY5kSqwswUnfLL3mmMoa
0n4J77ZA0u2cZQ/32x3CMoFcGYF5hE2fCUKqLJW/p5/O+0sXSxB3THKmsVdY7ZVd
sOVVxcPOnqzz+nv2gly4ck8qNSYb7/AuX+tmFMsAFDh3139hrtK6u7aNRCS6gYGn
etFUQH4IFuUaFN9xWNY6xl3ZYA16/AGsvyaAcVzp0lXUz+jSLx5uacbUgG9dS2I9
eCQlH6DrrzPkViCeGaxQZjJ3vv5/atPtDeZanOQsCN6J9ystmMzrv6zS/0SYY22e
bC6lzi/GIN3iK2CPXmDRt4lnAX+ivEgaHBhgQs+pEzlNthHUlM+YvsxmJwd5f9ib
0lpHMyfAs0ESNO1mUqvoSOGhuAhIA0kUQ3hp2VNoKrmkVWuC4Xv8qgpPFn513OA8
kjPEgsrKIwj+b4/ftXCQ
=L3lR
-----END PGP SIGNATURE-----

--VMt1DrMGOVs3KQwf--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
