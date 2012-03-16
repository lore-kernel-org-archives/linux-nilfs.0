From: "svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org" <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: nilfs_cleanerd Function not implemented
Date: Fri, 16 Mar 2012 05:05:33 -0700 (PDT)
Message-ID: <1331899533.77663.YahooMailNeo@web161902.mail.bf1.yahoo.com>
Reply-To: "svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org" <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1331899533; bh=pqWDBcAM563/5bEkN3HvyZm5NifR49lcJD41FeP4rko=; h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding; b=GPNn1A6SZDvhL2Gqp7/QkxPV87O4h/rukAmQ/eT9geFQqoWr215q+LlXv6g1rtt+4YEEb09o8lbhIOLaTkbrR6WIZuq4fi52lNLEExuZQfq8qs88tm0ebYRIoeb2xwhLh/RDDzFYeXaYxX2YvkAZ37CQXXpw8yWVQtM4A8/3OhY=
References: 
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi list,

I am in the process of migrating an embedded project from
ext2 to nilfs2 and have a problem with nilfs_cleanerd. It
does not start on mount and I cannot start it manually.

The below sequence is reproduced on the build system,
a QEMU i586, with a similar kernel as the target
(also i586, AMD Geode LX):

# mkfs.nilfs2 /dev/sdb1
mkfs.nilfs2 (nilfs-utils 2.1.1)
Start writing file system initial data to the device
=A0=A0=A0=A0=A0=A0 Blocksize:4096=A0 Device:/dev/sdb1=A0 Device Size:21=
46765824
=46ile system initialization succeeded !!

# mount.nilfs2 /dev/sdb1 /mnt/cf
# echo $?
0

# mount | grep nilfs
/dev/sdb1 on /mnt/cf type nilfs2 (rw,gcpid=3D489)
# nilfs-clean -l

No cleaner found on /dev/sdb1.

# dmesg | tail
=2E..
segctord starting. Construction interval =3D 5 seconds, CP frequency < =
30 seconds

# tail /var/log/syslog
=2E..
Mar 14 16:48:50 monit kernel: segctord starting. Construction interval =
=3D 5 seconds, CP frequency < 30 seconds
Mar 14 16:48:51 monit nilfs_cleanerd[489]: start
Mar 14 16:48:51 monit nilfs_cleanerd[489]: cannot open nilfs on /dev/sd=
b1: Function not implemented
Mar 14 16:48:51 monit nilfs_cleanerd[489]: cannot create cleanerd on /d=
ev/sdb1: Function not implemented
Mar 14 16:48:51 monit nilfs_cleanerd[489]: shutdown

Trying to start it manually with nilfs_cleanerd /dev/sdb1
gives the same result.

Kernel is a lean vanilla 3.2.11, but I have tried most
3.2.x kernels.


To a novice, like me, the lengthy strace below seems to
suggest a socket error of some sort (sendto(-1218631408,...).

Are there any specific kernel CONFIGs needed to get it
going?
/S-G

# strace -f /sbin/nilfs_cleanerd /dev/sdb1
execve("/sbin/nilfs_cleanerd", ["/sbin/nilfs_cleanerd", "/dev/sdb1"], [=
/* 13 vars */]) =3D 0
brk(0)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0x8dfd000
access("/etc/ld.so.nohwcap", F_OK)=A0=A0=A0=A0=A0 =3D -1 ENOENT (No suc=
h file or directory)
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xb7742000
access("/etc/ld.so.preload", R_OK)=A0=A0=A0=A0=A0 =3D -1 ENOENT (No suc=
h file or directory)
open("/etc/ld.so.cache", O_RDONLY)=A0=A0=A0=A0=A0 =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D17637, ...}) =3D 0
mmap2(NULL, 17637, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0xb773d000
close(3)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
access("/etc/ld.so.nohwcap", F_OK)=A0=A0=A0=A0=A0 =3D -1 ENOENT (No suc=
h file or directory)
open("/usr/lib/libnilfs.so.0", O_RDONLY) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260\22"..., 51=
2) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D24842, ...}) =3D 0
mmap2(NULL, 17896, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0=
) =3D 0xb7738000
mmap2(0xb773c000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_DENYWRITE, 3, 0x4) =3D 0xb773c000
close(3)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
access("/etc/ld.so.nohwcap", F_OK)=A0=A0=A0=A0=A0 =3D -1 ENOENT (No suc=
h file or directory)
open("/usr/lib/libnilfsgc.so.0", O_RDONLY) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\200\16"..., 51=
2) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D19922, ...}) =3D 0
mmap2(NULL, 17340, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0=
) =3D 0xb7733000
mmap2(0xb7737000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_DENYWRITE, 3, 0x3) =3D 0xb7737000
close(3)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
access("/etc/ld.so.nohwcap", F_OK)=A0=A0=A0=A0=A0 =3D -1 ENOENT (No suc=
h file or directory)
open("/lib/librt.so.1", O_RDONLY)=A0=A0=A0=A0=A0=A0 =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\240\30"..., 51=
2) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D30624, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xb7732000
mmap2(NULL, 33336, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0=
) =3D 0xb7729000
mmap2(0xb7730000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_DENYWRITE, 3, 0x6) =3D 0xb7730000
close(3)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
access("/etc/ld.so.nohwcap", F_OK)=A0=A0=A0=A0=A0 =3D -1 ENOENT (No suc=
h file or directory)
open("/lib/libc.so.6", O_RDONLY)=A0=A0=A0=A0=A0=A0=A0 =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260e\1"..., 51=
2) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D1294572, ...}) =3D 0
mmap2(NULL, 1300080, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,=
 0) =3D 0xb75eb000
