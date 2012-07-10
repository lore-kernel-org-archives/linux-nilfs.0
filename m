From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Tue, 10 Jul 2012 11:18:54 +0400
Message-ID: <1341904734.1980.17.camel@slavad-ubuntu-11>
References: <1341826112.1965.6.camel@slavad-ubuntu-11>
	 <20120709165626.GT1478@wloczykij>
	 <51D5FCEA-7103-4D4A-BADA-99A9780D9B68@dubeyko.com>
	 <20120710.105315.33988123.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-hOWRjUff+E3T0Ud+ya6D"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=04eD8Eo/fKLLkYZh3Xkz+EAVpzJIkvv3pxbH/FaZcqE=;
	b=MRXPgLcLIcLb5rKrhcfZRUR6nK+aSWB8SE748hvZlvb1wg8KZc2RshtTVDHVsL+pQ9SGuxDGOApSs4WRT+9yGhP1DdWnf87Jkcxsbnos6df6Bx71nqFdrNaAzhIA+Mi3;
In-Reply-To: <20120710.105315.33988123.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--=-hOWRjUff+E3T0Ud+ya6D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ryusuke,

Unfortunately, my kernel is compiled with enabled CONFIG_SHMEM and
CONFIG_TMPFS options. Moreover, I can see that /dev/shm mounted with
tmpfs type:

