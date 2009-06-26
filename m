From: Chris Samuel <chris-Ru3vu9m2XlBAfugRpC6u6w@public.gmane.org>
Subject: Re: NILFS usage on NAND and NOR flash memory
Date: Fri, 26 Jun 2009 18:01:48 +1000
Message-ID: <200906261801.48514.chris@csamuel.org>
References: <585a0ef70906231842p31130fd5h54cd124c6751ec7b@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1209748448=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <585a0ef70906231842p31130fd5h54cd124c6751ec7b-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

--===============1209748448==
Content-Type: multipart/signed;
  boundary="nextPart7167775.gfQzCG10ET";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart7167775.gfQzCG10ET
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Jun 2009 11:42:32 am Jesse Campbell wrote:

> ext3 was tried, but there were so many writes that the location of the
> journal on the SD card burned and the card became unusable.

I know that btrfs (another COW filesystem) has an SSD mode (and an SSD mode=
=20
for non-enterprise SSD's for 2.6.31), I wonder if NILFS could pick its brai=
ns=20
for these devices ?

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart7167775.gfQzCG10ET
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUASkSAbI1yjaOTJg85AQJ0QQf+OvTh83flhYvXT9b67m+IQVB52Nn6UH0P
eK74eju1WAH2UQNTvToNn54Vu3wcaiPdPkvdZJYYPEY4Hr89sOQcDKKVATyCMVFM
MN4pvKnI4S0k3LnorOt7L5ET2Tg2+m2vkgsSvPW8nUrt4bSDrdPrOORL8hyNdJcS
iMwOngvgkNhxy+dG2ij2aY2yFdsRjhLJBtNTMfP6aidXxFgYDuL68rdqAAFTPAUm
GsK3FgbZ4xfv20febOXgTBmAB8lCxhDiTIz7kEbcFgseqNP1A7z1suzW4aYLjIYf
0n5BneLK1IfyFyuvbzaoX2bhzIgbFuyS4wA/qEWQ28mT3lJ/nBsHHg==
=+6uv
-----END PGP SIGNATURE-----

--nextPart7167775.gfQzCG10ET--

--===============1209748448==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1209748448==--
