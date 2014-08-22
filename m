From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs_cleanerd.conf: set min_reclaimable_blocks parameter to 10 percent
Date: Sat, 23 Aug 2014 08:57:58 +0900
Message-ID: <1408751878-25236-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=6EMF3nuZ3HVgSNXdZ5TvxVfhsAl3fHFx065Jod6p4K8=;
        b=TQLUZ532MbU+OqWvVx92HFLIxuK07erz2e2E13xsNlcyC63gjZQyu4+hLI/nC+rFnH
         ZiOLvr/7Ig9fHEWx4c21cTreBh88P0xitc30sVpviGn2bqOtEueA+ER/FiV1vDWIEA00
         EWX+pYpFex+rO8N48TD/3qZSS6TnEvru+Ea2Wt1+7uVXgsbaFycbpAFzHP0gJRJwkSGf
         esqdcJbJ2zDmX5+Gm1TavFNWb4S+i1SPoJX3E6WQWl74Aa6iuqHycEiO2zu6kDOzFDnU
         aM8MgHnq7RImzmr8o5gvos7AbAXkWQLFabrJKDDqpkDi9qgNT/UW+Pt4lFLEyjlvY6JG
         aH6w==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Increase the default value of min_reclaimable_blocks parameter to 10
percent from the original 5 percent for the following reasons:

 1) In real environment, the 10 percent threshold looks better than 5
    percent to reduce relocation of static data.  The ratio of live
    blocks in a lump of static data region is typically about 90-99
    percent according to the result of "lssu -l".

 2) When we set min_reclaimable_blocks to 10 percent, 10 percent of
    disk space (excluding 5 percent reserved capacity) will remain
    unreclaimed at worst.  But, this is acceptable because the default
    value of min_clean_segments is 10 percent and
    mc_min_reclaimable_blocks (1%) is applied while the ratio of free
    space is below 10 percent.

Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 man/nilfs_cleanerd.conf.5         |    2 +-
 sbin/cleanerd/cldconfig.h         |    2 +-
 sbin/cleanerd/nilfs_cleanerd.conf |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/man/nilfs_cleanerd.conf.5 b/man/nilfs_cleanerd.conf.5
index e85fa19..f0366e4 100644
--- a/man/nilfs_cleanerd.conf.5
+++ b/man/nilfs_cleanerd.conf.5
@@ -99,7 +99,7 @@ kB 1000, K 1024, MB 1000*1000, M 1024*1024, GB 1000*1000*1000, G
 a percent sign, it represents the ratio of blocks in a segment.
 .PP
 The default values of \fBmin_reclaimable_blocks\fP and
-\fBmc_min_reclaimable_blocks\fP are 5 percent and 1 percent respectively.
+\fBmc_min_reclaimable_blocks\fP are 10 percent and 1 percent respectively.
 .TP
 .B log_priority
 Gives the verbosity level that is used when logging messages from
diff --git a/sbin/cleanerd/cldconfig.h b/sbin/cleanerd/cldconfig.h
index 0a598d5..2a0af5f 100644
--- a/sbin/cleanerd/cldconfig.h
+++ b/sbin/cleanerd/cldconfig.h
@@ -128,7 +128,7 @@ struct nilfs_cldconfig {
 #define NILFS_CLDCONFIG_USE_MMAP			1
 #define NILFS_CLDCONFIG_USE_SET_SUINFO			0
 #define NILFS_CLDCONFIG_LOG_PRIORITY			LOG_INFO
-#define NILFS_CLDCONFIG_MIN_RECLAIMABLE_BLOCKS		5
+#define NILFS_CLDCONFIG_MIN_RECLAIMABLE_BLOCKS		10
 #define NILFS_CLDCONFIG_MIN_RECLAIMABLE_BLOCKS_UNIT	NILFS_SIZE_UNIT_PERCENT
 #define NILFS_CLDCONFIG_MC_MIN_RECLAIMABLE_BLOCKS	1
 #define NILFS_CLDCONFIG_MC_MIN_RECLAIMABLE_BLOCKS_UNIT	NILFS_SIZE_UNIT_PERCENT
diff --git a/sbin/cleanerd/nilfs_cleanerd.conf b/sbin/cleanerd/nilfs_cleanerd.conf
index 05cd9d4..569cb09 100644
--- a/sbin/cleanerd/nilfs_cleanerd.conf
+++ b/sbin/cleanerd/nilfs_cleanerd.conf
@@ -53,7 +53,7 @@ retry_interval		60
 
 # Specify the minimum number of reclaimable blocks in a segment
 # before it can be cleaned.
-min_reclaimable_blocks	5%
+min_reclaimable_blocks	10%
 
 # Specify the minimum number of reclaimable blocks in a segment
 # before it can be cleaned.
-- 
1.7.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
