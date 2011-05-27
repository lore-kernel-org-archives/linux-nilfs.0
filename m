From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] lscp: hide internal checkpoints and add all option to show them
Date: Fri, 27 May 2011 13:00:28 +0900
Message-ID: <1306468828-24741-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This patch slightly changes behaviour of the lscp command.

The current lscp command displays all checkpoints including minor
checkpoints created as the result of garbage collection or snapshot
operations.  (Each minor checkpoint is accompanied by an "i" flag).

This patch adds "all" option to lscp, and changes its behaviour so as
to hide minor checkpoints by default and makes them visible only when
the all option is specified.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lscp.c |   34 ++++++++++++++++++++++------------
 man/lscp.1 |    3 +++
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/bin/lscp.c b/bin/lscp.c
index df9a0af..0721bd0 100644
--- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -54,6 +54,7 @@
 #ifdef _GNU_SOURCE
 #include <getopt.h>
 const static struct option long_option[] = {
+	{"all", no_argument, NULL, 'a'},
 	{"show-block-count", no_argument, NULL, 'b'},
 	{"show-increment", no_argument, NULL, 'g'},
 	{"reverse", no_argument, NULL, 'r'},
@@ -65,6 +66,7 @@ const static struct option long_option[] = {
 	{NULL, 0, NULL, 0}
 };
 #define LSCP_USAGE	"Usage: %s [OPTION]... [DEVICE]\n"		\
+			"  -a, --all\t\tshow all checkpoints\n"		\
 			"  -b, --show-block-count\t\tshow block count\n"\
 			"  -g, --show-increment\t\tshow increment count\n"\
 			"  -r, --reverse\t\treverse order\n"		\
@@ -86,6 +88,7 @@ static __u64 param_index;
 static __u64 param_lines;
 static struct nilfs_cpinfo cpinfos[LSCP_NCPINFO];
 static int show_block_count = 0;
+static int show_all = 0;
 
 static void lscp_print_header(void)
 {
@@ -139,10 +142,10 @@ static ssize_t lscp_get_cpinfo(struct nilfs *nilfs, nilfs_cno_t cno, int mode,
 static int lscp_forward_cpinfo(struct nilfs *nilfs,
 			       struct nilfs_cpstat *cpstat)
 {
+	struct nilfs_cpinfo *cpi;
 	nilfs_cno_t sidx;
 	__u64 rest;
 	ssize_t n;
-	int i;
 
 	rest = param_lines && param_lines < cpstat->cs_ncps ? param_lines :
 		cpstat->cs_ncps;
@@ -155,9 +158,12 @@ static int lscp_forward_cpinfo(struct nilfs *nilfs,
 		if (!n)
 			break;
 
-		for (i = 0; i < n; i++, rest--)
-			lscp_print_cpinfo(&cpinfos[i]);
-
+		for (cpi = cpinfos; cpi < cpinfos + n; cpi++) {
+			if (show_all || !nilfs_cpinfo_minor(cpi)) {
+				lscp_print_cpinfo(cpi);
+				rest--;
+			}
+		}
 		sidx = cpinfos[n - 1].ci_cno + 1;
 	}
 	return 0;
@@ -166,11 +172,11 @@ static int lscp_forward_cpinfo(struct nilfs *nilfs,
 static int lscp_backward_cpinfo(struct nilfs *nilfs,
 				struct nilfs_cpstat *cpstat)
 {
+	struct nilfs_cpinfo *cpi;
 	nilfs_cno_t sidx; /* start index (inclusive) */
 	nilfs_cno_t eidx; /* end index (exclusive) */
 	__u64 rest, delta;
 	ssize_t n;
-	int i;
 
 	rest = param_lines && param_lines < cpstat->cs_ncps ? param_lines :
 		cpstat->cs_ncps;
@@ -189,11 +195,12 @@ static int lscp_backward_cpinfo(struct nilfs *nilfs,
 		if (!n)
 			break;
 
-		for (i = 0 ; i < n && rest > 0; i++) {
-			if (cpinfos[n - i - 1].ci_cno >= eidx)
-				continue;
-			lscp_print_cpinfo(&cpinfos[n - i - 1]);
-			rest--;
+		for (cpi = cpinfos + n - 1; cpi >= cpinfos && rest > 0; cpi--) {
+			if (cpi->ci_cno < eidx &&
+			    (show_all || !nilfs_cpinfo_minor(cpi))) {
+				lscp_print_cpinfo(cpi);
+				rest--;
+			}
 		}
 	}
 	return 0;
@@ -341,13 +348,16 @@ int main(int argc, char *argv[])
 
 
 #ifdef _GNU_SOURCE
-	while ((c = getopt_long(argc, argv, "bgrsi:n:hV",
+	while ((c = getopt_long(argc, argv, "abgrsi:n:hV",
 				long_option, &option_index)) >= 0) {
 #else
-	while ((c = getopt(argc, argv, "bgrsi:n:hV")) >= 0) {
+	while ((c = getopt(argc, argv, "abgrsi:n:hV")) >= 0) {
 #endif	/* _GNU_SOURCE */
 
 		switch (c) {
+		case 'a':
+			show_all = 1;
+			break;
 		case 'b':
 			show_block_count = 1;
 			break;
diff --git a/man/lscp.1 b/man/lscp.1
index b5a553b..a100ac0 100644
--- a/man/lscp.1
+++ b/man/lscp.1
@@ -17,6 +17,9 @@ This command will fail if the \fIdevice\fP has no active mounts of a
 NILFS2 file system.
 .SH OPTIONS
 .TP
+\fB\-a\fR, \fB\-\-all\fR
+Do not hide minor checkpoints.
+.TP
 \fB\-b\fR, \fB\-\-show\-block\-count\fR
 Show number of used blocks instead of appended blocks.
 .TP
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
