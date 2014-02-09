From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] lssu: add option to print count of live blocks
Date: Mon, 10 Feb 2014 03:48:34 +0900
Message-ID: <1391971714-1724-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1391971714-1724-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391971714-1724-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds new options "-l" and "-p" to lssu command.

"-l" option prints count and ratio of live blocks for in-use segments,
and "-p" option allows users to specify a protection period which is
used to judge whether blocks are live or not.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/Makefile.am |    2 +
 bin/lssu.c      |  251 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 man/lssu.1      |   14 +++-
 3 files changed, 235 insertions(+), 32 deletions(-)

diff --git a/bin/Makefile.am b/bin/Makefile.am
index 9d63d06..1a7de64 100644
--- a/bin/Makefile.am
+++ b/bin/Makefile.am
@@ -14,6 +14,8 @@ dumpseg_SOURCES = dumpseg.c
 lscp_SOURCES = lscp.c
 
 lssu_SOURCES = lssu.c
+lssu_LDADD = $(LDADD) $(top_builddir)/lib/libnilfsgc.la \
+	 $(top_builddir)/lib/libparser.la
 
 mkcp_SOURCES = mkcp.c
 mkcp_LDADD = $(LDADD) $(LIB_POSIX_SEM)
diff --git a/bin/lssu.c b/bin/lssu.c
index 443910e..a452d19 100644
--- a/bin/lssu.c
+++ b/bin/lssu.c
@@ -37,79 +37,195 @@
 #include <string.h>
 #endif	/* HAVE_STRING_H */
 
+#if HAVE_LIMITS_H
+#include <limits.h>
+#endif	/* HAVE_LIMITS_H */
+
+#if HAVE_SYS_TIME_H
+#include <sys/time.h>
+#endif	/* HAVE_SYS_TIME */
+
 #if HAVE_TIME_H
 #include <time.h>
 #endif	/* HAVE_TIME_H */
 
 #include <errno.h>
 #include "nilfs.h"
+#include "nilfs_gc.h"
+#include "cnoconv.h"
+#include "parser.h"
 
 #ifdef _GNU_SOURCE
 #include <getopt.h>
 const static struct option long_option[] = {
 	{"all",  no_argument, NULL, 'a'},
 	{"index", required_argument, NULL, 'i'},
+	{"latest-usage", no_argument, NULL, 'l' },
 	{"lines", required_argument, NULL, 'n'},
+	{"protection-period", required_argument, NULL, 'p'},
 	{"help", no_argument, NULL, 'h'},
 	{"version", no_argument, NULL, 'V'},
 	{NULL, 0, NULL, 0}
 };
 
-#define LSSU_USAGE	"Usage: %s [OPTION]... [DEVICE]\n"		\
-			"  -a, --all\t\tdo not hide clean segments\n"	\
-			"  -i, --index\t\tstart index\n"		\
-			"  -n, --lines\t\toutput lines\n"		\
-			"  -h, --help\t\tdisplay this help and exit\n"	\
-			"  -V, --version\t\tdisplay version and exit\n"
+#define LSSU_USAGE							\
+	"Usage: %s [OPTION]... [DEVICE]\n"				\
+	"  -a, --all\t\t\tdo not hide clean segments\n"			\
+	"  -h, --help\t\t\tdisplay this help and exit\n"		\
+	"  -i, --index\t\t\tskip index segments at start of inputs\n"	\
+	"  -l, --latest-usage\t\tprint usage status of the moment\n"	\
+	"  -n, --lines\t\t\tlist only lines input segments\n"		\
+	"  -p, --protection-period\tspecify protection period\n"	\
+	"  -V, --version\t\t\tdisplay version and exit\n"
 #else	/* !_GNU_SOURCE */
 #include <unistd.h>
-#define LSSU_USAGE	"Usage: %s [-ahV] [-i index] [-n lines] [device]\n"
+#define LSSU_USAGE \
+	"Usage: %s [-alhV] [-i index] [-n lines] [-p period] [device]\n"
 #endif	/* _GNU_SOURCE */
 
 #define LSSU_BUFSIZE	128
 #define LSSU_NSEGS	512
 
