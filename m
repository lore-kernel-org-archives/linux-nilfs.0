From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs_cleanerd won't start for root filesystem
Date: Thu, 2 Aug 2012 11:23:06 +0200
Message-ID: <20120802092306.GV1478@wloczykij>
References: <20120801090028.GT1478@wloczykij>
 <1544142.eijMQvyoNB@coil>
 <20120801111921.GU1478@wloczykij>
 <20120801.203417.104482564.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6kWzDLe2BYLyVXGp"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120801.203417.104482564.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--6kWzDLe2BYLyVXGp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 01, 2012 at 08:34:17PM +0900, Ryusuke Konishi wrote:
> *snip*
>=20
> How about the following workaround?
>=20
> # ln -s /dev/<your-root-partition> /lib/udev/devices/root
> # reboot

My udev installation is missing /lib/udev/devices dir. Maybe that's also
distribution specific?

As a workaround I just modified my cleanerd starter script [1] to check
if /dev/root exists and, if it is missing, create proper /dev/root symlink
to ${TARGETDISK} before nilfs_cleanerd is started.

PS Is there some "proper" way to start nilfs_cleanerd on rootfs? Or
every way is good as far as it works fine? (my solution is missing the
gcpid=3Dfoo)

[1] http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01195.html

Piotr Szymaniak.

--6kWzDLe2BYLyVXGp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQGkb5AAoJEEMpAov1cw9lq1oP/AwSmz5exYvI2ywhzvo2jkqs
hP6VSC0Jicg0TbA1GGkYziwdamDJRTLv0EZFOqH71kUNvrVc6OhHmgDVr4YNL5rt
sy3Kz510TXLpNzq8J14YRXIfkTMKx07FEm+DMJxfGOGGraN9DBb+jIt1SAo5rLAb
CCQHDM5vYKDkrds1iOXsxBCaPVX+PtEsp7nGONu6VW3kAct6yKGK2muzxQda8xlP
Xo0WhH+VskrPI9AEybL1VP/WDKpVtuI19nKyV36z8Pj7lD7IMW2qWwASWEit02ck
vhky7kTcp/D30U1UcSm/M/Qej0xyQs6PnE9ptlWxRgJ5oCoZ6FrL0djF3cov/IG1
EI6+VnBBOu5EO9pKBXTPV1nLWpwbC0lB/0s2axuQbNvqW6E4qfYxToMGt3iRXRdB
vmS0Ob+iAJM42RgsADAQ1yhLLwke5798sTI0PH48WjbP+4E4VNf+7XcI3Hik0+W8
ms+vs5DkwTyXVTwHt4i9zine0jV2RDJwMpGApDyxHSsAta0tS/i8q2aIGZeUcuIw
nYSILWLOdIe7mlvO1YFcGHZkONIyhoLHP/sPX0kE3p7P3jC24tc36bWumiPcLUur
E28yrrbq3FRkDQkG4IlmAhZMUy19Vk1P76964jJ4RniBnlEyZwQyQZYfhrMp+5zI
LU8NEKS09pYkrOXBHVuR
=BRMZ
-----END PGP SIGNATURE-----

--6kWzDLe2BYLyVXGp--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
