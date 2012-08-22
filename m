From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: free space not reclaimed
Date: Wed, 22 Aug 2012 10:10:07 +0400
Message-ID: <1345615807.2482.9.camel@slavad-ubuntu-11>
References: <0D65752F-DE69-4A4D-98B3-6C1FF5FE4039@netams.com>
	 <1345552196.2457.52.camel@slavad-ubuntu-11>
	 <923B1589-662B-4CFF-B00F-6359CD95F52A@netams.com>
	 <1345555045.2457.57.camel@slavad-ubuntu-11>
	 <E761D812-7007-45AC-A177-A8A78E851284@netams.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=O9Z/s2TOIYxpm7dxc/ZqKzk3Hhcof5qLHUHgwyghR3Q=;
	b=aiLEb8QeTqHfAJjOYygqifN0au7oqzGXhGmI72B/yc46ehsk5wHX84wuZej2HjOFRzJCFZacv1dwDDE8qR97Z4BpgTFbMp+vVreempkLy7N/G/ugvtzwd27x/dms+rHn;
In-Reply-To: <E761D812-7007-45AC-A177-A8A78E851284-N6MIjFY6MsTQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yuriy Shkandybin <jura-N6MIjFY6MsTQT0dZR+AlfA@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Wed, 2012-08-22 at 01:21 +0400, Yuriy Shkandybin wrote:
> output of lssu -a=20
> http://www.netams.com/files/LSSU.gz
>=20

As I can see from this output, you have 215622 free segments now (as
minimum 1 TB free space). So, GC is working, as I can understand.

Have you this free space available?

With the best regards,
Vyacheslav Dubeyko.


> Thanks.
>=20
>=20
> 21.08.2012, =D0=B2 17:17, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> =D0=BD=
=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
> > Hi,
> >=20
> > On Tue, 2012-08-21 at 16:47 +0400, Yury Shkandybin wrote:
> >> I didn't stopped gc.
> >> # nilfs-clean -l
> >> running
> >>=20
> >> # mount
> >> rootfs on / type rootfs (rw)
> >> /dev/root on / type reiserfs (rw,noatime)
> >> devtmpfs on /dev type devtmpfs (rw,relatime,size=3D16447148k,nr_in=
odes=3D4111787,mode=3D755)
> >> proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
> >> tmpfs on /run type tmpfs (rw,nosuid,nodev,relatime,mode=3D755)
> >> sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
> >> devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=3D5,=
mode=3D620)
> >> shm on /dev/shm type tmpfs (rw,nosuid,nodev,noexec,relatime)
> >> none on /tmp type tmpfs (rw,noatime,size=3D256M)
> >> none on /cache type tmpfs (rw,noexec,nosuid,size=3D20G)
> >> /dev/sda2 on /archive type nilfs2 (rw,noatime,nodiratime,gcpid=3D5=
01)
> >>=20
> >> # lscp
> >>                 CNO        DATE     TIME  MODE  FLG     NBLKINC   =
    ICNT
> >> empty
> >>=20
> >> SEGNUM        DATE     TIME STAT     NBLOCKS
> >>                   0  2012-08-19 09:10:01  -d-        2047
> >>                   1  2012-08-19 09:10:03  -d-        2048
> >>                   2  2012-08-19 09:10:03  -d-        2048
> >> 		...
> >> # lssu | wc -l
> >> 3717895
> >>=20
> >=20
> > The full output of lssu is very important for the issue analysis. C=
ould
> > you please share full output of lssu command with -a option (lssu -=
a)?
> >=20
> > With the best regards,
> > Vyacheslav Dubeyko.
> >=20
> >=20
> >> There is no errors in dmesg.
> >>=20
> >> #strace -f nilfs_cleanerd  /dev/sda2  > LOG 2>&1
> >> xecve("/sbin/nilfs_cleanerd", ["nilfs_cleanerd", "/dev/sda2"], [/*=
 34 vars */]) =3D 0
