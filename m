From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Tue, 10 Jul 2012 11:50:08 +0200
Message-ID: <20120710095008.GW1478@wloczykij>
References: <20120709073300.GP1478@wloczykij>
 <10181027.pPHs7IDARt@coil>
 <20120710075131.GV1478@wloczykij>
 <1341909282.1973.3.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ahZICQ7iXVM/oLYH"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1341909282.1973.3.camel@slavad-ubuntu-11>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--ahZICQ7iXVM/oLYH
Content-Type: multipart/mixed; boundary="JEhTuUFIcUlI65CC"
Content-Disposition: inline


--JEhTuUFIcUlI65CC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2012 at 12:34:42PM +0400, Vyacheslav Dubeyko wrote:
> Hi Piotr,
>=20
> Could you send your output of "strace -f"? I guess that it is problem
> with semaphore opening as I can see in my reproduction. But it needs to
> compare our cases.

I'm not a strace guru, but it looks like some issue with new udev (or
whatever creating devices/symlinks in /dev). Right now I'm missing /dev/root
at machine with issues with nilfs_cleanerd:

maszyn ~ (: LANG=3D"C" ls -l /dev/root
ls: cannot access /dev/root: No such file or directory

While on the other:
wloczykij ~ (: LANG=3D"C" ls -l /dev/root
lrwxrwxrwx 1 root root 4 Jun 27 21:50 /dev/root -> sda3

strace -f log attached.

Piotr Szymaniak.



> On Tue, 2012-07-10 at 09:51 +0200, Piotr Szymaniak wrote:
> > On Mon, Jul 09, 2012 at 11:33:13AM +0200, dexen deVries wrote:
> > > On Monday 09 of July 2012 09:33:00 you wrote:
> > > >(...)
> > > > Where to go from this point? How to debug nilfs_cleanerd issue?
> > >=20
> > > using strace -f  on the nilfs_cleanerd should give you a clue what ca=
uses the=20
> > > exit. it may exit if can't connect to syslogd.
> >=20
> > Hi list,
> >=20
> > I will try to sort information from few messages together here.
> >=20
> > Attached strace output from my "nilfs_cleanerd" for rootfs. The script
> > is in /etc/local.d (again, Gentoo Linux) and it looks like this (removed
> > commented parts and empty lines):
> > CONFILE=3D"/etc/nilfs_cleanerd_rootfs.conf"
> > TARGETDISK=3D"/dev/disk/by-uuid/1aa9e6fb-cf7d-45bd-bbfb-08110a8840b7"
> > /sbin/nilfs_cleanerd -c "${CONFILE}" "${TARGETDISK}"
> >=20
> > And here's the mentioned nilfs_cleanerd_rootfs.conf:
> > protection_period	3600
> > min_clean_segments	13%
> > max_clean_segments	25%
> > clean_check_interval	10
> > selection_policy	timestamp	# timestamp in ascend order
> > nsegments_per_clean	2
> > mc_nsegments_per_clean	4
> > cleaning_interval	5
> > mc_cleaning_interval	1
> > retry_interval		60
> > use_mmap
> > log_priority		info
> >=20
> >=20
> > > if `lscp' reports no checkpoints, try `lscp -a' -- should show even m=
inor=20
> > > checkpoints (which are checkpoints created by GC, AFAIK).
> >=20
> > That's right, lscp -a gives some more output:
> > maszyn ~ # lscp -a | wc -l
> > 1428
> >=20
> > Running nilfs_cleanerd with more verbose output (log_priority debug)
> > gives me this:
> > Jul 10 09:45:26 [nilfs_cleanerd] start
> > Jul 10 09:45:26 [nilfs_cleanerd] cannot open nilfs on /dev/sda2: No such
> > file or directory
> > Jul 10 09:45:26 [nilfs_cleanerd] cannot create cleanerd on /dev/sda2: No
> > such file or directory
> > Jul 10 09:45:26 [nilfs_cleanerd] shutdown
> >=20
> >=20
> > maszyn ~ # ll /dev/sda2
> > brw-rw---- 1 root disk 8, 2 lip 10  2012 /dev/sda2
> >=20
> > maszyn ~ # ll /dev/disk/by-uuid/1aa9e6fb-cf7d-45bd-bbfb-08110a8840b7=20
> > lrwxrwxrwx 1 root root 10 lip 10  2012
> > /dev/disk/by-uuid/1aa9e6fb-cf7d-45bd-bbfb-08110a8840b7 -> ../../sda2
> >=20
> >=20
> > Piotr Szymaniak.
>=20

--=20
(...) wszystko to sprawilo,  iz przekroczyl owa umowna  granice,  ktora
jego przyjaciel,  prawnik Dan Tabares,  nazywal linia MTWD. Gdy raz juz
przekroczyles linie  MTWD  cokolwiek by sie zdarzylo, ty po prostu Masz
To W Dupie.
  -- Graham Masterton, "The Burning"

--JEhTuUFIcUlI65CC
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="nilfs2.strace-f.log"

execve("/sbin/nilfs_cleanerd", ["nilfs_cleanerd", "-c", "/etc/nilfs_cleanerd_rootfs.conf", "/dev/disk/by-uuid/1aa9e6fb-cf7d-"...], [/* 41 vars */]) = 0
brk(0)                                  = 0x9121000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7798000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=108478, ...}) = 0
mmap2(NULL, 108478, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb777d000
close(3)                                = 0
open("/lib/libnilfs.so.0", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0 \25\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=22884, ...}) = 0
mmap2(NULL, 25800, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7776000
mmap2(0xb777b000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x4) = 0xb777b000
close(3)                                = 0
open("/lib/libnilfsgc.so.0", O_RDONLY)  = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\20\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=17748, ...}) = 0
mmap2(NULL, 20664, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7770000
mmap2(0xb7774000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3) = 0xb7774000
close(3)                                = 0
open("/lib/librt.so.1", O_RDONLY)       = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\36\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=34648, ...}) = 0
mmap2(NULL, 37488, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7766000
mmap2(0xb776e000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x7) = 0xb776e000
close(3)                                = 0
open("/lib/libuuid.so.1", O_RDONLY)     = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\340\22\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=17928, ...}) = 0
mmap2(NULL, 20712, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7760000
mmap2(0xb7764000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3) = 0xb7764000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\240\306\1\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1536064, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb775f000
mmap2(NULL, 1550904, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb75e4000
mprotect(0xb7758000, 4096, PROT_NONE)   = 0
mmap2(0xb7759000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x174) = 0xb7759000
mmap2(0xb775c000, 10808, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb775c000
close(3)                                = 0
open("/lib/libpthread.so.0", O_RDONLY)  = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20k\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=124430, ...}) = 0
mmap2(NULL, 107020, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb75c9000
mmap2(0xb75e0000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x16) = 0xb75e0000
mmap2(0xb75e2000, 4620, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb75e2000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb75c8000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb75c8910, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb75e0000, 4096, PROT_READ)   = 0
mprotect(0xb7759000, 8192, PROT_READ)   = 0
mprotect(0xb7764000, 4096, PROT_READ)   = 0
mprotect(0xb776e000, 4096, PROT_READ)   = 0
mprotect(0xb7774000, 4096, PROT_READ)   = 0
mprotect(0xb777b000, 4096, PROT_READ)   = 0
mprotect(0x804f000, 4096, PROT_READ)    = 0
mprotect(0xb77b8000, 4096, PROT_READ)   = 0
munmap(0xb777d000, 108478)              = 0
set_tid_address(0xb75c8978)             = 2246
set_robust_list(0xb75c8980, 12)         = 0
futex(0xbff0883c, FUTEX_WAKE_PRIVATE, 1) = 0
futex(0xbff0883c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NULL, b75c8910) = -1 EAGAIN (Resource temporarily unavailable)
rt_sigaction(SIGRTMIN, {0xb75cf4c0, [], SA_SIGINFO}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0xb75cf540, [], SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
uname({sys="Linux", node="maszyn", ...}) = 0
readlink("/dev", 0xbff0649f, 4096)      = -1 EINVAL (Invalid argument)
readlink("/dev/disk", 0xbff0649f, 4096) = -1 EINVAL (Invalid argument)
readlink("/dev/disk/by-uuid", 0xbff0649f, 4096) = -1 EINVAL (Invalid argument)
readlink("/dev/disk/by-uuid/1aa9e6fb-cf7d-45bd-bbfb-08110a8840b7", "../../sda2", 4096) = 10
brk(0)                                  = 0x9121000
brk(0x9142000)                          = 0x9142000
readlink("/dev/sda2", 0xbff0649f, 4096) = -1 EINVAL (Invalid argument)
clone(Process 2247 attached
child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb75c8978) = 2247
[pid  2246] exit_group(0)               = ?
[pid  2247] setsid()                    = 2247
[pid  2247] chdir("/" <unfinished ...>
[pid  2246] +++ exited with 0 +++
<... chdir resumed> )                   = 0
close(0)                                = 0
close(1)                                = 0
close(2)                                = 0
open("/dev/null", O_RDONLY|O_LARGEFILE) = 0
open("/dev/null", O_WRONLY|O_LARGEFILE) = 1
open("/dev/null", O_WRONLY|O_LARGEFILE) = 2
time(NULL)                              = 1341913492
open("/etc/localtime", O_RDONLY)        = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=2679, ...}) = 0
fstat64(3, {st_mode=S_IFREG|0644, st_size=2679, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7797000
read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\n\0\0\0\0"..., 4096) = 2679
_llseek(3, -28, [2651], SEEK_CUR)       = 0
read(3, "\nCET-1CEST,M3.5.0,M10.5.0/3\n", 4096) = 28
close(3)                                = 0
munmap(0xb7797000, 4096)                = 0
socket(PF_FILE, SOCK_DGRAM|SOCK_CLOEXEC, 0) = 3
connect(3, {sa_family=AF_FILE, sun_path="/dev/log"}, 110) = 0
send(3, "<30>Jul 10 11:44:52 nilfs_cleane"..., 47, MSG_NOSIGNAL) = 47
open("/dev/sda2", O_RDONLY|O_LARGEFILE) = 4
ioctl(4, BLKGETSIZE64, 25769803776)     = 0
_llseek(4, 1024, [1024], SEEK_SET)      = 0
read(4, "\2\0\0\0\0\00044\30\1\0\0\221\fK\363\265~$\234\2\0\0\0\377\v\0\0\0\0\0\0"..., 1024) = 1024
_llseek(4, 25769799680, [25769799680], SEEK_SET) = 0
read(4, "\2\0\0\0\0\00044\30\1\0\0\221\fK\363\265~$\234\2\0\0\0\377\v\0\0\0\0\0\0"..., 1024) = 1024
readlink("/dev", 0xbff04bef, 4096)      = -1 EINVAL (Invalid argument)
readlink("/dev/sda2", 0xbff04bef, 4096) = -1 EINVAL (Invalid argument)
open("/proc/mounts", O_RDONLY|O_LARGEFILE) = 5
fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7797000
read(5, "rootfs / rootfs rw 0 0\n/dev/root"..., 1024) = 1024
readlink("/dev", 0xbff04bef, 4096)      = -1 EINVAL (Invalid argument)
readlink("/dev/root", 0xbff04bef, 4096) = -1 ENOENT (No such file or directory)
read(5, " 0 0\n/dev/sdd5 /mnt/de fuseblk r"..., 1024) = 207
read(5, "", 1024)                       = 0
close(5)                                = 0
munmap(0xb7797000, 4096)                = 0
time(NULL)                              = 1341913492
send(3, "<27>Jul 10 11:44:52 nilfs_cleane"..., 99, MSG_NOSIGNAL) = 99
time(NULL)                              = 1341913492
send(3, "<27>Jul 10 11:44:52 nilfs_cleane"..., 104, MSG_NOSIGNAL) = 104
time(NULL)                              = 1341913492
send(3, "<30>Jul 10 11:44:52 nilfs_cleane"..., 50, MSG_NOSIGNAL) = 50
close(3)                                = 0
exit_group(1)                           = ?
+++ exited with 1 +++


--JEhTuUFIcUlI65CC--

--ahZICQ7iXVM/oLYH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJP+/rQAAoJEEMpAov1cw9l5QEQAKa/iDC8e91nBDAq1JhXCmXM
ESM+OD0hQUxYc/maHj64w7jNXsDYgRrWGO8fCBnByq2cf41UvJcXlKXCFrJOp2ZR
MkFIDYD5tO1KD5CpQCl8zRc8fU898rmy7XQd3GtxGV5e95KxkidIfaRkqHJP/bmR
9cjoiPg61REnQWAekiNXiZ0kRb9vuCYgUloUNlFKEmXBs+6iIZa+0gVSUYMggs4U
b9PXEyXIexwkKk/PShe/zLtcz9Pm7Pcuzo1v5tcNVop/wLkrZnYlPJNrMhpjMlkL
fTsHwMoSf0OGRJlHoBnSPOObzqTr0cKIIsvs1yJu8CGlwjFKd3QGSsorT5MN9Urg
1lekjXgxccXXhAVnUt/6IUB4r3fctxzkQOTI/jCzP1fIsKdxaExhtmxD6HMiN4jq
b+XGchTAs6c77EzNMTA7JxEInKOca1EZiP4WvZcKpEwbejjmLJn0pEDIkYwOyn9A
gqBYPUECkSG1XjIhgyAFBnARVIdi81Y/fsPmazxEb0Fad74RHLyaCPUMCUGkVUqq
28P/wseIhElFHPpYPtrR0Z4hd92bmk++LAm6IxBJpjrtw+w3glJLsOEur9m0xWkI
34sYe+BnY9ApeUMz4P8v5Uk0UCn+nd/YeMJzR36zJ3nCDF2ahis/BU9kbFIzoKY5
Yj9UobVDJWKgCVKrK7Yw
=WSvT
-----END PGP SIGNATURE-----

--ahZICQ7iXVM/oLYH--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
