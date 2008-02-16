From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: some notes on a memory leak
Date: Sat, 16 Feb 2008 23:13:20 +0100
Message-ID: <20080216231320.05db87a1@vosztok>
References: <20080214010258.76494d68@vosztok>
	<20080215.150709.13051610.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1951600678=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
	bh=6bX4WED7aHtUhFLQcvugE53YuKHFJ+KtC7UcAcMMu0o=;
	b=KBeYpOcXgqfmLJwsjBZVrJLNqmHIZc9W+IHmpK008qzs5CnEiQ6Ir3for2OT3ifuPa1ZxfscsNAv67YN0C2UrbscY/lQlqe8H0cXvuCcs4qxsRpBQJBZ5xo7ZH0hNndBJDGnIARRMMqNKufI+24k1XvVb/++s+6EBTR8lcLSHtk=
In-Reply-To: <20080215.150709.13051610.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============1951600678==
Content-Type: multipart/signed; boundary="Sig_/P4PkyeND+53lxdrY5yC_ByA";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/P4PkyeND+53lxdrY5yC_ByA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Greetings!
>=20
> I'd like to append a note.
>=20
> NILFS has two different things about the cache usage than ordinary
> filesystems:
>=20
> (1) Since the cleaner clowls over a partition, it adds new pages into a c=
ache
>     of the block device one after another during it operates on the backg=
round.
>=20
> (2) Some blocks, for example the blocks to store header information of ea=
ch
>     segment, are allocated incrementally into the cache of the block devi=
ce.=20
>     So, bursty writes or frequent sync writes may bloat it.
>     Conversely, the turnover of buffers for files or meta data should not=
 be=20
>     higher than usual fs because a same buffer serves for a same file off=
set
>     even when its physical disk address changes.
>=20
generally nilfs2 performs well. rtorrent triggers some error.

> I made a patch to minimize the bloat of bdev cache due to the second
> difference.
> If you are bothered with that, please test the following patch.
> From my local tests, it didn't make no remarkable difference.
I tried the patch, i see no basic difference. the fs generally works fine, =
but rtorrent can make it consume all memory, and not free it after exit. ju=
st as if the cache entries didn't age (well i don't know how to describe th=
e situation better with my naive words). I have tried setting the following=
, with no luck:
 vm.vfs_cache_pressure =3D 200
and even=20
 vm.drop_caches =3D 3=20

according to docs, it should have had some effect, but neither had any (in =
case of rtorrent's garbage)

the "pages" cached by rtorrent can't be flushed out of cache even when rtor=
rent has quit. This may as well be he fault of rtorrent, but I can remember=
 an ext3 bug that was found by an rtorrent malfunction, and still, it is no=
t right. (other programs generally seem to release cache after some time af=
ter having been closed). If i start a hash check on a near complete dvd ima=
ge in rtorrent (0.7.9 version) i can waste my ram in less than 2 minutes!

umount helps. but now i can do my works on my notebook aswell.

Best Regards:
--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

* random fortune:
Above all things, reverence yourself.

--Sig_/P4PkyeND+53lxdrY5yC_ByA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHt2AAlZGsj+xzT3kRAoC8AJ9oIpawbMeLu8IAa6HnorNHNTZJWgCfXdZm
ooTQxRERJX+FHXfKNbYx35k=
=y08f
-----END PGP SIGNATURE-----

--Sig_/P4PkyeND+53lxdrY5yC_ByA--

--===============1951600678==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1951600678==--
