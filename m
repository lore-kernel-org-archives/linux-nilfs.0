From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v6 1/6] nilfs-utils: cldconfig add an option to set min. reclaimable blocks
Date: Fri,  7 Feb 2014 13:16:16 +0100
Message-ID: <d7f1a80dab87a673a1e32d789959374309b6d9e8.1391774956.git.andreas.rohner@gmx.net>
References: <cover.1391774956.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1391774956.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1391774956.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1391774956.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
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
 man/nilfs_cleanerd.conf.5         |  22 +++++
 sbin/cleanerd/cldconfig.c         | 169 ++++++++++++++++++++++++++++----------
 sbin/cleanerd/cldconfig.h         |  12 +++
 sbin/cleanerd/cleanerd.c          |  10 +++
 sbin/cleanerd/nilfs_cleanerd.conf |  20 +++++
 5 files changed, 191 insertions(+), 42 deletions(-)

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
index 270d360..bdd8c85 100644
--- a/sbin/cleanerd/cldconfig.c
+++ b/sbin/cleanerd/cldconfig.c
@@ -278,6 +278,55 @@ nilfs_cldconfig_handle_protection_period(struct nilfs_cldconfig *config,
 }
 
 static unsigned long long
+nilfs_convert_units_to_bytes(const struct nilfs_param *param)
+{
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
@@ -287,48 +336,7 @@ nilfs_convert_size_to_nsegments(struct nilfs *nilfs, struct nilfs_param *param)
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
@@ -455,6 +463,52 @@ nilfs_cldconfig_handle_mc_nsegments_per_clean(struct nilfs_cldconfig *config,
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
@@ -490,6 +544,14 @@ static int nilfs_cldconfig_handle_use_mmap(struct nilfs_cldconfig *config,
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
@@ -576,6 +638,18 @@ nilfs_cldconfig_keyword_table[] = {
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
@@ -640,7 +714,18 @@ static void nilfs_cldconfig_set_default(struct nilfs_cldconfig *config,
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
index 188ce9b..0a598d5 100644
--- a/sbin/cleanerd/cldconfig.h
+++ b/sbin/cleanerd/cldconfig.h
@@ -87,7 +87,11 @@ enum nilfs_size_unit {
  * if clean segments < min_clean_segments
  * @cf_retry_interval: retry interval
  * @cf_use_mmap: flag that indicate using mmap
+ * @cf_use_set_suinfo: flag that indicates the use of the set_suinfo ioctl
  * @cf_log_priority: log priority level
+ * @cf_min_reclaimable_blocks: minimum reclaimable blocks for cleaning
+ * @cf_mc_min_reclaimable_blocks: minimum reclaimable blocks for cleaning
+ * if clean segments < min_clean_segments
  */
 struct nilfs_cldconfig {
 	struct nilfs_selection_policy cf_selection_policy;
@@ -101,7 +105,10 @@ struct nilfs_cldconfig {
 	struct timeval cf_mc_cleaning_interval;
 	struct timeval cf_retry_interval;
 	int cf_use_mmap;
+	int cf_use_set_suinfo;
 	int cf_log_priority;
+	unsigned long cf_min_reclaimable_blocks;
+	unsigned long cf_mc_min_reclaimable_blocks;
 };
 
 #define NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE	\
@@ -119,7 +126,12 @@ struct nilfs_cldconfig {
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
index 1d09b5b..c58a542 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -145,6 +145,7 @@ const static struct option long_option[] = {
  * @cleaning_interval: cleaning interval
  * @target: target time for sleeping
  * @timeout: timeout value for sleeping
+ * @min_reclaimable_blocks: min. number of reclaimable blocks
  * @prev_nongc_ctime: previous nongc ctime
  * @recvq: receive queue
  * @recvq_name: receive queue name
@@ -172,6 +173,7 @@ struct nilfs_cleanerd {
 	struct timeval cleaning_interval;
 	struct timeval target;
 	struct timeval timeout;
+	unsigned long min_reclaimable_blocks;
 	__u64 prev_nongc_ctime;
 	mqd_t recvq;
 	char *recvq_name;
@@ -273,6 +275,8 @@ static int nilfs_cleanerd_reconfig(struct nilfs_cleanerd *cleanerd,
 	} else {
 		cleanerd->ncleansegs = config->cf_nsegments_per_clean;
 		cleanerd->cleaning_interval = config->cf_cleaning_interval;
+		cleanerd->min_reclaimable_blocks =
+				config->cf_min_reclaimable_blocks;
 		syslog(LOG_INFO, "configuration file reloaded");
 	}
 	return ret;
@@ -1238,10 +1242,14 @@ static int nilfs_cleanerd_handle_clean_check(struct nilfs_cleanerd *cleanerd,
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
@@ -1442,6 +1450,8 @@ static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
 
 	cleanerd->ncleansegs = cleanerd->config.cf_nsegments_per_clean;
 	cleanerd->cleaning_interval = cleanerd->config.cf_cleaning_interval;
+	cleanerd->min_reclaimable_blocks =
+			cleanerd->config.cf_min_reclaimable_blocks;
 
 
 	if (nilfs_cleanerd_automatic_suspend(cleanerd))
diff --git a/sbin/cleanerd/nilfs_cleanerd.conf b/sbin/cleanerd/nilfs_cleanerd.conf
index 26872aa..79d3fce 100644
--- a/sbin/cleanerd/nilfs_cleanerd.conf
+++ b/sbin/cleanerd/nilfs_cleanerd.conf
@@ -51,6 +51,26 @@ mc_cleaning_interval	1
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
+# The argument of min_reclaimable_blocks and mc_min_reclaimable_blocks
+# can be followed by a percent sign (%) or one of the following
+# multiplicative suffixes similar to min_clean_segments.
+#
+# If the argument is followed by "%", it represents a ratio for the
+# number of blocks per segment.
+
+# enable set_suinfo ioctl if supported
+# (needed for min_reclaimable_blocks)
+#use_set_suinfo
+
 # Use mmap when reading segments if supported.
 use_mmap
 
-- 
1.8.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
