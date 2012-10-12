From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Fri, 12 Oct 2012 22:56:55 +0200
Message-ID: <20121012205654.GI27763@wloczykij>
References: <20121008222557.GU28032@wloczykij>
 <1349767793.3427.7.camel@slavad-ubuntu>
 <20121009105239.GV28032@wloczykij>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8cpS+6Cx+xtICsjy"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121009105239.GV28032@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--8cpS+6Cx+xtICsjy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 09, 2012 at 12:52:39PM +0200, Piotr Szymaniak wrote:
> > I think that first of all it needs to detect that it is NILFS2 issue but
> > not hardware or MMC stack issue.
>=20
> Will connect some screen via HDMI to check if there's some error msg.
> The card should be fine, but I will dd it to disk to check for read
> errors.

Sorry for answering my own mail. Connected Raspberry Pi to a screen and
here's the output:

# --=20
segctord starting. Construction interval =3D 300 seconds. CP frequency < 30=
 seconds
NILFS: corrupt root inode.
List of all partitions:
b300    7883776 mmchlk0 driver: mmcblk
  b301       57344 mmcblk0p1 00000000-0000-0000-0000-000000000000
  b302      262144 mmcblk0p2 00000000-0000-0000-0000-000000000000
  b303     7560192 mmcblk0p3 00000000-0000-0000-0000-000000000000
0800       7816704 sda driver: sd
  0801     7016688 sda1 00000000-0000-0000-0000-000000000000
No filesystem could mount root, tried: nilfs2
Kernel panic - not syncing: VFS: Unable to mount root is on unknown-block(1=
79,3)
[<c001537c>] (unwind_backtrace+0x0/0xfc) from [<c0421c2c>] (dump_stack+0x20=
/0x24)
[<c0421c2c>] (dump_stack+0x20/0x24) from [<c0421de0>] (panic+0x70/0x1a0)
[<c0421de0>] (panic+0x70/0x1a0) from [<c05d4cf0>] (mount_block_root+0x1f4/0=
x254)
[<c05d4cf0>] (mount_block_root+0x1f4/0x256) from [<05d4f64>] (mount_root+0x=
f0/0x114)
[<c05d4f64>] (mount_root+0xf0/0x114) from [<c05d50e4>] (prepare_namespace+0=
x15c/0x1c0)
[<c05d50e4>] (prepare_namespace+0x15c/0x1c0) from [<c05d48dc>] (kernel_init=
+0x100/0x130)
[<c05d48dc>] (kernel_init+0x100/0x130) from [<c000f00c>] (kernel_thread_exi=
t+0x0/0x8)
# --=20

Don't know if that is usefull. ;)

Piotr Szymaniak.
--=20
Zaphod nie mia=C5=82 ochoty zaczyna=C4=87 z nimi b=C3=B3jki, a poniewa=C5=
=BC uwa=C5=BCa=C5=82, =C5=BCe jak
w odwadze  najlepsza jest ostro=C5=BCno=C5=9B=C4=87,  tak w ostro=C5=BCno=
=C5=9Bci - tch=C3=B3rzostwo,
schowa=C5=82 si=C4=99 odwa=C5=BCnie do szafy.
  -- Douglas Adams, "Life, The Universe and Everything"

--8cpS+6Cx+xtICsjy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQeIQWAAoJEEMpAov1cw9lpHsQAKeC8ojY4Rgxkfm3fhHo65ux
nZxkVdUcOq1S9Lcgwt5Ruqa2kE6qmMXO4zSzNW4YaH6z2u0+Uw5Gpx8mc0PMDVsx
vlvw+ExyNTXvcs7euvKpU1L3F1cOE1WkWQ1EQKE7kAKWk+3kVQxUIJB4jOO3SVTB
cHQ+1B7IFfFivOE/mpqWToY7rtbtM3mS83T8SVUaVKigintwPQutsv/Jaf00nSJt
MeFflIzX2ej90ny4e8Nd4gCK3HkVhpdpQ6Tbp9WAvH8grzGcy485WHPFeuEpFnFx
WVp6YP6YKzgttYWzvqL51eBeHA8zhLqxt1KwyRCme9ndZYyjcd8u2q3cMKV0PR1C
y2ju/tSZParJHp/Rtmy0Cht6wF2EabrlpK4pQxGbT5R3pxPGYv/HXl1XNVeXAw2g
wf1orMJFmxb9c2ZGaqZXUfkAmbo7sJqWgZhx9VhhdHmF0srJ0zxitD3w7nNaxCvX
ewf+uaSxyhvKIPfcFAV1klFaCikRI1AX/Lq7FYwNQ0XDdGx2s+VQS5Ac0FmAtIpj
NvPunTK7Sp4cjgjkNSUQUTkchUf20SBnRPHSTftLwXMESN9MZhxtAdx45zcF/dhO
xkWxoB+05r6uS0/Eu4uTr2X1NUTjtohDrOXHwGEObuoK5pnQi4SpfFfAMM0CujGT
qag2fOIoUtKAEWSfsWdM
=MYqW
-----END PGP SIGNATURE-----

--8cpS+6Cx+xtICsjy--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
