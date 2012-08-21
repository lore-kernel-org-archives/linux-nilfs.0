From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: free space not reclaimed
Date: Tue, 21 Aug 2012 23:15:28 +0900 (JST)
Message-ID: <20120821.231528.94857995.konishi.ryusuke@lab.ntt.co.jp>
References: <0D65752F-DE69-4A4D-98B3-6C1FF5FE4039@netams.com>
	<1345552196.2457.52.camel@slavad-ubuntu-11>
	<923B1589-662B-4CFF-B00F-6359CD95F52A@netams.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <923B1589-662B-4CFF-B00F-6359CD95F52A-N6MIjFY6MsTQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Yury Shkandybin <jura-N6MIjFY6MsTQT0dZR+AlfA@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 21 Aug 2012 16:47:01 +0400, Yury Shkandybin wrote:
> I didn't stopped gc.
> # nilfs-clean -l
> running

It may take long until free space increases because the current GC
algorithm is not smart.

Please wait until the output of "nilfs-clean -l" becomes "idle" to
confirm if it actually has a problem.

Regards,
Ryusuke Konishi

> # mount
> rootfs on / type rootfs (rw)
> /dev/root on / type reiserfs (rw,noatime)
> devtmpfs on /dev type devtmpfs (rw,relatime,size=16447148k,nr_inodes=4111787,mode=755)
> proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
> tmpfs on /run type tmpfs (rw,nosuid,nodev,relatime,mode=755)
> sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
> devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620)
> shm on /dev/shm type tmpfs (rw,nosuid,nodev,noexec,relatime)
> none on /tmp type tmpfs (rw,noatime,size=256M)
> none on /cache type tmpfs (rw,noexec,nosuid,size=20G)
> /dev/sda2 on /archive type nilfs2 (rw,noatime,nodiratime,gcpid=501)
> 
> # lscp
>                  CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
> empty
> 
> SEGNUM        DATE     TIME STAT     NBLOCKS
>                    0  2012-08-19 09:10:01  -d-        2047
>                    1  2012-08-19 09:10:03  -d-        2048
>                    2  2012-08-19 09:10:03  -d-        2048
> 		...
> # lssu | wc -l
> 3717895
> 
> There is no errors in dmesg.
> 
> #strace -f nilfs_cleanerd  /dev/sda2  > LOG 2>&1
> xecve("/sbin/nilfs_cleanerd", ["nilfs_cleanerd", "/dev/sda2"], [/* 34 vars */]) = 0
> brk(0)                                  = 0x1169000
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8c92de0000
> access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
> open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> fstat(3, {st_mode=S_IFREG|0644, st_size=53452, ...}) = 0
> mmap(NULL, 53452, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f8c92dd2000
> close(3)                                = 0
> open("/lib64/libnilfs.so.0", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\32\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=23648, ...}) = 0
> mmap(NULL, 2119024, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f8c929ba000
> mprotect(0x7f8c929bf000, 2093056, PROT_NONE) = 0
> mmap(0x7f8c92bbe000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x4000) = 0x7f8c92bbe000
> close(3)                                = 0
> open("/lib64/libnilfsgc.so.0", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\25\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=18544, ...}) = 0
> mmap(NULL, 2113920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f8c927b5000
> mprotect(0x7f8c927b9000, 2093056, PROT_NONE) = 0
> mmap(0x7f8c929b8000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f8c929b8000
> close(3)                                = 0
> open("/lib64/librt.so.1", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200(\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=35656, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8c927b4000
> mmap(NULL, 2133016, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f8c925ab000
> mprotect(0x7f8c925b3000, 2093056, PROT_NONE) = 0
> mmap(0x7f8c927b2000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x7000) = 0x7f8c927b2000
> close(3)                                = 0
> open("/lib64/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\30\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=18784, ...}) = 0
> mmap(NULL, 2113960, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f8c923a6000
> mprotect(0x7f8c923aa000, 2093056, PROT_NONE) = 0
> mmap(0x7f8c925a9000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f8c925a9000
> close(3)                                = 0
> open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0 G\2\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=1716440, ...}) = 0
> mmap(NULL, 3828832, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f8c91fff000
> mprotect(0x7f8c9219c000, 2097152, PROT_NONE) = 0
> mmap(0x7f8c9239c000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19d000) = 0x7f8c9239c000
> mmap(0x7f8c923a2000, 15456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f8c923a2000
> close(3)                                = 0
> open("/lib64/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P|\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=135105, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8c92dd1000
> mmap(NULL, 2212784, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f8c91de2000
> mprotect(0x7f8c91dfa000, 2093056, PROT_NONE) = 0
> mmap(0x7f8c91ff9000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17000) = 0x7f8c91ff9000
> mmap(0x7f8c91ffb000, 13232, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f8c91ffb000
> close(3)                                = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8c92dd0000
> mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8c92dce000
> arch_prctl(ARCH_SET_FS, 0x7f8c92dce740) = 0
> mprotect(0x7f8c9239c000, 16384, PROT_READ) = 0
> mprotect(0x7f8c91ff9000, 4096, PROT_READ) = 0
> mprotect(0x7f8c925a9000, 4096, PROT_READ) = 0
> mprotect(0x7f8c927b2000, 4096, PROT_READ) = 0
> mprotect(0x7f8c92bbe000, 4096, PROT_READ) = 0
> mprotect(0x7f8c929b8000, 4096, PROT_READ) = 0
> mprotect(0x606000, 4096, PROT_READ)     = 0
> mprotect(0x7f8c92de1000, 4096, PROT_READ) = 0
> munmap(0x7f8c92dd2000, 53452)           = 0
> set_tid_address(0x7f8c92dcea10)         = 4903
> set_robust_list(0x7f8c92dcea20, 24)     = 0
> futex(0x7fff5b95262c, FUTEX_WAKE_PRIVATE, 1) = 0
> futex(0x7fff5b95262c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NULL, 7f8c92dce740) = -1 EAGAIN (Resource temporarily unavailable)
> rt_sigaction(SIGRTMIN, {0x7f8c91de96b0, [], SA_RESTORER|SA_SIGINFO, 0x7f8c91df2bf0}, NULL, 8) = 0
> rt_sigaction(SIGRT_1, {0x7f8c91de9740, [], SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x7f8c91df2bf0}, NULL, 8) = 0
> rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
> readlink("/dev", 0x7fff5b9501c0, 4096)  = -1 EINVAL (Invalid argument)
> readlink("/dev/sda2", 0x7fff5b9501c0, 4096) = -1 EINVAL (Invalid argument)
> brk(0)                                  = 0x1169000
> brk(0x118a000)                          = 0x118a000
> clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f8c92dcea10) = 4904
> exit_group(0)                           = ?
> Process 4904 attached
> [pid  4903] +++ exited with 0 +++
> set_robust_list(0x7f8c92dcea20, 24)     = 0
> setsid()                                = 4904
> chdir("/")                              = 0
> close(0)                                = 0
> close(1)                                = 0
> close(2)                                = 0
> open("/dev/null", O_RDONLY)             = 0
> open("/dev/null", O_WRONLY)             = 1
> open("/dev/null", O_WRONLY)             = 2
> open("/etc/localtime", O_RDONLY|O_CLOEXEC) = 3
> fcntl(3, F_GETFD)                       = 0x1 (flags FD_CLOEXEC)
> fstat(3, {st_mode=S_IFREG|0644, st_size=1464, ...}) = 0
> fstat(3, {st_mode=S_IFREG|0644, st_size=1464, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8c92ddf000
> read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\16\0\0\0\16\0\0\0\0"..., 4096) = 1464
> lseek(3, -898, SEEK_CUR)                = 566
> read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\17\0\0\0\17\0\0\0\0"..., 4096) = 898
> close(3)                                = 0
> munmap(0x7f8c92ddf000, 4096)            = 0
> socket(PF_FILE, SOCK_DGRAM|SOCK_CLOEXEC, 0) = 3
> connect(3, {sa_family=AF_FILE, sun_path="/dev/log"}, 110) = -1 EPROTOTYPE (Protocol wrong type for socket)
> close(3)                                = 0
> socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC, 0) = 3
> connect(3, {sa_family=AF_FILE, sun_path="/dev/log"}, 110) = 0
> sendto(3, "<30>Aug 21 16:45:23 nilfs_cleane"..., 48, MSG_NOSIGNAL, NULL, 0) = 48
> open("/dev/sda2", O_RDONLY)             = 4
> ioctl(4, BLKGETSIZE64, 32967381466624)  = 0
> lseek(4, 1024, SEEK_SET)                = 1024
> read(4, "\2\0\0\0\0\00044\30\1\0\0\202z\264B\303|e\21\2\0\0\0\242\367;\0\0\0\0\0"..., 1024) = 1024
> lseek(4, 32967381458944, SEEK_SET)      = 32967381458944
> read(4, "\2\0\0\0\0\00044\30\1\0\0\202z\264B\303|e\21\2\0\0\0\242\367;\0\0\0\0\0"..., 1024) = 1024
> readlink("/dev", 0x7fff5b94e8d0, 4096)  = -1 EINVAL (Invalid argument)
> readlink("/dev/sda2", 0x7fff5b94e8d0, 4096) = -1 EINVAL (Invalid argument)
> open("/proc/mounts", O_RDONLY)          = 5
> fstat(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8c92ddf000
> read(5, "rootfs / rootfs rw 0 0\n/dev/root"..., 1024) = 582
> readlink("/dev", 0x7fff5b94e8d0, 4096)  = -1 EINVAL (Invalid argument)
> readlink("/dev/sda2", 0x7fff5b94e8d0, 4096) = -1 EINVAL (Invalid argument)
> close(5)                                = 0
> munmap(0x7f8c92ddf000, 4096)            = 0
> open("/archive", O_RDONLY)              = 5
> stat("/dev/sda2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 2), ...}) = 0
> statfs("/dev/shm", {f_type=0x1021994, f_bsize=4096, f_blocks=4111841, f_bfree=4111840, f_bavail=4111840, f_files=4111841, f_ffree=4111839, f_fsid={0, 0}, f_namelen=255, f_frsize=4096}) = 0
> futex(0x7f8c91ffe2e0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
> open("/dev/shm/sem.nilfs-cleaner-2050", O_RDWR|O_NOFOLLOW) = 6
> fstat(6, {st_mode=S_IFREG|0700, st_size=32, ...}) = 0
> mmap(NULL, 32, PROT_READ|PROT_WRITE, MAP_SHARED, 6, 0) = 0x7f8c92ddf000
> close(6)                                = 0
> stat("/etc/nilfs_cleanerd.conf", {st_mode=S_IFREG|0644, st_size=1815, ...}) = 0
> open("/etc/nilfs_cleanerd.conf", O_RDONLY) = 6
> fstat(6, {st_mode=S_IFREG|0644, st_size=1815, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8c92dde000
> read(6, "# nilfs_cleanerd.conf - configur"..., 4096) = 1815
> read(6, "", 4096)                       = 0
> close(6)                                = 0
> munmap(0x7f8c92dde000, 4096)            = 0
> stat("/dev/sda2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 2), ...}) = 0
> mq_open("nilfs-cleanerq-2050", O_RDONLY|O_CREAT, 0600, {mq_maxmsg=6, mq_msgsize=4096}) = 6
> rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
> rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
> rt_sigaction(SIGTERM, {0x403920, ~[RTMIN RT_1], SA_RESTORER, 0x7f8c92036bc0}, NULL, 8) = 0
> rt_sigaction(SIGHUP, {0x4038f0, ~[RTMIN RT_1], SA_RESTORER, 0x7f8c92036bc0}, NULL, 8) = 0
> sendto(3, "<30>Aug 21 16:45:23 nilfs_cleane"..., 62, MSG_NOSIGNAL, NULL, 0) = 62
> rt_sigprocmask(SIG_BLOCK, [HUP], NULL, 8) = 0
> ioctl(5, 0x80306e85, 0x7fff5b952510)    = 0
> sendto(3, "<30>Aug 21 16:45:23 nilfs_cleane"..., 63, MSG_NOSIGNAL, NULL, 0) = 63
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> mmap(NULL, 135168, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8c92dad000
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> mremap(0x7f8c92dad000, 135168, 266240, MREMAP_MAYMOVE) = 0x7f8c92d6c000
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> mremap(0x7f8c92d6c000, 266240, 528384, MREMAP_MAYMOVE) = 0x7f8c92ceb000
> ioctl(5, 0x80186e84, 0x7fff5b94f130)    = 0
> 
> and a lot of more ioctls and some mremaps
> 
> Sincerely,
> Yuriy Shkandybin
> 
> 
> 
> On Aug 21, 2012, at 4:29 PM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
> 
> > Hi,
> > 
> > On Tue, 2012-08-21 at 15:57 +0400, Yury Shkandybin wrote:
> >> Hello.
> >> 
> >> Recently i overloaded my nilfs2 partition with data.
> >> /dev/sda2        30T   29T  122G 100% /archive
> >> I've removed 4T and issued:
> >> rmcp -f 1.. 
> >> nilfs-clean -p 0
> >> , but used space left the same.
> >> Actually it keeps increasing.
> >> 
> > 
> > Did you stop garbage collection or not? Could share status of cleaner
> > (nilfs-clean -l)?
> > 
> > Moreover, could you share output of the mount utility (without any
> > options, please)?
> > 
> > Could you share output of lscp and lssu utilities?
> > 
> > Do you have any errors messages related to NILFS in the system log?
> > 
> > Could you share trace of nilfs_cleanerd start?
> > 
> > With the best regards,
> > Vyacheslav Dubeyko.
> > 
> >> I've tried different versions nilfs-utils ( now sys-fs/nilfs-utils-2.1.4)
> >> and kernels ( now sys-kernel/gentoo-sources-3.5.2)
> >> 
> >> nilfs_cleanerd  is running, keeping 1 LA
> >> According to debug output, it keeps cleaning garbage segments, but number of clean segments stays the same:
> >> Aug 21 15:42:38 WAYX017 nilfs_cleanerd[16907]: ncleansegs = 212114
> >> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: 4 segments selected to be cleaned
> >> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734108 cleaned
> >> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734109 cleaned
> >> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734110 cleaned
> >> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734111 cleaned
> >> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: adjust interval
> >> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: wait 0.000000
> >> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: wake up
> >> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: ncleansegs = 212114
> >> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: 4 segments selected to be cleaned
> >> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734112 cleaned
> >> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734113 cleaned
> >> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734114 cleaned
> >> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734115 cleaned
> >> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: adjust interval
> >> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: wait 0.000000
> >> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: wake up
> >> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: ncleansegs = 212114
> >> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: 4 segments selected to be cleaned
> >> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734116 cleaned
> >> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734117 cleaned
> >> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734118 cleaned
> >> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734119 cleaned
> >> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: adjust interval
> >> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: wait 0.000000
> >> 
> >> # cat /etc/nilfs_cleanerd.conf 
> >> protection_period       3600
> >> min_clean_segments      10%
> >> max_clean_segments      20%
> >> clean_check_interval    10
> >> selection_policy        timestamp       # timestamp in ascend order
> >> nsegments_per_clean     2
> >> mc_nsegments_per_clean  4
> >> cleaning_interval       5
> >> mc_cleaning_interval    1
> >> retry_interval          60
> >> use_mmap
> >> log_priority            debug
> >> 
> >> 
> >> There was hard resets in the past with this server.
> >> There is no snapshots.
> >> Filesystem was created with -O block_count
> >> 
> >> 
> >> 
> >> Sincerely,
> >> Yuriy Shkandybin
> >> 
> >> 
> >> 
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
