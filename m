From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: My NiLFS2 port to NetBSD: status update
Date: Tue, 4 Jun 2013 16:02:57 +0200
Message-ID: <20130604140257.GA713@diablo.13thmonkey.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ryusuke, hi folks,

it has been some time now that i worked on my NetBSD port of NiLFS2. A
read-only version has been included in the NetBSD kernel for some two(?) years
now. I then started on creating a writing version too but it got side tracked
by various reasons like moving to a new house/home :)

I've picked up development, re-starting again, learning from earlier mistakes.
Has anything fundemental changed in the last few months? I've taken in the
changes for volume name, the 2nd superblock and such, but is there anything
more?

As for the adoption of NiLFS2 in Linux, i've seen mixed responses in reviews.
Most complain about the read/write speed. Since i dont have a reasonable test
setup and my implementation is not writing yet, how are your thoughts about
this? Is it a fundemental issue or is it more due to way its implemented?

With regards,
Reinoud


--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (NetBSD)

iQEcBAEBAgAGBQJRrfORAAoJEIKcNwBDyKpoIqIIAKycbyFpSClG57TgddnPYqip
j9Rn5HRFJwONGicO33xNMKPyu51xuRdqHeNetjzEJaKrbcRoOASc1SMUzct5OFiC
fWSimnFpbQoxdkTCH33a6NBEB8ZRX4deXwktSMPcJFYJ8QFGd3fKMx//JSog0Yqf
oZbRtr0FbuWATQEMgi7fqeCCyaxxhQKXTsWjK/WHQrwrMRpYx0yIfEBzS0rypU/J
jPFF7uSYzIjb0mj4uLse1h7zqF8VviCJMixLGN8jLKFvUiZ8pXaYb46Io3imTtuK
UjLovhyOBAuL0d8AI8eHoTyiO2OTZceo7re5qyZOJd647qTKunIWR2FZsRhTHAI=
=Tshd
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
