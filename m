From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 05/10] nilfs-utils: do not initialize static or global variables to 0 or NULL
Date: Fri, 14 Feb 2014 03:24:05 +0900
Message-ID: <1392315850-29149-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Fix the following checkpatch errors:

 ERROR: do not initialise statics to 0 or NULL
 #92: FILE: lscp.c:92:
 +static int show_all = 0;

 ERROR: do not initialise statics to 0 or NULL
 #82: FILE: rmcp.c:82:
 +static int force = 0;

 ERROR: do not initialise statics to 0 or NULL
 #83: FILE: rmcp.c:83:
 +static int interactive = 0;

 ERROR: do not initialise statics to 0 or NULL
 #108: FILE: mkfs/mkfs.c:108:
 +static int quiet = 0;

 ERROR: do not initialise statics to 0 or NULL
 #109: FILE: mkfs/mkfs.c:109:
 +static int cflag = 0;

 ERROR: do not initialise statics to 0 or NULL
 #110: FILE: mkfs/mkfs.c:110:
 +static int nflag = 0;

 ERROR: do not initialise statics to 0 or NULL
 #111: FILE: mkfs/mkfs.c:111:
 +static int verbose = 0;

 ERROR: do not initialise statics to 0 or NULL
 #113: FILE: mkfs/mkfs.c:113:
 +static int force_overwrite = 0;

 ERROR: do not initialise statics to 0 or NULL
 #118: FILE: mkfs/mkfs.c:118:
 +static time_t creation_time = 0;

 ERROR: do not initialise statics to 0 or NULL
 #236: FILE: mkfs/mkfs.c:236:
 +static void **disk_buffer = NULL;

 ERROR: do not initialise statics to 0 or NULL
 #54: FILE: mount/fstab.c:54:
 +static int have_mtab_info = 0;

 ERROR: do not initialise statics to 0 or NULL
 #55: FILE: mount/fstab.c:55:
 +static int var_mtab_does_not_exist = 0;

 ERROR: do not initialise statics to 0 or NULL
 #56: FILE: mount/fstab.c:56:
 +static int var_mtab_is_a_symlink = 0;

 ERROR: do not initialise statics to 0 or NULL
 #108: FILE: mount/fstab.c:108:
 +static int got_mtab = 0;

 ERROR: do not initialise statics to 0 or NULL
 #109: FILE: mount/fstab.c:109:
 +static int got_fstab = 0;

 ERROR: do not initialise statics to 0 or NULL
 #327: FILE: mount/fstab.c:327:
 +static int we_created_lockfile = 0;

 ERROR: do not initialise statics to 0 or NULL
 #331: FILE: mount/fstab.c:331:
 +static int signals_have_been_setup = 0;

 ERROR: do not initialise globals to 0 or NULL
 #97: FILE: mount/mount.nilfs2.c:97:
 +int verbose = 0;

 ERROR: do not initialise globals to 0 or NULL
 #98: FILE: mount/mount.nilfs2.c:98:
 +int mount_quiet = 0;

 ERROR: do not initialise globals to 0 or NULL
 #99: FILE: mount/mount.nilfs2.c:99:
 +int readonly = 0;

 ERROR: do not initialise globals to 0 or NULL
 #100: FILE: mount/mount.nilfs2.c:100:
 +int readwrite = 0;

 ERROR: do not initialise statics to 0 or NULL
 #101: FILE: mount/mount.nilfs2.c:101:
 +static int nomtab = 0;

 ERROR: do not initialise statics to 0 or NULL
 #102: FILE: mount/mount.nilfs2.c:102:
 +static int devro = 0;

 ERROR: do not initialise statics to 0 or NULL
 #103: FILE: mount/mount.nilfs2.c:103:
 +static int fake = 0;

 ERROR: do not initialise globals to 0 or NULL
 #90: FILE: mount/mount_libmount.c:90:
 +int mount_quiet = 0;   /* for sundries.c */

 ERROR: do not initialise statics to 0 or NULL
 #91: FILE: mount/mount_libmount.c:91:
 +static int verbose = 0;

 ERROR: do not initialise statics to 0 or NULL
 #92: FILE: mount/mount_libmount.c:92:
 +static int devro = 0;

 ERROR: do not initialise statics to 0 or NULL
 #94: FILE: mount/mount_libmount.c:94:
 +static char *mount_fstype = NULL;

 ERROR: do not initialise globals to 0 or NULL
 #98: FILE: mount/umount.nilfs2.c:98:
 +int verbose = 0;

 ERROR: do not initialise globals to 0 or NULL
 #99: FILE: mount/umount.nilfs2.c:99:
 +int mount_quiet = 0;

 ERROR: do not initialise globals to 0 or NULL
 #100: FILE: mount/umount.nilfs2.c:100:
 +int readonly = 0;

 ERROR: do not initialise globals to 0 or NULL
 #101: FILE: mount/umount.nilfs2.c:101:
 +int readwrite = 0;

 ERROR: do not initialise statics to 0 or NULL
 #102: FILE: mount/umount.nilfs2.c:102:
 +static int nomtab = 0;

 ERROR: do not initialise globals to 0 or NULL
 #82: FILE: mount/umount_libmount.c:82:
 +int mount_quiet = 0;   /* for sundries.c */

 ERROR: do not initialise statics to 0 or NULL
 #83: FILE: mount/umount_libmount.c:83:
 +static int verbose = 0;

 ERROR: do not initialise statics to 0 or NULL
 #84: FILE: mount/umount_libmount.c:84:
 +static int force = 0;

 ERROR: do not initialise statics to 0 or NULL
 #85: FILE: mount/umount_libmount.c:85:
 +static int suid = 0;   /* reserved for non-root user mount/umount

 ERROR: do not initialise statics to 0 or NULL
 #125: FILE: nilfs-clean/nilfs-clean.c:125:
 +static int show_version_only = 0;

 ERROR: do not initialise statics to 0 or NULL
 #126: FILE: nilfs-clean/nilfs-clean.c:126:
 +static int verbose = 0;

 ERROR: do not initialise statics to 0 or NULL
 #128: FILE: nilfs-clean/nilfs-clean.c:128:
 +static const char *conffile = NULL;

 ERROR: do not initialise statics to 0 or NULL
 #105: FILE: nilfs-resize/nilfs-resize.c:105:
 +static int show_version_only = 0;

 ERROR: do not initialise statics to 0 or NULL
 #106: FILE: nilfs-resize/nilfs-resize.c:106:
 +static int verbose = 0;

 ERROR: do not initialise statics to 0 or NULL
 #107: FILE: nilfs-resize/nilfs-resize.c:107:
 +static int assume_yes = 0;

 ERROR: do not initialise statics to 0 or NULL
 #143: FILE: nilfs-resize/nilfs-resize.c:143:
 +static int pm_in_progress = 0;  /* 0: off, 1: on, -1: interrupted */

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lscp.c                       |    2 +-
 bin/rmcp.c                       |    4 ++--
 sbin/mkfs/mkfs.c                 |   16 ++++++++--------
 sbin/mount/fstab.c               |   14 +++++++-------
 sbin/mount/mount.nilfs2.c        |   14 +++++++-------
 sbin/mount/mount_libmount.c      |    8 ++++----
 sbin/mount/umount.nilfs2.c       |   10 +++++-----
 sbin/mount/umount_libmount.c     |    8 ++++----
 sbin/nilfs-clean/nilfs-clean.c   |    6 +++---
 sbin/nilfs-resize/nilfs-resize.c |    8 ++++----
 10 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/bin/lscp.c b/bin/lscp.c