> >> brk(0)                                  =3D 0x1169000
> >> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, =
-1, 0) =3D 0x7f8c92de0000
> >> access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such fil=
e or directory)
> >> open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
> >> fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D53452, ...}) =3D 0
> >> mmap(NULL, 53452, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x7f8c92dd2000
> >> close(3)                                =3D 0
> >> open("/lib64/libnilfs.so.0", O_RDONLY|O_CLOEXEC) =3D 3
> >> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\32\0\0=
\0\0\0\0"..., 832) =3D 832
> >> fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D23648, ...}) =3D 0
> >> mmap(NULL, 2119024, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE=
, 3, 0) =3D 0x7f8c929ba000
> >> mprotect(0x7f8c929bf000, 2093056, PROT_NONE) =3D 0
> >> mmap(0x7f8c92bbe000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_F=
IXED|MAP_DENYWRITE, 3, 0x4000) =3D 0x7f8c92bbe000
> >> close(3)                                =3D 0
> >> open("/lib64/libnilfsgc.so.0", O_RDONLY|O_CLOEXEC) =3D 3
> >> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\25\0\0=
\0\0\0\0"..., 832) =3D 832
> >> fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D18544, ...}) =3D 0
> >> mmap(NULL, 2113920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE=
, 3, 0) =3D 0x7f8c927b5000
> >> mprotect(0x7f8c927b9000, 2093056, PROT_NONE) =3D 0
> >> mmap(0x7f8c929b8000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_F=
IXED|MAP_DENYWRITE, 3, 0x3000) =3D 0x7f8c929b8000
> >> close(3)                                =3D 0
> >> open("/lib64/librt.so.1", O_RDONLY|O_CLOEXEC) =3D 3
> >> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200(\0\0\0=
\0\0\0"..., 832) =3D 832
> >> fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D35656, ...}) =3D 0
> >> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, =
-1, 0) =3D 0x7f8c927b4000
> >> mmap(NULL, 2133016, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE=
, 3, 0) =3D 0x7f8c925ab000
> >> mprotect(0x7f8c925b3000, 2093056, PROT_NONE) =3D 0
> >> mmap(0x7f8c927b2000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_F=
IXED|MAP_DENYWRITE, 3, 0x7000) =3D 0x7f8c927b2000
> >> close(3)                                =3D 0
> >> open("/lib64/libuuid.so.1", O_RDONLY|O_CLOEXEC) =3D 3
> >> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\30\0\0\0\=
0\0\0"..., 832) =3D 832
> >> fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D18784, ...}) =3D 0
> >> mmap(NULL, 2113960, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE=
, 3, 0) =3D 0x7f8c923a6000
> >> mprotect(0x7f8c923aa000, 2093056, PROT_NONE) =3D 0
> >> mmap(0x7f8c925a9000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_F=
IXED|MAP_DENYWRITE, 3, 0x3000) =3D 0x7f8c925a9000
> >> close(3)                                =3D 0
> >> open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) =3D 3
> >> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0 G\2\0\0\0\=
0\0"..., 832) =3D 832
> >> fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D1716440, ...}) =3D 0
> >> mmap(NULL, 3828832, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE=
, 3, 0) =3D 0x7f8c91fff000
> >> mprotect(0x7f8c9219c000, 2097152, PROT_NONE) =3D 0
> >> mmap(0x7f8c9239c000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_=
=46IXED|MAP_DENYWRITE, 3, 0x19d000) =3D 0x7f8c9239c000
> >> mmap(0x7f8c923a2000, 15456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_=
=46IXED|MAP_ANONYMOUS, -1, 0) =3D 0x7f8c923a2000
> >> close(3)                                =3D 0
> >> open("/lib64/libpthread.so.0", O_RDONLY|O_CLOEXEC) =3D 3
> >> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P|\0\0\0\0\=
0\0"..., 832) =3D 832
> >> fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D135105, ...}) =3D 0
> >> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, =
-1, 0) =3D 0x7f8c92dd1000
> >> mmap(NULL, 2212784, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE=
, 3, 0) =3D 0x7f8c91de2000
> >> mprotect(0x7f8c91dfa000, 2093056, PROT_NONE) =3D 0
> >> mmap(0x7f8c91ff9000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_F=
IXED|MAP_DENYWRITE, 3, 0x17000) =3D 0x7f8c91ff9000
> >> mmap(0x7f8c91ffb000, 13232, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_=
=46IXED|MAP_ANONYMOUS, -1, 0) =3D 0x7f8c91ffb000
> >> close(3)                                =3D 0
> >> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, =
-1, 0) =3D 0x7f8c92dd0000
> >> mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, =
-1, 0) =3D 0x7f8c92dce000
> >> arch_prctl(ARCH_SET_FS, 0x7f8c92dce740) =3D 0
> >> mprotect(0x7f8c9239c000, 16384, PROT_READ) =3D 0
> >> mprotect(0x7f8c91ff9000, 4096, PROT_READ) =3D 0
> >> mprotect(0x7f8c925a9000, 4096, PROT_READ) =3D 0
> >> mprotect(0x7f8c927b2000, 4096, PROT_READ) =3D 0
> >> mprotect(0x7f8c92bbe000, 4096, PROT_READ) =3D 0
> >> mprotect(0x7f8c929b8000, 4096, PROT_READ) =3D 0
> >> mprotect(0x606000, 4096, PROT_READ)     =3D 0
> >> mprotect(0x7f8c92de1000, 4096, PROT_READ) =3D 0
> >> munmap(0x7f8c92dd2000, 53452)           =3D 0
> >> set_tid_address(0x7f8c92dcea10)         =3D 4903
> >> set_robust_list(0x7f8c92dcea20, 24)     =3D 0
> >> futex(0x7fff5b95262c, FUTEX_WAKE_PRIVATE, 1) =3D 0
> >> futex(0x7fff5b95262c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTI=
ME, 1, NULL, 7f8c92dce740) =3D -1 EAGAIN (Resource temporarily unavaila=
ble)
> >> rt_sigaction(SIGRTMIN, {0x7f8c91de96b0, [], SA_RESTORER|SA_SIGINFO=
, 0x7f8c91df2bf0}, NULL, 8) =3D 0
> >> rt_sigaction(SIGRT_1, {0x7f8c91de9740, [], SA_RESTORER|SA_RESTART|=
SA_SIGINFO, 0x7f8c91df2bf0}, NULL, 8) =3D 0
> >> rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) =3D 0
> >> getrlimit(RLIMIT_STACK, {rlim_cur=3D8192*1024, rlim_max=3DRLIM64_I=
NFINITY}) =3D 0
> >> readlink("/dev", 0x7fff5b9501c0, 4096)  =3D -1 EINVAL (Invalid arg=
ument)
> >> readlink("/dev/sda2", 0x7fff5b9501c0, 4096) =3D -1 EINVAL (Invalid=
 argument)
