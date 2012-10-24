From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Wed, 24 Oct 2012 09:36:41 +0200
Message-ID: <20121024073641.GB27763@wloczykij>
References: <20121014200836.GK27763@wloczykij>
 <1350281888.2488.9.camel@slavad-ubuntu>
 <20121018201528.GS27763@wloczykij>
 <1350628991.2028.25.camel@slavad-ubuntu>
 <20121019101421.GT27763@wloczykij>
 <1350973913.2041.25.camel@slavad-ubuntu>
 <20121023084100.GW27763@wloczykij>
 <1350984395.2041.32.camel@slavad-ubuntu>
 <20121023115458.GA27763@wloczykij>
 <1350999330.2041.48.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OesXTvlsfeLEOFyS"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1350999330.2041.48.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--OesXTvlsfeLEOFyS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 23, 2012 at 05:35:30PM +0400, Vyacheslav Dubeyko wrote:
> I think that the issue is the concrete SD-card's issue. So, if you
> simply dump out the image on another SD-card then, I hope, all will work
> fine.

But what could be the issue with SD-card?

Anyway, I did a second image, mounted it as before and it works. dmesg
shows:
[ 2740.544690] NILFS warning: broken superblock. using spare superblock (bl=
ocksize =3D 1024).
[ 2740.544754] NILFS warning: broken superblock. using spare superblock (bl=
ocksize =3D 4096).
[ 2740.544760] NILFS warning: mounting unchecked fs
[ 2740.861477] NILFS: recovery complete.
[ 2740.911019] segctord starting. Construction interval =3D 300 seconds, CP=
 frequency < 30 seconds

I will try to put the image after mount/umount back to the SD-card and
check if it works on Raspberry Pi.


Piotr Szymaniak.
--=20
 - (...) Nie wyobrazam sobie, co ta gora miesa moglaby ci dac, czego ja
nie   moglbym   ofiarowac.  Oczywiscie  poza  piecdziesiecioma  funtami
rozrosnietych miesni.
 - Moze mnie wlasnie pociagaja rozrosniete miesnie. (...) W koncu wielu
mezczyzn pociaga rozrosnieta tkanka tluszczowa piersi.
  -- Graham Masterton, "The Wells of Hell"

--OesXTvlsfeLEOFyS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQh5qJAAoJEEMpAov1cw9lB4YQAKHs9lx/1jRqneINIAQS0q48
/ugk10VflkSxccGnysmtlvjkBPc6Iw9Le6Tg//gQDPmR7G4Srgi2iaYX/Vnw4hWk
EYckTeRm+CrVz+hSEXylG+rr2ued5fQD4wJYZPriPdo2udARPnfyIh5d1iphdCq0
+IOcNx46lCTfrDs1Gt4zUjVrHqhZBqhw7/WSI3IHdQ02+xECvnwruQwGs4Z7zhSB
+emxdPRsj/jev/5783FVuNM4j1ruipMMGiP0scQhx6oP2U2ZtQN4UinBRVlq1dak
jn4ZDDWFYU35H4pQOL3i6TygiRzWBq0d+MsNuD9O8xwGFjaDUePzWaN2DUPUaxey
gT7UqxgRcfDLGgM3ai4xzhS9PlqPYS4s5/3Q0L+EnbBuAjaeUk2n6k9xvUItb54P
2CNQZf7aE+AjBK7ft3xwFU1tZ+bMd76TT3c0K/SABDtl/X41vuKUyBinXtO+CUmk
2RXmTDonP7CymB5eCb1Ekcq0ofFbJZW/ACaYPrggElhl4ifRYieKdyVTTaEhgmBH
fAuuzJwGWe0GCPOlS3MpAQHd8a3+g4tY9A0jf9bMUqepkUfEZko9DsF1APvi7GGh
aoQQVnUSkVhe8o5zD7caQ1t6JLXZkI15KeeZaw+IVAOVuieeYCusPec1sQotb1Y2
EjMDybS+nfJbg8nRwUeG
=e9Aa
-----END PGP SIGNATURE-----

--OesXTvlsfeLEOFyS--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
