From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs_cleanerd cannot open nilfs on device that exists
Date: Wed, 12 Dec 2012 17:10:54 +0100
Message-ID: <20121212161054.GG3064@wloczykij>
References: <20121212145116.GE3064@wloczykij>
 <20121212145454.GF3064@wloczykij>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IvGM3kKqwtniy32b"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121212145454.GF3064@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--IvGM3kKqwtniy32b
Content-Type: multipart/mixed; boundary="k3qmt+ucFURmlhDS"
Content-Disposition: inline


--k3qmt+ucFURmlhDS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 12, 2012 at 03:54:55PM +0100, Piotr Szymaniak wrote:
> On Wed, Dec 12, 2012 at 03:51:16PM +0100, Piotr Szymaniak wrote:
> > Hello,
> >=20
> > I got a power failure today and after power restore there's a weird
> > issue with nilfs_cleanerd:
> >=20
> > wloczykij ~ # ll /dev/sda3
> > brw-rw---- 1 root disk 8, 3 Dec 12 08:35 /dev/sda3
> >=20
> > wloczykij ~ # mount | grep nilfs
> > /dev/root on / type nilfs2 (rw,relatime)
> > /dev/mapper/backup on /mnt/home_backup type nilfs2 (rw,gcpid=3D2995)
> > /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D5333)
> >=20
> > But when I try to run the cleaner:
> > Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: start
> > Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: cannot open nilfs on
> > /dev/sda3: No such file or directory
> > Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: cannot create cleanerd
> > on /dev/sda3: No such file or directory
> > Dec 12 15:46:17 wloczykij nilfs_cleanerd[5333]: shutdown
> >=20
> > Never happend before. Shutdown should be nice (got UPS monitored by
> > apcupsd, so I hope it worked - was in the middle of the night, so can't
> > really tell if was superclean shutdown).
>=20
> I should also notice, that other cleaner of different drive is working
> without issues:
> wloczykij ~ # ps aux | grep nilfs
> root      2995  0.0  0.0   2348   808 ?        Ss   12:19   0:00
> /sbin/nilfs_cleanerd -n /dev/mapper/backup /mnt/backup

Sorry for answering my own msg again.

Attached strace output.


Piotr Szymaniak.
--=20
Gdzie  w  tym  logika? Po co w ogole sie rodzic,  jesli jedyne,  co cie
czeka u kresu tego wszystkiego, to smierc?
  -- Graham Masterton, "The Burning"

--k3qmt+ucFURmlhDS
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="strace-nilfs_cleanerd.dontexist.out"

execve("/sbin/nilfs_cleanerd", ["/sbin/nilfs_cleanerd", "-c", "/etc/nilfs_cleanerd.conf", "/dev/sda3"], [/* 28 vars */]) = 0
brk(0)                                  = 0x865c000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7727000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=23848, ...}) = 0
mmap2(NULL, 23848, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7721000
close(3)                                = 0
open("/lib/libnilfs.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\240\24\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=18744, ...}) = 0
mmap2(NULL, 21660, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb771b000
mmap2(0xb771f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3) = 0xb771f000
close(3)                                = 0
open("/lib/libnilfsgc.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\20\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=13652, ...}) = 0
mmap2(NULL, 16568, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7716000
mmap2(0xb7719000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2) = 0xb7719000
close(3)                                = 0
open("/lib/librt.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0\36\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=30552, ...}) = 0
mmap2(NULL, 33364, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb770d000
mmap2(0xb7714000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6) = 0xb7714000
close(3)                                = 0
open("/lib/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0\21\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=13808, ...}) = 0
mmap2(NULL, 16588, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7708000
mmap2(0xb770b000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2) = 0xb770b000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320\314\1\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1709408, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7707000
mmap2(NULL, 1719044, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7563000
mmap2(0xb7701000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19e) = 0xb7701000
mmap2(0xb7704000, 11012, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7704000
close(3)                                = 0
open("/lib/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260k\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=124345, ...}) = 0
mmap2(NULL, 107016, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7548000
mmap2(0xb755f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x16) = 0xb755f000
mmap2(0xb7561000, 4616, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7561000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7547000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7547940, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7701000, 8192, PROT_READ)   = 0
mprotect(0xb755f000, 4096, PROT_READ)   = 0
mprotect(0xb770b000, 4096, PROT_READ)   = 0
mprotect(0xb7714000, 4096, PROT_READ)   = 0
mprotect(0xb771f000, 4096, PROT_READ)   = 0
mprotect(0xb7719000, 4096, PROT_READ)   = 0
mprotect(0x804e000, 4096, PROT_READ)    = 0
mprotect(0xb7749000, 4096, PROT_READ)   = 0
munmap(0xb7721000, 23848)               = 0
set_tid_address(0xb75479a8)             = 9341
set_robust_list(0xb75479b0, 12)         = 0
futex(0xbff37f24, FUTEX_WAKE_PRIVATE, 1) = 0
futex(0xbff37f24, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NULL, b7547940) = -1 EAGAIN (Resource temporarily unavailable)
rt_sigaction(SIGRTMIN, {0xb754e540, [], SA_SIGINFO}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0xb754e5c0, [], SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
uname({sys="Linux", node="wloczykij", ...}) = 0
readlink("/dev", 0xbff35baf, 4096)      = -1 EINVAL (Invalid argument)
readlink("/dev/sda3", 0xbff35baf, 4096) = -1 EINVAL (Invalid argument)
brk(0)                                  = 0x865c000
brk(0x867d000)                          = 0x867d000
clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb75479a8) = 9342
exit_group(0)                           = ?
+++ exited with 0 +++

--k3qmt+ucFURmlhDS--

--IvGM3kKqwtniy32b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQyKyOAAoJEEMpAov1cw9ly0AP/05cr5Cw+IYcHZzMKdYCv1mP
8GdoMLuoJPKblvcnM3ZOM0PEXgX4Um/tdB0gOfaBV/bFnfliNQHZ2Ajmz3NvgKTZ
FZFckYqG2PVVruCjCzsI4jZzertR9fFHcryEPnwjqCt3EY6JU+tYXUQUarJ6/5SF
RkPCT7jVhaszE84D10va2YC4tvQ8x6QmXXKd+yXpu03nGQ8JxLtC9Cw3C84w7TgV
d732PSutWonQTUQfI0lPw1UWPy56f2sdGyyzJMtdUrjpNfpnhC1Da+w/jpwhLiaP
/AL3OoBHBgetbKtPDQi2MhWFfzdlc5MNtAaWzdLNXp4Bsqi5J2qwCERlV/ldkf+O
AD3BwJ2jYo2lg3b0PQ6QwT6fvNx7amm2iFZ11MM5Gn8UbDtTvWjVRr96daEzRjR4
mlvyJ44SE0XJNcZiTO8IE4JX55RK7vPVIQNL54lFr/TDwhoNgr2Ao29bCBEZG7Nl
HDyemw6uGYvYoOzTu+sxXvCVcACdkwUqKVnw5ViaO0/cJlDjmhSqufNntVsY6A1Y
+44PRFLgdiqpv+cScTaBaeR82ZJc+xN7TLUPqdqKLOm+hFcMLsIqNzFnmjN+Sq6G
hMmeVqcM5930Zb9imsO91/Ll/8WZqMoI1rf1DILdoyjN89199MHXFuKhjoI6Hw3i
nkHCDUl7TgLJLA/yzynI
=MeHI
-----END PGP SIGNATURE-----

--IvGM3kKqwtniy32b--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
