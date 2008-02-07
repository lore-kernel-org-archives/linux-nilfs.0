From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: memory leak?
Date: Thu, 7 Feb 2008 12:44:58 +0100
Message-ID: <20080207124458.03a6cedf@vosztok>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1931756082=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:x-mailer:mime-version:content-type;
	bh=JksCOFvNsl+53AfiSIutLN+ixVWE0t27j78bppc6eZU=;
	b=t8OMjGaM9UKsqf0vuTjUZZxwMyUX2MDylQzfyfM3fiC8EWXNSTZad/3DxM396lc1Taw/4+BidxCS5KdfL3xkMr9BNyXMuoqbvMFVjvCHYOY8FaQSLvEolYMbzw9DM5rmMamkn6zfIhi2Cz8iFOQWOO3WlLy+jiK1WUi1h8HqI0s=
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--===============1931756082==
Content-Type: multipart/signed; boundary="Sig_/sWOWp2fd+VB7zqIifS_/Dd=";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/sWOWp2fd+VB7zqIifS_/Dd=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello!

As I stated in my previous letter, something eats up my ram. After a few ho=
urs of usage of nilfs without the GC (mount -i) the memory consumption has =
significantly raised (from ~33 megs to ~465megs). I ran rtorrent (as previo=
usly that program triggered a bug). this amount slowly added up, it took ~2=
.5 hours, and if it continued in this rate, soon the computer would become =
unusable. I'd be more happy if the GC caused the leak, as that runs in user=
space and can be debugged more easily even by me. Previously i didn't notic=
e such behaviour, so this might be related to the patch Ryusuke sent meg on=
 the 5th of February.

Best Regards,
--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

* random fortune:
My sister opened a computer store in Hawaii.  She sells C shells down=20
by the seashore.

--Sig_/sWOWp2fd+VB7zqIifS_/Dd=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHqu89lZGsj+xzT3kRAt2wAJ9ZdJ3K2mWRTE9Hl48kTfVto1mWSgCfVMLX
zW5J1oEEIZjUYfY61BFdmUA=
=A4Bv
-----END PGP SIGNATURE-----

--Sig_/sWOWp2fd+VB7zqIifS_/Dd=--

--===============1931756082==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1931756082==--
