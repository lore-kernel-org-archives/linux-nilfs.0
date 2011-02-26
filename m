From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs-utils: add block count option to lscp command
Date: Sun, 27 Feb 2011 01:48:16 +0900
Message-ID: <1298738897-13480-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds "-b" (or "--show-block-count") option and collaterally "-g"
(or "--show-increment") option to the lscp command to allow switching
amount of used blocks and that of appended blocks.

Note that the value of the block count field is not yet valid.  It
needs a change of the kernel code that adds block count support.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lscp.c |   28 +++++++++++++++++++++-------
 man/lscp.1 |   12 ++++++++++++
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/bin/lscp.c b/bin/lscp.c
index 642ed69..df9a0af 100644
--- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -54,6 +54,8 @@
 #ifdef _GNU_SOURCE
 #include <getopt.h>
 const static struct option long_option[] = {
+	{"show-block-count", no_argument, NULL, 'b'},
+	{"show-increment", no_argument, NULL, 'g'},
 	{"reverse", no_argument, NULL, 'r'},
 	{"snapshot", no_argument, NULL, 's'},
 	{"index", required_argument, NULL, 'i'},
@@ -63,6 +65,8 @@ const static struct option long_option[] = {
 	{NULL, 0, NULL, 0}
 };
 #define LSCP_USAGE	"Usage: %s [OPTION]... [DEVICE]\n"		\
+			"  -b, --show-block-count\t\tshow block count\n"\
+			"  -g, --show-increment\t\tshow increment count\n"\
 			"  -r, --reverse\t\treverse order\n"		\
 			"  -s, --snapshot\tlist only snapshots\n"	\
 			"  -i, --index\t\tcp/ss index\n"		\
@@ -70,7 +74,7 @@ const static struct option long_option[] = {
 			"  -h, --help\t\tdisplay this help and exit\n"	\
 			"  -V, --version\t\tdisplay version and exit\n"
 #else
-#define LSCP_USAGE	"Usage: %s [-rshV] [-i cno] [-n lines] [device]\n"
+#define LSCP_USAGE	"Usage: %s [-bgrshV] [-i cno] [-n lines] [device]\n"
 #endif	/* _GNU_SOURCE */
 
 #define LSCP_BUFSIZE	128
@@ -81,11 +85,13 @@ const static struct option long_option[] = {
 static __u64 param_index;
 static __u64 param_lines;
 static struct nilfs_cpinfo cpinfos[LSCP_NCPINFO];
+static int show_block_count = 0;
 
 static void lscp_print_header(void)
 {
-	printf("                 CNO        DATE     TIME  MODE  FLG   NBLKINC"
-	       "       ICNT\n");
+	printf("                 CNO        DATE     TIME  MODE  FLG     %s"
+	       "       ICNT\n",
+	       show_block_count ? " BLKCNT" : "NBLKINC");
 }
 
 static void lscp_print_cpinfo(struct nilfs_cpinfo *cpinfo)
@@ -98,11 +104,13 @@ static void lscp_print_cpinfo(struct nilfs_cpinfo *cpinfo)
 	localtime_r(&t, &tm);
 	strftime(timebuf, LSCP_BUFSIZE, "%F %T", &tm);
 
-	printf("%20llu  %s   %s    %s %10llu %10llu\n",
+	printf("%20llu  %s   %s    %s %12llu %10llu\n",
 	       (unsigned long long)cpinfo->ci_cno, timebuf,
 	       nilfs_cpinfo_snapshot(cpinfo) ? "ss" : "cp",
 	       nilfs_cpinfo_minor(cpinfo) ? "i" : "-",
-	       (unsigned long long)cpinfo->ci_nblk_inc,
+	       (unsigned long long)(show_block_count ?
+				    cpinfo->ci_blocks_count :
+				    cpinfo->ci_nblk_inc),
 	       (unsigned long long)cpinfo->ci_inodes_count);
 }
 
@@ -333,13 +341,19 @@ int main(int argc, char *argv[])
 
 
 #ifdef _GNU_SOURCE
-	while ((c = getopt_long(argc, argv, "rsi:n:hV",
+	while ((c = getopt_long(argc, argv, "bgrsi:n:hV",
 				long_option, &option_index)) >= 0) {
 #else
-	while ((c = getopt(argc, argv, "rsi:n:hV")) >= 0) {
+	while ((c = getopt(argc, argv, "bgrsi:n:hV")) >= 0) {
 #endif	/* _GNU_SOURCE */
 
 		switch (c) {
+		case 'b':
+			show_block_count = 1;
+			break;
+		case 'g':
+			show_block_count = 0;
+			break;
 		case 'r':
 			rvs = 1;
 			break;
diff --git a/man/lscp.1 b/man/lscp.1
index b7b6caa..b5a553b 100644
--- a/man/lscp.1
+++ b/man/lscp.1
@@ -17,6 +17,13 @@ This command will fail if the \fIdevice\fP has no active mounts of a
 NILFS2 file system.
 .SH OPTIONS
 .TP
+\fB\-b\fR, \fB\-\-show\-block\-count\fR
+Show number of used blocks instead of appended blocks.
+.TP
+\fB\-g\fR, \fB\-\-show\-increment\fR
+Show number of appended blocks instead of used blocks.  This is the
+default mode.
+.TP
 \fB\-r\fR, \fB\-\-reverse\fR
 Reverse order.
 .TP
@@ -60,6 +67,11 @@ checkpoint mode change, or other change of internal state.  Otherwise
 .B NBLKINC
 Number of blocks appended by the checkpoint.
 .TP
+.B BLKCNT
+Number of blocks used by the checkpoint.  The \fBNBLKINC\fR field
+and the \fBBLKCNT\fR field is selective.  This field is displayed
+only if the \fB\-b\fR option is specified.
+.TP
 .B ICNT
 Number of inodes included in the entire file system at the time
 specified by the checkpoint.
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
