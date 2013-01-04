From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Fri, 4 Jan 2013 20:16:33 +0100
Message-ID: <20130104191633.GF2080@wloczykij>
References: <20121129210650.GA4028@wloczykij>
 <1354255744.2090.3.camel@slavad-ubuntu>
 <20121130073219.GB4028@wloczykij>
 <1356415552.2052.11.camel@slavad-ubuntu>
 <20130103214913.GE2080@wloczykij>
 <28ABE57F-66DD-491E-9FDB-A6CE3CF773FB@dubeyko.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <28ABE57F-66DD-491E-9FDB-A6CE3CF773FB-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 04, 2013 at 03:46:13PM +0300, Vyacheslav Dubeyko wrote:
>=20
> On Jan 4, 2013, at 12:49 AM, Piotr Szymaniak wrote:
> > No, only checkpoints (just checked).
>=20
> Ok. It means that snapshots don't play any role for the issue.

Yes, it seems so.


> So, the issue was occurred not because of using rsync. Am I correct? I
> simply remember that rsync was used in another report about this issue
> also.

Yes, rsync just gave me information where it had an i/o error.


> > But, thanks to rsync I got a (corupted?) file that causes the
> > problem.  It's some /var/tmp/kdecache-$USER/foo.kcache. copying this
> > file to another place ends with readonly.
> >=20
>=20
> So, maybe the nature of /var/tmp/kdecache-$USER/foo.kcache is a reason
> of the issue. It is a very interesting detail. Could you share more
> details about this file? I mean size, creation time, modification
> time, owner, rights and so on. Moreover, could you share more details
> about your hardware environment? I mean CPU and RAM details.

maszn ~ # file /var/tmp/kdecache-appe/plasma_theme_Transparent-sima84.kcache
gives me an i/o error and remounts ro.

maszn ~ # stat /var/tmp/kdecache-appe/plasma_theme_Transparent-sima84.kcache
  File: =E2=80=98/var/tmp/kdecache-appe/plasma_theme_Transparent-sima84.kca=
che=E2=80=99
  Size: 84213856        Blocks: 165144     IO Block: 4096   regular file
Device: 802h/2050d      Inode: 102230      Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1001/   appe)   Gid: (  414/   appe)
Access: 2012-11-14 16:15:01.377207479 +0100
Modify: 2012-11-14 16:15:01.377207479 +0100
Change: 2012-11-14 16:15:01.377207479 +0100

Intel Pentium Dual-Core E5400, 4GB RAM, nilfs2 is located on part of
Kingston SSD. It runs x86 Gentoo Linux with vanilla kernel (from
kernel.org) and I try to keep it up to date (3.6.8 right now, but I was
away for some time) and recent nilfs-utils from the portage tree (this
could also be considered as "up to date" or "up to upstream releases").


> I think that it can be very interesting to know about how this file is
> distributed on the volume. Could you get by means of dumpseg
> information about several last segments? I don't know how many it
> needs for understanding but maybe about 10 can be enough for the
> beginning.

The file is pretty old so last 10 segments won't solve the issue, right?

Piotr Szymaniak.
--=20
 Natezyl sluch. Nic poza odglosami owadow z dziedzinca i naszeptywaniem
spryskiwaczy trawnika. Nic poza miarowym kapaniem z kranu w lazience.
 To bylo niczym zycie, skapujace kropla po kropli. K a p, k a p, k a p,
wszystko w kanal.
  -- Graham Masterton, "The Burning"

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQ5yqQAAoJEEMpAov1cw9lcUEQAJwHrQJLqp60KhKtTarsedCv
cG55Z/TbQ+5fg0Xl4Vc5QqEp03AL3OO/NEigh0k46QtvIoZO+2DmUkhTQJVHFHsC
khkU+BQTFHXXIK9WFKUXFlSe+hzKNbaBrrATnK78h4QIoBgRJYdZSTsKsxr6KrNW
TWqY//VfeAomUFO6OSrJWxUvWw98+IEr7bCIMLxttlq4jhJtSsSO+lyKVCwyTLux
Zm7qBJRUYAwOXYAoQmAnIBWe1wIfBx4iXqw6x6TAGqinV2a5yfTjJP73y+sDG0w6
oe9QhSy7AjfvYd0rGYvQeyIi6NmbUcJD6p8yg+HiNoiTy0Cfh1HvRj8cUIQF47AD
aWs2iJEgZfmjlH/GUTP/5x4lZwmTYR+mR+DKjoPfunhK1cKKVIk6w05KzWxEkXxv
1CekMgOhVPxXV0OekjdGt7HkD3gi2KaVRNykVY78FHopjXsmDgXvssQxMHQ/Mmkh
LUHT99QKQWPRHcvCljdF4q7fORNiIfNscDo2yY2jWKWAw077tCyOpDl9x/S7e5RW
eQF+YxDcvJqPKnQoJTyCnoRGx//u7YdTXIZ0SZmocW963sJze7PnJN9Lef9OA1g7
vHxc2aMMxxCWUbO/nGr6xMSmTmbFMkhR0DcBRk2jCzY5h1UfAMpAoev4fY0AgM4V
etPKK/KwEm2eyXZG3Ro+
=ojhZ
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
