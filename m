From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Wed, 07 Apr 2010 01:12:17 +0900 (JST)
Message-ID: <20100407.011217.45149562.ryusuke@osrg.net>
References: <20100405.120226.98047309.ryusuke@osrg.net>
	<4BB99633.1030701@prnet.org>
	<20100405.203450.56374807.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100405.203450.56374807.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 05 Apr 2010 20:34:50 +0900 (JST), Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> > If you decide for the second set of nsegments_per_clean and
> > cleaning_interval_parameters, please tell me if I should implement it or
> > if you will implement it, not that we are working on the same
> > functionality at the same time.
> 
> I'll do the change of default values.  And will give over to you for
> this extension ;)

The following patch is my part.

Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs2-utils: adjust default values of min/max clean segments

This adjusts the default values of thresholds and check interval of GC
execution control to decrease dependency to the capacity and class of
disk devices.

The new default value are as follows:

min_clean_segments     10%
max_clean_segments     20%
clean_check_interval   10

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 man/nilfs_cleanerd.conf.5         |    9 +++++----
 sbin/cleanerd/cldconfig.c         |   20 ++++++++++++++++----
 sbin/cleanerd/cldconfig.h         |    8 +++++---
 sbin/cleanerd/nilfs_cleanerd.conf |    6 +++---
 4 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/man/nilfs_cleanerd.conf.5 b/man/nilfs_cleanerd.conf.5
index 9d5e807..ad99857 100644
--- a/man/nilfs_cleanerd.conf.5
+++ b/man/nilfs_cleanerd.conf.5
@@ -28,25 +28,26 @@ default value is 3600, meaning one hour.
 .B min_clean_segments
 Specify the minimum number of clean segments. A value of 0 means
 normal cleaner operation. A value greater than 0 means pause cleaning
-until less than min_clean_segments are available. The default value
-is 100.
+until less than min_clean_segments are available.
 .TP
 .B max_clean_segments
 Specify the maximum number of clean segments. If min_clean_segments is
 0, this value is ignored. If more than max_clean_segments are available
 cleaning is paused until less than min_clean_segments are available.
-The default value is 200.
 .PP
 \fBmin_clean_segments\fP and \fBmax_clean_segments\fP may be followed
 by a percent sign or the following multiplicative suffixes: kB 1000,
 K 1024, MB 1000*1000, M 1024*1024, GB 1000*1000*1000, G
 1024*1024*1024, and so on for T, P, E.  If the argument is followed by
 a percent sign, it represents a disk capacity ratio.
+.PP
+The default values of \fBmin_clean_segments\fP and
+\fBmax_clean_segments\fP are 10 percent and 20 percent respectively.
 .TP
 .B clean_check_interval
 Specify the interval to wait between checks of min_clean_segments.
 If min_clean_segments is 0, this value is ignored.
