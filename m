From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v3 1/4] nilfs-utils: cldconfig add an option to set min. reclaimable blocks
Date: Mon, 27 Jan 2014 10:58:53 +0100
Message-ID: <7cf17e6c29aa41e08867a8f33d62062572521ab3.1390813175.git.andreas.rohner@gmx.net>
References: <cover.1390813175.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1390813175.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1390813175.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1390813175.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

With this option the user can specify the minimum number of
reclaimable blocks of a segment, before it can be cleaned. This is
a threshold for the GC to prevent needless moving of data. If
there are less reclaimable blocks in a segment than the specified
number, the GC will abort and try again with a different segment.

If there are less clean segments than min_clean_segments,
mc_min_reclaimable_blocks is used instead of
min_reclaimable_blocks. This allows for more flexibility in
configuring the GC.

The number of blocks can be specified in percent of a segment or
in bytes.

If the use_set_suinfo switch is not set, the optimization is
completely disabled.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs.h                   |   7 +-
 lib/nilfs.c                       |  28 +++++++
 man/nilfs_cleanerd.conf.5         |  22 +++++
 sbin/cleanerd/cldconfig.c         | 168 ++++++++++++++++++++++++++++----------
 sbin/cleanerd/cldconfig.h         |   8 ++
 sbin/cleanerd/cleanerd.c          |  15 ++++
 sbin/cleanerd/nilfs_cleanerd.conf |  13 +++
 7 files changed, 218 insertions(+), 43 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index 56286a9..b5f85d3 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -128,7 +128,8 @@ struct nilfs {
 #define NILFS_OPEN_RDWR		0x0008	/* Open NILFS API in read/write mode */
 #define NILFS_OPEN_GCLK		0x1000	/* Open GC lock primitive */
 
-#define NILFS_OPT_MMAP	0x01
+#define NILFS_OPT_MMAP		0x01
+#define NILFS_OPT_SET_SUINFO	0x02
 
 
 struct nilfs *nilfs_open(const char *, const char *, int);
@@ -140,6 +141,10 @@ void nilfs_opt_clear_mmap(struct nilfs *);
 int nilfs_opt_set_mmap(struct nilfs *);
 int nilfs_opt_test_mmap(struct nilfs *);
 
+void nilfs_opt_clear_set_suinfo(struct nilfs *);
+int nilfs_opt_set_set_suinfo(struct nilfs *);
+int nilfs_opt_test_set_suinfo(struct nilfs *);
+
 nilfs_cno_t nilfs_get_oldest_cno(struct nilfs *);
 
 struct nilfs_super_block *nilfs_get_sb(struct nilfs *);
diff --git a/lib/nilfs.c b/lib/nilfs.c
index c1771e8..93822de 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -288,6 +288,34 @@ int nilfs_opt_test_mmap(struct nilfs *nilfs)
 	return !!(nilfs->n_opts & NILFS_OPT_MMAP);
 }
 
