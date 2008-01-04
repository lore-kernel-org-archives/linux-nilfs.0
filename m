From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: __udivdi3
Date: Fri, 4 Jan 2008 04:16:30 +0100
Message-ID: <20080104041630.57fd0df6.elentirmo.gilgalad@gmail.com>
References: <20080103034154.bf6c74be.elentirmo.gilgalad@gmail.com>
	<200801032238.44785.chris@csamuel.org>
	<20080103161729.c623ad3e.elentirmo.gilgalad@gmail.com>
	<20080104014721.3D7163E06C1@fs.osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0535208605=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
	bh=W04wcfDl+SODPg9/2Vq7AR3fO8InORKD/4lWt3yM/Wo=;
	b=hroOUXJIMKT480TA967nAoQ3XB44j8fTNV6ZWYHk0jdyb5q0d4zwYhybVlbHv3a9dxLjnWAOb2ChMobXGda2XeqPzWxGlBrKboKBOL+2S5nF8OvXnWKnDQiZ2CcEdDuLdJ80LGkP0sJsxR32o1HjcvZdvMyR056bHCoMeTrQpGk=
In-Reply-To: <20080104014721.3D7163E06C1-121w62HK5dnR7s880joybQ@public.gmane.org>
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

--===============0535208605==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Fri__4_Jan_2008_04_16_30_+0100_kv=C+mYb/Ygf+Qcq"

--Signature=_Fri__4_Jan_2008_04_16_30_+0100_kv=C+mYb/Ygf+Qcq
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri,  4 Jan 2008 10:47:21 +0900 (JST)
amagai-sG5X7nlA6pw@public.gmane.org wrote:

> Hi,
>=20
> Could you try following steps?
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> cd nilfs-2.0.0-testing-8/fs
> edit Makefile, uncomment this line to enable debug option.
>=20
> #CONFIG_NILFS_DEBUG=3Dy
>=20
> make clean
> make
>=20
> egrep -i udivdi *.lst
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> I hope that the egrep shows filename which includes the
> undefined symbols.
>=20
To me it looks like the Makefile has some errors, or my make behaves strang=
ely
/*
ggergely@vosztok ~ $ make -v
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i686-pc-linux-gnu
ggergely@vosztok ~ $=20
*/
I think the Makefile error is that make doesn't expand $@ in line 20
/*
  EXTRA_CFLAGS +=3D -g -Wa,-adhlms=3D$@.lst -fno-omit-frame-pointer
*/
as it flooded me with info. i saved the stderr, and realised this:
/*
{standard input}: Assembler messages:
{standard input}:45564: Warning: can't open .lst: Permission denied
...

although, the uber dirty trick to change the line to=20
/*
  CFLAGS +=3D -g -Wa,-adhlms=3D$@.lst -fno-omit-frame-pointer
*/
did the trick. ;) I recommend examining this error as well, (I'm not a make=
file master, it'd take ages for me to find the cause and the fix) but if I =
see the situation wee for the first glimpse this as well may be some linux =
kernel makefile related stuff.

ggergely@vosztok ~/tmp/nilfs/nilfs-2.0.0-testing-8/fs $ egrep -i udivdi *.l=
st
dat.o.lst: 974              	.globl __udivdi3
dat.o.lst: 1245 03cb E8FCFFFF 	call __udivdi3
dat.o.lst:__udivdi3
ggergely@vosztok ~/tmp/nilfs/nilfs-2.0.0-testing-8/fs $=20


> My colleagues (and include me) are used nilfs 2 as /home=20
> of developping PC's with onw risk :-)
> Nilfs 2 cannot handle a disk full condition well,=20
> so, parameter tuning in /etc/nilfs_cleanerd.conf are very critical.

Thank you, this is good news for me! I hope soon I'll be running nilfs2!

Sorry for the long letter, hope I could help, and I'm waiting for the news.
Best regards: G=C3=A1bor Gergely
--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--Signature=_Fri__4_Jan_2008_04_16_30_+0100_kv=C+mYb/Ygf+Qcq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHfaURlZGsj+xzT3kRAsvsAKDP6FgqBoFyuli/wYcG7/rMvMZhJQCfciy3
yPs89vHUCGlNmMHsq5m3R60=
=D1tP
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Jan_2008_04_16_30_+0100_kv=C+mYb/Ygf+Qcq--

--===============0535208605==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0535208605==--
