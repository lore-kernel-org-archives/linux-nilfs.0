From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] lib/nilfs.c: add missing comments of API functions
Date: Sat, 25 Jan 2014 14:22:59 +0900
Message-ID: <1390627379-11856-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/nilfs.c |  128 ++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 53 deletions(-)

diff --git a/lib/nilfs.c b/lib/nilfs.c
index 7265830..05b9b03 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -223,12 +223,20 @@ static int nilfs_find_fs(struct nilfs *nilfs, const char *dev, const char *dir,
 	return ret;
 }
 
+/**
+ * nilfs_get_block_size - get block size of the file system
+ * @nilfs: nilfs object
+ */
 size_t nilfs_get_block_size(struct nilfs *nilfs)
 {
 	return 1UL << (le32_to_cpu(nilfs->n_sb->s_log_block_size) +
 		       NILFS_SB_BLOCK_SIZE_SHIFT);
 }
 
+/**
+ * nilfs_get_reserved_segments - get number of reserved segments
+ * @nilfs: nilfs object
+ */
 __u64 nilfs_get_reserved_segments(const struct nilfs *nilfs)
 {
 	const struct nilfs_super_block *sb = nilfs->n_sb;
@@ -241,6 +249,10 @@ __u64 nilfs_get_reserved_segments(const struct nilfs *nilfs)
 	return rn;
 }
 
+/**
+ * nilfs_opt_set_mmap - set mmap option
+ * @nilfs: nilfs object
+ */
 int nilfs_opt_set_mmap(struct nilfs *nilfs)
 {
 	long pagesize;
@@ -258,11 +270,19 @@ int nilfs_opt_set_mmap(struct nilfs *nilfs)
 	return 0;
 }
 
+/**
+ * nilfs_opt_clear_mmap - clear mmap option
+ * @nilfs: nilfs object
+ */
 void nilfs_opt_clear_mmap(struct nilfs *nilfs)
 {
 	nilfs->n_opts &= ~NILFS_OPT_MMAP;
 }
 
+/**
+ * nilfs_opt_test_mmap - test whether mmap option is set or not
+ * @nilfs: nilfs object
+ */
 int nilfs_opt_test_mmap(struct nilfs *nilfs)
 {
 	return !!(nilfs->n_opts & NILFS_OPT_MMAP);
@@ -419,8 +439,8 @@ void nilfs_close(struct nilfs *nilfs)
 }
 
 /**
- * nilfs_get_dev -
- * @nilfs:
+ * nilfs_get_dev - get the name of a device that nilfs object is opening
+ * @nilfs: nilfs object
  */
 const char *nilfs_get_dev(const struct nilfs *nilfs)
 {
@@ -428,10 +448,10 @@ const char *nilfs_get_dev(const struct nilfs *nilfs)
 }
 
 /**
- * nilfs_change_cpmode -
- * @nilfs:
- * @cno:
- * @mode:
+ * nilfs_change_cpmode - change mode of a checkpoint
+ * @nilfs: nilfs object
+ * @cno: checkpoint number
+ * @mode: new mode of checkpoint
  */
 int nilfs_change_cpmode(struct nilfs *nilfs, nilfs_cno_t cno, int mode)
 {
@@ -453,12 +473,12 @@ int nilfs_change_cpmode(struct nilfs *nilfs, nilfs_cno_t cno, int mode)
 }
 
 /**
- * nilfs_get_cpinfo -
- * @nilfs:
- * @cno:
- * @mode:
- * @cpinfo:
- * @nci:
+ * nilfs_get_cpinfo - get information of checkpoints
+ * @nilfs: nilfs object
+ * @cno: start checkpoint number
+ * @mode: mode of checkpoints that the caller wants to retrieve
+ * @cpinfo: array of nilfs_cpinfo structs to store information in
+ * @nci: size of @cpinfo array (number of items)
  */
 ssize_t nilfs_get_cpinfo(struct nilfs *nilfs, nilfs_cno_t cno, int mode,
 			 struct nilfs_cpinfo *cpinfo, size_t nci)
@@ -493,9 +513,9 @@ ssize_t nilfs_get_cpinfo(struct nilfs *nilfs, nilfs_cno_t cno, int mode,
 }
 
 /**
- * nilfs_delete_checkpoint -
- * @nilfs:
- * @cno:
+ * nilfs_delete_checkpoint - delete a checkpoint
+ * @nilfs: nilfs object
+ * @cno: checkpoint number to be deleted
  */
 int nilfs_delete_checkpoint(struct nilfs *nilfs, nilfs_cno_t cno)
 {
@@ -507,9 +527,9 @@ int nilfs_delete_checkpoint(struct nilfs *nilfs, nilfs_cno_t cno)
 }
 
 /**
- * nilfs_get_cpstat -
- * @nilfs:
- * @cpstat:
+ * nilfs_get_cpstat - get checkpoint statistics
+ * @nilfs: nilfs object
+ * @cpstat: buffer of a nilfs_cpstat struct to store statistics in
  */
 int nilfs_get_cpstat(const struct nilfs *nilfs, struct nilfs_cpstat *cpstat)
 {
@@ -521,11 +541,11 @@ int nilfs_get_cpstat(const struct nilfs *nilfs, struct nilfs_cpstat *cpstat)
 }
 
 /**
- * nilfs_get_suinfo -
- * @nilfs:
- * @segnum:
- * @si:
- * @nsi:
+ * nilfs_get_suinfo - get information of segment usage
+ * @nilfs: nilfs object
+ * @segnum: start segment number
+ * @si: array of nilfs_suinfo structs to store information in
+ * @nsi: size of @si array (number of items)
  */
 ssize_t nilfs_get_suinfo(const struct nilfs *nilfs, __u64 segnum,
 			 struct nilfs_suinfo *si, size_t nsi)