> >> brk(0)                                  =3D 0x1169000
> >> brk(0x118a000)                          =3D 0x118a000
> >> clone(child_stack=3D0, flags=3DCLONE_CHILD_CLEARTID|CLONE_CHILD_SE=
TTID|SIGCHLD, child_tidptr=3D0x7f8c92dcea10) =3D 4904
> >> exit_group(0)                           =3D ?
> >> Process 4904 attached
> >> [pid  4903] +++ exited with 0 +++
> >> set_robust_list(0x7f8c92dcea20, 24)     =3D 0
> >> setsid()                                =3D 4904
> >> chdir("/")                              =3D 0
> >> close(0)                                =3D 0
> >> close(1)                                =3D 0
> >> close(2)                                =3D 0
> >> open("/dev/null", O_RDONLY)             =3D 0
> >> open("/dev/null", O_WRONLY)             =3D 1
> >> open("/dev/null", O_WRONLY)             =3D 2
> >> open("/etc/localtime", O_RDONLY|O_CLOEXEC) =3D 3
> >> fcntl(3, F_GETFD)                       =3D 0x1 (flags FD_CLOEXEC)
> >> fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D1464, ...}) =3D 0
> >> fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D1464, ...}) =3D 0
> >> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, =
-1, 0) =3D 0x7f8c92ddf000
> >> read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\16\0\0\0\16\0\0=
\0\0"..., 4096) =3D 1464
> >> lseek(3, -898, SEEK_CUR)                =3D 566
> >> read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\17\0\0\0\17\0\0=
\0\0"..., 4096) =3D 898
> >> close(3)                                =3D 0
> >> munmap(0x7f8c92ddf000, 4096)            =3D 0
> >> socket(PF_FILE, SOCK_DGRAM|SOCK_CLOEXEC, 0) =3D 3
> >> connect(3, {sa_family=3DAF_FILE, sun_path=3D"/dev/log"}, 110) =3D =
-1 EPROTOTYPE (Protocol wrong type for socket)
> >> close(3)                                =3D 0
> >> socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC, 0) =3D 3
> >> connect(3, {sa_family=3DAF_FILE, sun_path=3D"/dev/log"}, 110) =3D =
0
> >> sendto(3, "<30>Aug 21 16:45:23 nilfs_cleane"..., 48, MSG_NOSIGNAL,=
 NULL, 0) =3D 48
