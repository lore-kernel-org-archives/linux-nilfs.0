From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs_cleanerd won't start for root filesystem
Date: Wed, 01 Aug 2012 09:21:11 +0200
Message-ID: <3290425.VTORBmyZ72@coil>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2019538.jRZKIY8uPP"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:subject:date:message-id:x-face:user-agent:mime-version
         :content-type:content-transfer-encoding;
        bh=YrTXz7i5HzC6vdlTuL4ofqQLzsFYjf1Nwf6Xb6jdDSg=;
        b=yhd7P1WXGAnCAeQ+YCKYBgtznT+rfCgUjlnb1Jj8pEh9OOCMrYgFE/SEPtl54KbOku
         PUFsG3I9JyehNergs+XnGIx0oOwWmnFWWLLQelwqHJoEK49pYQn1Rd5CHF8KEFEQpEsw
         05zIqIxl7fWmW5xDgMHDdmSF28RaBVw1H9sFa/9HR/1YWPaVCWrEVcp3hLNDa2pFrE/I
         gD42nK7clpLYQSfZNo54cVf/xRWGvTBocKaNR+GgYZuAJnxr/lYl/N0OZlqmm0FWzMRZ
         koTVZevIhs5UYbhzoEQRuUnmg17DlJsv5VdBT/mkgKwsNDlwhqip4DFm0+UpQiE1RKWc
         fjFQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


--nextPart2019538.jRZKIY8uPP
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi list,


I've upgraded kernel to v3.5 and udev to v182. Now nilfs_cleanerd won't=
 start=20
for root filesystem, even when executed by hand. Attach'd strace output=
 and=20
/proc/mounts. It seems the problem is there's no /dev/root symlink anym=
ore.


My root fs is /dev/sda3, command line:
# strace -f -o a.log -s 128 nilfs_cleanerd /dev/sda3

# nilfs_cleanerd-bin --version
nilfs_cleanerd-bin (nilfs-utils 2.1.4)


--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

"all dichotomies are either true or false" is a true paradox because it=
's=20
paradoxical only if it is a paradox ;)
--nextPart2019538.jRZKIY8uPP
Content-Disposition: attachment; filename="a.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="a.log"

