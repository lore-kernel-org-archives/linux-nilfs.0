From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: snapshots contain the same rrd database
Date: Wed, 26 Feb 2014 14:32:02 +0100
Message-ID: <20140226133201.GA2022@wloczykij>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I got a system crash after some 160+ days uptime. After a hard reboot I
noticed my rrd database looks corrupted.

So I changed some recent checkpoints to snapshots, mounted them and...
all the rrd files are the same!

Here's some info about current state:

wloczykij ~ # lscp /dev/sda3 | grep ss
    211211  2014-02-22 16:58:11   ss    -          119      54904
    211219  2014-02-22 18:18:28   ss    -          124      54910
    211811  2014-02-25 00:39:21   ss    -          140      54922
    211872  2014-02-25 09:47:16   ss    -          160      54922
    212008  2014-02-26 01:13:14   ss    -          114      54929
    212026  2014-02-26 03:22:45   ss    -           28      54928
    212042  2014-02-26 04:13:48   ss    -           29      54928
    212045  2014-02-26 04:24:00   ss    -           29      54928

wloczykij ~ # mount | grep cp
/dev/sda3 on /tmp/211219 type nilfs2 (ro,cp=3D211219)
/dev/sda3 on /tmp/211211 type nilfs2 (ro,cp=3D211211)
/dev/sda3 on /tmp/212026 type nilfs2 (ro,cp=3D212026)
/dev/sda3 on /tmp/212045 type nilfs2 (ro,cp=3D212045)

wloczykij ~ # for sumrrd in 211219 211211 212026 212045; do md5sum /tmp/$su=
mrrd/var/www/grubelek.pl/termometr/temp0.rrd; done
71f60c620a493021bb5e1c32c555abe8  /tmp/211219/var/www/grubelek.pl/termometr=
/temp0.rrd
71f60c620a493021bb5e1c32c555abe8  /tmp/211211/var/www/grubelek.pl/termometr=
/temp0.rrd
71f60c620a493021bb5e1c32c555abe8  /tmp/212026/var/www/grubelek.pl/termometr=
/temp0.rrd
71f60c620a493021bb5e1c32c555abe8  /tmp/212045/var/www/grubelek.pl/termometr=
/temp0.rrd

This is bad news! What should I do next? All the rrd dumps have the same
modification date:
<lastupdate>1376166602</lastupdate> <!-- 2013-08-10 22:30:02 CEST -->
(looks previous boot before the crash?)

I just moved the rrd to btrfs and made a subvolume snapshot and after about=
 an
hour rrd files are different:

wloczykij ~ # md5sum /home/services/termometr/temp0.rrd /home/snapshot-2014=
-02-26/services/termometr/temp0.rrd
2999dc7071d94e701d5246d79ccc488f  /home/services/termometr/temp0.rrd
1621f31fb7c27f1f3c0b0d8f0f5ede9e  /home/snapshot-2014-02-26/services/termom=
etr/temp0.rrd


wloczykij ~ # nilfs-tune -l /dev/sda3
nilfs-tune 2.1.5
Filesystem volume name:   (none)
Filesystem UUID:          f18e80b1-f3c1-49ec-baa5-39c0edc4c0b9
Filesystem magic number:  0x3434
Filesystem revision #:    2.0
Filesystem features:      (none)
Filesystem state:         invalid or mounted
Filesystem OS type:       Linux
Block size:               4096
Filesystem created:       Sat Aug 13 10:36:21 2011
Last mount time:          Wed Feb 26 09:33:53 2014
Last write time:          Wed Feb 26 14:15:29 2014
Mount count:              59
Maximum mount count:      50
Reserve blocks uid:       0 (user root)
Reserve blocks gid:       0 (group root)
First inode:              11
Inode size:               128
DAT entry size:           32
Checkpoint size:          192
Segment usage size:       16
Number of segments:       465
Device size:              3908042752
First data block:         1
# of blocks per segment:  2048
Reserved segments %:      5
Last checkpoint #:        212170
Last block address:       546866
Last sequence #:          35128
Free blocks count:        227328
Commit interval:          600
# of blks to create seg:  0
CRC seed:                 0x1a1e847d
CRC check sum:            0x57f59c5c
CRC check data size:      0x00000118

wloczykij ~ # uname -sr
Linux 3.4.56



Piotr Szymaniak.
--=20
(...) post=C4=85pili tak,  jakby odkryli zasady  rz=C4=85dz=C4=85ce  fizyk=
=C4=85  kwantow=C4=85,
a nast=C4=99pnie  wykorzystali je do zaprojektowania  nowej gry telewizyjnej
- a potem, co gorsza,  doszli do wniosku, =C5=BCe ca=C5=82a fizyka kwantowa=
 tylko
do tego si=C4=99 nadaje...
  -- Stephen King, "Dreamcatcher"

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDezRAAoJEEMpAov1cw9lK7MQALHZHpMwU1TXkQlCQZXqPer8
N7UOYwSwIdXBzFXLLSQTB4D7vPs1q7JC3ydyBO2vtFZa/fWvZeowKVEfr6bF/jMj
kwNiM/xfU6UoGLOQaBD7dPkcm2k/EYg5N/nhuL261NMlNutnGmVOt01MzNm2MD/f
aCgK1VNvYyVLuOw8tK3OVxTOAd0FJBSjeLj2d6/5hGkd3zhw1q7hLGophNfSucsy
PPUdtFY2QBoL/dix7GFVCWsXQ1fW7K9d4RC2YEXvL0WD7/3HRF4JAMhyjaOxAZy8
rjIQz3NDxoR+F5+ImLL6lEoZhSFaDEpbLJsdxkJjwmPsjebK6YmdIsISvnlqTE7Y
SHBjNuL1dDQyNR3MLY7l75/Mthg4K6ySOXc1TejiqLklS1vHMCisyXcT/0xQFuBj
bsKsmxpLgLZp1e8Yn/zPEf9aHo4GLQvaHgkkdwj+ZsjL2FGQj9hD+XtyEeeigOfz
adCORRwLu1j4Jv6ak8KGu2CQri5v+qqoEY4N87cMRgCIjYSQ2Fp5oK18v3fNvCJM
R1Kr9aWEzRJlo2BjK+zJOh912aCJ9mhN2T/WvmGy8FdeaAvP8FxorJUeF3E7Z0nx
XsSlcvoIgKdVkVPFZ8Z6bPbMhS4mEYIK0bxm7rg2VUmp+11KOlo5riFMsxV0SIKz
1yk6rnf9BkFUKzapw81C
=UaXe
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