+enum lssu_mode {
+	LSSU_MODE_NORMAL,
+	LSSU_MODE_LATEST_USAGE,
+};
+
+struct lssu_format {
+	char *header;
+	char *body;
+};
+
+const static struct lssu_format lssu_format[] = {
+	{
+		"              SEGNUM        DATE     TIME STAT     NBLOCKS\n",
+		"%20llu  %s  %c%c%c  %10u\n"
+	},
+	{
+		"           SEGNUM        DATE     TIME STAT     NBLOCKS"
+		"       NLIVEBLOCKS\n",
+		"%17llu  %s  %c%c%c  %10u %10u (%3u%%)\n"
+	}
+};
+
+static char *progname;
+
+static int all;
+static int latest;
+static int disp_mode;		/* display mode */
+static nilfs_cno_t protcno;
 static __u64 param_index;
 static __u64 param_lines;
-static struct nilfs_suinfo suinfos[LSSU_NSEGS];
 
+static size_t blocks_per_segment;
+static struct nilfs_suinfo suinfos[LSSU_NSEGS];
 
 static void lssu_print_header(void)
 {
-	printf("              SEGNUM        DATE     TIME STAT     NBLOCKS\n");
+	printf(lssu_format[disp_mode].header);
+}
+
+static ssize_t lssu_get_latest_usage(struct nilfs *nilfs,
+				     __u64 segnum, __u64 protseq,
+				     nilfs_cno_t protcno)
+{
+	struct nilfs_reclaim_stat stat;
+	struct nilfs_reclaim_params params = {
+		.flags = NILFS_RECLAIM_PARAM_PROTSEQ,
+		.protseq = protseq
+	};
+	__u64 segnums[1];
+	int ret;
+
+	if (protcno == NILFS_CNO_MAX) {
+		params.flags |= NILFS_RECLAIM_PARAM_PROTCNO;
+		params.protcno = protcno;
+	}
+
+	memset(&stat, 0, sizeof(stat));
+	segnums[0] = segnum;
+
+	ret = nilfs_assess_segment(nilfs, segnums, 1, &params, &stat);
+	if (ret < 0)
+		return -1;
+
+	if (stat.protected_segs > 0)
+		return -2;
+
+	return stat.live_blks;
 }
 
