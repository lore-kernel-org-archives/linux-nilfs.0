From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 1/9] nilfs2: refactor nilfs_sufile_updatev()
Date: Tue, 24 Feb 2015 20:01:36 +0100
Message-ID: <1424804504-10914-2-git-send-email-andreas.rohner@gmx.net>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424804504-10914-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch refactors nilfs_sufile_updatev() to take an array of
arbitrary data structures instead of an array of segment numbers as
input parameter. With this  change it is reusable for cases, where
it is necessary to pass extra data to the update function. The only
requirement for the data structures passed as input is, that they
contain the segment number within the structure. By passing the
offset to the segment number as another input parameter,
nilfs_sufile_updatev() can be oblivious to the actual type of the
input structures in the array.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/sufile.c | 79 ++++++++++++++++++++++++++++++++----------------------
 fs/nilfs2/sufile.h | 39 ++++++++++++++-------------
 2 files changed, 68 insertions(+), 50 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 2a869c3..1e8cac6 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -138,14 +138,18 @@ unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile)
 /**
  * nilfs_sufile_updatev - modify multiple segment usages at a time
  * @sufile: inode of segment usage file
- * @segnumv: array of segment numbers
- * @nsegs: size of @segnumv array
+ * @datav: array of segment numbers
+ * @datasz: size of elements in @datav
+ * @segoff: offset to segnum within the elements of @datav
+ * @ndata: size of @datav array
  * @create: creation flag
  * @ndone: place to store number of modified segments on @segnumv
  * @dofunc: primitive operation for the update
  *
  * Description: nilfs_sufile_updatev() repeatedly calls @dofunc
- * against the given array of segments.  The @dofunc is called with
+ * against the given array of data elements. Every data element has
+ * to contain a valid segment number and @segoff should be the offset
+ * to that within the data structure. The @dofunc is called with
  * buffers of a header block and the sufile block in which the target
  * segment usage entry is contained.  If @ndone is given, the number
  * of successfully modified segments from the head is stored in the
@@ -163,50 +167,55 @@ unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile)
  *
  * %-EINVAL - Invalid segment usage number
  */