+/**
+ * nilfs_opt_set_set_suinfo - set set_suinfo option
+ * @nilfs: nilfs object
+ */
+int nilfs_opt_set_set_suinfo(struct nilfs *nilfs)
+{
+	nilfs->n_opts |= NILFS_OPT_SET_SUINFO;
+	return 0;
+}
+
+/**
+ * nilfs_opt_clear_set_suinfo - clear set_suinfo option
+ * @nilfs: nilfs object
+ */
+void nilfs_opt_clear_set_suinfo(struct nilfs *nilfs)
+{
+	nilfs->n_opts &= ~NILFS_OPT_SET_SUINFO;
+}
+
+/**
+ * nilfs_opt_test_set_suinfo - test whether set_suinfo option is set or not
+ * @nilfs: nilfs object
+ */
+int nilfs_opt_test_set_suinfo(struct nilfs *nilfs)
+{
+	return !!(nilfs->n_opts & NILFS_OPT_SET_SUINFO);
+}
+
 static int nilfs_open_sem(struct nilfs *nilfs)
 {
 	char semnambuf[NAME_MAX - 4];
diff --git a/man/nilfs_cleanerd.conf.5 b/man/nilfs_cleanerd.conf.5
index 8f3fcd2..4315ecd 100644
--- a/man/nilfs_cleanerd.conf.5
+++ b/man/nilfs_cleanerd.conf.5
@@ -79,6 +79,28 @@ Specify whether to use \fBmmap\fP(2) for reading segments.  At
 present, this option is enabled if supported regardless of this
 directive.
 .TP
+.B use_set_suinfo
+Specify whether to use the set_suinfo ioctl if it is supported. This is
+necessary for the \fBmin_reclaimable_blocks\fP feature. By disabling this
+switch \fBmin_reclaimable_blocks\fP is also disabled.
+.TP
+.B min_reclaimable_blocks
+Specify the minimum number of reclaimable blocks in a segment before
+it can be cleaned.
+.TP
+.B mc_min_reclaimable_blocks
+Specify the minimum number of reclaimable blocks in a segment before
+it can be cleaned. if clean segments < min_clean_segments.
+.PP
+\fBmin_reclaimable_blocks\fP and \fBmc_min_reclaimable_blocks\fP may
+be followed by a percent sign or the following multiplicative suffixes:
+kB 1000, K 1024, MB 1000*1000, M 1024*1024, GB 1000*1000*1000, G
+1024*1024*1024, and so on for T, P, E.  If the argument is followed by
+a percent sign, it represents the ratio of blocks in a segment.
+.PP
+The default values of \fBmin_reclaimable_blocks\fP and
+\fBmc_min_reclaimable_blocks\fP are 5 percent and 1 percent respectively.
+.TP
 .B log_priority
 Gives the verbosity level that is used when logging messages from
 \fBnilfs_cleanerd\fP(8).  The possible values are: \fBemerg\fP,
diff --git a/sbin/cleanerd/cldconfig.c b/sbin/cleanerd/cldconfig.c
index 270d360..b69f060 100644
--- a/sbin/cleanerd/cldconfig.c
+++ b/sbin/cleanerd/cldconfig.c
@@ -278,6 +278,54 @@ nilfs_cldconfig_handle_protection_period(struct nilfs_cldconfig *config,
 }
 
 static unsigned long long
+nilfs_convert_units_to_bytes(struct nilfs_param *param) {
+	unsigned long long bytes = param->num;
+
+	switch (param->unit) {
+	case NILFS_SIZE_UNIT_KB:
+		bytes *= 1000ULL;
+		break;
+	case NILFS_SIZE_UNIT_KIB:
+		bytes <<= 10;
+		break;
+	case NILFS_SIZE_UNIT_MB:
+		bytes *= 1000000ULL;
+		break;
+	case NILFS_SIZE_UNIT_MIB:
+		bytes <<= 20;
+		break;
+	case NILFS_SIZE_UNIT_GB:
+		bytes *= 1000000000ULL;
+		break;
+	case NILFS_SIZE_UNIT_GIB:
+		bytes <<= 30;
+		break;
+	case NILFS_SIZE_UNIT_TB:
+		bytes *= 1000000000000ULL;
+		break;
+	case NILFS_SIZE_UNIT_TIB:
+		bytes <<= 40;
+		break;
+	case NILFS_SIZE_UNIT_PB:
+		bytes *= 1000000000000000ULL;
+		break;
+	case NILFS_SIZE_UNIT_PIB:
+		bytes <<= 50;
+		break;
+	case NILFS_SIZE_UNIT_EB:
+		bytes *= 1000000000000000000ULL;
+		break;
+	case NILFS_SIZE_UNIT_EIB:
+		bytes <<= 60;
+		break;
+	default:
+		assert(0);
+	}
+
+	return bytes;
+}
+
+static unsigned long long
 nilfs_convert_size_to_nsegments(struct nilfs *nilfs, struct nilfs_param *param)
 {
 	unsigned long long ret, segment_size, bytes;
@@ -287,48 +335,7 @@ nilfs_convert_size_to_nsegments(struct nilfs *nilfs, struct nilfs_param *param)
 	} else if (param->unit == NILFS_SIZE_UNIT_PERCENT) {
 		ret = (nilfs_get_nsegments(nilfs) * param->num + 99) / 100;
 	} else {
-		bytes = param->num;
-
-		switch (param->unit) {
-		case NILFS_SIZE_UNIT_KB:
-			bytes *= 1000ULL;
-			break;
-		case NILFS_SIZE_UNIT_KIB:
-			bytes <<= 10;
-			break;
-		case NILFS_SIZE_UNIT_MB:
-			bytes *= 1000000ULL;
-			break;
-		case NILFS_SIZE_UNIT_MIB:
-			bytes <<= 20;
-			break;
-		case NILFS_SIZE_UNIT_GB:
-			bytes *= 1000000000ULL;
-			break;
-		case NILFS_SIZE_UNIT_GIB:
-			bytes <<= 30;
-			break;
-		case NILFS_SIZE_UNIT_TB:
-			bytes *= 1000000000000ULL;
-			break;
-		case NILFS_SIZE_UNIT_TIB:
-			bytes <<= 40;
-			break;
-		case NILFS_SIZE_UNIT_PB:
-			bytes *= 1000000000000000ULL;
-			break;
-		case NILFS_SIZE_UNIT_PIB:
-			bytes <<= 50;
-			break;
-		case NILFS_SIZE_UNIT_EB:
-			bytes *= 1000000000000000000ULL;
-			break;
-		case NILFS_SIZE_UNIT_EIB:
-			bytes <<= 60;
-			break;
-		default:
-			assert(0);
-		}
+		bytes = nilfs_convert_units_to_bytes(param);
 		segment_size = nilfs_get_block_size(nilfs) *
 			nilfs_get_blocks_per_segment(nilfs);
 		ret = (bytes + segment_size - 1) / segment_size;
@@ -455,6 +462,52 @@ nilfs_cldconfig_handle_mc_nsegments_per_clean(struct nilfs_cldconfig *config,
 	return 0;
 }
 
+static unsigned long long
+nilfs_convert_size_to_blocks_per_segment(struct nilfs *nilfs,
+					 struct nilfs_param *param)
+{
+	unsigned long long ret, segment_size, block_size, bytes;
+
+	if (param->unit == NILFS_SIZE_UNIT_NONE) {
+		ret = param->num;
+	} else if (param->unit == NILFS_SIZE_UNIT_PERCENT) {
+		ret = (nilfs_get_blocks_per_segment(nilfs) * param->num) / 100;
+	} else {
+		block_size = nilfs_get_block_size(nilfs);
+		segment_size = block_size *
+				nilfs_get_blocks_per_segment(nilfs);
+		bytes = nilfs_convert_units_to_bytes(param) % segment_size;
+		ret = (bytes + block_size - 1) / block_size;
+	}
+	return ret;
+}
+
+static int
+nilfs_cldconfig_handle_min_reclaimable_blocks(struct nilfs_cldconfig *config,
+					      char **tokens, size_t ntoks,
+					      struct nilfs *nilfs)
+{
+	struct nilfs_param param;
+
+	if (nilfs_cldconfig_get_size_argument(tokens, ntoks, &param) == 0)
+		config->cf_min_reclaimable_blocks =
+			nilfs_convert_size_to_blocks_per_segment(nilfs, &param);
+	return 0;
+}
+
+static int
+nilfs_cldconfig_handle_mc_min_reclaimable_blocks(struct nilfs_cldconfig *config,
+						 char **tokens, size_t ntoks,
+						 struct nilfs *nilfs)
+{
+	struct nilfs_param param;
+
+	if (nilfs_cldconfig_get_size_argument(tokens, ntoks, &param) == 0)
+		config->cf_mc_min_reclaimable_blocks =
+			nilfs_convert_size_to_blocks_per_segment(nilfs, &param);
+	return 0;
+}
+
 static int
 nilfs_cldconfig_handle_cleaning_interval(struct nilfs_cldconfig *config,
 					 char **tokens, size_t ntoks,
@@ -490,6 +543,14 @@ static int nilfs_cldconfig_handle_use_mmap(struct nilfs_cldconfig *config,
 	return 0;
 }
 
+static int nilfs_cldconfig_handle_use_set_suinfo(struct nilfs_cldconfig *config,
+						 char **tokens, size_t ntoks,
+						 struct nilfs *nilfs)
+{
+	config->cf_use_set_suinfo = 1;
+	return 0;
+}
+
 static const struct nilfs_cldconfig_log_priority
 nilfs_cldconfig_log_priority_table[] = {
 	{"emerg",	LOG_EMERG},
@@ -576,6 +637,18 @@ nilfs_cldconfig_keyword_table[] = {
 		"log_priority", 2, 2,
 		nilfs_cldconfig_handle_log_priority
 	},
+	{
+		"min_reclaimable_blocks", 2, 2,
+		nilfs_cldconfig_handle_min_reclaimable_blocks
+	},
+	{
+		"mc_min_reclaimable_blocks", 2, 2,
+		nilfs_cldconfig_handle_mc_min_reclaimable_blocks
+	},
+	{
+		"use_set_suinfo", 1, 1,
+		nilfs_cldconfig_handle_use_set_suinfo
+	},
 };
 
 #define NILFS_CLDCONFIG_NKEYWORDS			\
@@ -640,7 +713,18 @@ static void nilfs_cldconfig_set_default(struct nilfs_cldconfig *config,
 	config->cf_retry_interval.tv_sec = NILFS_CLDCONFIG_RETRY_INTERVAL;
 	config->cf_retry_interval.tv_usec = 0;
 	config->cf_use_mmap = NILFS_CLDCONFIG_USE_MMAP;
+	config->cf_use_set_suinfo = NILFS_CLDCONFIG_USE_SET_SUINFO;
 	config->cf_log_priority = NILFS_CLDCONFIG_LOG_PRIORITY;
+
+	param.num = NILFS_CLDCONFIG_MIN_RECLAIMABLE_BLOCKS;
+	param.unit = NILFS_CLDCONFIG_MIN_RECLAIMABLE_BLOCKS_UNIT;
+	config->cf_min_reclaimable_blocks =
+		nilfs_convert_size_to_blocks_per_segment(nilfs, &param);
+
+	param.num = NILFS_CLDCONFIG_MC_MIN_RECLAIMABLE_BLOCKS;
+	param.unit = NILFS_CLDCONFIG_MC_MIN_RECLAIMABLE_BLOCKS_UNIT;
+	config->cf_mc_min_reclaimable_blocks =
+		nilfs_convert_size_to_blocks_per_segment(nilfs, &param);
 }
 
 static inline int iseol(int c)
diff --git a/sbin/cleanerd/cldconfig.h b/sbin/cleanerd/cldconfig.h
index 188ce9b..e7ac72e 100644
--- a/sbin/cleanerd/cldconfig.h
+++ b/sbin/cleanerd/cldconfig.h
@@ -101,7 +101,10 @@ struct nilfs_cldconfig {
 	struct timeval cf_mc_cleaning_interval;
 	struct timeval cf_retry_interval;
 	int cf_use_mmap;
+	int cf_use_set_suinfo;
 	int cf_log_priority;
+	unsigned long cf_min_reclaimable_blocks;
+	unsigned long cf_mc_min_reclaimable_blocks;
 };
 
 #define NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE	\
@@ -119,7 +122,12 @@ struct nilfs_cldconfig {
 #define NILFS_CLDCONFIG_MC_CLEANING_INTERVAL		1
 #define NILFS_CLDCONFIG_RETRY_INTERVAL			60
 #define NILFS_CLDCONFIG_USE_MMAP			1
+#define NILFS_CLDCONFIG_USE_SET_SUINFO			0
 #define NILFS_CLDCONFIG_LOG_PRIORITY			LOG_INFO
+#define NILFS_CLDCONFIG_MIN_RECLAIMABLE_BLOCKS		5
+#define NILFS_CLDCONFIG_MIN_RECLAIMABLE_BLOCKS_UNIT	NILFS_SIZE_UNIT_PERCENT
+#define NILFS_CLDCONFIG_MC_MIN_RECLAIMABLE_BLOCKS	1
+#define NILFS_CLDCONFIG_MC_MIN_RECLAIMABLE_BLOCKS_UNIT	NILFS_SIZE_UNIT_PERCENT
 
 #define NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX	32
 
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 742ab98..bf8b8b0 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -172,6 +172,7 @@ struct nilfs_cleanerd {
 	struct timeval cleaning_interval;
 	struct timeval target;
 	struct timeval timeout;
+	unsigned long min_reclaimable_blocks;
 	__u64 prev_nongc_ctime;
 	mqd_t recvq;
 	char *recvq_name;
@@ -246,6 +247,12 @@ static int nilfs_cleanerd_config(struct nilfs_cleanerd *cleanerd,
 	else
 		nilfs_opt_clear_mmap(cleanerd->nilfs);
 #endif	/* HAVE_MMAP */
+
+	if (cleanerd->config.cf_use_set_suinfo)
+		nilfs_opt_set_set_suinfo(cleanerd->nilfs);
+	else
+		nilfs_opt_clear_set_suinfo(cleanerd->nilfs);
+
 	nilfs_cleanerd_set_log_priority(cleanerd);
 
 	if (protection_period != ULONG_MAX) {
@@ -273,6 +280,8 @@ static int nilfs_cleanerd_reconfig(struct nilfs_cleanerd *cleanerd,
 	} else {
 		cleanerd->ncleansegs = config->cf_nsegments_per_clean;
 		cleanerd->cleaning_interval = config->cf_cleaning_interval;
+		cleanerd->min_reclaimable_blocks =
+				config->cf_min_reclaimable_blocks;
 		syslog(LOG_INFO, "configuration file reloaded");
 	}
 	return ret;
@@ -1238,10 +1247,14 @@ static int nilfs_cleanerd_handle_clean_check(struct nilfs_cleanerd *cleanerd,
 		/* disk space is close to limit -- accelerate cleaning */
 		cleanerd->ncleansegs = config->cf_mc_nsegments_per_clean;
 		cleanerd->cleaning_interval = config->cf_mc_cleaning_interval;
+		cleanerd->min_reclaimable_blocks =
+				config->cf_mc_min_reclaimable_blocks;
 	} else {
 		/* continue to run */
 		cleanerd->ncleansegs = config->cf_nsegments_per_clean;
 		cleanerd->cleaning_interval = config->cf_cleaning_interval;
+		cleanerd->min_reclaimable_blocks =
+				config->cf_min_reclaimable_blocks;
 	}
 
 	return 0; /* do gc */
@@ -1427,6 +1440,8 @@ static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
 
 	cleanerd->ncleansegs = cleanerd->config.cf_nsegments_per_clean;
 	cleanerd->cleaning_interval = cleanerd->config.cf_cleaning_interval;
+	cleanerd->min_reclaimable_blocks =
+			cleanerd->config.cf_min_reclaimable_blocks;
 
 
 	if (nilfs_cleanerd_automatic_suspend(cleanerd))
diff --git a/sbin/cleanerd/nilfs_cleanerd.conf b/sbin/cleanerd/nilfs_cleanerd.conf
index 26872aa..f88a57a 100644
--- a/sbin/cleanerd/nilfs_cleanerd.conf
+++ b/sbin/cleanerd/nilfs_cleanerd.conf
@@ -51,6 +51,19 @@ mc_cleaning_interval	1
 # Retry interval in seconds.
 retry_interval		60
 
+# Specify the minimum number of reclaimable blocks in a segment
+# before it can be cleaned.
+min_reclaimable_blocks	5%
+
+# Specify the minimum number of reclaimable blocks in a segment
+# before it can be cleaned.
+# if clean segments < min_clean_segments
+mc_min_reclaimable_blocks	1%
+
+# enable set_suinfo ioctl if supported
+# (needed for min_reclaimable_blocks)
+use_set_suinfo
+
 # Use mmap when reading segments if supported.
 use_mmap
 
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
