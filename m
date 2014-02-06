From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v5 3/6] nilfs-utils: nilfs-clean add cmdline param min-reclaimable-blocks
Date: Thu,  6 Feb 2014 15:17:23 +0100
Message-ID: <f93e550aaf08c0edaa6f04518ceb34b42975c839.1391692941.git.andreas.rohner@gmx.net>
References: <cover.1391692941.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1391692941.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1391692941.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1391692941.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch adds a command line parameter for nilfs-clean to allow
the manual override of the min_reclaimable_blocks option.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs_cleaner.h        | 19 +++++++++---------
 man/nilfs-clean.8              |  4 ++++
 sbin/cleanerd/cleanerd.c       | 21 ++++++++++++++++++++
 sbin/nilfs-clean/nilfs-clean.c | 44 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 73 insertions(+), 15 deletions(-)

diff --git a/include/nilfs_cleaner.h b/include/nilfs_cleaner.h
index 0bf02aa..874c17a 100644
--- a/include/nilfs_cleaner.h
+++ b/include/nilfs_cleaner.h
@@ -46,17 +46,18 @@ struct nilfs_cleaner_args {
 	uint64_t start_segnum;	/* start segment number */
 	uint64_t nsegs;		/* number of segments */
 	uint32_t runtime; /* runtime in seconds */
-	uint32_t pad2;
+	uint32_t min_reclaimable_blocks;
 };
 /* valid flags */
