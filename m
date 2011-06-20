From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: RE: mount & fsck of nilfs partition fail.
Date: Mon, 20 Jun 2011 11:27:49 -0700
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181B05E99CC6@COLOSSEXCH01.starsolutions.com>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05E99563@COLOSSEXCH01.starsolutions.com>
	<20110618.032928.182500686.ryusuke@osrg.net>
	<053D39D3D76C474EB2D2A284AA6BA3181B05E99A12@COLOSSEXCH01.starsolutions.com>
 <20110618.135312.64853996.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110618.135312.64853996.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Ryusuke,
  Sorry, I was away on the w/e. I've attached the console trace and the out file again for posterity. I will be upgrading to the recently released 2.0.22 version, and will try to mount the corrupted filesystem with it - unlikely, it will work, though it should help on future filesystems based on nilfs2? Thanks for the fsck help and the new release for older kernels. Please let me know if you need anything further, such that I can recover the corrupted filesystem.

Zahid

The console trace:
/sbin/fsck0.nilfs2 -f -v /dev/sda2
Super-block:
    revision = 2.0
    blocksize = 4096
    write time = 2011-06-11 23:22:03
    indicated log: blocknr = 1648528
        segnum = 804, seq = 401758, cno=3250953

Unclean FS.
The latest log is lost. Trying rollback recovery..
......
Searching the latest checkpoint.
get_latest_cno: log_start=1556429 (segnum=759): nfinfo=6, fblocknr=1556430
get_latest_cno: finfo: ino=17874, sum-blocknr=1556429, offset=80, nblocks=2, ndatablk=1, fblocknr=1556430
get_latest_cno: finfo: ino=17875, sum-blocknr=1556429, offset=128, nblocks=1, ndatablk=1, fblocknr=1556432
get_latest_cno: finfo: ino=6, sum-blocknr=1556429, offset=168, nblocks=2, ndatablk=1, fblocknr=1556433
get_latest_cno: finfo: ino=4, sum-blocknr=1556429, offset=216, nblocks=3, ndatablk=2, fblocknr=1556435
get_latest_cno: finfo: ino=4499, sum-blocknr=1556429, offset=280, nblocks=1306282328, ndatablk=0, fblocknr=1556438
fsck0.nilfs2: cannot read block (blocknr = 2696911): Success

The out file contents:
[Thread debugging using libthread_db enabled]
0x008c1402 in __kernel_vsyscall ()
#0  0x008c1402 in __kernel_vsyscall ()
No symbol table info available.
#1  0x00267713 in __waitpid_nocancel () from /lib/libc.so.6
No symbol table info available.
#2  0x0020c07b in do_system () from /lib/libc.so.6
No symbol table info available.
#3  0x08049154 in nilfs_backtrace () at fsck0.nilfs2.c:176
        cmd = "backtrace 17363 > /var/log/bt_fsck0.nilfs2.17363.out 2>&1\000)\000\000\000\000\000\032\200*\000\003\000\000\000\002", '\000' <repeats 12 time
s>"\360, l\222\002\000\000\000\364\257\062\000\000\000\000"
        progname = "/sbin\000fsck0.nilfs2\000\277p\305\062\000\001\000\000\000p\301\062\000@\301\062\000@\301\062\000X\000\000\000@\301\062\000\001", '\000'
 <repeats 19 times>, "`\000\000\000p\301\062\000\004\000\000\000\346\356#\000\000\000\000\000\230\301\062\000p\000\000\000\377\017\000"
        n = <value optimized out>
#4  0x08049251 in read_block (fd=3, blocknr=2696911, buf=0x950b8b0, size=4096)
    at fsck0.nilfs2.c:204
No locals.
#5  0x080492d9 in next_ss_entry (fd=3, blocknrp=0xbf881d18,
    offsetp=0xbf881d24, entry_size=8) at fsck0.nilfs2.c:570
        p = <value optimized out>
