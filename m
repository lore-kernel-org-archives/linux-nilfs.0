From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: __udivdi3
Date: Thu, 3 Jan 2008 16:17:29 +0100
Message-ID: <20080103161729.c623ad3e.elentirmo.gilgalad@gmail.com>
References: <20080103034154.bf6c74be.elentirmo.gilgalad@gmail.com>
	<200801032238.44785.chris@csamuel.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1187986912=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
	bh=0/wJZ8Gn2TsTzjLK/5BcrjQzgXiE+kuWMzKm5grKcZg=;
	b=MVr9RYlSziBwAGXI6Z4afU4tG9DOhLWmsheF9fbIMZz8HCw/QuANHCbB+nAPV7dyBMmz0D03OCTfiLhuvUYcbls+0TAyv9L5PmpwOZUgIteIg4fQ9nzwtlO8HQIlCeP52bZqJ3x8KjD5MpBJKK13EPhP2LsHv78p3mTSw94YKes=
In-Reply-To: <200801032238.44785.chris-Ru3vu9m2XlBAfugRpC6u6w@public.gmane.org>
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

--===============1187986912==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Thu__3_Jan_2008_16_17_29_+0100_OX6b.lTCYIVKPe0c"

--Signature=_Thu__3_Jan_2008_16_17_29_+0100_OX6b.lTCYIVKPe0c
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Jan 2008 22:38:42 +1100
Chris Samuel <chris-Ru3vu9m2XlBAfugRpC6u6w@public.gmane.org> wrote:

> On Thu, 3 Jan 2008, Gergely G=C3=A1bor wrote:
>=20
> > Serche the net but i couldn't solve the problem (I didnt even find
> > where is a reference to this symbol....)
>=20
> A reference from the ARM list:
>=20
> http://marc.info/?l=3Dlinux-arm-kernel&m=3D112125281504347&w=3D2
>=20
> Andrew Morton back in February implied that it was still there for=20
> x86:
>=20
> http://www.ussg.iu.edu/hypermail/linux/kernel/0702.3/1064.html
>=20
> Dunno if it's been pulled in later kernels though..
>=20
> cheers!
> Chris

If I understand well, this is used by the standard '/' operator on x86 (tha=
t is my case, and btw. I have 2.6.23 kernel with gentoo patches, if that co=
unts), so some division on the code references that macro. this case I cann=
ot solve this myself, yet I can't get the code to work... Please help, I'm =
really eager to try nilfs!

Should the final 2.0 nilfs be released, will it be ready for use for exampl=
e on a /home partition in real life, or will that still be considered risky=
/dangerous?

BTW: if I'll be able to get nilfs to work, I'll make an ebuild for gentoo, =
that can be put up to the nilfs site.

Best regards: G=C3=A1bor Gergely
--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--Signature=_Thu__3_Jan_2008_16_17_29_+0100_OX6b.lTCYIVKPe0c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHfPyMlZGsj+xzT3kRAvm+AJ9x5QLUJ/zhwpIcAOPC8p1ydZrZDwCgoaPb
RMnLXTrA6dYagWZpV4geGGs=
=v/vq
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Jan_2008_16_17_29_+0100_OX6b.lTCYIVKPe0c--

--===============1187986912==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1187986912==--
