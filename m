From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs-utils: move utility definitions into util.h
Date: Wed, 12 Feb 2014 01:23:08 +0900
Message-ID: <1392135789-5287-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1392135789-5287-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392135789-5287-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Gather up definitions of utility macros such as min_t(), max_t(),
DIV_ROUND_UP(), ARRAY_SIZE(), nilfs_cnt64_ge(), etc, into
include/util.h to make them reusable.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 include/Makefile.am              |    2 +-
 include/util.h                   |   49 ++++++++++++++++++++++++++++++++++++++
 lib/gc.c                         |    5 ++--
 sbin/cleanerd/cleanerd.c         |   23 +++---------------
 sbin/mkfs/mkfs.c                 |   27 +++++++--------------
 sbin/nilfs-resize/nilfs-resize.c |   21 ++--------------
 6 files changed, 66 insertions(+), 61 deletions(-)
 create mode 100644 include/util.h

diff --git a/include/Makefile.am b/include/Makefile.am
index 2b46bb5..f6b287f 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -3,4 +3,4 @@
 include_HEADERS = nilfs.h nilfs2_fs.h nilfs_cleaner.h
 noinst_HEADERS = realpath.h nls.h parser.h nilfs_feature.h \
 	vector.h nilfs_gc.h cnoconv.h cleaner_msg.h cleaner_exec.h \
-	pathnames.h
+	pathnames.h util.h
diff --git a/include/util.h b/include/util.h
new file mode 100644
index 0000000..a0d1bf2
--- /dev/null
+++ b/include/util.h
@@ -0,0 +1,49 @@
+/*
+ * util.h - utility definitions
+ */
+#ifndef __UTIL_H__
+#define __UTIL_H__
+
+#include <assert.h>
+#include <stdlib.h>
+
+#define BUG_ON(x)	   assert(!(x))
+/* Force a compilation error if the condition is true */
+#define BUILD_BUG_ON(condition) ((void)sizeof(struct { int: -!!(condition); }))
+
+#define typecheck(type, x)					\
+	({							\
+	   type __dummy;					\
+	   typeof(x) __dummy2;					\
+	   (void)(&__dummy == &__dummy2);			\
+	   1;							\
+	})
+
+
+#define DIV_ROUND_UP(n, m)	(((n) + (m) - 1) / (m))
+#define ARRAY_SIZE(arr)		(sizeof(arr) / sizeof((arr)[0]))
+
+
+#define min_t(type, x, y) \
+	({ type __x = (x); type __y = (y); __x < __y ? __x : __y; })
+#define max_t(type, x, y) \
+	({ type __x = (x); type __y = (y); __x > __y ? __x : __y; })
+
+
+#define cnt64_gt(a, b)						\
+	(typecheck(__u64, a) && typecheck(__u64, b) &&		\
+	 ((__s64)(b) - (__s64)(a) < 0))
+#define cnt64_ge(a, b)						\
+	(typecheck(__u64, a) && typecheck(__u64, b) &&		\
+	 ((__s64)(a) - (__s64)(b) >= 0))
+#define cnt64_lt(a, b)		cnt64_gt(b, a)
+#define cnt64_le(a, b)		cnt64_ge(b, a)
+
+
+#define timeval_to_timespec(tv, ts)		\
+do {						\
+	(ts)->tv_sec = (tv)->tv_sec;		\
+	(ts)->tv_nsec = (tv)->tv_usec * 1000;	\
+} while (0)
+
+#endif /* __UTIL_H__ */
diff --git a/lib/gc.c b/lib/gc.c
index 1119fa8..ba90376 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -37,6 +37,7 @@
 #include <assert.h>
 #include <stdarg.h>
 #include <signal.h>
+#include "util.h"
 #include "vector.h"
 #include "nilfs_gc.h"
 
@@ -227,8 +228,6 @@ static ssize_t nilfs_deselect_segment(__u64 *segnums, size_t nsegs, int nr)
 	return nsegs - 1;
 }
 
