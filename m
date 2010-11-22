From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/3] nilfs-utils: add verbose option to mkfs.nilfs2
Date: Mon, 22 Nov 2010 19:24:02 +0900
Message-ID: <1290421443-27679-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1290421443-27679-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290421443-27679-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Allows mkfs.nilfs2 to print out detail messages with "-v" option.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 man/mkfs.nilfs2.8 |    9 +++++++++
 sbin/mkfs/mkfs.c  |   14 +++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/man/mkfs.nilfs2.8 b/man/mkfs.nilfs2.8
index 76c278f..fb70c87 100644
--- a/man/mkfs.nilfs2.8
+++ b/man/mkfs.nilfs2.8
@@ -32,6 +32,9 @@ mkfs.nilfs2 \- create a NILFS2 filesystem
 .B \-q
 ]
 [
+.B \-v
+]
+[
 .B \-V
 ]
 .I device
@@ -63,6 +66,9 @@ mkfs.nilfs2 \- create a NILFS2 filesystem
 .B \-q
 ]
 [
+.B \-v
+]
+[
 .B \-V
 ]
 .I device
@@ -114,6 +120,9 @@ Quiet execution.  Useful if
 .B mkfs.nilfs2
 is run in a script.
 .TP
+.B \-v
+Verbose execution.
+.TP
 .B \-V
 Print the version number of
 .B mkfs.nilfs2
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index 03d7415..95f4408 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -108,6 +108,7 @@ char *progname = "mkfs.nilfs2";
 static int quiet = 0;
 static int cflag = 0;
 static int nflag = 0;
+static int verbose = 0;
 static unsigned long blocksize = NILFS_DEF_BLOCKSIZE;
 static unsigned long blocks_per_segment = NILFS_DEF_BLKS_PER_SEG;
 static unsigned long r_segments_percentage = NILFS_DEF_RESERVED_SEGMENTS;
@@ -876,7 +877,7 @@ static void parse_options(int argc, char *argv[])
 {
 	int c, show_version_only = 0;
 
-	while ((c = getopt(argc, argv, "b:B:cL:m:nqVP:")) != EOF) {
+	while ((c = getopt(argc, argv, "b:B:cL:m:nqvVP:")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = atol(optarg);
@@ -900,6 +901,9 @@ static void parse_options(int argc, char *argv[])
 		case 'q':
 			quiet = 1;
 			break;
+		case 'v':
+			verbose++;
+			break;
 		case 'V':
 			show_version_only = 1;
 			break;
@@ -911,6 +915,10 @@ static void parse_options(int argc, char *argv[])
 			usage();
 		}
 	}
+
+	if (quiet)
+		verbose = 0;
+
 	if ((optind == argc) && !show_version_only)
 		usage();
 
@@ -936,8 +944,8 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: %s [-b block-size] [-B blocks-per-segment] [-c] \n"
-		"[-L volume-label] [-m reserved-segments-percentage] [-n] \n"
-		"[-q] [-V] device\n",
+		"[-L volume-label] [-m reserved-segments-percentage] \n"
+		"[-nqvV] device\n",
 		progname);
 	exit(1);
 }
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