index 6ddd003..52447e5 100644
--- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -89,7 +89,7 @@ static __u64 param_index;
 static __u64 param_lines;
 static struct nilfs_cpinfo cpinfos[LSCP_NCPINFO];
 static int show_block_count = 1;
-static int show_all = 0;
+static int show_all;
 
 static void lscp_print_header(void)
 {
diff --git a/bin/rmcp.c b/bin/rmcp.c
index a12faa1..92d672f 100644
--- a/bin/rmcp.c
+++ b/bin/rmcp.c
@@ -79,8 +79,8 @@ static const struct option long_options[] = {
 
 static char *progname;
 
-static int force = 0;
-static int interactive = 0;
+static int force;
+static int interactive;
 
 static int rmcp_confirm(const char *arg)
 {
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index f4be411..9f03c07 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -105,18 +105,18 @@ extern int optind;
 char *progname = "mkfs.nilfs2";
 
 /* Options */
-static int quiet = 0;
-static int cflag = 0;
-static int nflag = 0;
-static int verbose = 0;
+static int quiet;
+static int cflag;
+static int nflag;
+static int verbose;
 static int discard = 1;
-static int force_overwrite = 0;
+static int force_overwrite;
 static unsigned long blocksize = NILFS_DEF_BLOCKSIZE;
 static unsigned long blocks_per_segment = NILFS_DEF_BLKS_PER_SEG;
 static unsigned long r_segments_percentage = NILFS_DEF_RESERVED_SEGMENTS;
 
-static time_t creation_time = 0;
-static char volume_label[80] = {0};
+static time_t creation_time;
+static char volume_label[80];
 static __u64 compat_array[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
 	0,
@@ -233,7 +233,7 @@ segment_start_blocknr(struct nilfs_disk_info *di, unsigned long segnum)
 /*
  * I/O primitives
  */
-static void **disk_buffer = NULL;
+static void **disk_buffer;
 static unsigned long disk_buffer_size;
 
 static void init_disk_buffer(long max_blocks);
diff --git a/sbin/mount/fstab.c b/sbin/mount/fstab.c
index 194f000..e8d88c0 100644
--- a/sbin/mount/fstab.c
+++ b/sbin/mount/fstab.c
@@ -51,9 +51,9 @@
 extern int verbose;
 
 /* Information about mtab. ------------------------------------*/
-static int have_mtab_info = 0;
-static int var_mtab_does_not_exist = 0;
-static int var_mtab_is_a_symlink = 0;
+static int have_mtab_info;
+static int var_mtab_does_not_exist;
+static int var_mtab_is_a_symlink;
 
 static void
 get_mtab_info(void) {
@@ -105,8 +105,8 @@ mtab_is_writable() {
 /* Contents of mtab and fstab ---------------------------------*/
 
 struct mntentchn mounttable, fstab;
-static int got_mtab = 0;
-static int got_fstab = 0;
+static int got_mtab;
+static int got_fstab;
 
 static void read_mounttable(void), read_fstab(void);
 
@@ -324,11 +324,11 @@ getmntoptfile (const char *file) {
 /* Updating mtab ----------------------------------------------*/
 
 /* Flag for already existing lock file. */
-static int we_created_lockfile = 0;
+static int we_created_lockfile;
 static int lockfile_fd = -1;
 
 /* Flag to indicate that signals have been set up. */
-static int signals_have_been_setup = 0;
+static int signals_have_been_setup;
 
 /* Ensure that the lock is released if we are interrupted.  */
 extern char *strsignal(int sig);	/* not always in <string.h> */
diff --git a/sbin/mount/mount.nilfs2.c b/sbin/mount/mount.nilfs2.c
index 4bc45ad..0588add 100644
--- a/sbin/mount/mount.nilfs2.c
+++ b/sbin/mount/mount.nilfs2.c
@@ -94,13 +94,13 @@
 #include "nls.h"
 
 /* mount options */
-int verbose = 0;
-int mount_quiet = 0;
-int readonly = 0;
-int readwrite = 0;
-static int nomtab = 0;
-static int devro = 0;
-static int fake = 0;
+int verbose;
+int mount_quiet;
+int readonly;
+int readwrite;
+static int nomtab;
+static int devro;
+static int fake;
 
 /* global variables */
 extern char *optarg;
diff --git a/sbin/mount/mount_libmount.c b/sbin/mount/mount_libmount.c
index c7e7e25..c518475 100644
--- a/sbin/mount/mount_libmount.c
+++ b/sbin/mount/mount_libmount.c
@@ -87,11 +87,11 @@
 #endif	/* _GNU_SOURCE */
 
 /* mount options */
-int mount_quiet = 0;	/* for sundries.c */
-static int verbose = 0;
-static int devro = 0;
+int mount_quiet;	/* for sundries.c */
+static int verbose;
+static int devro;
 
-static char *mount_fstype = NULL;
+static char *mount_fstype;
 
 /* global variables */
 const char fstype[] = NILFS2_FS_NAME;
diff --git a/sbin/mount/umount.nilfs2.c b/sbin/mount/umount.nilfs2.c
index 770c9d1..8947ddb 100644
--- a/sbin/mount/umount.nilfs2.c
+++ b/sbin/mount/umount.nilfs2.c
@@ -95,11 +95,11 @@
 #include "nls.h"
 
 
-int verbose = 0;
-int mount_quiet = 0;
-int readonly = 0;
-int readwrite = 0;
-static int nomtab = 0;
+int verbose;
+int mount_quiet;
+int readonly;
+int readwrite;
+static int nomtab;
 
 extern char *optarg;
 extern int optind;
diff --git a/sbin/mount/umount_libmount.c b/sbin/mount/umount_libmount.c
index ca4a917..c5f34d5 100644
--- a/sbin/mount/umount_libmount.c
+++ b/sbin/mount/umount_libmount.c
@@ -79,10 +79,10 @@
 #endif	/* _GNU_SOURCE */
 
 /* options */
-int mount_quiet = 0;	/* for sundries.c */
-static int verbose = 0;
-static int force = 0;
-static int suid = 0;	/* reserved for non-root user mount/umount
+int mount_quiet;	/* for sundries.c */
+static int verbose;
+static int force;
+static int suid;	/* reserved for non-root user mount/umount
 			   (not supported yet) */
 
 /* global variables */
diff --git a/sbin/nilfs-clean/nilfs-clean.c b/sbin/nilfs-clean/nilfs-clean.c
index 0f011bd..e1446bd 100644
--- a/sbin/nilfs-clean/nilfs-clean.c
+++ b/sbin/nilfs-clean/nilfs-clean.c
@@ -122,10 +122,10 @@ enum {
 
 /* options */
 static char *progname;
-static int show_version_only = 0;
-static int verbose = 0;
+static int show_version_only;
+static int verbose;
 static int clean_cmd = NILFS_CLEAN_CMD_RUN;
-static const char *conffile = NULL;
+static const char *conffile;
 
 static unsigned long protection_period = ULONG_MAX;
 static int nsegments_per_clean = 2;
diff --git a/sbin/nilfs-resize/nilfs-resize.c b/sbin/nilfs-resize/nilfs-resize.c
index 0c5aca2..be89f8c 100644
--- a/sbin/nilfs-resize/nilfs-resize.c
+++ b/sbin/nilfs-resize/nilfs-resize.c
@@ -102,9 +102,9 @@ static const struct option long_option[] = {
 
 /* options */
 static char *progname;
-static int show_version_only = 0;
-static int verbose = 0;
-static int assume_yes = 0;
+static int show_version_only;
+static int verbose;
+static int assume_yes;
 static int show_progress = 1;
 
 /* global variables */
@@ -140,7 +140,7 @@ static int pm_labelwidth = 10;
 static __u64 pm_max;
 static __u64 pm_done;
 static int pm_curpos;
-static int pm_in_progress = 0;  /* 0: off, 1: on, -1: interrupted */
+static int pm_in_progress;	/* 0: off, 1: on, -1: interrupted */
 static const char *pm_label;
 
 static void nilfs_resize_logger(int priority, const char *fmt, ...)
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