-#define nilfs_cnt64_ge(a, b)	((__s64)(a) - (__s64)(b) >= 0)
-
 /**
  * nilfs_acc_blocks - collect summary of blocks contained in segments
  * @nilfs: nilfs object
@@ -268,7 +267,7 @@ static ssize_t nilfs_acc_blocks(struct nilfs *nilfs,
 			return -1;
 
 		segseq = nilfs_get_segment_seqnum(nilfs, segment, segnums[i]);
-		if (nilfs_cnt64_ge(segseq, protseq)) {
+		if (cnt64_ge(segseq, protseq)) {
 			n = nilfs_deselect_segment(segnums, n, i);
 			if (nilfs_put_segment(nilfs, segment) < 0)
 				return -1;
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 39cb65c..c20045d 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -74,8 +74,9 @@
 #include <setjmp.h>
 #include <assert.h>
 #include <uuid/uuid.h>
-#include "vector.h"
 #include "nilfs.h"
+#include "util.h"
+#include "vector.h"
 #include "nilfs_gc.h"
 #include "nilfs_cleaner.h"
 #include "cleaner_msg.h"
@@ -89,24 +90,6 @@
 #endif	/* SYSCONFDIR */
 #define NILFS_CLEANERD_CONFFILE	SYSCONFDIR "/nilfs_cleanerd.conf"
 
-#ifndef min_t
-#define min_t(type, x, y) \
-	({ type __x = (x); type __y = (y); __x < __y ? __x : __y; })
-#define max_t(type, x, y) \
-	({ type __x = (x); type __y = (y); __x > __y ? __x : __y; })
-#endif
-
-#define nilfs_cnt64_ge(a, b)	((__s64)(a) - (__s64)(b) >= 0)
-
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
-#endif
-
-#define timeval_to_timespec(tv, ts)		\
-do {						\
-	(ts)->tv_sec = (tv)->tv_sec;		\
-	(ts)->tv_nsec = (tv)->tv_usec * 1000;	\
-} while (0)
 
 #ifdef _GNU_SOURCE
 #include <getopt.h>
