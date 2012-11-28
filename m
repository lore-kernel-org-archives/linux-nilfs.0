From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Wed, 28 Nov 2012 15:21:16 +0100
Message-ID: <20121128142116.GY4028@wloczykij>
References: <50A5737C.2040805@li.ru>
 <201211160313.AA04185@capsicum.lab.ntt.co.jp>
 <50A65588.3000205@li.ru>
 <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg@mail.gmail.com>
 <20121127151924.GW4028@wloczykij>
 <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB@dubeyko.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qjSZefE6w0iW6XmQ"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--qjSZefE6w0iW6XmQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27, 2012 at 08:43:01PM +0300, Vyacheslav Dubeyko wrote:
> Could you describe the path of issue reproducing? What filesystem
> operations took place near before the issue?

Reproduce: Use a computer with nilfs2? No idea... I notice this issue
=66rom time to time. I suppose it's more visible when the system is idle
and then I notice a lot of CPU load without any reason (also as I wrote
before - it stops immediately after runnig sync).


Piotr Szymaniak.
--=20
Wanted
Dead or Alive

Schr=C3=B6dinger's Cat

--qjSZefE6w0iW6XmQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQth3cAAoJEEMpAov1cw9lwsIQAMg8zFmwxFgOmWbCx3WLt80L
v5mkJkPeKTAkkW5XA2cn8C9JHnd3Qs8l2gaC2IrU+7KaMAFesccxanigdkdBDh7U
dg0cfuOXzidGzkJOl40axXXNhdjf5aBjs4BEWQZXOGKv+plTX6/pULBG6PMkUxFk
LE4xHTl/ZQ8Sq9HLbfnfxVdZn1QVw8jcb5KuTI20G6DFwWkQl8qxGFaUG0LSp6Yk
RIXGMnL2VFt2JjdjKpCI9/1LLEnFEGV7ogreu8bPFCAWAz0VLTb8bmy/sH+xZ+Ui
uZAuX1hnROJgPf+Y7ICBmK5tNnabKJDzKYgeALGtN4CaYXCYx+8rn1ZCS2VyOZoX
mWpMuzc+2rKDkQRXj3qN+jASBIoRZPl4gr2CRamM0wYqZXrOPsHum036xfdVFNJC
Nem7TrOMyeghPlXsz3DRyJAF/hts6cXbizyRj+nR794pqv/VJKeQ3eFp9l0GfWHy
CuLiH9nz8LtQRlEfXcTnyKyMcGyiPuRPaeF7QFksmSYVBNt9E9qYIAob/6cy7coC
MCSqcIuL+WUm7h2+Jq9fR0R8WjKdE9amTcfjzSNi2hplkufwp4BpctUhQGTGoAth
WEOhIiyCO90sebJKaU5+EjGJgfYUJ7aA9PinDXOeLnk/WCmWr+nJMgUbZ20z+oLT
LgL4lk+4wEy9SY0jqVEu
=JTSw
-----END PGP SIGNATURE-----

--qjSZefE6w0iW6XmQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
