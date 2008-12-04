From: Chris Samuel <chris-Ru3vu9m2XlBAfugRpC6u6w@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Thu, 4 Dec 2008 19:30:59 +1100
Message-ID: <200812041931.02528.chris@csamuel.org>
References: <20081203064930.B64F0829D@blinkenlights.ch>
	<20081203162628.B82C3829D@blinkenlights.ch>
	<20081204.170654.88475919.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1839762514=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081204.170654.88475919.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

--===============1839762514==
Content-Type: multipart/signed;
  boundary="nextPart2943657.7Em4O624Su";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2943657.7Em4O624Su
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thu, 4 Dec 2008 7:06:54 pm Ryusuke Konishi wrote:

> This never occurs if the block device is
> supporting 'write barrier' feature properly.
>
> Could you tell me the kernel version that you are using?
>
> I feel that an additional disk flush operation may be
> needed for older kernels or such devices. (Of course,
> first priority should be on making fsck.)

It's worth remembering that (unless something has changed recently) filesys=
tems=20
on a logical volume using LVM won't have barriers either.

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart2943657.7Em4O624Su
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASTeVRo1yjaOTJg85AQJrmQf/Vle6/1159Qxp5wR6dNBhCPYDCuQxLkVs
e/M2N1lTZZSpePuoFLMj8ILOlF+YMJh3FZVmcT8LosroeuFSPNCuzKBVqs0uS5UH
ujX+B5SAQNszPLL+Dr4wZ+uqb/TCdT6wbnW4V9ImXpT4ayGYKF3RsMOKJnfgvGNN
ojavjbY9r72AHFNZv1+fZ32saNgMW5dATBTk8pROY26X+Yx1hs9e0jSSPqQ/s1Pt
qyWZNVboNswZ2mC3Yki1ObAt6fuvMqgs0uVJ5hUJfkszdGSxz25PNK5Vg+LrfMVA
l9TFqYNPNyDQ7Extu2JRcmbSnqmeorZD5drEj1D9877JSg/2z2nTYg==
=Aomn
-----END PGP SIGNATURE-----

--nextPart2943657.7Em4O624Su--

--===============1839762514==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1839762514==--
