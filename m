From: Chris Samuel <chris-Ru3vu9m2XlBAfugRpC6u6w@public.gmane.org>
Subject: Re: Using nilfs to increase performance of NAND/SSD
	flash devices.
Date: Mon, 4 Feb 2008 21:00:36 +1100
Message-ID: <200802042100.36826.chris@csamuel.org>
References: <30c6373b0802011231t75a8a00djab3c82b4de3fa928@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1986369227=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <30c6373b0802011231t75a8a00djab3c82b4de3fa928-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

--===============1986369227==
Content-Type: multipart/signed; boundary="nextPart2675926.fUzZzeyQbi";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2675926.fUzZzeyQbi
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sat, 2 Feb 2008, Kevin Burton wrote:

> I tested this theory by comparing nilfs2 to XFS on the mtron with a
> sysbenchm random write to test.=C2=A0 Sure enough nilfs2 beat out XFS by
> 8.5x and wrote at about 50MB/s which is amazingly impressive.

Out of interest, have you considered comparing it to logfs on the same=20
device too ?

cheers!
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart2675926.fUzZzeyQbi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUAR6biRI1yjaOTJg85AQL3Fwf6A34ptitEXS5GuYMiDjxpVUwaVyu+/BmR
F/mjamvS47YXMjh4ZZlBmmrEcyzXJ5cfagjzvPJ/0FLSyaJfXHGq4IkXk0T02aQP
lvzSq0AOGAmKOoKtDz4RyKaFAp7oQBPQeHaNuJxaQk0res2Z++/z0RHaKxGZLCgs
4cFFZrwoC7G2/Eqqzg4JzQQyDkExVdnH5KjwH3MwvodJdvHWAdpUagVtpYsTLqhn
4byNkrIas4W9voZdQuHYK0Ix9e9DS/DsqdXi6zN0gZNFN2TOq7Bn9+D2DWYu0WV3
/Zm4ZjjfxlhzjMLWOH8jUcDn3DL9NIry/+Vc/IxfuSuqFX4zqHUL7A==
=vHM1
-----END PGP SIGNATURE-----

--nextPart2675926.fUzZzeyQbi--

--===============1986369227==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1986369227==--