linux-2.6.34-gentoo-r6 # mount
/dev/sda3 on / type xfs (rw,noatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
udev on /dev type tmpfs (rw,nosuid,relatime,size=3D10240k,mode=3D755)
devpts on /dev/pts type devpts
(rw,nosuid,noexec,relatime,gid=3D5,mode=3D620)
shm on /dev/shm type tmpfs (rw,noexec,nosuid,nodev)
usbfs on /proc/bus/usb type usbfs
(rw,noexec,nosuid,devmode=3D0664,devgid=3D85)
/dev/sdb2 on /mnt/nilfs2 type nilfs2 (rw,gcpid=3D6331)

And it is possible to see it from strace output also (tmpfs magic -
0x1021994):

statfs("/dev/shm", {f_type=3D0x1021994, f_bsize=3D4096, f_blocks=3D64251,
f_bfree=3D64250, f_bavail=3D64250, f_files=3D64251, f_ffree=3D64249, f_fsid=
=3D{0,
0}, f_namelen=3D255, f_frsize=3D4096}) =3D 0

However, I have not last stable kernel on its machine
(2.6.34-gentoo-r6). Maybe, it can make some side effects.

I am going to continue investigation of the issue. I attach to the
e-mail full strace output (10-07-2012-nilfs-cleanerd-issue.txt).

With the best regards,
Vyacheslav Dubeyko.

On Tue, 2012-07-10 at 10:53 +0900, Ryusuke Konishi wrote:
> Hi Vyacheslav,
> On Mon, 9 Jul 2012 22:55:40 +0400, Vyacheslav Dubeyko wrote:
> > Hi Piotr,
> >=20
> > You are right. I can reproduce this issue very simply. The nilfs_cleane=
rd doesn't started during mount really.
> >=20
> > I can detect some suspicious output of strace during mount and next try=
ing to start of nilfs_cleanerd:
> >=20
> > ....
> > set_tid_address(0xb76a0768)             =3D 21036
> > set_robust_list(0xb76a0770, 0xc)        =3D 0
> > futex(0xbfdd4f90, FUTEX_WAKE_PRIVATE, 1) =3D 0
> > futex(0xbfdd4f90, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NU=
LL, bfdd4fa0) =3D -1 EAGAIN (Resource temporarily unavailable)
> >=20
> > ....
> > mq_open("nilfs-cleanerq-2066", O_RDONLY|O_CREAT, 0600, {mq_maxmsg=3D6, =
mq_msgsize=3D4096}) =3D -1 ENOSYS (Function not implemented)
> >=20
> > But maybe it is not reason of the problem. It needs to investigate the =
issue more deeply.
>=20
> Your problem looks that of FAQ #8 on http://www.nilfs.org/en/faq.html
>=20
> >  8. cleanerd (or chcp/mkcp command) fails with an error: ``cannot open
> >     nilfs on /dev/xxx: Function not implemented''.
> >
> >  Confirm whether tmpfs (former shm fs) is mounted on /dev/shm. POSIX
> >  semaphores do not work if the filesystem on /dev/shm is wrong,
> >  which causes the above failure.
> >
> >  Some systems are using ramfs instead of tmpfs. You may need to
> >  change kernel configuration and rebuild kernel to enable tmpfs.
>=20
> Please confirm if tmpfs is mounted on /dev/shm.
>=20
> The same issue is reported on the following thread:
>=20
>   http://marc.info/?t=3D133190016900003&r=3D1&w=3D2
>=20
>=20
> Regards,
> Ryusuke Konishi
>=20
> > Thanks,
> > Vyacheslav Dubeyko.
> >=20
> > On Jul 9, 2012, at 8:56 PM, Piotr Szymaniak wrote:
> >=20
> > > On Mon, Jul 09, 2012 at 01:28:32PM +0400, Vyacheslav Dubeyko wrote:
> > >> Hi Piotr,
> > >>=20
> > >> Does system journals on your machines contain any interested details
> > >> about reported issue? Could you try to extract some error or warning
> > >> messages from system journal?
> > >=20
> > > (resend as I replied only to Vyacheslav)
> > >=20
> > > If by journals you mean logs then no. I'm only able to find some like
> > > this:
> > > Jul  3 10:32:45 wloczykij nilfs_cleanerd[1434]: resume (clean check)
> > > Jul  3 10:41:37 wloczykij nilfs_cleanerd[1434]: pause (clean check)
> > >=20
> > > That's all about nilfs in the last week and current log has only manu=
al
> > > runs related to those operation described before.
> > >=20
> > > Piotr Szymaniak.
> > >=20
> > >=20
> > >> On Mon, 2012-07-09 at 09:33 +0200, Piotr Szymaniak wrote:
> > >>> Hi.
> > >>>=20
> > >>> I've upgraded nilfs-utils (running Gentoo) on 29 july. Today I ran =
out
> > >>> of space on my / and found that nilfs_cleanerd isn't working. When =
I
> > >>> start it from the command line it exits instantly. Also, all previo=
us
> > >>> checkpoints on / (also on two other mountpoints on different machin=
e)
> > >>> are gone.
> > >>>=20
> > >>> What I did? Downgraded nilfs-utils to 2.1.1, remounted mountpoints.=
 On
> > >>> the second machine it's runnig fine (cleaned _all_ checkpoints), on=
 the
> > >>> first one with disk space issue it exits just like 2.1.3.
> > >>>=20
> > >>> Here are some fs details. Machine with disk space issues, rootfs:
> > >>>    CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
> > >>> 147688  2012-07-09 08:38:14   cp    -        11075     242915
> > >>> 147689  2012-07-09 08:38:14   cp    -           60     242895
> > >>> (=E2=80=A6)
> > >>> 148999  2012-07-09 09:13:46   cp    -           60     242888
> > >>> 149000  2012-07-09 09:19:45   cp    -           44     242888
> > >>>=20
> > >>> Filesystem      Size  Used Avail Use% Mounted on
> > >>> rootfs           24G   13G   11G  56% /
> > >>>=20
> > >>> mount shows:
> > >>> /dev/sda2 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D15356)
> > >>>=20
> > >>> There's no nilfs_cleanerd with pid 15356.
> > >>>=20
> > >>>=20
> > >>> Second machine rootfs:
> > >>>   CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
> > >>> 92246  2012-07-09 08:16:58   cp    -          118      44669
> > >>> (=E2=80=A6)
> > >>> 92439  2012-07-09 09:19:14   cp    -           29      44668
> > >>> 92440  2012-07-09 09:19:46   cp    -           33      44668
> > >>>=20
> > >>> Filesystem         Size  Used Avail Use% Mounted on
> > >>> rootfs             3.7G  888M  2.6G  26% /
> > >>>=20
> > >>> (it should be around 3G used)
> > >>>=20
> > >>> Second machine second mountpoint:
> > >>>   CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
> > >>>  1496  2012-07-09 03:31:23   cp    -         8837     132766
> > >>>  1497  2012-07-09 03:31:26   cp    -          468     132766
> > >>>  1498  2012-07-09 03:41:27   cp    -         1474     132765
> > >>>=20
> > >>> (this fs should containt *all* 1498 checkpoints)
> > >>>=20
> > >>> Filesystem         Size  Used Avail Use% Mounted on
> > >>> /dev/dm-2          117G   58G   54G  76% /mnt/home_backup
> > >>>=20
> > >>> (in this one it should be around 100G of used space)
> > >>>=20
> > >>> mount:
> > >>> /dev/dm-2 on /mnt/home_backup type nilfs2 (rw,gcpid=3D13135)
> > >>> /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D1363)
> > >>>=20
> > >>> Both cleaners running (the second mountpoint - /mnt/home_backup - i=
s under
> > >>> heavy load and I suppose it will end with around 20G used space).
> > >>>=20
> > >>> Where to go from this point? How to debug nilfs_cleanerd issue?
> > >>>=20
> > >>>=20
> > >>> Piotr Szymaniak.
> > >>=20
> > >>=20
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-nilf=
s" in
> > >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >=20
> > > --=20
> > > Marriage is like a coffin and each kid is like another nail.
> > >  -- Homer Simpson
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=-hOWRjUff+E3T0Ud+ya6D
Content-Disposition: attachment; filename="10-07-2012-nilfs-cleanerd-issue.txt"
Content-Type: text/plain; name="10-07-2012-nilfs-cleanerd-issue.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

