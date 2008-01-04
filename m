From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: __udivdi3
Date: Fri, 4 Jan 2008 16:24:51 +0100
Message-ID: <20080104162451.24810644.elentirmo.gilgalad@gmail.com>
References: <20080103034154.bf6c74be.elentirmo.gilgalad@gmail.com>
	<200801032238.44785.chris@csamuel.org>
	<20080103161729.c623ad3e.elentirmo.gilgalad@gmail.com>
	<20080104014721.3D7163E06C1@fs.osrg.net>
	<20080104041630.57fd0df6.elentirmo.gilgalad@gmail.com>
	<20080104140246.2A3D83E06C1@fs.osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0270130304=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
	bh=uvJS7bBBs6W3sG6DuG2Mo83VfdC0n4fUlPs6EJndtKo=;
	b=T9SbbcO9UDVWVGaqWElDsWLMbridpbX0hVRoh+e1exWQaX86e1Otje0nuUCOhb1JSfclK7MpGqee3JQPJyJJzkzJYTq4reegV2gqHP1ZsdjfflgjtPbRLAf89A3Srz3INfujG1kF+zkhv0AJOgl8Q8KOOt29tzNsEVzpM5Naus0=
In-Reply-To: <20080104140246.2A3D83E06C1-121w62HK5dnR7s880joybQ@public.gmane.org>
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

--===============0270130304==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Fri__4_Jan_2008_16_24_51_+0100_Tqi0yiw=9873zykU"

--Signature=_Fri__4_Jan_2008_16_24_51_+0100_Tqi0yiw=9873zykU
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri,  4 Jan 2008 23:02:46 +0900 (JST)
<amagai-sG5X7nlA6pw@public.gmane.org> wrote:

> Hi,=20
> please try following patch,=20

Thanks! Now it works like a charm (at least, for the few minutes in a loop =
device)

Great work! I'll make the ebuild in the weekend.

--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--Signature=_Fri__4_Jan_2008_16_24_51_+0100_Tqi0yiw=9873zykU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHfk/IlZGsj+xzT3kRAqRSAJ4qyfkGbWElgQCbdyQ6/xbIzKvQOgCgxZkG
7u23gWhqoGsfQYNXkkGSmxg=
=gCc4
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Jan_2008_16_24_51_+0100_Tqi0yiw=9873zykU--

--===============0270130304==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0270130304==--
