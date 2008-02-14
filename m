From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: some notes on a memory leak
Date: Thu, 14 Feb 2008 01:02:58 +0100
Message-ID: <20080214010258.76494d68@vosztok>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0860451948=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:x-mailer:mime-version:content-type;
	bh=gfg6jp00AflyXtk0/JxfHWf8c+ExQI3slY/OV4DHD+0=;
	b=B5CDtssW2uXp9dh0oEQQ6ezO4MEvD2px1F5HTvH/Gh5M0TdKgsIK+DQgi+w6q9+TwcA/WuyS1pE1X6UVuLgP7u0BxqXClVQde3gaW8Junm+60qDWLUI133/2S1ux/b9LZJOjN+leGJp8khkcH5oHfVMApqNpgTskiDJeZzu+488=
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

--===============0860451948==
Content-Type: multipart/signed; boundary="Sig_/5n4rdqKvNHo4LPZtVJVniFO";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/5n4rdqKvNHo4LPZtVJVniFO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello Ryusuke, and other nilfs developers, and users!

I have left my computer working, testing nilfs. I have found that after a l=
og period of time, most of the memory in the computer vas allocated as cach=
e (according to vmstat) and even aftel killing all processes that held file=
s open, the amount (~430 megabytes) did not decrease significantly. I have =
unmounted the filesystem, and most cache was freed up, and after remounting=
 nilfs, the system was fast as lightning again (the module was not needed t=
o be removed to reclaim the memory). This leads to the assumption, that som=
e data is left cached, even when not in use. To reproduce this behaviour, I=
 simply started "vmstat 1", and rtorrent, started a download, and watched t=
he cache consumption climb. after exiting rtorrent, most of the cache is no=
t reclaimed, not even after a long period of time. (i understand, that leav=
ing blocks in the cache is preferable for a log structured fs, as that redu=
ces seeks necessary for reading, but possibly some aging mechanism, and/or =
a maximum cache size option would be a good idea to implement in the future=
, if not yet done)

Apart from this minor issue, the fs is working fine. i feel that (but this =
is very subjective, only based on my perception) the current rate of this l=
eakage is far smaller that the rate i experienced with the patched version =
of testing-8. (than the system went unusable after a few minutes, as all me=
m was consumed, not it took more than 4 hours, as i wrote a letter with fai=
rly much free mem before leaving home with the machine running.)

Sorry for flooding the mail list with my self-contradictory status reports.

Please tell me, where can i read about the architecture of nilfs2 in greate=
r detail, other than the code? (i'm willing to understand the code as well,=
 but i'd need some guidance, where to start. I'd be the most happy if i cou=
ld provide some more useful help rather than constant "complaining") has ma=
ny things changed since nilfs1? (i have found papers about that on the proj=
ect homepage)

Yours sincerely: Gergely G=C3=A1bor
--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

* random fortune:
Rome wasn't burnt in a day.

--Sig_/5n4rdqKvNHo4LPZtVJVniFO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHs4U1lZGsj+xzT3kRAhsgAJ9rVUvzcTW3l3H4DTg+phDXY1jWRwCgnsmL
YhWtcZi3tYla/IdR29Wcifs=
=nW+7
-----END PGP SIGNATURE-----

--Sig_/5n4rdqKvNHo4LPZtVJVniFO--

--===============0860451948==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0860451948==--
