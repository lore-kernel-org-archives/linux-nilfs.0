From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/6] nilfs2: remove list of freeing segments
Date: Mon, 18 May 2009 00:29:45 +0900
Message-ID: <1242574186-21554-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1242574186-21554-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1242574186-21554-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This will clean up a list of freeing segments and the related
functions from segment.c and ioctl.c, which have hurt code
readability.

This removal is applied by using nilfs_sufile_updatev() previously
introduced in the patch ("nilfs2: add sufile function that can modify
multiple segment usages").

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c   |   26 ----------
 fs/nilfs2/segbuf.c  |    1 -
 fs/nilfs2/seglist.h |    6 --
 fs/nilfs2/segment.c |  130 ++++++++++++++-------------------------------------
 fs/nilfs2/segment.h |   11 ++--
 fs/nilfs2/sufile.h  |   56 +++++++++++++---------
 6 files changed, 74 insertions(+), 156 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 50ff3f2..015debb 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -435,24 +435,6 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 	return nmembs;
 }
 
-static int nilfs_ioctl_free_segments(struct the_nilfs *nilfs,
-				     struct nilfs_argv *argv, void *buf)
-{
-	size_t nmembs = argv->v_nmembs;
-	struct nilfs_sb_info *sbi = nilfs->ns_writer;
-	int ret;
-
-	if (unlikely(!sbi)) {
-		/* never happens because called for a writable mount */
-		WARN_ON(1);
-		return -EROFS;
-	}
-	ret = nilfs_segctor_add_segments_to_be_freed(
-		NILFS_SC(sbi), buf, nmembs);
-
-	return (ret < 0) ? ret : nmembs;
-}
-
 int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 				       struct nilfs_argv *argv, void **kbufs)
 {
@@ -491,14 +473,6 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 		msg = "cannot mark copying blocks dirty";
 		goto failed;
 	}
-	ret = nilfs_ioctl_free_segments(nilfs, &argv[4], kbufs[4]);
-	if (ret < 0) {
-		/*
-		 * can safely abort because this operation is atomic.
-		 */
-		msg = "cannot set segments to be freed";
-		goto failed;
-	}
 	return 0;
 
  failed:
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 1e68821..dc0277a 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -26,7 +26,6 @@
 #include <linux/crc32.h>
 #include "page.h"
 #include "segbuf.h"
-#include "seglist.h"
 
 
 static struct kmem_cache *nilfs_segbuf_cachep;
