From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/6] nilfs2: hide nilfs_write_info struct in
	segment buffer code
Date: Mon, 30 Nov 2009 22:30:43 +0900
Message-ID: <1259587845-3436-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1259587845-3436-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1259587845-3436-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

Hides nilfs_write_info struct and nilfs_segbuf_prepare_write function
in segbuf.c to simplify the interface of nilfs_segbuf_write function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c  |   62 ++++++++++++++++++++++++++++++++++++--------------
 fs/nilfs2/segbuf.h  |   24 +------------------
 fs/nilfs2/segment.c |   12 ++-------
 3 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index d86056c..636590c 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -24,10 +24,22 @@
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/crc32.h>
+#include <linux/backing-dev.h>
 #include "page.h"
 #include "segbuf.h"
 
 
+struct nilfs_write_info {
+	struct the_nilfs       *nilfs;
+	struct bio	       *bio;
+	int 			start, end; /* The region to be submitted */
+	int			rest_blocks;
+	int			max_pages;
+	int			nr_vecs;
+	sector_t		blocknr;
+};
+
+
 static struct kmem_cache *nilfs_segbuf_cachep;
 
 static void nilfs_segbuf_init_once(void *obj)
@@ -271,7 +283,7 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 	struct bio *bio = wi->bio;
 	int err;
 
