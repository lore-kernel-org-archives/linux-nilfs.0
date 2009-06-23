From: Sami Liedes <sliedes-kf+aQKke1yb1KXRcyAk9cg@public.gmane.org>
Subject: Re: "Drastic I/O error (write(2)): No space left
	on	device"
Date: Tue, 23 Jun 2009 15:56:36 +0300
Message-ID: <20090623125636.GD4836@lh.kyla.fi>
References: <4A40C0C8.90402@gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1525151521=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A40C0C8.90402-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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


--===============1525151521==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EY/WZ/HvNxOox07X"
Content-Disposition: inline


--EY/WZ/HvNxOox07X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2009 at 07:47:20AM -0400, T-Machine wrote:
> Hi; Using NILFS2 - nilfs-utils-2.0.12 / 2.0.14 - w. kernel ..6.29.5 &=20
> ..6.30 (Slackware & SlamD & BW64)...
> ... tried both, as part of the main tree, as well as modules.
> 1) Problem - example: bonnie++ "Drastic I/O error (write(2)): No space=20
> left on device"; (8G space 2G RAM)
> Same in "direct" writes - no bonnie++ etc.
> The nilfs partition simply runs out of space at ~10%.

One thing I've been wondering about is this notion that checkpoints
younger than some amount of time t are protected, no matter what. I
don't know if there's some hard design decision which forces that, but
it seems to me that often it's desirable to have checkpoints "if
possible", but not at the cost of writes failing. Of course there are
clearly also cases where the current behavior of guaranteed protection
for young check points is desirable.

Well, I'm not at all familiar with nilfs2 internals, so I hope I'm not
talking too much about issues I don't understand and stepping onto
other people's toes :-), but it seems to me it might at least be
useful to have two separate configurable periods instead of the
current protection_period, so I could configure something like

soft_protection_period=3D3600
hard_protection_period=3D600

where the fs would behave something like

- freely garbage collect cps older than soft_protection_period (just
  as AFAIK is now done to cps older than protection_period),

- never garbage collect cps younger than hard_correction period (just
  as is now done to cps younger than protection period), and

- make a best effort to not garbage collect cps younger than
  soft_protection_period but older than hard_protection period, unless
  for a reason like being low on disk space

(Generally in my current use cases I haven't been very interested in
the checkpointing features of nilfs2, so I would probably have wanted
to set something like soft_protection_period=3D3600 and
hard_protection_period=3D0 if possible.)

	Sami

--EY/WZ/HvNxOox07X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIbBAEBCAAGBQJKQNEDAAoJEKLT589SE0a0RD8P933pDmbirImuNavwKKXcZNNG
DtB34b7LQyQ3sSu+0DMr8MHou5E/q9hkf4dJHKv3ieRQ1HmpkbQ+DOGv8J4ffgLa
+wRTqMEBVRJonxJS0Q01XYg0YFNQyUuhECbXuUUvHE1kCIVEwofgWOJyrXdxm4ps
7+kGokYXxQ0UuKbueClP4znCe8++HGEXz1tjCg4brdNnPrkZHHPqe+u6v0jYkXud
+TWxqyXmzxHnWp6nHQmc639/z7shRZymxGv0G8wI3uD2rNM0jS/ebM4i0Xlh10N5
pZMjqUvaKXe4wKRYZDEkL0XR4R5Zi5VDdC9QSX/4KivL3js8FTS8qVUZxBgASCSq
rF47lvfZADR8s9iPPMFZQ4U/AmzCOlUtcTlskHvPNKWvl/PgEzLNy88AG4Fr2s0P
H1PG2imRMoAD0UjenQ1UVXdYv8pC/JuusRtVNB1Sa52XAKT2Y4gZib76RfO7+1fC
z4jnr3/UWqb/iV6oMpj13Q98M/JZkJSI4mV+jSXzV5DRvs6I986NFAyOVBO9o9sD
lxPsHCi4uOtzP32zNxID/J5toruuuGuJ/FjpgqjRQuozehcp6aKLZiCt/fV78LwS
hsTeYhhGGTt8777HrcgKjCepkB/2vV2y+O9j6a8JErKMG/mnOdDX8flWAXhz54ea
QFCfgmUBFF5IZ8RNZes=
=FaYp
-----END PGP SIGNATURE-----

--EY/WZ/HvNxOox07X--

--===============1525151521==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1525151521==--
