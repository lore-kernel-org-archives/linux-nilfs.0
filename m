From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: mount & fsck of nilfs partition fail.
Date: Sat, 18 Jun 2011 03:29:28 +0900 (JST)
Message-ID: <20110618.032928.182500686.ryusuke@osrg.net>
References: <20110615.195858.252298449.ryusuke@osrg.net>
	<20110616.033201.162617955.ryusuke@osrg.net>
	<053D39D3D76C474EB2D2A284AA6BA3181B05E99563@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA3181B05E99563-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
