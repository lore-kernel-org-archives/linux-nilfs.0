From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Deadlocks! help, please!
Date: Tue, 5 Feb 2008 13:18:15 +0100
Message-ID: <20080205131815.39f7b0e7@enyergija>
References: <20080121.140129.01311807.ryusuke@osrg.net>
	<20080122000052.215084db@vosztok>
	<1200970920.2844.59.camel@localhost.localdomain>
	<20080205.182829.44149266.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1416924197=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
	bh=watbCFKyBU/pX71tCHJMjT4WTlnIm9YgSlXviGwtEjU=;
	b=mLfRUUWgBB3oSTsrRIAyJ7YY/hBrCFb0xVWhrfZIuLEGI8wK266PtrlmN0Ri4PAfsObAnzTUZS9A7BSjeIchOQW1cbM5tMW3cgMO5gzjSTsn/F+UbGfR7gLi9iCpv925XL/OFGhS5I3Ri5iRJkSe7/WLwOWHLtXujhsrhCfAve8=
In-Reply-To: <20080205.182829.44149266.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

--===============1416924197==
Content-Type: multipart/signed; boundary="Sig_/kgj0HH44uw4R_B+WiLt6bR=";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/kgj0HH44uw4R_B+WiLt6bR=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Feb 2008 18:28:29 +0900 (JST)
Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

Hello Ryusuke

> Today I could reproduce the hang problem, and succeeded in capturing
> a stack trace of the suspended cleaner process.
>=20
> After short analysis, a suspicious bug was found in a write routine
> of NILFS.  It seems to be the root cause of this problem.
>=20
> I will attach a revised patch below.
> Could you try the patch?

This is great news, but I cannot try it until tomorrow, as 1 hour before (w=
hat irony!) my nilfs fs has completely died. (i was sleeping, woke up, trie=
d to check my mail, and nilfs forze i restarted several times, but i couldn=
't do anything, as soon as i wanted to do anything on the disk, (even lscp!=
) the fs froze. tomorrow i'll restore my backups (to a freshly patched nilf=
s), and will try the new patch.

Thanks for Your work,
--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

 * random fortune:
To invent, you need a good imagination and a pile of junk.
		-- Thomas Edison

--Sig_/kgj0HH44uw4R_B+WiLt6bR=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHqFQLlZGsj+xzT3kRAvdwAKDCJvCgHeSkelbT8sCbpyiZtpM8WQCdGx/l
ktTRerUQPLVf3xGcA4PkCRA=
=DJXC
-----END PGP SIGNATURE-----

--Sig_/kgj0HH44uw4R_B+WiLt6bR=--

--===============1416924197==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1416924197==--
