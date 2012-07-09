From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Mon, 9 Jul 2012 18:56:26 +0200
Message-ID: <20120709165626.GT1478@wloczykij>
References: <20120709073300.GP1478@wloczykij>
 <1341826112.1965.6.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1Sa0i77dkqaUxqYg"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1341826112.1965.6.camel@slavad-ubuntu-11>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--1Sa0i77dkqaUxqYg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 09, 2012 at 01:28:32PM +0400, Vyacheslav Dubeyko wrote:
> Hi Piotr,
>=20
> Does system journals on your machines contain any interested details
> about reported issue? Could you try to extract some error or warning
> messages from system journal?

(resend as I replied only to Vyacheslav)

If by journals you mean logs then no. I'm only able to find some like
this:
Jul  3 10:32:45 wloczykij nilfs_cleanerd[1434]: resume (clean check)
Jul  3 10:41:37 wloczykij nilfs_cleanerd[1434]: pause (clean check)

That's all about nilfs in the last week and current log has only manual
runs related to those operation described before.

Piotr Szymaniak.


> On Mon, 2012-07-09 at 09:33 +0200, Piotr Szymaniak wrote:
> > Hi.
> >=20
> > I've upgraded nilfs-utils (running Gentoo) on 29 july. Today I ran out
> > of space on my / and found that nilfs_cleanerd isn't working. When I
> > start it from the command line it exits instantly. Also, all previous
> > checkpoints on / (also on two other mountpoints on different machine)
> > are gone.
> >=20
> > What I did? Downgraded nilfs-utils to 2.1.1, remounted mountpoints. On
> > the second machine it's runnig fine (cleaned _all_ checkpoints), on the
> > first one with disk space issue it exits just like 2.1.3.
> >=20
> > Here are some fs details. Machine with disk space issues, rootfs:
> >     CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
> >  147688  2012-07-09 08:38:14   cp    -        11075     242915
> >  147689  2012-07-09 08:38:14   cp    -           60     242895
> > (=E2=80=A6)
> >  148999  2012-07-09 09:13:46   cp    -           60     242888
> >  149000  2012-07-09 09:19:45   cp    -           44     242888
> >=20
> > Filesystem      Size  Used Avail Use% Mounted on
> > rootfs           24G   13G   11G  56% /
> >=20
> > mount shows:
> > /dev/sda2 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D15356)
> >=20
> > There's no nilfs_cleanerd with pid 15356.
> >=20
> >=20
> > Second machine rootfs:
> >    CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
> >  92246  2012-07-09 08:16:58   cp    -          118      44669
> > (=E2=80=A6)
> >  92439  2012-07-09 09:19:14   cp    -           29      44668
> >  92440  2012-07-09 09:19:46   cp    -           33      44668
> >=20
> > Filesystem         Size  Used Avail Use% Mounted on
> > rootfs             3.7G  888M  2.6G  26% /
> >=20
> > (it should be around 3G used)
> >=20
> > Second machine second mountpoint:
> >    CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
> >   1496  2012-07-09 03:31:23   cp    -         8837     132766
> >   1497  2012-07-09 03:31:26   cp    -          468     132766
> >   1498  2012-07-09 03:41:27   cp    -         1474     132765
> >=20
> > (this fs should containt *all* 1498 checkpoints)
> >=20
> > Filesystem         Size  Used Avail Use% Mounted on
> > /dev/dm-2          117G   58G   54G  76% /mnt/home_backup
> >=20
> > (in this one it should be around 100G of used space)
> >=20
> > mount:
> > /dev/dm-2 on /mnt/home_backup type nilfs2 (rw,gcpid=3D13135)
> > /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D1363)
> >=20
> > Both cleaners running (the second mountpoint - /mnt/home_backup - is un=
der
> > heavy load and I suppose it will end with around 20G used space).
> >=20
> > Where to go from this point? How to debug nilfs_cleanerd issue?
> >=20
> >=20
> > Piotr Szymaniak.
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Marriage is like a coffin and each kid is like another nail.
  -- Homer Simpson

--1Sa0i77dkqaUxqYg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJP+w06AAoJEEMpAov1cw9lR/wP/i8vqo5+rpG5aKkUP3kGYODO
91zdtQCttYsUXyej/ULzCKkpPoGi0PY0KhC7WyoTOz+VhikW+u3SSZhJK0mDoiuG
MI/d3OffgNJr2J9uH9ehuc7Gh4nwaJCCmCqGlkcSImdzQBCfq6pzFAtKEh9MrmgG
b3Wb7SSvCOyNNxE7FI34UpgKGEZYWQsLurPWT7R5J6x7/gYHk1o9DCEgAK5mFX0+
t4naKzoZrcSKJRBTqBLFTp6pVmmZMYsC7UfuLZWsOUT0lIdUODVw/R29A8Iy0hCn
fZiz5yfwLxQqLa8T6aq9tZs+4hWDkq/PA6wH+1PJ8sDzd+nrRgfaofExz8EU1WSq
78ORAFmLyx6rj6IZZVJSPbvtUp04xEzHXxzEKnC91DVpkUaXAsiS5i5II4Cdq0Qh
ldOr36GCCxdP7xuAgSetk3v2/XDmp0rlDxEshGxoW6iqFEztK2nvlYEExDCsWZZy
C+3BqowxiYU8F4MRnle6KFuuVOoo8/3zouz4SPqAFsKVVb4/VTcg1u5b4nc/X+Hd
CNxPOcRydMYIbvWG7SYtvFZri4maNIEeemEyr2wQfucir+PFAtMsynDOxitJLPrP
u8//YHeOfZiXGB6Ym5ni+RGl7r82ucfhJ0q3shBYDQuwGhlRC9FR1Tq9/uJrsKiQ
iRbrFhTbsyCMSmRxxUqM
=Po81
-----END PGP SIGNATURE-----

--1Sa0i77dkqaUxqYg--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
