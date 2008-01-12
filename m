From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs ebuilds for gentoo users
Date: Sat, 12 Jan 2008 22:12:38 +0100
Message-ID: <20080112221238.5d4a1410@vosztok>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0869939960=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:x-mailer:mime-version:content-type;
	bh=D8jI47WcNxGi55OmuwdgDd4U8MB4epscMPdZtSFyj+g=;
	b=lWKHS2UuKxidkTjrY7wdLUtDds/W4krDZX1cRXn6sMmFmVcPkSginrtUsobHNbGKSdgxft6o+6os5XTQlzAah2ADbkJAD6/lX19PZHRxnkbiXvMnZ5Mq7zn7j6RJxt3g4w9/NkmrFLGBDShnxME63o/miN8pxuoFhnOgzl8LmFw=
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

--===============0869939960==
Content-Type: multipart/signed; boundary="Sig_//nChbIbVzpBFvV=jYpNkdy=";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_//nChbIbVzpBFvV=jYpNkdy=
Content-Type: multipart/mixed; boundary="MP_/8xd1xfkA/=d4GEpDeHKEbk_"

--MP_/8xd1xfkA/=d4GEpDeHKEbk_
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello!

As promised on the week, I have made some ebuilds of nilfs and the utils, u=
sable with the gentoo linux distribution. Please try them if using gentoo a=
nd interrested in nilfs, all feedback is welcomed. I attach an archive of t=
he files necessary, and here is the mercurial repository of my private over=
lay (sorry, couldn't get rewrite working):

http://freeshells.ch/~ggergely/cgi-bin/hgwebdir.cgi/portage-ggergely-overla=
y/

Note: i do not support any magical overlay management tools. simply clone i=
t, and update sometimes (half a year or so...), and append it to PORTDIR_OV=
ERLAY.To get further info on setting up an overlay, please consult the manu=
als. (look for PORTDIR_OVERLAY)

the link to the archive containing the appropriate files (extract _in_ an o=
verlay):=20
http://freeshells.ch/~ggergely/nilfs-ebuilds.tar.bz2

I also attach the archive, as it is only 4k big.

Use, and enjoy it, maybe the archive could be linked from the site, to have=
 some more people give nilfs a chance!

I'll make some basic manpages in the future. Oh, and please consider the pa=
tch I made to utils, (trivial one) as it enables building inside a sandbox =
(needed for packaging).

Should the final version be released, I will send a bugreport to gentoo, to=
 request the ebuilds to be included in portage.

Cheers: G=C3=A1bor Gergely
--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

* random fortune:
You have a deep appreciation of the arts and music.

--MP_/8xd1xfkA/=d4GEpDeHKEbk_
Content-Type: application/x-bzip; name=nilfs-ebuilds.tar.bz2
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=nilfs-ebuilds.tar.bz2

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
JOlBxr1ONZ9Dk5xQQPqLuSKcKEgY2j27AA==

--MP_/8xd1xfkA/=d4GEpDeHKEbk_--

--Sig_//nChbIbVzpBFvV=jYpNkdy=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHiS1QlZGsj+xzT3kRApA7AKCZ0+gy8McBaPu+k0Iw8coOhwK5wACeKs7v
lXrtyF7sYjU8K5z/WePf3A0=
=6flx
-----END PGP SIGNATURE-----

--Sig_//nChbIbVzpBFvV=jYpNkdy=--

--===============0869939960==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0869939960==--