slavad-gentoo-pc linux-2.6.34-gentoo-r6 # strace -f nilfs_cleanerd
execve("/sbin/nilfs_cleanerd", ["nilfs_cleanerd"], [/* 27 vars */]) = 0
brk(0)                                  = 0x8051000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7702000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=13973, ...}) = 0
mmap2(NULL, 13973, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb76fe000
close(3)                                = 0
open("/usr/lib/libnilfs.so.0", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\340\22\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=58978, ...}) = 0
mmap2(NULL, 21704, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb76f8000
mmap2(0xb76fc000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3) = 0xb76fc000
close(3)                                = 0
open("/usr/lib/libnilfsgc.so.0", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320\16\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=41262, ...}) = 0
mmap2(NULL, 16568, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb76f3000
mmap2(0xb76f6000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2) = 0xb76f6000
close(3)                                = 0
open("/lib/librt.so.1", O_RDONLY)       = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`\31\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=30552, ...}) = 0
mmap2(NULL, 33392, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb76ea000
mmap2(0xb76f1000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6) = 0xb76f1000
close(3)                                = 0
open("/lib/libuuid.so.1", O_RDONLY)     = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P\21\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=13872, ...}) = 0
mmap2(NULL, 16604, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb76e5000
mmap2(0xb76e8000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2) = 0xb76e8000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20m\1\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1323292, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb76e4000
mmap2(NULL, 1333544, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb759e000
mmap2(0xb76de000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x13f) = 0xb76de000
mmap2(0xb76e1000, 10536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb76e1000
close(3)                                = 0
open("/lib/libpthread.so.0", O_RDONLY)  = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0J\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=116790, ...}) = 0
mmap2(NULL, 98796, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7585000
mmap2(0xb759a000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x14) = 0xb759a000
mmap2(0xb759c000, 4588, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb759c000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7584000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7584700, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb759a000, 4096, PROT_READ)   = 0
mprotect(0xb76de000, 8192, PROT_READ)   = 0
mprotect(0xb76e8000, 4096, PROT_READ)   = 0
mprotect(0xb76f1000, 4096, PROT_READ)   = 0
mprotect(0xb76f6000, 4096, PROT_READ)   = 0
mprotect(0xb76fc000, 4096, PROT_READ)   = 0
mprotect(0x804e000, 4096, PROT_READ)    = 0
mprotect(0xb7720000, 4096, PROT_READ)   = 0
munmap(0xb76fe000, 13973)               = 0
set_tid_address(0xb7584768)             = 3805
set_robust_list(0xb7584770, 0xc)        = 0
futex(0xbfcde720, FUTEX_WAKE_PRIVATE, 1) = 0
futex(0xbfcde720, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NULL, bfcde730) = -1 EAGAIN (Resource temporarily unavailable)
rt_sigaction(SIGRTMIN, {0xb75893e0, [], SA_SIGINFO}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0xb75898d0, [], SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
uname({sys="Linux", node="slavad-gentoo-pc", ...}) = 0
clone(Process 3806 attached
child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7584768) = 3806
[pid  3805] exit_group(0)               = ?
setsid()                                = 3806
chdir("/")                              = 0
close(0)                                = 0
close(1)                                = 0
close(2)                                = 0
open("/dev/null", O_RDONLY|O_LARGEFILE) = 0
open("/dev/null", O_WRONLY|O_LARGEFILE) = 1
open("/dev/null", O_WRONLY|O_LARGEFILE) = 2
brk(0)                                  = 0x8051000
brk(0x8072000)                          = 0x8072000
time(NULL)                              = 1337504136
open("/etc/localtime", O_RDONLY)        = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=2194, ...}) = 0
fstat64(3, {st_mode=S_IFREG|0644, st_size=2194, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7701000
read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\f\0\0\0\f\0\0\0\0"..., 4096) = 2194
_llseek(3, -27, [2167], SEEK_CUR)       = 0
read(3, "\nMSK-3MSD,M3.5.0,M10.5.0/3\n", 4096) = 27
close(3)                                = 0
munmap(0xb7701000, 4096)                = 0
socket(PF_FILE, SOCK_DGRAM|SOCK_CLOEXEC, 0) = 3
connect(3, {sa_family=AF_FILE, path="/dev/log"}, 110) = -1 EPROTOTYPE (Protocol wrong type for socket)
close(3)                                = 0
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC, 0) = 3
connect(3, {sa_family=AF_FILE, path="/dev/log"}, 110) = 0
send(3, "<30>May 20 12:55:36 nilfs_cleane"..., 48, MSG_NOSIGNAL) = 48
open("/proc/mounts", O_RDONLY|O_LARGEFILE) = 4
fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7701000
read(4, "rootfs / rootfs rw 0 0\n/dev/sda3"..., 1024) = 457
close(4)                                = 0
munmap(0xb7701000, 4096)                = 0
open("/dev/sdb2", O_RDONLY|O_LARGEFILE) = 4
ioctl(4, BLKGETSIZE64, 1085736960)      = 0
_llseek(4, 1024, [1024], SEEK_SET)      = 0
read(4, "\2\0\0\0\0\00044\30\1\0\0\373\363\213N\324d\270\0\2\0\0\0\201\0\0\0\0\0\0\0"..., 1024) = 1024
_llseek(4, 1085730816, [1085730816], SEEK_SET) = 0
read(4, "\2\0\0\0\0\00044\30\1\0\0\373\363\213N\324d\270\0\2\0\0\0\201\0\0\0\0\0\0\0"..., 1024) = 1024
open("/proc/mounts", O_RDONLY|O_LARGEFILE) = 5
fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7701000
read(5, "rootfs / rootfs rw 0 0\n/dev/sda3"..., 1024) = 457
close(5)                                = 0
munmap(0xb7701000, 4096)                = 0
open("/mnt/nilfs2", O_RDONLY|O_LARGEFILE) = 5
stat64("/dev/sdb2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 18), ...}) = 0
statfs("/dev/shm", {f_type=0x1021994, f_bsize=4096, f_blocks=64251, f_bfree=64250, f_bavail=64250, f_files=64251, f_ffree=64249, f_fsid={0, 0}, f_namelen=255, f_frsize=4096}) = 0
futex(0xb759d188, FUTEX_WAKE_PRIVATE, 2147483647) = 0
open("/dev/shm/sem.nilfs-cleaner-2066", O_RDWR|O_NOFOLLOW) = 7
fstat64(7, {st_mode=S_IFREG|0700, st_size=16, ...}) = 0
mmap2(NULL, 16, PROT_READ|PROT_WRITE, MAP_SHARED, 7, 0) = 0xb7701000
close(7)                                = 0
stat64("/etc/nilfs_cleanerd.conf", {st_mode=S_IFREG|0644, st_size=1813, ...}) = 0
open("/etc/nilfs_cleanerd.conf", O_RDONLY|O_LARGEFILE) = 7
fstat64(7, {st_mode=S_IFREG|0644, st_size=1813, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7700000
read(7, "# nilfs_cleanerd.conf - configur"..., 4096) = 1813
read(7, "", 4096)                       = 0
close(7)                                = 0
munmap(0xb7700000, 4096)                = 0
stat64("/dev/sdb2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 18), ...}) = 0
mq_open("nilfs-cleanerq-2066", O_RDONLY|O_CREAT, 0600, {mq_maxmsg=6, mq_msgsize=4096}) = -1 ENOSYS (Function not implemented)
time(NULL)                              = 1337504136
send(3, "<27>May 20 12:55:36 nilfs_cleane"..., 102, MSG_NOSIGNAL) = 102
munmap(0xb7701000, 16)                  = 0
close(4)                                = 0
close(5)                                = 0
time(NULL)                              = 1337504136
send(3, "<27>May 20 12:55:36 nilfs_cleane"..., 101, MSG_NOSIGNAL) = 101
time(NULL)                              = 1337504136
send(3, "<30>May 20 12:55:36 nilfs_cleane"..., 51, MSG_NOSIGNAL) = 51
close(3)                                = 0
exit_group(1)                           = ?
Process 3806 detached

--=-hOWRjUff+E3T0Ud+ya6D--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
