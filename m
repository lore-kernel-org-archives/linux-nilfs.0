From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Tue, 10 Jul 2012 16:07:11 +0200
Message-ID: <20120710140711.GY1478@wloczykij>
References: <1341904734.1980.17.camel@slavad-ubuntu-11>
 <20120710.175131.21311203.konishi.ryusuke@lab.ntt.co.jp>
 <1341916735.1973.10.camel@slavad-ubuntu-11>
 <20120710.200937.163315083.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="g3IWFuR7/O9KKcN6"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120710.200937.163315083.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--g3IWFuR7/O9KKcN6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2012 at 08:09:37PM +0900, Ryusuke Konishi wrote:
> On Tue, 10 Jul 2012 14:38:55 +0400, Vyacheslav Dubeyko wrote:
> > I think after analysis of strace output that Piotr Szymaniak has the
> > same problem. But maybe I wrong.=20
>=20
> According to the log, his problem looks different.
>=20
> cleanerd fails with ENOENT error (No such file or directory)
> if it couldn't find the given device in /proc/mounts.
>=20
> His /proc/mounts looks:
>=20
> rootfs / rootfs rw 0 0
> /dev/root / nilfs2 rw 0 0
> ..
>=20
> And, the strace log shows that /dev/root didn't exist.
>=20
> I guess the problem would be fixed if a proper symbolic link pointing
> to the real device is created as /dev/root.

Yes, it seems so. Just after I wrote my amateur strace analysis I tried
to fix it by hand. Made a symlink from /dev/root to /dev/sda2 and
remounted /. nilfs_cleanerd started fine.

But why is it failing on /dev/root anyway? It's started with
/dev/disk/by-uuid/uuid pointing to a proper device (sda2). Do we really
need /dev/root?

Also, maybe there's a reason to remove /dev/root? I will try later with
some older udev to see if it is created.


Piotr Szymaniak.
--=20
<kow`> "There are 10 types of people in the world... those who
understand binary and those who don't."
<SpaceRain> That's only 2 types of people, kow.
<SpaceRain> STUPID
  -- bash.org

--g3IWFuR7/O9KKcN6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJP/DcPAAoJEEMpAov1cw9l3S0P+wbMqqkCzCfS+VlNDMQ/k0LX
3V00AihZ9rH3oidW/hABOKMtuj2Y+u0mZLK2hQ44WCVU6hgcwnw9J7iFWqhvEC2s
/MuKtTbDZDWYb6aasQFlQQlYwmiar7smVaGFbnsZkyGIr/gSPwNt4DYAmatB1yP/
kIJdKBlen9d0MaQE/z3Sds0PwAfrGJm7Zq9xyTk6zDVLPogeXEetg6M2GMyIimmC
LCoUAOBvbh583fKmeCi3537+ctjPCsQCFkpvbsdINNrzRpVyWoWI+h83KRJU5tQd
o9IInS0ACMFQd16Nkm1CW8a0PS42NlVXRq+2lj1e3541muViBI1aQNlFbmA3MzNM
w29Y1NounVzXGVbXPcv2+CVpeZazsx51aoSswNhc0NVNfzDasSmkRAGJkdRhAltU
//H+sdHXSWbnPViKEa8+VTnD3J9qlIndTH9/vXDOUSS1afj7cnDWZAqLIW6oREUG
i+ThZQ6iVxghyv9/B8kI0iR0TsJ6/xo6kj9K9GFXO/ncTQ/keuotcLmtTUYRkGiY
JCa/y7ZImuiX5ErmX2vvCFT2dB4C+1gCdooJDN2urAnpMy0kCoV4XumBzSmCh7rO
rJ3ylBhk6uhEBxEkvFf6bdOKLRjcLWl7maKRI0X3QszarsFGS9d1efyStwodIB4m
qTrgBXYRMCaUdRmaDaF6
=KP/2
-----END PGP SIGNATURE-----

--g3IWFuR7/O9KKcN6--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
