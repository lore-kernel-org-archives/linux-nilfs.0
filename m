From: Dmitry Smirnov <onlyjob-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Re: few patches from Debian
Date: Sat, 19 Apr 2014 21:17:19 +1000
Message-ID: <4645877.yriC0M9ozk@debstor>
References: <2256155.lyPQvkPv8r@debstor> <6284364.q7fsBQ3iYY@debstor> <20140419.195816.57462893.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7222751.HgFyufmNoS"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:user-agent:in-reply-to
         :references:mime-version:content-type;
        bh=N00ZU6ZKa7Vc07+wvOh4PvO07LRMSYouowvupR7GR+Y=;
        b=i7rjDJ3X2Ft+qWBnJq7xrHTic+O+k+0DsVT0B0/855HIkcpkECuPrBUnrexHJv5DQR
         U5e0E8CW1XbU6Vk5UYhc77iqDUAk8nffrskTEVep5LnjsSBaklPJz+ma2t/v712YTQPh
         y2ObB3cG65hlCfYJGKAC2z1JqZGEj8aPpdk9Q9Y351bz0UC8KOPJpNqgiyuoOrI2PWTM
         qVCvsHPE15yja6fhWBTtn+beepT0cdErBAIatlEgzub8/LW7ZZwDPYqua1Cxzv7tdxrw
         97ovAhiO7Pp0Vz9k/lGqVMUslvhSEMVgHQ4sYKlk/fGVnwjRFq8jMwGj+6AnW551P6Sk
         5Ybg==
In-Reply-To: <20140419.195816.57462893.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--nextPart7222751.HgFyufmNoS
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Sat, 19 Apr 2014 19:58:16 Ryusuke Konishi wrote:
> This patch breaks mount program; mount.nilfs2 fails to find cleanerd
> since it was moved to /usr/sbin:
>=20
>   # mount -t nilfs2 /dev/sdb1 /test
>   mount.nilfs2: Error: nilfs_cleanerd not found
>   nilfs_cleanerd aborted

Damn, sorry for mess...


> I think nilfs_cleanerd should be installed to /sbin.

You're right but in this case it should be statically linked with depen=
dent=20
libraries...

=2D-=20
Cheers,
 Dmitry Smirnov.


--nextPart7222751.HgFyufmNoS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABCAAGBQJTUltDAAoJEFK2u9lTlo0bQZ8P/iuIuhV0fqJagvr/OYRp1Yny
Q880WZh2hWAbkrCIpaPRsL35qilUW12M9R+dNTME3bEG/7fRsWfv3zUELd55QqvL
1uAuLOwtSXTRY+Ie2MAMCT++HUMaulN1FtPADJ8gOS3tVwmpx8Ffxx7UZ4xcqKex
f2DqWpn5vNlh1oiN01SiW4Vo9RAR45ikgF39aJ6yhxQTsyo8q1p6iGj7f9P3nEhe
EhtMLXC8TGPthfaeex+DUt1kjQC3ddOLFOyKakBeBxG7c4JAWtIl6UqXWCZHPCer
EF/LVowYpFGGS4XgeNrVF5uTM+wryOjQGCXtfylkrgi8cgw5ZUApwzeALZYbp+gb
+PE4T2VrZs1zpA62NJvMxIsryP00CvsVuRZzFaQLKdysxs31hG6SGN78l2gBeBP4
EcnEqeeuYL8eWBMSmiC4BZ3Ed56Qk1Ra6dm+ijCJUqaL/wB3JKsTk1+zzeUyNcGS
GKiXXPj64+A/zPETT/guLljUYOS8NpkbWXu62vSoxGpnj2gGk2fo+bVbJHZ5s5bK
UaNZ0s+l3AP3aagKtj3WO7LdAV81HjXub+s3B5ywq8GOpmZeQvzUrXVVcZDOZExa
UXunAGPhx8Nat3Y8+QEMS5yMgAHzEiIA+imHyrx4ukg775iXWPtOOL+e3DSTWgek
i0I2QWKkUPligKiHAaHw
=9fiT
-----END PGP SIGNATURE-----

--nextPart7222751.HgFyufmNoS--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
