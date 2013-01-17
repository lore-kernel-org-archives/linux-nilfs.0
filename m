From: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: Work around uncleanable full filesystem
Date: Thu, 17 Jan 2013 09:32:51 +0100
Message-ID: <10139628.nRTq3A6E4L@bentobox>
References: <1358178899-26347-1-git-send-email-sven@narfation.org> <2312125.8JVqXAGppa@bentobox> <1358409438.2513.14.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1965251.lBDqolOfhs"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=narfation.org;
	s=20121; t=1358411578;
	bh=9rcH56/546PTxYHBYqRa/FFxXyaLZF9VP4jEc7wHucM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1JvRWFU1oo6m2aKkXqzNowbFLC1yrbu9QngN7fmTWNRZysOnrST8AXnbaY7OjlQJ
	 wbbQ2JZWZZvgiizxFdMPz1ZQf32BT4F3wLaDM3maIW9L1LcTFw+yFVwhY+ijy5Dqzm
	 3/7tmzEDgDz7WY0SsNSWK92LIx2DOjxuQqwkFW1Y=
In-Reply-To: <1358409438.2513.14.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--nextPart1965251.lBDqolOfhs
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday 17 January 2013 11:57:18 Vyacheslav Dubeyko wrote:
[...]
> If you do so by the hands then, from my point of view, you know what you
> are doing.

You asked for a way to easily reproduce it and now say it is my fault? Sry, 
but it happened in a real world scenario and I only provided a testcase for 
you.

Kind regards,
	Sven
--nextPart1965251.lBDqolOfhs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQ97czAAoJEF2HCgfBJntGE0IP/2vVpz2rNwxEMoEqjveSH1So
cZoERSChOHQUGzj29Pv/L4zW2Poau4LBatvLuUI2c3n5MugeWWjFC0lWMKxwIMEA
AKzEa8SA97zGYeX4Oc6+AR0NC9sCg6CRIHqAq6dJQBF0V4aE5jIYbOaVqAobSHkt
vr3ZwX0XBIwUcse0Mu+JLb4YZ0IKDrLTJDEQZONRWnFHGzjhzH0aG7rfEjlPkOrb
L2/C4wRZ8rNpncZwxIVQm68TWScqWLHtLQkf28swy4pRnP/pG1nGcNHiZ1etXia0
vXflqZUpcqUSC2nAVtxQY+dxwhA2JVRliR5Z6KfcrPe+ebu2wuQ5fDoOglqg6DBD
gTLdMvdgGVDAaZ1twBFtKNdzVlInQA5TjOY+dnpBBgRqUp6uPmivcarOpeWDFOrX
EFd6uyS87dsXlRSgFAkDRhq/JIdKVYXmPunzTRsX1gsfCzVqnHqnBFIVW7kz192D
sP5NPmGaiYHwkXf7yx37lrVFz79OWCcVPQ95rvDga99dUHQ1hHyZuCrLFzhAKfFd
60MehfqnTrGwNUYjGTUIeVITrFjXxOfOtVHR10YEP+w40mDKMQ30BWjxEOV1jked
p/GUsOjM4s0/Ixkw2Cvlh9QIwg/poyYPR4Y1iZAEORP4cCT/8Wl1YEjBtCDDJU6G
3WEFvZxlUh3LR+o0o9YC
=CbJB
-----END PGP SIGNATURE-----

--nextPart1965251.lBDqolOfhs--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
