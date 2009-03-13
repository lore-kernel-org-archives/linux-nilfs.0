From: Leon Weber <leon-UvuJAy62EvlM7kwft8N7nw@public.gmane.org>
Subject: Re: Dump tools for checkpoints
Date: Fri, 13 Mar 2009 17:26:09 +0100
Message-ID: <20090313162609.GD7494@zaphod.leonweber.de>
References: <2883.84.133.202.72.1235869032.squirrel@ssl.its-beck.de>
	<20090308.143916.113539820.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0265724171=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090308.143916.113539820.ryusuke-sG5X7nlA6pw@public.gmane.org>
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


--===============0265724171==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.03.2009 14:39:16, Ryusuke Konishi wrote:
> I've moved the replication feature to the top of todo list in our web
> site ;)

Is replication really a feature that a file system should implement? I
think it should be implemented one layer below the fs. If one needs a
replicated file system, there are things like drbd (distributed
replicated block device). Of course, the file system should support being
on a replicated device, though I don't really see a need to implement
this on the fs layer, or am I missing anything?

Leon

--=20
Leon Weber, leon-UvuJAy62EvlM7kwft8N7nw@public.gmane.org 0x8E04D7FC
jabber: leon-2ASvDZBniIemthueiVhc4g@public.gmane.org (icq: 261067046)
--
Geizige Menschen sind unangenehme Zeitgenossen - aber angenehme Vorfahren.

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkm6iSEACgkQmxj00I4E1/yhbwCfQ1Xxf70v6NWaOGrQSNfVOPXz
LloAoJf8URjbw8nzYG4+tWt1scEvdDV1
=6Z5A
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--

--===============0265724171==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0265724171==--
