From: Sami Liedes <sliedes-kf+aQKke1yb1KXRcyAk9cg@public.gmane.org>
Subject: Re: nilfs_cleanerd on root partition
Date: Sun, 21 Jun 2009 17:37:08 +0300
Message-ID: <20090621143708.GC4836@lh.kyla.fi>
References: <20090620211939.GA5937@odysseus.gateway.2wire.net>
	<20090621.183937.71761103.ryusuke@osrg.net>
	<20090621134418.GA4836@lh.kyla.fi>
	<20090621140234.GB4836@lh.kyla.fi>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0039075571=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090621140234.GB4836-7bsdmvTMBDzHOG6cAo2yLw@public.gmane.org>
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


--===============0039075571==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Content-Disposition: inline


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 21, 2009 at 05:02:34PM +0300, Sami Liedes wrote:
> You say I should start the cleanerd by running
>=20
>  # nilfs_cleanerd /dev/sdb1 /
>=20
> However nothing in the output of `nilfs_cleanerd -h' indicates
> anything of the second parameter (mount point). Looking at the source,
> that's how mount.nilfs2 runs it too, and that's exactly the case where
> it fails.

OK, I debugged a bit and figured out what the real problem is. It's
the fact that nilfs_find_fs() is too strict about the mount points
being the same. Namely, it considers /media/lacie and /media/lacie/ to
be different mount points (it merely does a strcmp()).

/proc/mounts always uses the former syntax, so if the mount command is
something like `mount /dev/mapper/lacie /media/lacie/ -t nilfs2', the
cleanerd is not started because mount passes "/media/lacie/" as the
mount point, and nilfs_find_fs() expects it to not have the last
slash.

	Sami

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKPkWUAAoJEKLT589SE0a0QJUP/2scKk7eHzHmYPmjdLXfhTWG
ew3ChKuCT10aQhic+Mds+c0gJRwQYryAlHZH1BZM2C/JjAWz/SZFW6XIM0ASVrI8
rrGLuczBNW1D4NqeAKtm76N91yLCZe6aQe/5Oh0UiQ8la1gJ6mkn1o/UyAr4U4bt
DdDNuZCn6DoFIm8DszPr6GG2qpYMt/32k51bUGC1T4bmNUdmsMu3rHKrnZ4FIeh2
AWlc5WrDADLGl36I4PHXOBj6pGju/YBrJu7jbgjOll3R72yTM9RzORV255OX8zEX
UfsMXoEeUO5PUX6Q+5f3v2UTJILXlyoYZVDuW/LlrUlduHBjA1AzN1ZsnbuPaF9V
2CAh4yuHfEntmWjsZn62AWcVJp4PdiLcyiDzxO+BaAq5mjPcvbF9i4Z0U8nUZd8C
IKbLlP/yS+BUti2y/Qh1PPc7tg2LTmOUdcwDMvQmImmIX3rJhU6ezHoWMg7ub+fQ
9c39XcJU04tfup8kOaUv034DlK2OuMtmoVYhHEzxI9Vr5NvvOCPe6z2wTufKrFyl
kib2CwuP01aI4xtpR/6zkrWAeZvYaZOwj/+/Ntz4l4dfgj5y/napUrUOs00aWBGE
S3n062jiZTphmKe7zij6U5iPCJDTZtXS3MP84GeqvoNtnlIL5vmV9kx5vzJgyRCr
sx06VHLCi6bpqeynWdEb
=NfpT
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--

--===============0039075571==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0039075571==--
