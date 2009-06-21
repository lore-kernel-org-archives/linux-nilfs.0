From: Sami Liedes <sliedes-kf+aQKke1yb1KXRcyAk9cg@public.gmane.org>
Subject: Re: nilfs_cleanerd on root partition
Date: Sun, 21 Jun 2009 16:44:19 +0300
Message-ID: <20090621134418.GA4836@lh.kyla.fi>
References: <20090620211939.GA5937@odysseus.gateway.2wire.net>
	<20090621.183937.71761103.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1082269936=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090621.183937.71761103.ryusuke-sG5X7nlA6pw@public.gmane.org>
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


--===============1082269936==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 21, 2009 at 06:39:37PM +0900, Ryusuke Konishi wrote:
> nilfs_cleanerd is invoked when the partition is mounted, but sleeps if
> no reclaimable data exists.
>=20
> Is there nilfs_cleanerd process ?
>=20
>  $ ps aux | grep nilfs_cleanerd
[...]
> If the cleanerd did not exist, you can invoke it by hand.
>=20
>  # nilfs_cleanerd /dev/sdb1 /

Hmm, for me, nilfs_cleanerd does not start with such a command (either
=66rom mount or by hand).

I *think* I might know what the problem is. The nilfs2-tools in Debian
unstable is 2.0.12, while the version of nilfs2 in 2.6.30 is .14
unless I'm mistaken.

In any case I'd be very happy to get some error messages visible
somewhere; mount failed silently to start nilfs_cleanerd, even
starting nilfs_cleanerd by hand doesn't output anything to indicate it
did not succeed, and there's nothing in dmesg about that either. The
only indication there's something wrong, if you know to look, is the
message

   "cannot create cleanerd on /dev/mapper/lacie"

in /var/log/daemon.log and the fact that cleanerd is not running.

	Sami

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKPjkyAAoJEKLT589SE0a0cnoP/2wHUOzjNDcmJ34Pccgj/KVX
Na+XDnT0195k4KSRXlcV5ulnkFmCuoRRV6ny6PjP/9ZaQtlv/DG0ngsNOW7GOtan
er2TdhZzbHOw/d4FOTe+wAsFVIZrRphUkC7RWJnwf9WfXV25jDo2cU9fEAcs3/+F
ERJkCQDG1xCl5Wi2yUX2ZEvxSmpyBqt9ITWLXe422wwTRhNwFwumGHgsFzGr48Hg
XxRYpxNr09N/4UCi53FiY8IWVGPtucmF/Qy3IMCaKVn6SEWUpAtC9JWtJ5kTeIv+
dV5XmZ6+7j/LXJ4L+Rqy99bFElHW8iKad90oMJ9OG2qn445cPjEyIkUXm9oO+afq
mwpKTBvIuP8fP+KeFjtsaNFztoFMKNQjrHQp436wCgqT+DBH0MZLRL1pXXHgMolR
Tf3ewkxE5bFeAeGZDRDUQBuIJmfdb9GsikWgzF+dzYtV/2rkDdq7O9nagRhL/tjK
NrCByqRu3D6UMsNlgh02FroVv9Q9aEklmPgM5MoWUFrN4RyKoUhtF8kPIJGK33fS
VDkM1ADv9R5uCwuqyRQA16wjR7hYMxld9jhGokazzfFGTIwQnmYmlXMXM9y2C3Su
rnfYiCVQ+MWqaZY1di3bYrXIGSrqjxlCyv5GY1jhgr6sa7gT7DwbMmJzO1rZy6Pc
z/1D4Wi8suuFBfirXNMs
=Dgwy
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--

--===============1082269936==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1082269936==--
