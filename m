From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs2 not garbage collecting
Date: Mon, 6 Aug 2012 13:48:20 +0200
Message-ID: <20120806114820.GY1478@wloczykij>
References: <CANku=ggohcWWoxE1x=XmfWpANKyWRTWb5p_aHh8LU6+utU4OPQ@mail.gmail.com>
 <CANku=ghnDzkFHpPZ8eT9Y3kTM62zBKMk6TjBVraE4Kisa1TRPQ@mail.gmail.com>
 <F50BDE9A-4863-49CC-AC87-EEDC5B854E9C@dubeyko.com>
 <CANku=gjkTr-nYq8RxTUCVK9YU+xTjHyPbktB86BUpeuMwMBC4A@mail.gmail.com>
 <D99F26AB-309D-4325-A87C-DBF0F7BA6360@dubeyko.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2VmY8g3XFtK+hx8d"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D99F26AB-309D-4325-A87C-DBF0F7BA6360-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--2VmY8g3XFtK+hx8d
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 05, 2012 at 08:51:21PM +0400, Vyacheslav Dubeyko wrote:
> Hi Paolo,
>=20
> On Aug 5, 2012, at 6:46 PM, Paolo Giangrandi wrote:
>=20
> > No, didn't try, I missed that program, and I'm quite afraid of
> > breaking something...
> >=20
> > Currently checkpoints are like this:
> >=20
> > # lscp | head
> >                 CNO        DATE     TIME  MODE  FLG     NBLKINC       I=
CNT
> >              302507  2012-07-19 15:36:17   cp    -          429     138=
707
> >              302508  2012-07-19 15:36:17   cp    -           27     138=
707
> >              302509  2012-07-19 15:36:21   cp    -           86     138=
708
> >              302510  2012-07-19 15:36:22   cp    -           30     138=
708
> >              302511  2012-07-19 15:36:22   cp    -           29     138=
708
> >              302512  2012-07-19 15:36:22   cp    -           27     138=
708
> >              302513  2012-07-19 15:36:22   cp    -           29     138=
708
> >              302514  2012-07-19 15:36:24   cp    -           34     138=
708
> >              302515  2012-07-19 15:36:24   cp    -           26     138=
708
> > # lscp | tail
> >              305341  2012-08-04 23:03:21   cp    -          141     138=
492
> >              305342  2012-08-04 23:05:06   cp    -          646     138=
418
> >              305343  2012-08-04 23:07:22   cp    -          229     138=
392
> >              305344  2002-02-26 00:01:56   cp    -          708     138=
392
> >              305345  2002-02-26 00:02:03   cp    -           33     138=
392
> >              305346  2002-02-26 00:02:22   cp    -           29     138=
392
> >              305347  2002-02-26 00:05:30   cp    -           25     138=
392
> >              305348  2002-02-26 00:08:25   cp    -           29     138=
392
> >              305349  2002-02-26 00:14:28   cp    -           27     138=
392
> >              305350  2002-02-26 00:15:01   cp    -           32     138=
392
> >=20
> > (the date of some checkpoints is set to 2002 because that EeePC has
> > some issues with the clock: the clock battery is probably broken)

Iirc there was some issue with nilfs_cleanerd and timeshifting (and
here we have cp 305344 10 years before 305343). But I think it was
solved, so maybe you have (old)  nilfs-utils without the patch?

Piotr Szymaniak.

--2VmY8g3XFtK+hx8d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQH68EAAoJEEMpAov1cw9lTYoP/iUbsiy1mbGg31N+CylQE8BI
praF1C6jmh182q79s1owqDY/QIC9vcq4VP9dM0Y4KzQSJ1NwEUTzn5BBxyU6warH
cFZ2BtNH8CxObO+puXx6QsaedsO2VbkeWBl+YexB4P6yk7hCTrpgtJZl8GrtneIo
yOeQkAbM0jIRm+EV1WKVAxX7So3hWYGJAI3qj+GYbyAaFhKwOIY1TIVvhIbPg0qK
IAuIerEujFy+Pzy6/x8dX888Dj3i0P8HbApGt7nrGZVSQiGOCnV0MdFUIXa5GWn4
TvSth9qOoHxN2jhZuiN8VeLt4LOT/o2Q+eWYK10M9BIcoDmZ9NLcaugYXmnCYX55
I1Y40tNpofG7px6AzU023sziKMEnLPKkb3UkRXSlaiK9SbrS35SJjMtdhSSSevSC
GdC/uLbvoHFvWXeocyGGKb9ugBMOI6uUA+m5ShL/NrziT8dc1TuxvUEmZNfQdllX
ke0iYttQgMWsw1ehmUm4aXTlbQQo1Ke60K5WllfuZPseg0o+411gA8g3Rl5QzD3b
nF9ST3PB9+MB7bxnsdYy9trbXV3g6P4uI3yvlhICfL3Iuvso5aaupAELiRvOIZ+c
qot5dBVeWO+hPnlEKmVpjNeQr9Vb4GVi3oz/ce6RLjl2i8O1eyRiY66Z13IQWQb3
xSEd5RpkXdMNc0ssZzs9
=QDkL
-----END PGP SIGNATURE-----

--2VmY8g3XFtK+hx8d--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
