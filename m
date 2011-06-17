From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: RE: mount & fsck of nilfs partition fail.
Date: Fri, 17 Jun 2011 14:55:04 -0700
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181B05E99A12@COLOSSEXCH01.starsolutions.com>
References: <20110615.195858.252298449.ryusuke@osrg.net>
	<20110616.033201.162617955.ryusuke@osrg.net>
	<053D39D3D76C474EB2D2A284AA6BA3181B05E99563@COLOSSEXCH01.starsolutions.com>
 <20110618.032928.182500686.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110618.032928.182500686.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Ryusuke,
 I have attached the output below (let me know if you need anything further - thanks for your help):
[Thread debugging using libthread_db enabled]
0x0090a402 in __kernel_vsyscall ()
#0  0x0090a402 in __kernel_vsyscall ()
No symbol table info available.
#1  0x00267713 in __waitpid_nocancel () from /lib/libc.so.6
No symbol table info available.
#2  0x0020c07b in do_system () from /lib/libc.so.6
No symbol table info available.
#3  0x08049154 in nilfs_backtrace () at fsck0.nilfs2.c:176
        cmd = "backtrace 10688 > /var/log/bt_fsck0.nilfs2.10688.out 2>&1\000\000\000\243\213)\000\032\200*\000\024\215#\000\002", '\000' <repeats 12 times>"\360, l\222\002\000\000\000\364\257\062\000\000\000\000"
        progname = "/sbin\000fsck0.nilfs2", '\000' <repeats 18 times>, "`\000\000\000p\301\062\000\004\000\000\000\346\356#\000\000\000\000\000\230\301\062\000p\000\000\000\377\017\000\000@\000\000\000\300\277\337\bp\301\062\0
00\000 \004\000\032\200*\000\000\020\002\000\001\000\000\000\000\000\000"
        n = <value optimized out>
#4  0x08049251 in read_block (fd=3, blocknr=2696911, buf=0x8ddb8b0, size=4096)
    at fsck0.nilfs2.c:204
No locals.
#5  0x080492d9 in next_ss_entry (fd=3, blocknrp=0xbfc458b8,
    offsetp=0xbfc458c4, entry_size=8) at fsck0.nilfs2.c:570
        p = <value optimized out>
#6  0x0804994c in get_latest_cno (fd=3, seginfo=0x8dfd8f8, start=0x8dfe410)
    at fsck0.nilfs2.c:636
No locals.
#7  find_latest_cno_in_logical_segment (fd=3, seginfo=0x8dfd8f8,
    start=0x8dfe410) at fsck0.nilfs2.c:660
        loginfo = 0x8dfe410
        cno = 3249616
        latest_cno = 0
        seq = <value optimized out>
        i = 0
#8  0x0804aafc in nilfs_fsck (argc=2146089, argv=0xbfc4579c)
    at fsck0.nilfs2.c:1058
No locals.
#9  main (argc=2146089, argv=0xbfc4579c) at fsck0.nilfs2.c:1183
No locals.

Thread 1 (Thread 0xb7fdfa80 (LWP 10688)):
#0  0x0090a402 in __kernel_vsyscall ()
No symbol table info available.
#1  0x00267713 in __waitpid_nocancel () from /lib/libc.so.6
No symbol table info available.
#2  0x0020c07b in do_system () from /lib/libc.so.6
No symbol table info available.
#3  0x08049154 in nilfs_backtrace () at fsck0.nilfs2.c:176
        cmd = "backtrace 10688 > /var/log/bt_fsck0.nilfs2.10688.out 2>&1\000\000\000\243\213)\000\032\200*\000\024\215#\000\002", '\000' <repeats 12 times>"\360, l\222\002\000\000\000\364\257\062\000\000\000\000"
        progname = "/sbin\000fsck0.nilfs2", '\000' <repeats 18 times>, "`\000\000\000p\301\062\000\004\000\000\000\346\356#\000\000\000\000\000\230\301\062\000p\000\000\000\377\017\000\000@\000\000\000\300\277\337\bp\301\062\0
00\000 \004\000\032\200*\000\000\020\002\000\001\000\000\000\000\000\000"
        n = <value optimized out>
#4  0x08049251 in read_block (fd=3, blocknr=2696911, buf=0x8ddb8b0, size=4096)
    at fsck0.nilfs2.c:204
No locals.
#5  0x080492d9 in next_ss_entry (fd=3, blocknrp=0xbfc458b8,
    offsetp=0xbfc458c4, entry_size=8) at fsck0.nilfs2.c:570
        p = <value optimized out>
#6  0x0804994c in get_latest_cno (fd=3, seginfo=0x8dfd8f8, start=0x8dfe410)
    at fsck0.nilfs2.c:636
No locals.
#7  find_latest_cno_in_logical_segment (fd=3, seginfo=0x8dfd8f8,
    start=0x8dfe410) at fsck0.nilfs2.c:660
        loginfo = 0x8dfe410
        cno = 3249616
        latest_cno = 0
        seq = <value optimized out>
        i = 0
#8  0x0804aafc in nilfs_fsck (argc=2146089, argv=0xbfc4579c)
    at fsck0.nilfs2.c:1058
No locals.
#9  main (argc=2146089, argv=0xbfc4579c) at fsck0.nilfs2.c:1183
No locals.