26959 execve("/sbin/nilfs_cleanerd-bin", ["nilfs_cleanerd-bin", "/dev/sda3"], [/* 40 vars */]) = 0
26959 brk(0)                            = 0x23c4000
26959 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0d116e4000
26959 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
26959 open("/usr/lib64/tls/x86_64/libnilfs.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
26959 stat("/usr/lib64/tls/x86_64", 0x7fff923ab910) = -1 ENOENT (No such file or directory)
26959 open("/usr/lib64/tls/libnilfs.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
26959 stat("/usr/lib64/tls", 0x7fff923ab910) = -1 ENOENT (No such file or directory)
26959 open("/usr/lib64/x86_64/libnilfs.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
26959 stat("/usr/lib64/x86_64", 0x7fff923ab910) = -1 ENOENT (No such file or directory)
26959 open("/usr/lib64/libnilfs.so.0", O_RDONLY|O_CLOEXEC) = 3
26959 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000\27\0\0\0\0\0\0@\0\0\0\0\0\0\0008H\0\0\0\0\0\0\0\0\0\0@\0008\0\5\0@\0\31\0\30\0\1\0\0\0\5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\34=\0\0\0\0\0\0\34=\0\0\0\0\0\0\0\0 \0\0\0\0\0\1\0\0\0\6\0\0\0"..., 832) = 832
26959 fstat(3, {st_mode=S_IFREG|0755, st_size=20088, ...}) = 0
26959 mmap(NULL, 2115440, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f0d112be000
26959 mprotect(0x7f0d112c2000, 2097152, PROT_NONE) = 0
26959 mmap(0x7f0d114c2000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x4000) = 0x7f0d114c2000
26959 close(3)                          = 0
26959 open("/usr/lib64/libnilfsgc.so.0", O_RDONLY|O_CLOEXEC) = 3
26959 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0 \24\0\0\0\0\0\0@\0\0\0\0\0\0\0h4\0\0\0\0\0\0\0\0\0\0@\0008\0\5\0@\0\31\0\30\0\1\0\0\0\5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\344.\0\0\0\0\0\0\344.\0\0\0\0\0\0\0\0 \0\0\0\0\0\1\0\0\0\6\0\0\0"..., 832) = 832
26959 fstat(3, {st_mode=S_IFREG|0755, st_size=15016, ...}) = 0
26959 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0d112bd000
26959 mmap(NULL, 2110368, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f0d110b9000
26959 mprotect(0x7f0d110bc000, 2097152, PROT_NONE) = 0
26959 mmap(0x7f0d112bc000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f0d112bc000
26959 close(3)                          = 0
26959 open("/usr/lib64/librt.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
26959 open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
26959 fstat(3, {st_mode=S_IFREG|0644, st_size=202058, ...}) = 0
26959 mmap(NULL, 202058, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f0d11087000
26959 close(3)                          = 0
26959 open("/lib64/librt.so.1", O_RDONLY|O_CLOEXEC) = 3
26959 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\"\0\0\0\0\0\0@\0\0\0\0\0\0\0\270s\0\0\0\0\0\0\0\0\0\0@\0008\0\t\0@\0\"\0\37\0\6\0\0\0\5\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\370\1\0\0\0\0\0\0\370\1\0\0\0\0\0\0\10\0\0\0\0\0\0\0\3\0\0\0\4\0\0\0"..., 832) = 832
26959 fstat(3, {st_mode=S_IFREG|0755, st_size=42620, ...}) = 0
26959 mmap(NULL, 2128984, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f0d10e7f000
26959 mprotect(0x7f0d10e86000, 2093056, PROT_NONE) = 0
26959 mmap(0x7f0d11085000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6000) = 0x7f0d11085000
26959 close(3)                          = 0
26959 open("/usr/lib64/libuuid.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
26959 open("/lib64/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
26959 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200\23\0\0\0\0\0\0@\0\0\0\0\0\0\0`/\0\0\0\0\0\0\0\0\0\0@\0008\0\6\0@\0\34\0\33\0\1\0\0\0\5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\354*\0\0\0\0\0\0\354*\0\0\0\0\0\0\0\0 \0\0\0\0\0\1\0\0\0\6\0\0\0"..., 832) = 832
26959 fstat(3, {st_mode=S_IFREG|0755, st_size=13920, ...}) = 0
26959 mmap(NULL, 2109072, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f0d10c7c000
26959 mprotect(0x7f0d10c7f000, 2093056, PROT_NONE) = 0
26959 mmap(0x7f0d10e7e000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f0d10e7e000
26959 close(3)                          = 0
26959 open("/usr/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
26959 open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
26959 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\33\2\0\0\0\0\0@\0\0\0\0\0\0\0\370y\33\0\0\0\0\0\0\0\0\0@\0008\0\n\0@\0&\0#\0\6\0\0\0\5\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0000\2\0\0\0\0\0\0000\2\0\0\0\0\0\0\10\0\0\0\0\0\0\0\3\0\0\0\4\0\0\0"..., 832) = 832
26959 fstat(3, {st_mode=S_IFREG|0755, st_size=2048386, ...}) = 0
26959 mmap(NULL, 3916984, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f0d108bf000
26959 mprotect(0x7f0d10a72000, 2093056, PROT_NONE) = 0
26959 mmap(0x7f0d10c71000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1b2000) = 0x7f0d10c71000
26959 mmap(0x7f0d10c77000, 17592, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f0d10c77000
26959 close(3)                          = 0
26959 open("/usr/lib64/libpthread.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
26959 open("/lib64/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
26959 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000l\0\0\0\0\0\0@\0\0\0\0\0\0\0\320s\1\0\0\0\0\0\0\0\0\0@\0008\0\t\0@\0\"\0\37\0\6\0\0\0\5\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\370\1\0\0\0\0\0\0\370\1\0\0\0\0\0\0\10\0\0\0\0\0\0\0\3\0\0\0\4\0\0\0"..., 832) = 832
26959 fstat(3, {st_mode=S_IFREG|0755, st_size=130859, ...}) = 0
26959 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0d116e3000
26959 mmap(NULL, 2208776, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f0d106a3000
26959 mprotect(0x7f0d106ba000, 2093056, PROT_NONE) = 0
26959 mmap(0x7f0d108b9000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x16000) = 0x7f0d108b9000
26959 mmap(0x7f0d108bb000, 13320, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f0d108bb000
26959 close(3)                          = 0
26959 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0d116e2000
26959 mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0d116e0000
26959 arch_prctl(ARCH_SET_FS, 0x7f0d116e0780) = 0
26959 mprotect(0x7f0d10c71000, 16384, PROT_READ) = 0
26959 mprotect(0x7f0d108b9000, 4096, PROT_READ) = 0
26959 mprotect(0x7f0d11085000, 4096, PROT_READ) = 0
26959 mprotect(0x7f0d116e5000, 4096, PROT_READ) = 0
26959 munmap(0x7f0d11087000, 202058)    = 0
26959 set_tid_address(0x7f0d116e0a50)   = 26959
26959 set_robust_list(0x7f0d116e0a60, 0x18) = 0
26959 rt_sigaction(SIGRTMIN, {0x7f0d106a9790, [], SA_RESTORER|SA_SIGINFO, 0x7f0d106b24e0}, NULL, 8) = 0
26959 rt_sigaction(SIGRT_1, {0x7f0d106a9810, [], SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x7f0d106b24e0}, NULL, 8) = 0
26959 rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
26959 getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
26959 readlink("/dev", 0x7fff923a9cf0, 4096) = -1 EINVAL (Invalid argument)
26959 readlink("/dev/sda3", 0x7fff923a9cf0, 4096) = -1 EINVAL (Invalid argument)
26959 brk(0)                            = 0x23c4000
26959 brk(0x23e5000)                    = 0x23e5000
26959 clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f0d116e0a50) = 26960
26959 exit_group(0)                     = ?
26960 set_robust_list(0x7f0d116e0a60, 0x18) = 0
26960 setsid()                          = 26960
26960 chdir("/")                        = 0
26960 close(0)                          = 0
26960 close(1)                          = 0
26960 close(2)                          = 0
26960 open("/dev/null", O_RDONLY)       = 0
26960 open("/dev/null", O_WRONLY)       = 1
26960 open("/dev/null", O_WRONLY)       = 2
26960 open("/etc/localtime", O_RDONLY|O_CLOEXEC) = 3
26960 fstat(3, {st_mode=S_IFREG|0644, st_size=2679, ...}) = 0
26960 fstat(3, {st_mode=S_IFREG|0644, st_size=2679, ...}) = 0
26960 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0d116df000
26960 read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0\n\0\0\0\0\0\0\0\247\0\0\0\n\0\0\0\26\231\250*\320\233\f\27`\233\325\332\360\234\331\256\220\235\244\265\220\236\271\220\220\237\204\227\220\240\232\266\0\241e\275\0\246}|`\310v\336\20\314\347K\20\315\251\27\220\316\242C\20\317\2224\20\320\200\251`\320\204\272\0\321\225\222p\322\212\273`\323b\377p\324K#\220"..., 4096) = 2679
26960 lseek(3, -1698, SEEK_CUR)         = 981
26960 read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\v\0\0\0\v\0\0\0\0\0\0\0\250\0\0\0\v\0\0\0\32\377\377\377\377V\266\320P\377\377\377\377\231\250*\320\377\377\377\377\233\f\27`\377\377\377\377\233\325\332\360\377\377\377\377\234\331\256\220\377\377\377\377\235\244\265\220\377\377\377\377\236\271\220\220\377\377\377\377\237\204\227\220\377\377\377\377\240\232\266\0\377\377\377\377\241e\275\0\377\377\377\377"..., 4096) = 1698
26960 lseek(3, 2678, SEEK_SET)          = 2678
26960 close(3)                          = 0
26960 munmap(0x7f0d116df000, 4096)      = 0
26960 socket(PF_FILE, SOCK_DGRAM|SOCK_CLOEXEC, 0) = 3
26960 connect(3, {sa_family=AF_FILE, path="/dev/log"}, 110) = 0
26960 sendto(3, "<30>Aug  1 09:17:51 nilfs_cleanerd-bin[26960]: start", 52, MSG_NOSIGNAL, NULL, 0) = 52
26960 open("/dev/sda3", O_RDONLY)       = 4
26960 ioctl(4, BLKGETSIZE64, 0x7fff923aac98) = 0
26960 lseek(4, 1024, SEEK_SET)          = 1024
26960 read(4, "\2\0\0\0\0\00044\30\1\0\0\312:\256\260%U\257\232\2\0\0\0\377E\0\0\0\0\0\0\0\0\0\0#\0\0\0\1\0\0\0\0\0\0\0\0\10\0\0\5\0\0\0+\2\177\0\0\0\0\0\20\360\177\1\0\0\0\0e\224\20\0\0\0\0\0\0\340\205\1\0\0\0\0\346\332\217M\0\0\0\0\10\260\27P\0\0\0\0>\326\30P\0\0\0\0\331\0002\0\2\0\1\0\346\332\217M\0\0\0\0"..., 1024) = 1024
26960 lseek(4, 150325211136, SEEK_SET)  = 150325211136
26960 read(4, "\2\0\0\0\0\00044\30\1\0\0\312:\256\260\356\374\3i\2\0\0\0\377E\0\0\0\0\0\0\0\0\0\0#\0\0\0\1\0\0\0\0\0\0\0\0\10\0\0\5\0\0\0\333\1\177\0\0\0\0\0\"\340\177\1\0\0\0\0c\224\20\0\0\0\0\0\0\360\205\1\0\0\0\0\346\332\217M\0\0\0\0\10\260\27P\0\0\0\0w\272\30P\0\0\0\0\331\0002\0\2\0\1\0\346\332\217M\0\0\0\0"..., 1024) = 1024
26960 readlink("/dev", 0x7fff923a8400, 4096) = -1 EINVAL (Invalid argument)
26960 readlink("/dev/sda3", 0x7fff923a8400, 4096) = -1 EINVAL (Invalid argument)
26960 open("/proc/mounts", O_RDONLY)    = 5
26960 fstat(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
26960 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0d116df000
26960 read(5, "rootfs / rootfs rw 0 0\n/dev/root / nilfs2 rw,relatime 0 0\ndevtmpfs /dev devtmpfs rw,relatime,size=3015980k,nr_inodes=753995,mode"..., 1024) = 716
26960 readlink("/dev", 0x7fff923a8400, 4096) = -1 EINVAL (Invalid argument)
26960 readlink("/dev/root", 0x7fff923a8400, 4096) = -1 ENOENT (No such file or directory)
26960 readlink("/dev", 0x7fff923a8400, 4096) = -1 EINVAL (Invalid argument)
26960 readlink("/dev/sdb3", 0x7fff923a8400, 4096) = -1 EINVAL (Invalid argument)
26960 read(5, "", 1024)                 = 0
26960 close(5)                          = 0
26960 munmap(0x7f0d116df000, 4096)      = 0
26960 sendto(3, "<27>Aug  1 09:17:51 nilfs_cleanerd-bin[26960]: cannot open nilfs on /dev/sda3: No such file or directory", 104, MSG_NOSIGNAL, NULL, 0) = 104
26960 sendto(3, "<27>Aug  1 09:17:51 nilfs_cleanerd-bin[26960]: cannot create cleanerd on /dev/sda3: No such file or directory", 109, MSG_NOSIGNAL, NULL, 0) = 109
26960 sendto(3, "<30>Aug  1 09:17:51 nilfs_cleanerd-bin[26960]: shutdown", 55, MSG_NOSIGNAL, NULL, 0) = 55
26960 close(3)                          = 0
26960 exit_group(1)                     = ?

--nextPart2019538.jRZKIY8uPP
Content-Disposition: attachment; filename="mounts"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="mounts"

rootfs / rootfs rw 0 0
/dev/root / nilfs2 rw,relatime 0 0
devtmpfs /dev devtmpfs rw,relatime,size=3015980k,nr_inodes=753995,mode=755 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
tmpfs /run tmpfs rw,relatime,mode=755 0 0
devpts /dev/pts devpts rw,relatime,gid=5,mode=620 0 0
cgroup /sys/fs/cgroup cgroup rw,relatime,blkio,memory,cpuacct,cpu 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
/dev/sdb3 /home nilfs2 rw,noatime 0 0
tmpfs /dev/shm tmpfs rw,relatime,size=344064k 0 0
/dev/sda2 /boot ext2 rw,noatime 0 0
/dev/sdb4 /mnt/bulk-0 ext4 rw,noatime,data=ordered 0 0
gvfs-fuse-daemon /home/dexen/.gvfs fuse.gvfs-fuse-daemon rw,nosuid,nodev,relatime,user_id=1000,group_id=100 0 0

--nextPart2019538.jRZKIY8uPP--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
