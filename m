From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Wed, 9 Jan 2013 22:09:43 +0100
Message-ID: <20130109210943.GA22054@wloczykij>
References: <20121129210650.GA4028@wloczykij>
 <1354255744.2090.3.camel@slavad-ubuntu>
 <20121130073219.GB4028@wloczykij>
 <1356415552.2052.11.camel@slavad-ubuntu>
 <20130103214913.GE2080@wloczykij>
 <28ABE57F-66DD-491E-9FDB-A6CE3CF773FB@dubeyko.com>
 <20130104191633.GF2080@wloczykij>
 <C2F4A5DE-538B-4468-9A6A-BA619EDDA462@dubeyko.com>
 <20130105164752.GG2080@wloczykij>
 <504C0292-D0C6-426C-BDFD-1CD50FB32617@dubeyko.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <504C0292-D0C6-426C-BDFD-1CD50FB32617-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?B?0KHQtdGA0LPQtdC5INCQ0LvQtdC60YHQsNC90LTRgNC+0LI=?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--kXdP64Ggrk/fb43R
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 08, 2013 at 03:52:30PM +0300, Vyacheslav Dubeyko wrote:
> Hi guys,
>=20
> I am trying to reproduce the issue last three days but without
> success. I tried different workloads and different environments. As I
> know all of you have the issue in reproduced state. So I have
> additional questions.
>=20
> 1. All of you have such messages:
>=20
> Jan 03 22:36:38 [kernel] [  953.289973] NILFS: bad btree node (blocknr=3D=
26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
> Jan 03 22:36:38 [kernel] [  953.289976] NILFS error (device sda2): nilfs_=
bmap_lookup_contig: broken bmap (inode number=3D102230)

I noticed already, that before I had:
Jan 04 19:40:29 [kernel] [  801.937864] NILFS: bad btree node (blocknr=3D26=
229286): level =3D 67, flags =3D 0xee, nchildren =3D 40

And now it is:
[34101.963275] NILFS: bad btree node (blocknr=3D26229286): level =3D 84, fl=
ags =3D 0x89, nchildren =3D 13348

So different level, flags and nchildren, but blocknr is the same.


> As I understand, you still have message for concrete block number (for
> example, blocknr=3D26229286) during remount. But you haven't the message
> for this block number (for example, blocknr=3D26229286) after umount and
> mount again. But you can get error messages for another block number
> after it. Am I correct?

Looking at my logs I only have an error for the mentioned blocknr.


> Could you share strace output for "cat" command for such corrupted
> file? Maybe syslog can contain some interesting details during
> execution of "cat" command. Could you check syslog for interesting
> error messages during such try?

Attached strace output.


> 3. Could you share configuration file of your kernel (.config)? I
> suspect that you can have some special configuration of your
> environment that I haven't.

Attached.


> 4. Could you share content of nilfs_cleanerd.conf file for NILFS2
> partition that has such issue? Sorry, if I ask about it again.

Attached.



> 5. Did you have any sudden power-off before you encounter the issue
> firstly?

No, I think not.


Piotr Szymaniak.
--=20
 Odpowiedz, nie zastanawiaj=C4=85c si=C4=99: co jest najgro=C5=BAniejsze dl=
a firmowych
danych? Pomy=C5=9Bla=C5=82e=C5=9B o sabota=C5=BCu, hakerach albo szpiegostw=
ie przemys=C5=82owym?
Owszem,  wszystko to prawda,  ale najwi=C4=99kszym zagro=C5=BCeniem dla fir=
mowych
danych s=C4=85 =C5=BC=C3=B3=C5=82te samoprzylepne karteczki.
  -- Ben Rothke, "Computer security"

--u3/rZRmxL6MmkK24
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="config.bz2"
Content-Transfer-Encoding: base64

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
zU30OHlUtU+v4XPr80P/i7kinChIIuTGeoA=

--u3/rZRmxL6MmkK24
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="dmesg_cat.log.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWX78W08AEztfgAAQQGd/8gE1GAq/799gYAZ8Pg4SpQEpCAADAaMhoMIBoBpo
AASICJSmQyAAAAADAaMhoMIBoBpoAAyP/1UoBoaGg0AAxAGgwGjIaDCAaAaaAAClSCaBTTNJ
MTTamZRtJo8keUrwkfoQgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbK0UQ8IHnA84HkQvigfA
hYgfmBnA8oG+oTtIXygaQMQPvA8IH490DSBiBiB1IHniB0oL4wO6B8oHzgdIHPqIXzoO6/d7
CFpUCnvFKACQlvxEKk0/N9AQC1ZlyXkXdyXcVERTjuoANAQCwEAuL4UAEBzsREX1ZJEI1ABK
9xUo+TYhuCdbrU16dzFJKotNRbcRaYkAtobPTl5c/mgAymuTTOw33Iha5wMM4GHBBvuW2GLW
0cbnA0ZMWllY1gZGsDS0ueT5Vw6qaqGZlZkIAJPTtrzLUQ2W3kIA3PEhcIG+325uuAaWCzwX
Egs8i+zTqqnPLe5GIAJF3DvQQCpUMWrITGobGtaYxYRCRLTUwmMUmwmNaMVliwysrRiNLDLa
BkWRnktLFvVDjm3Z3MzMwzsbqlpjFwnMpJb2kx036wQCouli8Wp0SqXivtOnLly35ujqUAHi
pW0xoOoAGLrZ2AKUC2Anicy24KUqDkJlKYzvJKiCJ5cvTC9KsZxWuS3qlRyrWrF1ZmREb1Rx
jNVD6EiiG8h7JHaiqIqozbssEBZGqFB6kAFK7VagApeXTcHVi5/yADaYyU9cnCpp6NGeWezb
EhcYGVpboGneJvxGtiMsSYYk34kwxJoxVuxYYWLnwzJL04medGr1M1tx4qL1TR46m64Xd3dq
as/fA98DuQOBC4kL20F3IH2QPFA7yF9kDWgfZABgIBer3/PXPwez23fsPd9ub0yebHezE7mb
HNu+RebvLKzmR07ndzts5UPmd5zl3w73N6ZPNjvZidzNjm3fIvN3llZzI6dzu522cqO7ye8v
bvDvc3TJ5sd7PK5u8i+3fIvN7m5e92LMzmZw1wz3ZcNfqQu+B4IHdA/ED6awPuQu9A6QMQPG
BlA/EDCB5wPGB/sDSB4oOqBmgbQOMD2QOcDEDygfRB6wORC9PzpA9IHbAwQuyByQcYGSDKBv
7IHXA5wOcDnA9IHptAz64HZA8iFvgZQOkgbQOSD2QMQOuB7oHLdmgesDL2kLCBtA7SFvygcc
QMoHbAzgbaQOkDigbQNYHr1QNYGkD4c4HCBiBtA5wOEDj0gfpA0IXtgcYGUD+4HSBtA9dP14
oN8DEDl0gaoH1gdm3/i7kinChIP34tp4

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="nilfs.conf"

protection_period	3600
min_clean_segments	15%
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

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="strace_cat.log"
Content-Transfer-Encoding: quoted-printable

execve("/bin/cat", ["cat", "/var/tmp/kdecache-malpa/plasma_t"...], [/* 45 v=
ars */]) =3D 0
brk(0)                                  =3D 0x8ba0000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0xb772a000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D105158, ...}) =3D 0
mmap2(NULL, 105158, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0xb7710000
close(3)                                =3D 0
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0\315\1\0004\0\0\0=
"..., 512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D1729888, ...}) =3D 0
mmap2(NULL, 1743644, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0xb7566000
mprotect(0xb7709000, 4096, PROT_NONE)   =3D 0
mmap2(0xb770a000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DE=
NYWRITE, 3, 0x1a3) =3D 0xb770a000
mmap2(0xb770d000, 11036, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_AN=
ONYMOUS, -1, 0) =3D 0xb770d000
close(3)                                =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0xb7565000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb75656c0, limit:1048575,=
 seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_prese=
nt:0, useable:1}) =3D 0
mprotect(0xb770a000, 8192, PROT_READ)   =3D 0
mprotect(0x8052000, 4096, PROT_READ)    =3D 0
mprotect(0xb774c000, 4096, PROT_READ)   =3D 0
munmap(0xb7710000, 105158)              =3D 0
brk(0)                                  =3D 0x8ba0000
brk(0x8bc1000)                          =3D 0x8bc1000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_LARGEFILE|O_CLOEXEC) =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D1716432, ...}) =3D 0
mmap2(NULL, 1716432, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0xb73c1000
close(3)                                =3D 0
fstat64(1, {st_mode=3DS_IFREG|0664, st_size=3D1904, ...}) =3D 0
open("/var/tmp/kdecache-malpa/plasma_theme_Transparent-sima84.kcache", O_RD=
ONLY|O_LARGEFILE) =3D 3
fstat64(3, {st_mode=3DS_IFREG|0664, st_size=3D84213856, ...}) =3D 0
fadvise64_64(3, 0, 0, POSIX_FADV_SEQUENTIAL) =3D 0
read(3, 0x8ba1000, 65536)               =3D -1 EIO (Input/output error)
write(2, "cat: ", 5cat: )                    =3D 5
write(2, "/var/tmp/kdecache-malpa/plasma_t"..., 62/var/tmp/kdecache-malpa/p=
lasma_theme_Transparent-sima84.kcache) =3D 62
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) =3D 4
fcntl64(4, F_GETFD)                     =3D 0x1 (flags FD_CLOEXEC)
fstat64(4, {st_mode=3DS_IFREG|0644, st_size=3D2502, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0xb7729000
read(4, "# Locale name alias data base.\n#"..., 4096) =3D 2502
read(4, "", 4096)                       =3D 0
close(4)                                =3D 0
munmap(0xb7729000, 4096)                =3D 0
open("/usr/share/locale/pl_PL.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) =3D -1 =
ENOENT (No such file or directory)
open("/usr/share/locale/pl_PL.utf8/LC_MESSAGES/libc.mo", O_RDONLY) =3D -1 E=
NOENT (No such file or directory)
open("/usr/share/locale/pl_PL/LC_MESSAGES/libc.mo", O_RDONLY) =3D -1 ENOENT=
 (No such file or directory)
open("/usr/share/locale/pl.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) =3D -1 ENO=
ENT (No such file or directory)
open("/usr/share/locale/pl.utf8/LC_MESSAGES/libc.mo", O_RDONLY) =3D -1 ENOE=
NT (No such file or directory)
open("/usr/share/locale/pl/LC_MESSAGES/libc.mo", O_RDONLY) =3D 4
fstat64(4, {st_mode=3DS_IFREG|0644, st_size=3D143799, ...}) =3D 0
mmap2(NULL, 143799, PROT_READ, MAP_PRIVATE, 4, 0) =3D 0xb739d000
close(4)                                =3D 0
open("/usr/lib/gconv/gconv-modules.cache", O_RDONLY) =3D 4
fstat64(4, {st_mode=3DS_IFREG|0644, st_size=3D26242, ...}) =3D 0
mmap2(NULL, 26242, PROT_READ, MAP_SHARED, 4, 0) =3D 0xb7396000
close(4)                                =3D 0
write(2, ": B\305\202\304\205d wej\305\233cia/wyj\305\233cia", 26: B=C5=82=
=C4=85d wej=C5=9Bcia/wyj=C5=9Bcia) =3D 26
write(2, "\n", 1
)                       =3D 1
close(3)                                =3D 0
close(1)                                =3D 0
close(2)                                =3D 0
exit_group(1)                           =3D ?
+++ exited with 1 +++

--u3/rZRmxL6MmkK24--

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQ7dyXAAoJEEMpAov1cw9lCNEP/2m2HXKdjNSv9WnQP1sBthF5
cH9dO/SzRxDisuEDkHUZM4c1GWi/trhBqpBGNWMpDsdTwwhYTUhaJPASMtwTtNAa
5DXFOq/Xtvtg/BpNrQUKNRCE50jxXRrv22G4ROtdCBuFXCRnrHYZekR3LIuYy7Vg
92PWM3q6FhsOREkEQ3ooNXqWuiRhOFLKCako+WD7dvT0apV6NdDLHVRd6N1F1cUc
hlNwWobcmnT2jvuibaDndHFcMJ1m99hDqnS3BUTXgsZ2bIXivkw6ZahBCFx1/1hT
UsxoPo+YJ3FQgTkGqJ9OsvT26CGJO93voPb+wQHIngRrTL9T0rz2xKT1gLCrQ9AH
MAlDG/VmTusez5AeJAsa69zjBPAXpwHSIZ/yplsEd64Bdid/4gmsiVc+gXbNb6u6
5Hzh/aL51UQXmVsjTW113mENzQxNR8pog5HKW5IhcFVyZ0V9fkQGYAHY0Ns6PDsj
vOKBQi+wAbjfyZ8zc4WMMtsY1mOfQ511MJMAcvwiXRG8G0VGDx9fWGSZqPcRK8tV
1x/WpQvRdrEbtgl+Ewal1TQ4JmRkEhlBG5cquQqTNOTuMTXUL6yLOdS4QbB/VjnL
YJ1HQ4JiM+za7sJtp+UJhuK16yvPHHyDAXQRwkGma+MT77TO/jFQNMHVPtn59FW4
VoZTumP552owOw3BvDAM
=TUI2
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
