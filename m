From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 1/4] nilfs-utils: cldconfig add an option to set minimal free blocks
Date: Sun, 19 Jan 2014 15:01:39 +0100
Message-ID: <685e5c720189d1e451ed8a0d65581aa8c5a3f7f0.1390139797.git.andreas.rohner@gmx.net>
References: <cover.1390139797.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1390139797.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1390139797.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1390139797.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

With this option the user can specify the minimal number of free/dead
blocks, which is a threshold for the GC. If there are less free blocks
to gain from cleaning a segment than the specified number, the GC will
abort and try again with a different segment.

By setting it to 0 this feature is effectively disabled.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 sbin/cleanerd/cldconfig.c | 20 ++++++++++++++++++++
 sbin/cleanerd/cldconfig.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/sbin/cleanerd/cldconfig.c b/sbin/cleanerd/cldconfig.c
index 270d360..9a55914 100644
--- a/sbin/cleanerd/cldconfig.c
+++ b/sbin/cleanerd/cldconfig.c
@@ -456,6 +456,20 @@ nilfs_cldconfig_handle_mc_nsegments_per_clean(struct nilfs_cldconfig *config,
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
+	config->cf_min_free_blocks_for_cleaning = n;
+	return 0;
+}
+
+static int
 nilfs_cldconfig_handle_cleaning_interval(struct nilfs_cldconfig *config,
 					 char **tokens, size_t ntoks,
 					 struct nilfs *nilfs)
@@ -576,6 +590,10 @@ nilfs_cldconfig_keyword_table[] = {
 		"log_priority", 2, 2,
 		nilfs_cldconfig_handle_log_priority
 	},
+	{
+		"min_free_blocks_for_cleaning", 2, 2,
+		nilfs_cldconfig_handle_min_free_blocks
+	},
 };
 
 #define NILFS_CLDCONFIG_NKEYWORDS			\
@@ -641,6 +659,8 @@ static void nilfs_cldconfig_set_default(struct nilfs_cldconfig *config,
 	config->cf_retry_interval.tv_usec = 0;
 	config->cf_use_mmap = NILFS_CLDCONFIG_USE_MMAP;
 	config->cf_log_priority = NILFS_CLDCONFIG_LOG_PRIORITY;
+	config->cf_min_free_blocks_for_cleaning =
+		NILFS_CLDCONFIG_MIN_FREE_BLOCKS_FOR_CLEANING;
 }
 
 static inline int iseol(int c)
diff --git a/sbin/cleanerd/cldconfig.h b/sbin/cleanerd/cldconfig.h
index 188ce9b..71a0642 100644
--- a/sbin/cleanerd/cldconfig.h
+++ b/sbin/cleanerd/cldconfig.h
@@ -102,6 +102,7 @@ struct nilfs_cldconfig {
 	struct timeval cf_retry_interval;
 	int cf_use_mmap;
 	int cf_log_priority;
+	unsigned long cf_min_free_blocks_for_cleaning;
 };
 
 #define NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE	\
@@ -120,6 +121,7 @@ struct nilfs_cldconfig {
 #define NILFS_CLDCONFIG_RETRY_INTERVAL			60
 #define NILFS_CLDCONFIG_USE_MMAP			1
 #define NILFS_CLDCONFIG_LOG_PRIORITY			LOG_INFO
+#define NILFS_CLDCONFIG_MIN_FREE_BLOCKS_FOR_CLEANING		128
 
 #define NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX	32
 
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