mmap2(0xb7723000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0x138) =3D 0xb7723000
mmap2(0xb7726000, 9840, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_ANONYMOUS, -1, 0) =3D 0xb7726000
close(3)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
access("/etc/ld.so.nohwcap", F_OK)=A0=A0=A0=A0=A0 =3D -1 ENOENT (No suc=
h file or directory)
open("/lib/libpthread.so.0", O_RDONLY)=A0 =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220G\0"..., 51=
2) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D112012, ...}) =3D 0
mmap2(NULL, 94688, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0=
) =3D 0xb75d3000
mmap2(0xb75e7000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_DENYWRITE, 3, 0x13) =3D 0xb75e7000
mmap2(0xb75e9000, 4576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_ANONYMOUS, -1, 0) =3D 0xb75e9000
close(3)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xb75d2000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb75d28c0, limit:1048=
575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_n=
ot_present:0, useable:1}) =3D 0
mprotect(0xb7723000, 4096, PROT_READ)=A0=A0 =3D 0
munmap(0xb773d000, 17637)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D=
 0
set_tid_address(0xb75d2908)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 122=
4
sendto(-1218631408, umovestr: Input/output error
0xc, 3076423668, MSG_EOR|MSG_ERRQUEUE|MSG_DONTWAIT|MSG_CONFIRM|0xb75d00=
00, {sa_family=3D0xed31 /* AF_??? */, sa_data=3D"^\211\341\203\344\360P=
TRh\300\334\4\10"}, 3220150176) =3D 0
futex(0xbfef9790, 0x81 /* FUTEX_??? */, 1) =3D 0
rt_sigaction(SIGRTMIN, {0xb75d7280, [], SA_SIGINFO}, NULL, 8) =3D 0
rt_sigaction(SIGRT_1, {0xb75d7680, [], SA_RESTART|SA_SIGINFO}, NULL, 8)=
 =3D 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) =3D 0
getrlimit(RLIMIT_STACK, {rlim_cur=3D8192*1024, rlim_max=3DRLIM_INFINITY=
}) =3D 0
uname({sys=3D"Linux", node=3D"monit.site.tpm", ...}) =3D 0
readlink("/dev", 0xbfef771f, 4096)=A0=A0=A0=A0=A0 =3D -1 EINVAL (Invali=
d argument)
readlink("/dev/sdb1", 0xbfef771f, 4096) =3D -1 EINVAL (Invalid argument=
)
brk(0)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0x8dfd000
brk(0x8e1e000)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 =3D 0x8e1e000
clone(Process 1225 attached
child_stack=3D0, flags=3DCLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHL=
D, child_tidptr=3D0xb75d2908) =3D 1225
[pid=A0 1224] exit_group(0)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D=
 ?
Process 1224 detached
setsid()=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 1225
chdir("/")=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
close(0)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
close(1)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
close(2)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
open("/dev/null", O_RDONLY)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
open("/dev/null", O_WRONLY)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 1
open("/dev/null", O_WRONLY)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 2
time(NULL)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =3D 1331898633
open("/etc/localtime", O_RDONLY)=A0=A0=A0=A0=A0=A0=A0 =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D1892, ...}) =3D 0
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D1892, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xb7741000
read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\4\0\0\0\4\0\0"..., 4=
096) =3D 1892
_llseek(3, -28, [1864], SEEK_CUR)=A0=A0=A0=A0=A0=A0 =3D 0
read(3, "\nCET-1CEST,M3.5.0,M10.5.0/3\n", 4096) =3D 28
close(3)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
munmap(0xb7741000, 4096)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D=
 0
stat64("/etc/localtime", {st_mode=3DS_IFREG|0644, st_size=3D1892, ...})=
 =3D 0
