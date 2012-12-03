From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: Raspberry-Pi and NiLFS2
Date: Tue, 4 Dec 2012 00:10:34 +0100
Message-ID: <20121203231034.GE4028@wloczykij>
References: <20121203150440.GA4950@nas.13thmonkey.org>
 <C408B24F-3846-4950-9586-B08CD5B4FBE1@dubeyko.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jZNlLGxhPb4urluq"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C408B24F-3846-4950-9586-B08CD5B4FBE1-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--jZNlLGxhPb4urluq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 03, 2012 at 10:18:46PM +0300, Vyacheslav Dubeyko wrote:
> Hi,
>=20
> On Dec 3, 2012, at 6:04 PM, Reinoud Zandijk wrote:
>=20
> > Hi folks,
> >=20
> > has anyone tried out NiLFS2 on the RPi as root file system? I tried, bu=
t of
> > course my default kernel has no support for NiLFS2 :-/
> >=20
>=20
> As I know, Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org> have experience with usi=
ng NILFS2 on Raspberry-Pi. I hope that he share your knowledge when he will=
 have free time.
>=20
> Piotr, could you share your experience or some useful links about it?

Sure. I'm using custom build kernel with nilfs2 support built-in and
Gentoo Linux on my rPi. It works stable. Except one time error that
could be connected with turbo mode and/or memory card/card controller
issue (but it works stable @900MHz turbo mode).

I used some ready-to-use stage3 (or stage4?) created for rPi by someone
at the official forums, made custom kernel, made nilfs2 as rootfs and
adjusted fstab. No rocket since here. (-:


Piotr Szymaniak.
--=20
  Polowalem na slabych,  nieszkodliwych i niczego nie podejrzewajacych.
Lekcja, ktorej mnie nauczono, brzmi: silny ma zawsze racje.
    -- Carl Panzram

--jZNlLGxhPb4urluq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQvTFqAAoJEEMpAov1cw9lbEIQAJ/MiM9FgWu3gAkwtUM0xebs
+WMZAh0IdCXmhj3WIxsUUOlYjj8mrQdtyujt/7XfmN1Skvf3S8QiE10KfdCPc5lX
caaGj69eKBF4bDW9Vlsc0EYNX5qKhDiKrdPa3B8JH5nhRfGs9DtGiFPu30zG9U0N
VI8CbsEPwRhdOanHXMONSVJ0HyyZNP4jb1sxrAr+VuYlH58V8+ngXpx41S07xjH5
B+19ogF8jObVh/+qdubeCD/D11A+2cYXJiWz5vwCmKI2qgZPkmhBdxJCD9hpKnnY
TRTlfVOSxP54Q1RQTqahWV+AHGdMNs0WWwH1KsFzROOenh/lvySSu1URxGzc10ce
zjSQOWeZT3Azm5cPSbp5hijYoclfyCTBx8JcvKqipzlH1C7WtupsRqAWnRFdLaqB
ERpCp0K2K6Qex/TkAn4NvrdUyJZ4BLyPxEVfD7tLaX2vrIvNJEiDAQogCChB8nQA
GMPwFOxsx2Np5OUgyqKBgP7dxZOk14qPAlvgpNRHKuq9jpFESRXNwE6e89JH417h
4gfrp54GXhSiZepwyJF5mv1/ul6n6zTtE1KXA9Amti/G1861ws4BdOwabJ7XR8L7
eUozcBk6Crfx1agiVW0zdTUDQwSFx2TvVYC2euO/gyaQqkDAB6ZwZcjdpbPs9X6l
y1fMrpbBVblDwHw4SORj
=8k0t
-----END PGP SIGNATURE-----

--jZNlLGxhPb4urluq--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