-#define NILFS_CLEANER_ARG_PROTECTION_PERIOD	(1 << 0)
-#define NILFS_CLEANER_ARG_NSEGMENTS_PER_CLEAN	(1 << 1)
-#define NILFS_CLEANER_ARG_CLEANING_INTERVAL	(1 << 2)
-#define NILFS_CLEANER_ARG_USAGE_RATE_THRESHOLD	(1 << 3) /* reserved */
-#define NILFS_CLEANER_ARG_START_SEGNUM		(1 << 4) /* reserved */
-#define NILFS_CLEANER_ARG_NSEGS			(1 << 5) /* reserved */
-#define NILFS_CLEANER_ARG_NPASSES		(1 << 6) /* reserved */
-#define NILFS_CLEANER_ARG_RUNTIME		(1 << 7) /* reserved */
+#define NILFS_CLEANER_ARG_PROTECTION_PERIOD		(1 << 0)
+#define NILFS_CLEANER_ARG_NSEGMENTS_PER_CLEAN		(1 << 1)
+#define NILFS_CLEANER_ARG_CLEANING_INTERVAL		(1 << 2)
+#define NILFS_CLEANER_ARG_USAGE_RATE_THRESHOLD		(1 << 3) /* reserved */
+#define NILFS_CLEANER_ARG_START_SEGNUM			(1 << 4) /* reserved */
+#define NILFS_CLEANER_ARG_NSEGS				(1 << 5) /* reserved */
+#define NILFS_CLEANER_ARG_NPASSES			(1 << 6) /* reserved */
+#define NILFS_CLEANER_ARG_RUNTIME			(1 << 7) /* reserved */
+#define NILFS_CLEANER_ARG_MIN_RECLAIMABLE_BLOCKS	(1 << 8)
 
 enum {
 	NILFS_CLEANER_STATUS_IDLE,
diff --git a/man/nilfs-clean.8 b/man/nilfs-clean.8
index 04e11c6..94267e1 100644
--- a/man/nilfs-clean.8
+++ b/man/nilfs-clean.8
@@ -43,6 +43,10 @@ Display cleaner status.
 \fB\-h\fR, \fB\-\-help\fR
 Display help message and exit.
 .TP
+\fB\-m\fR, \fB\-\-min\-reclaimable\-blocks=\fICOUNT\fR
+Specify the minimum number of reclaimable blocks in a segment before
+it can be cleaned.
+.TP
 \fB\-p\fR, \fB\-\-protection-period=\fIinterval\fR
 Set protection period for a cleaner run.  The \fIinterval\fR parameter
 is an integer value and specifies the minimum time that deleted or
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 4624f92..2896af8 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -159,6 +159,7 @@ const static struct option long_option[] = {
  * @mm_ncleansegs: number of segmetns cleaned per cycle (manual mode)
  * @mm_protection_period: protection period (manual mode)
  * @mm_cleaning_interval: cleaning interval (manual mode)
+ * @mm_min_reclaimable_blocks: min. number of reclaimable blocks (manual mode)
  */
 struct nilfs_cleanerd {
 	struct nilfs *nilfs;
@@ -186,6 +187,7 @@ struct nilfs_cleanerd {
 	long mm_ncleansegs;
 	struct timeval mm_protection_period;
 	struct timeval mm_cleaning_interval;
+	unsigned long mm_min_reclaimable_blocks;
 };
 
 /**
@@ -469,6 +471,14 @@ nilfs_cleanerd_protection_period(struct nilfs_cleanerd *cleanerd)
 		&cleanerd->config.cf_protection_period;
 }
 
+static unsigned long
+nilfs_cleanerd_min_reclaimable_blocks(struct nilfs_cleanerd *cleanerd)
+{
+	return cleanerd->running == 2 ?
+		cleanerd->mm_min_reclaimable_blocks :
+		cleanerd->min_reclaimable_blocks;
+}
+
 static void
 nilfs_cleanerd_reduce_ncleansegs_for_retry(struct nilfs_cleanerd *cleanerd)
 {
@@ -1011,6 +1021,17 @@ static int nilfs_cleanerd_cmd_run(struct nilfs_cleanerd *cleanerd,
 		cleanerd->mm_cleaning_interval =
 			cleanerd->cleaning_interval;
 	}
+	/* minimal reclaimable blocks */
+	if (req2->args.valid & NILFS_CLEANER_ARG_MIN_RECLAIMABLE_BLOCKS) {
+		if (req2->args.min_reclaimable_blocks >
+		    nilfs_get_blocks_per_segment(cleanerd->nilfs))
+			goto error_inval;
+		cleanerd->mm_min_reclaimable_blocks =
+			req2->args.min_reclaimable_blocks;
+	} else {
+		cleanerd->mm_min_reclaimable_blocks =
+			cleanerd->min_reclaimable_blocks;
+	}
 	/* number of passes */
 	if (req2->args.valid & NILFS_CLEANER_ARG_NPASSES) {
 		if (!req2->args.npasses)
diff --git a/sbin/nilfs-clean/nilfs-clean.c b/sbin/nilfs-clean/nilfs-clean.c
index 55abd55..f77fdf7 100644
--- a/sbin/nilfs-clean/nilfs-clean.c
+++ b/sbin/nilfs-clean/nilfs-clean.c
@@ -77,6 +77,7 @@ const static struct option long_option[] = {
 	{"stop", no_argument, NULL, 'b'},
 	{"suspend", no_argument, NULL, 's'},
 	{"speed", required_argument, NULL, 'S'},
+	{"min-reclaimable-blocks", required_argument, NULL, 'm'},
 	{"verbose", no_argument, NULL, 'v'},
 	{"version", no_argument, NULL, 'V'},
 	{NULL, 0, NULL, 0}
@@ -90,6 +91,9 @@ const static struct option long_option[] = {
 	"  -l, --status\t\tdisplay cleaner status\n"			\
 	"  -p, --protection-period=SECONDS\n"				\
 	"               \t\tspecify protection period\n"		\
+	"  -m, --min-reclaimable-blocks=COUNT\n"			\
+	"               \t\tset minimum number of reclaimable blocks\n"	\
+	"               \t\tbefore a segment can be cleaned\n"		\
 	"  -q, --quit\t\tshutdown cleaner\n"				\
 	"  -r, --resume\t\tresume cleaner\n"				\
 	"  -s, --suspend\t\tsuspend cleaner\n"				\
@@ -98,9 +102,10 @@ const static struct option long_option[] = {
 	"  -v, --verbose\t\tverbose mode\n"				\
 	"  -V, --version\t\tdisplay version and exit\n"
 #else
-#define NILFS_CLEAN_USAGE						\
-	"Usage: %s [-b] [-c [conffile]] [-h] [-l] [-p protection-period]" \
-	"          [-q] [-r] [-s] [-S gc-speed] [-v] [-V] [device]\n"
+#define NILFS_CLEAN_USAGE						  \
+	"Usage: %s [-b] [-c [conffile]] [-h] [-l] [-m blocks]\n"	  \
+	"          [-p protection-period] [-q] [-r] [-s] [-S gc-speed]\n" \
+	"          [-v] [-V] [device]\n"
 #endif	/* _GNU_SOURCE */
 
 
@@ -124,6 +129,7 @@ static const char *conffile = NULL;
 static unsigned long protection_period = ULONG_MAX;
 static int nsegments_per_clean = 2;
 static struct timespec cleaning_interval = { 0, 100000000 };   /* 100 msec */
+static unsigned long min_reclaimable_blocks = 20;  /* about 1% with 8MB segs */
 
 static sigjmp_buf nilfs_clean_env;
 static struct nilfs_cleaner *nilfs_cleaner;
@@ -164,9 +170,11 @@ static int nilfs_clean_do_run(struct nilfs_cleaner *cleaner)
 	args.nsegments_per_clean = nsegments_per_clean;
 	args.cleaning_interval = cleaning_interval.tv_sec;
 	args.cleaning_interval_nsec = cleaning_interval.tv_nsec;
+	args.min_reclaimable_blocks = min_reclaimable_blocks;
 	args.valid = (NILFS_CLEANER_ARG_NPASSES |
 		      NILFS_CLEANER_ARG_CLEANING_INTERVAL |
-		      NILFS_CLEANER_ARG_NSEGMENTS_PER_CLEAN);
+		      NILFS_CLEANER_ARG_NSEGMENTS_PER_CLEAN |
+		      NILFS_CLEANER_ARG_MIN_RECLAIMABLE_BLOCKS);
 
 	if (protection_period != ULONG_MAX) {
 		args.protection_period = protection_period;
@@ -426,6 +434,26 @@ failed_too_large:
 	return -1;
 }
 
+static int nilfs_clean_parse_min_reclaimable(const char *arg)
+{
+	unsigned long blocks;
+	char *endptr;
+
+	blocks = strtoul(arg, &endptr, 10);
+	if (endptr == arg || endptr[0] != '\0') {
+		myprintf(_("Error: invalid reclaimable blocks: %s\n"), arg);
+		return -1;
+	}
+
+	if (blocks == ULONG_MAX) {
+		myprintf(_("Error: value too large: %s\n"), arg);
+		return -1;
+	}
+
+	min_reclaimable_blocks = blocks;
+	return 0;
+}
+
 static void nilfs_clean_parse_options(int argc, char *argv[])
 {
 #ifdef _GNU_SOURCE
@@ -434,10 +462,10 @@ static void nilfs_clean_parse_options(int argc, char *argv[])
 	int c;
 
 #ifdef _GNU_SOURCE
-	while ((c = getopt_long(argc, argv, "bc::hlp:qrsS:vV",
+	while ((c = getopt_long(argc, argv, "bc::hlm:p:qrsS:vV",
 				long_option, &option_index)) >= 0) {
 #else
-	while ((c = getopt(argc, argv, "bc::hlp:qrsS:vV")) >= 0) {
+	while ((c = getopt(argc, argv, "bc::hlm:p:qrsS:vV")) >= 0) {
 #endif	/* _GNU_SOURCE */
 		switch (c) {
 		case 'b':
@@ -455,6 +483,10 @@ static void nilfs_clean_parse_options(int argc, char *argv[])
 		case 'l':
 			clean_cmd = NILFS_CLEAN_CMD_INFO;
 			break;
+		case 'm':
+			if (nilfs_clean_parse_min_reclaimable(optarg) < 0)
+				exit(EXIT_FAILURE);
+			break;
 		case 'p':
 			if (nilfs_clean_parse_protection_period(optarg) < 0)
 				exit(EXIT_FAILURE);
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
