From: Chris Samuel <chris-Ru3vu9m2XlBAfugRpC6u6w@public.gmane.org>
Subject: Re: proper name for userspace package?
Date: Wed, 5 Aug 2009 21:32:45 +1000
Message-ID: <200908052132.45489.chris@csamuel.org>
References: <4A71CA72.8080106@redhat.com>
	<20090804.041006.12536354.ryusuke@osrg.net>
	<4A7742D6.9050405@debian.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1251379956=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A7742D6.9050405-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
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

--===============1251379956==
Content-Type: multipart/signed;
  boundary="nextPart1829009.Fz2tsylGDT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1829009.Fz2tsylGDT
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, 4 Aug 2009 06:04:38 am Daniel Baumann wrote:

> i heard, that ocfs2 is called ocfs2 because ocfs1 was oracle intern
> only. not sure if that's true though.

No, it's not. :-)   OCFS2 is a POSIX compliant filesystem, OCFS isn't.

http://oss.oracle.com/projects/ocfs/

# Note: OCFS is not intended to be a POSIX compliant file system, there are=
 no
# guarantees that timestamp updates or inode changes are similar in behavio=
ur
# as other filesystems on the same platform or especially on different
# operating systems. Version 1 is specifically designed for Oracle Database
# files, create, move, delete and backup. It is well possible that certain =
OS
# commands will show different results, this is not considered a malfunction
# inside ocfs. We try when possible and where possible to stick to standard
# behaviour with error messages, e.g. ENOSPACE, etc. However, at the minimu=
m,
# what is required for Oracle to work properly is implemented, anything more
# is not a guarantee.

=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1829009.Fz2tsylGDT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUASnlt3Y1yjaOTJg85AQK1tAf+PXd4xyl9e5iQAhlA/sUlhDdvwMWezIJ1
u9GsQlfrWv5sCZF7sgySBndVbpmeTXYR56s6uzPzkXTj4LC4Z64zYOHW9/jduPEJ
9w0dCEmmEwsjna8E6QDtewO9xTZJK2aXAKYx3W1EJsZxVtY8dLLiGr/FK5SNVr7x
O6ri2jppvfgzUtCqAvll8vx4GOqwf8F+OKkdGWijEH4YumOzBFALFl/3QjRVrtPM
oDiOLDG/GcZ3cP49i/cCvNjPGPz8n1stkXSspC90WOlgDBck16BlSvfebCgk2wVV
xdMHD/Fg+j+PxNVkUN/GXfx41Vc7TusuEC2zcDZuFZH2c6NSzWx76Q==
=vtGr
-----END PGP SIGNATURE-----

--nextPart1829009.Fz2tsylGDT--

--===============1251379956==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1251379956==--
