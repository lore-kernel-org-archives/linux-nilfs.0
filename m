From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Sun, 14 Oct 2012 22:47:40 +0200
Message-ID: <20121014204740.GL27763@wloczykij>
References: <20121010220331.GA27763@wloczykij>
 <1349938258.1908.3.camel@slavad-ubuntu>
 <20121011092300.GB27763@wloczykij>
 <1349950320.1908.11.camel@slavad-ubuntu>
 <20121011180332.GE27763@wloczykij>
 <1350025832.2026.43.camel@slavad-ubuntu>
 <20121012103119.GF27763@wloczykij>
 <1350040053.2026.47.camel@slavad-ubuntu>
 <20121012114043.GG27763@wloczykij>
 <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC@dubeyko.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="L5nTHegdhbHhzmSD"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--L5nTHegdhbHhzmSD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 14, 2012 at 06:55:59PM +0400, Vyacheslav Dubeyko wrote:
> So, it is clear that #359 segment is empty. Moreover, #357 segment doesn'=
t contain ifile block with blkoff =3D 2 as I can see from dumpseg output. C=
urrently, I know that #358 segment contains empty ifile block with blkoff =
=3D 2. It needs to find segment which contains not empty block of ifile for=
 blkoff =3D 2. Could you share dumpseg output of all previous segments (for=
 #358)?

I suppose that the dump was to big for the list, but I hope you guys got
it.

Piotr Szymaniak.
--=20
Gdybym  opowiadal  bajke,  powiedzialbym,  ze Andy walczyl zaciekle, az
zostawiono  go  w  spokoju.  Chcialbym  to  powiedziec,  ale  nie moge.
Wiezienie nie ma nic wspolnego z bajka, jest az nazbyt realne.
  -- Stephen King, "Rita Hayworth and Shawshank Redemption"

--L5nTHegdhbHhzmSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQeyTrAAoJEEMpAov1cw9l9fEP/162B2EQlLkp1tWPVok+pW63
c6BDd2PZh3jjFECtcCxLMeinMmPtyeBLdNgI0K1u5gKglcJcUVEuSnsJuIsQfQ4+
YsXXAwcahjkKeGvh7iHCU5qxTk3SjwWVs9Tp31bka/6T6zmbzVtNJolgQgU5mE67
x8yeAPiGADrNML8vP5TxjeZsJ711AX9IGuCJD3uUyeeqn93WEMvcMN5bq2ZFcR34
YByKMuW8iY7UMUiecPvDLq6YVCA/SJP1VzwqUe71t8YskCizPE13e8FJVlakCGEH
euGp9GhzQg1jZPVCSSeF4x0ZrZv+oF6CKxcQiWvro7qIPJsswxjyC+hdYvNLhqFE
sRR1+CwObOpLA0Azj/JdFSSJJ25eoFRFjBLKHgwkTFR6x4IULZVBrrSsAXFzgTuf
+jL4KiCHscFkQjBBsP5VkeavW61+GhfbHssmxY3A+zpJPdXe+uo/xFlBqRsqbFTE
MokzGI7adX0mz7CodwboeCwPH/097Jlu0LatgzF/vTdUuuUnkGao2bTrA+eSa0Tf
nP6iV00wfg2xvS5OhWsZeAiMYUaVn/1nQVTOU0T++kxthbrEA8CtFsRxp8o5UoN+
jxHlKMOLs3Z8qIVDwMObgDBYkZZUfRX77AJUPcMXGqF/AQsHyocisZaDfZ689wHq
sUUouAo6oWPrRRbkzTpx
=tXUo
-----END PGP SIGNATURE-----

--L5nTHegdhbHhzmSD--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