-int nilfs_sufile_updatev(struct inode *sufile, __u64 *segnumv, size_t nsegs,
-			 int create, size_t *ndone,
-			 void (*dofunc)(struct inode *, __u64,
+int nilfs_sufile_updatev(struct inode *sufile, void *datav, size_t datasz,
+			 size_t segoff, size_t ndata, int create,
+			 size_t *ndone,
+			 void (*dofunc)(struct inode *, void *,
 					struct buffer_head *,
 					struct buffer_head *))
 {
 	struct buffer_head *header_bh, *bh;
 	unsigned long blkoff, prev_blkoff;
 	__u64 *seg;
-	size_t nerr = 0, n = 0;
+	void *data, *dataend = datav + ndata * datasz;
+	size_t n = 0;
 	int ret = 0;
 
-	if (unlikely(nsegs == 0))
+	if (unlikely(ndata == 0))
 		goto out;
 
-	down_write(&NILFS_MDT(sufile)->mi_sem);
-	for (seg = segnumv; seg < segnumv + nsegs; seg++) {
+
+	for (data = datav; data < dataend; data += datasz) {
+		seg = data + segoff;
 		if (unlikely(*seg >= nilfs_sufile_get_nsegments(sufile))) {
 			printk(KERN_WARNING
 			       "%s: invalid segment number: %llu\n", __func__,
 			       (unsigned long long)*seg);
-			nerr++;
+			ret = -EINVAL;
+			goto out;
 		}
 	}
-	if (nerr > 0) {
-		ret = -EINVAL;
-		goto out_sem;
-	}
 
+	down_write(&NILFS_MDT(sufile)->mi_sem);
 	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
 	if (ret < 0)
 		goto out_sem;
 
-	seg = segnumv;
+	data = datav;
+	seg = data + segoff;
 	blkoff = nilfs_sufile_get_blkoff(sufile, *seg);
 	ret = nilfs_mdt_get_block(sufile, blkoff, create, NULL, &bh);
 	if (ret < 0)
 		goto out_header;
 
 	for (;;) {
-		dofunc(sufile, *seg, header_bh, bh);
+		dofunc(sufile, data, header_bh, bh);
 
-		if (++seg >= segnumv + nsegs)
+		++n;
+		data += datasz;
+		if (data >= dataend)
 			break;
+		seg = data + segoff;
 		prev_blkoff = blkoff;
 		blkoff = nilfs_sufile_get_blkoff(sufile, *seg);
 		if (blkoff == prev_blkoff)
@@ -220,28 +229,30 @@ int nilfs_sufile_updatev(struct inode *sufile, __u64 *segnumv, size_t nsegs,
 	}
 	brelse(bh);
 
- out_header:
-	n = seg - segnumv;
+out_header:
 	brelse(header_bh);
- out_sem:
+out_sem:
 	up_write(&NILFS_MDT(sufile)->mi_sem);
- out:
+out:
 	if (ndone)
 		*ndone = n;
 	return ret;
 }
 
-int nilfs_sufile_update(struct inode *sufile, __u64 segnum, int create,
-			void (*dofunc)(struct inode *, __u64,
+int nilfs_sufile_update(struct inode *sufile, void *data, size_t segoff,
+			int create,
+			void (*dofunc)(struct inode *, void *,
 				       struct buffer_head *,
 				       struct buffer_head *))
 {
 	struct buffer_head *header_bh, *bh;
+	__u64 *seg;
 	int ret;
 
-	if (unlikely(segnum >= nilfs_sufile_get_nsegments(sufile))) {
+	seg = data + segoff;
+	if (unlikely(*seg >= nilfs_sufile_get_nsegments(sufile))) {
 		printk(KERN_WARNING "%s: invalid segment number: %llu\n",
-		       __func__, (unsigned long long)segnum);
+		       __func__, (unsigned long long)*seg);
 		return -EINVAL;
 	}
 	down_write(&NILFS_MDT(sufile)->mi_sem);
@@ -250,9 +261,9 @@ int nilfs_sufile_update(struct inode *sufile, __u64 segnum, int create,
 	if (ret < 0)
 		goto out_sem;
 
-	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, create, &bh);
+	ret = nilfs_sufile_get_segment_usage_block(sufile, *seg, create, &bh);
 	if (!ret) {
-		dofunc(sufile, segnum, header_bh, bh);
+		dofunc(sufile, data, header_bh, bh);
 		brelse(bh);
 	}
 	brelse(header_bh);
@@ -406,12 +417,13 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 	return ret;
 }
 
-void nilfs_sufile_do_cancel_free(struct inode *sufile, __u64 segnum,
+void nilfs_sufile_do_cancel_free(struct inode *sufile, __u64 *data,
 				 struct buffer_head *header_bh,
 				 struct buffer_head *su_bh)
 {
 	struct nilfs_segment_usage *su;
 	void *kaddr;
+	__u64 segnum = *data;
 
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
@@ -431,13 +443,14 @@ void nilfs_sufile_do_cancel_free(struct inode *sufile, __u64 segnum,
 	nilfs_mdt_mark_dirty(sufile);
 }
 
-void nilfs_sufile_do_scrap(struct inode *sufile, __u64 segnum,
+void nilfs_sufile_do_scrap(struct inode *sufile, __u64 *data,
 			   struct buffer_head *header_bh,
 			   struct buffer_head *su_bh)
 {
 	struct nilfs_segment_usage *su;
 	void *kaddr;
 	int clean, dirty;
+	__u64 segnum = *data;
 
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
@@ -462,13 +475,14 @@ void nilfs_sufile_do_scrap(struct inode *sufile, __u64 segnum,
 	nilfs_mdt_mark_dirty(sufile);
 }
 
-void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
+void nilfs_sufile_do_free(struct inode *sufile, __u64 *data,
 			  struct buffer_head *header_bh,
 			  struct buffer_head *su_bh)
 {
 	struct nilfs_segment_usage *su;
 	void *kaddr;
 	int sudirty;
+	__u64 segnum = *data;
 
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
@@ -596,13 +610,14 @@ int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 	return ret;
 }
 
-void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
+void nilfs_sufile_do_set_error(struct inode *sufile, __u64 *data,
 			       struct buffer_head *header_bh,
 			       struct buffer_head *su_bh)
 {
 	struct nilfs_segment_usage *su;
 	void *kaddr;
 	int suclean;
+	__u64 segnum = *data;
 
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index b8afd72..2df6c71 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -46,21 +46,21 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
 				size_t);
 ssize_t nilfs_sufile_set_suinfo(struct inode *, void *, unsigned , size_t);
 
-int nilfs_sufile_updatev(struct inode *, __u64 *, size_t, int, size_t *,
-			 void (*dofunc)(struct inode *, __u64,
-					struct buffer_head *,
-					struct buffer_head *));
-int nilfs_sufile_update(struct inode *, __u64, int,
-			void (*dofunc)(struct inode *, __u64,
+int nilfs_sufile_updatev(struct inode *, void *, size_t, size_t, size_t, int,
+			 size_t *, void (*dofunc)(struct inode *, void *,
+						  struct buffer_head *,
+						  struct buffer_head *));
+int nilfs_sufile_update(struct inode *, void *, size_t, int,
+			void (*dofunc)(struct inode *, void *,
 				       struct buffer_head *,
 				       struct buffer_head *));
-void nilfs_sufile_do_scrap(struct inode *, __u64, struct buffer_head *,
+void nilfs_sufile_do_scrap(struct inode *, __u64 *, struct buffer_head *,
 			   struct buffer_head *);
-void nilfs_sufile_do_free(struct inode *, __u64, struct buffer_head *,
+void nilfs_sufile_do_free(struct inode *, __u64 *, struct buffer_head *,
 			  struct buffer_head *);
-void nilfs_sufile_do_cancel_free(struct inode *, __u64, struct buffer_head *,
+void nilfs_sufile_do_cancel_free(struct inode *, __u64 *, struct buffer_head *,
 				 struct buffer_head *);
-void nilfs_sufile_do_set_error(struct inode *, __u64, struct buffer_head *,
+void nilfs_sufile_do_set_error(struct inode *, __u64 *, struct buffer_head *,
 			       struct buffer_head *);
 
 int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs);
@@ -75,7 +75,8 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range);
  */
 static inline int nilfs_sufile_scrap(struct inode *sufile, __u64 segnum)
 {
-	return nilfs_sufile_update(sufile, segnum, 1, nilfs_sufile_do_scrap);
+	return nilfs_sufile_update(sufile, &segnum, 0, 1,
+				   (void *)nilfs_sufile_do_scrap);
 }
 
 /**
@@ -85,7 +86,8 @@ static inline int nilfs_sufile_scrap(struct inode *sufile, __u64 segnum)
  */
 static inline int nilfs_sufile_free(struct inode *sufile, __u64 segnum)
 {
-	return nilfs_sufile_update(sufile, segnum, 0, nilfs_sufile_do_free);
+	return nilfs_sufile_update(sufile, &segnum, 0, 0,
+				   (void *)nilfs_sufile_do_free);
 }
 
 /**
@@ -98,8 +100,8 @@ static inline int nilfs_sufile_free(struct inode *sufile, __u64 segnum)
 static inline int nilfs_sufile_freev(struct inode *sufile, __u64 *segnumv,
 				     size_t nsegs, size_t *ndone)
 {
-	return nilfs_sufile_updatev(sufile, segnumv, nsegs, 0, ndone,
-				    nilfs_sufile_do_free);
+	return nilfs_sufile_updatev(sufile, segnumv, sizeof(__u64), 0, nsegs,
+				    0, ndone, (void *)nilfs_sufile_do_free);
 }
 
 /**
@@ -116,8 +118,9 @@ static inline int nilfs_sufile_cancel_freev(struct inode *sufile,
 					    __u64 *segnumv, size_t nsegs,
 					    size_t *ndone)
 {
-	return nilfs_sufile_updatev(sufile, segnumv, nsegs, 0, ndone,
-				    nilfs_sufile_do_cancel_free);
+	return nilfs_sufile_updatev(sufile, segnumv, sizeof(__u64), 0, nsegs,
+				    0, ndone,
+				    (void *)nilfs_sufile_do_cancel_free);
 }
 
 /**
@@ -139,8 +142,8 @@ static inline int nilfs_sufile_cancel_freev(struct inode *sufile,
  */
 static inline int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
 {
-	return nilfs_sufile_update(sufile, segnum, 0,
-				   nilfs_sufile_do_set_error);
+	return nilfs_sufile_update(sufile, &segnum, 0, 0,
+				   (void *)nilfs_sufile_do_set_error);
 }
 
 #endif	/* _NILFS_SUFILE_H */
-- 
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
