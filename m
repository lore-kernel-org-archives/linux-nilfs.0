From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 1/5] nilfs-utils: cldconfig add an option to set minimal free blocks
Date: Tue, 21 Jan 2014 14:59:40 +0100
Message-ID: <22b5b3ac403052d3044dc8c1bebe323191376c03.1390310509.git.andreas.rohner@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

With this option the user can specify the minimal number of free/dead
blocks before a segment can be cleaned. This is a threshold for the GC
to prevent needless moving of data. If there are less free blocks
to gain from cleaning a segment than the specified number, the GC will
abort and try again with a different segment.

By setting it to 0 this feature is effectively disabled.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs_cleaner.h           | 19 ++++++++++---------
 sbin/cleanerd/cldconfig.c         | 40 +++++++++++++++++++++++++++++++++++++++
 sbin/cleanerd/cldconfig.h         |  4 ++++
 sbin/cleanerd/cleanerd.c          | 23 ++++++++++++++++++++++
 sbin/cleanerd/nilfs_cleanerd.conf |  9 +++++++++
 sbin/nilfs-clean/nilfs-clean.c    | 18 ++++++++++++++----
 6 files changed, 100 insertions(+), 13 deletions(-)

diff --git a/include/nilfs_cleaner.h b/include/nilfs_cleaner.h
index 0bf02aa..42c4aa7 100644
--- a/include/nilfs_cleaner.h
+++ b/include/nilfs_cleaner.h
@@ -46,17 +46,18 @@ struct nilfs_cleaner_args {
 	uint64_t start_segnum;	/* start segment number */
 	uint64_t nsegs;		/* number of segments */
 	uint32_t runtime; /* runtime in seconds */
-	uint32_t pad2;
+	uint32_t min_free_blocks_threshold;
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
+#define NILFS_CLEANER_ARG_MIN_FREE_BLOCKS_THRESHOLD	(1 << 8)
 
 enum {
 	NILFS_CLEANER_STATUS_IDLE,
diff --git a/sbin/cleanerd/cldconfig.c b/sbin/cleanerd/cldconfig.c
index 270d360..4d7589c 100644
--- a/sbin/cleanerd/cldconfig.c
+++ b/sbin/cleanerd/cldconfig.c
@@ -456,6 +456,34 @@ nilfs_cldconfig_handle_mc_nsegments_per_clean(struct nilfs_cldconfig *config,
 }
 
 static int
+nilfs_cldconfig_handle_min_free_blocks(struct nilfs_cldconfig *config,
+				       char **tokens, size_t ntoks,
+				       struct nilfs *nilfs)
+{
+	unsigned long n;
+
+	if (nilfs_cldconfig_get_ulong_argument(tokens, ntoks, &n) < 0)
+		return 0;
+
+	config->cf_min_free_blocks_threshold = n;
+	return 0;
+}
+
+static int
+nilfs_cldconfig_handle_mc_min_free_blocks(struct nilfs_cldconfig *config,
+					  char **tokens, size_t ntoks,
+					  struct nilfs *nilfs)
+{
+	unsigned long n;
+
+	if (nilfs_cldconfig_get_ulong_argument(tokens, ntoks, &n) < 0)
+		return 0;
+
+	config->cf_mc_min_free_blocks_threshold = n;
+	return 0;
+}
+
+static int
 nilfs_cldconfig_handle_cleaning_interval(struct nilfs_cldconfig *config,
 					 char **tokens, size_t ntoks,
 					 struct nilfs *nilfs)
@@ -576,6 +604,14 @@ nilfs_cldconfig_keyword_table[] = {
 		"log_priority", 2, 2,
 		nilfs_cldconfig_handle_log_priority
 	},
+	{
+		"min_free_blocks_threshold", 2, 2,
+		nilfs_cldconfig_handle_min_free_blocks
+	},
+	{
+		"mc_min_free_blocks_threshold", 2, 2,
+		nilfs_cldconfig_handle_mc_min_free_blocks
+	},
 };
 
 #define NILFS_CLDCONFIG_NKEYWORDS			\
@@ -641,6 +677,10 @@ static void nilfs_cldconfig_set_default(struct nilfs_cldconfig *config,
 	config->cf_retry_interval.tv_usec = 0;
 	config->cf_use_mmap = NILFS_CLDCONFIG_USE_MMAP;
 	config->cf_log_priority = NILFS_CLDCONFIG_LOG_PRIORITY;
+	config->cf_min_free_blocks_threshold =
+		NILFS_CLDCONFIG_MIN_FREE_BLOCKS_THRESHOLD;
+	config->cf_mc_min_free_blocks_threshold =
+		NILFS_CLDCONFIG_MC_MIN_FREE_BLOCKS_THRESHOLD;
 }
 
 static inline int iseol(int c)
diff --git a/sbin/cleanerd/cldconfig.h b/sbin/cleanerd/cldconfig.h
index 188ce9b..49ee6be 100644
--- a/sbin/cleanerd/cldconfig.h
+++ b/sbin/cleanerd/cldconfig.h
@@ -102,6 +102,8 @@ struct nilfs_cldconfig {
 	struct timeval cf_retry_interval;
 	int cf_use_mmap;
 	int cf_log_priority;
+	unsigned long cf_min_free_blocks_threshold;
+	unsigned long cf_mc_min_free_blocks_threshold;
 };
 
 #define NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE	\
@@ -120,6 +122,8 @@ struct nilfs_cldconfig {
 #define NILFS_CLDCONFIG_RETRY_INTERVAL			60
 #define NILFS_CLDCONFIG_USE_MMAP			1
 #define NILFS_CLDCONFIG_LOG_PRIORITY			LOG_INFO
+#define NILFS_CLDCONFIG_MIN_FREE_BLOCKS_THRESHOLD	256
+#define NILFS_CLDCONFIG_MC_MIN_FREE_BLOCKS_THRESHOLD	128
 
 #define NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX	32
 
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 86dfcf7..eb6eace 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -172,6 +172,7 @@ struct nilfs_cleanerd {
 	struct timeval cleaning_interval;
 	struct timeval target;
 	struct timeval timeout;
+	unsigned long min_free_blocks_threshold;
 	__u64 prev_nongc_ctime;
 	mqd_t recvq;
 	char *recvq_name;
@@ -184,6 +185,7 @@ struct nilfs_cleanerd {
 	long mm_ncleansegs;
 	struct timeval mm_protection_period;
 	struct timeval mm_cleaning_interval;
+	unsigned long mm_min_free_blocks_threshold;
 };
 
 /**
@@ -459,6 +461,14 @@ nilfs_cleanerd_protection_period(struct nilfs_cleanerd *cleanerd)
 		&cleanerd->config.cf_protection_period;
 }
 
+static unsigned long
+nilfs_cleanerd_min_free_blocks_threshold(struct nilfs_cleanerd *cleanerd)
+{
+	return cleanerd->running == 2 ?
+		cleanerd->mm_min_free_blocks_threshold :
+		cleanerd->min_free_blocks_threshold;
+}
+
 static void
 nilfs_cleanerd_reduce_ncleansegs_for_retry(struct nilfs_cleanerd *cleanerd)
 {
@@ -998,6 +1008,13 @@ static int nilfs_cleanerd_cmd_run(struct nilfs_cleanerd *cleanerd,
 		cleanerd->mm_cleaning_interval =
 			cleanerd->cleaning_interval;
 	}
+	/* minimal free blocks threshold */
+	if (req2->args.valid & NILFS_CLEANER_ARG_MIN_FREE_BLOCKS_THRESHOLD) {
+		cleanerd->mm_min_free_blocks_threshold =
+			req2->args.min_free_blocks_threshold;
+	} else {
+		cleanerd->mm_min_free_blocks_threshold = 0;
+	}
 	/* number of passes */
 	if (req2->args.valid & NILFS_CLEANER_ARG_NPASSES) {
 		if (!req2->args.npasses)
@@ -1235,10 +1252,14 @@ static int nilfs_cleanerd_handle_clean_check(struct nilfs_cleanerd *cleanerd,
 		/* disk space is close to limit -- accelerate cleaning */
 		cleanerd->ncleansegs = config->cf_mc_nsegments_per_clean;
 		cleanerd->cleaning_interval = config->cf_mc_cleaning_interval;
+		cleanerd->min_free_blocks_threshold =
+				config->cf_mc_min_free_blocks_threshold;
 	} else {
 		/* continue to run */
 		cleanerd->ncleansegs = config->cf_nsegments_per_clean;
 		cleanerd->cleaning_interval = config->cf_cleaning_interval;
+		cleanerd->min_free_blocks_threshold =
+				config->cf_min_free_blocks_threshold;
 	}
 
 	return 0; /* do gc */
@@ -1424,6 +1445,8 @@ static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
 
 	cleanerd->ncleansegs = cleanerd->config.cf_nsegments_per_clean;
 	cleanerd->cleaning_interval = cleanerd->config.cf_cleaning_interval;
+	cleanerd->min_free_blocks_threshold =
+			cleanerd->config.cf_min_free_blocks_threshold;
 
 
 	if (nilfs_cleanerd_automatic_suspend(cleanerd))
diff --git a/sbin/cleanerd/nilfs_cleanerd.conf b/sbin/cleanerd/nilfs_cleanerd.conf
index 26872aa..23ef8de 100644
--- a/sbin/cleanerd/nilfs_cleanerd.conf
+++ b/sbin/cleanerd/nilfs_cleanerd.conf
@@ -51,6 +51,15 @@ mc_cleaning_interval	1
 # Retry interval in seconds.
 retry_interval		60
 
+# Minimal number of free blocks before a segment
+# can be cleaned. Set to 0 to disable it.
+min_free_blocks_threshold	256
+
+# Minimal number of free blocks before a segment
+# can be cleaned. Set to 0 to disable it.
+# if clean segments < min_clean_segments
+mc_min_free_blocks_threshold	128
+
 # Use mmap when reading segments if supported.
 use_mmap
 
diff --git a/sbin/nilfs-clean/nilfs-clean.c b/sbin/nilfs-clean/nilfs-clean.c
index 55abd55..23b7e61 100644
--- a/sbin/nilfs-clean/nilfs-clean.c
+++ b/sbin/nilfs-clean/nilfs-clean.c
@@ -77,6 +77,7 @@ const static struct option long_option[] = {
 	{"stop", no_argument, NULL, 'b'},
 	{"suspend", no_argument, NULL, 's'},
 	{"speed", required_argument, NULL, 'S'},
+	{"free-blocks-threshold", optional_argument, NULL, 't'},
 	{"verbose", no_argument, NULL, 'v'},
 	{"version", no_argument, NULL, 'V'},
 	{NULL, 0, NULL, 0}
@@ -95,12 +96,15 @@ const static struct option long_option[] = {
 	"  -s, --suspend\t\tsuspend cleaner\n"				\
 	"  -S, --speed=COUNT[/SECONDS]\n"				\
 	"               \t\tset GC speed\n"				\
+	"  -t, --free-blocks-threshold=COUNT\n"				\
+	"               \t\tset minimal number of free blocks before\n"	\
+	"               \t\ta segment can be cleaned\n"			\
 	"  -v, --verbose\t\tverbose mode\n"				\
 	"  -V, --version\t\tdisplay version and exit\n"
 #else
 #define NILFS_CLEAN_USAGE						\
 	"Usage: %s [-b] [-c [conffile]] [-h] [-l] [-p protection-period]" \
-	"          [-q] [-r] [-s] [-S gc-speed] [-v] [-V] [device]\n"
+	"          [-q] [-r] [-s] [-S gc-speed] [-t blocks][-v] [-V] [device]\n"
 #endif	/* _GNU_SOURCE */
 
 
@@ -124,6 +128,7 @@ static const char *conffile = NULL;
 static unsigned long protection_period = ULONG_MAX;
 static int nsegments_per_clean = 2;
 static struct timespec cleaning_interval = { 0, 100000000 };   /* 100 msec */
+static unsigned long min_free_blocks_threshold;
 
 static sigjmp_buf nilfs_clean_env;
 static struct nilfs_cleaner *nilfs_cleaner;
@@ -164,9 +169,11 @@ static int nilfs_clean_do_run(struct nilfs_cleaner *cleaner)
 	args.nsegments_per_clean = nsegments_per_clean;
 	args.cleaning_interval = cleaning_interval.tv_sec;
 	args.cleaning_interval_nsec = cleaning_interval.tv_nsec;
+	args.min_free_blocks_threshold = min_free_blocks_threshold;
 	args.valid = (NILFS_CLEANER_ARG_NPASSES |
 		      NILFS_CLEANER_ARG_CLEANING_INTERVAL |
-		      NILFS_CLEANER_ARG_NSEGMENTS_PER_CLEAN);
+		      NILFS_CLEANER_ARG_NSEGMENTS_PER_CLEAN |
+		      NILFS_CLEANER_ARG_MIN_FREE_BLOCKS_THRESHOLD);
 
 	if (protection_period != ULONG_MAX) {
 		args.protection_period = protection_period;
@@ -434,10 +441,10 @@ static void nilfs_clean_parse_options(int argc, char *argv[])
 	int c;
 
 #ifdef _GNU_SOURCE
-	while ((c = getopt_long(argc, argv, "bc::hlp:qrsS:vV",
+	while ((c = getopt_long(argc, argv, "bc::hlp:qrsS:t:vV",
 				long_option, &option_index)) >= 0) {
 #else
-	while ((c = getopt(argc, argv, "bc::hlp:qrsS:vV")) >= 0) {
+	while ((c = getopt(argc, argv, "bc::hlp:qrsS:t:vV")) >= 0) {
 #endif	/* _GNU_SOURCE */
 		switch (c) {
 		case 'b':
@@ -472,6 +479,9 @@ static void nilfs_clean_parse_options(int argc, char *argv[])
 			if (nilfs_clean_parse_gcspeed(optarg) < 0)
 				exit(EXIT_FAILURE);
 			break;
+		case 't':
+			min_free_blocks_threshold = strtoul(optarg, NULL, 10);
+			break;
 		case 'v':
 			verbose = 1;
 			break;
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
