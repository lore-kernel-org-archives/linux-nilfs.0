From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Thu, 18 Oct 2012 22:15:28 +0200
Message-ID: <20121018201528.GS27763@wloczykij>
References: <20121011092300.GB27763@wloczykij>
 <1349950320.1908.11.camel@slavad-ubuntu>
 <20121011180332.GE27763@wloczykij>
 <1350025832.2026.43.camel@slavad-ubuntu>
 <20121012103119.GF27763@wloczykij>
 <1350040053.2026.47.camel@slavad-ubuntu>
 <20121012114043.GG27763@wloczykij>
 <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC@dubeyko.com>
 <20121014200836.GK27763@wloczykij>
 <1350281888.2488.9.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jPC/Tkukgh9ZDT79"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1350281888.2488.9.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--jPC/Tkukgh9ZDT79
Content-Type: multipart/mixed; boundary="rQAi4ZBraoACHIeu"
Content-Disposition: inline


--rQAi4ZBraoACHIeu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 15, 2012 at 10:18:08AM +0400, Vyacheslav Dubeyko wrote:
> On Sun, 2012-10-14 at 22:08 +0200, Piotr Szymaniak wrote:
> > On Sun, Oct 14, 2012 at 06:55:59PM +0400, Vyacheslav Dubeyko wrote:
> > >=20
> > > So, it is clear that #359 segment is empty. Moreover, #357 segment do=
esn't contain ifile block with blkoff =3D 2 as I can see from dumpseg outpu=
t. Currently, I know that #358 segment contains empty ifile block with blko=
ff =3D 2. It needs to find segment which contains not empty block of ifile =
for blkoff =3D 2. Could you share dumpseg output of all previous segments (=
for #358)?
> >=20
> > dumpseg of blocks 340 =E2=86=92 357 attached (I hope, the file is ~200K=
B).
> >=20
>=20
> As I can see, checkpoints #1843 and #1819 contain ifile's block with blko=
ff =3D 2.
>=20
> Could you check state of blocks 719300 and 698817? If any of these blocks=
 are not empty then, please, send the raw dump of non-empty block(s).

Both dumps attached.

Piotr Szymaniak.
--=20
Smiejmy sie! Kto wie czy swiat potrwa jeszcze trzy tygodnie?
  -- Beaumarchais Pierre Augustin

--rQAi4ZBraoACHIeu
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="dump.698817.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWR3Ihk4AAIv////3a/1/dP/eZT/7IMV54s1tfvfdJ/+Bto98z/whfgDbwAJc
AkKoaiRNPUNA00NBpoAaekANNNAA0AaAaAAAAAyADI0AGmgBiD1PUQNDJpppiZA00MjQyaaG
g0wmQxDIDBGIyaAaDBGIwTTRgCGAEZNMmjEDQyaaaYmQNNDI0MmmhoNMJkMQyAwRiMmgGgwR
iME00YAhgBGTTJowSJJpNQmj01PU0jDRlG00IyGT00CYAmCAMIMTIwmEyDATIxMZEyYAT1Hp
Hqepvma1P5ki7alKICCISZDjVD7DgapYghorCx6QEFl/E3EN5o+mXR2UgZWSzzyJmLGgVsZJ
3bPfiquz0j2LW40t/j7lBb+3f1YFrO6trzHUUZCyxV220NuC3gL1llKSeVgVN47RnqZ/UUit
DFgUA0gInCSBCMJoS3gtd+NeTY01DiI3rYTFaC6xABkK0JBkdeqRSEqGg7O0gV8xBU7u0Or/
j/mYUsCZiW0vjidHPCS1YGrG22k0NDCtU1QwuaFNE77TGsqqQuaxIhizt9BJ6T3eHehhTFl9
brt1cZngflFRlIfnccI4QQpCgj0iB1HbxSdtycrfmVnnn1HUurLtTdHXkqdf4C1QzabW3ue/
x8unePkSXE8mFgVrKGfYsh5fbX0lHxElMXv5iUIo9GGmyzKiIaU0oIYCkbWCMr38WaCKWb0g
4sv6LU6fIiNmrBKmokf8FB3S6Bh1mA2dQrE3xsYusQxF1cDL9L9sGPcGGA1Kmc0qAVMEbW5+
WObeWEetULK4J+/aGjmMvavIYWgzPJmLzDRWHjteYRiisevZzndBdjBD8PMTt9ERwZddHspX
6YOt3LhI85a9/y9nRXw2gDAWTM4AHK5VC3qqI7nDhga3csikcpgROXCdgq2CS5KaNU6Idfjo
qMUlyP/XtBYxjVLa5LDxi4kqwxszRh4ZOihs3lO0F9Rsg1pTQ6D7Ix2l+pEEgPJ/IHJCMAAm
TkBqhexQQQ0AHsPChSgIC8DcJGLXrkxw+WTpfoF3JFOFCQHciGTg

--rQAi4ZBraoACHIeu
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="dump.719300.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWYCpLbcAAIv////3a/1/dP/eZT/7IMX56s1tfvfdJ/+Bto98z/whXgDbwAJc
AkKoaiRG1GQ0GgDRoBppoADIAAAAGg0AADQBoAyZGg0DTQBiHqeogDTTTTTTCGTIZBhNDRgC
GhgTRkYQZNNGgAwRoYhiaZNMRhGBNGjCaBAGmmmmmmEMmQyDCaGjAENDAmjIwgyaaNABgjQx
DE0yaYjCMCaNGE0AkSQmoR6amamgND1E9TRkwmAnqYahkZNMExDIyHoBpAMJjQJhomn6pkYg
DyZGSPka2XWJFhqUogIIhJkOL4fecDVDEENFQVVICCu963EN3h8suvtpAyoLRu5M7caZTWxl
XYZu4mrMy5p7XKXuiq3SDJ6rV0661nzltn8lNNb12Ks22hv0YkVYFXShPNQKjPu0ZoK+woFa
GPAoBpARPCSBCLLQl84tnz7eTY01DiIv2wnFaC7pABb1ISC52ioFISmaD89vCNC0gpdOF5Xh
zBOwJzFtZb2J5uoElfAXw220mhoYVAkylmVmU6JtDensU0oWC0kQ0enxYJP1try7wLM4s37W
z4OUzvJ++KTMw8ZxgGAJkKCPSAd6otLeRaZrz9DbpljjjqpvRV1+nvpddWq8Nevh2O9v8HD8
fP06d5eZJM3kyrClWsoLlcPT8aexpiMxakMRhAoQhjubpUBDSmlBDAUjW0Qi31kXLoZfkH1S
8hanb+6I26uCVFJIyAmPGXYMPxYDZhFQnf1+cu8Yxlha27/DuWY2Aw1rUqJ50pgVEEbi6+CM
GxcI0dIs1ZP08A0dJl5T/hZ4Zp7HMoFhjsMLQdXaFkyBV9LdaLxgv1/KyHPwyirqyMCXeRqU
tcmDqeHqU3KR5S2/f/W8UqDVKYCqTGQDlaogMJRE+DhxYmtnK4pHMECQhcZ4C0aVJnQSiMYD
Fx8VoyCXM/5aoLj2Vua+J5ytJUDGz0DExCeaZs+ajcCvxZhpTmh0H2QjmYYHIj0Q/iHslT2S
wAEGmIDYhZdHnn6gCIO055V0AcFIx61YnGdEnof/i7kinChIQFSW24A=

--rQAi4ZBraoACHIeu--

--jPC/Tkukgh9ZDT79
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQgGNgAAoJEEMpAov1cw9lpmsP/AjMEf4qVChAkuW+QzLsB1fn
1QpeQhjmcLhoawaMVSWqK9TVmdjg+xzn/11WhahQqs8p3Tcq6xYJlk/6CmoxvGwd
r4ex4ihvB6Dys84XWmllumgc9xM+ByA13vWbwUDaeuJalK7CV+On/b3QzKjv3i+3
6y+KJzdraEc+cAJCPjNpqzI97/4lTxmXFUqeHI1xgERRrqbPlm1cmNB8j4eAPWBW
6lv9AIzpnlRMnvPa9IjhD8JnteRi04c/8gWRlwRgMBb7tev8j83Ms+8vcWHNhG6z
QK2HrhqimuQjRWyYzVo4NFKaeyrwnkeKGweWqCgrSEnh6gR6yeYgvSmZ8oUdX7oC
B0VV2uIjCgG5G8PBqL3gdAGcHM0r8mzgC3xHW0mLQzJPZAcRr9n/6wbRmvXslD+Q
JwJ0VTz/0qBeHq2mJRLh2OVwvaefmGw4TA+zUvr/3PftKiNvtAO+eZmgeUCfnKR9
Sq85Lrmh1Q9KHqeuharPTu8Eztjqt6n2iOwqv0+I6bykN1jXNDv7qfWxgDBPpZ+i
mTK8U3AWtUqwZptyeIo3NUnBKrPchjzYYmTPl8SO2Wwb9KT27WoNG186EG0FZlXi
Gu+xV4nUrtYwH8xqvz2LJqpEDTxhTrDkfib5QjM235yQR1eSk+ov615g0Yc/JqG+
jkoYTV6rICkU0ZARNe9A
=WNuQ
-----END PGP SIGNATURE-----

--jPC/Tkukgh9ZDT79--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