Thread 1 (Thread 0xb7fdfa80 (LWP 10688)):
#0  0x0090a402 in __kernel_vsyscall ()
No symbol table info available.
#1  0x00267713 in __waitpid_nocancel () from /lib/libc.so.6
No symbol table info available.
#2  0x0020c07b in do_system () from /lib/libc.so.6
No symbol table info available.
#3  0x08049154 in nilfs_backtrace () at fsck0.nilfs2.c:176
        cmd = "backtrace 10688 > /var/log/bt_fsck0.nilfs2.10688.out 2>&1\000\000\000\243\213)\000\032\200*\000\024\215#\000\002", '\000' <repeats 12 times>"\360, l\222\002\000\000\000\364\257\062\000\000\000\000"
        progname = "/sbin\000fsck0.nilfs2", '\000' <repeats 18 times>, "`\000\000\000p\301\062\000\004\000\000\000\346\356#\000\000\000\000\000\230\301\062\000p\000\000\000\377\017\000\000@\000\000\000\300\277\337\bp\301\062\0
00\000 \004\000\032\200*\000\000\020\002\000\001\000\000\000\000\000\000"
        n = <value optimized out>
#4  0x08049251 in read_block (fd=3, blocknr=2696911, buf=0x8ddb8b0, size=4096)
    at fsck0.nilfs2.c:204
No locals.
#5  0x080492d9 in next_ss_entry (fd=3, blocknrp=0xbfc458b8,
    offsetp=0xbfc458c4, entry_size=8) at fsck0.nilfs2.c:570
        p = <value optimized out>
#6  0x0804994c in get_latest_cno (fd=3, seginfo=0x8dfd8f8, start=0x8dfe410)
    at fsck0.nilfs2.c:636
No locals.
#7  find_latest_cno_in_logical_segment (fd=3, seginfo=0x8dfd8f8,
    start=0x8dfe410) at fsck0.nilfs2.c:660
        loginfo = 0x8dfe410
        cno = 3249616
        latest_cno = 0
        seq = <value optimized out>
        i = 0
#8  0x0804aafc in nilfs_fsck (argc=2146089, argv=0xbfc4579c)
    at fsck0.nilfs2.c:1058
No locals.
#9  main (argc=2146089, argv=0xbfc4579c) at fsck0.nilfs2.c:1183
No locals.
A debugging session is active.

        Inferior 1 [process 10688] will be detached.

Quit anyway? (y or n) [answered Y; input not from terminal]

Zahid

-----Original Message-----
From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org] 
Sent: Friday, June 17, 2011 11:29 AM
To: Zahid Chowdhury
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: mount & fsck of nilfs partition fail.

On Wed, 15 Jun 2011 11:38:16 -0700, Zahid Chowdhury wrote:
> Hello Ryusuke,
>   Yes, "the data on the partition is important". Please let me know how to
> "get a backtrace of the error" and I will send it to you. Thanks a lot.
> 
> Zahid

Try the following patch.

You will need to install gdb and backtrace script available at:

  http://samba.org/ftp/unpacked/junkcode/segv_handler/backtrace

The modified fsck0.nilfs2 will write a backtrace into
"/var/log/bt_fsck0.nilfs2.<pid>.out".


Regards,
Ryusuke Konishi
---
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

fsck0.nilfs2: add backtrace routine

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/fsck/Makefile.am    |    2 +-
 sbin/fsck/fsck0.nilfs2.c |   30 +++++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/sbin/fsck/Makefile.am b/sbin/fsck/Makefile.am
index 789ae1b..5357967 100644
--- a/sbin/fsck/Makefile.am
+++ b/sbin/fsck/Makefile.am
@@ -1,6 +1,6 @@
 ## Makefile.am
 
-AM_CFLAGS = -Wall
+AM_CFLAGS = -Wall -g
 AM_CPPFLAGS = -I$(top_srcdir)/include
 LDADD = -luuid $(top_builddir)/lib/libnilfsfeature.la \
 	$(top_builddir)/lib/libmountchk.la \
diff --git a/sbin/fsck/fsck0.nilfs2.c b/sbin/fsck/fsck0.nilfs2.c
index 35a010c..6a41766 100644
--- a/sbin/fsck/fsck0.nilfs2.c
+++ b/sbin/fsck/fsck0.nilfs2.c
@@ -151,6 +151,32 @@ static inline void *nilfs_zalloc(size_t size)
 }
 
 /*
+ * The following part is based on segv_handler by Andrew Tridgell
+ * found at http://samba.org/ftp/unpacked/junkcode/segv_handler/
+ *
+ * To enable this feature, install gdb and 'backtrace' script available
+ * on the above site.
+ */
+static void nilfs_backtrace(void)
+{
+	char cmd[100];
+	char progname[100];
+	char *p;
+	int n;
+
+	n = readlink("/proc/self/exe", progname, sizeof(progname));
+	progname[n] = 0;
+
+	p = strrchr(progname, '/');
+	*p = 0;
+
+	snprintf(cmd, sizeof(cmd),
+		 "backtrace %d > /var/log/bt_%s.%d.out 2>&1",
+		 (int)getpid(), p+1, (int)getpid());
+	system(cmd);
+}
+
+/*
  * Block buffer
  */
 static void *block_buffer = NULL;
@@ -173,9 +199,11 @@ static void read_block(int fd, __u64 blocknr, void *buf,
 		       unsigned long size)
 {
 	if (lseek64(fd, blocknr * blocksize, SEEK_SET) < 0 ||
-	    read(fd, buf, size) < size)
+	    read(fd, buf, size) < size) {
+		nilfs_backtrace();
 		die("cannot read block (blocknr = %llu): %s",
 		    (unsigned long long)blocknr, strerror(errno));
+	}
 }
 
 static inline __u64 segment_start_blocknr(unsigned long segnum)
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