@@ -548,9 +568,9 @@ ssize_t nilfs_get_suinfo(const struct nilfs *nilfs, __u64 segnum,
 }
 
 /**
- * nilfs_get_sustat -
- * @nilfs:
- * @sustat:
+ * nilfs_get_sustat - get segment usage statistics
+ * @nilfs: nilfs object
+ * @sustat: buffer of a nilfs_sustat struct to store statistics in
  */
 int nilfs_get_sustat(const struct nilfs *nilfs, struct nilfs_sustat *sustat)
 {
@@ -563,10 +583,10 @@ int nilfs_get_sustat(const struct nilfs *nilfs, struct nilfs_sustat *sustat)
 }
 
 /**
- * nilfs_get_vinfo -
- * @nilfs:
- * @vinfo:
- * @nvi:
+ * nilfs_get_vinfo - get information of virtual block addresses
+ * @nilfs: nilfs object
+ * @vinfo: array of nilfs_vinfo structs to store information in
+ * @nvi: size of @vinfo array (number of items)
  */
 ssize_t nilfs_get_vinfo(const struct nilfs *nilfs,
 			struct nilfs_vinfo *vinfo, size_t nvi)
@@ -589,10 +609,10 @@ ssize_t nilfs_get_vinfo(const struct nilfs *nilfs,
 }
 
 /**
- * nilfs_get_bdescs:
- * @nilfs:
- * @bdescs:
- * @nbdescs:
+ * nilfs_get_bdescs - get information of blocks used in DAT file itself
+ * @nilfs: nilfs object
+ * @bdescs: array of nilfs_bdesc structs to store information in
+ * @nbdescs: size of @bdescs array (number of items)
  */
 ssize_t nilfs_get_bdescs(const struct nilfs *nilfs,
 			 struct nilfs_bdesc *bdescs, size_t nbdescs)
@@ -615,18 +635,18 @@ ssize_t nilfs_get_bdescs(const struct nilfs *nilfs,
 }
 
 /**
- * nilfs_clean_segments -
- * @nilfs:
- * @vdescs:
- * @nvdescs:
- * @periods:
- * @nperiods:
- * @vblocknrs:
- * @nvblocknrs:
- * @bdescs:
- * @nbdescs:
- * @segnums:
- * @nsegs:
+ * nilfs_clean_segments - do garbage collection operation
+ * @nilfs: nilfs object
+ * @vdescs: array of nilfs_vdesc structs to specify live blocks
+ * @nvdescs: size of @vdescs array (number of items)
+ * @periods: array of nilfs_period structs to specify checkpoints to be deleted
+ * @nperiods: size of @periods array (number of items)
+ * @vblocknrs: array of virtual block addresses to be freed
+ * @nvblocknrs: size of @vblocknrs array (number of items)
+ * @bdescs: array of nilfs_bdesc structs to specify live DAT blocks
+ * @nbdescs: size of @bdescs array (number of items)
+ * @segnums: array of segment numbers to specify segments to be freed
+ * @nsegs: size of @segnums array (number of items)
  */
 int nilfs_clean_segments(struct nilfs *nilfs,
 			 struct nilfs_vdesc *vdescs, size_t nvdescs,
@@ -662,8 +682,9 @@ int nilfs_clean_segments(struct nilfs *nilfs,
 }
 
 /**
- * nilfs_sync -
- * @nilfs:
+ * nilfs_sync - sync a NILFS file system
+ * @nilfs: nilfs object
+ * @cnop: buffer to store the latest checkpoint number in
  */
 int nilfs_sync(const struct nilfs *nilfs, nilfs_cno_t *cnop)
 {
@@ -720,9 +741,10 @@ int nilfs_set_alloc_range(struct nilfs *nilfs, off_t start, off_t end)
 /* raw */
 
 /**
- * nilfs_get_segment -
- * @nilfs: NILFS object
+ * nilfs_get_segment - read or mmap segment to a memory region
+ * @nilfs: nilfs object
  * @segnum: segment number
+ * @segmentp: buffer to store start address of allocated memory region in
  */
 ssize_t nilfs_get_segment(struct nilfs *nilfs, unsigned long segnum,
 			  void **segmentp)
@@ -774,9 +796,9 @@ ssize_t nilfs_get_segment(struct nilfs *nilfs, unsigned long segnum,
 }
 
 /**
- * nilfs_put_segment -
- * @nilfs: NILFS object
- * @seg: segment
+ * nilfs_put_segment - free memory used for raw segment access
+ * @nilfs: nilfs object
+ * @segment: start address of the memory region to be freed
  */
 int nilfs_put_segment(struct nilfs *nilfs, void *segment)
 {
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
