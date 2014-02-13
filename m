From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 01/10] nilfs-utils: fix order of storage class specifiers
Date: Fri, 14 Feb 2014 03:24:01 +0900
Message-ID: <1392315850-29149-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1392315850-29149-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392315850-29149-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix the following checkpatch warnings:

 WARNING: storage class should be at the beginning of the declaration
 #54: FILE: dumpseg.c:54:
 +const static struct option long_option[] = {

 WARNING: storage class should be at the beginning of the declaration
 #57: FILE: lscp.c:57:
 +const static struct option long_option[] = {

 WARNING: storage class should be at the beginning of the declaration
 #61: FILE: lssu.c:61:
 +const static struct option long_option[] = {

 WARNING: storage class should be at the beginning of the declaration
 #100: FILE: lssu.c:100:
 +const static struct lssu_format lssu_format[] = {

 WARNING: storage class should be at the beginning of the declaration
 #53: FILE: mkcp.c:53:
 +const static struct option long_option[] = {

 WARNING: storage class should be at the beginning of the declaration
 #57: FILE: rmcp.c:57:
 +const static struct option long_options[] = {

 WARNING: storage class should be at the beginning of the declaration
 #85: FILE: nilfs-tune/nilfs-tune.c:85:
 +const static __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {

 WARNING: storage class should be at the beginning of the declaration
 #94: FILE: nilfs-tune/nilfs-tune.c:94:
 +const static __u64 clear_ok_features[NILFS_MAX_FEATURE_TYPES] = {

 WARNING: storage class should be at the beginning of the declaration
 #96: FILE: cleanerd/cleanerd.c:96:
 +const static struct option long_option[] = {

 WARNING: storage class should be at the beginning of the declaration
 #1060: FILE: mkfs/mkfs.c:1060:
 +const static __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {

 WARNING: storage class should be at the beginning of the declaration
 #70: FILE: nilfs-clean/nilfs-clean.c:70:
 +const static struct option long_option[] = {

 WARNING: storage class should be at the beginning of the declaration
 #72: FILE: nilfs-resize/nilfs-resize.c:72:
 +const static struct option long_option[] = {

 WARNING: storage class should be at the beginning of the declaration
 #144: FILE: nilfs-resize/nilfs-resize.c:144:
 +const static char *pm_label;

 WARNING: storage class should be at the beginning of the declaration
 #707: FILE: nilfs-resize/nilfs-resize.c:707:
 +       const static struct timespec retry_interval = { 0, 500000000 };

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/chcp.c                       |    2 +-
 bin/dumpseg.c                    |    2 +-
 bin/lscp.c                       |    2 +-
 bin/lssu.c                       |    4 ++--
 bin/mkcp.c                       |    2 +-
 bin/rmcp.c                       |    2 +-
 sbin/cleanerd/cleanerd.c         |    2 +-
 sbin/mkfs/mkfs.c                 |    2 +-
 sbin/nilfs-clean/nilfs-clean.c   |    2 +-
 sbin/nilfs-resize/nilfs-resize.c |    6 +++---
 sbin/nilfs-tune/nilfs-tune.c     |    4 ++--
 11 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/bin/chcp.c b/bin/chcp.c
index e1d31fd..837cf01 100644
--- a/bin/chcp.c
+++ b/bin/chcp.c
@@ -58,7 +58,7 @@
 
 #ifdef _GNU_SOURCE
 #include <getopt.h>
-const static struct option long_option[] = {
+static const struct option long_option[] = {
 	{"help", no_argument, NULL, 'h'},
 	{"version", no_argument, NULL, 'V'},
 	{NULL, 0, NULL, 0}
diff --git a/bin/dumpseg.c b/bin/dumpseg.c
index abb1e7f..24a3624 100644
--- a/bin/dumpseg.c
+++ b/bin/dumpseg.c
@@ -51,7 +51,7 @@
 
 #ifdef _GNU_SOURCE
 #include <getopt.h>
-const static struct option long_option[] = {
+static const struct option long_option[] = {
 	{"help", no_argument, NULL, 'h'},
 	{"version", no_argument, NULL, 'V'},
 	{NULL, 0, NULL, 0}
diff --git a/bin/lscp.c b/bin/lscp.c
index 7c51e70..c0a1b99 100644
--- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -54,7 +54,7 @@
 
 #ifdef _GNU_SOURCE
 #include <getopt.h>
-const static struct option long_option[] = {
+static const struct option long_option[] = {
 	{"all", no_argument, NULL, 'a'},
 	{"show-block-count", no_argument, NULL, 'b'},
 	{"show-increment", no_argument, NULL, 'g'},
diff --git a/bin/lssu.c b/bin/lssu.c
index e0cbd8d..add7252 100644
--- a/bin/lssu.c
+++ b/bin/lssu.c
@@ -58,7 +58,7 @@
 
 #ifdef _GNU_SOURCE
 #include <getopt.h>
-const static struct option long_option[] = {
+static const struct option long_option[] = {
 	{"all",  no_argument, NULL, 'a'},
 	{"index", required_argument, NULL, 'i'},
 	{"latest-usage", no_argument, NULL, 'l' },
@@ -97,7 +97,7 @@ struct lssu_format {
 	char *body;
 };
 
-const static struct lssu_format lssu_format[] = {
+static const struct lssu_format lssu_format[] = {
 	{
 		"              SEGNUM        DATE     TIME STAT     NBLOCKS\n",
 		"%20llu  %s  %c%c%c  %10u\n"
diff --git a/bin/mkcp.c b/bin/mkcp.c
index a614784..57cf0c8 100644
--- a/bin/mkcp.c
+++ b/bin/mkcp.c
@@ -50,7 +50,7 @@
 #ifdef _GNU_SOURCE
 #include <getopt.h>
 
-const static struct option long_option[] = {
+static const struct option long_option[] = {
 	{"snapshot", no_argument, NULL, 's'},
 	{"print", no_argument, NULL, 'p'},
 	{"help", no_argument, NULL, 'h'},
diff --git a/bin/rmcp.c b/bin/rmcp.c
index af9eeb0..a12faa1 100644
--- a/bin/rmcp.c
+++ b/bin/rmcp.c
@@ -54,7 +54,7 @@
 
 #ifdef _GNU_SOURCE
 #include <getopt.h>
-const static struct option long_options[] = {
+static const struct option long_options[] = {
 	{"force", no_argument, NULL, 'f'},
 	{"interactive", no_argument, NULL, 'i'},
 	{"help", no_argument, NULL, 'h'},
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 6a0291c..f3f2acd 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -93,7 +93,7 @@
 
 #ifdef _GNU_SOURCE
 #include <getopt.h>
-const static struct option long_option[] = {
+static const struct option long_option[] = {
 	{"conffile", required_argument, NULL, 'c'},
 	{"help", no_argument, NULL, 'h'},
 	/* nofork option is obsolete. It does nothing even if passed */
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index dd2652f..bed7818 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -1057,7 +1057,7 @@ static inline void check_ctime(time_t ctime)
 	}
 }
 
-const static __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
+static const __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
 	0,
 	/* Read-only compat */
diff --git a/sbin/nilfs-clean/nilfs-clean.c b/sbin/nilfs-clean/nilfs-clean.c
index 4a92abf..de44c11 100644
--- a/sbin/nilfs-clean/nilfs-clean.c
+++ b/sbin/nilfs-clean/nilfs-clean.c
@@ -67,7 +67,7 @@
 
 #ifdef _GNU_SOURCE
 #include <getopt.h>
-const static struct option long_option[] = {
+static const struct option long_option[] = {
 	{"break", no_argument, NULL, 'b'},
 	{"reload", optional_argument, NULL, 'c'},
 	{"help", no_argument, NULL, 'h'},
diff --git a/sbin/nilfs-resize/nilfs-resize.c b/sbin/nilfs-resize/nilfs-resize.c
index 116b47f..a228c29 100644
--- a/sbin/nilfs-resize/nilfs-resize.c
+++ b/sbin/nilfs-resize/nilfs-resize.c
@@ -69,7 +69,7 @@ extern int check_mount(const char *device);
 
 #ifdef _GNU_SOURCE
 #include <getopt.h>
-const static struct option long_option[] = {
+static const struct option long_option[] = {
 	{"help", no_argument, NULL, 'h'},
 	{"verbose", no_argument, NULL, 'v'},
 	{"yes", no_argument, NULL, 'y'},
@@ -141,7 +141,7 @@ static __u64 pm_max;
 static __u64 pm_done;
 static int pm_curpos;
 static int pm_in_progress = 0;  /* 0: off, 1: on, -1: interrupted */
-const static char *pm_label;
+static const char *pm_label;
 
 static void nilfs_resize_logger(int priority, const char *fmt, ...)
 {
@@ -704,7 +704,7 @@ static int nilfs_resize_move_out_active_segments(struct nilfs *nilfs,
 						 unsigned long long start,
 						 unsigned long long end)
 {
-	const static struct timespec retry_interval = { 0, 500000000 };
+	static const struct timespec retry_interval = { 0, 500000000 };
 							/* 500 msec */
 	ssize_t nfound;
 	int retrycnt = 0;
diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.c
index 0698649..e651d2c 100644
--- a/sbin/nilfs-tune/nilfs-tune.c
+++ b/sbin/nilfs-tune/nilfs-tune.c
@@ -82,7 +82,7 @@ static void nilfs_tune_usage(void)
 	       "                  [-U UUID] device\n");
 }
 
-const static __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
+static const __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
 	0,
 	/* Read-only compat */
@@ -91,7 +91,7 @@ const static __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	0
 };
 
-const static __u64 clear_ok_features[NILFS_MAX_FEATURE_TYPES] = {
+static const __u64 clear_ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
 	0,
 	/* Read-only compat */
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
