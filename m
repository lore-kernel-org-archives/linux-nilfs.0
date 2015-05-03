From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 4/5] nilfs-utils: implement the tracking of live blocks for set_suinfo
Date: Sun,  3 May 2015 12:07:06 +0200
Message-ID: <1430647627-18902-4-git-send-email-andreas.rohner@gmx.net>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430647522-14304-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

If the tracking of live blocks is enabled, the information passed to
the kernel with the set_suinfo ioctl must also be modified. To this
end the nilfs_count_nlive_blks() fucntion is introduced. It simply
loops through the vdescv and bdescv vectors and counts the live
blocks belonging to a certain segment. Here the new vdesc flags
introduced earlier come in handy. If NILFS_VDESC_SNAPSHOT_PROTECTED flag
is set, the block is always counted as alive. However if it is not set
and NILFS_VDESC_PERIOD_PROTECTED is set instead it is counted as
reclaimable.

Additionally the nilfs_xreclaim_segment() function is refactored, so
that the set_suinfo part is extracted into its own function
nilfs_try_set_suinfo(). This is useful, because the code gets more
complicated with the new additions.

If the kernel either doesn't support the set_suinfo ioctl or doesn't
support the set_nlive_blks flag, it returns ENOTTY or EINVAL
respectively and the corresponding options are disabled and not used
again.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs.h |   6 ++
 lib/gc.c        | 177 ++++++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 145 insertions(+), 38 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index dbcb76e..5fd01fc 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -328,6 +328,12 @@ static inline __u32 nilfs_get_blocks_per_segment(const struct nilfs *nilfs)
 	return le32_to_cpu(nilfs->n_sb->s_blocks_per_segment);
 }
 
