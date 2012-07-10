From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Tue, 10 Jul 2012 09:51:31 +0200
Message-ID: <20120710075131.GV1478@wloczykij>
References: <20120709073300.GP1478@wloczykij>
 <10181027.pPHs7IDARt@coil>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dg6Tyglv1qyvGx3q"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <10181027.pPHs7IDARt@coil>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--dg6Tyglv1qyvGx3q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 09, 2012 at 11:33:13AM +0200, dexen deVries wrote:
> On Monday 09 of July 2012 09:33:00 you wrote:
> >(...)
> > Where to go from this point? How to debug nilfs_cleanerd issue?
>=20
> using strace -f  on the nilfs_cleanerd should give you a clue what causes=
 the=20
> exit. it may exit if can't connect to syslogd.

Hi list,

I will try to sort information from few messages together here.

Attached strace output from my "nilfs_cleanerd" for rootfs. The script
is in /etc/local.d (again, Gentoo Linux) and it looks like this (removed
commented parts and empty lines):
CONFILE=3D"/etc/nilfs_cleanerd_rootfs.conf"
TARGETDISK=3D"/dev/disk/by-uuid/1aa9e6fb-cf7d-45bd-bbfb-08110a8840b7"
/sbin/nilfs_cleanerd -c "${CONFILE}" "${TARGETDISK}"

And here's the mentioned nilfs_cleanerd_rootfs.conf:
protection_period	3600
min_clean_segments	13%
max_clean_segments	25%
clean_check_interval	10
selection_policy	timestamp	# timestamp in ascend order
nsegments_per_clean	2
mc_nsegments_per_clean	4
cleaning_interval	5
mc_cleaning_interval	1
retry_interval		60
use_mmap
log_priority		info


> if `lscp' reports no checkpoints, try `lscp -a' -- should show even minor=
=20
> checkpoints (which are checkpoints created by GC, AFAIK).

That's right, lscp -a gives some more output:
maszyn ~ # lscp -a | wc -l
1428

Running nilfs_cleanerd with more verbose output (log_priority debug)
gives me this:
Jul 10 09:45:26 [nilfs_cleanerd] start
Jul 10 09:45:26 [nilfs_cleanerd] cannot open nilfs on /dev/sda2: No such
file or directory
Jul 10 09:45:26 [nilfs_cleanerd] cannot create cleanerd on /dev/sda2: No
such file or directory
Jul 10 09:45:26 [nilfs_cleanerd] shutdown


maszyn ~ # ll /dev/sda2
brw-rw---- 1 root disk 8, 2 lip 10  2012 /dev/sda2

maszyn ~ # ll /dev/disk/by-uuid/1aa9e6fb-cf7d-45bd-bbfb-08110a8840b7=20
lrwxrwxrwx 1 root root 10 lip 10  2012
/dev/disk/by-uuid/1aa9e6fb-cf7d-45bd-bbfb-08110a8840b7 -> ../../sda2


Piotr Szymaniak.
--=20
Gdy mowisz, co bedzie w przyszlym roku, diabel chichocze.
  -- Przyslowie japonskie

--dg6Tyglv1qyvGx3q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJP+98DAAoJEEMpAov1cw9ltT8P/2vD79S6Nhr8WLUFTNUGjstb
07KX7mey3OXUnVoFOTJHzs5ft/foBs5iDZ/uGnki1w+nXqmgrnsp+mx6VJUDMAvk
y2NJqcjaGSLQyCxD566ZcOvgEk2R40Lgx3dgqpkraHLk2yUWja6fED5C5xQw6uYE
yG/Epko418qPfi3pgWa8LyG3061Qf+UVNcdJMQH6ukGY2fcEpffSmZI4GLyb+0B5
fV2jXN5C73iS4j9/43ouR8RuWDECC5gd/84lVqFwLQUTRup0z0fujiIdQZpr1y0J
BcXRXu4YreQRWlR9xHH7vo4PLeSGM4rgwUjYTZ4sINe/dJgXoRlQFJQtlDTXSx89
3x/X3oEmAYMOM0FbYgMHM6oQL+xTkPFNWm+Rau3sBK9oSKAqAvMrSU8a/tVLlSL8
0wKoHYZCFCnK9SnYUQdskan3pwAYdRxwQK+Vd0auySIoEC/49TAypMUbcOkcrP9l
2o1F2tL8P025x+lIi4Ncetq9198QxEv/fpalhpYQlyUrJe47cwQg86AlA72+tZHD
/1NKpyIuLhNw0MHLwGLawbL+7di4iYRT+2yvln7dQ+1M/rSnelIm3Vboc68D0ugo
AyysR/WPeiZJ+sOyzSoZNs86cy4fcNai7o55fy4cs3I9itPOJKpBfSVGjyoyrrAr
CEe4z+I9o1s7eYuIrKnq
=+64Y
-----END PGP SIGNATURE-----

--dg6Tyglv1qyvGx3q--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
