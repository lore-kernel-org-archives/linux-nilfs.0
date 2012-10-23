From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Tue, 23 Oct 2012 10:41:00 +0200
Message-ID: <20121023084100.GW27763@wloczykij>
References: <20121012103119.GF27763@wloczykij>
 <1350040053.2026.47.camel@slavad-ubuntu>
 <20121012114043.GG27763@wloczykij>
 <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC@dubeyko.com>
 <20121014200836.GK27763@wloczykij>
 <1350281888.2488.9.camel@slavad-ubuntu>
 <20121018201528.GS27763@wloczykij>
 <1350628991.2028.25.camel@slavad-ubuntu>
 <20121019101421.GT27763@wloczykij>
 <1350973913.2041.25.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="W1uEbMXJ1Mj4g6TI"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1350973913.2041.25.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--W1uEbMXJ1Mj4g6TI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 23, 2012 at 10:31:53AM +0400, Vyacheslav Dubeyko wrote:
> Sorry, for delay with answer. I was slightly busy.

Hi,

Not a problem. Thanks for help. (:


> So, currently, I have such picture. Your initial report was:
>=20
> On Tue, 2012-10-09 at 00:25 +0200, Piotr Szymaniak wrote:
> > dmesg shows:
> > (...)
> > [43893.754525] segctord starting. Construction interval =3D 300 seconds=
, CP frequency < 30 seconds
> > [43893.760245] NILFS: corrupt root inode.
>=20
> This error message generates only in one place by
> nilfs_get_root_dentry() method in super.c
> (http://lxr.free-electrons.com/source/fs/nilfs2/super.c#L903):
>=20
> 903         if (!S_ISDIR(inode->i_mode) || !inode->i_blocks || !inode->i_=
size) {
> 904                 iput(inode);
> 905                 printk(KERN_ERR "NILFS: corrupt root inode.\n");
> 906                 ret =3D -EINVAL;
> 907                 goto out;
> 908         }
>=20
> So, only corruption of any of three fields of inode can be a reason for
> such error message, from my understanding. But from the dump of #734205
> block I can see such content of root inode (ino =3D 2):
>=20
> 00000100  01 00 00 00 00 00 00 00  00 10 00 00 00 00 00 00  |............=
=2E...|
> 00000110  08 00 00 00 00 00 00 00  08 00 00 00 00 00 00 00  |............=
=2E...|
> 00000120  03 5a 62 02 03 5a 62 02  00 00 00 00 00 00 00 00  |.Zb..Zb.....=
=2E...|
> 00000130  ed 41 13 00 00 00 00 00  00 00 00 00 00 00 00 00  |.A..........=
=2E...|
> 00000140  8f aa 0a 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
> 00000150  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
> 00000160  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
> 00000170  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
>=20
> [00000100] i_blocks =3D 0x1
> [00000108] i_size =3D 0x1000
> [00000130] i_mode =3D 0x41ed (040755)
>=20
> It means that inode's content is placed in one block and this inode
> describes folder. So, the on-disk inode is correct and should be read
> correctly during mounting. I have compared vanilla kernel code with
> https://github.com/raspberrypi/linux and can't see any significant
> difference. Currently, I think that unstable functioning of SD-card
> controller in the Turbo mode can be the reason of this error message but
> maybe I haven't the clear picture.
>=20
> Did you try to mount this NILFS2 volume on host machine in normal mode?
> Do you have such error message with this NILFS2 volume in another
> technical environment?

Yes, I tried to run it in normal mode (/boot is on small fat partition,
so I can tweak Turbo one way on another without touching rootfs). Also
all of the dumps are made on another machine (Gentoo x86 with kernel 3.6.2)
and it refuses to mount with above message.


Piotr Szymaniak.
--=20
 - Bufory.  Oto, dlaczego ja poslubilem.  I bylem glupcem, wstydzac sie
przed  soba  do  tego  przyznac.  Zupelnie  jak  faceci,  ktorzy kupuja
Playboya,  wmawiajac  sobie,  ze  to  tylko dla artykulow. - Otarl usta
wierzchem  dloni. - Zgoda, to infantylne, ale to mi sie wlasnie podoba.
Bufory.
  -- Graham Masterton, "Mirror"

--W1uEbMXJ1Mj4g6TI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQhlgbAAoJEEMpAov1cw9lJ6kQAIcM7ibyu+NqbbMmgS3z/SKm
hVMlEhHcziVhN4rbgtQRtrVh90bY9yYqdyxU0ifw+t3V+D14UnQEEbb/SOiKXFMR
u7hsPMoz98kdJikLnETDKyNdgBtozSk7NItt2xsaGSvlrXKzR8IslyRTc/ElUAZV
4IAUycOiXAakGWGY72dHJagLM9nbehf3nRCLi+66ZbVxsFOjlJ0NiGPMadfTVEDx
yX3G0S3UjxEtBCb2as7GPMq0aHgux1ATLhQ3jQMiwJgMrtZBOjRLNz2Hz4+csLZV
1tUnWhhgHpmzI2fm+YwzK+tDLoXaPs5/vKRws/zBYjrlDpTGGuoPWyyBE8J9aiEt
i0vnQO25gxIRRULs/XUzYuCsbqhgqXL75PJ0JIiryVebBR5ck1o4vSX/75GxQdUD
Psr9+CCBm0UuOCIWiw5A5+5WGuBSU5Ev5KopeVuOYyl5lfzfWuCaN77WeXH6haTl
9x268e90xZC8Tyr1g5N1wofUxFt33nLUGzDDR6XTLT1PDBCa2mF7/hAULUJmH/R/
0tMvDDe0gp0McBvyXar9/fzqojAv6b8pyjyCmggOzOb/6UjJM5JSB9/EbYFfprCv
mAnCW2BuarNnfptZXqRLEUxEmkso54pwTzU+SVW2w4eeyrxtW+PcuXKQLEm305IS
mqPnrhTNm6n8xm2A/BAd
=BEil
-----END PGP SIGNATURE-----

--W1uEbMXJ1Mj4g6TI--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