-	if (segbuf->sb_nbio > 0 && bdi_write_congested(wi->bdi)) {
+	if (segbuf->sb_nbio > 0 && bdi_write_congested(wi->nilfs->ns_bdi)) {
 		wait_for_completion(&segbuf->sb_bio_event);
 		segbuf->sb_nbio--;
 		if (unlikely(atomic_read(&segbuf->sb_err))) {
@@ -305,17 +317,15 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 }
 
 /**
- * nilfs_alloc_seg_bio - allocate a bio for writing segment.
- * @sb: super block
- * @start: beginning disk block number of this BIO.
+ * nilfs_alloc_seg_bio - allocate a new bio for writing log
+ * @nilfs: nilfs object
+ * @start: start block number of the bio
  * @nr_vecs: request size of page vector.
  *
- * alloc_seg_bio() allocates a new BIO structure and initialize it.
- *
  * Return Value: On success, pointer to the struct bio is returned.
  * On error, NULL is returned.
  */
-static struct bio *nilfs_alloc_seg_bio(struct super_block *sb, sector_t start,
+static struct bio *nilfs_alloc_seg_bio(struct the_nilfs *nilfs, sector_t start,
 				       int nr_vecs)
 {
 	struct bio *bio;
@@ -326,18 +336,18 @@ static struct bio *nilfs_alloc_seg_bio(struct super_block *sb, sector_t start,
 			bio = bio_alloc(GFP_NOIO, nr_vecs);
 	}
 	if (likely(bio)) {
-		bio->bi_bdev = sb->s_bdev;
-		bio->bi_sector = (sector_t)start << (sb->s_blocksize_bits - 9);
+		bio->bi_bdev = nilfs->ns_bdev;
+		bio->bi_sector = start << (nilfs->ns_blocksize_bits - 9);
 	}
 	return bio;
 }
 
-void nilfs_segbuf_prepare_write(struct nilfs_segment_buffer *segbuf,
-				struct nilfs_write_info *wi)
+static void nilfs_segbuf_prepare_write(struct nilfs_segment_buffer *segbuf,
+				       struct nilfs_write_info *wi)
 {
 	wi->bio = NULL;
 	wi->rest_blocks = segbuf->sb_sum.nblocks;
-	wi->max_pages = bio_get_nr_vecs(wi->sb->s_bdev);
+	wi->max_pages = bio_get_nr_vecs(wi->nilfs->ns_bdev);
 	wi->nr_vecs = min(wi->max_pages, wi->rest_blocks);
 	wi->start = wi->end = 0;
 	wi->blocknr = segbuf->sb_pseg_start;
@@ -352,7 +362,7 @@ static int nilfs_segbuf_submit_bh(struct nilfs_segment_buffer *segbuf,
 	BUG_ON(wi->nr_vecs <= 0);
  repeat:
 	if (!wi->bio) {
-		wi->bio = nilfs_alloc_seg_bio(wi->sb, wi->blocknr + wi->end,
+		wi->bio = nilfs_alloc_seg_bio(wi->nilfs, wi->blocknr + wi->end,
 					      wi->nr_vecs);
 		if (unlikely(!wi->bio))
 			return -ENOMEM;
@@ -371,31 +381,47 @@ static int nilfs_segbuf_submit_bh(struct nilfs_segment_buffer *segbuf,
 	return err;
 }
 
+/**
+ * nilfs_segbuf_write - submit write requests of a log
+ * @segbuf: buffer storing a log to be written
+ * @nilfs: nilfs object
+ *
+ * Return Value: On Success, 0 is returned. On Error, one of the following
+ * negative error code is returned.
+ *
+ * %-EIO - I/O error
+ *
+ * %-ENOMEM - Insufficient memory available.
+ */
 int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
-		       struct nilfs_write_info *wi)
+		       struct the_nilfs *nilfs)
 {
+	struct nilfs_write_info wi;
 	struct buffer_head *bh;
 	int res = 0, rw = WRITE;
 
+	wi.nilfs = nilfs;
+	nilfs_segbuf_prepare_write(segbuf, &wi);
+
 	list_for_each_entry(bh, &segbuf->sb_segsum_buffers, b_assoc_buffers) {
-		res = nilfs_segbuf_submit_bh(segbuf, wi, bh, rw);
+		res = nilfs_segbuf_submit_bh(segbuf, &wi, bh, rw);
 		if (unlikely(res))
 			goto failed_bio;
 	}
 
 	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
-		res = nilfs_segbuf_submit_bh(segbuf, wi, bh, rw);
+		res = nilfs_segbuf_submit_bh(segbuf, &wi, bh, rw);
 		if (unlikely(res))
 			goto failed_bio;
 	}
 
-	if (wi->bio) {
+	if (wi.bio) {
 		/*
 		 * Last BIO is always sent through the following
 		 * submission.
 		 */
 		rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
-		res = nilfs_segbuf_submit_bio(segbuf, wi, rw);
+		res = nilfs_segbuf_submit_bio(segbuf, &wi, rw);
 	}
 
  failed_bio:
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index bd076cc..241a00d 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -27,7 +27,6 @@
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
 #include <linux/completion.h>
-#include <linux/backing-dev.h>
 
 /**
  * struct nilfs_segsum_info - On-memory segment summary
@@ -173,27 +172,8 @@ static inline void nilfs_segbuf_clear(struct nilfs_segment_buffer *segbuf)
 	nilfs_release_buffers(&segbuf->sb_payload_buffers);
 }
 
-struct nilfs_write_info {
-	struct bio	       *bio;
-	int 			start, end; /* The region to be submitted */
-	int			rest_blocks;
-	int			max_pages;
-	int			nr_vecs;
-	sector_t		blocknr;
-
-	/*
-	 * The following fields must be set explicitly
-	 */
-	struct super_block     *sb;
-	struct backing_dev_info *bdi; /* backing dev info */
-	struct buffer_head     *bh_sr;
-};
-
-
-void nilfs_segbuf_prepare_write(struct nilfs_segment_buffer *,
-				struct nilfs_write_info *);
-int nilfs_segbuf_write(struct nilfs_segment_buffer *,
-		       struct nilfs_write_info *);
+int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
+		       struct the_nilfs *nilfs);
 int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf);
 
 #endif /* _NILFS_SEGBUF_H */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index cb004eb..4422cda 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1784,19 +1784,13 @@ static int nilfs_segctor_prepare_write(struct nilfs_sc_info *sci,
 }
 
 static int nilfs_segctor_write(struct nilfs_sc_info *sci,
-			       struct backing_dev_info *bdi)
+			       struct the_nilfs *nilfs)
 {
 	struct nilfs_segment_buffer *segbuf;
-	struct nilfs_write_info wi;
 	int err, res;
 
-	wi.sb = sci->sc_super;
-	wi.bh_sr = sci->sc_super_root;
-	wi.bdi = bdi;
-
 	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
-		nilfs_segbuf_prepare_write(segbuf, &wi);
-		err = nilfs_segbuf_write(segbuf, &wi);
+		err = nilfs_segbuf_write(segbuf, nilfs);
 
 		res = nilfs_segbuf_wait(segbuf);
 		err = err ? : res;
@@ -2170,7 +2164,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 
 		nilfs_segctor_fill_in_checksums(sci, nilfs->ns_crc_seed);
 
-		err = nilfs_segctor_write(sci, nilfs->ns_bdi);
+		err = nilfs_segctor_write(sci, nilfs);
 		if (unlikely(err))
 			goto failed_to_write;
 
-- 
1.6.3.4