+static inline __u64
+nilfs_get_segnum_of_block(const struct nilfs *nilfs, sector_t blocknr)
+{
+	return blocknr / nilfs_get_blocks_per_segment(nilfs);
+}
+
 static inline int nilfs_feature_track_live_blks(const struct nilfs *nilfs)
 {
 	const __u64 required_bits = NILFS_FEATURE_COMPAT_TRACK_LIVE_BLKS |
diff --git a/lib/gc.c b/lib/gc.c
index a830e45..3e3bb2c 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -619,6 +619,130 @@ static int nilfs_toss_bdescs(struct nilfs_vector *bdescv)
 }
 
 /**
+ * nilfs_count_nlive_blks - returns the number of live blocks in segnum
+ * @nilfs: nilfs object
+ * @segnum: segment number
+ * @bdescv: vector object storing (descriptors of) disk block numbers
+ * @vdescv: vector object storing (descriptors of) virtual block numbers
+ */
+static size_t nilfs_count_nlive_blks(const struct nilfs *nilfs,
+				     __u64 segnum,
+				     struct nilfs_vector *vdescv,
+				     struct nilfs_vector *bdescv,
+				     size_t *pnss)
+{
+	struct nilfs_vdesc *vdesc;
+	struct nilfs_bdesc *bdesc;
+	int i;
+	size_t res = 0, nss = 0;
+
+	for (i = 0; i < nilfs_vector_get_size(bdescv); i++) {
+		bdesc = nilfs_vector_get_element(bdescv, i);
+		assert(bdesc != NULL);
+
+		if (nilfs_get_segnum_of_block(nilfs, bdesc->bd_blocknr) ==
+		    segnum && nilfs_bdesc_is_live(bdesc))
+			++res;
+	}
+
+	for (i = 0; i < nilfs_vector_get_size(vdescv); i++) {
+		vdesc = nilfs_vector_get_element(vdescv, i);
+		assert(vdesc != NULL);
+
+		if (nilfs_get_segnum_of_block(nilfs, vdesc->vd_blocknr) ==
+		    segnum && (nilfs_vdesc_snapshot_protected(vdesc) ||
+		    !nilfs_vdesc_period_protected(vdesc))) {
+			++res;
+			if (nilfs_vdesc_snapshot_protected(vdesc))
+				++nss;
+		}
+	}
+
+	if (pnss)
+		*pnss = nss;
+
+	return res;
+}
+
+/**
+ * nilfs_try_set_suinfo - wrapper for nilfs_set_suinfo
+ * @nilfs: nilfs object
+ * @segnums: array of segment numbers storing selected segments
+ * @nsegs: size of the @segnums array
+ * @vdescv: vector object storing (descriptors of) virtual block numbers
+ * @bdescv: vector object storing (descriptors of) disk block numbers
+ *
+ * Description: nilfs_try_set_suinfo() prepares the input data structure
+ * for nilfs_set_suinfo(). If the kernel doesn't support the
+ * NILFS_IOCTL_SET_SUINFO ioctl, errno is set to ENOTTY and the set_suinfo
+ * option is cleared to prevent future calls to nilfs_try_set_suinfo().
+ * Similarly if the SUFILE extension is not supported by the kernel,
+ * errno is set to EINVAL and the track_live_blks option is disabled.
+ *
+ * Return Value: On success, zero is returned.  On error, a negative value
+ * is returned. If errno is set to ENOTTY or EINVAL, the kernel doesn't support
+ * the current configuration for nilfs_set_suinfo().
+ */
+static int nilfs_try_set_suinfo(struct nilfs *nilfs, __u64 *segnums,
+		size_t nsegs, struct nilfs_vector *vdescv,
+		struct nilfs_vector *bdescv)
+{
+	struct nilfs_vector *supv;
+	struct nilfs_suinfo_update *sup;
+	struct timeval tv;
+	int ret = -1;
+	size_t i, nblocks, nss;
+
+	supv = nilfs_vector_create(sizeof(struct nilfs_suinfo_update));
+	if (!supv)
+		goto out;
+
+	ret = gettimeofday(&tv, NULL);
+	if (ret < 0)
+		goto out;
+
+	for (i = 0; i < nsegs; ++i) {
+		sup = nilfs_vector_get_new_element(supv);
+		if (!sup) {
+			ret = -1;
+			goto out;
+		}
+
+		sup->sup_segnum = segnums[i];
+		sup->sup_flags = 0;
+		nilfs_suinfo_update_set_lastmod(sup);
+		sup->sup_sui.sui_lastmod = tv.tv_sec;
+
+		if (nilfs_opt_test_track_live_blks(nilfs)) {
+			nilfs_suinfo_update_set_nlive_blks(sup);
+			nilfs_suinfo_update_set_nsnapshot_blks(sup);
+
+			nblocks = nilfs_count_nlive_blks(nilfs,
+					segnums[i], vdescv, bdescv, &nss);
+			sup->sup_sui.sui_nlive_blks = nblocks;
+			sup->sup_sui.sui_nsnapshot_blks = nss;
+		}
+	}
+
+	ret = nilfs_set_suinfo(nilfs, nilfs_vector_get_data(supv), nsegs);
+	if (ret < 0) {
+		if (errno == ENOTTY) {
+			nilfs_gc_logger(LOG_WARNING,
+					"set_suinfo ioctl is not supported");
+			nilfs_opt_clear_set_suinfo(nilfs);
+		} else if (errno == EINVAL) {
+			nilfs_gc_logger(LOG_WARNING,
+					"sufile extension is not supported");
+			nilfs_opt_clear_track_live_blks(nilfs);
+		}
+	}
+
+out:
+	nilfs_vector_destroy(supv);
+	return ret;
+}
+
+/**
  * nilfs_xreclaim_segment - reclaim segments (enhanced API)
  * @nilfs: nilfs object
  * @segnums: array of segment numbers storing selected segments
@@ -632,14 +756,12 @@ int nilfs_xreclaim_segment(struct nilfs *nilfs,
 			   const struct nilfs_reclaim_params *params,
 			   struct nilfs_reclaim_stat *stat)
 {
-	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv, *supv;
+	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv;
 	sigset_t sigset, oldset, waitset;
 	nilfs_cno_t protcno;
-	ssize_t n, i, ret = -1;
+	ssize_t n, ret = -1;
 	size_t nblocks;
 	__u32 reclaimable_blocks;
-	struct nilfs_suinfo_update *sup;
-	struct timeval tv;
 
 	if (!(params->flags & NILFS_RECLAIM_PARAM_PROTSEQ) ||
 	    (params->flags & (~0UL << __NR_NILFS_RECLAIM_PARAMS))) {
@@ -658,8 +780,7 @@ int nilfs_xreclaim_segment(struct nilfs *nilfs,
 	bdescv = nilfs_vector_create(sizeof(struct nilfs_bdesc));
 	periodv = nilfs_vector_create(sizeof(struct nilfs_period));
 	vblocknrv = nilfs_vector_create(sizeof(__u64));
-	supv = nilfs_vector_create(sizeof(struct nilfs_suinfo_update));
-	if (!vdescv || !bdescv || !periodv || !vblocknrv || !supv)
+	if (!vdescv || !bdescv || !periodv || !vblocknrv)
 		goto out_vec;
 
 	sigemptyset(&sigset);
@@ -757,46 +878,27 @@ int nilfs_xreclaim_segment(struct nilfs *nilfs,
 	if ((params->flags & NILFS_RECLAIM_PARAM_MIN_RECLAIMABLE_BLKS) &&
 			nilfs_opt_test_set_suinfo(nilfs) &&
 			reclaimable_blocks < params->min_reclaimable_blks * n) {
-		if (stat) {
-			stat->deferred_segs = n;
-			stat->cleaned_segs = 0;
-		}
 
-		ret = gettimeofday(&tv, NULL);
-		if (ret < 0)
+		ret = nilfs_try_set_suinfo(nilfs, segnums, n, vdescv, bdescv);
+		if (ret == 0) {
+			if (stat) {
+				stat->deferred_segs = n;
+				stat->cleaned_segs = 0;
+			}
 			goto out_lock;
-
-		for (i = 0; i < n; ++i) {
-			sup = nilfs_vector_get_new_element(supv);
-			if (!sup)
-				goto out_lock;
-
-			sup->sup_segnum = segnums[i];
-			sup->sup_flags = 0;
-			nilfs_suinfo_update_set_lastmod(sup);
-			sup->sup_sui.sui_lastmod = tv.tv_sec;
 		}
 
-		ret = nilfs_set_suinfo(nilfs, nilfs_vector_get_data(supv), n);
-
-		if (ret == 0)
-			goto out_lock;
-
-		if (ret < 0 && errno != ENOTTY) {
+		if (ret < 0 && errno != ENOTTY && errno != EINVAL) {
 			nilfs_gc_logger(LOG_ERR, "cannot set suinfo: %s",
 					strerror(errno));
 			goto out_lock;
 		}
 
-		/* errno == ENOTTY */
-		nilfs_gc_logger(LOG_WARNING,
-				"set_suinfo ioctl is not supported");
-		nilfs_opt_clear_set_suinfo(nilfs);
-		if (stat) {
-			stat->deferred_segs = 0;
-			stat->cleaned_segs = n;
-		}
-		/* Try nilfs_clean_segments */
+		/*
+		 * errno == ENOTTY || errno == EINVAL
+		 * nilfs_try_set_suinfo() failed because it is not supported
+		 * so try nilfs_clean_segments() instead
+		 */
 	}
 
 	ret = nilfs_clean_segments(nilfs,
@@ -829,7 +931,6 @@ out_vec:
 	nilfs_vector_destroy(bdescv);
 	nilfs_vector_destroy(periodv);
 	nilfs_vector_destroy(vblocknrv);
-	nilfs_vector_destroy(supv);
 	/*
 	 * Flags of valid fields in stat->exflags must be unset.
 	 */
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