diff --git a/fs/nilfs2/seglist.h b/fs/nilfs2/seglist.h
index d39df91..e448e40 100644
--- a/fs/nilfs2/seglist.h
+++ b/fs/nilfs2/seglist.h
@@ -32,11 +32,6 @@
 struct nilfs_segment_entry {
 	__u64			segnum;
 
-#define NILFS_SLH_FREED		0x0001	/* The segment was freed provisonally.
-					   It must be cancelled if
-					   construction aborted */
-
-	unsigned		flags;
 	struct list_head	list;
 	struct buffer_head     *bh_su;
 	struct nilfs_segment_usage *raw_su;
@@ -52,7 +47,6 @@ nilfs_alloc_segment_entry(__u64 segnum)
 
 	if (likely(ent)) {
 		ent->segnum = segnum;
-		ent->flags = 0;
 		ent->bh_su = NULL;
 		ent->raw_su = NULL;
 		INIT_LIST_HEAD(&ent->list);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 22c7f65..aa97754 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -39,7 +39,6 @@
 #include "sufile.h"
 #include "cpfile.h"
 #include "ifile.h"
-#include "seglist.h"
 #include "segbuf.h"
 
 
@@ -79,7 +78,8 @@ enum {
 /* State flags of collection */
 #define NILFS_CF_NODE		0x0001	/* Collecting node blocks */
 #define NILFS_CF_IFILE_STARTED	0x0002	/* IFILE stage has started */
-#define NILFS_CF_HISTORY_MASK	(NILFS_CF_IFILE_STARTED)
+#define NILFS_CF_SUFREED	0x0004	/* segment usages has been freed */
+#define NILFS_CF_HISTORY_MASK	(NILFS_CF_IFILE_STARTED | NILFS_CF_SUFREED)
 
 /* Operations depending on the construction mode and file type */
 struct nilfs_sc_operations {
@@ -810,7 +810,7 @@ static int nilfs_segctor_clean(struct nilfs_sc_info *sci)
 {
 	return list_empty(&sci->sc_dirty_files) &&
 		!test_bit(NILFS_SC_DIRTY, &sci->sc_flags) &&
-		list_empty(&sci->sc_cleaning_segments) &&
+		sci->sc_nfreesegs == 0 &&
 		(!nilfs_doing_gc() || list_empty(&sci->sc_gc_inodes));
 }
 
@@ -1005,44 +1005,6 @@ static void nilfs_drop_collected_inodes(struct list_head *head)
 	}
 }
 
-static void nilfs_segctor_cancel_free_segments(struct nilfs_sc_info *sci,
-					       struct inode *sufile)
-
-{
-	struct list_head *head = &sci->sc_cleaning_segments;
-	struct nilfs_segment_entry *ent;
-	int err;
-
-	list_for_each_entry(ent, head, list) {
-		if (!(ent->flags & NILFS_SLH_FREED))
-			break;
-		err = nilfs_sufile_cancel_free(sufile, ent->segnum);
-		WARN_ON(err); /* do not happen */
-		ent->flags &= ~NILFS_SLH_FREED;
-	}
-}
-
-static int nilfs_segctor_prepare_free_segments(struct nilfs_sc_info *sci,
-					       struct inode *sufile)
-{
-	struct list_head *head = &sci->sc_cleaning_segments;
-	struct nilfs_segment_entry *ent;
-	int err;
-
-	list_for_each_entry(ent, head, list) {
-		err = nilfs_sufile_free(sufile, ent->segnum);
-		if (unlikely(err))
-			return err;
-		ent->flags |= NILFS_SLH_FREED;
-	}
-	return 0;
-}
-
-static void nilfs_segctor_commit_free_segments(struct nilfs_sc_info *sci)
-{
-	nilfs_dispose_segment_list(&sci->sc_cleaning_segments);
-}
-
 static int nilfs_segctor_apply_buffers(struct nilfs_sc_info *sci,
 				       struct inode *inode,
 				       struct list_head *listp,
@@ -1161,6 +1123,7 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct list_head *head;
 	struct nilfs_inode_info *ii;
+	size_t ndone;
 	int err = 0;
 
 	switch (sci->sc_stage.scnt) {
@@ -1250,10 +1213,16 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 			break;
 		sci->sc_stage.scnt++;  /* Fall through */
 	case NILFS_ST_SUFILE:
-		err = nilfs_segctor_prepare_free_segments(sci,
-							  nilfs->ns_sufile);
-		if (unlikely(err))
+		err = nilfs_sufile_freev(nilfs->ns_sufile, sci->sc_freesegs,
+					 sci->sc_nfreesegs, &ndone);
+		if (unlikely(err)) {
+			nilfs_sufile_cancel_freev(nilfs->ns_sufile,
+						  sci->sc_freesegs, ndone,
+						  NULL);
 			break;
+		}
+		sci->sc_stage.flags |= NILFS_CF_SUFREED;
+
 		err = nilfs_segctor_scan_file(sci, nilfs->ns_sufile,
 					      &nilfs_sc_file_ops);
 		if (unlikely(err))
@@ -1486,7 +1455,15 @@ static void nilfs_segctor_end_construction(struct nilfs_sc_info *sci,
 {
 	if (unlikely(err)) {
 		nilfs_segctor_free_incomplete_segments(sci, nilfs);
-		nilfs_segctor_cancel_free_segments(sci, nilfs->ns_sufile);
+		if (sci->sc_stage.flags & NILFS_CF_SUFREED) {
+			int ret;
+
+			ret = nilfs_sufile_cancel_freev(nilfs->ns_sufile,
+							sci->sc_freesegs,
+							sci->sc_nfreesegs,
+							NULL);
+			WARN_ON(ret); /* do not happen */
+		}
 	}
 	nilfs_segctor_clear_segment_buffers(sci);
 }
@@ -1585,7 +1562,13 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 		if (mode != SC_LSEG_SR || sci->sc_stage.scnt < NILFS_ST_CPFILE)
 			break;
 
-		nilfs_segctor_cancel_free_segments(sci, nilfs->ns_sufile);
+		if (sci->sc_stage.flags & NILFS_CF_SUFREED) {
+			err = nilfs_sufile_cancel_freev(nilfs->ns_sufile,
+							sci->sc_freesegs,
+							sci->sc_nfreesegs,
+							NULL);
+			WARN_ON(err); /* do not happen */
+		}
 		nilfs_segctor_clear_segment_buffers(sci);
 
 		err = nilfs_segctor_extend_segments(sci, nilfs, nadd);
@@ -2224,10 +2207,8 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 		nilfs_segctor_complete_write(sci);
 
 		/* Commit segments */
-		if (has_sr) {
-			nilfs_segctor_commit_free_segments(sci);
+		if (has_sr)
 			nilfs_segctor_clear_metadata_dirty(sci);
-		}
 
 		nilfs_segctor_end_construction(sci, nilfs, 0);
 
@@ -2301,48 +2282,6 @@ void nilfs_flush_segment(struct super_block *sb, ino_t ino)
 					/* assign bit 0 to data files */
 }
 
-int nilfs_segctor_add_segments_to_be_freed(struct nilfs_sc_info *sci,
-					   __u64 *segnum, size_t nsegs)
-{
-	struct nilfs_segment_entry *ent;
-	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
-	struct inode *sufile = nilfs->ns_sufile;
-	LIST_HEAD(list);
-	__u64 *pnum;
-	size_t i;
-	int err;
-
-	for (pnum = segnum, i = 0; i < nsegs; pnum++, i++) {
-		ent = nilfs_alloc_segment_entry(*pnum);
-		if (unlikely(!ent)) {
-			err = -ENOMEM;
-			goto failed;
-		}
-		list_add_tail(&ent->list, &list);
-
-		err = nilfs_open_segment_entry(ent, sufile);
-		if (unlikely(err))
-			goto failed;
-
-		if (unlikely(!nilfs_segment_usage_dirty(ent->raw_su)))
-			printk(KERN_WARNING "NILFS: unused segment is "
-			       "requested to be cleaned (segnum=%llu)\n",
-			       (unsigned long long)ent->segnum);
-		nilfs_close_segment_entry(ent, sufile);
-	}
-	list_splice(&list, sci->sc_cleaning_segments.prev);
-	return 0;
-
- failed:
-	nilfs_dispose_segment_list(&list);
-	return err;
-}
-
-void nilfs_segctor_clear_segments_to_be_freed(struct nilfs_sc_info *sci)
-{
-	nilfs_dispose_segment_list(&sci->sc_cleaning_segments);
-}
-
 struct nilfs_segctor_wait_request {
 	wait_queue_t	wq;
 	__u32		seq;
@@ -2607,10 +2546,13 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 	err = nilfs_init_gcdat_inode(nilfs);
 	if (unlikely(err))
 		goto out_unlock;
+
 	err = nilfs_ioctl_prepare_clean_segments(nilfs, argv, kbufs);
 	if (unlikely(err))
 		goto out_unlock;
 
+	sci->sc_freesegs = kbufs[4];
+	sci->sc_nfreesegs = argv[4].v_nmembs;
 	list_splice_init(&nilfs->ns_gc_inodes, sci->sc_gc_inodes.prev);
 
 	for (;;) {
@@ -2629,6 +2571,8 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 	}
 
  out_unlock:
+	sci->sc_freesegs = NULL;
+	sci->sc_nfreesegs = 0;
 	nilfs_clear_gcdat_inode(nilfs);
 	nilfs_transaction_unlock(sbi);
 	return err;
@@ -2835,7 +2779,6 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct nilfs_sb_info *sbi)
 	INIT_LIST_HEAD(&sci->sc_dirty_files);
 	INIT_LIST_HEAD(&sci->sc_segbufs);
 	INIT_LIST_HEAD(&sci->sc_gc_inodes);
-	INIT_LIST_HEAD(&sci->sc_cleaning_segments);
 	INIT_LIST_HEAD(&sci->sc_copied_buffers);
 
 	sci->sc_interval = HZ * NILFS_SC_DEFAULT_TIMEOUT;
@@ -2901,9 +2844,6 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 		nilfs_dispose_list(sbi, &sci->sc_dirty_files, 1);
 	}
 
-	if (!list_empty(&sci->sc_cleaning_segments))
-		nilfs_dispose_segment_list(&sci->sc_cleaning_segments);
-
 	WARN_ON(!list_empty(&sci->sc_segbufs));
 
 	down_write(&sbi->s_nilfs->ns_segctor_sem);
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 476bdd5..f36a851 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -90,8 +90,9 @@ struct nilfs_segsum_pointer {
  * @sc_nblk_inc: Block count of current generation
  * @sc_dirty_files: List of files to be written
  * @sc_gc_inodes: List of GC inodes having blocks to be written
- * @sc_cleaning_segments: List of segments to be freed through construction
  * @sc_copied_buffers: List of copied buffers (buffer heads) to freeze data
+ * @sc_freesegs: array of segment numbers to be freed
+ * @sc_nfreesegs: number of segments on @sc_freesegs
  * @sc_dsync_inode: inode whose data pages are written for a sync operation
  * @sc_dsync_start: start byte offset of data pages
  * @sc_dsync_end: end byte offset of data pages (inclusive)
@@ -131,9 +132,11 @@ struct nilfs_sc_info {
 
 	struct list_head	sc_dirty_files;
 	struct list_head	sc_gc_inodes;
-	struct list_head	sc_cleaning_segments;
 	struct list_head	sc_copied_buffers;
 
+	__u64		       *sc_freesegs;
+	size_t			sc_nfreesegs;
+
 	struct nilfs_inode_info *sc_dsync_inode;
 	loff_t			sc_dsync_start;
 	loff_t			sc_dsync_end;
@@ -225,10 +228,6 @@ extern void nilfs_flush_segment(struct super_block *, ino_t);
 extern int nilfs_clean_segments(struct super_block *, struct nilfs_argv *,
 				void **);
 
-extern int nilfs_segctor_add_segments_to_be_freed(struct nilfs_sc_info *,
-						  __u64 *, size_t);
-extern void nilfs_segctor_clear_segments_to_be_freed(struct nilfs_sc_info *);
-
 extern int nilfs_attach_segment_constructor(struct nilfs_sb_info *);
 extern void nilfs_detach_segment_constructor(struct nilfs_sb_info *);
 
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index e8e2627..fd6232e 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -54,36 +54,16 @@ int nilfs_sufile_update(struct inode *, __u64, int,
 			void (*dofunc)(struct inode *, __u64,
 				       struct buffer_head *,
 				       struct buffer_head *));
-void nilfs_sufile_do_cancel_free(struct inode *, __u64, struct buffer_head *,
-				 struct buffer_head *);
 void nilfs_sufile_do_scrap(struct inode *, __u64, struct buffer_head *,
 			   struct buffer_head *);
 void nilfs_sufile_do_free(struct inode *, __u64, struct buffer_head *,
 			  struct buffer_head *);
+void nilfs_sufile_do_cancel_free(struct inode *, __u64, struct buffer_head *,
+				 struct buffer_head *);
 void nilfs_sufile_do_set_error(struct inode *, __u64, struct buffer_head *,
 			       struct buffer_head *);
 
 /**
- * nilfs_sufile_cancel_free -
- * @sufile: inode of segment usage file
- * @segnum: segment number
- *
- * Description:
- *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- */
-static inline int nilfs_sufile_cancel_free(struct inode *sufile, __u64 segnum)
-{
-	return nilfs_sufile_update(sufile, segnum, 0,
-				   nilfs_sufile_do_cancel_free);
-}
-
-/**
  * nilfs_sufile_scrap - make a segment garbage
  * @sufile: inode of segment usage file
  * @segnum: segment number to be freed
@@ -104,6 +84,38 @@ static inline int nilfs_sufile_free(struct inode *sufile, __u64 segnum)
 }
 
 /**
+ * nilfs_sufile_freev - free segments
+ * @sufile: inode of segment usage file
+ * @segnumv: array of segment numbers
+ * @nsegs: size of @segnumv array
+ * @ndone: place to store the number of freed segments
+ */
+static inline int nilfs_sufile_freev(struct inode *sufile, __u64 *segnumv,
+				     size_t nsegs, size_t *ndone)
+{
+	return nilfs_sufile_updatev(sufile, segnumv, nsegs, 0, ndone,
+				    nilfs_sufile_do_free);
+}
+
+/**
+ * nilfs_sufile_cancel_freev - reallocate freeing segments
+ * @sufile: inode of segment usage file
+ * @segnumv: array of segment numbers
+ * @nsegs: size of @segnumv array
+ * @ndone: place to store the number of cancelled segments
+ *
+ * Return Value: On success, 0 is returned. On error, a negative error codes
+ * is returned.
+ */
+static inline int nilfs_sufile_cancel_freev(struct inode *sufile,
+					    __u64 *segnumv, size_t nsegs,
+					    size_t *ndone)
+{
+	return nilfs_sufile_updatev(sufile, segnumv, nsegs, 0, ndone,
+				    nilfs_sufile_do_cancel_free);
+}
+
+/**
  * nilfs_sufile_set_error - mark a segment as erroneous
  * @sufile: inode of segment usage file
  * @segnum: segment number
-- 
1.6.2