@@ -510,7 +493,7 @@ static int nilfs_segment_is_protected(struct nilfs *nilfs, __u64 segnum,
 		return -1;
 
 	segseq = nilfs_get_segment_seqnum(nilfs, segment, segnum);
-	if (nilfs_cnt64_ge(segseq, protseq))
+	if (cnt64_ge(segseq, protseq))
 		ret = 1;
 	nilfs_put_segment(nilfs, segment);
 	return ret;
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index 8eb00bf..dd2652f 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -36,8 +36,6 @@
 #include <stdlib.h>
 #endif	/* HAVE_STDLIB_H */
 
-#include <assert.h>
-
 #if HAVE_UNISTD_H
 #include <unistd.h>
 #endif	/* HAVE_UNISTD_H */
@@ -77,6 +75,7 @@
 #endif	/* HAVE_BLKID_BLKID_H */
 
 #include "nilfs.h"
+#include "util.h"
 #include "nilfs_feature.h"
 #include "mkfs.h"
 #include "pathnames.h"
@@ -84,14 +83,6 @@
 
 typedef __u64  blocknr_t;
 
-#define BUG_ON(x)	   assert(!(x))
-/* Force a compilation error if the condition is true */
-#define BUILD_BUG_ON(condition) ((void)sizeof(struct { int: -!!(condition); }))
-
-#define ROUNDUP_DIV(n, m)	(((n) - 1) / (m) + 1)
-#define max_t(type, x, y) \
-	({ type __x = (x); type __y = (y); __x > __y ? __x : __y; })
-
 extern __u32 crc32_le(__u32 seed, unsigned char const *data, size_t length);
 #define nilfs_crc32(seed, data, length)  crc32_le(seed, data, length)
 
@@ -371,7 +362,7 @@ static unsigned count_blockgrouped_file_blocks(unsigned entry_size,
 	unsigned long entries_per_block = blocksize / entry_size;
 
 	return group_desc_blocks_per_group + bitmap_blocks_per_group +
-		ROUNDUP_DIV(nr_initial_entries, entries_per_block);
+		DIV_ROUND_UP(nr_initial_entries, entries_per_block);
 }
 
 static unsigned count_ifile_blocks(void)
@@ -391,7 +382,7 @@ static unsigned count_sufile_blocks(void)
 {
 	unsigned long sufile_segment_usages_per_block
 		= blocksize / sizeof(struct nilfs_segment_usage);
-	return ROUNDUP_DIV(nr_initial_segments +
+	return DIV_ROUND_UP(nr_initial_segments +
 			   NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET,
 			   sufile_segment_usages_per_block);
 }
@@ -401,7 +392,7 @@ static unsigned count_cpfile_blocks(void)
 	const unsigned nr_initial_checkpoints = 1;
 	unsigned long cpfile_checkpoints_per_block
 		= blocksize / sizeof(struct nilfs_checkpoint);
-	return ROUNDUP_DIV(nr_initial_checkpoints +
+	return DIV_ROUND_UP(nr_initial_checkpoints +
 			   NILFS_CPFILE_FIRST_CHECKPOINT_OFFSET
 			   - 1 /* checkpoint number begins from 1 */,
 			   cpfile_checkpoints_per_block);
@@ -509,7 +500,7 @@ static void init_disk_layout(struct nilfs_disk_info *di, int fd,
 
 	di->blocks_per_segment = blocks_per_segment;
 	segment_size = di->blocks_per_segment * blocksize;
-	first_segblk = ROUNDUP_DIV(NILFS_DISKHDR_SIZE, blocksize);
+	first_segblk = DIV_ROUND_UP(NILFS_DISKHDR_SIZE, blocksize);
 	di->first_segment_block = first_segblk;
 	if (first_segblk + NILFS_PSEG_MIN_BLOCKS > di->blocks_per_segment)
 		too_small_segment(di->blocks_per_segment,
@@ -537,7 +528,7 @@ static struct nilfs_segment_info *new_segment(struct nilfs_disk_info *di)
 	memset(si, 0, sizeof(*si));
 
 	si->sumbytes = sizeof(struct nilfs_segment_summary);
-	si->nblk_sum = ROUNDUP_DIV(si->sumbytes, blocksize);
+	si->nblk_sum = DIV_ROUND_UP(si->sumbytes, blocksize);
 	si->start = di->first_segment_block; /* for segment 0 */
 	return si;
 }
@@ -572,7 +563,7 @@ static void fix_disk_layout(struct nilfs_disk_info *di)
 		if (di->nblocks_to_write < si->start + si->nblocks)
 			di->nblocks_to_write = si->start + si->nblocks;
 	}
-	di->nsegments_to_write = ROUNDUP_DIV(di->nblocks_to_write,
+	di->nsegments_to_write = DIV_ROUND_UP(di->nblocks_to_write,
 					     di->blocks_per_segment);
 }
 
@@ -596,7 +587,7 @@ static void add_file(struct nilfs_segment_info *si, ino_t ino,
 		increment_segsum_size(si, nblocks, dat_flag);
 		if (!dat_flag)
 			si->nvblocknrs += nblocks;
-		si->nblk_sum = ROUNDUP_DIV(si->sumbytes, blocksize);
+		si->nblk_sum = DIV_ROUND_UP(si->sumbytes, blocksize);
 	}
 }
 
@@ -880,7 +871,7 @@ static void *map_disk_buffer(blocknr_t blocknr, int clear_flag)
 
 static void read_disk_header(int fd, const char *device)
 {
-	int i, hdr_blocks = ROUNDUP_DIV(NILFS_SB_OFFSET_BYTES, blocksize);
+	int i, hdr_blocks = DIV_ROUND_UP(NILFS_SB_OFFSET_BYTES, blocksize);
 
 	lseek(fd, 0, SEEK_SET);
 	for (i = 0; i < hdr_blocks; i++) {
diff --git a/sbin/nilfs-resize/nilfs-resize.c b/sbin/nilfs-resize/nilfs-resize.c
index c8b0868..116b47f 100644
--- a/sbin/nilfs-resize/nilfs-resize.c
+++ b/sbin/nilfs-resize/nilfs-resize.c
@@ -60,6 +60,7 @@
 #include <errno.h>
 #include <signal.h>
 #include "nilfs.h"
+#include "util.h"
 #include "vector.h"
 #include "nilfs_gc.h"
 #include "cnoconv.h"
@@ -99,24 +100,6 @@ const static struct option long_option[] = {
 #define FITHAW		_IOWR('X', 120, int)
 #endif
 
-/* general macros */
-#ifndef DIV_ROUND_UP
-#define DIV_ROUND_UP(n, m)	(((n) + (m) - 1) / (m))
-#endif
-
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
-#endif
-
-#ifndef min_t
-#define min_t(type, x, y) \
-	({ type __x = (x); type __y = (y); __x < __y ? __x : __y; })
-#define max_t(type, x, y) \
-	({ type __x = (x); type __y = (y); __x > __y ? __x : __y; })
-#endif
-
-#define nilfs_cnt64_ge(a, b)	((__s64)(a) - (__s64)(b) >= 0)
-
 /* options */
 static char *progname;
 static int show_version_only = 0;
@@ -314,7 +297,7 @@ static int nilfs_resize_segment_is_protected(struct nilfs *nilfs, __u64 segnum)
 		return -1;
 	}
 	segseq = nilfs_get_segment_seqnum(nilfs, segment, segnum);
-	if (nilfs_cnt64_ge(segseq, protseq))
+	if (cnt64_ge(segseq, protseq))
 		ret = 1;
 	nilfs_put_segment(nilfs, segment);
 	return ret;
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