> >> open("/dev/sda2", O_RDONLY)             =3D 4
> >> ioctl(4, BLKGETSIZE64, 32967381466624)  =3D 0
> >> lseek(4, 1024, SEEK_SET)                =3D 1024
> >> read(4, "\2\0\0\0\0\00044\30\1\0\0\202z\264B\303|e\21\2\0\0\0\242\=
367;\0\0\0\0\0"..., 1024) =3D 1024
> >> lseek(4, 32967381458944, SEEK_SET)      =3D 32967381458944
> >> read(4, "\2\0\0\0\0\00044\30\1\0\0\202z\264B\303|e\21\2\0\0\0\242\=
367;\0\0\0\0\0"..., 1024) =3D 1024
> >> readlink("/dev", 0x7fff5b94e8d0, 4096)  =3D -1 EINVAL (Invalid arg=
ument)
> >> readlink("/dev/sda2", 0x7fff5b94e8d0, 4096) =3D -1 EINVAL (Invalid=
 argument)
> >> open("/proc/mounts", O_RDONLY)          =3D 5
> >> fstat(5, {st_mode=3DS_IFREG|0444, st_size=3D0, ...}) =3D 0
> >> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, =
-1, 0) =3D 0x7f8c92ddf000
> >> read(5, "rootfs / rootfs rw 0 0\n/dev/root"..., 1024) =3D 582
> >> readlink("/dev", 0x7fff5b94e8d0, 4096)  =3D -1 EINVAL (Invalid arg=
ument)
> >> readlink("/dev/sda2", 0x7fff5b94e8d0, 4096) =3D -1 EINVAL (Invalid=
 argument)
> >> close(5)                                =3D 0
> >> munmap(0x7f8c92ddf000, 4096)            =3D 0
> >> open("/archive", O_RDONLY)              =3D 5
> >> stat("/dev/sda2", {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 2)=
, ...}) =3D 0
> >> statfs("/dev/shm", {f_type=3D0x1021994, f_bsize=3D4096, f_blocks=3D=
4111841, f_bfree=3D4111840, f_bavail=3D4111840, f_files=3D4111841, f_ff=
ree=3D4111839, f_fsid=3D{0, 0}, f_namelen=3D255, f_frsize=3D4096}) =3D =
0
> >> futex(0x7f8c91ffe2e0, FUTEX_WAKE_PRIVATE, 2147483647) =3D 0
> >> open("/dev/shm/sem.nilfs-cleaner-2050", O_RDWR|O_NOFOLLOW) =3D 6
> >> fstat(6, {st_mode=3DS_IFREG|0700, st_size=3D32, ...}) =3D 0
> >> mmap(NULL, 32, PROT_READ|PROT_WRITE, MAP_SHARED, 6, 0) =3D 0x7f8c9=
2ddf000
> >> close(6)                                =3D 0
> >> stat("/etc/nilfs_cleanerd.conf", {st_mode=3DS_IFREG|0644, st_size=3D=
1815, ...}) =3D 0
> >> open("/etc/nilfs_cleanerd.conf", O_RDONLY) =3D 6
> >> fstat(6, {st_mode=3DS_IFREG|0644, st_size=3D1815, ...}) =3D 0
> >> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, =
-1, 0) =3D 0x7f8c92dde000
> >> read(6, "# nilfs_cleanerd.conf - configur"..., 4096) =3D 1815
> >> read(6, "", 4096)                       =3D 0
> >> close(6)                                =3D 0
> >> munmap(0x7f8c92dde000, 4096)            =3D 0
> >> stat("/dev/sda2", {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 2)=
, ...}) =3D 0
> >> mq_open("nilfs-cleanerq-2050", O_RDONLY|O_CREAT, 0600, {mq_maxmsg=3D=
6, mq_msgsize=3D4096}) =3D 6
> >> rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  =3D 0
> >> rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> >> rt_sigaction(SIGTERM, {0x403920, ~[RTMIN RT_1], SA_RESTORER, 0x7f8=
c92036bc0}, NULL, 8) =3D 0
> >> rt_sigaction(SIGHUP, {0x4038f0, ~[RTMIN RT_1], SA_RESTORER, 0x7f8c=
92036bc0}, NULL, 8) =3D 0
> >> sendto(3, "<30>Aug 21 16:45:23 nilfs_cleane"..., 62, MSG_NOSIGNAL,=
 NULL, 0) =3D 62
