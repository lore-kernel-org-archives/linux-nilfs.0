From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/3] nilfs-clean: do not override min_reclaimable_blocks if -m option is not used
Date: Tue, 19 Aug 2014 08:52:14 +0900
Message-ID: <1408405936-6130-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1408405936-6130-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=XRQmA1XpM6xa44R7Sgb2r64LGSrv7UAeqD11jkPRpWs=;
        b=Y2co0dOr6jphV7ENuonaSpEdx+3RF16Iu60rYPMpzYANSarZDY8BETGTbBm1P5MhGD
         57V0bnNQO40QGJKm/PHh17oZzHafGEMYXqu4R+KllrP8vNtJJA4S9W+iElrQ7XTfepex
         Y3bztBuU0WFULrjBM96uwC2ZtiGT0nf2qhPkJ/F4Iu0t3b/BspDpt5JYWVq7VaPNd6Oh
         LNfegxHqcYufUwcLjOA1kc6Rgza28Os70765n2uDfPXUo09AmbtJB6R8YOZP4JLI8quv
         CM033f+Xcw5PM4W8P2hUyePNIYY36Lyh/moxCnIh9/iZfV2wXvRFn+THLwswJ2ymObZT
         8LUw==
In-Reply-To: <1408405936-6130-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>, Ryusuke konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The current implementation of nilfs-clean always overrides
min_reclaimable_blocks parameter and nilfs_cleanerd cannot use that
value defined in /etc/nilfs_cleanerd.conf for manual-mode gc
operation.

This resolves the issue by avoiding to override the
min_reclaimable_blocks parameter when -m option is not specified.

Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 man/nilfs-clean.8              |    1 -
 sbin/nilfs-clean/nilfs-clean.c |   16 +++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/man/nilfs-clean.8 b/man/nilfs-clean.8
index af39b6b..4bca51d 100644
--- a/man/nilfs-clean.8
+++ b/man/nilfs-clean.8
@@ -48,7 +48,6 @@ Specify the minimum number of reclaimable blocks in a segment before
 it can be cleaned. If the argument is followed by a percent sign, it
 represents the ratio of blocks in a segment. This argument will only have
 an effect if the use_set_suinfo flag is set in the configuration file.
-The default value is one percent.
 .TP
 \fB\-p\fR, \fB\-\-protection-period=\fIinterval\fR
 Set protection period for a cleaner run.  The \fIinterval\fR parameter
diff --git a/sbin/nilfs-clean/nilfs-clean.c b/sbin/nilfs-clean/nilfs-clean.c
index 1f4c8f0..62130c4 100644
--- a/sbin/nilfs-clean/nilfs-clean.c
+++ b/sbin/nilfs-clean/nilfs-clean.c
@@ -130,9 +130,8 @@ static const char *conffile;
 static unsigned long protection_period = ULONG_MAX;
 static int nsegments_per_clean = 2;
 static struct timespec cleaning_interval = { 0, 100000000 };   /* 100 msec */
-static unsigned long min_reclaimable_blocks = 1;
-static unsigned char min_reclaimable_blocks_unit =
-		NILFS_CLEANER_ARG_UNIT_PERCENT;
+static unsigned long min_reclaimable_blocks = ULONG_MAX;
+static unsigned char min_reclaimable_blocks_unit = NILFS_CLEANER_ARG_UNIT_NONE;
 
 static sigjmp_buf nilfs_clean_env;
 static struct nilfs_cleaner *nilfs_cleaner;
@@ -173,18 +172,21 @@ static int nilfs_clean_do_run(struct nilfs_cleaner *cleaner)
 	args.nsegments_per_clean = nsegments_per_clean;
 	args.cleaning_interval = cleaning_interval.tv_sec;
 	args.cleaning_interval_nsec = cleaning_interval.tv_nsec;
-	args.min_reclaimable_blocks = min_reclaimable_blocks;
-	args.min_reclaimable_blocks_unit = min_reclaimable_blocks_unit;
 	args.valid = (NILFS_CLEANER_ARG_NPASSES |
 		      NILFS_CLEANER_ARG_CLEANING_INTERVAL |
-		      NILFS_CLEANER_ARG_NSEGMENTS_PER_CLEAN |
-		      NILFS_CLEANER_ARG_MIN_RECLAIMABLE_BLOCKS);
+		      NILFS_CLEANER_ARG_NSEGMENTS_PER_CLEAN);
 
 	if (protection_period != ULONG_MAX) {
 		args.protection_period = protection_period;
 		args.valid |= NILFS_CLEANER_ARG_PROTECTION_PERIOD;
 	}
 
+	if (min_reclaimable_blocks != ULONG_MAX) {
+		args.min_reclaimable_blocks = min_reclaimable_blocks;
+		args.min_reclaimable_blocks_unit = min_reclaimable_blocks_unit;
+		args.valid |= NILFS_CLEANER_ARG_MIN_RECLAIMABLE_BLOCKS;
+	}
+
 	if (nilfs_cleaner_run(cleaner, &args, NULL) < 0) {
 		myprintf(_("Error: cannot run cleaner: %s\n"),
 			 strerror(errno));
-- 
1.7.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
