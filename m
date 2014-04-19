From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/4] nilfs-utils: fix typos in source files
Date: Sun, 20 Apr 2014 00:14:15 +0900
Message-ID: <1397920455-373-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1397920455-373-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397920455-373-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix typos in source files of mkfs.nilfs2, nilfs_cleanerd,
mount.nilfs2, nilfs-clean, include/nilfs.h, and lib/gc.c.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 include/nilfs.h                | 4 ++--
 lib/gc.c                       | 2 +-
 sbin/cleanerd/cleanerd.c       | 8 ++++----
 sbin/mkfs/bitops.c             | 2 +-
 sbin/mkfs/mkfs.c               | 4 ++--
 sbin/mount/mount_opts.h        | 2 +-
 sbin/nilfs-clean/nilfs-clean.c | 2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index fab8ff2..f695f48 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -191,7 +191,7 @@ struct nilfs_psegment {
  * struct nilfs_file - file iterator
  * @f_finfo: file information
  * @f_blocknr: block number
- * @f_offset: byte offset from the begining of segment
+ * @f_offset: byte offset from the beginning of segment
  * @f_index: index
  * @f_psegment: partial segment
  */
@@ -208,7 +208,7 @@ struct nilfs_file {
  * struct nilfs_block - block iterator
  * @b_binfo: block information
  * @b_blocknr: block number
- * @b_offset: byte offset from the begining of segment
+ * @b_offset: byte offset from the beginning of segment
  * @b_index: index
  * @b_dsize: size of data block information
  * @b_nsize: size of node block information
diff --git a/lib/gc.c b/lib/gc.c
index bb644c4..54d0b66 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -480,7 +480,7 @@ static int nilfs_toss_vdescs(struct nilfs *nilfs,
 				break;
 
 			/*
-			 * Add the virtual block number to the canditate
+			 * Add the virtual block number to the candidate
 			 * for deletion.
 			 */
 			vblocknrp = nilfs_vector_get_new_element(vblocknrv);
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 17de87b..d37bd5c 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -125,7 +125,7 @@ static const struct option long_option[] = {
  * @fallback: fallback state
  * @retry_cleaning: retrying reclamation for protected segments
  * @no_timeout: the next timeout will be 0 seconds
- * @ncleansegs: number of semgents cleaned per cycle
+ * @ncleansegs: number of segments cleaned per cycle
  * @cleaning_interval: cleaning interval
  * @target: target time for sleeping
  * @timeout: timeout value for sleeping
@@ -138,9 +138,9 @@ static const struct option long_option[] = {
  * @pending_cmd: pending client command
  * @jobid: current job id
  * @mm_prev_state: previous status during suspending
- * @mm_nrestpasses: remaiing number of passes
+ * @mm_nrestpasses: remaining number of passes
  * @mm_nrestsegs: remaining number of segment (1-pass)
- * @mm_ncleansegs: number of segmetns cleaned per cycle (manual mode)
+ * @mm_ncleansegs: number of segments cleaned per cycle (manual mode)
  * @mm_protection_period: protection period (manual mode)
  * @mm_cleaning_interval: cleaning interval (manual mode)
  * @mm_min_reclaimable_blocks: min. number of reclaimable blocks (manual mode)
@@ -190,7 +190,7 @@ static volatile unsigned long protection_period;
 
 /* global variables */
 static struct nilfs_cleanerd *nilfs_cleanerd;
-static sigjmp_buf nilfs_cleanerd_env; /* for siglongjume */
+static sigjmp_buf nilfs_cleanerd_env; /* for siglongjmp */
 static volatile sig_atomic_t nilfs_cleanerd_reload_config; /* reload flag */
 static char nilfs_cleanerd_msgbuf[NILFS_CLEANER_MSG_MAX_REQSZ];
 
diff --git a/sbin/mkfs/bitops.c b/sbin/mkfs/bitops.c
index 6262884..a649def 100644
--- a/sbin/mkfs/bitops.c
+++ b/sbin/mkfs/bitops.c
@@ -9,7 +9,7 @@
 /*
  * For the benefit of those who are trying to port Linux to another
  * architecture, here are some C-language equivalents.  You should
- * recode these in the native assmebly language, if at all possible.
+ * recode these in the native assembly language, if at all possible.
  *
  * C language equivalents written by Theodore Ts'o, 9/26/92.
  * Modified by Pete A. Zaitcev 7/14/95 to be portable to big endian
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index c122375..c7e18c6 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -137,7 +137,7 @@ static void parse_options(int argc, char *argv[]);
  *           ^
  *           sb->s_first_data_block
  *
- * Intial layout of ifile and DAT file:
+ * Initial layout of ifile and DAT file:
  *
  * blk +0                  +1       +2
  *  +------------------+--------+---------+
@@ -1388,7 +1388,7 @@ static inline void
 alloc_blockgrouped_file_entry(blocknr_t blocknr, unsigned long nr)
 {
 	struct nilfs_palloc_group_desc *desc = map_disk_buffer(blocknr, 1);
-					/* allways use the first group */
+					/* always use the first group */
 	void *bitmap = map_disk_buffer(blocknr + 1, 1);
 
 	if (nilfs_test_bit(nr, bitmap))
diff --git a/sbin/mount/mount_opts.h b/sbin/mount/mount_opts.h
index cce3856..00e6958 100644
--- a/sbin/mount/mount_opts.h
+++ b/sbin/mount/mount_opts.h
@@ -59,7 +59,7 @@ char *replace_optval(char *s, const char *fmt, void *varp, ...);
  * @fmt.  If replacement or removal occurs, old @str is automatically
  * freed.
  *
- * Return Value: new options string is retured.
+ * Return Value: new options string is returned.
  */
 #define replace_drop_opt(str, fmt, oldvalp, newval, cond)	\
 ({								\
diff --git a/sbin/nilfs-clean/nilfs-clean.c b/sbin/nilfs-clean/nilfs-clean.c
index e1446bd..1f4c8f0 100644
--- a/sbin/nilfs-clean/nilfs-clean.c
+++ b/sbin/nilfs-clean/nilfs-clean.c
@@ -1,5 +1,5 @@
 /*
- * nilfs-clean.c - run garbage colletor for nilfs2 volume
+ * nilfs-clean.c - run garbage collector for nilfs2 volume
  *
  * Licensed under GPLv2: the complete text of the GNU General Public License
  * can be found in COPYING file of the nilfs-utils package.
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
