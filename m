From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Wed, 10 Oct 2012 22:39:53 +0200
Message-ID: <20121010203952.GD28032@wloczykij>
References: <20121009105239.GV28032@wloczykij>
 <1349784514.1921.9.camel@slavad-ubuntu>
 <20121009135833.GX28032@wloczykij>
 <20121010.012440.17932600.konishi.ryusuke@lab.ntt.co.jp>
 <20121010073912.GA28032@wloczykij>
 <1349865834.1889.95.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UTjKcilERHWBCdCp"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1349865834.1889.95.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--UTjKcilERHWBCdCp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 10, 2012 at 02:43:54PM +0400, Vyacheslav Dubeyko wrote:
> Could you share full output of "nilfs-tune -l"? I can't start analysis wi=
thout superblock's content.

maszyn ~ # nilfs-tune -l /dev/sdf3
nilfs-tune 2.1.4
Filesystem volume name:   (none)
Filesystem UUID:          53760664-f9ed-4c8d-af42-c6ee2f16d956
Filesystem magic number:  0x3434
Filesystem revision #:    2.0
Filesystem features:      (none)
Filesystem state:         invalid or mounted
Filesystem OS type:       Linux
Block size:               4096
Filesystem created:       Fri Aug  3 08:37:06 2012
Last mount time:          Thu Jan  1 01:00:01 1970
Last write time:          Thu Jan  1 01:00:01 1970
Mount count:              56
Maximum mount count:      50
Reserve blocks uid:       0 (user root)
Reserve blocks gid:       0 (group root)
First inode:              11
Inode size:               128
DAT entry size:           32
Checkpoint size:          192
Segment usage size:       16
Number of segments:       922
Device size:              7741636608
First data block:         1
# of blocks per segment:  2048
Reserved segments %:      5
Last checkpoint #:        1873
Last block address:       734128
Last sequence #:          358
Free blocks count:        1150976
Commit interval:          300
# of blks to create seg:  0
CRC seed:                 0x3e0bea06
CRC check sum:            0x2643ad60
CRC check data size:      0x00000118


Piotr Szymaniak.
--=20
 Jedna z g=C5=82=C3=B3w  Zaphoda spojrza=C5=82a w bok.  Druga  zrobi=C5=82a=
  zaraz to samo,
gdy=C5=BC  chcia=C5=82a zobaczy=C4=87,  na co patrzy pierwsza,  nie by=C5=
=82o to jednak nic
konkretnego.
  -- Douglas Adams, "The Hitchhiker's Guide to the Galaxy"

--UTjKcilERHWBCdCp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQdd0YAAoJEEMpAov1cw9lP3kP/Ri7g54EFLyz366zlJTJydYT
z2xNwB/2CHwNE0esldVvPoJODPy7ndzh/zqJX2g0qaJrUMNuNnO7G/2Q0Ah9Alpv
G6ONadGu5hNKEuH45Iv6MUBqlnHWk4c2YYKUsmZYdZrDckD23NlrflICveca0CSF
l+H/Ti6HR8c0dvdvBGHDQs7fNY6FzOiFYRro/eB3amMzUITUmwCL6YTFjH1xvdy4
Y99evjI4yvMgvfbTjvNB96v7bM9RH79AMyt9CW9SCtFIMx4iq0yUytmqLyg2WVmL
itpFNe4QzOaj7JpcD2x6FpvzXjorhSwK2fcZfFVKpWNrvUqPn8d/6sEaRV/7txPN
IECsX0RiSb/3zUhLHqnuVZ5QAaATrpAsB01wXXl2rL77n5cjnz8zlXy901KRDCSo
evm7jEiYWmBNV8OJfUwN8379klAh42zq3QRI4vVLSqNjd1klfVWMUTZBU6PRus8p
73M3T7pNw08duYjvYshP3R+FMUfUA0ELwRZBde91sbcs+zAB3QHrqJCPxKgU3nOZ
Qo8SQM3b/Y0toRkPWsJxVTTyGStRvp8voHxBwFFB96JwZZAJrypPrQpjr4a5ZoWH
M9hXRTWWv0rlEJ4Ok2Ko86J3ivPmStZXm22lIPwDKBn0pDddvgfwKlojWl9eiNnj
jaVquiF05rXsCZsZ+4pU
=DkHp
-----END PGP SIGNATURE-----

--UTjKcilERHWBCdCp--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
