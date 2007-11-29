From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Garbage Collection Schemes
Date: Thu, 29 Nov 2007 04:11:04 +0100
Message-ID: <20071129041104.650412ca.elentirmo.gilgalad@gmail.com>
References: <200711261512.11121.jsa@gotroot.homeip.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1654234688=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
	bh=NvzfDpQVP7Jzcr2D4hQ2MIYg+ipyPCGZZFCIG7bSitk=;
	b=kB5tfr5usMBiDllC4NQIKqp9nOCr3FpaN/20cUvF6pnwwslP+LmvxONLqNzzMyiKBDIhr7Hzkyjrn1vhPVrNtMVxesFPm82Xw0OcAjLPl1dgEPEZaljP0/gproXXMxu1dRVTPFCGek/bhESb8+Q80wy5018rJYwzlbDZoE00+cM=
In-Reply-To: <200711261512.11121.jsa-MJZuZBXGww0Jmq/UkTHWNaxOck334EZe@public.gmane.org>
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

--===============1654234688==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Thu__29_Nov_2007_04_11_04_+0100_BNVCDaHzK1jTy.01"

--Signature=_Thu__29_Nov_2007_04_11_04_+0100_BNVCDaHzK1jTy.01
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Nov 2007 15:12:10 -0800
John Andersen <jsa-MJZuZBXGww0Jmq/UkTHWNaxOck334EZe@public.gmane.org> wrote:

> I am new to NILFS, so bear with me.
>=20
> I would like to ask, (without reading the entire archive of messages) if
> any thought to other garbage collection schemes has been contemplated.
>=20
> For instance: This file system looks like it might be very useful for=20
> certain types of environments where N sequential revisions of documents
> must be maintained, regardless of the  age or how any given document rela=
tes
> to other documents.
>=20
> Checkpoints do not seem to do this.
>=20
> I would like to see garbage collection options that allow (for example)
> 10 copies retained (of EACH file), each bearing different dates. =20
>=20
> Garbage collection would erase the 11th (oldest copy) if, (and only if) t=
he=20
> other 10 all had different dates.  This prevents the situation where one =
user=20
> (or rogue process) re-saving a document 15 times a day wipes out all prio=
r=20
> copies.
>=20
> An option might be garbage collection not based on a NUMBER of iterations
> but rather a period of time (3 years, 7 years, etc, while still purging s=
ame=20
> date (or same hour, minute, etc) copies.
>=20

AFAIK there is a protection interval in which GC wont clean up a checkpoint=
. (maybe i remember badly... and some other LFS fs was that...)

> This type of garbage collection is found almost nowhere, and this
> file system seems to be the closest possible candidate to do this.
>=20
> There are applications, where a consistent representation of all=20
> files at a specific point in time (snapshot or checkpoint) is LESS
> important than the ability to roll back individual documents to=20
> a number of prior iterations or a number of years.
>=20
> Legal documents, financial records, code version archiving, etc, all
> have these requirements.
>=20
>=20
> --=20
> __________________________
> John Andersen=09
> Screenio.com
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users

BTW: does/will nilfs support named snapshots?

Best Regards: Gergely G=C3=A1bor

--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--Signature=_Thu__29_Nov_2007_04_11_04_+0100_BNVCDaHzK1jTy.01
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHTi3IlZGsj+xzT3kRAvO/AKCS31/zog8lz4n1SxgohBi4bMzBXQCg1N6T
xDVEfS0eaJdkfQwKlCrOeEE=
=b2+B
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2007_04_11_04_+0100_BNVCDaHzK1jTy.01--

--===============1654234688==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1654234688==--
