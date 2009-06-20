From: Sami Liedes <sliedes-kf+aQKke1yb1KXRcyAk9cg@public.gmane.org>
Subject: Re: df seems to show wrong disk usage
Date: Sun, 21 Jun 2009 01:36:08 +0300
Message-ID: <20090620223607.GE23838@lh.kyla.fi>
References: <20090620200832.GD23838@lh.kyla.fi>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0306229862=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090620200832.GD23838-7bsdmvTMBDzHOG6cAo2yLw@public.gmane.org>
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


--===============0306229862==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JBi0ZxuS5uaEhkUZ"
Content-Disposition: inline


--JBi0ZxuS5uaEhkUZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 20, 2009 at 11:08:33PM +0300, Sami Liedes wrote:
> I've been copying data to a 700 GiB nilfs2 volume from a fast disk for
> 2.5 hours now. df -h shows there's only 37 GiB of data there:
>=20
> /dev/mapper/lacie     699G   37G  628G   6% /media/lacie
>=20
> Yet running du -csh in one big directory in /media/lacie at the same
> time shows disk usage to be 62G in that directory alone.

Looking at the data, it contains a lot of hard links, so this may be
something to do with them.

	Sami

--JBi0ZxuS5uaEhkUZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKPWRXAAoJEKLT589SE0a0AqcP/20KT5hM+42IuHf2FO3ThfHj
duJDg8ymwlaTZ0UQ1gMucPScFkqL2VT8wdD0ECSJzuAu5iFogEJSf4Ig1xk1jC7o
nkZxjCJt+Bw1ezcJfNHZK5w4S9kw0qZRFpQdXbzol8nvq044MKF5C1q64jB1Zd4i
P9fZM7Y/GGj6YfFqep9RCMZqNR1ClMuiE3teY2jFFzPTy7JdTrrSVcrw0FUPC18H
VdJ6DVXxC2AWC+ra63FossOy9AzXABU5N/+h/gusjB1c16SWfFYhQNcmiBfPrbYJ
NkpwoZdfpWzh/2F/pFBgfa4JsNuti8the6LhTfHdxjkSGT5Kyu2O/ifhCFjlymLi
QR9d6ZlWQivZLnkkqX1dEuxoSCpxBv9+37Zjm+E+BwcgCsMX1ajFaazIWuNh/HyP
QYtPRn6fQ50/CLAgS6PIpyG42ZKBj882ih5KofB/H9q7cH1k6r0fjzzEavAFE9Xf
Jfc+FoHEqebSRNTOZlL6tvlUrIEs4Ys5Z7Giiktxu5V/KlbpY4CW/lWy7K7nCrEQ
XZX43FfuDNLAdlKF4wynkgZLKkExrPhgAAsWGX8drxDCCNIvEfeKbK+AQUjF4T3y
922qdyem01QCSMjFnv+hbNPWAku0HSH+cnxTvPPgT2wTvGE8VqGmXtjnE6v6Rvws
iGFOA/3LQFgUc3qrevvj
=jWtt
-----END PGP SIGNATURE-----

--JBi0ZxuS5uaEhkUZ--

--===============0306229862==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0306229862==--
