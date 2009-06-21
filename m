From: Sami Liedes <sliedes-kf+aQKke1yb1KXRcyAk9cg@public.gmane.org>
Subject: Re: nilfs_cleanerd on root partition
Date: Sun, 21 Jun 2009 17:02:34 +0300
Message-ID: <20090621140234.GB4836@lh.kyla.fi>
References: <20090620211939.GA5937@odysseus.gateway.2wire.net>
	<20090621.183937.71761103.ryusuke@osrg.net>
	<20090621134418.GA4836@lh.kyla.fi>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1423633157=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090621134418.GA4836-7bsdmvTMBDzHOG6cAo2yLw@public.gmane.org>
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


--===============1423633157==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 21, 2009 at 04:44:19PM +0300, Sami Liedes wrote:
> I *think* I might know what the problem is. The nilfs2-tools in Debian
> unstable is 2.0.12, while the version of nilfs2 in 2.6.30 is .14
> unless I'm mistaken.

Never mind, I just realized 2.0.12 is the latest -tools.

You say I should start the cleanerd by running

 # nilfs_cleanerd /dev/sdb1 /

However nothing in the output of `nilfs_cleanerd -h' indicates
anything of the second parameter (mount point). Looking at the source,
that's how mount.nilfs2 runs it too, and that's exactly the case where
it fails.

Running merely `nilfs_cleanerd /dev/mapper/lacie', as per the
nilfs_cleanerd -h output, succeeds (but I don't know if it does the
right thing). When I (or mount) gives the mount point as a second
parameter, it fails fairly silently. I only get this in
/var/log/daemon.log:

When started by mount.nilfs2:

------------------------------------------------------------
Jun 20 20:34:28 lh nilfs_cleanerd[27527]: start
Jun 20 20:34:28 lh nilfs_cleanerd[27527]: cannot create cleanerd on /dev/mapper/lacie
Jun 20 20:34:28 lh nilfs_cleanerd[27527]: shutdown
------------------------------------------------------------

When started manually by running `nilfs_cleanerd /dev/mapper/lacie
/media/lacie' (the mount point):

------------------------------------------------------------
Jun 21 16:12:04 lh nilfs_cleanerd[2573]: start
Jun 21 16:12:04 lh nilfs_cleanerd[2573]: cannot create cleanerd on /dev/mapper/lacie
Jun 21 16:12:04 lh nilfs_cleanerd[2573]: shutdown
------------------------------------------------------------

	Sami

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKPj16AAoJEKLT589SE0a0D5UQAI5kvgdWzqwV03IuISYt29HX
Dunlgny9/Uu3PDD6a1ETu+MSgYK16YTjs6w9noYL7RpBcdGTbfPdOj8DVNsfY7Yx
Xtkxrpp6hydzssw54D9CVDp/VobE6zd+eBVaKsPybpse7H8J+mGhCWFfmi6D4w6t
511RS2Nhoawsp9mA2Veu2eiz6n7A8IM7q7tDiSZsoKLX/a96HoFGwkDxDyr2aKet
QnH9WaKOQPS1z1RlS2aiHVVGp2+ZVCP6EoUzHUPN/atRJ1/zdvJF/QOUaZt4S/eI
0vhvaz3oe2db1sUcJBsVZQ05goz3yhrhD0fY4EIz27wdir+7ao+591iWo0+fO8ZR
Gg/w1dCGxhCo0nY2wS5hleKBuq6mRAlLN7achxOg12XU8zZcNgSMo9BHm1feb/8P
hEI7AvCG4Mdl6Csl+lTdDZM6i1pBXp9C2tFInQ7hZRQgXFE7ceVJCi0AORAni4Rl
0jTzD9dA6TH4XB75llLw7HJTEEB9tlL8BD0GB2lNBYAScal11+af8vMTAfQPXf5j
bXSj2+bK9XpfGDJmzjA3zqlUAT+7ukogyrETRS9XsAKtICGjFPgkM/dBtRlv3d9J
zt6m7S9aELhlFB9Wqv0AoEI9aRmh4HpNc13fHxyZBjLyJ+2od0vKJshCiZNfM3T8
1yEh2WRI6vI5aNKRUau0
=BAko
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--

--===============1423633157==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1423633157==--
