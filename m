From: Sami Liedes <sliedes-kf+aQKke1yb1KXRcyAk9cg@public.gmane.org>
Subject: df seems to show wrong disk usage
Date: Sat, 20 Jun 2009 23:08:33 +0300
Message-ID: <20090620200832.GD23838@lh.kyla.fi>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1971334928=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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


--===============1971334928==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Content-Disposition: inline


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I've been copying data to a 700 GiB nilfs2 volume from a fast disk for
2.5 hours now. df -h shows there's only 37 GiB of data there:

/dev/mapper/lacie     699G   37G  628G   6% /media/lacie

Yet running du -csh in one big directory in /media/lacie at the same
time shows disk usage to be 62G in that directory alone.

Are the df figures somehow inaccurate for nilfs2 volumes?

I'm using the version of nilfs2 in stock 2.6.30 kernel.

	Sami

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKPUHAAAoJEKLT589SE0a0bloP+gOw1EJOE+4cB1S4dPog+WMf
fdIKoICVqkTQxXw7Bt+kOhPbS3XnA4HkBv2syn0Vovxi8OqEpi1hCMtP5EtTmF6x
AHVXlDUjigQlrNPOkGmAaW/0WVmkWa7qTxiLlpg5t9WXsEz9BDluQlgNi2VZXhKU
uifTfy6wlgS30N5XwX4D72fmHfsAtmgc6E2F5kvGgdPGOJk7fmKHCGqomfRkx1Ns
LQRS+dcj3fwPVM6YiIdoUfEvy11ZCqJnXSXo5fccv1S2tltwS8jVPFPLdoameqkm
2zX+j1FuuyZ884j1S5xgueYVtOqfFE7FYjCUKCd5TikP1GZ+cElION3T1kpft+jg
sTZtsIdTZ7KN1EdB+lKjOsb0JG87rzzNI5JfPCZPnoF3z7b8LOScxb6yXUkl9Z2y
5OrrFCa1PJ9BSOr04buSIu4cGdNFUyVXQ6nDCwnzOkndPh1FPqVXwQm5bxXdJy3I
QF9KqP22z35sg673Hutjb7dMEv0oDOUDciOqJjJyr0IEVVqcJVLUKOkL9vrVzfF8
teuzLmK/BUjL0CL09UF0rKP1ZzWvP1LqoQjniRqU2aC1tpGB0O1SqRjph5qhu+4n
pKUW4bF7Cs8Td7C1Wjt3ZS8kMbCrye1GHLnqxyEBOhZ2YCyIq0956cgeoX3xGvRD
BsRsSc1O4HGcwU2RRZGh
=bqgA
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--

--===============1971334928==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1971334928==--
