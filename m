From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: reserved space
Date: Tue, 15 Jan 2008 19:18:28 +0100
Message-ID: <20080115191828.0a47569d@enyergija>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2132152279=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:x-mailer:mime-version:content-type;
	bh=Ok/WhUGl9SqJrIS5FBbNtfHjEbQYPdDLvL+XotUJwSs=;
	b=nqwLwcSYri67Bzf+qcNu12uHHdZaqIy5HvaO60W76jDPfJQIsF3AxsiygmpMs2vRwqZ18XM0GKOY8r+0ahMB9QJ2uKz2uS36v96s1jYS9AhgZ32amp3nuwoDRwte1pp6K0oKwn06qrVK9XhXD3N3I2DDpMa/MYiDU1qOcNGJQyU=
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

--===============2132152279==
Content-Type: multipart/signed; boundary="Sig_/e3QVVrcDWXoAEb5cdReEaKW";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/e3QVVrcDWXoAEb5cdReEaKW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello!

i'm migrating to nilfs on one of my machjines right now, and when I was cre=
ating the filesystem, i met an option of mkfs.nilfs, "-m" that controls the=
 reserved segment percentage. can this amount be adjusted later? this space=
 is virtually lost, as this is kept always free for the GC to be able to wo=
rk?

My 2nd question is: what is /usr/bin/lssu supposewd to do?

Thanks: G=C3=A1bor Gergely
--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

 * random fortune:
If he should ever change his faith, it'll be because he no longer thinks
he's God.

--Sig_/e3QVVrcDWXoAEb5cdReEaKW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHjPj6lZGsj+xzT3kRAsELAKClAIQIsjvfbXFSmEJaHCsMl2iUPgCfeXdm
dM2ZW6aAjlIAZyzeua9XBkg=
=H4PM
-----END PGP SIGNATURE-----

--Sig_/e3QVVrcDWXoAEb5cdReEaKW--

--===============2132152279==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============2132152279==--