#6  0x080499fc in get_latest_cno (fd=3, seginfo=0x952d8f8, start=0x952e410)
    at fsck0.nilfs2.c:650
        __func__ = "get_latest_cno"
#7  find_latest_cno_in_logical_segment (fd=3, seginfo=0x952d8f8,
    start=0x952e410) at fsck0.nilfs2.c:674
        loginfo = 0x952e410
        cno = 3249616
        latest_cno = 0
        seq = <value optimized out>
        i = 0
#8  0x0804abac in nilfs_fsck (argc=2146089, argv=0xbf881bdc)
    at fsck0.nilfs2.c:1072
No locals.
#9  main (argc=2146089, argv=0xbf881bdc) at fsck0.nilfs2.c:1197
No locals.

Thread 1 (Thread 0xb7f88a80 (LWP 17363)):
#0  0x008c1402 in __kernel_vsyscall ()
No symbol table info available.
#1  0x00267713 in __waitpid_nocancel () from /lib/libc.so.6
No symbol table info available.
#2  0x0020c07b in do_system () from /lib/libc.so.6
No symbol table info available.
#3  0x08049154 in nilfs_backtrace () at fsck0.nilfs2.c:176
        cmd = "backtrace 17363 > /var/log/bt_fsck0.nilfs2.17363.out 2>&1\000)\000\000\000\000\000\032\200*\000\003\000\000\000\002", '\000' <repeats 12 time
s>"\360, l\222\002\000\000\000\364\257\062\000\000\000\000"
        progname = "/sbin\000fsck0.nilfs2\000\277p\305\062\000\001\000\000\000p\301\062\000@\301\062\000@\301\062\000X\000\000\000@\301\062\000\001", '\000'
 <repeats 19 times>, "`\000\000\000p\301\062\000\004\000\000\000\346\356#\000\000\000\000\000\230\301\062\000p\000\000\000\377\017\000"
        n = <value optimized out>
#4  0x08049251 in read_block (fd=3, blocknr=2696911, buf=0x950b8b0, size=4096)
    at fsck0.nilfs2.c:204
No locals.
#5  0x080492d9 in next_ss_entry (fd=3, blocknrp=0xbf881d18,
    offsetp=0xbf881d24, entry_size=8) at fsck0.nilfs2.c:570
        p = <value optimized out>
#6  0x080499fc in get_latest_cno (fd=3, seginfo=0x952d8f8, start=0x952e410)
    at fsck0.nilfs2.c:650
        __func__ = "get_latest_cno"
#7  find_latest_cno_in_logical_segment (fd=3, seginfo=0x952d8f8,
    start=0x952e410) at fsck0.nilfs2.c:674
        loginfo = 0x952e410
        cno = 3249616
        latest_cno = 0
        seq = <value optimized out>
        i = 0
#8  0x0804abac in nilfs_fsck (argc=2146089, argv=0xbf881bdc)
    at fsck0.nilfs2.c:1072
No locals.
#9  main (argc=2146089, argv=0xbf881bdc) at fsck0.nilfs2.c:1197

Zahid

-----Original Message-----
From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org] 
Sent: Friday, June 17, 2011 9:53 PM
To: Zahid Chowdhury
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: mount & fsck of nilfs partition fail.

