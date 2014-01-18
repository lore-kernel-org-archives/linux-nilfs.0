From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] lscp: show block count by default
Date: Sat, 18 Jan 2014 22:57:12 +0900
Message-ID: <1390053433-13598-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1390053433-13598-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390053433-13598-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

For each checkpoint of NILFS2, total block count (BLKCNT) is more
meaningful information than appended block count (NBLKINC).  This
changes the default display information of lscp command on block count
to BLKCNT from NBLKINC, and updates relevant man pages.  NBLKINC can
be still displayed when we specified '-g' option.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lscp.c  |    2 +-
 man/lscp.1  |   20 +++++++++++---------
 man/nilfs.8 |   24 ++++++++++++------------
 3 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/bin/lscp.c b/bin/lscp.c
index ec9f97c..f16f870 100644
--- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -87,7 +87,7 @@ const static struct option long_option[] = {
 static __u64 param_index;
 static __u64 param_lines;
 static struct nilfs_cpinfo cpinfos[LSCP_NCPINFO];
-static int show_block_count = 0;
+static int show_block_count = 1;
 static int show_all = 0;
 
 static void lscp_print_header(void)
diff --git a/man/lscp.1 b/man/lscp.1
index e71a878..bb44cfa 100644
--- a/man/lscp.1
+++ b/man/lscp.1
@@ -1,7 +1,7 @@
 .\"  Copyright (C) 2007-2012 Nippon Telegraph and Telephone Corporation.
 .\"  Written by Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
 .\"
-.TH LSCP 1 "May 2011" "nilfs-utils version 2.1"
+.TH LSCP 1 "Jan 2014" "nilfs-utils version 2.1"
 .SH NAME
 lscp \- list NILFS2 checkpoints
 .SH SYNOPSIS
@@ -21,11 +21,11 @@ NILFS2 file system.
 Do not hide minor checkpoints.
 .TP
 \fB\-b\fR, \fB\-\-show\-block\-count\fR
-Show number of used blocks instead of appended blocks.
+Show number of used blocks instead of appended blocks.  This is the
+default mode.
 .TP
 \fB\-g\fR, \fB\-\-show\-increment\fR
-Show number of appended blocks instead of used blocks.  This is the
-default mode.
+Show number of appended blocks instead of used blocks.
 .TP
 \fB\-r\fR, \fB\-\-reverse\fR
 Reverse order.
@@ -67,17 +67,19 @@ field if the checkpoint was created only by garbage collection,
 checkpoint mode change, or other change of internal state.  Otherwise
 ``-'' is printed.
 .TP
-.B NBLKINC
-Number of blocks appended by the checkpoint.
+.B NBLKINC (optional)
+Number of blocks appended by the checkpoint.  This field is displayed
+instead of BLKCNT field when \fB\-g\fR option is specified.
 .TP
 .B BLKCNT
-Number of blocks used by the checkpoint.  The \fBNBLKINC\fR field
-and the \fBBLKCNT\fR field is selective.  This field is displayed
-only if the \fB\-b\fR option is specified.
+Number of blocks used by the checkpoint.
 .TP
 .B ICNT
 Number of inodes included in the entire file system at the time
 specified by the checkpoint.
+.SH BUGS
+NILFS2 in Linux kernel version 2.6.38 and earlier does not support the
+block count (BLKCNT) information.
 .SH AUTHOR
 Koji Sato
 .SH AVAILABILITY
diff --git a/man/nilfs.8 b/man/nilfs.8
index a4747a4..cb4eddc 100644
--- a/man/nilfs.8
+++ b/man/nilfs.8
@@ -66,24 +66,24 @@ ordinary POSIX file system.  This will invoke a cleaner process
 .B lscp
 lists checkpoints created in the file system as follows:
 .PP
-        CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
-          1  2008-05-08 14:45:49   cp    -         11          2
-          2  2008-05-08 14:50:22   cp    -     200523         81
-          3  2008-05-08 20:40:34   cp    -        136         61
-          4  2008-05-08 20:41:20   cp    -     187666       1604
-          5  2008-05-08 20:41:42   cp    -         51       1634
+        CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
+          1  2014-01-18 20:49:54   cp    -            4          2
+          2  2014-01-18 20:51:45   cp    -         3990         11
+          3  2014-01-18 20:51:45   cp    -         6058          3
+          4  2014-01-18 20:51:49   cp    -         4807          6
+          5  2014-01-18 20:51:49   cp    -          262          3
         ...
 .TP
 .B chcp ss \fP2
 changes the checkpoint whose \fIcheckpoint-number\fP is two to a snapshot.
 Then the checkpoint list will become as follows:
 .PP
-        CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
-          1  2008-05-08 14:45:49   cp    -         11          2
-          2  2008-05-08 14:50:22   ss    -     200523         81
-          3  2008-05-08 20:40:34   cp    -        136         61
-          4  2008-05-08 20:41:20   cp    -     187666       1604
-          5  2008-05-08 20:41:42   cp    -         51       1634
+        CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
+          1  2014-01-18 20:49:54   cp    -            4          2
+          2  2014-01-18 20:51:45   ss    -         3990         11
+          3  2014-01-18 20:51:45   cp    -         6058          3
+          4  2014-01-18 20:51:49   cp    -         4807          6
+          5  2014-01-18 20:51:49   cp    -          262          3
         ...
 .TP
 .B mount \-t nilfs2 \-r \-o cp=2 \fP/dev/sdb1 /snapshot
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
