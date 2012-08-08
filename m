From: Paolo Giangrandi <paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org>
Subject: Re: nilfs2 not garbage collecting
Date: Wed, 8 Aug 2012 17:08:51 +0200
Message-ID: <CANku=ggwvtpDQUD=1uD9LU7kdfy5m2LPE64x4mmfFA1h+J+S3g@mail.gmail.com>
References: <CANku=ggohcWWoxE1x=XmfWpANKyWRTWb5p_aHh8LU6+utU4OPQ@mail.gmail.com>
	<CANku=ghnDzkFHpPZ8eT9Y3kTM62zBKMk6TjBVraE4Kisa1TRPQ@mail.gmail.com>
	<F7DFCB7F-9015-4051-9A60-5056EAB81E4D@dubeyko.com>
	<CANku=ghdeeSLP6QsJh9jvs5fJwEYuTTV7w8iigE1nZoT74NYgQ@mail.gmail.com>
	<1344232478.1912.9.camel@slavad-ubuntu-11>
	<CANku=ggMp_gBgijee2umhNf5dBQO4zvmqopKBz70V1Z81oShVA@mail.gmail.com>
	<1344406417.1922.11.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=CAzkTBjNpgWVIBr8Rbnnfuvb1waUrdn8dmN0npqaDWw=;
        b=SlY3e65zFcDxh8Ap9AxL4snGRDXbktjkWvdSXjGxsIzQmv0YAUQ5LHuIcJs7w4PkWu
         0x5CCsjCL25EoWV2QiV/Ja/FjVTH2YVGijt0BkV81If0ijAmN06elG5wbCuNuRsQ4yk2
         NLUhwgFCYE8jYJhogZAb+H3A79ugU42pawCuIr4iiRjnbojJ47uDj/CYsIWCZd5MGgFX
         TjkCThiD7kKsCG5ig/nlcWgl2LT64XZzbhqAbOOzYzBRLeFbdw6ZnkKH9Kqvz959Deg8
         MLfDvfh/OtRSd/sKB2ZF+AW7ngmdJUQGWE7Ono9wsvkFn4X5aCnjSpauAKCPK8bNVofe
         eC1A==
In-Reply-To: <1344406417.1922.11.camel@slavad-ubuntu-11>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

After creating an image of the filesystem, I erased all of the
checkpoints (`rmcp ..305356`, it worked, as confirmed by `lscp`).
nilfs_cleanerd (run with ArchLinux default options) didn't release any
space until I ran `nilfs-clean -p0`. At that point these lines got
appended to the log files:

/var/log/everything.log:Mar  1 15:38:34 localhost nilfs_cleanerd[944]:
received run command
/var/log/everything.log:Mar  1 15:38:34 localhost nilfs_cleanerd[944]:
run (manual)
/var/log/everything.log:Mar  1 15:38:34 localhost nilfs_cleanerd[944]:
command run acked
/var/log/everything.log:Mar  1 15:38:34 localhost nilfs_cleanerd[944]:
ncleansegs = 48
/var/log/everything.log:Mar  1 15:38:34 localhost nilfs_cleanerd[944]:
4 segments selected to be cleaned
/var/log/everything.log:Mar  1 15:38:36 localhost nilfs_cleanerd[944]:
segment 806 cleaned
/var/log/everything.log:Mar  1 15:38:36 localhost nilfs_cleanerd[944]:
segment 807 cleaned
/var/log/everything.log:Mar  1 15:38:36 localhost nilfs_cleanerd[944]:
segment 808 cleaned
/var/log/everything.log:Mar  1 15:38:36 localhost nilfs_cleanerd[944]:
segment 809 cleaned
/var/log/everything.log:Mar  1 15:38:36 localhost nilfs_cleanerd[944]:
adjust interval
/var/log/everything.log:Mar  1 15:38:36 localhost nilfs_cleanerd[944]:
wait 0.000000
/var/log/everything.log:Mar  1 15:38:36 localhost nilfs_cleanerd[944]: wake up
/var/log/everything.log:Mar  1 15:38:36 localhost nilfs_cleanerd[944]:
ncleansegs = 52
/var/log/everything.log:Mar  1 15:38:36 localhost nilfs_cleanerd[944]:
3 segments selected to be cleaned
/var/log/everything.log:Mar  1 15:38:38 localhost nilfs_cleanerd[944]:
segment 810 cleaned
/var/log/everything.log:Mar  1 15:38:38 localhost nilfs_cleanerd[944]:
segment 811 cleaned
/var/log/everything.log:Mar  1 15:38:38 localhost nilfs_cleanerd[944]:
segment 812 cleaned
/var/log/everything.log:Mar  1 15:38:38 localhost nilfs_cleanerd[944]:
adjust interval
/var/log/everything.log:Mar  1 15:38:38 localhost nilfs_cleanerd[944]:
wait 0.000000
/var/log/everything.log:Mar  1 15:38:38 localhost nilfs_cleanerd[944]:
received get-status command
/var/log/everything.log:Mar  1 15:38:38 localhost nilfs_cleanerd[944]:
command get-status acked
/var/log/everything.log:Mar  1 15:38:38 localhost nilfs_cleanerd[944]:
ncleansegs = 54
/var/log/everything.log:Mar  1 15:38:38 localhost nilfs_cleanerd[944]:
0 segment selected to be cleaned
/var/log/everything.log:Mar  1 15:38:38 localhost nilfs_cleanerd[944]:
manual run completed
/var/log/everything.log:Mar  1 15:38:38 localhost nilfs_cleanerd[944]:
wait 10.000000

