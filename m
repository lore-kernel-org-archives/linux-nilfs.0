From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Fri, 12 Oct 2012 14:28:30 +0200
Message-ID: <20121012122829.GH27763@wloczykij>
References: <20121008222557.GU28032@wloczykij>
 <1349767793.3427.7.camel@slavad-ubuntu>
 <20121009105239.GV28032@wloczykij>
 <20121012114915.GE7823@csmith-bm.vm.bytemark.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="P7Tqkd/m/Jnohiaz"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121012114915.GE7823-Ng8wz+J301SNY5Lh21HnMTHS2PGA244I9dF7HbQ/qKg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Christian Smith <csmith-r5H9PUQoNxUga4AWyxku7ULnMzgEhdHr@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--P7Tqkd/m/Jnohiaz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 12, 2012 at 12:49:15PM +0100, Christian Smith wrote:
> On Tue, Oct 09, 2012 at 12:52:39PM +0200, Piotr Szymaniak wrote:
> > It's an ???allowed??? overcloking. I have another SD Card with Raspbian=
 (and
> > without nilfs2) that works fine with Turbo Mode. At least it seems to
> > work fine. The second card was in Turbo Mode (@900MHz) for a few days
> > and was working. Yesterday i made it @1000MHz and it didn't boot.
>=20
> It's allowed in that it no longer invalidates your warranty, but I don't =
think
> there is any guarantee it will work.
>=20
> Overclocking also puts more load on the PSU, so there is potentially less
> power available for the SD Card to work with. Perhaps a write failed due
> to power issues in Turbo mode? What is your PSU rating? 0.7A is the
> recommended amount the PSU should be able to supply.

It seems to work fine with Raspbian, so I dubt it's an PSU issue (I've
tested Raspbian @1000MHz in the first place). Afair the PSU is 1 or 1,1A,
so that should not be a problem.


> As an aside, I have also been thinking of using NILFS root, but struggled=
 to
> get the default kernel up and running with an initrd (to load the nilfs2
> module). Did you use a built in nilfs2 driver?

Yes, I'm using custom build kernel with build in nilfs2 support (and a
lot of stuff cut down since I won't use it (and even if, I can compile
them back, right?)).


Piotr Szymaniak.
--=20
Nie mam problemu z piciem.  Bez  problemu  pije,  upijam sie i walam po
podlodze.
  -- R. Williams

--P7Tqkd/m/Jnohiaz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQeAztAAoJEEMpAov1cw9leLgP/RSanvgFhx+N3orAYGtgB1IX
x0uEDlimf8RAhd4mlLUOdDd56IX+9NILlrq7ltfDNQIfDsN01W9itr2oaIbN1V3w
tSEDtAFS3Py8K8Ayb8Vj7/WeXSLqw6j/1+LdHn8lNFN4iVTZe1hxx/0jP6uhaixE
Z53PRR9EaDLTxksc7prrdbafLTY4qc06UMB7aRK9qffPRSt3UwZUcOOxvsWthLuC
uIbOQJbS/uWPXPk1Zyk04bGlBzURLPY3TAU9jyIFTK+UBG2HBC8w5FQ0uWQwT3T1
/8C5tfKU3CNZhRy0UYjjvTMZLfYxOXNTkhf7qw3J5TDAWpBY3NRuez4JPIjvH+WW
VQiqNC5OXh5nLCxyTqDUaLfbWpWYKriM1MmzGUYoIyVewfdYNp+rVnjEM3CeBSco
oVPZVbtceP+idbzZqp6UWI8vS7B4zKAJZSm3jdY2PsNdEQuNTzdi0fiKF11S/diW
IQLsQfB9A8Rg+eTbk7llzCZtbGQroV5WbkmahfCMZFxLdeqhOpvWjQ/7Fu3aC03K
LAkV2NmXjadoDlMyrQdbJY9nwlE+wXqsCGY6feip8UBgfIn1Epw4Un95rGhRBAE6
JWN8tK+8iMoAcFrp4RfiFItjJcLN7RMXGOZscUH9VhW9mfY8+3qmzeIXzZIj7CEa
WL6LbaBpthLgh9FBJoqm
=Gu/O
-----END PGP SIGNATURE-----

--P7Tqkd/m/Jnohiaz--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
