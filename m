From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Tue, 23 Oct 2012 13:54:58 +0200
Message-ID: <20121023115458.GA27763@wloczykij>
References: <20121012114043.GG27763@wloczykij>
 <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC@dubeyko.com>
 <20121014200836.GK27763@wloczykij>
 <1350281888.2488.9.camel@slavad-ubuntu>
 <20121018201528.GS27763@wloczykij>
 <1350628991.2028.25.camel@slavad-ubuntu>
 <20121019101421.GT27763@wloczykij>
 <1350973913.2041.25.camel@slavad-ubuntu>
 <20121023084100.GW27763@wloczykij>
 <1350984395.2041.32.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="N0R7NkT9p8YM3UMD"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1350984395.2041.32.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--N0R7NkT9p8YM3UMD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Oct 23, 2012 at 01:26:35PM +0400, Vyacheslav Dubeyko wrote:
> It is strange. Did you try to mount NILFS2 volume that is placed on
> SD-card for the case of on another machine (Gentoo x86 with kernel
> 3.6.2)?

Yes, all those messages are from this machine (it could be kernel 3.4.10
or 3.6 or 3.6.1 at the beginning of this thread).


> Could you try to mount volume's dump as loop device on machine (Gentoo
> x86 with kernel 3.6.2)?

Now this is weird. I have a complete image of the SD-card but never
tried to mount it. Now I did with:
mount -t nilfs2 -o loop,offset=[offset to nilfs2] raspi.img /mount/point
and it works.

I tried to mount this SD-card on the same machine (using card reader) and
had the mentioned error.

Now I'm a bit confused. Made SD-card image without issues, SD-card
refuses to mount, but the image works?

I will try to make another image and double check it.

What should I do if this works? mount the image, umount the image (that
should fix it?) and copy image back to SD-card?


> Could you share strace output (strace mount <device> <mount-point>) for
> the case of mount trying?

I will share the SD-card strace output later (if it still won't work,
see above).


Piotr Szymaniak.

--N0R7NkT9p8YM3UMD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQhoWSAAoJEEMpAov1cw9lw2gQALfQCVDT0Sb9fPkjNbSLkRrZ
wAaKWA9vjl/QTG3Iy5z8eKdkgpJJ/8rCtjpHn0SEy+P29BNacSTRniNVzB9fTcm7
rpkLYhAL+C0hNTQCwkVjyhRXYGgIS7BBfv8p38tpfS7qmNEUvgROGClfcrePbs/f
RT7xxwQifurbeixKiLqhQxmmlPCusroEG547VxgvFikGR5NntW3GOys0F+gxZ9R2
4epFEBwBHvhsn7wQboeVgidyKvzQOr7IapHbrH4t1KTrGVkHBg97PBv+bBlaqt1X
3n0wr0sQRJwB+dDBMHhA8PLJJFwkVmmz0HE5qiH97/4kFYkxFcXsWpcS7R1ONsmY
NyFvW/P5WCq1MWBhecGFbaJJJf64cq1BpZAaqDh/GQPEnhrdLgZywMVh95m6jR5m
6dmR3fbrp7c0Dyj5LCVbRXdJN7v8zM5mXMrzT1HUUOUC2Mn8DQGDups6l06a9dq2
X3rCMsHawYkpTnMBHOfnZnFC1H66I33b6pI2xPji8iaEsvCJUGgQFRR7lae4HGLW
q+fEGK9IhcDuB1dtrYs0Ik3ur6YnWnHdwTg2T3LJoT0abujQb9ODwQrrATCg/ac9
oAAiSqRQW9/iYQwCBqJreoMyUhzfzot/zM0QPbycBJLbE+d7oMTb469J6zVzOWdi
DWGa0goC46GuF0MwwjS9
=6qBi
-----END PGP SIGNATURE-----

--N0R7NkT9p8YM3UMD--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