On Fri, 17 Jun 2011 14:55:04 -0700, Zahid Chowdhury wrote:
> Hello Ryusuke,
>  I have attached the output below (let me know if you need anything further - thanks for your help):
> [Thread debugging using libthread_db enabled]
> 0x0090a402 in __kernel_vsyscall ()
> #0  0x0090a402 in __kernel_vsyscall ()
> No symbol table info available.
> #1  0x00267713 in __waitpid_nocancel () from /lib/libc.so.6
> No symbol table info available.
> #2  0x0020c07b in do_system () from /lib/libc.so.6
> No symbol table info available.
> #3  0x08049154 in nilfs_backtrace () at fsck0.nilfs2.c:176
>         cmd = "backtrace 10688 > /var/log/bt_fsck0.nilfs2.10688.out 2>&1\000\000\000\243\213)\000\032\200*\000\024\215#\000\002", '\000' <repeats 12 times>"\360, l\222\002\000\000\000\364\257\062\000\000\000\000"
>         progname = "/sbin\000fsck0.nilfs2", '\000' <repeats 18 times>, "`\000\000\000p\301\062\000\004\000\000\000\346\356#\000\000\000\000\000\230\301\062\000p\000\000\000\377\017\000\000@\000\000\000\300\277\337\bp\301\062\0
> 00\000 \004\000\032\200*\000\000\020\002\000\001\000\000\000\000\000\000"
>         n = <value optimized out>
> #4  0x08049251 in read_block (fd=3, blocknr=2696911, buf=0x8ddb8b0, size=4096)
>     at fsck0.nilfs2.c:204
> No locals.
> #5  0x080492d9 in next_ss_entry (fd=3, blocknrp=0xbfc458b8,
>     offsetp=0xbfc458c4, entry_size=8) at fsck0.nilfs2.c:570
>         p = <value optimized out>
> #6  0x0804994c in get_latest_cno (fd=3, seginfo=0x8dfd8f8, start=0x8dfe410)
>     at fsck0.nilfs2.c:636
> No locals.
> #7  find_latest_cno_in_logical_segment (fd=3, seginfo=0x8dfd8f8,
>     start=0x8dfe410) at fsck0.nilfs2.c:660
>         loginfo = 0x8dfe410
>         cno = 3249616
>         latest_cno = 0
>         seq = <value optimized out>
>         i = 0
> #8  0x0804aafc in nilfs_fsck (argc=2146089, argv=0xbfc4579c)
>     at fsck0.nilfs2.c:1058
> No locals.
> #9  main (argc=2146089, argv=0xbfc4579c) at fsck0.nilfs2.c:1183
> No locals.

Ok, get_latest_cno function seems to have something wrong.

Could you please get some debug information with the following patch ?


Ryusuke Konishi
---
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

fsck0.nilfs2: insert debug messages in get_latest_cno function

---
 sbin/fsck/fsck0.nilfs2.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/sbin/fsck/fsck0.nilfs2.c b/sbin/fsck/fsck0.nilfs2.c
index 6a41766..7b70911 100644
--- a/sbin/fsck/fsck0.nilfs2.c
+++ b/sbin/fsck/fsck0.nilfs2.c
@@ -592,6 +592,11 @@ static __u64 get_latest_cno(int fd, __u64 log_start)
 	offset = le16_to_cpu(ss->ss_bytes);
 	fblocknr = blocknr + DIV_ROUND_UP(le32_to_cpu(ss->ss_sumbytes),
 					  blocksize);
+	fprintf(stderr, "%s: log_start=%llu (segnum=%lu): nfinfo=%lu, "
+		"fblocknr=%llu\n", __func__,
+		(unsigned long long)log_start,
+		(unsigned long)log_start / blocks_per_segment,
+		(unsigned long)nfinfo, (unsigned long long)fblocknr);
 
 	for (i = 0; i < nfinfo; i++) {
 		finfo = next_ss_entry(fd, &blocknr, &offset, sizeof(*finfo));
@@ -601,6 +606,14 @@ static __u64 get_latest_cno(int fd, __u64 log_start)
 		nnodeblk = nblocks - ndatablk;
 		ino = le64_to_cpu(finfo->fi_ino);
 
+		fprintf(stderr, "%s: finfo: ino=%llu, sum-blocknr=%llu, "
+			"offset=%u, nblocks=%lu, ndatablk=%lu, "
+			"fblocknr=%llu\n", __func__,
+			(unsigned long long)ino,
+			(unsigned long long)blocknr, offset,
+			(unsigned long)nblocks, (unsigned long)ndatablk,
+			(unsigned long long)fblocknr);
+
 		if (ino == NILFS_DAT_INO) {
 			__le64 *blkoff;
 			struct nilfs_binfo_dat *binfo_dat;
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