socket(PF_FILE, SOCK_DGRAM, 0)=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 3
fcntl64(3, F_SETFD, FD_CLOEXEC)=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
connect(3, {sa_family=3DAF_FILE, path=3D"/dev/log"}, 110) =3D 0
send(3, "<30>Mar 16 12:50:33 nilfs_cleane"..., 47, MSG_NOSIGNAL) =3D 47
open("/dev/sdb1", O_RDONLY)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 4
ioctl(4, BLKGETSIZE64, 0xbfef8658)=A0=A0=A0=A0=A0 =3D 0
lseek(4, 1024, SEEK_SET)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D=
 1024
read(4, "\2\0\0\0\0\00044\30\1\0\0KH.\227\17t\213\r\2\0\0\0\377"..., 10=
24) =3D 1024
lseek(4, 2146758656, SEEK_SET)=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 214675865=
6
read(4, "\2\0\0\0\0\00044\30\1\0\0KH.\227\17t\213\r\2\0\0\0\377"..., 10=
24) =3D 1024
readlink("/dev", 0xbfef5e4f, 4096)=A0=A0=A0=A0=A0 =3D -1 EINVAL (Invali=
d argument)
readlink("/dev/sdb1", 0xbfef5e4f, 4096) =3D -1 EINVAL (Invalid argument=
)
open("/proc/mounts", O_RDONLY)=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 5
fstat64(5, {st_mode=3DS_IFREG|0444, st_size=3D0, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xb7741000
read(5, "rootfs / rootfs rw 0 0\nprocfs /p"..., 1024) =3D 765
readlink("/dev", 0xbfef5e4f, 4096)=A0=A0=A0=A0=A0 =3D -1 EINVAL (Invali=
d argument)
readlink("/dev/sdb1", 0xbfef5e4f, 4096) =3D -1 EINVAL (Invalid argument=
)
close(5)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
munmap(0xb7741000, 4096)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D=
 0
open("/mnt/cf", O_RDONLY)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D=
 5
stat64("/dev/sdb1", {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(8, 17), =
=2E..}) =3D 0
statfs("/dev/shm", {f_type=3D0x858458f6, f_bsize=3D4096, f_blocks=3D0, =
f_bfree=3D0, f_bavail=3D0, f_files=3D0, f_ffree=3D0, f_fsid=3D{0, 0}, f=
_namelen=3D255, f_frsize=3D4096}) =3D 0
open("/proc/mounts", O_RDONLY)=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 6
fstat64(6, {st_mode=3DS_IFREG|0444, st_size=3D0, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xb7741000
read(6, "rootfs / rootfs rw 0 0\nprocfs /p"..., 1024) =3D 765
statfs("/lib/init/rw", {f_type=3D0x858458f6, f_bsize=3D4096, f_blocks=3D=
0, f_bfree=3D0, f_bavail=3D0, f_files=3D0, f_ffree=3D0, f_fsid=3D{0, 0}=
, f_namelen=3D255, f_frsize=3D4096}) =3D 0
statfs("/dev", {f_type=3D0x858458f6, f_bsize=3D4096, f_blocks=3D0, f_bf=
ree=3D0, f_bavail=3D0, f_files=3D0, f_ffree=3D0, f_fsid=3D{0, 0}, f_nam=
elen=3D255, f_frsize=3D4096}) =3D 0
statfs("/dev/shm", {f_type=3D0x858458f6, f_bsize=3D4096, f_blocks=3D0, =
f_bfree=3D0, f_bavail=3D0, f_files=3D0, f_ffree=3D0, f_fsid=3D{0, 0}, f=
_namelen=3D255, f_frsize=3D4096}) =3D 0
read(6, "", 1024)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =3D 0
close(6)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
munmap(0xb7741000, 4096)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D=
 0
futex(0xb75ea184, 0x81 /* FUTEX_??? */, 2147483647) =3D 0
close(4)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
close(5)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
time(NULL)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =3D 1331898633
stat64("/etc/localtime", {st_mode=3DS_IFREG|0644, st_size=3D1892, ...})=
 =3D 0
send(3, "<27>Mar 16 12:50:33 nilfs_cleane"..., 98, MSG_NOSIGNAL) =3D 98
time(NULL)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =3D 1331898633
stat64("/etc/localtime", {st_mode=3DS_IFREG|0644, st_size=3D1892, ...})=
 =3D 0
send(3, "<27>Mar 16 12:50:33 nilfs_cleane"..., 103, MSG_NOSIGNAL) =3D 1=
03
time(NULL)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =3D 1331898633
stat64("/etc/localtime", {st_mode=3DS_IFREG|0644, st_size=3D1892, ...})=
 =3D 0
send(3, "<30>Mar 16 12:50:33 nilfs_cleane"..., 50, MSG_NOSIGNAL) =3D 50
close(3)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
exit_group(1)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 =3D ?
Process 1225 detached
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