and a few kilobytes got free'd:
# df | grep sda2
/dev/sda2                          7839740 7397372     49152 100% /mnt

Now nilfs_cleanerd seems unable again to free more space.
Should I try anything else, before recreating the filesystem?
If you are interested into it, I can share the 7.5GB raw filesystem image.

On Wed, Aug 8, 2012 at 8:13 AM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
> Hi Paolo,
>
> I can't see any strange or suspicious in your traces. As I can
> understand, nilfs_cleanerd is working with proper volume. If you have
> freshly updated system then you have actual state of nilfs-utils (maybe
> without one commit which is not important for the issue).
>
> I think that maybe date of some checkpoints (and the sequence) on your
> file system can confuse nilfs-cleanerd. This supposition needs in more
> detailed investigation.
>
> So, could you share information about nilfs-cleanerd's behavior after
> manual checkpoints deletion?
>
> With the best regards,
> Vyacheslav Dubeyko.
>
>
> On Mon, 2012-08-06 at 16:07 +0200, Paolo Giangrandi wrote:
>> On Mon, Aug 6, 2012 at 7:54 AM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
>> > Hi Paolo,
>> >
>> > Could you share full output of mount utility? I feel that I haven't full
>> > picture without this output.
>> >
>> > Moreover, it needs to more details about nilfs_cleanerd activity. Could
>> > you try to kill started by default nilfs_cleanerd and try to start
>> > nilfs_cleanerd manually with strace utility? Then it will be very
>> > interesting to see output of strace.
>> >
>> > With the best regards,
>> > Vyacheslav Dubeyko.
>> >
>>
>> `mount` is quite quiet:
>> # mount -v /dev/sda2 /mnt/sda2
>> mount.nilfs2: started nilfs_cleanerd
>>
>> About strace:
>> # nilfs-clean -q
>> # strace -o nilfs_cleanerd.strace nilfs_cleanerd -n /dev/sda2 /mnt/sda2
>> The content of nilfs_cleanerd.strace is now:
>> ---
>> execve("/sbin/nilfs_cleanerd", ["nilfs_cleanerd", "-n", "/dev/sda2",
>> "/mnt/sda2"], [/* 29 vars */]) = 0
>> brk(0)                                  = 0x9534000
>> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
>> 0) = 0xb77b7000
>> access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
>> open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
>> fstat64(3, {st_mode=S_IFREG|0644, st_size=26475, ...}) = 0
>> mmap2(NULL, 26475, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb77b0000
>> close(3)                                = 0
>> open("/lib/libnilfs.so.0", O_RDONLY|O_CLOEXEC) = 3
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\300\22\0\0004\0\0\0"...,
>> 512) = 512
>> fstat64(3, {st_mode=S_IFREG|0755, st_size=22980, ...}) = 0
>> mmap2(NULL, 25796, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
>> 0) = 0xb77a9000
>> mmap2(0xb77ae000, 8192, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x4) = 0xb77ae000
>> close(3)                                = 0
>> open("/lib/libnilfsgc.so.0", O_RDONLY|O_CLOEXEC) = 3
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\300\16\0\0004\0\0\0"...,
>> 512) = 512
>> fstat64(3, {st_mode=S_IFREG|0755, st_size=17844, ...}) = 0
>> mmap2(NULL, 16564, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
>> 0) = 0xb77a4000
>> mmap2(0xb77a7000, 8192, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3) = 0xb77a7000
>> close(3)                                = 0
>> open("/lib/librt.so.1", O_RDONLY|O_CLOEXEC) = 3
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@\31\0\0004\0\0\0"...,
>> 512) = 512
>> fstat64(3, {st_mode=S_IFREG|0755, st_size=30684, ...}) = 0
>> mmap2(NULL, 33356, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
>> 0) = 0xb779b000
>> mmap2(0xb77a2000, 8192, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6) = 0xb77a2000
>> close(3)                                = 0
>> open("/lib/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320\20\0\0004\0\0\0"...,
>> 512) = 512
>> fstat64(3, {st_mode=S_IFREG|0755, st_size=18028, ...}) = 0
>> mmap2(NULL, 20712, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
>> 0) = 0xb7795000
>> mmap2(0xb7799000, 8192, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3) = 0xb7799000
>> close(3)                                = 0
>> open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
>> read(3, "\177ELF\1\1\1\3\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`\227\1\0004\0\0\0"...,
>> 512) = 512
>> fstat64(3, {st_mode=S_IFREG|0755, st_size=1967415, ...}) = 0
>> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
>> 0) = 0xb7794000
>> mmap2(NULL, 1727172, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE,
>> 3, 0) = 0xb75ee000
>> mprotect(0xb778d000, 4096, PROT_NONE)   = 0
>> mmap2(0xb778e000, 12288, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19f) = 0xb778e000
>> mmap2(0xb7791000, 10948, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7791000
>> close(3)                                = 0
>> open("/lib/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P[\0\0004\0\0\0"...,
>> 512) = 512
>> fstat64(3, {st_mode=S_IFREG|0755, st_size=130395, ...}) = 0
>> mmap2(NULL, 107004, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
>> 0) = 0xb75d3000
>> mmap2(0xb75ea000, 8192, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x16) = 0xb75ea000
>> mmap2(0xb75ec000, 4604, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb75ec000
>> close(3)                                = 0
>> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
>> 0) = 0xb75d2000
>> set_thread_area({entry_number:-1 -> 6, base_addr:0xb75d2940,
>> limit:1048575, seg_32bit:1, contents:0, read_exec_only:0,
>> limit_in_pages:1, seg_not_present:0, useable:1}) = 0
>> mprotect(0xb778e000, 8192, PROT_READ)   = 0
>> mprotect(0xb75ea000, 4096, PROT_READ)   = 0
>> mprotect(0xb7799000, 4096, PROT_READ)   = 0
>> mprotect(0xb77a2000, 4096, PROT_READ)   = 0
>> mprotect(0xb77ae000, 4096, PROT_READ)   = 0
>> mprotect(0xb77a7000, 4096, PROT_READ)   = 0
>> mprotect(0x804e000, 4096, PROT_READ)    = 0
>> mprotect(0xb77d9000, 4096, PROT_READ)   = 0
>> munmap(0xb77b0000, 26475)               = 0
>> set_tid_address(0xb75d29a8)             = 1026
>> set_robust_list(0xb75d29b0, 12)         = 0
>> rt_sigaction(SIGRTMIN, {0xb75d85f0, [], SA_SIGINFO}, NULL, 8) = 0
>> rt_sigaction(SIGRT_1, {0xb75d8680, [], SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
>> rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
>> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
>> uname({sys="Linux", node="archiso", ...}) = 0
>> readlink("/dev", 0xbfe242ab, 4096)      = -1 EINVAL (Invalid argument)
>> readlink("/dev/sda2", 0xbfe242ab, 4096) = -1 EINVAL (Invalid argument)
>> brk(0)                                  = 0x9534000
>> brk(0x9555000)                          = 0x9555000
>> readlink("/mnt", 0xbfe242ab, 4096)      = -1 EINVAL (Invalid argument)
>> readlink("/mnt/sda2", 0xbfe242ab, 4096) = -1 EINVAL (Invalid argument)
>> setsid()                                = 1026
>> chdir("/")                              = 0
>> close(0)                                = 0
>> close(1)                                = 0
>> close(2)                                = 0
>> open("/dev/null", O_RDONLY|O_LARGEFILE) = 0
>> open("/dev/null", O_WRONLY|O_LARGEFILE) = 1
>> open("/dev/null", O_WRONLY|O_LARGEFILE) = 2
>> time(NULL)                              = 1344261563
>> open("/etc/localtime", O_RDONLY|O_CLOEXEC) = 3
>> fstat64(3, {st_mode=S_IFREG|0644, st_size=118, ...}) = 0
>> fstat64(3, {st_mode=S_IFREG|0644, st_size=118, ...}) = 0
>> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
>> 0) = 0xb77b6000
>> read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\1\0\0\0\0"...,
>> 1024) = 118
>> _llseek(3, -6, [112], SEEK_CUR)         = 0
>> read(3, "\nUTC0\n", 1024)               = 6
>> _llseek(3, 117, [117], SEEK_SET)        = 0
>> close(3)                                = 0
>> munmap(0xb77b6000, 4096)                = 0
>> socket(PF_FILE, SOCK_DGRAM|SOCK_CLOEXEC, 0) = 3
>> connect(3, {sa_family=AF_FILE, sun_path="/dev/log"}, 110) = 0
>> send(3, "<30>Aug  6 13:59:23 nilfs_cleane"..., 47, MSG_NOSIGNAL) = 47
>> open("/dev/sda2", O_RDONLY|O_LARGEFILE) = 4
>> ioctl(4, BLKGETSIZE64, 8036098560)      = 0
>> _llseek(4, 1024, [1024], SEEK_SET)      = 0
>> read(4, "\2\0\0\0\0\00044\30\1\0\0|\254\177\302\275p\270\257\2\0\0\0\275\3\0\0\0\0\0\0"...,
>> 1024) = 1024
>> _llseek(4, 8036093952, [8036093952], SEEK_SET) = 0
>> read(4, "\2\0\0\0\0\00044\30\1\0\0|\254\177\302\275p\270\257\2\0\0\0\275\3\0\0\0\0\0\0"...,
>> 1024) = 1024
>> readlink("/dev", 0xbfe229eb, 4096)      = -1 EINVAL (Invalid argument)
>> readlink("/dev/sda2", 0xbfe229eb, 4096) = -1 EINVAL (Invalid argument)
>> readlink("/mnt", 0xbfe229eb, 4096)      = -1 EINVAL (Invalid argument)
>> readlink("/mnt/sda2", 0xbfe229eb, 4096) = -1 EINVAL (Invalid argument)
>> open("/proc/mounts", O_RDONLY|O_LARGEFILE) = 5
>> fstat64(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
>> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
>> 0) = 0xb77b6000
>> read(5, "rootfs / rootfs rw 0 0\nproc /pro"..., 1024) = 1024
>> read(5, "s2 rw,relatime 0 0\n", 1024)   = 19
>> readlink("/mnt", 0xbfe229eb, 4096)      = -1 EINVAL (Invalid argument)
>> readlink("/mnt/sda2", 0xbfe229eb, 4096) = -1 EINVAL (Invalid argument)
>> readlink("/dev", 0xbfe229eb, 4096)      = -1 EINVAL (Invalid argument)
>> readlink("/dev/sda2", 0xbfe229eb, 4096) = -1 EINVAL (Invalid argument)
>> close(5)                                = 0
>> munmap(0xb77b6000, 4096)                = 0
>> open("/mnt/sda2", O_RDONLY|O_LARGEFILE) = 5
>> stat64("/dev/sda2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 2), ...}) = 0
>> statfs("/dev/shm", {f_type=0x1021994, f_bsize=4096, f_blocks=127669,
>> f_bfree=127668, f_bavail=127668, f_files=127669, f_ffree=127667,
>> f_fsid={0, 0}, f_namelen=255, f_frsize=4096}) = 0
>> futex(0xb75ed1a8, FUTEX_WAKE_PRIVATE, 2147483647) = 0
>> open("/dev/shm/sem.nilfs-cleaner-2050", O_RDWR|O_NOFOLLOW) = 6
>> fstat64(6, {st_mode=S_IFREG|0700, st_size=16, ...}) = 0
>> mmap2(NULL, 16, PROT_READ|PROT_WRITE, MAP_SHARED, 6, 0) = 0xb77b6000
>> close(6)                                = 0
>> stat64("/etc/nilfs_cleanerd.conf", {st_mode=S_IFREG|0644,
>> st_size=1813, ...}) = 0
>> open("/etc/nilfs_cleanerd.conf", O_RDONLY|O_LARGEFILE) = 6
>> fstat64(6, {st_mode=S_IFREG|0644, st_size=1813, ...}) = 0
>> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
>> 0) = 0xb77b5000
>> read(6, "# nilfs_cleanerd.conf - configur"..., 4096) = 1813
>> read(6, "", 4096)                       = 0
>> close(6)                                = 0
>> munmap(0xb77b5000, 4096)                = 0
>> stat64("/dev/sda2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 2), ...}) = 0
>> mq_open("nilfs-cleanerq-2050", O_RDONLY|O_CREAT, 0600, {mq_maxmsg=6,
>> mq_msgsize=4096}) = 6
>> rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
>> rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
>> rt_sigaction(SIGTERM, {0x804b260, ~[RTMIN RT_1], 0}, NULL, 8) = 0
>> rt_sigaction(SIGHUP, {0x804b250, ~[RTMIN RT_1], 0}, NULL, 8) = 0
>> gettimeofday({1344261563, 753241}, NULL) = 0
>> time(NULL)                              = 1344261563
>> send(3, "<30>Aug  6 13:59:23 nilfs_cleane"..., 61, MSG_NOSIGNAL) = 61
>> rt_sigprocmask(SIG_BLOCK, [HUP], NULL, 8) = 0
>> ioctl(5, 0x80306e85, 0xbfe253d0)        = 0
>> time(NULL)                              = 1344261563
>> send(3, "<30>Aug  6 13:59:23 nilfs_cleane"..., 62, MSG_NOSIGNAL) = 62
>> gettimeofday({1344261563, 755312}, NULL) = 0
>> ioctl(5, 0x80186e84, 0xbfe23218)        = 0
>> ioctl(5, 0x80186e84, 0xbfe23218)        = 0
>> gettimeofday({1344261563, 756199}, NULL) = 0
>> rt_sigprocmask(SIG_UNBLOCK, [HUP], NULL, 8) = 0
>> gettimeofday({1344261563, 756672}, NULL) = 0
>> mq_timedreceive(6, #
>> ---
>>
>> This time I used the default nilfs_cleanerd.conf as provided by arch:
>> # cat /etc/nilfs_cleanerd.conf | grep -v "^#" | grep -v "^$"
>> protection_period       3600
>> min_clean_segments      10%
>> max_clean_segments      20%
>> clean_check_interval    10
>> selection_policy        timestamp       # timestamp in ascend order
>> nsegments_per_clean     2
>> mc_nsegments_per_clean  4
>> cleaning_interval       5
>> mc_cleaning_interval    1
>> retry_interval          60
>> use_mmap
>> log_priority            info
>>
>>
>> Tomorrow I'll backup the content of that filesystem and will try to
>> manually remove some checkpoints.
>>
>> In case you need it, I could create a snapshot of the whole filesystem
>> and share it.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