> >> rt_sigprocmask(SIG_BLOCK, [HUP], NULL, 8) =3D 0
> >> ioctl(5, 0x80306e85, 0x7fff5b952510)    =3D 0
> >> sendto(3, "<30>Aug 21 16:45:23 nilfs_cleane"..., 63, MSG_NOSIGNAL,=
 NULL, 0) =3D 63
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> mmap(NULL, 135168, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS=
, -1, 0) =3D 0x7f8c92dad000
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> mremap(0x7f8c92dad000, 135168, 266240, MREMAP_MAYMOVE) =3D 0x7f8c9=
2d6c000
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >> mremap(0x7f8c92d6c000, 266240, 528384, MREMAP_MAYMOVE) =3D 0x7f8c9=
2ceb000
> >> ioctl(5, 0x80186e84, 0x7fff5b94f130)    =3D 0
> >>=20
> >> and a lot of more ioctls and some mremaps
> >>=20
> >> Sincerely,
> >> Yuriy Shkandybin
> >>=20
> >>=20
> >>=20
> >> On Aug 21, 2012, at 4:29 PM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org=
> wrote:
> >>=20
> >>> Hi,
> >>>=20
> >>> On Tue, 2012-08-21 at 15:57 +0400, Yury Shkandybin wrote:
> >>>> Hello.
> >>>>=20
> >>>> Recently i overloaded my nilfs2 partition with data.
> >>>> /dev/sda2        30T   29T  122G 100% /archive
> >>>> I've removed 4T and issued:
> >>>> rmcp -f 1..=20
> >>>> nilfs-clean -p 0
> >>>> , but used space left the same.
> >>>> Actually it keeps increasing.
> >>>>=20
> >>>=20
> >>> Did you stop garbage collection or not? Could share status of cle=
aner
> >>> (nilfs-clean -l)?
> >>>=20
> >>> Moreover, could you share output of the mount utility (without an=
y
> >>> options, please)?
> >>>=20
> >>> Could you share output of lscp and lssu utilities?
> >>>=20
> >>> Do you have any errors messages related to NILFS in the system lo=
g?
> >>>=20
> >>> Could you share trace of nilfs_cleanerd start?
> >>>=20
> >>> With the best regards,
> >>> Vyacheslav Dubeyko.
> >>>=20
> >>>> I've tried different versions nilfs-utils ( now sys-fs/nilfs-uti=
ls-2.1.4)
> >>>> and kernels ( now sys-kernel/gentoo-sources-3.5.2)
> >>>>=20
> >>>> nilfs_cleanerd  is running, keeping 1 LA
> >>>> According to debug output, it keeps cleaning garbage segments, b=
ut number of clean segments stays the same:
> >>>> Aug 21 15:42:38 WAYX017 nilfs_cleanerd[16907]: ncleansegs =3D 21=
2114
> >>>> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: 4 segments select=
ed to be cleaned
> >>>> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734108 cl=
eaned
> >>>> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734109 cl=
eaned
> >>>> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734110 cl=
eaned
> >>>> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734111 cl=
eaned
> >>>> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: adjust interval
> >>>> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: wait 0.000000
> >>>> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: wake up
> >>>> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: ncleansegs =3D 21=
2114
> >>>> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: 4 segments select=
ed to be cleaned
> >>>> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734112 cl=
eaned
> >>>> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734113 cl=
eaned
> >>>> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734114 cl=
eaned
> >>>> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734115 cl=
eaned
> >>>> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: adjust interval
> >>>> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: wait 0.000000
> >>>> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: wake up
> >>>> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: ncleansegs =3D 21=
2114
> >>>> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: 4 segments select=
ed to be cleaned
> >>>> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734116 cl=
eaned
> >>>> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734117 cl=
eaned
> >>>> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734118 cl=
eaned
> >>>> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734119 cl=
eaned
> >>>> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: adjust interval
> >>>> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: wait 0.000000
> >>>>=20
> >>>> # cat /etc/nilfs_cleanerd.conf=20
> >>>> protection_period       3600
> >>>> min_clean_segments      10%
> >>>> max_clean_segments      20%
> >>>> clean_check_interval    10
> >>>> selection_policy        timestamp       # timestamp in ascend or=
der
> >>>> nsegments_per_clean     2
> >>>> mc_nsegments_per_clean  4
> >>>> cleaning_interval       5
> >>>> mc_cleaning_interval    1
> >>>> retry_interval          60
> >>>> use_mmap
> >>>> log_priority            debug
> >>>>=20
> >>>>=20
> >>>> There was hard resets in the past with this server.
> >>>> There is no snapshots.
> >>>> Filesystem was created with -O block_count
> >>>>=20
> >>>>=20
> >>>>=20
> >>>> Sincerely,
> >>>> Yuriy Shkandybin
> >>>>=20
> >>>>=20
> >>>>=20
> >>>>=20
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-=
nilfs" in
> >>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.ht=
ml
> >>>=20
> >>>=20
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-n=
ilfs" in
> >>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> >>=20
> >=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nil=
fs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
