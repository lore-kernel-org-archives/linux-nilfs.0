From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Thu, 11 Oct 2012 11:23:00 +0200
Message-ID: <20121011092300.GB27763@wloczykij>
References: <20121009105239.GV28032@wloczykij>
 <1349784514.1921.9.camel@slavad-ubuntu>
 <20121009135833.GX28032@wloczykij>
 <20121010.012440.17932600.konishi.ryusuke@lab.ntt.co.jp>
 <20121010073912.GA28032@wloczykij>
 <1349870593.1889.107.camel@slavad-ubuntu>
 <20121010220331.GA27763@wloczykij>
 <1349938258.1908.3.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1349938258.1908.3.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 11, 2012 at 10:50:58AM +0400, Vyacheslav Dubeyko wrote:
> On Thu, 2012-10-11 at 00:03 +0200, Piotr Szymaniak wrote:
> > On Wed, Oct 10, 2012 at 04:03:13PM +0400, Vyacheslav Dubeyko wrote:
> > > I need in superblock's content anyway.
> > >=20
> > > Currently, I need in raw dumps from two blocks after dump preliminary=
 analysis. Because you have message about root inode corruption then it nee=
ds to check the root inode raw representation in ifile (ino =3D 6). As I ca=
n see from your dump that the third block of ifile is located in 734205 blo=
ck (blkoff =3D 2, blocknr =3D 734205). Also I can see that root inode conte=
nt (ino =3D 2) is located in 734158 block ( blkoff =3D 0, blocknr =3D 73415=
8).
> > >=20
> > > Could you share these 2 blocks content?
> > >=20
> > > Or you can check that these blocks contains expected metadata info. I=
 expect that some of these blocks doesn't contains valid metadata info.
> >=20
> > How should i make the dump?
> >=20
>=20
> You can use dd for dumping (dd if=3D/dev/<device> of=3D<file> bs=3D<block=
 size> skip=3D<offset to the block> count=3D<blocks count>).

So I should dump block 743205 and 734158? Ok, but I'm not familiar with
blkoff.

ie. blkoff =3D 2, blocknr =3D 734205 it means the dump should be block
734205 and (blkoff =3D 2) next two blocks? If this is correct then this
should work, right?
dd if=3D/dev/<device> of=3D<dump> bs=3D2048 skip=3D734205 count=3D3 (not su=
re if
dd counts skip=3D and count=3D from 0 or 1)
And similar with block 734158 but only one block (blkoff =3D 0)?


Piotr Szymaniak.
--=20
Oczywiscie wiedzial,  ze byla wojna - nie ta obecna,  glupia,  w ktorej
Amerykanie  dostawali  lomot od bandy zoltkow w czarnych pizamach - ale
druga wojna swiatowa.
  -- Stephen King, "Apt Pupil"

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQdo/zAAoJEEMpAov1cw9l3WcQALvFb3I8hHBHEsoNEUIInvVw
zZoo4wGpwYrMFycaCgPXThP8fghHXnebZXYA5O1wRTUmWx7/SgIKjaXAicy8BN/v
/JqjZi4rp7rjhtKAoNVESuO5v1pCIwrQe7cZVC8qNZq5RhZM9hD8+mG42jBSqRvF
dN7lWuQhjDYEAhXfepv7z3qo6Q0Cj0rtEcoa4HPxOsEMX+WonIGP3Su/hg2HmhQX
/dZysyPW8Jb1XTjPxbAWBjkhWU9PjAsBge7vlV3SFKoEwOWwcHAWH8awFkip9RHg
butP1+FJifs6oi3Geq8LIxJw/GXq4U4NTMweonvKY3qOJlZdw8qOW1PVZzf/axLG
Aqzbk1++iBUZWGHADUoBiAqxkS7ypFOcqEN08SQCcXFyayLgmmZQoYdLjbpQPZel
1OoHJYpqwhgRTXrEYf2BfW10olXA6aMw79o5SOC5k+X73on5QAR9LL2qK6AUVdsq
6cBc/kCJt1oEPsWnmKmJ1aY4aRS48E4zyZvpDGathkmAS4bRZKvewuL4Aa4NgQcM
NT8GplZ7kAnji28qu+CFdD37Y5toYY6u1JOGjK7+Ii05Rg2OmoVSjAHX0U1l+OCg
LXwgTl0EqWIXWs4s6oWqDgMGQRJ1It/TQ2ANylx21nQPDUfyB8at0F6r2YOvm0At
ZcAeIVFFZTFwQ6H8b/BE
=k5pz
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
