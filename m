From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Thu, 3 Jan 2013 22:49:13 +0100
Message-ID: <20130103214913.GE2080@wloczykij>
References: <20121129210650.GA4028@wloczykij>
 <1354255744.2090.3.camel@slavad-ubuntu>
 <20121130073219.GB4028@wloczykij>
 <1356415552.2052.11.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1356415552.2052.11.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 25, 2012 at 10:05:52AM +0400, Vyacheslav Dubeyko wrote:
> Hi Piotr,
>=20
> On Fri, 2012-11-30 at 08:32 +0100, Piotr Szymaniak wrote:
> > On Fri, Nov 30, 2012 at 10:09:04AM +0400, Vyacheslav Dubeyko wrote:
> > > Hi,
> > >=20
> > > On Thu, 2012-11-29 at 22:06 +0100, Piotr Szymaniak wrote:
> > > > Hello.
> > > >=20
> > > > Doing some work today (system update, kernel update, rsync rootfs w=
ith
> > > > external drive) I noticed some unwanted behaviour:
> > > > maszn ~ # touch afile
> > > > touch: cannot touch =E2=80=98afile=E2=80=99: System plik=C3=B3w wy=
=C5=82=C4=85cznie do odczytu
> > > >                         it's Read only filesystem
> > > >=20
> > > > dmesg shows a lot (1812 in the log) of:
> > > > [ 8288.319012] NILFS: bad btree node (blocknr=3D26229286): level =
=3D 178,
> > > > flags =3D 0x0, nchildren =3D 0
> > > > [ 8288.319017] NILFS error (device sda2): nilfs_bmap_lookup_contig:
> > > > broken bmap (inode number=3D102230)
> > > >=20
> > > > After mount -o remount,rw /
> > > > [ 8384.734024] segctord starting. Construction interval =3D 300 sec=
onds,
> > > > CP frequency < 30 seconds
> > > > [ 8384.734028] NILFS warning: mounting fs with errors
> > > >=20
> > > > Never happend before and it looks like it works fine now (using van=
illa
> > > > kernel 3.6.4).
> > > >=20
> > > > After a reboot (to vanilla kernel 3.6.8) dmesg shows:
> > > > [    6.046883] segctord starting. Construction interval =3D 300 sec=
onds,
> > > > CP frequency < 30 seconds
> > > > [    6.046884] NILFS warning: mounting fs with errors
> > > >=20
> > > > I don't like the "errors" part...
> > > >=20
>=20
> Did you have any snapshots on this volume or not?

No, only checkpoints (just checked).

Also, got this issue again. A *lot* of:
Jan 03 22:36:38 [kernel] [  953.289973] NILFS: bad btree node
(blocknr=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
Jan 03 22:36:38 [kernel] [  953.289976] NILFS error (device sda2):
nilfs_bmap_lookup_contig: broken bmap (inode number=3D102230)
Jan 03 22:36:38 [kernel] [  953.289976]=20
Jan 03 22:36:38 [kernel] [  953.290248] NILFS: bad btree node
(blocknr=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
Jan 03 22:36:38 [kernel] [  953.290251] NILFS error (device sda2):
nilfs_bmap_lookup_contig: broken bmap (inode number=3D102230)
Jan 03 22:36:38 [kernel] [  953.290251]=20
Jan 03 22:36:38 [kernel] [  953.290523] NILFS: bad btree node
(blocknr=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
Jan 03 22:36:38 [kernel] [  953.290526] NILFS error (device sda2):
nilfs_bmap_lookup_contig: broken bmap (inode number=3D102230)

Then I remounted rw and tried again (i was rsyncing my whole rootfs to
another drive):
Jan 03 22:38:15 [kernel] [ 1050.290134] segctord starting. Construction
interval =3D 300 seconds, CP frequency < 30 seconds
Jan 03 22:38:15 [kernel] [ 1050.290135] NILFS warning: mounting fs with
errors
Jan 03 22:38:15 [nilfs_cleanerd] start
Jan 03 22:38:15 [nilfs_cleanerd] pause (clean check)
Jan 03 22:38:40 [kernel] [ 1075.157346] NILFS: bad btree node
(blocknr=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
Jan 03 22:38:40 [kernel] [ 1075.157351] NILFS error (device sda2):
nilfs_bmap_lookup_contig: broken bmap (inode number=3D102230)
Jan 03 22:38:40 [kernel] [ 1075.157351]=20
Jan 03 22:38:40 [kernel] [ 1075.157352] Remounting filesystem read-only
Jan 03 22:38:40 [kernel] [ 1075.159162] NILFS: bad btree node
(blocknr=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
Jan 03 22:38:40 [kernel] [ 1075.159168] NILFS error (device sda2):
nilfs_bmap_lookup_contig: broken bmap (inode number=3D102230)
Jan 03 22:38:40 [kernel] [ 1075.159168]=20
Jan 03 22:38:40 [kernel] [ 1075.161003] NILFS: bad btree node
(blocknr=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
Jan 03 22:38:40 [kernel] [ 1075.161019] NILFS error (device sda2):
nilfs_bmap_lookup_contig: broken bmap (inode number=3D102230)

But, thanks to rsync I got a (corupted?) file that causes the problem.
It's some /var/tmp/kdecache-$USER/foo.kcache. copying this file to
another place ends with readonly.


Piotr Szymaniak.
--=20
  - Chyba nie jest pan jednym z tych roniacych lzy liberalow?
  - Odmawiam odpowiedzi, poniewaz moglaby zostac wykorzystana przeciwko
mnie - odparlem.  Taksiarz  wydal  prychniecie oznaczajace dlaczego-ja-
zawsze-trafiam-na-takich-cwaniakow... ale zamknal sie.
  -- Stephen King, "The Breathing Method"

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQ5fzZAAoJEEMpAov1cw9lE3EP/18EEfuF7/jNDtIGcXx+9hpE
htx9YqWzY7zZ2VuF0rmB4jBbT44rcA83II6I3WmQEfozKb4VbDUyp5Io+BVwYCiP
vwP5DxV54xBU3198PVqsGjxIxhzRU7OqZPh1vI9zgs2SZVlH3VHKtvCeJ4bjWYNu
pES0taZGQglfHuSrVLgQhvHR288R2rhAYlBbWMy9kPhSkPQx51I06a7Fe26ZVCmj
vYFvTM7g28FOE7AZ6c+0MfrxxF0vurASB3Eev2GJp0ccjSkPUBAEUKeKWc/F+v0U
guGICepbrttoSeicf9831QNQDv/JiCcuV0yYU0XBCG6bfcL0DCFb7CM9g/ZCXOVm
OGF5l2jI0TOh2DZ5oKH6FSJWZg5aM0EMvOoHZcwOTSBOPDjmQGUZKXA+BZjUy0zH
kDulGQOryZUVD2j/kiDCwoahs11hUcJetC1H8qxGGYYXHXwech/hqKyhsC1CTm+N
wvuV0i29xprMyaUQzJX1qVcPSOJZ45KUol4zjdCQQFHbcB6Nbd9XFvOXYAUL5fIN
LYs1dm3V0lFvYK9lz5kuorJ3uOXi4rMEmJqBkhOOUwftH/5/MNBKqckoq9e3JXcJ
KTQcsgPdgL9CvN6iUpJkEm8eOZcmqJC/oRcxH7bxoxlIBlu4PSVKcrnTpIi+MTvH
XqCvX2Aq+tPtqmhE/v55
=3da5
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