-static ssize_t lssu_print_suinfo(__u64 segnum, ssize_t nsi, int all)
+static ssize_t lssu_print_suinfo(struct nilfs *nilfs, __u64 segnum,
+				 ssize_t nsi, __u64 protseq)
 {
 	struct tm tm;
 	time_t t;
 	char timebuf[LSSU_BUFSIZE];
-	ssize_t i, n = 0;
+	ssize_t i, n = 0, ret;
+	int ratio;
+	size_t nliveblks;
 
 	for (i = 0; i < nsi; i++, segnum++) {
-		if (all || !nilfs_suinfo_clean(&suinfos[i])) {
-			t = (time_t)suinfos[i].sui_lastmod;
-			if (t != 0) {
-				localtime_r(&t, &tm);
-				strftime(timebuf, LSSU_BUFSIZE, "%F %T", &tm);
-			} else
-				snprintf(timebuf, LSSU_BUFSIZE,
-					 "---------- --:--:--");
-
-			printf("%20llu  %s  %c%c%c  %10u\n",
+		if (!all && nilfs_suinfo_clean(&suinfos[i]))
+			continue;
+
+		t = (time_t)suinfos[i].sui_lastmod;
+		if (t != 0) {
+			localtime_r(&t, &tm);
+			strftime(timebuf, LSSU_BUFSIZE, "%F %T", &tm);
+		} else
+			snprintf(timebuf, LSSU_BUFSIZE,
+				 "---------- --:--:--");
+
+		switch (disp_mode) {
+		case LSSU_MODE_NORMAL:
+			printf(lssu_format[disp_mode].body,
 			       (unsigned long long)segnum,
 			       timebuf,
 			       nilfs_suinfo_active(&suinfos[i]) ? 'a' : '-',
 			       nilfs_suinfo_dirty(&suinfos[i]) ? 'd' : '-',
 			       nilfs_suinfo_error(&suinfos[i]) ? 'e' : '-',
 			       suinfos[i].sui_nblocks);
-			n++;
+			break;
+		case LSSU_MODE_LATEST_USAGE:
+			nliveblks = 0;
+			ratio = 0;
+
+			if (!nilfs_suinfo_dirty(&suinfos[i]) ||
+			    nilfs_suinfo_error(&suinfos[i]))
+				goto skip_scan;
+
+			ret = lssu_get_latest_usage(nilfs, segnum, protseq,
+						    protcno);
+			if (ret >= 0) {
+				nliveblks = ret;
+				ratio = (ret * 100 + 99) / blocks_per_segment;
+			} else if (ret == -2) {
+				nliveblks = suinfos[i].sui_nblocks;
+				ratio = 100;
+			} else {
+				fprintf(stderr,
+					"%s: failed to get usage: %s\n",
+					progname, strerror(errno));
+				exit(1);
+			}
+
+		skip_scan:
+			printf(lssu_format[disp_mode].body,
+			       (unsigned long long)segnum,
+			       timebuf,
+			       nilfs_suinfo_active(&suinfos[i]) ? 'a' : '-',
+			       nilfs_suinfo_dirty(&suinfos[i]) ? 'd' : '-',
+			       nilfs_suinfo_error(&suinfos[i]) ? 'e' : '-',
+			       suinfos[i].sui_nblocks, nliveblks, ratio);
+			break;
 		}
+		n++;
 	}
 	return n;
 }
 
-static int lssu_list_suinfo(struct nilfs *nilfs, int all)
+static int lssu_list_suinfo(struct nilfs *nilfs)
 {
 	struct nilfs_sustat sustat;
 	__u64 segnum, rest, count;
@@ -128,23 +244,66 @@ static int lssu_list_suinfo(struct nilfs *nilfs, int all)
 		if (nsi < 0)
 			return 1;
 
-		n = lssu_print_suinfo(segnum, nsi, all);
+		n = lssu_print_suinfo(nilfs, segnum, nsi, sustat.ss_prot_seq);
 		segnum += nsi;
 	}
 
 	return 0;
 }
 
+static int lssu_get_protcno(struct nilfs *nilfs,
+			    unsigned long protection_period,
+			    nilfs_cno_t *protcnop)
+{
+	struct nilfs_cnoconv *cnoconv;
+	struct timeval tv;
+	__u64 prottime;
+	int ret;
+
+	if (protection_period == ULONG_MAX) {
+		*protcnop = NILFS_CNO_MAX;
+		return 0;
+	}
+
+	ret = gettimeofday(&tv, NULL);
+	if (ret < 0) {
+		fprintf(stderr, "%s: cannot get current time: %m\n", progname);
+		return -1;
+	}
+	prottime = tv.tv_sec - protection_period;
+
+	cnoconv = nilfs_cnoconv_create(nilfs);
+	if (!cnoconv) {
+		fprintf(stderr,
+			"%s: cannot create checkpoint number converter: %m\n",
+			progname);
+		return -1;
+	}
+
+	ret = nilfs_cnoconv_time2cno(cnoconv, prottime, protcnop);
+	if (ret < 0) {
+		fprintf(stderr,
+			"%s: cannot convert protectoin time to checkpoint "
+			"number: %m\n",
+			progname);
+	}
+
+	nilfs_cnoconv_destroy(cnoconv);
+	return ret;
+}
+
 int main(int argc, char *argv[])
 {
 	struct nilfs *nilfs;
-	char *dev, *progname;
-	int c, all, status;
+	char *dev;
+	int c, status;
+	int open_flags;
+	unsigned long protection_period = ULONG_MAX;
+	int ret;
 #ifdef _GNU_SOURCE
 	int option_index;
 #endif	/* _GNU_SOURCE */
 
-	all = 0;
 	opterr = 0;
 	progname = strrchr(argv[0], '/');
 	if (progname == NULL)
@@ -153,10 +312,10 @@ int main(int argc, char *argv[])
 		progname++;
 
 #ifdef _GNU_SOURCE
-	while ((c = getopt_long(argc, argv, "ai:n:hV",
+	while ((c = getopt_long(argc, argv, "ai:ln:hp:V",
 				long_option, &option_index)) >= 0) {
 #else	/* !_GNU_SOURCE */
-	while ((c = getopt(argc, argv, "ai:n:hV")) >= 0) {
+	while ((c = getopt(argc, argv, "ai:ln:hp:V")) >= 0) {
 #endif	/* _GNU_SOURCE */
 
 		switch (c) {
@@ -166,12 +325,30 @@ int main(int argc, char *argv[])
 		case 'i':
 			param_index = (__u64)atoll(optarg);
 			break;
+		case 'l':
+			latest = 1;
+			break;
 		case 'n':
 			param_lines = (__u64)atoll(optarg);
 			break;
 		case 'h':
 			fprintf(stderr, LSSU_USAGE, progname);
 			exit(0);
+		case 'p':
+			ret = nilfs_parse_protection_period(
+				optarg, &protection_period);
+			if (!ret)
+				break;
+
+			if (errno == ERANGE) {
+				fprintf(stderr, "too large period: %s\n",
+					optarg);
+			} else {
+				fprintf(stderr,
+					"invalid protection period: %s\n",
+					optarg);
+			}
+			exit(1);
 		case 'V':
 			printf("%s (%s %s)\n", progname, PACKAGE,
 			       PACKAGE_VERSION);
@@ -192,14 +369,26 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 
-	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDONLY);
+	open_flags = NILFS_OPEN_RDONLY;
+	if (latest)
+		open_flags |= NILFS_OPEN_RAW | NILFS_OPEN_GCLK;
+
+	nilfs = nilfs_open(dev, NULL, open_flags);
 	if (nilfs == NULL) {
 		fprintf(stderr, "%s: %s: cannot open NILFS\n",
 			progname, dev);
 		exit(1);
 	}
 
-	status = lssu_list_suinfo(nilfs, all);
+	if (latest) {
+		blocks_per_segment = nilfs_get_blocks_per_segment(nilfs);
+		disp_mode = LSSU_MODE_LATEST_USAGE;
+		ret = lssu_get_protcno(nilfs, protection_period, &protcno);
+		if (ret < 0)
+			exit(1);
+	}
+
+	status = lssu_list_suinfo(nilfs);
 
 	nilfs_close(nilfs);
 	exit(status);
diff --git a/man/lssu.1 b/man/lssu.1
index 00cfcfa..2b58f8f 100644
--- a/man/lssu.1
+++ b/man/lssu.1
@@ -1,7 +1,7 @@
 .\"  Copyright (C) 2007-2012 Nippon Telegraph and Telephone Corporation.
 .\"  Written by Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
 .\"
-.TH LSSU 1 "May 2011" "nilfs-utils version 2.1"
+.TH LSSU 1 "Feb 2014" "nilfs-utils version 2.1"
 .SH NAME
 lssu \- list usage state of NILFS2 segments
 .SH SYNOPSIS
@@ -27,9 +27,17 @@ Display help message and exit.
 \fB\-i \fIindex\fR, \fB\-\-index\fR=\fIindex\fR
 Skip \fIindex\fP segments at start of input.
 .TP
+\fB\-l\fR, \fB\-\-latest-usage\fR
+Print usage status of the moment.
+.TP
 \fB\-n \fIlines\fR, \fB\-\-lines\fR=\fIlines\fR
 List only \fIlines\fP input segments.
 .TP
+\fB\-p \fIperiod\fR, \fB\-\-protection-period\fR=\fIperiod\fR
+Specify protection period.  This option is used when printing usage
+status of the moment (with \fB\-l\fR option) to test if each
+block in segments is protected and is not reclaimable.
+.TP
 \fB\-V\fR, \fB\-\-version\fR
 Display version and exit.
 .SH "FIELD DESCRIPTION"
@@ -63,6 +71,10 @@ error.  NILFS2 avoids allocating the segments with this flag.
 .TP
 .B NBLOCKS
 Number of in-use blocks of the segment.
+.TP
+.B NLIVEBLOCKS (optional)
+Number and ratio of in-use blocks of the moment.  This field is
+displayed when \fB\-l\fR option is specified.
 .SH AUTHOR
 Koji Sato
 .SH AVAILABILITY
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