-The default value is 60.
+The default value is 10.
 .TP
 .B selection_policy
 Specify the GC policy. At present, only the `\fBtimestamp\fP' policy,
diff --git a/sbin/cleanerd/cldconfig.c b/sbin/cleanerd/cldconfig.c
index e7552b6..369cc22 100644
--- a/sbin/cleanerd/cldconfig.c
+++ b/sbin/cleanerd/cldconfig.c
@@ -584,15 +584,27 @@ static int nilfs_cldconfig_handle_keyword(struct nilfs_cldconfig *config,
 	return 0;
 }
 
-static void nilfs_cldconfig_set_default(struct nilfs_cldconfig *config)
+static void nilfs_cldconfig_set_default(struct nilfs_cldconfig *config,
+					struct nilfs *nilfs)
 {
+	struct nilfs_param param;
+
 	config->cf_selection_policy.p_importance =
 		NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE;
 	config->cf_selection_policy.p_threshold =
 		NILFS_CLDCONFIG_SELECTION_POLICY_THRESHOLD;
 	config->cf_protection_period = NILFS_CLDCONFIG_PROTECTION_PERIOD;
-	config->cf_min_clean_segments = NILFS_CLDCONFIG_MIN_CLEAN_SEGMENTS;
-	config->cf_max_clean_segments = NILFS_CLDCONFIG_MAX_CLEAN_SEGMENTS;
+
+	param.num = NILFS_CLDCONFIG_MIN_CLEAN_SEGMENTS;
+	param.unit = NILFS_CLDCONFIG_MIN_CLEAN_SEGMENTS_UNIT;
+	config->cf_min_clean_segments =
+		nilfs_convert_size_to_nsegments(nilfs, &param);
+
+	param.num = NILFS_CLDCONFIG_MAX_CLEAN_SEGMENTS;
+	param.unit = NILFS_CLDCONFIG_MAX_CLEAN_SEGMENTS_UNIT;
+	config->cf_max_clean_segments =
+		nilfs_convert_size_to_nsegments(nilfs, &param);
+
 	config->cf_clean_check_interval = NILFS_CLDCONFIG_CLEAN_CHECK_INTERVAL;
 	config->cf_nsegments_per_clean = NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN;
 	config->cf_mc_nsegments_per_clean = NILFS_CLDCONFIG_MC_NSEGMENTS_PER_CLEAN;
@@ -671,7 +683,7 @@ static int nilfs_cldconfig_do_read(struct nilfs_cldconfig *config,
 int nilfs_cldconfig_read(struct nilfs_cldconfig *config, const char *path,
 			 struct nilfs *nilfs)
 {
-	nilfs_cldconfig_set_default(config);
+	nilfs_cldconfig_set_default(config, nilfs);
 	if (nilfs_cldconfig_do_read(config, path, nilfs) < 0)
 		syslog(LOG_WARNING, "%s: cannot read", path);
 	return 0;
diff --git a/sbin/cleanerd/cldconfig.h b/sbin/cleanerd/cldconfig.h
index 6985594..aec6aaa 100644
--- a/sbin/cleanerd/cldconfig.h
+++ b/sbin/cleanerd/cldconfig.h
@@ -103,9 +103,11 @@ struct nilfs_cldconfig {
 			nilfs_cldconfig_selection_policy_timestamp
 #define NILFS_CLDCONFIG_SELECTION_POLICY_THRESHOLD	0
 #define NILFS_CLDCONFIG_PROTECTION_PERIOD		3600
-#define	NILFS_CLDCONFIG_MIN_CLEAN_SEGMENTS		100
-#define	NILFS_CLDCONFIG_MAX_CLEAN_SEGMENTS		200
-#define	NILFS_CLDCONFIG_CLEAN_CHECK_INTERVAL		60
+#define NILFS_CLDCONFIG_MIN_CLEAN_SEGMENTS		10
+#define NILFS_CLDCONFIG_MIN_CLEAN_SEGMENTS_UNIT		NILFS_SIZE_UNIT_PERCENT
+#define NILFS_CLDCONFIG_MAX_CLEAN_SEGMENTS		20
+#define NILFS_CLDCONFIG_MAX_CLEAN_SEGMENTS_UNIT		NILFS_SIZE_UNIT_PERCENT
+#define NILFS_CLDCONFIG_CLEAN_CHECK_INTERVAL		10
 #define NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN		2
 #define NILFS_CLDCONFIG_MC_NSEGMENTS_PER_CLEAN		4
 #define NILFS_CLDCONFIG_CLEANING_INTERVAL		5
diff --git a/sbin/cleanerd/nilfs_cleanerd.conf b/sbin/cleanerd/nilfs_cleanerd.conf
index 83c941a..151bef0 100644
--- a/sbin/cleanerd/nilfs_cleanerd.conf
+++ b/sbin/cleanerd/nilfs_cleanerd.conf
@@ -14,10 +14,10 @@ protection_period	3600
 # Minium number of clean segments 
 # 0  = normal cleaner behaviour
 # >0 = start cleaning if less segments are available
-min_clean_segments	100
+min_clean_segments	10%
 
 # Maximum number of clean segments
-max_clean_segments	200
+max_clean_segments	20%
 
 # The argument of min_clean_segments and max_clean_segments can be
 # followed by a percent sign (%) or one of the following
@@ -28,7 +28,7 @@ max_clean_segments	200
 # ratio.
 
 # Clean segment check interval in seconds
-clean_check_interval	60
+clean_check_interval	10
 
 # Segment selection policy.
 # In NILFS version 2.0.0, only the timestamp policy is supported.
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
